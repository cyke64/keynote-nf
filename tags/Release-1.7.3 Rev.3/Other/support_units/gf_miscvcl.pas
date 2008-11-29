unit gf_miscvcl;
{$I gf_base.inc}

(* ************************************************************
 MOZILLA PUBLIC LICENSE STATEMENT
 -----------------------------------------------------------
 The contents of this file are subject to the Mozilla Public
 License Version 1.1 (the "License"); you may not use this file
 except in compliance with the License. You may obtain a copy of
 the License at http://www.mozilla.org/MPL/

 Software distributed under the License is distributed on an "AS
 IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 implied. See the License for the specific language governing
 rights and limitations under the License.

 The Original Code is "gf_URLParser.pas".

 The Initial Developer of the Original Code is Marek Jedlinski
 <eristic@lodz.pdi.net> (Poland).
 Portions created by Marek Jedlinski are
 Copyright (C) 2000, 2001. All Rights Reserved.
 -----------------------------------------------------------
 Contributor(s):
 -----------------------------------------------------------
 History:
 -----------------------------------------------------------
 To do:
 -----------------------------------------------------------
 Released: 20 August 2001
 -----------------------------------------------------------
 URLs:

 - original author's software site:
 http://www.lodz.pdi.net/~eristic/free/index.html
 http://go.to/generalfrenetics

 Email addresses (at least one should be valid)
 <eristic@lodz.pdi.net>
 <cicho@polbox.com>
 <cicho@tenbit.pl>

************************************************************ *)

interface
uses Forms, Classes, SysUtils,
     Controls, FileCtrl, Dialogs,
     Windows, StdCtrls, Clipbrd,
     ShellAPI, Messages;


function ClipboardAsString : string;
function FirstLineFromClipboard( const MaxLen : integer ) : string;


Procedure PostKeyEx32( key: Word; Const shift: TShiftState;
            specialkey: Boolean );

Procedure PostKeyEx( hWindow: HWnd; key: Word; Const shift:
            TShiftState; specialkey: Boolean );

function CheckDir( const aDir : string; const AutoCreate : boolean ) : boolean;

procedure SleepWell( const TenthsOfSecond : cardinal );
function VerdanaInstalled : boolean;
function TahomaInstalled : boolean;
function PopUpMessage( const mStr : string; const mType : TMsgDlgType; const mButtons : TMsgDlgButtons; const mHelpCtx : integer ) : word;
Function DefMessageDlg(const aCaption: String;
                       const Msg: string;
                       DlgType: TMsgDlgType;
                       Buttons: TMsgDlgButtons;
                       DefButton: Integer;
                       HelpCtx: Longint): Integer;

var
  _TahomaFontInstalled : boolean = false;

implementation

procedure SleepWell( const TenthsOfSecond : cardinal );
var
  TargetTicks : cardinal;
begin
  TargetTicks := GetTickCount+(100*TenthsOfSecond);
  while (TargetTicks-GetTickCount) >  0 do begin
    sleep(100); // Check for updates 10 times a second.
    Application.ProcessMessages;
  end;
end; // SleepWell

Function DefMessageDlg(const aCaption: String;
                       const Msg: string;
                       DlgType: TMsgDlgType;
                       Buttons: TMsgDlgButtons;
                       DefButton: Integer;
                       HelpCtx: Longint): Integer;
// code by Peter Below (TeamB)
Var
  i: Integer;
  btn: TButton;
Begin
  With CreateMessageDialog(Msg, DlgType, Buttons) Do
  try
    Caption := aCaption;
    HelpContext := HelpCtx;
    For i := 0 To ComponentCount-1 Do Begin
      If Components[i] Is TButton Then Begin
        btn := TButton(Components[i]);
        btn.Default := btn.ModalResult = DefButton;
        If btn.Default Then
          ActiveControl := Btn;
      End;
    End; { For }
    Result := ShowModal;
  finally
    Free;
  end;
End; // DefMessageDlg

function VerdanaInstalled : boolean;
var
   i : integer;
begin
  { look BACKWARDS, because the string 'Verdana'
  will be closer to the end of the font list, so
  we will find it faster by looking from the end }
  result := false;
  for i := pred( screen.fonts.count ) downto 0 do
    if ( screen.fonts[i] = 'Verdana' ) then
    begin
      result := true;
      break;
    end;
end; // VerdanaInstalled

function TahomaInstalled : boolean;
var
   i : integer;
