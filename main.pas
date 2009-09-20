unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CoolTrayIcon, DataFile, Buttons, ImgList,
  AppEvnts, Menus, inifiles, ComCtrls, XPMan, SimpleMySQL, Registry, shellapi;
const
   NombreDLL       = 'HookMouse.dll';
   CM_MANDA_DATOS  = WM_USER + $1000;
type
  TCompartido = record
    Receptor,
    wHitTestCode,
    x,y,
    Ventana         : hwnd;
  end;
  PCompartido   =^TCompartido;
  THookMouse=procedure; stdcall;
type
  TForm2 = class(TForm)
    CoolTrayIcon1: TCoolTrayIcon;
    Timer2: TTimer;
    Timer3: TTimer;
    Timer1: TTimer;
    ImageList2: TImageList;
    PopupMenu1: TPopupMenu;
    Kopiuj1: TMenuItem;
    MainMenu1: TMainMenu;
    Oprogramie1: TMenuItem;
    Wyzerujwynik1: TMenuItem;
    Konto1: TMenuItem;
    Zakcz1: TMenuItem;
    Myszometer1: TMenuItem;
    Uruchamiajzstartemsystemu1: TMenuItem;
    TreeView1: TTreeView;
    XPManifest1: TXPManifest;
    N1: TMenuItem;
    Konfiguracja1: TMenuItem;
    Timer4: TTimer;
    Aktualizujco1: TMenuItem;
    N1godzine1: TMenuItem;
    N30minut1: TMenuItem;
    N15minut1: TMenuItem;
    N10minut1: TMenuItem;
    N5minut1: TMenuItem;
    Jednostki1: TMenuItem;
    Pixele1: TMenuItem;
    Cale1: TMenuItem;
    Milimetry1: TMenuItem;
    Centymetry1: TMenuItem;
    Metry1: TMenuItem;
    Kilometry1: TMenuItem;
    Oprogramie2: TMenuItem;
    N2: TMenuItem;
    Zamknij1: TMenuItem;
    N3: TMenuItem;
    Aktualizujteraz1: TMenuItem;
    Aktualizujteraz2: TMenuItem;
    Pokazujoknopodczasuruchamiania1: TMenuItem;
    Pomoc1: TMenuItem;
    StronaWWW1: TMenuItem;
    tray: TImageList;
    postep: TProgressBar;
    Memo1: TRichEdit;
    Splitter1: TSplitter;
    PopupMenu2: TPopupMenu;
    Wyczy1: TMenuItem;
    procedure Wyczy1Click(Sender: TObject);
    procedure StronaWWW1Click(Sender: TObject);
    procedure Pokazujoknopodczasuruchamiania1Click(Sender: TObject);
    procedure Uruchamiajzstartemsystemu1Click(Sender: TObject);
    procedure Pixele1Click(Sender: TObject);
    procedure N5minut1Click(Sender: TObject);
    procedure N10minut1Click(Sender: TObject);
    procedure N15minut1Click(Sender: TObject);
    procedure N30minut1Click(Sender: TObject);
    procedure N1godzine1Click(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Zakcz1Click(Sender: TObject);
    procedure Konto1Click(Sender: TObject);
    procedure Wyzerujwynik1Click(Sender: TObject);
    procedure Oprogramie1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure CoolTrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CoolTrayIcon1MouseExit(Sender: TObject);
    procedure CoolTrayIcon1MouseEnter(Sender: TObject);
    procedure CoolTrayIcon1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations }
    FicheroM       : THandle;
    Compartido     : PCompartido;
    HandleDLL      : THandle;
    jednostki : word;
    HookOn,
    HookOff        : THookMouse;
    LastX, LastY  : Word;
    odleglosc : int64;
    za : integer;
    odlegloscCal : int64;
    last : word;
    sekundy : integer;
    Cal : integer;
    mm : integer;
    kliknietoLewe, kliknietoPrawe, kliknietoSrodkowy: integer;
    kliknietoLeweCal, kliknietoPraweCal, kliknietoSrodkowyCal : integer;
    ranga : string;
    procedure Staty;
    procedure log(t:string;C:TColor;Font:TFontStyles);
//    procedure ladujjezyk(s:string);
    procedure LlegaDelHook(var message: TMessage); message  CM_MANDA_DATOS;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  //rangi : array[0..9] of string;
