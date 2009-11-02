{*******************************************************}
{                                                       }
{         Delphi VCL Extensions (RX)                    }
{                                                       }
{         Copyright (c) 1995, 1996 AO ROSNO             }
{         Copyright (c) 1997, 1998 Master-Bank          }
{                                                       }
{*******************************************************}

unit RxCombos;

{.$DEFINE GXE}
{ Activate this define to use RxCombos in the GXExplorer Open Source project }

{$I RX.INC}
{$W-,T-}

interface

uses {$IFDEF WIN32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF}
  Messages, Classes, Controls, Graphics, StdCtrls, Forms, Menus;

type

{ TOwnerDrawComboBox }

  TOwnerDrawComboStyle = csDropDown..csDropDownList;

  TOwnerDrawComboBox = class(TCustomComboBox)
  private
    FStyle: TOwnerDrawComboStyle;
    FItemHeightChanging: Boolean;
    procedure SetComboStyle(Value: TOwnerDrawComboStyle);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
{$IFDEF WIN32}
    procedure CMRecreateWnd(var Message: TMessage); message CM_RECREATEWND;
{$ENDIF}
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure ResetItemHeight;
    function MinItemHeight: Integer; virtual;
    property Style: TOwnerDrawComboStyle read FStyle write SetComboStyle
      default csDropDownList;
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ TColorComboBox }

  TColorComboBox = class(TOwnerDrawComboBox)
  private
    FColorValue: TColor;
    FDisplayNames: Boolean;
    FColorNames: TStrings;
    FOnChange: TNotifyEvent;
    function GetColorValue: TColor;
    procedure SetColorValue(NewValue: TColor);
    procedure SetDisplayNames(Value: Boolean);
    procedure SetColorNames(Value: TStrings);
    procedure ColorNamesChanged(Sender: TObject);
  protected
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure Click; override;
    procedure Change; override;
    procedure PopulateList; virtual;
    procedure DoChange; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Text;
  published
    property ColorValue: TColor read GetColorValue write SetColorValue
      default clBlack;
    property ColorNames: TStrings read FColorNames write SetColorNames;
    property DisplayNames: Boolean read FDisplayNames write SetDisplayNames
      default True;
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property Enabled;
    property Font;
{$IFDEF RX_D4}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
{$ENDIF}
{$IFDEF WIN32}
  {$IFNDEF VER90}
    property ImeMode;
    property ImeName;
  {$ENDIF}
{$ENDIF}
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
{$IFDEF WIN32}
    property OnStartDrag;
{$ENDIF}
{$IFDEF RX_D5}
    property OnContextPopup;
{$ENDIF}
{$IFDEF RX_D4}
    property OnEndDock;
    property OnStartDock;
{$ENDIF}
  end;

{ TFontComboBox }

  TFontDevice = (fdScreen, fdPrinter, fdBoth);
  TFontListOption = (foAnsiOnly, foTrueTypeOnly, foFixedPitchOnly,
    foNoOEMFonts, foOEMFontsOnly, foScalableOnly, foNoSymbolFonts);
  TFontListOptions = set of TFontListOption;

  TFontComboBox = class(TOwnerDrawComboBox)
  private
    FTrueTypeBMP: TBitmap;
    FDeviceBMP: TBitmap;
    FOnChange: TNotifyEvent;
    FDevice: TFontDevice;
    FUpdate: Boolean;
    FUseFonts: Boolean;
    FOptions: TFontListOptions;
    procedure SetFontName(const NewFontName: TFontName);
    function GetFontName: TFontName;
    function GetTrueTypeOnly: Boolean;
    procedure SetDevice(Value: TFontDevice);
    procedure SetOptions(Value: TFontListOptions);
    procedure SetTrueTypeOnly(Value: Boolean);
    procedure SetUseFonts(Value: Boolean);
    procedure Reset;
    procedure WMFontChange(var Message: TMessage); message WM_FONTCHANGE;
  protected
    procedure PopulateList; virtual;
    procedure Change; override;
    procedure Click; override;
    procedure DoChange; dynamic;
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    function MinItemHeight: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Text;
  published
    property Device: TFontDevice read FDevice write SetDevice default fdScreen;
    property FontName: TFontName read GetFontName write SetFontName;
    property Options: TFontListOptions read FOptions write SetOptions default [];
    property TrueTypeOnly: Boolean read GetTrueTypeOnly write SetTrueTypeOnly
      stored False; { obsolete, use Options instead }
    property UseFonts: Boolean read FUseFonts write SetUseFonts default False;
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property Enabled;
    property Font;
    property DropDownCount;
{$IFDEF RX_D4}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
{$ENDIF}
{$IFDEF WIN32}
  {$IFNDEF VER90}
    property ImeMode;
    property ImeName;
  {$ENDIF}
{$ENDIF}
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
{$IFDEF WIN32}
    property OnStartDrag;
{$ENDIF}
{$IFDEF RX_D5}
    property OnContextPopup;
{$ENDIF}
{$IFDEF RX_D4}
    property OnEndDock;
    property OnStartDock;
{$ENDIF}
  end;

