unit udm;

interface

uses
System.SysUtils, System.Classes, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, System.IOUtils, FMX.Dialogs,
  Datasnap.DBClient, FireDAC.Comp.UI;

type
  TBoolArray = Array of Boolean;
  TDM = class(TDataModule)
    fdConn: TFDConnection;
    fdUsuario: TFDQuery;
    FDQuery1: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure fdConnAfterConnect(Sender: TObject);
  private
    { Private declarations }

  public
    StatusThreads:TBoolArray;
    function verificaTermThreads:boolean;
    function checaConexao : Boolean;
    procedure populaPromocao(retorno : String);
    procedure populaProduto(retorno : String);
    procedure populaEmpresa(retorno : String);

    { Public declarations }
  end;

var
  DM: TDM;

implementation

uses
  uController, REST.Json, uPrincipal, System.JSON;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDM }

function TDM.checaConexao: Boolean;
var
  IdTCPCliente : TIdTcpClient;
begin
  result:=false;
  try
    IdTCPCliente := TIdTcpClient.Create(nil);
    try
      IdTCPCliente.ReadTimeout:=5000;
      IdTCPCliente.ConnectTimeout:=2000;
      IdTCPCliente.Port:= 80;
      IdTCPCliente.Host:='www.google.com';
      IdTCPCliente.Connect;
      IdTCPCliente.Disconnect;
      result:=true;
    except
      result:=false;
    end;
  finally
    FreeAndNil(IdTCPCliente);
  end;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  with fdConn do
    begin
      {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
        Params.Values['DriverID'] := 'SQLite';

        try
          Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'DB.db');
          Connected := True;
        except
          on E: Exception do
            begin
              raise
                Exception.Create('Erro de conexão com o banco de dados!');
            end;
        end;
      {$ENDIF}

      {$IFDEF MSWINDOWS}
        try
          Params.Values['Database'] := ExtractFileDir(GetCurrentDir)+'DB.db';
          Connected := True;
        except
          on E: Exception do
            begin
              raise
                Exception.Create('Erro de conexão com o banco de dados!' + #13 + e.Message);
            end;
        end;
      {$ENDIF}
    end;
end;

procedure TDM.fdConnAfterConnect(Sender: TObject);
begin
  FDConn.ExecSQL(
    'CREATE TABLE IF NOT EXISTS USUARIO ('+
    '    ID              INTEGER      PRIMARY KEY AUTOINCREMENT'+
    '                                 UNIQUE,'+
    '    NOME       STRING (100),'+
    '    SENHA      STRING (50),'+
    '    EMAIL      STRING (50),'+
    '    TOKEN      STRING (50)'+
    ');'
  );
end;

procedure TDM.populaEmpresa(retorno: String);
var
  jsRetorno : TJSONValue;
  Thread :TThread;
  Item : TEmpresa;
begin
  jsRetorno := TJSONObject.ParseJSONValue(retorno);

  try
    if TJSONArray(jsRetorno).Count <> 0 then
      begin
        with dm do
          begin
            fprincipal.cdsEmpresa.Active := true;
            fprincipal.cdsEmpresa.EmptyDataSet;
            fprincipal.cdsEmpresa.DisableControls;

            Thread :=  TThread.CreateAnonymousThread(
              procedure
                var
                  i:integer;
                begin
                  for i := 0 to Pred(TJSONArray(jsRetorno).Count) do
                    begin
                      Item := TEmpresa.Create;
                      try
                        item := TJson.JSONToObject<TEmpresa>(TJSONObject((TJSONArray(jsRetorno)).Items[i]));
                        if fprincipal.cdsEmpresa.Locate('id', Item.id, []) then
                          fprincipal.cdsEmpresa.Edit
                        else
                           begin
                            fprincipal.cdsEmpresa.Insert;
                            fprincipal.cdsEmpresaid.Value := Item.id;
                            fprincipal.cdsEmpresaNome.Value := Item.nome;
                            fprincipal.cdsEmpresaendereco.Value := Item.endereco;
                            fprincipal.cdsEmpresatelefone.Value := Item.telefone;
                            fprincipal.cdsEmpresaemail.Value := Item.email;
                           end;

                        fprincipal.cdsEmpresa.Post;
                      finally
                        Item.Free;
                      end;
                    end;
                    fprincipal.cdsEmpresa.EnableControls;
                    StatusThreads[0]:= True;
                    if verificaTermThreads then
                      fprincipal.baixaPromocao;
                end);
            Thread.FreeOnTerminate := True;
            Thread.Start;
          end
      end;

  except on E: Exception do
    fprincipal.baixaEmpresa;
  end;
end;

procedure TDM.populaProduto(retorno: String);
var
  jsRetorno : TJSONValue;
  Thread :TThread;
  Item : TProduto;
begin
  jsRetorno := TJSONObject.ParseJSONValue(retorno);

  try
    if TJSONArray(jsRetorno).Count <> 0 then
      begin
        with dm do
          begin
            fprincipal.cdsProduto.Active := true;
            fprincipal.cdsProduto.EmptyDataSet;
            fprincipal.cdsProduto.DisableControls;

            Thread :=  TThread.CreateAnonymousThread(
              procedure
                var
                  i:integer;
                begin
                  for i := 0 to Pred(TJSONArray(jsRetorno).Count) do
                    begin
                      Item := TProduto.Create;
                      try
                        item := TJson.JSONToObject<TProduto>(TJSONObject((TJSONArray(jsRetorno)).Items[i]));
                        if fprincipal.cdsProduto.Locate('id', Item.id, []) then
                          fprincipal.cdsProduto.Edit
                        else
                           begin
                              fprincipal.cdsProduto.Insert;
                              fprincipal.cdsProdutoid.value := Item.id;
                              fprincipal.cdsProdutoNome.Value := Item.nome;
                              fprincipal.cdsProdutovalor.Value := Item.valor;
                              fprincipal.cdsProdutocod_empresa.Value := Item.idEmpresa;
                              fprincipal.cdsProdutocod_categoria.Value := Item.idCategoria;
                           end;

                        fprincipal.cdsProduto.Post;
                      finally
                        Item.Free;
                      end;
                    end;
                    fprincipal.cdsProduto.EnableControls;
                    StatusThreads[1]:= True;
                    if verificaTermThreads then
                      fprincipal.baixaPromocao;
                end);
            Thread.FreeOnTerminate := True;
            Thread.Start;
          end
      end;

  except on E: Exception do
    fprincipal.baixaEmpresa;
  end;
end;

procedure TDM.populaPromocao(retorno : String);
var
  jsRetorno : TJSONValue;
  Thread :TThread;
  Item : TPromocoes;
begin
  jsRetorno := TJSONObject.ParseJSONValue(retorno);

  try
    if TJSONArray(jsRetorno).Count <> 0 then
      begin
        with dm do
          begin
            fprincipal.cdsPromocoes.Active := true;
            fprincipal.cdsPromocoes.EmptyDataSet;
            fprincipal.cdsPromocoes.DisableControls;

            Thread :=  TThread.CreateAnonymousThread(
              procedure
                var
                  i:integer;
                begin
                  for i := 0 to Pred(TJSONArray(jsRetorno).Count) do
                    begin
                      Item := TPromocoes.Create;
                      try
                        item := TJson.JSONToObject<TPromocoes>(TJSONObject((TJSONArray(jsRetorno)).Items[i]));
                        if fprincipal.cdsPromocoes.Locate('Indice', Item.id, []) then
                          fprincipal.cdsPromocoes.Edit
                        else
                           begin
                            fprincipal.cdsPromocoes.Insert;
                            fprincipal.cdsPromocoesIndice.Value := Item.id;
                            fprincipal.cdsPromocoestexto.Value := Item.texto;
                            fprincipal.cdsPromocoesdesconto.Value := Item.desconto;
                            fprincipal.cdsPromocoesdesc_pagamento.Value := Item.desc_pagamento;
                            fprincipal.cdsPromocoesrelevancia.Value := Item.relevancia;
                            fprincipal.cdsPromocoesidproduto.Value := Item.idproduto;
                            fprincipal.cdsPromocoesidEmpresa.Value := Item.idEmpresa;
                            fprincipal.cdsPromocoesdataInicial.Value := Item.dataInicial;
                            fprincipal.cdsPromocoesdataFinal.Value := Item.dataFinal;

                            fprincipal.cdsEmpresa.Locate('id',fprincipal.cdsPromocoesidEmpresa.Value, []);
                            fprincipal.cdsPromocoesfNomeEmpresa.Value := fprincipal.cdsEmpresanome.Value;
                            fprincipal.cdsProduto.Locate('id',fprincipal.cdsPromocoesidproduto.Value,[]);
                            fprincipal.cdsPromocoesfNomeProduto.Value := fprincipal.cdsProdutonome.Value;
                            fprincipal.cdsPromocoesfPrecoProduto.Value := fprincipal.cdsProdutovalor.Value;
                           end;


                        fprincipal.cdsPromocoes.Post;
                      finally
                        Item.Free;
                      end;
                      fprincipal.preencheListView;
                      fprincipal.AnimaCarrega.Enabled := False;
                      fprincipal.AnimaCarrega.Visible := False;
                    end;
                    fprincipal.cdsPromocoes.EnableControls;
                end);
            Thread.FreeOnTerminate := True;
            Thread.Start;
          end

      end
    else
      begin
        //ShowMessage('Nenhum Registro encontrado');
        fprincipal.AnimaCarrega.Enabled := False;
        fprincipal.AnimaCarrega.Visible := False;
      end;
  except on E: Exception do
    fprincipal.baixaPromocao;
  end;
end;

function TDM.verificaTermThreads: boolean;
var
  i, cont:integer;
begin
  Result := True;
  for I := 0 to pred(Length(StatusThreads)) do
    begin
      if not (StatusThreads[i]) then
        begin
          Result := False;
          Exit;
        end;
    end;
end;

end.
