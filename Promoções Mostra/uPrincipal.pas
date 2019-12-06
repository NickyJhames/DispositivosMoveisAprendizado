unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Effects, FMX.Objects, FMX.Layouts, FMX.ScrollBox, FMX.Memo,
  FMX.Controls.Presentation, FMX.StdCtrls,Soap.EncdDecd, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, Data.DB,
  Datasnap.DBClient, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  System.Actions, FMX.ActnList, System.JSON, Data.Bind.GenData,
  Data.Bind.ObjectScope, System.ImageList, FMX.ImgList

    {$IFDEF ANDROID}
     ,Androidapi.JNI.JavaTypes,
     Androidapi.JNI.GraphicsContentViewText,
     FMX.Helpers.Android,
     Androidapi.Helpers,
     Androidapi.NativeActivity,
     Androidapi.JNIBridge,
     IdURI,
     Androidapi.Jni.Net,
     FMX.Platform.Android
  {$ENDIF}

  ;

type
  TFPrincipal = class(TForm)
    TabControl1: TTabControl;
    tbFavoritos: TTabItem;
    tbPerfil: TTabItem;
    tbAlta: TTabItem;
    layout_abas: TLayout;
    layout_aba_home: TLayout;
    btHot: TImage;
    Layout2: TLayout;
    btFavoritos: TImage;
    Layout3: TLayout;
    btPerfil: TImage;
    Rectangle1: TRectangle;
    ToolBar1: TToolBar;
    ShadowEffect1: TShadowEffect;
    btPesquisa: TImage;
    lvAlta: TListView;
    Layout4: TLayout;
    Label2: TLabel;
    AnimaCarrega: TAniIndicator;
    ToolBar2: TToolBar;
    Label1: TLabel;
    ShadowEffect2: TShadowEffect;
    Layout1: TLayout;
    Image2: TImage;
    ToolBar3: TToolBar;
    Label3: TLabel;
    ShadowEffect3: TShadowEffect;
    ltPerfil: TLayout;
    Layout5: TLayout;
    Rectangle2: TRectangle;
    lbNome: TLabel;
    Layout6: TLayout;
    Rectangle3: TRectangle;
    Label4: TLabel;
    Layout7: TLayout;
    Rectangle4: TRectangle;
    Label5: TLabel;
    ShadowEffect4: TShadowEffect;
    ShadowEffect5: TShadowEffect;
    ShadowEffect6: TShadowEffect;
    ImageControl1: TImageControl;
    ActionList1: TActionList;
    ChangeTabAlta: TChangeTabAction;
    ChangeTabFavoritos: TChangeTabAction;
    ChangeTabPerfil: TChangeTabAction;
    dsCategoria: TDataSource;
    dsEmpresa: TDataSource;
    dsProduto: TDataSource;
    dsPromocoes: TDataSource;
    BindingsList1: TBindingsList;
    imgBotoes: TImageList;
    ImageList2: TImageList;
    ListView4: TListView;
    ShadowEffect7: TShadowEffect;
    cdsProduto: TClientDataSet;
    cdsProdutonome: TStringField;
    cdsProdutovalor: TFloatField;
    cdsProdutocod_empresa: TIntegerField;
    cdsProdutocod_categoria: TIntegerField;
    cdsProdutoimg: TStringField;
    cdsProdutoid: TIntegerField;
    cdsEmpresa: TClientDataSet;
    cdsEmpresanome: TStringField;
    cdsEmpresaendereco: TStringField;
    cdsEmpresatelefone: TStringField;
    cdsEmpresaemail: TStringField;
    cdsEmpresaimg: TStringField;
    cdsEmpresaid: TIntegerField;
    cdsCategoria: TClientDataSet;
    cdsCategoriatipo: TStringField;
    cdsPromocoes: TClientDataSet;
    cdsPromocoesindice: TIntegerField;
    cdsPromocoesdesconto: TFloatField;
    cdsPromocoesdesc_pagamento: TIntegerField;
    cdsPromocoesrelevancia: TFloatField;
    cdsPromocoesidproduto: TIntegerField;
    cdsPromocoesidEmpresa: TIntegerField;
    cdsPromocoesdataInicial: TDateField;
    cdsPromocoesdataFinal: TDateField;
    cdsPromocoestexto: TStringField;
    cdsPromocoesfNomeProduto: TStringField;
    cdsPromocoesfNomeEmpresa: TStringField;
    cdsPromocoesfPrecoProduto: TFloatField;
    cdsPromocoesintContato: TSingleField;
    cdsPromocoesintFavorito: TSingleField;
    cdsPromocoesintProduto: TIntegerField;
    cdsPromocoesintFavoritoMarcado: TSingleField;
    procedure FormCreate(Sender: TObject);
    procedure btPesquisaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure btHotClick(Sender: TObject);
    procedure btFavoritosClick(Sender: TObject);
    procedure btPerfilClick(Sender: TObject);
    procedure lvAltaPullRefresh(Sender: TObject);
    procedure lvAltaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    function BitmapFromBase64(const base64: string): TBitmap;
    procedure colocaImagens;
    { Private declarations }
  public
    Sincro:Boolean;
    procedure baixaPromocao;
    procedure baixaEmpresa;
    procedure baixaProduto;
    procedure preencheListView;
    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;

