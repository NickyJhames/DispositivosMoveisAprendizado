unit uSplash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  REST.JSON, System.JSON;

type
  TFSplash = class(TForm)
    Rectangle1: TRectangle;
    Image1: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    Initialized : Boolean;
    procedure carregaFormPrincipal;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSplash: TFSplash;

implementation

uses
  uPrincipal, uController, udm, uLogin;

{$R *.fmx}

{ TForm2 }

procedure TFSplash.carregaFormPrincipal;
var
  Frm : TForm;
  usuario, msg, Retorno : String;
  jsRetorno : TJSONValue;
begin
  DM := TDM.Create(Application);
  dm.fdUsuario.Open;
  CriarComponents;
  if DM.fdUsuario.RecordCount = 0 then
    begin
      fLogin := TfLogin.Create(Application);
      fLogin.Show;
      Application.MainForm := fLogin;
    end
  else
    begin
      fPrincipal := TfPrincipal.Create(Application);

      Application.MainForm := fPrincipal;

      fPrincipal.Show;
    end;

  fSplash.Close;
  FreeAndNil(fSplash);
end;

procedure TFSplash.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;

  if not Initialized then
    begin
      Initialized := True;

      carregaFormPrincipal;
    end;
end;

end.
