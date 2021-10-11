unit Exexe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
 OpenDialog1.InitialDir:=Application.ExeName;
 if OpenDialog1.Execute then
  Edit1.Text:=OpenDialog1.FileName;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 // картинки на кнопки
    // - Program Files\Common Files\Borland Shared\Images\Buttons
 Application.Title:='Exe in exe';    
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 OpenDialog1.InitialDir:=Application.ExeName;
 if OpenDialog1.Execute then
  Edit2.Text:=OpenDialog1.FileName;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
 SaveDialog1.InitialDir:=Application.ExeName;
 if SaveDialog1.Execute then
  Edit3.Text:=SaveDialog1.FileName;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 f,f2: file;
 buf: array[1..1024] of byte;
 i,j,done: integer;
begin
 Button1.Enabled:=false;
 if not((FileExists(Edit1.Text)) or (FileExists(Edit2.Text)))
 then
  begin
   ShowMessage('Неправильно указан путь к файлу');
   Button1.Enabled:=true;
   Exit;
  end;
 if not FileExists(ExtractFilePath((Application.ExeName))+'Unpacker.exe')
 then
  begin
   ShowMessage('Не могу найти Unpacker.exe');
   Button1.Enabled:=true;
   Exit;
  end;
 if Edit3.Text=''
 then
  begin
   ShowMessage('Введите имя файла!');
   Button1.Enabled:=true;
   Exit;
  end;
 AssignFile(f,ExtractFilePath((Application.ExeName))+'Unpacker.exe');
 AssignFile(f2,Edit3.Text);
 Reset(f,1);
 Rewrite(f2,1);
 // создаем файл указанный в Edit3.Text и записываем в него
 // распаковщик, размер первого файла + сам файл, размер второго
 // + второй соответственно файл
 i:=0;
 while not eof(f) do
  begin
   BlockRead(f,buf,sizeof(buf),done);
   BlockWrite(f2,buf,done);
   Application.ProcessMessages;
   inc(i);
   Sleep(10);
   Label1.Caption:='Запись распаковщика: '+IntToStr(i);
  end;
 CloseFile(f);
////////////
 AssignFile(f,Edit1.Text);
 Reset(f,1);
 done:=FileSize(f);
 BlockWrite(f2,done,4);
 i:=0;
 while not eof(f) do
  begin
   BlockRead(f,buf,sizeof(buf),done);
   BlockWrite(f2,buf,done);
   Application.ProcessMessages;
   inc(i);
   Label2.Caption:='Запаковка файла 1: '+IntToStr(i)+' ( ~ Кбайт)';
  end;
 CloseFile(f);
///////////
 AssignFile(f,Edit2.Text);
 Reset(f,1);
 done:=FileSize(f);
 BlockWrite(f2,done,4);
 j:=0;
 while not eof(f) do
  begin
   BlockRead(f,buf,sizeof(buf),done);
   BlockWrite(f2,buf,done);
   Application.ProcessMessages;
   inc(j);
   i:=i+1;
   Label3.Caption:='Запаковка файла 2: '+IntToStr(i)+' ( ~ Кбайт)';
  end;
 CloseFile(f);
 CloseFile(f2);
 Button1.Enabled:=true;
end;

end.
