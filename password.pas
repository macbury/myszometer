unit password;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SimpleMySQL,ImgList;

type
  TFrmLogin = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ImageList1: TImageList;
    Button3: TButton;
    Notebook1: TNotebook;
    Bevel2: TBevel;
    Button4: TButton;
    Button5: TButton;
    Shape1: TShape;
    Bevel1: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    Image2: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label8: TLabel;
    Label9: TLabel;
    Image1: TImage;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    sEdit2: TEdit;
    sEdit1: TEdit;
    Edit1: TEdit;
    Image3: TImage;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    RadioButton3: TRadioButton;
    Label10: TLabel;
    Label15: TLabel;
    procedure Edit3Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sEdit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ss,sss : string;//nick haslo
    function rejestruj(nick,haslo:string): boolean;
    function loguj(nick,haslo:string):boolean;

  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

function TFrmLogin.loguj(nick,haslo:string):boolean;
var MySQL: TSimpleMySQL;
begin
     MySQL := TSimpleMySQL.Create;
     MySQL.Host := 'freesql.org';
     MySQL.User := 'myszometer';
     MySQL.Password := 'myszo12';
     if  mysql.connect = false then exit;
     MySQL.SelectDatabase('myszometer');

     MySQL.Query('select * from myszometer where user="'+nick+'" and pass=PASSWORD("'+haslo+'")');
     if MySQL.QueryResult.RowsCount =0 then
     begin
          ShowMessage('Podane konto nie istnieje! SprawdŸ poprawnoœæ loginu i has³a.');
          result := false;
     end else result := true;
     MySQl.Free;
end;
function TFrmLogin.rejestruj(nick,haslo:string) : boolean;
var MySQL: TSimpleMySQL;
begin

     MySQL := TSimpleMySQL.Create;
     MySQL.Host := 'freesql.org';
     MySQL.User := 'myszometer';
     MySQL.Password := 'myszo12';
     if  mysql.connect = false then exit;
     MySQL.SelectDatabase('myszometer');
     MySQL.Query('select * from myszometer where user="'+nick+ '";');
     if MySQL.QueryResult.RowsCount = 0 then
     begin
         mySQL.Query('insert into myszometer values ("'+nick+'", PASSWORD("'+haslo+'"), "0", "0", "0", "0", " ", "0", "0", "0", "0", "0", "0",  null);');
         ShowMessage('Gratulujê! Konto za³o¿one!');
         result := true;
     end else
     begin
          result := false;
          ShowMessage('U¿ytkownik o podanym loginie ju¿ istnieje!');
     end;
     MySQl.Free;
end;
procedure TFrmLogin.Button1Click(Sender: TObject);
begin
     if edit4.Text = '' then
     begin
          ShowMessage('Podaj Login!');
          exit;
     end;
     if not loguj(edit4.Text,edit3.Text) then exit;
     tag := 2;
     close;
end;

procedure TFrmLogin.sEdit1Change(Sender: TObject);
var Bitmap : TBitmap;
begin
     if (sEdit1.Text = sEdit2.Text) then
     begin
          Bitmap := TBitmap.Create;
          imagelist1.GetBitmap(1, bitmap);
          image1.Picture.Assign(Bitmap);
          button3.Enabled := true;

          bitmap.Free;
     end
     else
     begin
          Bitmap := TBitmap.Create;
          imagelist1.GetBitmap(0, bitmap);
          image1.Picture.Assign(Bitmap);
          button3.Enabled := false;

          bitmap.Free;
     end;

end;

procedure TFrmLogin.Button2Click(Sender: TObject);
begin
     tag := 0;
     close;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
var Bitmap : TBitmap;
begin
    Bitmap := TBitmap.Create;
    imagelist1.GetBitmap(2, bitmap);
    image1.Picture.Assign(Bitmap);
    image3.Picture.Assign(Bitmap);
    bitmap.Free;
    tag := 0;
    NoteBook1.ActivePage := 'start';
end;

procedure TFrmLogin.Button3Click(Sender: TObject);
begin
      if edit1.Text = '' then
      begin
          ShowMessage('Podaj Login!');
          exit;
      end;
      case Application.MessageBox(Pchar('Czy chcesz za³o¿yæ konto: '+edit1.text),'Nowe konto', MB_YESNO) of
          idYES:
          begin
               if rejestruj(edit1.Text,sedit1.Text) then
               begin
                    tag := 1;
                    close;
               end;
          end;
      end;

end;

procedure TFrmLogin.Button4Click(Sender: TObject);
begin
     if radiobutton1.Checked then
     begin
        NoteBook1.ActivePage := 'NewKonto';
        button3.Visible := true;
        Button4.Visible := false;
        label5.Caption := '- Tworzenie nowego konta';
     end
     else
     begin
        Edit3.Text := '';
        Edit2.Text := '';
        Edit4.Text := '';
        NoteBook1.ActivePage := 'Konto';
        label5.Caption := '- Logowanie do konta';
        button1.Visible := true;
        Button4.Visible := false;
        if radiobutton3.Checked then
        begin
             Edit3.Text := sss;
             Edit2.Text := sss;
             Edit4.Text := ss;
             label5.Caption := '- Konfiguracja konta';
        end;
     end;
end;

procedure TFrmLogin.Button5Click(Sender: TObject);
begin
    button1.Visible := false;
    button3.Visible := false;
    Button4.Visible := true;
    NoteBook1.ActivePage := 'start';
    label5.Caption := '- Konta';
end;

procedure TFrmLogin.Edit3Change(Sender: TObject);
var Bitmap : TBitmap;
begin
     if (Edit3.Text = Edit2.Text) then
     begin
          Bitmap := TBitmap.Create;
          imagelist1.GetBitmap(1, bitmap);
          image3.Picture.Assign(Bitmap);
          button1.Enabled := true;

          bitmap.Free;
     end
     else
     begin
          Bitmap := TBitmap.Create;
          imagelist1.GetBitmap(0, bitmap);
          image3.Picture.Assign(Bitmap);
          button1.Enabled := false;

          bitmap.Free;
     end;

end;

end.
