unit uController;

interface

uses
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  System.SysUtils, FMX.Forms, System.Classes, FMX.dialogs,
  IdServerIOHandler, IdSSL, IdSSLOpenSSL, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSLOpenSSLHeaders, System.IOUtils, REST.Types,
  FMX.Controls.Presentation, FMX.StdCtrls, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Authenticator.Basic;

type
  TUsuario = Class
  private
    Fid: Integer;
    Femail: string;
    Fsenha: string;
    Fnome: String;
    Ftoken: string;
    procedure Setid(const Value: Integer);
    procedure Setemail(const Value: string);
    procedure Setnome(const Value: String);
    procedure Setsenha(const Value: string);
    procedure Settoken(const Value: string);
  published
    property id:Integer read Fid write Setid;
    property nome:String read Fnome write Setnome;
    property senha:string read Fsenha write Setsenha;
    property email:string read Femail write Setemail;
    property token:string read Ftoken write Settoken;
  end;

  TEmpresa = class
  private
    Femail: String;
    Fnome: String;
    Fendereco: String;
    Ftelefone: String;
    Fid: Integer;
    procedure Setemail(const Value: String);
    procedure Setendereco(const Value: String);
    procedure Setnome(const Value: String);
    procedure Settelefone(const Value: String);
    procedure Setid(const Value: Integer);
  published
    property id:Integer read Fid write Setid;
    property nome:String read Fnome write Setnome;
    property endereco:String read Fendereco write Setendereco;
    property telefone:String read Ftelefone write Settelefone;
    property email:String read Femail write Setemail;
  end;

  TProduto = class
  private
    FidEmpresa: Integer;
    Fvalor: double;
    Findice: integer;
    Fnome: String;
    FidCategoria: Integer;
    Fid: Integer;
    procedure SetidCategoria(const Value: Integer);
    procedure SetidEmpresa(const Value: Integer);
    procedure Setindice(const Value: integer);
    procedure Setnome(const Value: String);
    procedure Setvalor(const Value: double);
    procedure Setid(const Value: Integer);
  published
    property id:Integer read Fid write Setid;
    property indice : integer read Findice write Setindice;
    property nome:String read Fnome write Setnome;
    property valor : double read Fvalor write Setvalor;
    property idEmpresa:Integer read FidEmpresa write SetidEmpresa;
    property idCategoria:Integer read FidCategoria write SetidCategoria;
  end;

  TPromocoes = class
  private
    Ftexto: string;
    Fproduto: integer;
    Fdesc_pagamento: Integer;
    FidEmpresa: Integer;
    Fdesconto: Double;
    Frelevancia: Double;
    FdataFinal: TDateTime;
    FdataInicial: TDateTime;
    Fid: integer;
    procedure Settexto(const Value: string);
    procedure SetdataFinal(const Value: TDateTime);
    procedure SetdataInicial(const Value: TDateTime);
    procedure Setdesc_pagamento(const Value: Integer);
    procedure Setdesconto(const Value: Double);
    procedure SetidEmpresa(const Value: Integer);
    procedure Setidproduto(const Value: Integer);
    procedure Setrelevancia(const Value: Double);
    procedure Setid(const Value: integer);
  published
    property id:integer read Fid write Setid;
    property texto :string read Ftexto write Settexto;
    property desconto : Double read Fdesconto write Setdesconto;
    property desc_pagamento : Integer read Fdesc_pagamento write Setdesc_pagamento;
    property relevancia: Double read Frelevancia write Setrelevancia;
    property idproduto:Integer read Fproduto write Setidproduto;
    property idEmpresa:Integer read FidEmpresa write SetidEmpresa;
    property dataInicial:TDateTime read FdataInicial write SetdataInicial;
    property dataFinal:TDateTime read FdataFinal write SetdataFinal;
  end;

procedure CriarComponents;
function GetHTTP(URI: String) : String;
function PostHTTP(URI, Body: String) : String;

const
  URL = 'http://192.168.0.36:8000/';

var
  TOKEN : string;
  RESTClient1: TRESTClient;
  RESTRequest1: TRESTRequest;
  RESTResponse1: TRESTResponse;


implementation

