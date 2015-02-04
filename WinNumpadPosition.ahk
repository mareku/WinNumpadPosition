;======================================================================
;テンキー(以降n)でウィンドウを移動&リサイズ
; +----+-----+----+
; | n7 |  n8 | n9 |
; +----|-----|----+
; | n4 |  n5 | n6 |
; +----|-----|----+
; | n1 |  n2 | n3 |
; +----+-----+----+
; | n0 |  n. | nE |
; +----+-----+----+
; u = Up, d = Down, l = Left, r = Right
; Top = 最前面, Max = 最大化, m = モニタ移動
; +----+-----+----+
; | lu |  u  | ru |
; +----|-----|----+
; | l  |  m  | r  |
; +----|-----|----+
; | ld |  d  | rd |
; +----+-----+----+
; |Top | Max | Ent|
; +----+-----+----+
;======================================================================
;ホットキー定義INI
iniPath:="E:\00work\nemo\script\AutoHotkey\WinNumpadPosition.ini"

;変数
;今の変更可能数
SizeChangeCount:=1

;サイズ変更可能数
;上下
UpDownMaxCount:=6
;左右
LeftRightMaxCount:=6
;斜め側
SidesMaxCount:=9
;中央
MiddleMaxCount:=6

;ウィンドウカウント
CurrentMonitor:=1

;----------------------------------------------------------------------
;ホットキー定義
;----------------------------------------------------------------------
;#Persistent
  ;ウィンドウ移動
  iniSection:="WinMoveHotkey"
  SetHotkey(iniPath, iniSection, "leftUp", "leftUp")
  SetHotkey(iniPath, iniSection, "left", "left")
  SetHotkey(iniPath, iniSection, "leftDown", "leftDown")
  SetHotkey(iniPath, iniSection, "up", "up")
  SetHotkey(iniPath, iniSection, "middle", "middle")
  SetHotkey(iniPath, iniSection, "down", "down")
  Sethotkey(iniPath, iniSection, "rightUp", "rightUp")
  Sethotkey(iniPath, iniSection, "right", "right")
  SetHotkey(iniPath, iniSection, "rightDown", "rightDown")
  ;モニター移動
  iniSection:="MonitorMove"
  SetHotkey(iniPath, iniSection, "monitor", "monitor")
  ;オプション機能
  iniSection:="OperatingOptions"
  SetHotkey(iniPath, iniSection, "foreground", "foreground")
  SetHotkey(iniPath, iniSection, "semitransparent", "semitransparent")
  SetHotkey(iniPath, iniSection, "maximization", "maximization")
return

;----------------------------------------------------------------------
;その他
;----------------------------------------------------------------------
;最前面
foreground:
  WinSet, Topmost, TOGGLE, A  ;ウィンドウを最前面/解除
Return

;最大化/元に戻す
maximization:
  ; WinSet, Style, ^0xC00000, A
  ; WinGet, t, MinMax, A  ;ウィンド最大化判別
  ; if(t=0){
  ;   WinSet, Style, -0xC00000, A   ;タイトルバー非表示
  ;   WinMaximize, A                ;ウィンドウ最大化
  ; } else {
  ;   WinSet, Style, +0xC00000, A   ;タイトルバー表示
  ;   WinRestore, A                 ;ウィンドウを元のサイズに戻す
  ; }
  WinGet, tmp, MinMax, A
  if (tmp = 1) {
    WinRestore, A
  } Else {
    WinMaximize, A
  }
return

;半透明化
transparencyFlag:=0
semitransparent:
;   transparency:=
;   if(0=transparencyFlag){
;     transparency:=160
;     transparencyFlag:=1
;   } else {
;     transparency:=255
;     transparencyFlag:=0
;   }
; WinSet, Transparent, %transparency%, A
WinGet, t, Transparent, A
if %t%
WinSet, Transparent, OFF, A
else
WinSet, Transparent, 200, A
return

;----------------------------------------------------------------------
;移動キー
;----------------------------------------------------------------------
;モニタ移動
monitor:
  SysGet, mCount, MonitorCount

  if (CurrentMonitor >= mCount){
    CurrentMonitor:=1
  }
  else{
    CurrentMonitor++
  }
