{
  SimpleMySQL jest klasa umozliwiajaca latwa komunikacje z baza danych MySQL
  korzysta z modulu mysql.pas i biblioteki libmySQL.dll. Celem tej SimpleMySQL
  jest stworzenie jak najprostrzej metody laczenia i zarzadzania baza danych
  MySQL.

  Klasa korzysta z MySQL Client API for Borland Delphi (dolaczone).

  Wersja : 1.0
  Autor: Wolverine (wolverine@daminet.pl)
}

unit SimpleMySQL;

interface

uses Windows, Messages, SysUtils, Classes, Controls, StdCtrls, MySQL;

type
  TField = record
    Name: String;
    Value: String;
  end;

  TRow = record
    Index: Integer;
    Fields: array of TField;
  end;

  TTable = record
    Name: String;
    Rows: array of TRow;
    Fields: array of TField;
    RowsCount, FieldsCount: Integer;
  end;

  TSimpleMySQL = class
    private
      MySQL: TMySQL;
      pResult: PMYSQL_RES;
      pRow: PMYSQL_ROW;
      pFields: PMYSQL_FIELDS;
    public
      QueryResult: TTable;  //Wyniki zapytania

      //Polaczenie
      Host: String;
      User: String;
      Password: String;
      function Connect: Boolean;
      procedure Disconnect;

      //Zarzadzanie baza
      function SelectDatabase(Name: String): Boolean;
      function Query(q: String): Boolean;
      function GetValue(Row: TRow; Name: String): String;

      destructor Destroy;
  end;

implementation

function TSimpleMySQL.Connect: Boolean;
begin
  mysql_connect(@MySQL, PChar(Host), PChar(User), PChar(Password));
  Result := (MySQL.net.last_errno = 0);
end;

procedure TSimpleMySQL.Disconnect;
begin
  mysql_close(@MySQL);
end;

function TSimpleMySQL.SelectDatabase(Name: String): Boolean;
begin
  Result := (mysql_select_db(@MySQL, PChar(Name)) = 0);
end;

function TSimpleMySQL.Query(q: String): Boolean;
var
  i, j: Integer;
begin
  mysql_query(@MySQL, PChar(q));
  pResult := mysql_store_result(@MySQL);

  if pResult = nil then begin
    Result := False;
    Exit;
  end else
    Result := True;

  QueryResult.RowsCount := presult^.row_count;
  QueryResult.FieldsCount := presult^.field_count;

  SetLength(QueryResult.Rows, presult^.row_count);
  SetLength(QueryResult.Fields, presult^.field_count);

  pfields := presult^.fields;
  for j := 0 to presult^.field_count - 1 do
    QueryResult.Fields[j].Name := pfields^[j].name;

  for i := 0 to presult^.row_count - 1 do begin
    prow := mysql_fetch_row(presult);
    for j := 0 to presult^.field_count -1 do begin
      SetLength(QueryResult.Rows[i].Fields, presult^.field_count);
      QueryResult.Rows[i].Fields[j].Name := QueryResult.Fields[j].Name;
      QueryResult.Rows[i].Fields[j].Value := prow^[j];
    end;
  end;
end;

function TSimpleMySQL.GetValue(Row: TRow; Name: String): String;
var
  q: Integer;
begin
  for q := 0 to QueryResult.FieldsCount -1 do
    if QueryResult.Fields[q].Name = Name then begin
      Result := Row.Fields[q].Value;
      Exit;
    end;
end;

destructor TSimpleMySQL.Destroy;
begin
  SetLength(QueryResult.Rows, 0);
  SetLength(QueryResult.Fields, 0);
  inherited Destroy;
end;

end.