{$IFDEF GXE}
procedure Register;
{$ENDIF}

implementation

{$IFDEF WIN32}
 {$R *.R32}
{$ELSE}
 {$R *.R16}
{$ENDIF}

uses SysUtils, Printers {$IFNDEF GXE}, VCLUtils {$ENDIF};

{$IFDEF GXE}
procedure Register;
begin
  RegisterComponents('Additional', [TFontComboBox, TColorComboBox]);
end;
{$ENDIF GXE}

{$IFNDEF WIN32}
type
  DWORD = Longint;
{$ENDIF}

{ Utility routines }

function CreateBitmap(ResName: PChar): TBitmap;
begin
{$IFDEF GXE}
  Result := TBitmap.Create;
  Result.Handle := LoadBitmap(HInstance, ResName);
{$ELSE}
  Result := MakeModuleBitmap(HInstance, ResName);
  if Result = nil then ResourceNotFound(ResName);
{$ENDIF GXE}
end;

function GetItemHeight(Font: TFont): Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  try
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;
  Result := Metrics.tmHeight + 1;
end;

{ TOwnerDrawComboBox }

constructor TOwnerDrawComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Style := csDropDownList;
  FStyle := csDropDownList;
end;

procedure TOwnerDrawComboBox.SetComboStyle(Value: TOwnerDrawComboStyle);
begin
  if FStyle <> Value then begin
    FStyle := Value;
    inherited Style := Value;
  end;
end;

function TOwnerDrawComboBox.MinItemHeight: Integer;
begin
  Result := GetItemHeight(Font);
  if Result < 9 then Result := 9;
end;

procedure TOwnerDrawComboBox.ResetItemHeight;
var
  H: Integer;
begin
  H := MinItemHeight;
  FItemHeightChanging := True;
  try
    inherited ItemHeight := H;
  finally
    FItemHeightChanging := False;
  end;
  if HandleAllocated then SendMessage(Handle, CB_SETITEMHEIGHT, 0, H);
end;

procedure TOwnerDrawComboBox.CreateParams(var Params: TCreateParams);
const
  ComboBoxStyles: array[TOwnerDrawComboStyle] of DWORD =
    (CBS_DROPDOWN, CBS_SIMPLE, CBS_DROPDOWNLIST);
begin
  inherited CreateParams(Params);
  with Params do
    Style := (Style and not CBS_DROPDOWNLIST) or CBS_OWNERDRAWFIXED or
      ComboBoxStyles[FStyle];
end;

procedure TOwnerDrawComboBox.CreateWnd;
begin
  inherited CreateWnd;
  ResetItemHeight;
end;

procedure TOwnerDrawComboBox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ResetItemHeight;
  RecreateWnd;
end;

{$IFDEF WIN32}
procedure TOwnerDrawComboBox.CMRecreateWnd(var Message: TMessage);
begin
  if not FItemHeightChanging then
    inherited;
end;
{$ENDIF}

{ TColorComboBox }

const
  ColorsInList = 16;
  ColorValues: array [0..ColorsInList - 1] of TColor = (
    clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray,
    clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clWhite);

constructor TColorComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorValue := clBlack;  { make default color selected }
  FColorNames := TStringList.Create;
  TStringList(FColorNames).OnChange := ColorNamesChanged;
  FDisplayNames := True;
end;

destructor TColorComboBox.Destroy;
begin
  TStringList(FColorNames).OnChange := nil;
  FColorNames.Free;
  FColorNames := nil;
  inherited Destroy;
end;

procedure TColorComboBox.CreateWnd;
begin
  inherited CreateWnd;
  PopulateList;
  SetColorValue(FColorValue);
end;

procedure TColorComboBox.PopulateList;
var
  I: Integer;
  ColorName: string;
