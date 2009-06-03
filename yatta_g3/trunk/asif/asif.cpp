#include <windows.h>
#include "asif.h"

extern "C" {

	__declspec(dllexport) void BitBltExp(BYTE* dstp, int dstp_pitch, const BYTE* srcp, int src_pitch, int row_size, int height, CAsifScriptEnvironment* env) {
		env->BitBlt(dstp,dstp_pitch,srcp,src_pitch,row_size,height);
	}

	__declspec(dllexport) void AddFunction(const char* name, const char* params, IScriptEnvironment::ApplyFunc apply, void* user_data, CAsifScriptEnvironment* env) {
		env->AddFunction(name,params,apply,user_data); 
	}

	__declspec(dllexport) long GetCPUFlags(CAsifScriptEnvironment* env) {
		return env->GetCPUFlags(); 
	}

	__declspec(dllexport) void SetGlobalVar(const char* varname, AVSValueStruct varvalue, CAsifScriptEnvironment* env) {
		env->SetGlobalVar(varname,varvalue); 
	}

	__declspec(dllexport) void CheckVersion(int version, CAsifScriptEnvironment* env){
		env->CheckVersion(version); 
	}

	__declspec(dllexport) bool FunctionExists(const char* name, CAsifScriptEnvironment* env) {
		return env->FunctionExists(name); 
	}

	__declspec(dllexport) bool MakeWritable(CAsifVideoFrame* pvf, CAsifScriptEnvironment* env) {
		return env->MakeWritable(pvf); 
	}

	__declspec(dllexport) void AtExit(IScriptEnvironment::ShutdownFunc function, void* user_data, CAsifScriptEnvironment* env) {
		env->AtExit(function,user_data); 
	}

	__declspec(dllexport) CAsifVideoFrame* NewVideoFrame(const VideoInfo & vi, int align, CAsifScriptEnvironment* env) {
		return env->NewVideoFrame(vi, align); 
	}

	__declspec(dllexport) void PopContext(CAsifScriptEnvironment* env) {
		env->PopContext(); 
	}

	__declspec(dllexport) void PushContext(int level, CAsifScriptEnvironment* env) {
		env->PushContext(level); 
	}

	__declspec(dllexport) void VSprintf(const char* fmt, void* val, CAsifScriptEnvironment* env) {
		env->VSprintf(fmt,val); 
	}

	__declspec(dllexport) CAsifVideoFrame* Subframe(CAsifVideoFrame* src, int rel_offset, int new_pitch, int new_row_size, int new_height, CAsifScriptEnvironment* env) {
		return env->Subframe(src,rel_offset,new_pitch,new_row_size,new_height); 
	}

	__declspec(dllexport) void SaveString(const char* s, int length, CAsifScriptEnvironment* env) {
		env->SaveString(s,length); 
	}

	__declspec(dllexport) CAsifVideoFrame* GetFrame(int n, CAsifClip* clip) {
		return clip->GetFrame(n);
	}

	__declspec(dllexport) void SetCacheHints(int cachehints,int frame_range, CAsifClip* clip) {
		return clip->SetCacheHints(cachehints,frame_range);
	}

	__declspec(dllexport) bool GetParity(int n, CAsifClip* clip) {
		return clip->GetParity(n);
	}

	__declspec(dllexport) void GetAudio(void* buf, __int64 start, __int64 count, CAsifClip* clip) {
		return clip->GetAudio(buf,start,count);
	}


	__declspec(dllexport) int GetPitch(int plane, CAsifVideoFrame* vf) {
		return vf->pf->GetPitch(plane);
	}

	__declspec(dllexport) int GetHeight(int plane, CAsifVideoFrame* vf) {
		return vf->pf->GetHeight(plane);
	}

	__declspec(dllexport) int GetRowSize(int plane, CAsifVideoFrame* vf) {
		return vf->pf->GetRowSize(plane);
	}

	__declspec(dllexport) bool IsWritable(CAsifVideoFrame* vf) {
		return vf->pf->IsWritable();
	}

	__declspec(dllexport) BYTE* GetWritePtr(int plane, CAsifVideoFrame* vf) {
		return vf->pf->GetWritePtr(plane);
	}

	__declspec(dllexport) const BYTE* GetReadPtr(int plane, CAsifVideoFrame* vf) {
		return vf->pf->GetReadPtr(plane);
	}

	__declspec(dllexport) AsifData *InitializeAsif() {
		AsifData *a = new AsifData();
		if (!(a->Dll = LoadLibrary("AVISYNTH.DLL"))) {
			delete a;
			return NULL;
		}

		if (!(a->CreateScriptEnvironment = (cfunc)GetProcAddress(a->Dll, "CreateScriptEnvironment"))) {
			delete a;
			return NULL;
		}

		return a;
	}

	__declspec(dllexport) void DeInitializeAsif(AsifData * a) {
		FreeLibrary(a->Dll);
		delete a;
	}

	__declspec(dllexport) CAsifScriptEnvironment* NewAsifScriptEnvironment(AsifData *a) {
		IScriptEnvironment* se;
		try { se=(*a->CreateScriptEnvironment)(AVISYNTH_INTERFACE_VERSION); } catch (...) { return NULL; }
		if (se == NULL) {
			delete a;
			return NULL;
		}

		return new CAsifScriptEnvironment(se);
	}

	__declspec(dllexport) void SetVar(const char* varname, AVSValueStruct varvalue, CAsifScriptEnvironment* env) {
		return env->SetVar(varname,varvalue);
	}

	__declspec(dllexport) void DeleteAsifClip(CAsifClip* clip) {
		delete clip;
	}

	__declspec(dllexport) void DeleteAsifVideoFrame(CAsifVideoFrame* frame) {
		delete frame;
	}

	__declspec(dllexport) void DeleteAsifScriptEnvironment(CAsifScriptEnvironment* env) {
		delete env;
	}

	__declspec(dllexport) int CharArg(const char* arg, const char* argname, CAsifScriptEnvironment* env) {
		return env->CharArg(arg,argname);
	}

	__declspec(dllexport) int IntArg(const int arg, const char* argname, CAsifScriptEnvironment* env) {
		return env->IntArg(arg,argname);
	}

	__declspec(dllexport) int BoolArg(const bool arg, const char* argname, CAsifScriptEnvironment* env) {
		return env->BoolArg(arg,argname);
	}

	__declspec(dllexport) int FloatArg(const float arg, const char* argname, CAsifScriptEnvironment* env) {
		return env->FloatArg(arg,argname);
	}

	__declspec(dllexport) int ClipArg(CAsifClip* clip, const char* argname, CAsifScriptEnvironment* env) {
		return env->ClipArg(clip,argname);
	}

	__declspec(dllexport) int SetWorkingDir(const char* dir, CAsifScriptEnvironment* env) {
		return env->SetWorkingDir(dir);
	}

	__declspec(dllexport) AVSValueStruct Invoke(const char* command, CAsifScriptEnvironment* env) {
		return env->Invoke(command);
	}

	__declspec(dllexport) int SetMemoryMax(int MB, CAsifScriptEnvironment* env) {
		return env->SetMemoryMax(MB);
	}

	__declspec(dllexport) VideoInfo GetVideoInfo(CAsifClip* clip) {
		return clip->GetVideoInfo();
	}

	__declspec(dllexport) CAsifVideoFrame* GetVideoPointer(int n, CAsifClip* clip) {
		return clip->GetFrame(n);
	}

} // extern "C"

