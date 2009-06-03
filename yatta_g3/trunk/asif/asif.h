#include <windows.h>
#include <vector>
#include "avisynth.h"

typedef IScriptEnvironment* (__stdcall *cfunc)(int);

struct AsifData {
	HMODULE Dll;
	cfunc CreateScriptEnvironment;
};

class CAsifVideoFrame {
public:
    PVideoFrame pf;
	CAsifVideoFrame(PVideoFrame vf);
	int GetPitch(int plane);
	int GetHeight(int plane);
	int GetRowSize(int plane);
	bool IsWritable();
	BYTE* GetWritePtr(int plane);
	const BYTE* GetReadPtr(int plane);
};

class CAsifClip {
	friend class CAsifScriptEnvironment;
private:
	PClip video;
	VideoInfo vi;
	IScriptEnvironment* clipse;
public:
	CAsifClip(PClip clip, IScriptEnvironment* env);
	VideoInfo GetVideoInfo();
	CAsifVideoFrame* GetFrame(int n);
    void SetCacheHints(int cachehints,int frame_range);
    bool GetParity(int n);
    void GetAudio(void* buf, __int64 start, __int64 count);
};

struct AVSValueStruct {
	int errors;
	int arraysize;
	int type;
	union {
		int ival;
		float fval;
		bool bval;
		const char* sval;
		CAsifClip* cval;
	} returnvalue;
};

class CAsifScriptEnvironment {
	friend class CAsifVideoFrame;
private:
	IScriptEnvironment* envse;
    int argcount;
	std::vector<AVSValue> args;
    std::vector<const char*> argnames;
	void ResetArgs();
public:
	void SetVar(const char* varname, AVSValueStruct varvalue);
	AVSValueStruct GetVar(const char* varname); 
	int CharArg(const char* arg, const char* argname);
	int IntArg(const int arg, const char* argname);
	int BoolArg(const bool arg, const char* argname);
	int FloatArg(const float arg, const char* argname);
	int ClipArg(CAsifClip* clip, const char* argname);
    CAsifScriptEnvironment(IScriptEnvironment *ienv);
	~CAsifScriptEnvironment();
	int SetWorkingDir(const char* dir);
	AVSValueStruct Invoke(const char* command);
	int SetMemoryMax(int MB);
    void AddFunction(const char* name, const char* params, IScriptEnvironment::ApplyFunc apply, void* user_data);
    long GetCPUFlags();
	void SetGlobalVar(const char* varname, AVSValueStruct varvalue);
    void CheckVersion(int version);
    bool FunctionExists(const char* name);
    bool MakeWritable(CAsifVideoFrame* pvf);
    void AtExit(IScriptEnvironment::ShutdownFunc function, void* user_data);
	CAsifVideoFrame* NewVideoFrame(const VideoInfo & vi, int align);
	void BitBlt(BYTE* dstp, int dstp_pitch, const BYTE* srcp, int src_pitch, int row_size, int height);
	void PopContext();
	void PushContext(int level);
	void VSprintf(const char* fmt, void* val);
    CAsifVideoFrame* Subframe(CAsifVideoFrame* src, int rel_offset, int new_pitch, int new_row_size, int new_height);
    void SaveString(const char* s, int length);
};



