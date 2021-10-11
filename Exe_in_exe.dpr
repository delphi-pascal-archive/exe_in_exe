program Exe_in_exe;

uses
  Forms,
  Exexe in 'Exexe.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
