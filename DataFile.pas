{-----------------------------------------------------------------------------
 DataFile
 Last modification : August, 29, 2001
 (Please write this last modification date in your e-mails.)

 Product:       DataFile
 Version: 	1.12
 Author:	Momot Alexander (Deleon)
 Web:		http://www.dbwork.chat.ru
 E-Mail:	sync@kor.kes.ru
 Status:	FreeWare
 Delphi:		32-bit versions
 Platform:	Windows 32-bit versions.

~ History ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-----------------------------------------------------------------------------}
unit DataFile;

interface

uses
  Windows, SysUtils, Classes;

const
  MAX_NAMELEN  = 36;
  MAXPATHLEN   = 240;

type
  IDENTNAME = array[0..MAX_NAMELEN - 1]of Char;

  pDataHdr = ^IDataHdr;
  IDataHdr = packed record
   Id      : Integer;
   Section : IDENTNAME;
   Ident   : IDENTNAME;
   Size    : Integer;
  end;

  TDataFile = class(TObject)
  private
    FFile: TFileStream;
    FFileName: string;
    FCodeKey: string;
    function  GetSectionCount: Integer;
    procedure XorBuffer(pBuf: Pointer; Count: integer);
    function  FindIdent(Section, Ident: string; pHdr: pDataHdr): boolean;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    //----------------------------------------------------
    procedure GetSectionNames(List: TStrings);
    procedure GetValueNames(Section: string; List: TStrings);
    //----------------------------------------------------
    function  SectionExists(Section: string): Boolean;
    function  ValueExists(Section, Ident: string): Boolean;
    //----------------------------------------------------
    function  ReadData(Section, Ident: string; pBuf: Pointer): Integer;
    function  ReadStream(Section, Ident: string; Stream: TStream): Integer;
    function  ReadString(Section, Ident, Default: string): string;
    function  ReadInteger(Section, Ident: string; Default: Integer): Integer;
    function  ReadDouble(Section, Ident: string; Default: Double): Double;
    function  ReadExtended(Section, Ident: string; Default: Extended): Extended;
    function  ReadDateTime(Section, Ident: string; Default: TDateTime): TDateTime;
    function  ReadBoolean(Section, Ident: string; Default: Boolean): Boolean;
    procedure ReadStrings(Section, Ident: string; List: TStrings);
    //----------------------------------------------------
    function  WriteData(Section, Ident: string; pBuf: Pointer; Count: Integer): Integer;
    function  WriteStream(Section, Ident: string; Stream: TStream): Integer;
    procedure WriteString(Section, Ident, Value: string);
    procedure WriteInteger(Section, Ident: string; Value: Integer);
    procedure WriteDouble(Section, Ident: string; Value: Double);
    procedure WriteExtended(Section, Ident: string; Value: Extended);
    procedure WriteDateTime(Section, Ident: string; Value: TDateTime);
    procedure WriteBoolean(Section, Ident: string; Value: Boolean);
    procedure WriteStrings(Section, Ident: string; List: TStrings);
    //----------------------------------------------------
    procedure Delete(Section, Ident: string);
    procedure DeleteSection(Section: string);
    //----------------------------------------------------
    property  CodeKey: string read FCodeKey write FCodeKey;
    property  FileName: string read FFileName;
    property  SectionCount: Integer read GetSectionCount;
  end;


implementation

const
 HDR_IDENT = $112;
constructor TDataFile.Create(const FileName: string);
var
 OpenMode: integer;
 Afile: textfile;
begin
  FFileName := FileName;
  if not FileExists(FFileName) then begin
    assignfile(Afile, FFileName);
    rewrite(Afile);
    closefile(Afile);
  end;
  if FileExists(FFileName)then
   OpenMode := fmOpenReadWrite or fmShareDenyNone
  else
   OpenMode := fmCreate or fmShareDenyNone;
  FFile := TFileStream.Create(FileName, OpenMode);
  FCodeKey := 'hDmpSwrdGZxqlHdgfcIRuHsDHs5Tu';
end;

destructor  TDataFile.Destroy;
begin
 if Assigned( FFile )then FFile.Free;
end;

function TDataFile.FindIdent(Section, Ident: string; pHdr: pDataHdr): boolean;
var
 Sect    : string;
 Iden    : string;
 Count   : integer;
 IsError : boolean;