implementation

uses
  uController, udm, REST.Json,Math;

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.iPhone47in.fmx IOS}

procedure TFPrincipal.baixaEmpresa;
var
  Thread: TThread;
  retorno:String;
begin
  AnimaCarrega.Enabled := true;
  AnimaCarrega.Visible := true;
  AnimaCarrega.BringToFront;

  Thread :=  TThread.CreateAnonymousThread(
    procedure
      begin
        retorno := GetHTTP('rest/view_empresa');
        if retorno = 'Erro!' then
          begin
            baixaEmpresa;
            exit;
          end;
        dm.populaEmpresa(retorno);
      end
  );

  Thread.FreeOnTerminate := True;
  Thread.Start;
end;

procedure TFPrincipal.baixaProduto;
var
  Thread: TThread;
  retorno:String;
begin
  AnimaCarrega.Enabled := true;
  AnimaCarrega.Visible := true;
  AnimaCarrega.BringToFront;

  Thread :=  TThread.CreateAnonymousThread(
    procedure
      begin
        retorno := GetHTTP('rest/view_produto');
        if retorno = 'Erro!' then
          begin
            baixaProduto;
            exit;
          end;
        dm.populaProduto(retorno);
      end
  );

  Thread.FreeOnTerminate := True;
  Thread.Start;
end;

procedure TFPrincipal.baixaPromocao;
var
  Thread: TThread;
  retorno:String;
begin
  AnimaCarrega.Enabled := true;
  AnimaCarrega.Visible := true;
  AnimaCarrega.BringToFront;

  Thread :=  TThread.CreateAnonymousThread(
    procedure
      begin
        retorno := GetHTTP('rest/view_promocoes');
        if retorno = 'Erro!' then
          begin
            baixaPromocao;
            exit;
          end;
        dm.populaPromocao(retorno);
      end
  );

  Thread.FreeOnTerminate := True;
  Thread.Start;
end;

function TFPrincipal.BitmapFromBase64(const base64: string): TBitmap;
var
        Input: TStringStream;
        Output: TBytesStream;
begin
        Input := TStringStream.Create(base64, TEncoding.ASCII);
        try
                Output := TBytesStream.Create;
                try
                        Soap.EncdDecd.DecodeStream(Input, Output);
                        Output.Position := 0;
                        Result := TBitmap.Create;
                        try
                                Result.LoadFromStream(Output);
                        except
                                Result.Free;
                                raise;
                        end;
                finally
                        Output.Free;
                end;
        finally
                Input.Free;
        end;
end;

procedure TFPrincipal.btHotClick(Sender: TObject);
begin
  ExecuteAction(ChangeTabAlta);
end;

procedure TFPrincipal.btPerfilClick(Sender: TObject);
begin
    ExecuteAction(ChangeTabPerfil);
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
var
  Retorno : string;
