program MyszoMeter;

uses
  Forms,
  SysUtils,
  Windows,
  main in 'main.pas' {Form2},
  password in 'password.pas' {FrmLogin},
  ABOUT in 'ABOUT.pas' {AboutBox},
  mysql in 'mysql.pas',
  SimpleMySQL in 'SimpleMySQL.pas',
  datafile in 'datafile.pas';

{$R *.res}
var
  ini: TDataFile;
begin
  CreateMutex(nil, FALSE, 'MyszoMeter');
  if GetLastError() <> 0 then Halt;
  Application.Initialize;
  Application.Title := 'MyszoMeter';
  Application.CreateForm(TForm2, Form2);
  ini := TDataFile.Create(extractfilepath(application.ExeName)+'\data.dat');
  Application.ShowMainForm := INI.ReadBoolean('kasek','eds', true);
  ini.Free;
  Application.Run;
end.