begin
  Items.BeginUpdate;
  try
    Clear;
    for I := 0 to Pred(ColorsInList) do begin
      if (I <= Pred(FColorNames.Count)) and (FColorNames[I] <> '') then
        ColorName := FColorNames[I]
      else
        { delete two first characters which prefix "cl" educated }
        ColorName := Copy(ColorToString(ColorValues[I]), 3, MaxInt);
      Items.AddObject(ColorName, TObject(ColorValues[I]));
    end;
  finally
    Items.EndUpdate;
  end;
end;

procedure TColorComboBox.ColorNamesChanged(Sender: TObject);
begin
  if HandleAllocated then begin
    FColorValue := ColorValue;
    RecreateWnd;
  end;
end;

procedure TColorComboBox.SetColorNames(Value: TStrings);
begin
  FColorNames.Assign(Value);
end;

procedure TColorComboBox.SetDisplayNames(Value: Boolean);
begin
  if DisplayNames <> Value then begin
    FDisplayNames := Value;
    Invalidate;
  end;
end;

function TColorComboBox.GetColorValue: TColor;
var
  I: Integer;
begin
  Result := FColorValue;
  if (Style <> csDropDownList) and (ItemIndex < 0) then begin
    I := Items.IndexOf(inherited Text);
    if I >= 0 then Result := TColor(Items.Objects[I])
    else begin
      Val(inherited Text, Result, I);
      if I <> 0 then Result := FColorValue;
    end;
  end;
end;

procedure TColorComboBox.SetColorValue(NewValue: TColor);
var
  Item: Integer;
  CurrentColor: TColor;
  S: string;
begin
  if (ItemIndex < 0) or (NewValue <> FColorValue) then begin
    FColorValue := NewValue;
    { change selected item }
    for Item := 0 to Pred(Items.Count) do begin
      CurrentColor := TColor(Items.Objects[Item]);
      if CurrentColor = NewValue then begin
        if ItemIndex <> Item then ItemIndex := Item;
        DoChange;
        Exit;
      end;
    end;
    if Style = csDropDownList then
      ItemIndex := -1
    else begin
      S := ColorToString(NewValue);
      if Pos('cl', S) = 1 then System.Delete(S, 1, 2);
      inherited Text := S;
    end;
    DoChange;
  end;
end;

procedure TColorComboBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
const
  ColorWidth = 22;
var
  ARect: TRect;
  Text: array[0..255] of Char;
  Safer: TColor;
begin
  ARect := Rect;
  Inc(ARect.Top, 2);
  Inc(ARect.Left, 2);
  Dec(ARect.Bottom, 2);
  if FDisplayNames then ARect.Right := ARect.Left + ColorWidth
  else Dec(ARect.Right, 3);
  with Canvas do begin
    FillRect(Rect);
    Safer := Brush.Color;
    Pen.Color := clWindowText;
    Rectangle(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
    Brush.Color := TColor(Items.Objects[Index]);
    try
      InflateRect(ARect, -1, -1);
      FillRect(ARect);
    finally
      Brush.Color := Safer;
    end;
    if FDisplayNames then begin
      StrPCopy(Text, Items[Index]);
      Rect.Left := Rect.Left + ColorWidth + 6;
      DrawText(Canvas.Handle, Text, StrLen(Text), Rect,
{$IFDEF RX_D4}
        DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX));
{$ELSE}
        DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
{$ENDIF}
    end;
  end;
end;

procedure TColorComboBox.Change;
var
  AColor: TColor;
begin
  inherited Change;
  AColor := GetColorValue;
  if FColorValue <> AColor then begin
    FColorValue := AColor;
    DoChange;
  end;
end;

procedure TColorComboBox.Click;
begin
  if ItemIndex >= 0 then ColorValue := TColor(Items.Objects[ItemIndex]);
  inherited Click;
end;

procedure TColorComboBox.DoChange;
begin
  if not (csReading in ComponentState) then
    if Assigned(FOnChange) then FOnChange(Self);
end;

{ TFontComboBox }

const
  WRITABLE_FONTTYPE = 256;

function IsValidFont(Box: TFontComboBox; LogFont: TLogFont;
  FontType: Integer): Boolean;