VideoInfo CAsifClip::GetVideoInfo() {
	return vi;
}

int CAsifVideoFrame::GetPitch(int plane) {
	return pf->GetPitch(plane);
}

int CAsifVideoFrame::GetHeight(int plane) {
	return pf->GetHeight(plane);
}

int CAsifVideoFrame::GetRowSize(int plane) {
	return pf->GetRowSize(plane);
}

bool CAsifVideoFrame::IsWritable() {
	return pf->IsWritable();
}

BYTE* CAsifVideoFrame::GetWritePtr(int plane) {
	return pf->GetWritePtr(plane);
}

const BYTE* CAsifVideoFrame::GetReadPtr(int plane) {
	return pf->GetReadPtr(plane);
}

CAsifVideoFrame::CAsifVideoFrame(PVideoFrame vf) {
	pf=vf;
}

CAsifVideoFrame* CAsifClip::GetFrame(int n) {
	return new CAsifVideoFrame(video->GetFrame(n,clipse));
}

void CAsifClip::GetAudio(void* buf, __int64 start, __int64 count) {
	video->GetAudio(buf,start,count,clipse);
}

bool CAsifClip::GetParity(int n) {
	return video->GetParity(n);
}

void CAsifClip::SetCacheHints(int cachehints,int frame_range) {
	video->SetCacheHints(cachehints,frame_range);
}

