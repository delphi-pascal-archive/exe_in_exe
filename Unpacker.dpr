program Unpacker;

uses
 SysUtils;

const
 c=41984;

var
 h: integer;
 mas: array[1..2048] of byte;
 f: file;
 i,done1: integer;
 done: integer=0;

begin
 h:=FileOpen(paramstr(0),fmOpenRead or fmShareDenyWrite);
 FileSeek(h,c,0);
 FileRead(h,i,sizeof(i));
 AssignFile(f,'file_1.tmp');
 Rewrite(f,1);
 while i>=done+2048 do
  begin
   done1:=FileRead(h,mas,sizeof(mas));
   blockwrite(f,mas,done1);
   inc(done,done1);
  end;
 if i>done then
  begin
   done1:=fileread(h,mas,i-done);
   blockwrite(f,mas,done1);
  end;
 CloseFile(f);
 done:=0;
 FileRead(h,i,sizeof(i));
 AssignFile(f,'file_2.tmp');
 Rewrite(f,1);
 while i>=done+2048 do
  begin
   done1:=FileRead(h,mas,sizeof(mas));
   blockwrite(f,mas,done1);
   inc(done,done1);
  end;
 if i>done then
  begin
   done1:=FileRead(h,mas,i-done);
   blockwrite(f,mas,done1);
  end;
 CloseFile(f);
 FileClose(h);
end.