begin
  Result := True;
  if (foAnsiOnly in Box.Options) then
    Result := Result and (LogFont.lfCharSet = ANSI_CHARSET);
  if (foTrueTypeOnly in Box.Options) then
    Result := Result and (FontType and TRUETYPE_FONTTYPE = TRUETYPE_FONTTYPE);
  if (foFixedPitchOnly in Box.Options) then
    Result := Result and (LogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH);
  if (foOEMFontsOnly in Box.Options) then
    Result := Result and (LogFont.lfCharSet = OEM_CHARSET);
  if (foNoOEMFonts in Box.Options) then
    Result := Result and (LogFont.lfCharSet <> OEM_CHARSET);
  if (foNoSymbolFonts in Box.Options) then
    Result := Result and (LogFont.lfCharSet <> SYMBOL_CHARSET);
  if (foScalableOnly in Box.Options) then
    Result := Result and (FontType and RASTER_FONTTYPE = 0);
end;

{$IFDEF WIN32}

function EnumFontsProc(var EnumLogFont: TEnumLogFont;
  var TextMetric: TNewTextMetric; FontType: Integer; Data: LPARAM): Integer;
  export; stdcall;
var
  FaceName: string;
begin
  FaceName := StrPas(EnumLogFont.elfLogFont.lfFaceName);
  with TFontComboBox(Data) do
    if (Items.IndexOf(FaceName) < 0) and
      IsValidFont(TFontComboBox(Data), EnumLogFont.elfLogFont, FontType) then
    begin
      if EnumLogFont.elfLogFont.lfCharSet <> SYMBOL_CHARSET then
        FontType := FontType or WRITABLE_FONTTYPE;
      Items.AddObject(FaceName, TObject(FontType));
    end;
  Result := 1;
end;

{$ELSE}

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; export;
begin
  with TFontComboBox(Data) do
    if (Items.IndexOf(StrPas(LogFont.lfFaceName)) < 0) and
      IsValidFont(TFontComboBox(Data), LogFont, FontType) then
    begin
      if LogFont.lfCharSet = SYMBOL_CHARSET then
        FontType := FontType or WRITABLE_FONTTYPE;
      Items.AddObject(StrPas(LogFont.lfFaceName), TObject(FontType));
    end;
  Result := 1;
end;

{$ENDIF WIN32}

constructor TFontComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTrueTypeBMP := CreateBitmap('TRUETYPE_FNT');
  FDeviceBMP := CreateBitmap('DEVICE_FNT');
  FDevice := fdScreen;
  Sorted := True;
  inherited ItemHeight := MinItemHeight;
end;

destructor TFontComboBox.Destroy;
begin
  FTrueTypeBMP.Free;
  FDeviceBMP.Free;
  inherited Destroy;
end;

procedure TFontComboBox.CreateWnd;
var
  OldFont: TFontName;
begin
  OldFont := FontName;
  inherited CreateWnd;
  FUpdate := True;
  try
    PopulateList;
    inherited Text := '';
    SetFontName(OldFont);
  finally
    FUpdate := False;
  end;
  if AnsiCompareText(FontName, OldFont) <> 0 then DoChange;
end;

procedure TFontComboBox.PopulateList;
var
  DC: HDC;
{$IFNDEF WIN32}
  Proc: TFarProc;
{$ENDIF}
begin
  if not HandleAllocated then Exit;
  Items.BeginUpdate;
  try
    Clear;
    DC := GetDC(0);
    try
{$IFDEF WIN32}
      if (FDevice = fdScreen) or (FDevice = fdBoth) then
        EnumFontFamilies(DC, nil, @EnumFontsProc, Longint(Self));
      if (FDevice = fdPrinter) or (FDevice = fdBoth) then
      try
        EnumFontFamilies(Printer.Handle, nil, @EnumFontsProc, Longint(Self));
      except
        { skip any errors }
      end;
{$ELSE}
      Proc := MakeProcInstance(@EnumFontsProc, HInstance);
      try
        if (FDevice = fdScreen) or (FDevice = fdBoth) then
          EnumFonts(DC, nil, Proc, PChar(Self));
        if (FDevice = fdPrinter) or (FDevice = fdBoth) then
          try
            EnumFonts(Printer.Handle, nil, Proc, PChar(Self));
          except
            { skip any errors }
          end;
      finally
        FreeProcInstance(Proc);
      end;
{$ENDIF}
    finally
      ReleaseDC(0, DC);
    end;
  finally
    Items.EndUpdate;
  end;
end;

procedure TFontComboBox.SetFontName(const NewFontName: TFontName);
var
  Item: Integer;