return

;中央
middle:
  GetMonitor(CurrentMonitor, mX, mY, mW, mH)

  CountReset(MiddleMaxCount, SizeChangeCount)

  MiddleWidthReSize(mW, rW, SizeChangeCount)
  MiddleHeightReSize(mH, rH, SizeChangeCount)

  XPos:=(0>mX) ? (mX/2)-(rW/2) : (mW/2)-(rW/2)
  YPos:=(0>mY) ? (mY/2)-(rH/2) : (mH/2)-(rH/2)

  WinMove, A,, XPos, YPos, rW, rH

  SizeChangeCount++

return

;左上
leftUp:
  ;モニター
  GetMonitor(CurrentMonitor, mX, mY, mW, mH)
  ;カウントリセット
  CountReset(SidesMaxCount, SizeChangeCount)

  WidthReSize(mW, rW, SizeChangeCount)
  HeightReSize(mH, rH, SizeChangeCount)

  WinMove, A,, mX, mY, rW, rH

  SizeChangeCount++

return

;右上
rightUp:
  GetMonitor(CurrentMonitor, mX, mY, mW, mH)

  CountReset(SidesMaxCount, SizeChangeCount)

  WidthReSize(mW, rW, SizeChangeCount)
  HeightReSize(mH, rH, SizeChangeCount)

  cX:= (0 > mX) ? rW-(rW*2) : mW-rW

  WinMove, A,, cX, mY, rW, rH

  SizeChangeCount++
return

;左下
leftDown:
  GetMonitor(CurrentMonitor, mX, mY, mW, mH)

  CountReset(SidesMaxCount, SizeChangeCount)

  WidthReSize(mW, rW, SizeChangeCount)
  HeightReSize(mH, rH, SizeChangeCount)

  cY:= (0 > mY) ? rH-(rH*2) : mH-rH

  WinMove, A,, mX, cY, rW, rH

  SizeChangeCount++
return

;右下
rightDown:
  GetMonitor(CurrentMonitor, mX, mY, mW, mH)

  CountReset(SidesMaxCount, SizeChangeCount)

  WidthReSize(mW, rW, SizeChangeCount)
  HeightReSize(mH, rH, SizeChangeCount)

  cX:= (0 > mX) ? rW-(rW*2) : mW-rW

  cH:= (0 > mY) ? rH-(rH*2) : mH-rH

  WinMove, A,, cX, cH, rW, rH

  SizeChangeCount++
return

;上
up:
  GetMonitor(CurrentMonitor, mX, mY, mW, mH)

  CountReset(UpDownMaxCount, SizeChangeCount)

  SidesWidthResize(mH, rH, SizeChangeCount)

  rW:=(SizeChangeCount >= 4) ? mW*1/3 : mW

  XPos:= (0 > mX) ? (mX/2)-(rW/2) : (mW/2)-(rW/2)

  WinMove, A,, XPos, mY, rW, rH

  SizeChangeCount++

return

;下
down:
 GetMonitor(CurrentMonitor, mX, mY, mW, mH)

 CountReset(UpDownMaxCount, SizeChangeCount)

 SidesWidthReSize(mH, rH, SizeChangeCount)

 rW:=(SizeChangeCount >= 4) ? mW*1/3 : mW

 YPos:= (0 > mY) ? rH-(rH*2) : mH-rH
 XPos:= (0 > mX) ? (mX/2)-(rW/2) : (mW/2)-(rW/2)

WinMove, A,, XPos, YPos, rW, rH

 SizeChangeCount++

return

;左
left:
  GetMonitor(CurrentMonitor, mX, mY, mW, mH)
  ;カウントリセット
  CountReset(LeftRightMaxCount, SizeChangeCount)

  SidesWidthReSize(mW, rW, SizeChangeCount)


  rH:=(SizeChangeCount >= 4) ? mH*1/3 : mH

  YPos:=(0>mY) ? (mY/2)-(rH/2) : (mH/2)-(rH/2)

  WinMove, A,, mX, YPos, rW, rH

  SizeChangeCount++