CAsifClip::CAsifClip(PClip clip, IScriptEnvironment* env) {
	video = clip;
	clipse = env;
	vi = clip->GetVideoInfo();
}

void CAsifScriptEnvironment::AddFunction(const char* name, const char* params, IScriptEnvironment::ApplyFunc apply, void* user_data) {
	envse->AddFunction(name,params,apply,user_data);
}

void CAsifScriptEnvironment::SetGlobalVar(const char* varname, AVSValueStruct varvalue) {
	AVSValue var;

	if (varvalue.type == 0) {
		var = AVSValue();
	} else if (varvalue.type == 1) {
		var = AVSValue(varvalue.returnvalue.cval->video);
	} else if (varvalue.type == 2) {
		var = AVSValue(varvalue.returnvalue.bval);
	} else if (varvalue.type == 3) {
		var = AVSValue(varvalue.returnvalue.ival);
	} else if (varvalue.type == 4) {
		var = AVSValue(varvalue.returnvalue.fval);
	} else if (varvalue.type == 5) {
		var = AVSValue(varvalue.returnvalue.sval);
	} else if (varvalue.type == 6) {
		var = AVSValue(0);
	}

	envse->SetGlobalVar(varname,var);
}

long CAsifScriptEnvironment::GetCPUFlags() {
	return envse->GetCPUFlags();
}

bool CAsifScriptEnvironment::FunctionExists(const char* name) {
	return envse->FunctionExists(name);
}

void CAsifScriptEnvironment::CheckVersion(int version) {
	envse->CheckVersion(version);
}

void CAsifScriptEnvironment::AtExit(IScriptEnvironment::ShutdownFunc function, void* user_data) {
	envse->AtExit(function,user_data);
}

bool CAsifScriptEnvironment::MakeWritable(CAsifVideoFrame* pvf) {
	PVideoFrame* tf = &pvf->pf;
	return envse->MakeWritable(tf);
}

void CAsifScriptEnvironment::BitBlt(BYTE* dstp, int dstp_pitch, const BYTE* srcp, int src_pitch, int row_size, int height) {
    envse->BitBlt(dstp, dstp_pitch, srcp, src_pitch, row_size, height);
}

CAsifVideoFrame* CAsifScriptEnvironment::NewVideoFrame(const VideoInfo & vi, int align) {
	return new CAsifVideoFrame(envse->NewVideoFrame(vi, align));
}

void CAsifScriptEnvironment::PopContext() {
    envse->PopContext();
}

void CAsifScriptEnvironment::PushContext(int level) {
    envse->PushContext(level);
}

void CAsifScriptEnvironment::SaveString(const char* s, int length) {
    envse->SaveString(s,length);
}

CAsifVideoFrame* CAsifScriptEnvironment::Subframe(CAsifVideoFrame* src, int rel_offset, int new_pitch, int new_row_size, int new_height) {
	return new CAsifVideoFrame(envse->Subframe(src->pf,rel_offset,new_pitch,new_row_size,new_height));
}

void CAsifScriptEnvironment::VSprintf(const char* fmt, void* val) {
    envse->VSprintf(fmt,val);
}