begin
 IsError := False;
 Result  := False;
 FFile.Seek(0, soFromBeginning);
 repeat
  Count  := FFile.Read(pHdr^, SizeOf(IDataHdr));
  if( Count <> SizeOf(IDataHdr))then Break;
  XorBuffer(pHdr, SizeOf(IDataHdr));
  if( pHdr^.ID <> HDR_IDENT )then
  begin
   IsError := True;
   Break;
  end;
  Sect := pHdr^.Section;
  Iden := pHdr^.Ident;
  Result := ( ANSICompareText(Sect, Section) = 0 )and
            (( ANSICompareText(Iden, Ident) = 0 )or
            ( Ident = '' ));
  if( Result )then Break;
  FFile.Seek(pHdr^.Size, soFromCurrent);
 until( False );
 if( IsError )then raise EInvalidOperation.Create('Invalid file format.');
end;

procedure TDataFile.XorBuffer(pBuf: Pointer; Count: Integer);
var
 I: Integer;
 p: pBYTE;
begin
 p := pBuf;
 if( FCodeKey <> '' )then
 for I := 0 to Count - 1 do
 begin
  p^ := Byte(FCodeKey[1 + ((I - 1) mod Length(FCodeKey))]) xor p^;
  inc(p);
 end;
end;

function TDataFile.GetSectionCount: Integer;
var
 Hdr    : IDataHdr;
 Count  : integer;
 IsError: boolean;
begin
 IsError := False;
 Result  := 0;
 FFile.Seek(0, soFromBeginning);
 repeat
  Count  := FFile.Read(Hdr, SizeOf(IDataHdr));
  if( Count <> SizeOf(IDataHdr))then Break;
  XorBuffer(pBYTE(@Hdr), SizeOf(IDataHdr));
  if( Hdr.ID <> HDR_IDENT )then
  begin
   IsError := True;
   Break;
  end else inc(Result);
  FFile.Seek(Hdr.Size, soFromCurrent);
 until( False );
 if( IsError )then raise EInvalidOperation.Create('Invalid file format.');
end;

procedure TDataFile.GetSectionNames(List: TStrings);
var
 Hdr    : IDataHdr;
 Count  : integer;
 IsError: boolean;
begin
 IsError := False;
 List.Clear;
 FFile.Seek(0, soFromBeginning);
 repeat
  Count  := FFile.Read(Hdr, SizeOf(IDataHdr));
  if( Count <> SizeOf(IDataHdr))then Break;
  XorBuffer(pBYTE(@Hdr), SizeOf(IDataHdr));
  if( Hdr.ID <> HDR_IDENT )then
  begin
   IsError := True;
   Break;
  end else
  if( List.IndexOf(Hdr.Section) = -1 )then
  List.Add(Hdr.Section);
  FFile.Seek(Hdr.Size, soFromCurrent);
 until( False );
 if( IsError )then raise EInvalidOperation.Create('Invalid file format.');
end;

procedure TDataFile.GetValueNames(Section: string; List: TStrings);
var
 Hdr    : IDataHdr;
 Count  : integer;
 IsError: boolean;
begin
 IsError := False;
 List.Clear;
 FFile.Seek(0, soFromBeginning);
 repeat
  Count  := FFile.Read(Hdr, SizeOf(IDataHdr));
  if( Count <> SizeOf(IDataHdr))then Break;
  XorBuffer(pBYTE(@Hdr), SizeOf(IDataHdr));
  if( Hdr.ID <> HDR_IDENT )then
  begin
   IsError := True;
   Break;
  end else
  if ANSICompareText(Section, Hdr.Section) = 0 then
  List.Add(Hdr.Ident);
  FFile.Seek(Hdr.Size, soFromCurrent);
 until( False );
 if( IsError )then raise EInvalidOperation.Create('Invalid file format.');
end;

{------------------------------------------------------------------------------}
{  find                                                                        }
{------------------------------------------------------------------------------}

function TDataFile.SectionExists(Section: string): Boolean;
var
  Hdr: IDataHdr;
begin
  Result := FindIdent(Section, '', @Hdr);
end;

function TDataFile.ValueExists(Section, Ident: string): Boolean;
var
  Hdr: IDataHdr;
begin
  Result := FindIdent(Section, Ident, @Hdr);
end;

{------------------------------------------------------------------------------}
{  read                                                                        }
{------------------------------------------------------------------------------}

function TDataFile.ReadData(Section, Ident: string; pBuf: Pointer): Integer;
var
 Found   : boolean;
 Hdr     : IDataHdr;
