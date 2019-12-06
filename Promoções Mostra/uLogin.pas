unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Layouts,
  System.Actions, FMX.ActnList, FMX.TabControl;

type
  TFLogin = class(TForm)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Rectangle2: TRectangle;
    ShadowEffect1: TShadowEffect;
    Layout2: TLayout;
    lbUsuario: TLabel;
    edUsuario: TEdit;
    Layout3: TLayout;
    lbSenha: TLabel;
    edSenha: TEdit;
    btEntrar: TRectangle;
    Label1: TLabel;
    Rectangle3: TRectangle;
    Label2: TLabel;
    tc: TTabControl;
    tbLogin: TTabItem;
    tbCriarConta: TTabItem;
    Layout5: TLayout;
    Rectangle4: TRectangle;
    Layout6: TLayout;
    Label3: TLabel;
    edCriaNome: TEdit;
    Layout7: TLayout;
    Label4: TLabel;
    edCriaSenha: TEdit;
    Rectangle5: TRectangle;
    Label5: TLabel;
    ShadowEffect2: TShadowEffect;
    Layout8: TLayout;
    Label6: TLabel;
    edCriaEmail: TEdit;
    ActionList1: TActionList;
    ChangeTabCriaConta: TChangeTabAction;
    ChangeTabLoga: TChangeTabAction;
    Rectangle6: TRectangle;
    Label7: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLogin: TFLogin;

implementation

uses
  udm, System.JSON, uController, uPrincipal;

{$R *.fmx}

procedure TFLogin.Label1Click(Sender: TObject);
var
  token, Retorno : String;
  jsRetorno : TJSONValue;
begin
  if dm.checaConexao then
    begin
      if tc.ActiveTab = tbLogin then
        Retorno := PostHTTP('rest/login',
        '{"username":"'+edUsuario.Text+
        '","password":"'+edSenha.Text+'"}')
      else
        Retorno := PostHTTP('rest/cria_usuario',
        '{"username":"'+edCriaNome.Text+
        '","password":"'+edCriaSenha.Text+
        '","email":"'+edCriaEmail.Text+'"}'
        );
      if Retorno = 'Erro' then
        Exit;

      jsRetorno := TJSONObject.ParseJSONValue(Retorno);

      try
        token := jsRetorno.GetValue('error', token);

        if (token <> '') then
          begin
            ShowMessage('Usuário ou senha incorretos!');
            exit;
          end;
      except

      end;

      dm.fdUsuario.Active := True;
      dm.fdUsuario.Insert;
      if tc.ActiveTab = tbLogin then
        begin
          dm.fdUsuario.FieldByName('NOME').Value := edUsuario.Text;
          dm.fdUsuario.FieldByName('SENHA').Value := edSenha.Text;
        end
      else
        begin
          dm.fdUsuario.FieldByName('NOME').Value := edCriaNome.Text;
          dm.fdUsuario.FieldByName('SENHA').Value := edCriaSenha.Text;
          dm.fdUsuario.FieldByName('EMAIL').Value := edCriaEmail.Text;
        end;

      token := jsRetorno.GetValue('token', token);
      dm.fdUsuario.FieldByName('TOKEN').Value := token;
      dm.fdUsuario.Post;
      dm.fdUsuario.Active := False;

      fPrincipal := TfPrincipal.Create(Application);

      fPrincipal.Show;
      Application.MainForm := fPrincipal;

      fLogin.Close;
      FreeAndNil(fLogin);
    end
  else
    ShowMessage('Não foi possível estabeler a conexão');

end;

procedure TFLogin.Label2Click(Sender: TObject);
begin
  ExecuteAction(ChangeTabCriaConta);
end;

procedure TFLogin.Label7Click(Sender: TObject);
begin
  ExecuteAction(ChangeTabLoga);
end;

end.