begin
  if FontName <> NewFontName then begin
    if not (csLoading in ComponentState) then begin
      HandleNeeded;
      { change selected item }
      for Item := 0 to Items.Count - 1 do
        if AnsiCompareText(Items[Item], NewFontName) = 0 then begin
          ItemIndex := Item;
          DoChange;
          Exit;
        end;
      if Style = csDropDownList then ItemIndex := -1
      else inherited Text := NewFontName;
    end
    else inherited Text := NewFontName;
    DoChange;
  end;
end;

function TFontComboBox.GetFontName: TFontName;
begin
  Result := inherited Text;
end;

function TFontComboBox.GetTrueTypeOnly: Boolean;
begin
  Result := foTrueTypeOnly in FOptions;
end;

procedure TFontComboBox.SetOptions(Value: TFontListOptions);
begin
  if Value <> Options then begin
    FOptions := Value;
    Reset;
  end;
end;

procedure TFontComboBox.SetTrueTypeOnly(Value: Boolean);
begin
  if Value <> TrueTypeOnly then begin
    if Value then FOptions := FOptions + [foTrueTypeOnly]
    else FOptions := FOptions - [foTrueTypeOnly];
    Reset;
  end;
end;

procedure TFontComboBox.SetDevice(Value: TFontDevice);
begin
  if Value <> FDevice then begin
    FDevice := Value;
    Reset;
  end;
end;

procedure TFontComboBox.SetUseFonts(Value: Boolean);
begin
  if Value <> FUseFonts then begin
    FUseFonts := Value;
    Invalidate;
  end;
end;

procedure TFontComboBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  Bitmap: TBitmap;
  BmpWidth: Integer;
  Text: array[0..255] of Char;
begin
  with Canvas do begin
    FillRect(Rect);
    BmpWidth  := 20;
    if (Integer(Items.Objects[Index]) and TRUETYPE_FONTTYPE) <> 0 then
      Bitmap := FTrueTypeBMP
    else if (Integer(Items.Objects[Index]) and DEVICE_FONTTYPE) <> 0 then
      Bitmap := FDeviceBMP
    else Bitmap := nil;
    if Bitmap <> nil then begin
      BmpWidth := Bitmap.Width;
      BrushCopy(Bounds(Rect.Left + 2, (Rect.Top + Rect.Bottom - Bitmap.Height)
        div 2, Bitmap.Width, Bitmap.Height), Bitmap, Bounds(0, 0, Bitmap.Width,
        Bitmap.Height), Bitmap.TransparentColor);
    end;
    { uses DrawText instead of TextOut in order to get clipping against
      the combo box button }
    {TextOut(Rect.Left + bmpWidth + 6, Rect.Top, Items[Index])}
    StrPCopy(Text, Items[Index]);
    Rect.Left := Rect.Left + BmpWidth + 6;
    if FUseFonts and (Integer(Items.Objects[Index]) and WRITABLE_FONTTYPE <> 0) then
      Font.Name := Items[Index];
    DrawText(Handle, Text, StrLen(Text), Rect,
{$IFDEF RX_D4}
      DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX));
{$ELSE}
      DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
{$ENDIF}
  end;
end;

procedure TFontComboBox.WMFontChange(var Message: TMessage);
begin
  inherited;
  Reset;
end;

function TFontComboBox.MinItemHeight: Integer;
begin
  Result := inherited MinItemHeight;
  if Result < FTrueTypeBMP.Height - 1 then
    Result := FTrueTypeBMP.Height - 1;
end;

procedure TFontComboBox.Change;
var
  I: Integer;
begin
  inherited Change;
  if Style <> csDropDownList then begin
    I := Items.IndexOf(inherited Text);
    if (I >= 0) and (I <> ItemIndex) then begin
      ItemIndex := I;
      DoChange;
    end;
  end;
end;

procedure TFontComboBox.Click;
begin
  inherited Click;
  DoChange;
end;

procedure TFontComboBox.DoChange;
begin
  if not (csReading in ComponentState) then
    if not FUpdate and Assigned(FOnChange) then FOnChange(Self);
end;

procedure TFontComboBox.Reset;
var
  SaveName: TFontName;
begin
  if HandleAllocated then begin
    FUpdate := True;
    try
      SaveName := FontName;
      PopulateList;
      FontName := SaveName;
    finally
      FUpdate := False;
      if FontName <> SaveName then DoChange;
    end;
  end;
end;

end.