begin
 Found := FindIdent(Section, Ident, @Hdr);
 if( Found  )then
 begin
  Result := FFile.Read(pBuf^, Hdr.Size);
  XorBuffer(pBuf, Hdr.Size);
 end else
  Result := -1;
end;

function TDataFile.ReadStream(Section, Ident: string; Stream: TStream): Integer;
var
 Hdr  : IDataHdr;
 pBuf : Pointer;
begin
  if( FindIdent(Section, Ident, @Hdr)  )then
  begin
   Result := Hdr.Size;
   try
    GetMem(pBuf, Result);
    FFile.Read(pBuf^, Result);
    XorBuffer(pBuf, Result);
    Stream.Size := 0;
    Stream.Write(pBuf^, Result);
    Stream.Seek(0, soFromBeginning);
   finally
    FreeMem(pBuf, Result);
   end;
  end else
   Result := -1;
end;

function TDataFile.ReadString(Section, Ident, Default: string): string;
var
  Buf   : TMemoryStream;
  pBuf  : PChar;
  Count : Integer;
begin
  try
   Buf   := TMemoryStream.Create;
   Count := ReadStream(Section, Ident, Buf);
   if( Count > -1 )then
   begin
    pBuf  := StrAlloc(Count);
    Buf.Seek(0, soFromBeginning);
    Buf.Read(pBuf^, Count);
    Result := StrPas(pBuf);
   end else
    Result := Default;
  finally
   Buf.Free;
  end;
end;

function TDataFile.ReadInteger(Section, Ident: string; Default: Integer): Integer;
var
  Buf   : array[0..1023]of Char;
  Count : Integer;
begin
  Count := ReadData(Section, Ident, @Buf);
  if( Count >= SizeOf(Integer) )then
   Move(Buf, Result, SizeOf(Integer))
  else
   Result := Default;
end;

function TDataFile.ReadDouble(Section, Ident: string; Default: Double): Double;
var
  Buf   : array[0..1023]of Char;
  Count : Integer;
begin
  Count := ReadData(Section, Ident, @Buf);
  if( Count >= SizeOf(Double) )then
   Move(Buf, Result, SizeOf(Double))
  else
   Result := Default;
end;

function TDataFile.ReadExtended(Section, Ident: string; Default: Extended): Extended;
var
  Buf   : array[0..1023]of Char;
  Count : Integer;
begin
  Count := ReadData(Section, Ident, @Buf);
  if( Count >= SizeOf(Extended) )then
   Move(Buf, Result, SizeOf(Extended))
  else
   Result := Default;
end;

function TDataFile.ReadDateTime(Section, Ident: string; Default: TDateTime): TDateTime;
var
  Buf   : array[0..1023]of Char;
  Count : Integer;
begin
  Count := ReadData(Section, Ident, @Buf);
  if( Count >= SizeOf(TDateTime) )then
   Move(Buf, Result, SizeOf(TDateTime))
  else
   Result := Default;
end;

function TDataFile.ReadBoolean(Section, Ident: string; Default: Boolean): Boolean;
var
  Buf   : array[0..1023]of Char;
  Count : Integer;
begin
  Count := ReadData(Section, Ident, @Buf);
  if( Count >= SizeOf(Boolean) )then
   Move(Buf, Result, SizeOf(Boolean))
  else
   Result := Default;
end;

procedure TDataFile.ReadStrings(Section, Ident: string; List: TStrings);
var
  Buf   : TMemoryStream;
  Count : Integer;
begin
  try
   List.Clear;
   Buf := TMemoryStream.Create;
   Count := ReadStream(Section, Ident, Buf);
   if( Count > -1 )then
   List.LoadFromStream( Buf );
  finally
   Buf.Free;
  end;
end;

{------------------------------------------------------------------------------}
{  write                                                                       }
{------------------------------------------------------------------------------}

function TDataFile.WriteData(Section, Ident: string; pBuf: Pointer; Count: Integer): Integer;
var
 Hdr : IDataHdr;
 P   : Pointer;
begin
 Delete(Section, Ident);
 FFile.Seek(0, soFromEnd);
 { feel header }
 Hdr.Id := HDR_IDENT;
 StrPCopy(Hdr.Section, Section);
 StrPCopy(Hdr.Ident, Ident);
 Hdr.Size := Count;
 { xor }
 XorBuffer(@Hdr, SizeOf(IDataHdr));
 { write header }
 Result := FFile.Write(Hdr, SizeOf(IDataHdr));
 if( Result > -1 )then
 begin
  try
   GetMem(P, Count);
   Move(pBuf^, P^, Count);
   { xor data }
   XorBuffer(P, Count);
   { write data }
   Result := FFile.Write(P^, Count);
  finally
   FreeMem(P, Count);
  end;
 end;
