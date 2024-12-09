program Exportar;

uses
  Vcl.Forms,
  uExportar in '..\Fontes\uExportar.pas' {frmExportar};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmExportar, frmExportar);
  Application.Run;
end.
