library HookMouse;
uses
  Windows,
  Messages;

const
  CM_MANDA_DATOS = WM_USER + $1000;

 type
  TCompartido = record
    Receptor,
    wHitTestCode,
    x,y,
    Ventana         : hwnd;
  end;
  PCompartido   =^TCompartido;


 var
  HookDeMouse  : HHook;
  FicheroM     : THandle;
  Compartido   : PCompartido;


 function CallBackDelHook( Code    : Integer;
                           wParam  : WPARAM;
                           lParam  : LPARAM
                           )       : LRESULT; stdcall;

 var
   DatosMouse     : PMouseHookStruct;
   Intentos       : integer;


 begin

  if code=HC_ACTION then
  begin

   FicheroM:=OpenFileMapping(FILE_MAP_WRITE,False,'ElReceptor');

   if FicheroM<>0 then
   begin
     Compartido:=MapViewOfFile(FicheroM,FILE_MAP_WRITE,0,0,0);

     DatosMouse:=Pointer(lparam);

     Compartido^.Ventana:=DatosMouse^.hwnd;
     Compartido^.x:=DatosMouse^.pt.x;
     Compartido^.y:=DatosMouse^.pt.y;

     PostMessage(Compartido^.Receptor,CM_MANDA_DATOS,wParam,lParam);

     UnmapViewOfFile(Compartido);
     CloseHandle(FicheroM);
   end;
  end;

  Result := CallNextHookEx(HookDeMouse, Code, wParam, lParam)
 end;

 procedure HookOn; stdcall;
 begin
   HookDeMouse:=SetWindowsHookEx(WH_MOUSE, @CallBackDelHook, HInstance , 0);
 end;


 procedure HookOff;  stdcall;
 begin

   UnhookWindowsHookEx(HookDeMouse);
 end;

 exports

  HookOn,
  HookOff;

 begin
 end.