end;

function TDataFile.WriteStream(Section, Ident: string; Stream: TStream): Integer;
var
 pBuf : Pointer;
begin
 try
  { init buffer }
  GetMem(pBuf, Stream.Size);
  Stream.Seek(0, soFromBeginning);
  Stream.Read(pBuf^, Stream.Size);
  { write data }
  Result := WriteData(Section, Ident, pBuf, Stream.Size);
 finally
  FreeMem(pBuf, Stream.Size);
 end;
end;

procedure TDataFile.WriteString(Section, Ident, Value: string);
var
  pBuf : pChar;
begin
  try
   pBuf := StrNew(PChar(Value));
   WriteData(Section, Ident, pBuf, StrLen(pBuf) + 1);
  finally
   StrDispose(pBuf);
  end;
end;

procedure TDataFile.WriteInteger(Section, Ident: string; Value: Integer);
begin
  WriteData(Section, Ident, @Value, SizeOf(Integer));
end;

procedure TDataFile.WriteDouble(Section, Ident: string; Value: Double);
begin
  WriteData(Section, Ident, @Value, SizeOf(Double));
end;

procedure TDataFile.WriteExtended(Section, Ident: string; Value: Extended);
begin
  WriteData(Section, Ident, @Value, SizeOf(Extended));
end;

procedure TDataFile.WriteDateTime(Section, Ident: string; Value: TDateTime);
begin
  WriteData(Section, Ident, @Value, SizeOf(TDateTime));
end;

procedure TDataFile.WriteBoolean(Section, Ident: string; Value: Boolean);
begin
  WriteData(Section, Ident, @Value, SizeOf(Boolean));
end;

procedure TDataFile.WriteStrings(Section, Ident: string; List: TStrings);
var
  Buf   : TMemoryStream;
  Count : Integer;
begin
  try
   Buf := TMemoryStream.Create;
   List.SaveToStream( Buf );
   WriteStream(Section, Ident, Buf);
  finally
   Buf.Free;
  end;
end;

{------------------------------------------------------------------------------}
{  delete                                                                      }
{------------------------------------------------------------------------------}

procedure TDataFile.Delete(Section, Ident: string);
var
  BufPos   : Integer;
  HdrPos   : Integer;
  EndPos   : Integer;
  FileSize : Integer;
  Count    : Integer;
  Hdr      : IDataHdr;
  pBuf     : Pointer;
begin
  if( FindIdent(Section, Ident, @Hdr) )then
  begin
   FileSize := FFile.Size;
   BufPos   := FFile.Position;
   HdrPos   := BufPos - SizeOf(IDataHdr);
   { seek to end buffer }
   EndPos   := FFile.Seek(Hdr.Size, soFromCurrent);
   Count    := FileSize - EndPos;
   try
    GetMem(pBuf, Count);
    FFile.Read(pBuf^, Count);
    FFile.Seek(HdrPos, soFromBeginning);
    FFile.Write(pBuf^, Count);
    FFile.Size := FileSize - ( Hdr.Size + SizeOf(IDataHdr) );
   finally
    FreeMem(pBuf, Count);
   end;
  end;
end;

procedure TDataFile.DeleteSection(Section: string);
var
  BufPos : Integer;
  HdrPos : Integer;
  EndPos : Integer;
  Size   : Integer;
  Count  : Integer;
  Hdr    : IDataHdr;
  pBuf   : Pointer;
begin
  while FindIdent(Section, '', @Hdr)do
  begin
   Size := FFile.Size;
   BufPos := FFile.Position;
   HdrPos := BufPos - SizeOf(IDataHdr);
   { Seek to end buffer }
   EndPos := FFile.Seek(Hdr.Size, soFromCurrent);
   Count  := Size - EndPos;
   try
    GetMem(pBuf, Count);
    FFile.Read(pBuf^, Count);
    FFile.Seek(HdrPos, soFromBeginning);
    FFile.Write(pBuf^, Count);
    FFile.Size := Size - ( Hdr.Size + SizeOf(IDataHdr) );
   finally
    FreeMem(pBuf, Count);
   end;
  end;
end;

end.