begin
  { look BACKWARDS, because the string 'Verdana'
  will be closer to the end of the font list, so
  we will find it faster by looking from the end }
  result := false;
  for i := pred( screen.fonts.count ) downto 0 do
    if ( screen.fonts[i] = 'Tahoma' ) then
    begin
      result := true;
      break;
    end;
end; // TahomaInstalled

function PopUpMessage( const mStr : string; const mType : TMsgDlgType; const mButtons : TMsgDlgButtons; const mHelpCtx : integer ) : word;
// Like MessageDlg, but brings application window to front before
// displaying the message, and minimizes application if it was
// minimized before the message was shown.
var
  wasiconic : boolean;
begin
  wasiconic := ( IsIconic(Application.Handle) = TRUE );
  if wasiconic then
    Application.Restore;
  Application.BringToFront;
  result := messagedlg( mStr, mType, mButtons, mHelpCtx );
  if wasiconic then
    Application.Minimize;
end; // PopUpMessage


{************************************************************
 * Procedure PostKeyEx32
 *
 * Parameters:
 *  key    : virtual keycode of the key to send. For printable
 *           keys this is simply the ANSI code (Ord(character)).
 *  shift  : state of the modifier keys. This is a set, so you
 *           can set several of these keys (shift, control, alt,
 *           mouse buttons) in tandem. The TShiftState type is
 *           declared in the Classes Unit.
 *  specialkey: normally this should be False. Set it to True to
 *           specify a key on the numeric keypad, for example.
 * Description:
 *  Uses keybd_event to manufacture a series of key events matching
 *  the passed parameters. The events go to the control with focus.
 *  Note that for characters key is always the upper-case version of
 *  the character. Sending without any modifier keys will result in
 *  a lower-case character, sending it with [ssShift] will result
 *  in an upper-case character!
 *Created: 17.7.98 by P. Below
 ************************************************************}
Procedure PostKeyEx32( key: Word; Const shift: TShiftState;
                     specialkey: Boolean );
  Type
    TShiftKeyInfo = Record
                      shift: Byte;
                      vkey : Byte;
                    End;
    byteset = Set of 0..7;
  Const
    shiftkeys: Array [1..3] of TShiftKeyInfo =
      ((shift: Ord(ssCtrl); vkey: VK_CONTROL ),
       (shift: Ord(ssShift); vkey: VK_SHIFT ),
       (shift: Ord(ssAlt); vkey: VK_MENU ));
  Var
    flag: DWORD;
    bShift: ByteSet absolute shift;
    i: Integer;
  Begin
    For i := 1 To 3 Do Begin
      If shiftkeys[i].shift In bShift Then
        keybd_event( shiftkeys[i].vkey,
                     MapVirtualKey(shiftkeys[i].vkey, 0),
                     0, 0);
    End; { For }
    If specialkey Then
      flag := KEYEVENTF_EXTENDEDKEY
    Else
      flag := 0;

    keybd_event( key, MapvirtualKey( key, 0 ), flag, 0 );
    flag := flag or KEYEVENTF_KEYUP;
    keybd_event( key, MapvirtualKey( key, 0 ), flag, 0 );

    For i := 3 DownTo 1 Do Begin
      If shiftkeys[i].shift In bShift Then
        keybd_event( shiftkeys[i].vkey,
                     MapVirtualKey(shiftkeys[i].vkey, 0),
                     KEYEVENTF_KEYUP, 0);
    End; { For }
  End; { PostKeyEx32 }


{************************************************************
 * Procedure PostKeyEx
 *
 * Parameters:
 *  hWindow: target window to be send the keystroke
 *  key    : virtual keycode of the key to send. For printable
 *           keys this is simply the ANSI code (Ord(character)).
 *           For letters alsways use the upper-case version!
 *  shift  : state of the modifier keys. This is a set, so you
 *           can set several of these keys (shift, control, alt,
 *           mouse buttons) in tandem. The TShiftState type is
 *           declared in the Classes Unit.
 *  specialkey: normally this should be False. Set it to True to
 *           specify a key on the numeric keypad, for example.
 *           If this parameter is true, bit 24 of the lparam for
 *           the posted WM_KEY* messages will be set.
 * Description:
 *  This procedure sets up Windows key state array to correctly
 *  reflect the requested pattern of modifier keys and then posts
 *  a WM_KEYDOWN/WM_KEYUP message pair to the target window. Then
 *  Application.ProcessMessages is called to process the messages
 *  before the keyboard state is restored.
 * Error Conditions:
 *  May fail due to lack of memory for the two key state buffers.
 *  Will raise an exception in this case.
 * NOTE:
 *  Setting the keyboard state will not work across applications
 *  running in different memory spaces on Win32.
 *Created: 02/21/96 16:39:00 by P. Below
 ************************************************************}