procedure CriarComponents;
begin
  RESTResponse1 := TRESTResponse.Create(nil);

  RESTClient1 := TRESTClient.Create(nil);

  RESTRequest1 := TRESTRequest.Create(nil);
  RESTRequest1.Client := RESTClient1;
  RESTRequest1.Response := RESTResponse1;


  RESTClient1.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8';
  RESTClient1.BaseURL := URL;
end;

function PostHTTP(URI, Body: String) : String;
begin
  RESTRequest1.Method := rmPOST;
  RESTRequest1.Params.Clear;

  if not TOKEN.IsEmpty then
    begin
      with RESTRequest1.Params.AddItem do
        begin
          Kind := pkHTTPHEADER;
          Value := 'Token '+TOKEN;
          Name := 'Authorization';
          Options := [poDoNotEncode];
        end;
    end;

  RESTRequest1.Params.AddBody(Body, ctAPPLICATION_JSON);
  RESTRequest1.Resource := URI;

  try
    RESTRequest1.Execute;

    result := RESTResponse1.Content;
  except
    on e : exception do
      begin
        result := 'Erro';
        Showmessage(e.Message);
      end;

  end;
end;

function GetHTTP(URI:String) : String;
begin
  try
    RESTRequest1.Method := rmGET;
    RESTRequest1.Params.Clear;
    RESTRequest1.Timeout := 15000;

    if not TOKEN.IsEmpty then
    begin
      with RESTRequest1.Params.AddItem do
        begin
          Kind := pkHTTPHEADER;
          Value := 'Token '+TOKEN;
          Name := 'Authorization';
          Options := [poDoNotEncode];
        end;
    end;

    RESTRequest1.Resource := URI;

    RESTRequest1.Execute;

    result := RESTResponse1.Content;
  except on E: Exception do
    Result:='Erro!';
  end;

end;

{ TUsuario }

procedure TUsuario.Setemail(const Value: string);
begin
  Femail := Value;
end;

procedure TUsuario.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TUsuario.Setnome(const Value: String);
begin
  Fnome := Value;
end;

procedure TUsuario.Setsenha(const Value: string);
begin
  Fsenha := Value;
end;

procedure TUsuario.Settoken(const Value: string);
begin
  Ftoken := Value;
end;

{ TPromocoes }

procedure TPromocoes.SetdataFinal(const Value: TDateTime);
begin
  FdataFinal := Value;
end;

procedure TPromocoes.SetdataInicial(const Value: TDateTime);
begin
  FdataInicial := Value;
end;

procedure TPromocoes.Setdesconto(const Value: Double);
begin
  Fdesconto := Value;
end;

procedure TPromocoes.Setdesc_pagamento(const Value: Integer);
begin
  Fdesc_pagamento := Value;
end;

procedure TPromocoes.SetidEmpresa(const Value: Integer);
begin
  FidEmpresa := Value;
end;

procedure TPromocoes.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TPromocoes.Setidproduto(const Value: Integer);
begin
  Fproduto := Value;
end;

procedure TPromocoes.Setrelevancia(const Value: Double);
begin
  Frelevancia := Value;
end;

procedure TPromocoes.Settexto(const Value: string);
begin
  Ftexto := Value;
end;

{ TProduto }

procedure TProduto.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TProduto.SetidCategoria(const Value: Integer);
begin
  FidCategoria := Value;
end;

procedure TProduto.SetidEmpresa(const Value: Integer);
begin
  FidEmpresa := Value;
end;

procedure TProduto.Setindice(const Value: integer);
begin
  Findice := Value;
end;

procedure TProduto.Setnome(const Value: String);
begin
  Fnome := Value;
end;

procedure TProduto.Setvalor(const Value: double);
begin
  Fvalor := Value;
end;

{ TEmpresa }

procedure TEmpresa.Setemail(const Value: String);
begin
  Femail := Value;
end;

procedure TEmpresa.Setendereco(const Value: String);
begin
  Fendereco := Value;
end;

procedure TEmpresa.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TEmpresa.Setnome(const Value: String);
begin
  Fnome := Value;
end;

procedure TEmpresa.Settelefone(const Value: String);
begin
  Ftelefone := Value;
end;

end.