void CAsifScriptEnvironment::SetVar(const char* varname, AVSValueStruct varvalue) {
	AVSValue var;

	if (varvalue.type == 0) {
		var = AVSValue();
	} else if (varvalue.type == 1) {
		var = AVSValue(varvalue.returnvalue.cval->video);
	} else if (varvalue.type == 2) {
		var = AVSValue(varvalue.returnvalue.bval);
	} else if (varvalue.type == 3) {
		var = AVSValue(varvalue.returnvalue.ival);
	} else if (varvalue.type == 4) {
		var = AVSValue(varvalue.returnvalue.fval);
	} else if (varvalue.type == 5) {
		var = AVSValue(varvalue.returnvalue.sval);
	} else if (varvalue.type == 6) {
		var = AVSValue(0);
	}

	envse->SetGlobalVar(varname,var);
}

CAsifScriptEnvironment::CAsifScriptEnvironment(IScriptEnvironment *ienv) {
	  envse = ienv;
	  argcount = 0;
}

CAsifScriptEnvironment::~CAsifScriptEnvironment() {
	delete envse;
}

int CAsifScriptEnvironment::CharArg(const char* arg, const char* argname) {
	argnames.push_back(argname);
	args.push_back(arg);
	argcount++;
	return 0;
}

int CAsifScriptEnvironment::IntArg(const int arg, const char* argname) {
	argnames.push_back(argname);
	args.push_back(arg);
	argcount++;
	return 0;
}

int CAsifScriptEnvironment::BoolArg(const bool arg, const char* argname) {
	argnames.push_back(argname);
	args.push_back(arg);
	argcount++;
	return 0;
}

int CAsifScriptEnvironment::FloatArg(const float arg, const char* argname) {
	argnames.push_back(argname);
	args.push_back(arg);
	argcount++;
	return 0;
}

int CAsifScriptEnvironment::ClipArg(CAsifClip* clip, const char* argname) {
	argnames.push_back(argname);
	args.push_back(clip->video);
	argcount++;
	return 0;
}

int CAsifScriptEnvironment::SetWorkingDir(const char* dir) {
	return envse->SetWorkingDir(dir);
}

void CAsifScriptEnvironment::ResetArgs() {
	argnames.clear();
	args.clear();
	argcount = 0;
}

AVSValueStruct CAsifScriptEnvironment::Invoke(const char* command) {
	AVSValueStruct ir;
    ir.arraysize = 0;
    ir.errors = false;
	ir.returnvalue.ival = 0;
	ir.type = 0;

	const char ** tempargnames = new const char *[argcount];
	AVSValue* tempargs = new AVSValue[argcount];

	for (int i = 0; i < argcount; i++) {
		tempargs[i] = args[i];
		tempargnames[i] = argnames[i];
	}

	try {
		AVSValue ret = envse->Invoke(command,AVSValue(tempargs,argcount),tempargnames);

		if (ret.IsClip()) {
			ir.returnvalue.cval=new CAsifClip(ret.AsClip(),envse);
		   ir.type = 1;
		} else if (ret.IsBool()) {
			ir.returnvalue.bval=ret.AsBool();
			ir.type = 2;
		} else if (ret.IsInt()) {
			ir.returnvalue.ival=ret.AsInt();
			ir.type = 3;
		} else if (ret.IsFloat()) {
			ir.returnvalue.fval=(float)ret.AsFloat();
			ir.type = 4;
		} else if (ret.IsString()) {
			ir.returnvalue.sval=ret.AsString();
			ir.type = 5;
		} else if (ret.IsArray()) {
		//	ir.returnvalue.aval=ret.
			ir.arraysize = ret.ArraySize();
			ir.type = 6;
		}

	} catch (AvisynthError &e) {
		ir.type=100;
		ir.returnvalue.sval=e.msg;
		ir.errors = 1;
	}

	delete [] tempargnames;
	delete [] tempargs;

	ResetArgs();

	return ir;
}

int CAsifScriptEnvironment::SetMemoryMax(int MB) {
	return envse->SetMemoryMax(MB);
}