begin
  // Pega Token
  dm.fdUsuario.Active := True;
  TOKEN := dm.fdUsuario.FieldByName('TOKEN').Value;
  lbNome.Text := dm.fdUsuario.FieldByName('NOME').Value;
  dm.fdUsuario.Active := False;
end;

procedure TFPrincipal.FormShow(Sender: TObject);
begin
  SetLength(dm.StatusThreads,2);
  baixaEmpresa;
  baixaProduto;
end;

procedure TFPrincipal.btFavoritosClick(Sender: TObject);
begin
  ExecuteAction(ChangeTabFavoritos);
end;

procedure TFPrincipal.btPesquisaClick(Sender: TObject);
begin
  if TabControl1.ActiveTab = tbAlta then
    lvAlta.SearchVisible := not lvAlta.SearchVisible
  else if TabControl1.ActiveTab = tbFavoritos then
    //lvFavoritos.SearchVisible := not lvFavoritos.SearchVisible;
end;

procedure TFPrincipal.colocaImagens;
var
  i:integer;
begin

end;

procedure TFPrincipal.Label5Click(Sender: TObject);
begin
  dm.FDQuery1.Active := False;
  dm.FDQuery1.SQL.Clear;
  dm.FDQuery1.SQL.Add('drop table usuario;');
  dm.FDQuery1.ExecSQL;
  close;
end;

procedure TFPrincipal.lvAltaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  uri : string;
  {$IFDEF ANDROID}
  Intent : JIntent;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
  cdsEmpresa.Active := True;
  cdsEmpresa.Last;
  uri :='https://api.whatsapp.com/send?phone=+5566996429225&text=Olá, estou interessado no produto '+cdsProdutoNome.Value;

  try
    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW, TJnet_Uri.JavaClass.parse(StringToJString(TIdURI.URLEncode(uri))));

    SharedActivity.startActivity(Intent);
  except on E: Exception do
    ShowMessage(E.Message);
  end;
  {$ENDIF}

end;

procedure TFPrincipal.lvAltaPullRefresh(Sender: TObject);
var
  Thread : TThread;
begin
  if Sincro then
    exit;
  if dm.checaConexao then
      begin
      Sincro := True;
      try
        Thread :=  TThread.CreateAnonymousThread(
        procedure
        begin
          try
            AnimaCarrega.Enabled := true;
            AnimaCarrega.Visible := true;
            AnimaCarrega.BringToFront;

            try
              cdsPromocoes.DisableControls;
              baixaEmpresa;
              baixaProduto;
              cdsPromocoes.EnableControls;
            except on E: Exception do
              ShowMessage(e.Message);
            end;
          finally
            cdsPromocoes.First;

            AnimaCarrega.Enabled := False;
            AnimaCarrega.Visible := False;
            AnimaCarrega.Sendtoback;

            Sincro := false;
          end;
        end);
        Thread.FreeOnTerminate := True;
        Thread.Start;
        except on E: Exception do
          ShowMessage(e.Message);
      end;
    end else
      ShowMessage('Não foi possível estabelecer a conexão');

end;

procedure TFPrincipal.preencheListView;
var
  Str:String;
begin
  cdsPromocoes.First;
  while not cdsPromocoes.Eof do
    begin
      //Items
      with lvAlta.Items.Add do
        begin
          Data['Valor'] := cdsPromocoesfPrecoProduto.Value;
          Data['Desconto'] := cdsPromocoesdesconto.Value;
          str := cdsPromocoesfNomeEmpresa.Value;
          Data['Empresa'] := str;
          Data['DataFinal'] := cdsPromocoesdataFinal.Value;
          Data['Outro'] := cdsPromocoesrelevancia.Value;
          str := cdsPromocoesfNomeProduto.Value;
          Data['Produto']:= str;
          Data['imgProduto'] := RandomRange(3, 5);

          Data['imgContato'] := 2;
          Data['imgFavorito'] := 0;
        end;
      cdsPromocoes.Next;
    end;
end;

end.
