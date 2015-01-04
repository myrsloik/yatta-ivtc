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

unit VapourSynth;

//{$DEFINE VAPOURSYNTHDLLIMPORT}

{$IFDEF WIN32}
{$DEFINE STDCALL}
{$ENDIF}

{$ALIGN 8}
{$Z4}

interface

const
  VapourSynthLib = 'VapourSynth.dll';

  VAPOURSYNTH_API_MAJOR = 3;
  VAPOURSYNTH_API_MINOR = 1;
  VAPOURSYNTH_API_VERSION = (VAPOURSYNTH_API_MAJOR shl 16) or VAPOURSYNTH_API_MINOR;

type
  DoubleArray  = array[0..$0ffffffe] of Double;
  PDoubleArray = ^DoubleArray;

  PVSFrameRef = Pointer;
  PVSFrameRefArray  = array[0..$0ffffffe] of PVSFrameRef;
  PPVSFrameRefArray = ^PVSFrameRefArray;
  PVSNodeRef = Pointer;
  PVSCore = Pointer;
  PVSPlugin = Pointer;
  PVSNode = Pointer;
  PVSFuncRef = Pointer;
  PVSMap = Pointer;
  PVSFrameContext = Pointer;
  PVSFormat = ^VSFormat;
  PVSCoreInfo = ^VSCoreInfo;
  PVSVideoInfo = ^VSVideoInfo;
  PVSAPI = ^VSAPI;

  VSColorFamily = (
    cmGray   = 1000000,
    cmRGB    = 2000000,
    cmYUV    = 3000000,
    cmYCoCg  = 4000000,
    cmCompat = 9000000);

  VSSampleType = (
    stInteger = 0,
    stFloat = 1);

  VSPresetFormat = (
    pfNone = 0,

    pfGray8 = Integer(cmGray) + 10,
    pfGray16,

    pfGrayH,
    pfGrayS,

    pfYUV420P8 = Integer(cmYUV) + 10,
    pfYUV422P8,
    pfYUV444P8,
    pfYUV410P8,
    pfYUV411P8,
    pfYUV440P8,

    pfYUV420P9,
    pfYUV422P9,
    pfYUV444P9,

    pfYUV420P10,
    pfYUV422P10,
    pfYUV444P10,

    pfYUV420P16,
    pfYUV422P16,
    pfYUV444P16,

    pfYUV444PH,
    pfYUV444PS,

    pfRGB24 = Integer(cmRGB) + 10,
    pfRGB27,
    pfRGB30,
    pfRGB48,

    pfRGBH,
    pfRGBS,

    pfCompatBGR32 = Integer(cmCompat) + 10,
    pfCompatYUY2);

  VSFilterMode = (
    fmParallel = 100,
    fmParallelRequests = 200,
    fmUnordered = 300,
    fmSerial = 400);

  VSFormat = record
    name: array[0..31] of AnsiChar;
    id: Integer;
    colorFamily: VSColorFamily;
    sampleType: VSSampleType;
    bitsPerSample: Integer;
    bytesPerSample: Integer;

    subSamplingW: Integer;
    subSamplingH: Integer;

    numPlanes: Integer;
  end;

  VSNodeFlags = (
    nfNoFlags = 0,
    nfNoCache = 1,
    nfIsCache = 3); // works because nfIsCache also requires nfNoCache to be set

  VSPropTypes = (
    ptUnset = Integer('u'),
    ptInt = Integer('i'),
    ptFloat = Integer('f'),
    ptData = Integer('s'),
    ptNode = Integer('c'),
    ptFrame = Integer('v'),
    ptFunction = Integer('m'));

  VSGetPropErrors = (
    peUnset = 1,
    peType  = 2,
    peIndex = 4);

  VSPropAppendMode = (
    paReplace = 0,
    paAppend  = 1,
    paTouch   = 2);

  VSCoreInfo = record
    versionString: PAnsiChar;
    core: Integer;
    api: Integer;
    numThreads: Integer;
    maxFramebufferSize: Int64;
    usedFramebufferSize: Int64;
  end;

  VSVideoInfo = record
    format: PVSFormat;
    fpsNum: Int64;
    fpsDen: Int64;
    width: Integer;
    height: Integer;
    numFrames: Integer;
    flags: VSNodeFlags;
  end;

  VSActivationReason = (
    arInitial = 0,
    arFrameReady = 1,
    arAllFramesReady = 2,
    arError = -1);

  VSMessageType = (
    mtDebug = 0,
    mtWarning = 1,
    mtCritical = 2,
    mtFatal = 3);

  VSGetVapourSynthAPI = function(version: Integer): PVSAPI; {$IFDEF STDCALL}stdcall;{$ENDIF}
  VSPublicFunction = procedure(inm: PVSMap; outm: PVSMap; userData: Pointer; core: PVSCore; vsapi: PVSAPI); {$IFDEF STDCALL}stdcall;{$ENDIF}
  VSFreeFuncData = procedure(userData: Pointer); {$IFDEF STDCALL}stdcall;{$ENDIF}
  VSFrameDoneCallback = procedure(userData: Pointer; f: PVSFrameRef; n: Integer; node: PVSNodeRef; errorMsg: PAnsiChar); {$IFDEF STDCALL}stdcall;{$ENDIF}
  VSMessageHandler = procedure(msgType: VSMessageType; msg: PAnsiChar; userData: Pointer); {$IFDEF STDCALL}stdcall;{$ENDIF}
  VSFilterInit = procedure(inm: PVSMap; outm: PVSMap; var instanceData: Pointer; node: PVSNode; core: PVSCore; vsapi: PVSAPI); {$IFDEF STDCALL}stdcall;{$ENDIF}
  VSFilterGetFrame = function(n: Integer; activationReason: Integer; var instanceData: Pointer; var frameData: Pointer; frameCtx: PVSFrameContext; core: PVSCore; vsapi: PVSAPI): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
  VSFilterFree = procedure(instanceData: Pointer; core: PVSCore; vsapi: PVSAPI); {$IFDEF STDCALL}stdcall;{$ENDIF}

  VSAPI = record
    createCore: function(threads: Integer): PVSCore; {$IFDEF STDCALL}stdcall;{$ENDIF}
    freeCore: procedure(core: PVSCore); {$IFDEF STDCALL}stdcall;{$ENDIF}
    getCoreInfo: function(core: PVSCore): PVSCoreInfo; {$IFDEF STDCALL}stdcall;{$ENDIF}

    cloneFrameRef: function(f: PVSFrameRef): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    cloneNodeRef: function(node: PVSNodeRef): PVSNodeRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    cloneFuncRef: function(f: PVSFuncRef): PVSFuncRef; {$IFDEF STDCALL}stdcall;{$ENDIF}

    freeFrame: procedure(f: PVSFrameRef); {$IFDEF STDCALL}stdcall;{$ENDIF}
    freeNode: procedure(node: PVSNodeRef); {$IFDEF STDCALL}stdcall;{$ENDIF}
    freeFunc: procedure(f: PVSFuncRef); {$IFDEF STDCALL}stdcall;{$ENDIF}

    newVideoFrame: function(format: PVSFormat; width: Integer; height: Integer; propSrc: PVSFrameRef; core: PVSCore): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    copyFrame: function(f: PVSFrameRef; core: PVSCore): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    copyFrameProps: procedure(src: PVSFrameRef; dst: PVSFrameRef; core: PVSCore); {$IFDEF STDCALL}stdcall;{$ENDIF}

    registerFunction: procedure(name: PAnsiChar; args: PAnsiChar; argsFunc: VSPublicFunction; functionData: Pointer; plugin: PVSPlugin); {$IFDEF STDCALL}stdcall;{$ENDIF}
    getPluginById: function(identifier: PAnsiChar; core: PVSCore): PVSPlugin; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getPluginByNs: function(ns: PAnsiChar; core: PVSCore): PVSPlugin; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getPlugins: function(core: PVSCore): PVSMap; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getFunctions: function(plugin: PVSPlugin): PVSMap; {$IFDEF STDCALL}stdcall;{$ENDIF}
    createFilter: procedure(inm: PVSMap; outm: PVSMap; name: PAnsiChar; init: VSFilterInit; getFrame: VSFilterGetFrame; free: VSFilterFree; filterMode: Integer; flags:Integer; instanceData: Pointer; core: PVSCore); {$IFDEF STDCALL}stdcall;{$ENDIF}
    setError: procedure(map: PVSMap; errorMessage: PAnsiChar); {$IFDEF STDCALL}stdcall;{$ENDIF}
    getError: function(map: PVSMap): PAnsiChar; {$IFDEF STDCALL}stdcall;{$ENDIF}
    setFilterError: procedure(errorMessage: PAnsiChar; frameCtx: PVSFrameContext); {$IFDEF STDCALL}stdcall;{$ENDIF}
    invoke: function(plugin: PVSPlugin; name: PAnsiChar; args: PVSMap): PVSMap; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getFormatPreset: function(id: Integer; core: PVSCore): PVSFormat; {$IFDEF STDCALL}stdcall;{$ENDIF}
    registerFormat: function(colorFamily: VSColorFamily; sampleType: VSSampleType; bitsPerSample: Integer; subSamplingW: Integer; subSamplingH: Integer; core: PVSCore): PVSFormat; {$IFDEF STDCALL}stdcall;{$ENDIF}

    getFrame: function(n: Integer; node: PVSNodeRef; errorMsg: PAnsiChar; bufSize: Integer): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getFrameAsync: procedure(n: Integer; node: PVSNodeRef; callback: VSFrameDoneCallback; userData: Pointer); {$IFDEF STDCALL}stdcall;{$ENDIF}
    getFrameFilter: function(n: Integer; node: PVSNodeRef; frameCtx: PVSFrameContext): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    requestFrameFilter: procedure(n: Integer; node: PVSNodeRef; frameCtx: PVSFrameContext); {$IFDEF STDCALL}stdcall;{$ENDIF}
    queryCompletedFrame: procedure(var node: PVSNodeRef; n: Integer; frameCtx: PVSFrameContext); {$IFDEF STDCALL}stdcall;{$ENDIF}
    releaseFrameEarly: procedure(node: PVSNodeRef; n: Integer; frameCtx: PVSFrameContext); {$IFDEF STDCALL}stdcall;{$ENDIF}

    getStride: function(f: PVSFrameRef; plane: Integer): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getReadPtr: function(f: PVSFrameRef; plane: Integer): PByte; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getWritePtr: function(f: PVSFrameRef; plane: Integer): PByte; {$IFDEF STDCALL}stdcall;{$ENDIF}

    createFunc: function(func: VSPublicFunction; userData: Pointer; free: VSFreeFuncData; core: PVSCore; vsapi: PVSAPI): PVSFuncRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    callFunc: procedure(func: PVSFuncRef; inm: PVSMap; outm: PVSMap; core: PVSCore = nil; vsapi: PVSAPI = nil); {$IFDEF STDCALL}stdcall;{$ENDIF}

    createMap: function: PVSMap; {$IFDEF STDCALL}stdcall;{$ENDIF}
    freeMap: procedure(map: PVSMap); {$IFDEF STDCALL}stdcall;{$ENDIF}
    clearMap: procedure(map: PVSMap); {$IFDEF STDCALL}stdcall;{$ENDIF}

    getVideoInfo: function(node: PVSNodeRef): PVSVideoInfo; {$IFDEF STDCALL}stdcall;{$ENDIF}
    setVideoInfo: procedure(vi: PVSVideoInfo; numOutputs: Integer; node: PVSNode); {$IFDEF STDCALL}stdcall;{$ENDIF}
    getFrameFormat: function(f: PVSFrameRef): PVSFormat; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getFrameWidth: function(f: PVSFrameRef): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getFrameHeight: function(f: PVSFrameRef): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getFramePropsRO: function(f: PVSFrameRef): PVSMap; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getFramePropsRW: function(f: PVSFrameRef): PVSMap; {$IFDEF STDCALL}stdcall;{$ENDIF}

    propNumKeys: function(map: PVSMap): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetKey: function(map: PVSMap; index: Integer): PAnsiChar; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propNumElements: function(map: PVSMap; key: PAnsiChar): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetType: function(map: PVSMap; key: PAnsiChar): AnsiChar; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetInt: function(map: PVSMap; key: PAnsiChar; index: Integer; error: PInteger = nil): Int64; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetFloat: function(map: PVSMap; key: PAnsiChar; index: Integer; error: PInteger = nil): Double; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetData: function(map: PVSMap; key: PAnsiChar; index: Integer; error: PInteger = nil): PAnsiChar; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetDataSize: function(map: PVSMap; key: PAnsiChar; index: Integer; error: PInteger = nil): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetNode: function(map: PVSMap; key: PAnsiChar; index: Integer; error: PInteger = nil): PVSNodeRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetFrame: function(map: PVSMap; key: PAnsiChar; index: Integer; error: PInteger = nil): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetFunc: function(map: PVSMap; key: PAnsiChar; index: Integer; error: PInteger = nil): PVSFuncRef; {$IFDEF STDCALL}stdcall;{$ENDIF}

    propDeleteKey: function(map: PVSMap; key: PAnsiChar): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propSetInt: function(map: PVSMap; key: PAnsiChar; i: Int64; append: VSPropAppendMode = paReplace): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propSetFloat: function(map: PVSMap; key: PAnsiChar; d: double; append: VSPropAppendMode = paReplace): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propSetData: function(map: PVSMap; key: PAnsiChar; data: PAnsiChar; size: Integer; append: VSPropAppendMode = paReplace): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propSetNode: function(map: PVSMap; key: PAnsiChar; node: PVSNodeRef; append: VSPropAppendMode = paReplace): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propSetFrame: function(map: PVSMap; key: PAnsiChar; f: PVSFrameRef; append: VSPropAppendMode = paReplace): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propSetFunc: function(map: PVSMap; key: PAnsiChar; func: PVSFuncRef; append: VSPropAppendMode = paReplace): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}

    setMaxCacheSize: function(bytes: Int64; core: PVSCore): Int64; {$IFDEF STDCALL}stdcall;{$ENDIF}
    getOutputIndex: function(frameCtx: PVSFrameContext): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    newVideoFrame2: function(format: PVSFormat; width: Integer; height: Integer; planeSrc: PPVSFrameRefArray; planes: PIntegerArray; propSrc: PVSFrameRef; core: PVSCore): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}

    setMessageHandler: procedure(handler: VSMessageHandler; userData: Pointer); {$IFDEF STDCALL}stdcall;{$ENDIF}
    setThreadCount: function(threads: Integer; core: PVSCore): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}

    getPluginPath: function(plugin: PVSPlugin): PAnsiChar; {$IFDEF STDCALL}stdcall;{$ENDIF}

    propGetIntArray: function(map: PVSMap; key: PAnsiChar; error: PInteger = nil): PInt64Array; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propGetFloatArray: function(map: PVSMap; key: PAnsiChar; error: PInteger = nil): PDoubleArray; {$IFDEF STDCALL}stdcall;{$ENDIF}

    propSetIntArray: function(map: PVSMap; key: PAnsiChar; i: PInt64Array; size: Integer): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
    propSetFloatArray: function(map: PVSMap; key: PAnsiChar; const d: PDoubleArray; size: Integer): Integer; {$IFDEF STDCALL}stdcall;{$ENDIF}
  end;
{$IFDEF VAPOURSYNTHDLLIMPORT}
  function getVapourSynthAPI(version: Integer = VAPOURSYNTH_API_VERSION): PVSAPI; {$IFDEF STDCALL}stdcall;{$ENDIF} external VapourSynthLib;
{$ENDIF}
implementation

end.