implementation
uses password, about;
{$R *.dfm}
procedure TForm2.log(t:string;C:TColor;Font:TFontStyles);
begin
     Memo1.SelAttributes.Style := font;
     memo1.SelAttributes.Color := c;
     memo1.Lines.Add('['+TimeTostr(Now)+'] '+t);
end;
procedure TForm2.LlegaDelHook(var message: TMessage);
var
   DatosMouse     : PMouseHookStruct;
   NombreVentana  : array [0..200] of char;
   tempX : Word;
   tempY : Word;
begin
   with Compartido^ do
   begin
     if LastX+LastY = 0 then
     begin
          LastX := x;
          LastY := y;
          exit;
     end;
     if x < LastX then
     TempX := LastX - x else TempX := x - LastX;
     if y < LastY then
     TempY := LastY - y else TempY := y - LastY;
     odleglosc := odleglosc + TempX+TempY;
     odlegloscCal := odlegloscCal+ TempX+TempY;
     LastX := x;
     LastY := y;
   end;

   //GetWindowText(Compartido^.Ventana,@NombreVentana,200);
   //Label2.Caption:=NombreVentana;
   if (Message.wParam = WM_LBUTTONDOWN) then
   begin
        inc(kliknietoLewe);
        inc(kliknietoLeweCal);
   end;
   if (Message.wParam = WM_MBUTTONDOWN) then
   begin
        inc(Form2.kliknietoSrodkowy);
        inc(Form2.kliknietoSrodkowyCal);
   end;
   if (Message.wParam = WM_RBUTTONDOWN) then
   begin
        inc(Form2.kliknietoPrawe);
        inc(Form2.kliknietoPraweCal);
   end;
   {case Message.wParam of
     WM_LBUTTONDBLCLK     : Accion:='WM_LBUTTONDBLCLK  ';
     WM_LBUTTONDOWN	 : Accion:='WM_LBUTTONDOWN    ';
     WM_LBUTTONUP         : Accion:='WM_LBUTTONUP      ';
     WM_MBUTTONDBLCLK     : Accion:='WM_MBUTTONDBLCLK  ';
     WM_MBUTTONDOWN       : Accion:='WM_MBUTTONDOWN    ';
     WM_MBUTTONUP         : Accion:='WM_MBUTTONUP      ';
     WM_MOUSEMOVE         : Accion:='WM_MOUSEMOVE      ';
     WM_NCHITTEST         : Accion:='WM_NCHITTEST      ';
     WM_NCLBUTTONDBLCLK   : Accion:='WM_NCLBUTTONDBLCLK';
     WM_NCLBUTTONDOWN     : Accion:='WM_NCLBUTTONDOWN  ';
     WM_NCLBUTTONUP       : Accion:='WM_NCLBUTTONUP    ';
     WM_NCMBUTTONDBLCLK   : Accion:='WM_NCMBUTTONDBLCLK';
     WM_NCMBUTTONDOWN     : Accion:='WM_NCMBUTTONDOWN  ';
     WM_NCMBUTTONUP       : Accion:='WM_NCMBUTTONUP    ';
     WM_NCMOUSEMOVE       : Accion:='WM_NCMOUSEMOVE    ';
     WM_NCRBUTTONDBLCLK   : Accion:='WM_NCRBUTTONDBLCLK';
     WM_NCRBUTTONDOWN     : Accion:='WM_NCRBUTTONDOWN  ';
     WM_NCRBUTTONUP       : Accion:='WM_NCRBUTTONUP    ';
     WM_RBUTTONDBLCLK     : Accion:='WM_RBUTTONDBLCLK  ';
     WM_RBUTTONDOWN       : Accion:='WM_RBUTTONDOWN    ';
     WM_RBUTTONUP         : Accion:='WM_RBUTTONUP      ';
   end;}
   //Memo1.Lines.Append(Accion);
end;

