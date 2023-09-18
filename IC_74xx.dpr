program IC_74xx;

uses
  Vcl.Forms,
  IC_74xx_U1 in 'IC_74xx_U1.pas' {ic_74xx_f1},
  ESConnectionModule in 'ESConnectionModule.pas' {ESConnection: TDataModule},
  Chip in 'Chip.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tic_74xx_f1, ic_74xx_f1);
  Application.CreateForm(TESConnection, ESConnection);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
