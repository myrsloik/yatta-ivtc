{
* Copyright (c) 2015 Fredrik Mellbin
*
* This file is part of VapourSynth.
*
* VapourSynth is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* VapourSynth is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with VapourSynth; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
}

unit VSScript;

interface

uses VapourSynth;

{$IFDEF WIN32}
{$DEFINE STDCALL}
{$ENDIF}

const
  VSScriptLib = 'VSScript.dll';


type
  PVSScript = Pointer;

  VSEvalFlags = (
    efNoFlags = 0,
    efSetWorkingDir = 1);

  function vsscript_init: Integer; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_finalize: Integer; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_evaluateScript(var handle: PVSScript; script: PAnsiChar; scriptFilename: PAnsiChar; flags: VSEvalFlags = efSetWorkingDir): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_evaluateFile(var handle: PVSScript; scriptFilename: PAnsiChar; flags: VSEvalFlags = efSetWorkingDir): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_createScript(var handle: PVSScript): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  procedure vsscript_freeScript(handle: PVSScript); {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_getError(handle: PVSScript): PAnsiChar; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;

  function vsscript_getOutput(handle: PVSScript; index: Integer): PVSNodeRef; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_clearOutput(handle: PVSScript; index: Integer): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_getCore(handle: PVSScript): PVSCore; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_getVSApi: PVSAPI; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;

  function vsscript_getVariable(handle: PVSScript; name: PAnsiChar; dst: PVSMap): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_setVariable(handle: PVSScript; vars: PVSMap): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
  function vsscript_clearVariable(handle: PVSScript; name: PAnsiChar): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;

  procedure vsscript_clearEnvironment(handle: PVSScript); {$IFDEF STDCALL}stdcall;{$ENDIF} external VSScriptLib;
implementation

end.
