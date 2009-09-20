unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, shellapi;

type
  TAboutBox = class(TForm)
    Label2: TLabel;
    Button1: TButton;
    Copyright: TLabel;
    Version: TLabel;
    ProductName: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Bevel1: TBevel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    procedure Label11Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label6MouseLeave(Sender: TObject);
    procedure Label6MouseEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.Label5MouseEnter(Sender: TObject);
begin
     TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
end;

procedure TAboutBox.Label5MouseLeave(Sender: TObject);
begin
     TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
end;

procedure TAboutBox.Label5Click(Sender: TObject);
begin
     //TLabel(Sender).Caption;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
      Image1.Picture.Icon.Assign(Application.Icon);
end;

procedure TAboutBox.Label6MouseEnter(Sender: TObject);
begin
     TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
end;

procedure TAboutBox.Label6MouseLeave(Sender: TObject);
begin
     TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
end;

procedure TAboutBox.Label6Click(Sender: TObject);
begin
    ShellExecute(Handle,'open',PChar('mailto:'+TLabel(Sender).Hint),nil,nil,SW_SHOWNORMAL);
end;

procedure TAboutBox.Label11Click(Sender: TObject);
begin
     ShellExecute(Handle,'open',PChar(TLabel(Sender).Hint),nil,nil,SW_SHOWNORMAL);
end;

end.

