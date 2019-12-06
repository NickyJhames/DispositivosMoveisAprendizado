program ProjetoPromocoes;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {FPrincipal},
  uSplash in 'uSplash.pas' {FSplash},
  uController in 'uController.pas',
  udm in 'udm.pas' {DM: TDataModule},
  uLogin in 'uLogin.pas' {FLogin},
  uBemVindo in 'uBemVindo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFSplash, FSplash);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