return

;右
right:
  GetMonitor(CurrentMonitor, mX, mY, mW, mH)

  CountReset(LeftRightMaxCount, SizeChangeCount)

  SidesWidthReSize(mW, rW, SizeChangeCount)

  rH:=(SizeChangeCount >= 4) ? mH*1/3 : mH

  XPos:= (0 > mX) ? rW-(rW*2) : mW-rW
  YPos:=(0>mY) ? (mY/2)-(rH/2) : (mH/2)-(rH/2)

  WinMove, A,, XPos, YPos, rW, rH

  SizeChangeCount++

return

;----------------------------------------------------------------------
;ホットキー定義関数
;----------------------------------------------------------------------
SetHotkey(Path, Sec, key, fun)
{
  IniRead, Getkey, %Path%, %Sec%, %key%
  if(Getkey!="Error")
  Hotkey, %Getkey%, %fun%
}

;----------------------------------------------------------------------
;ウィンドウ移動関連関数
;----------------------------------------------------------------------
;現在のモニタのデータ
GetMonitor(monitorNo, ByRef mX, ByRef mY, ByRef mW, ByRef mH)
{
  SysGet, m, MonitorWorkArea, %monitorNo%
  mX := mLeft
  mY := mTop
  mW := mRight - mLeft
  mH := mBottom - mTop
}

;カウントリセット
CountReset(Reset, ByRef SizeChangeCount){
  if(SizeChangeCount > Reset){
    SizeChangeCount:=1
  }
}
;横のリサイズ計算
WidthReSize(w, ByRef rW, count){
  if(count=1) {
    rW := w*1/2
  } else if(count=2) {
    rW := w*1/3
  } else if(count=3) {
    rW := w*2/3
  } else if(count=4) {
    rW := w*2/3
  } else if(count=5) {
    rW := w*1/3
  } else if(count=6) {
    rW := w*1/2
  } else if(count=7) {
    rW := w*1/2
  } else if(count=8) {
    rW := w*2/3
  } else if(count=9) {
    rW := w*1/3
  }
}
;高さのリサイズ計算
HeightReSize(h, ByRef rH, count){
  if(count=1) {
    rH := h*1/2
  } else if(count=2) {
    rH := h*1/3
  } else if(count=3) {
    rH := h*1/3
  } else if(count=4) {
    rH := h*2/3
  } else if(count=5) {
    rH := h*2/3
  } else if(count=6) {
    rH := h*1/3
  } else if(count=7) {
    rH := h*2/3
  } else if(count=8) {
    rH := h*1/2
  } else if(count=9) {
    rH := h*1/2
  }
}

;上下左右のリサイズ
SidesWidthResize(w, ByRef rW, count){
  if(count=1) {
    rW := w*1/2
  } else if(count=2) {
    rW := w*1/3
  } else if(count=3) {
    rW := w*2/3
  } else if(count=4) {
    rW := w*1/2
  } else if(count=5) {
    rW := w*1/3
  } else if(count=6) {
    rW := w*2/3
 }
}
SidesHeightResize(h, ByRef rH, count){
  if(count=1) {
    rH := h*1/2
  } else if(count=2) {
    rH := h*1/3
  } else if(count=3) {
    rH := h*2/3
  }
}

;中央でのリサイズ
MiddleWidthReSize(w, ByRef rW, count){
  if(count=1) {
    rW:=w*1/3
  } else if(count=2) {
    rW:=w*1/2
  } else if(count=3) {
    rW:=w*2/3
  } else if(count=4) {
    ;rW:=1050
    rW:=w*4/5
  } else if(count=5) {
    rW:=w*4/5
  } else if(count=6) {
    rW:=w
  }
}

MiddleHeightReSize(h, ByRef rH, count){
  if(count=1) {
    rH:=h*1/3
  } else if(count=2) {
    rH:=h*1/2
  } else if(count=3) {
    rH:=h*2/3
  } else if(count=4) {
    ;rH:=1000
    rH:=h*4/5
  } else if(count=5) {
    rH:=h
  } else if(count=6) {
    rH:=h*4/5
  }
}