{procedure TForm2.ladujjezyk(s:string);
var ini : tinifile;
begin
     {INI := TINIFile.Create(extractfilepath(application.ExeName)+'\'+s+'.lng');
     btnUP.Hint := INI.ReadString('Hints','btnUP', 'Zawsze na wierzchu');
     SpeedButton4.Hint :=  INI.ReadString('Hints','Clear', 'Wyzeruj');
     SpeedButton2.Hint :=  INI.ReadString('Hints','Options', 'Konfiguracja');
     SpeedButton1.Hint :=  INI.ReadString('Hints','About', 'O Programie');
     SpeedButton3.Hint :=  INI.ReadString('Hints','Exit', 'Zamknij');
     label2.Caption :=  INI.ReadString('Labels','Travel', 'Przejecha³eœ/aœ dziœ:');
     label9.Caption :=  INI.ReadString('Labels','Travel all', 'Przejecha³eœ/aœ ca³:');
     label10.Caption :=  INI.ReadString('Labels','Click', 'Klikniêto dziœ:');
     label11.Caption :=  INI.ReadString('Labels','Click all', 'Klikniêto ca³.:');
     label12.Caption :=  INI.ReadString('Labels','Click Left', 'Lewy przycisk:');
     label13.Caption :=  INI.ReadString('Labels','Click Right', 'Prawy przycisk:');
     label1.Caption :=  INI.ReadString('Labels','Click Middle', 'Œrodkowy przycisk:');
     label5.Caption :=  INI.ReadString('Labels','Rang', 'Ranga:');
     rangi[0] :=  INI.ReadString('Rangs','1', 'Nowicjusz');
     rangi[1] :=  INI.ReadString('Rangs','2', 'Amator');
     rangi[2] :=  INI.ReadString('Rangs','3', 'Pocz¹tkuj¹cy');
     rangi[3] :=  INI.ReadString('Rangs','4', 'Zdolniacha');
     rangi[4] :=  INI.ReadString('Rangs','5', 'Dobry');
     rangi[5] :=  INI.ReadString('Rangs','6', 'Bardzo Dobry');
     rangi[6] :=  INI.ReadString('Rangs','7', 'Zdolnyœ');
     rangi[7] :=  INI.ReadString('Rangs','8', 'Pogromca myszy');
     rangi[8] :=  INI.ReadString('Rangs','9', 'Pirat Drogowy');
     rangi[9] :=  INI.ReadString('Rangs','10', 'Obej¿yœwiat');
     INI.Free;
end; }

function PixeleNaCale(px:integer):Integer;
var s:single;
begin
     s := px/Form2.cal;
     result := Trunc(s);
end;
function PixeleNaKiloMetry(px:integer):string;
begin
     result := FormatFloat('0.00',(((px/Form2.mm)/10)/100)/1000);
end;
function procent(m,i : integer) : string;
begin
     result :=FormatFloat('0.00', (i*100)/m)+'%';
end;
function PixeleNaMetry(px:integer):string;
begin
     result := FormatFloat('0.00', ((px/Form2.mm)/10)/100);
end;
function PixeleNaCentymetry(px:integer):string;
begin
     result := FormatFloat('0.00',(px/Form2.mm)/10);
end;
function PixeleNaMilimetry(px:integer):string;
begin
     result := IntToStr(Round(px/Form2.mm)); // Troszkê niedok³adne ale to szczegó³
end;
function CzyXP : boolean;
var
   OS:TOsVersionInfo;
begin
     OS.dwOSVersionInfoSize:=SizeOf(os);
     GetVersionEx(os);
     if (os.dwMajorVersion = 5) and (os.dwMinorVersion = 1) then
     result := true else result := false;
end;
procedure TForm2.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;
begin
  inherited;
  if CzyXP then
  Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;
procedure TForm2.Staty;
var s, s2 : string;
    i : integer;
begin

     case jednostki of
      0:
      begin
          s := IntToStr(odleglosc)+ ' px';
          s2 := IntToStr(odlegloscCal)+ ' px';
      end;
      1:
      begin
          s := IntToStr(PixeleNaCale(odleglosc))+ ' cal';
          s2 := IntToStr(PixeleNaCale(odlegloscCal))+ ' cal';
      end;
      2:
      begin
          s := PixeleNaMilimetry(odleglosc)+ ' mm';
          s2 := PixeleNaMilimetry(odlegloscCal)+ ' mm';

      end;
      3:
      begin
          s := PixeleNaCentymetry(odleglosc)+ ' cm';
          s2 := PixeleNaCentymetry(odlegloscCal)+ ' cm';
      end;
      4:
      begin
          s := PixeleNaMetry(odleglosc)+ ' m';
          s2 := PixeleNaMetry(odlegloscCal)+ ' m';
      end;
      5:
      begin
          s := PixeleNaKiloMetry(odleglosc)+ ' km';
          s2 := PixeleNaKiloMetry(odlegloscCal)+ ' km';
      end;
     end;
     TreeView1.Items[1].Text := 'Przejechano dziœ: '+s;//przejechano
     TreeView1.Items[2].Text := 'Przejechano ca³.: '+s2;//przejechano ca³
     TreeView1.Items[5].Text := 'Klikniêto: '+intToStr(kliknietoLewe);//klik left
     TreeView1.Items[6].Text := 'Klikniêto ca³.: '+intToStr(kliknietoLeweCal);//klik left cal
     TreeView1.Items[8].Text := 'Klikniêto: '+intToStr(kliknietoPrawe);//klik left
     TreeView1.Items[9].Text := 'Klikniêto ca³.: '+intToStr(kliknietoPraweCal);//klik left cal
     TreeView1.Items[11].Text := 'Klikniêto: '+intToStr(kliknietoSrodkowy);//klik left
     TreeView1.Items[12].Text := 'Klikniêto ca³.: '+intToStr(kliknietoSrodkowyCal);//klik left cal
     i := kliknietoLeweCal+kliknietoPraweCal+kliknietoSrodkowyCal;
     TreeView1.Items[13].Text := 'Klikniêto ca³.: '+ inttostr(i);
    //kliknietoSrodkowy
     if kliknietoLewe = 0 then
     begin
      TreeView1.Items[4].Text := 'Lewy(--%)';
      exit;
     end;
     TreeView1.Items[4].Text := 'Lewy('+procent(kliknietoLewe+kliknietoPrawe+kliknietoSrodkowy, kliknietoLewe)+')';
     if kliknietoPrawe = 0 then
     begin
      TreeView1.Items[7].Text := 'Prawy(--%)';
      exit;
     end;
     TreeView1.Items[7].Text := 'Prawy('+procent(kliknietoLewe+kliknietoPrawe+kliknietoSrodkowy, kliknietoprawe)+')';//klik left %
     if kliknietoSrodkowy = 0 then
     begin
      TreeView1.Items[10].Text := 'Œrodkowy(--%)';
      exit;
     end;
     TreeView1.Items[10].Text := 'Œrodkowy('+procent(kliknietoLewe+kliknietoPrawe+kliknietoSrodkowy, kliknietoSrodkowy)+')';//klik left %
end;
procedure TForm2.FormCreate(Sender: TObject);
var ini : TDataFile;
    DC: HDC;
    hres,{vres}hsiz{vsiz}:integer;
    x{,y} : single;
begin
     log('Start Myszometra',clBlack,[fsBold]);
     CoolTrayIcon1.Icon := Application.Icon;
     INI := TDataFile.Create(extractfilepath(application.ExeName)+'\data.dat');//¯eby nikt nie zmienia³ sobie licznika
     //ladujjezyk('english');
     log('£adowanie opcji',clBlack,[]);
     odlegloscCal := INI.ReadInteger('O','w',0);
     kliknietoLeweCal := INI.ReadInteger('O','ik',0);
     kliknietoPraweCal:= INI.ReadInteger('O','kiss',0);
     kliknietoSrodkowyCal := INI.ReadInteger('O','kal',0);
     Form2.Left := INI.ReadInteger('Okno','Lewo',100);
     Form2.Top := INI.ReadInteger('Okno','Góra',100);
     Form2.width := INI.ReadInteger('Okno','ww',255);
     Form2.height := INI.ReadInteger('Okno','hh',382);

     //label7.Caption := DateToStr(INI.ReadDateTime('O','s', Now));
     //if INI.ReadDateTime('O','t',Now) = Now Then
     //odleglosc := INI.ReadInteger('O','g',0);
     if INI.ReadBoolean('kas','ed', true) then
     begin
          Uruchamiajzstartemsystemu1Click(self);
          INI.WriteBoolean('kas','ed', false);
     end;


     jednostki := INI.ReadInteger('Okno','INDEX',0);
     case jednostki of
      0:pixele1.Checked := true;
      1:cale1.Checked := true;
      2:Milimetry1.Checked := true;
      3:Centymetry1.Checked := true;
      4:Metry1.Checked := true;
      5:Kilometry1.Checked := true;
     end;
     Timer4.Interval := INI.ReadInteger('Okno','swder',3600000);
     case Timer4.Interval of
      3600000:N1godzine1.Checked := true;
      1800000:N30minut1.Checked := true;
      900000:N15minut1.Checked := true;
      600000:N10minut1.Checked := true;
      300000:N5minut1.Checked := true;
     end;
     za := Timer4.interval div 1000;
     Pokazujoknopodczasuruchamiania1.Checked := INI.ReadBoolean('kasek','eds', true);
     if INI.ReadBoolean('kasek','ed', true) then
     begin
          INI.WriteBoolean('kasek','ed', false);
          INI.Free;
          Konto1Click(self);
     end else INI.Free;
//     label8.Caption := TimeToStr(Now)+' - '+DateToStr(Now);
     cal := Screen.PixelsPerInch;
     Timer2Timer(self);
     DC := GetDC(0);
     hres := GetDeviceCaps(DC,HORZRES);
     //vres := GetDeviceCaps(DC,VERTRES);
     hsiz := GetDeviceCaps(DC,HORZSIZE);
     //vsiz := GetDeviceCaps(DC,VERTSIZE);
     ReleaseDC(0, DC);
     x := hres/hsiz;
     //y := vres/vsiz;
     //ShowMessage(FloatToStr(Trunc(x))+' '+FloatToStr(Trunc(y)));
     mm := Trunc(x);
     log('Zak³adanie hooka na mysz',clblue,[]);
     HandleDLL:=LoadLibrary( PChar(ExtractFilePath(Application.Exename)+
                                 NombreDLL ) );
     if HandleDLL = 0 then raise Exception.Create('Brak bibloteki DLL!');

     @HookOn :=GetProcAddress(HandleDLL, 'HookOn');
     @HookOff:=GetProcAddress(HandleDLL, 'HookOff');

     IF not assigned(HookOn) or
      not assigned(HookOff)  then
      raise Exception.Create('Nie ta wersja biblioteki DLL!');

     FicheroM:=CreateFileMapping( $FFFFFFFF,
                               nil,
                               PAGE_READWRITE,
                               0,
                               SizeOf(Compartido),
                               'ElReceptor');

     if FicheroM=0 then
      raise Exception.Create( 'B³¹d podczas tworzenia pliku');

     Compartido:=MapViewOfFile(FicheroM,FILE_MAP_WRITE,0,0,0);

     Compartido^.Receptor:=Handle;
     HookOn;

end;

procedure TForm2.FormDestroy(Sender: TObject);
var ini : TDataFile;
begin
    if Assigned(HookOff) then HookOff;
    if HandleDLL<>0 then
    FreeLibrary(HandleDLL);
    if FicheroM<>0 then
    begin
     UnmapViewOfFile(Compartido);
     CloseHandle(FicheroM);
    end;
     INI := TDataFile.Create(extractfilepath(application.ExeName)+'\data.dat');
     INI.WriteInteger('O','w',odlegloscCal);
     INI.WriteInteger('O','ik',kliknietoLeweCal);
     INI.WriteInteger('O','kiss',kliknietoPraweCal);
     INI.WriteInteger('O','kal',kliknietoSrodkowyCal);
     INI.WriteInteger('Okno','Lewo',Form2.Left);
     INI.WriteInteger('Okno','Góra',Form2.Top);
     INI.WriteInteger('Okno','ww',Form2.Width);
     INI.WriteInteger('Okno','hh',Form2.Height);
     INI.WriteInteger('Okno','INDEX',jednostki);
     INI.WriteBoolean('kasek','eds',Pokazujoknopodczasuruchamiania1.Checked);
     //INI.WriteInteger('O','g',odleglosc);
     //INI.WriteDate('O','t', NOW);
     //INI.WriteString('O','s', label7.Caption);
     INI.WriteInteger('Okno','swder',Timer4.Interval);
     INI.Free;

end;

procedure TForm2.Timer2Timer(Sender: TObject);
var s : string;
begin


     if odlegloscCal < 10000000 then
     begin
          s := 'Mysz zwyczajna';
     end
     else
     if odlegloscCal < 50000000 then
     begin
          s := 'Mysz biurkowa';
     end
     else
     if odlegloscCal < 80000000 then
     begin
          s := 'Mysz domowa';
     end
     else
     if odlegloscCal < 100000000 then
     begin
          s := 'Mysz skalna';
     end
     else
     if odlegloscCal < 300000000 then
     begin
          s := 'Mysz zaroœlowa';
     end
     else
     if odlegloscCal < 600000000 then
     begin
          s := 'Mysz polna';
     end
     else
     if odlegloscCal < 900000000 then
     begin
          s := 'Mysz leœna';
     end
     else
     if odlegloscCal < 1000000000 then
     begin
          s := 'Mysz drogowa';
     end
     else
     if odlegloscCal < 2000000000 then
     begin
          s := 'Mega Mysz';
     end
     else
     if odlegloscCal < 10000000000 then
     begin
          s := 'Super Mysz';
     end;
     TreeView1.Items[14].Text := 'Ranga: '+s;//ranga
     ranga := s;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin

      action := caNone;
      CoolTrayIcon1.HideMainForm;
end;

procedure TForm2.CoolTrayIcon1Click(Sender: TObject);
begin
    CoolTrayIcon1.showMainForm;
end;

procedure TForm2.CoolTrayIcon1MouseEnter(Sender: TObject);
begin
    //CoolTrayIcon1.Hint := 'Przejecha³eœ dziœ: '+Label3.Caption+#13+'Przejecha³eœ ca³.: '+Panel1.Caption+#13+'Klikniêto LMB/MMB/RMB: '+Panel2.Caption+'/'+Panel6.Caption+'/'+Panel4.Caption+#13+'Klikniêto ca³. LMB/MMB/RMB: '+Panel3.Caption+'/'+Panel7.Caption+'/'+Panel5.Caption;
    //CoolTrayIcon1.ShowBalloonHint('MyszoMeter',CoolTrayicon1.Hint,bitInfo,20);
end;

procedure TForm2.CoolTrayIcon1MouseExit(Sender: TObject);
begin
CoolTrayIcon1MouseEnter(self);
end;

procedure TForm2.CoolTrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
CoolTrayIcon1MouseEnter(self);
end;

procedure TForm2.Timer3Timer(Sender: TObject);
var
   min,sec:string;
   _min,_sec:integer;
begin

     if za = 0 then exit;
     dec(za);
     _min:=za div 60;
     _sec:=za-_min*60;
     min:=inttostr(_min);
     sec:=inttostr(_sec);
     if _min = 0 then
     TreeView1.Items[17].Text := 'Nastêpna aktualizacja za: '+sec +' sekund.'
     else TreeView1.Items[17].Text := 'Nastêpna aktualizacja za: '+min +' minut.';

end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
     if Form2.Visible then
     staty;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
     {case combobox1.ItemIndex of
     0:Timer1.Interval := 1;
     1:Timer1.Interval := 10;
     2:Timer1.Interval := 20;
     3:Timer1.Interval := 35;
     4:Timer1.Interval := 50;
     5:Timer1.Interval := 100;
     end;}
end;

procedure TForm2.Oprogramie1Click(Sender: TObject);
var AboutBox : TAboutBox;
begin
     AboutBox := TAboutBox.create(application);
     AboutBox.ShowModal;
     aboutbox.Free;
end;

procedure TForm2.Wyzerujwynik1Click(Sender: TObject);
begin
      case Application.MessageBox('Czy oby napewno chcesz wyzerowaæ licznik???','Uwaga', MB_YESNO) of
          idYES:
          begin
              log('Zerowanie licznika',clGray,[]);
              odlegloscCal := 0;
              odleglosc := 0;
              kliknietoLewe := 0;
              kliknietoPrawe := 0;
              kliknietoLeweCal := 0;
              kliknietoPraweCal := 0;
          end;
      end;
end;

procedure TForm2.Konto1Click(Sender: TObject);
var FrmLogin : TFrmLogin;
    ini : TDataFile;
begin
     FrmLogin := TFrmLogin.Create(Application);
     INI := TDataFile.Create(extractfilepath(application.ExeName)+'\data.dat');
     if (INI.ReadString('w','l', '')<>'') and (INI.ReadString('w','l', '')<> '') then
     begin
          FrmLogin.RadioButton3.Enabled := true;
          FrmLogin.ss := INI.ReadString('w','l', '');
          FrmLogin.sss := INI.ReadString('w','p', '');
     end;
     //FrmLogin.CheckBox1.Checked := INI.ReadBoolean('w','a', false);
     FrmLogin.ShowModal;
     if FRMLogin.Tag = 1 then
     begin
          INI.WriteString('w','l',FrmLogin.Edit1.Text);
          INI.WriteString('w','p',FrmLogin.sEdit1.Text);  //rejestracja
         // INI.WriteBoolean('w','a',FrmLogin.CheckBox1.Checked);
     end else
     if FRMLogin.Tag = 2 then
     begin
          INI.WriteString('w','l',FrmLogin.Edit4.Text);
          INI.WriteString('w','p',FrmLogin.Edit3.Text);  //logowanie
         // INI.WriteBoolean('w','a',FrmLogin.CheckBox1.Checked);
     end;
     FrmLogin.Free;
     INI.Free;

end;

procedure TForm2.Zakcz1Click(Sender: TObject);
begin
      case Application.MessageBox('Czy oby napewno chcesz zamkn¹æ aplikacjê???','Uwaga', MB_YESNO) of
          idYES:application.Terminate;
      end;
end;

procedure TForm2.Timer4Timer(Sender: TObject);
var MySQL: TSimpleMySQL;
    ini : TDataFile;
    s1, s2 : string;
begin
     log('Rozpoczynam Aktualizacjê',clGreen,[fsBold]);
     postep.Position := 0;
     INI := TDataFile.Create(extractfilepath(application.ExeName)+'\data.dat');
     postep.Position := 1;
     s1 := INI.ReadString('w','l', '');
     s2 := INI.ReadString('w','p', '');
     if (s1 = '') and (s2='') then
     begin
          log('Brak u¿ytkownika! Proszê siê zarejestrowaæ!',clRed,[fsBold]);
          INI.Free;
          exit;
     end;
     CoolTrayIcon1.IconList := tray;
     CoolTrayIcon1.CycleIcons := true;
     //FrmPostep.Hide;
     MySQL := TSimpleMySQL.Create;
     MySQL.Host := 'freesql.org';
     MySQL.User := 'myszometer';
     MySQL.Password := 'myszo12';
     postep.Position := 2;
     application.ProcessMessages;
     log('£¹czenie z serwerem...',clBlue,[]);
     if  mysql.connect = false then
     begin
          postep.Position := 0;
          log('Brak odpowiedzi serwera',clRed,[fsBold]);
          TreeView1.Items[16].Text := 'Ostatnia aktualizacja: B³¹d(Brak odpowiedzi serwera)';//ranga
          za := Timer4.interval div 1000;
          CoolTrayIcon1.CycleIcons := false;
          CoolTrayIcon1.IconList := nil;
          CoolTrayIcon1.Icon := Application.Icon;
          postep.Position := 0;
          INI.Free;
          exit;
     end;
     log('Nawi¹zano po³¹czenie...',clGreen,[fsUnderLine]);
     postep.Position := 3;
     MySQL.SelectDatabase('myszometer');
     application.ProcessMessages;
     postep.Position := 4;
     log('Wyszukiwanie u¿ytkownika...',clBlack,[]);
     MySQL.Query('select * from myszometer where user="'+s1+'" and pass=PASSWORD('+s2+');');
     application.ProcessMessages;
     postep.Position := 5;
     if MySQL.QueryResult.RowsCount =0 then
     begin
         log('Aktualizacja wyników...',clBlack,[]);
         application.ProcessMessages;
         postep.Position := 6;
         MySQL.Query('update myszometer set klikniec="'+IntToStr(kliknietoLeweCal+kliknietoPraweCal+kliknietoSrodkowyCal)+'" where user="'+s1+'";');
         postep.Position := 7;
         application.ProcessMessages;
         MySQL.Query('update myszometer set klikniec_lewy="'+IntToStr(kliknietoLeweCal)+'" where user="'+s1+'";');
         postep.Position := 8;
         application.ProcessMessages;
         MySQL.Query('update myszometer set klikniec_prawy="'+IntToStr(kliknietoPraweCal)+'" where user="'+s1+'";');
         application.ProcessMessages;
         postep.Position := 9;
         MySQL.Query('update myszometer set klikniec_srodkowy="'+IntToStr(kliknietoSrodkowyCal)+'" where user="'+s1+'";');
         application.ProcessMessages;
         postep.Position := 10;
         MySQL.Query('update myszometer set ranga="'+ranga+'" where user="'+s1+'";');
         application.ProcessMessages;
         postep.Position := 11;
         MySQL.Query('update myszometer set przejechane_px="'+IntToStr(odlegloscCal)+'" where user="'+s1+'";');
         application.ProcessMessages;
         postep.Position := 12;
         MySQL.Query('update myszometer set przejechane_cale="'+IntToStr(PixeleNaCale(odlegloscCal))+'" where user="'+s1+'";');
         application.ProcessMessages;
         postep.Position := 13;
         MySQL.Query('update myszometer set przejechane_mm="'+PixeleNaMetry(odlegloscCal)+'" where user="'+s1+'";');
         application.ProcessMessages;
         postep.Position := 14;
         MySQL.Query('update myszometer set przejechane_cm="'+PixeleNaCentyMetry(odlegloscCal)+'" where user="'+s1+'";');
         application.ProcessMessages;
         postep.Position := 15;
         MySQL.Query('update myszometer set przejechane_m="'+PixeleNaMetry(odlegloscCal)+'" where user="'+s1+'";');
         application.ProcessMessages;
         postep.Position := 16;
         MySQL.Query('update myszometer set przejechane_km="'+PixeleNaKilometry(odlegloscCal)+'" where user="'+s1+'";');
     end else log('Brak u¿ytkownika! Proszê siê zarejestrowaæ!',clRed,[fsBold]);
     postep.Position := 17;
     MySQl.Free;
     TreeView1.Items[16].Text := 'Ostatnia aktualizacja: '+TimeToStr(Now);//ranga
     za := Timer4.interval div 1000;
     INI.Free;
     CoolTrayIcon1.CycleIcons := false;
     CoolTrayIcon1.IconList := nil;
     CoolTrayIcon1.Icon := Application.Icon;
     postep.Position := 0;
     //log('Aktualizacja zak¹czona...',clGray,[fsUnderLine]);
end;

procedure TForm2.N1godzine1Click(Sender: TObject);
begin
     timer4.Interval := 3600000;
     za := Timer4.interval div 1000;
     TMenuItem(sender).Checked := true;
end;

procedure TForm2.N30minut1Click(Sender: TObject);
begin
    timer4.Interval := 1800000;
    za := Timer4.interval div 1000;
    TMenuItem(sender).Checked := true;
end;

procedure TForm2.N15minut1Click(Sender: TObject);
begin
     timer4.Interval :=900000;
     za := Timer4.interval div 1000;
     TMenuItem(sender).Checked := true;
end;

procedure TForm2.N10minut1Click(Sender: TObject);
begin
     timer4.Interval := 600000;
     za := Timer4.interval div 1000;
     TMenuItem(sender).Checked := true;
end;

procedure TForm2.N5minut1Click(Sender: TObject);
begin
     timer4.Interval :=300000;
     za := Timer4.interval div 1000;
     TMenuItem(sender).Checked := true;
end;

procedure TForm2.Pixele1Click(Sender: TObject);
begin
      jednostki := TMenuItem(Sender).Tag;
      TMenuItem(sender).Checked := true;
end;

procedure TForm2.Uruchamiajzstartemsystemu1Click(Sender: TObject);
var Reg : TRegistry;
begin
      if Application.MessageBox('Czy chcesz aby myszometr uruchamia³ siê podczas startu systemu???','Uwaga', MB_YESNO) = idYES then
      begin
           Reg := TRegistry.Create;
           if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\', true) then
           begin
                reg.WriteString('Myszometer',application.ExeName);
           end;
           Reg.Free;
      end;
end;

procedure TForm2.Pokazujoknopodczasuruchamiania1Click(Sender: TObject);
begin
      TMenuItem(sender).Checked := not TMenuItem(sender).Checked;
end;

procedure TForm2.StronaWWW1Click(Sender: TObject);
begin
    ShellExecute(Handle,'open',PChar('http://dcm.ar-net.eu/myszometer/'),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm2.Wyczy1Click(Sender: TObject);
begin
     Memo1.Lines.Clear;
end;

end.