Procedure PostKeyEx( hWindow: HWnd; key: Word; Const shift:
    TShiftState; specialkey: Boolean );
Type
  TBuffers = Array [0..1] of TKeyboardState;
Var
  pKeyBuffers : ^TBuffers;
  lparam: cardinal;
Begin
  (* check if the target window exists *)
  If IsWindow(hWindow) Then Begin
    (* set local variables to default values *)
    pKeyBuffers := Nil;
    lparam := MakeLong(0, MapVirtualKey(key, 0));

    (* modify lparam if special key requested *)
    If specialkey Then
      lparam := lparam or $1000000;

    (* allocate space for the key state buffers *)
    New(pKeyBuffers);
    try
      (* Fill buffer 1 with current state so we can later restore it.
         Null out buffer 0 to get a "no key pressed" state. *)
      GetKeyboardState( pKeyBuffers^[1] );
      FillChar(pKeyBuffers^[0], Sizeof(TKeyboardState), 0);

      (* set the requested modifier keys to "down" state in the buffer
*)
      If ssShift In shift Then
        pKeyBuffers^[0][VK_SHIFT] := $80;
      If ssAlt In shift Then Begin
        (* Alt needs special treatment since a bit in lparam needs also
be set *)
        pKeyBuffers^[0][VK_MENU] := $80;
        lparam := lparam or $20000000;
      End;
      If ssCtrl In shift Then
        pKeyBuffers^[0][VK_CONTROL] := $80;
      If ssLeft In shift Then
        pKeyBuffers^[0][VK_LBUTTON] := $80;
      If ssRight In shift Then
        pKeyBuffers^[0][VK_RBUTTON] := $80;
      If ssMiddle In shift Then
        pKeyBuffers^[0][VK_MBUTTON] := $80;

      (* make out new key state array the active key state map *)
      SetKeyboardState( pKeyBuffers^[0] );

      (* post the key messages *)
      If ssAlt In Shift Then Begin
        PostMessage( hWindow, WM_SYSKEYDOWN, key, lparam);
        PostMessage( hWindow, WM_SYSKEYUP, key, lparam or $C0000000);
      End
      Else Begin
        PostMessage( hWindow, WM_KEYDOWN, key, lparam);
        PostMessage( hWindow, WM_KEYUP, key, lparam or $C0000000);
      End;
      (* process the messages *)
      Application.ProcessMessages;

      (* restore the old key state map *)
      SetKeyboardState( pKeyBuffers^[1] );
    finally
      (* free the memory for the key state buffers *)
      If pKeyBuffers <> Nil Then
        Dispose( pKeyBuffers );
    End; { If }
  End;
End; { PostKeyEx }

function CheckDir( const aDir : string; const AutoCreate : boolean ) : boolean;
var
  io : integer;
begin
  result := DirectoryExists( aDir );
  if (( not result ) and AutoCreate )then
  begin
    if ( messagedlg( 'Directory does not exist:' +#13+
      aDir +#13+ 'Attempt to create directory?', mtError, [mbYes,mbNo], 0 ) = mrYes ) then
      begin
        {$I-}
        mkdir( aDir );
        io := IOResult;
        {$I+}
        result := ( io = 0 );
        if result then
          messagedlg( 'Directory successfully created.', mtInformation, [mbOK], 0 )
        else
          messagedlg( 'Failed to create directory. Error code: ' + inttostr( io ), mtError, [mbOK], 0 );
      end;
  end;
end; // CheckDir


function ClipboardAsString : string;
begin
  if ( Clipboard.HasFormat( CF_TEXT )) then
    result := Clipboard.AsText
  else
    result := '';
end; // ClipboardAsString

function FirstLineFromClipboard( const MaxLen : integer ) : string;
var
  i, l, max : integer;
begin
  result := trimleft( ClipboardAsString );
  l := length( result );
  if ( l > 0 ) then
  begin
    if ( MaxLen < l ) then
      max := MaxLen
    else
      max := l;
    for i := 1 to max do
    begin
      if ( result[i] < #32 ) then
      begin
        delete( result, i, l );
        break;
      end;
    end;
  end;
end; // FirstLineFromClipboard


end.




