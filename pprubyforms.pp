unit ppRubyForms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ppRuby, ppRubyClasses, Forms;

operator explicit (v : VALUE) : TWindowState;
operator explicit (v : TWindowState) : VALUE;

resourcestring
  msgCanNotConvertTo =
    'Can not convert %s to %s.';

implementation

var
  cacheWindowStates : array [TWindowState] of VALUE;

procedure InitWindowStates;
 begin
  cacheWindowStates[wsNormal]    := VALUE(ID('wsNormal'));
  cacheWindowStates[wsMinimized] := VALUE(ID('wsMinimized'));
  cacheWindowStates[wsMaximized] := VALUE(ID('wsMaximized'));
 end;

operator explicit (v : VALUE) : TWindowState;
 begin
  case ValType(v) of
       rtFixNum :
         exit(TWindowState(PtrInt(v)));
       rtSymbol :
         for Result := Low(TWindowState) to High(TWindowState) do
             if cacheWindowStates[Result] = v
                then exit;
  end;
  raise ERubyConversion.CreateFmt(msgCanNotConvertTo, [ansistring(Inspect(v)), 'TWindowState']);
 end;

operator explicit (v : TWindowState) : VALUE;
 begin
  Result := cacheWindowStates[v];
 end;

initialization
 ppRuby.AddLoadHook(@InitWindowStates);
end.
