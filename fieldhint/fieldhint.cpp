/*
	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/
/* FieldHint 0.1-0.11 by Loren Merritt, Copyright 2004-2005 */
/* FieldHint 0.12 modifictions by Fredrik Mellbin, Copyright 2011 */
/* FieldHint 0.13 modifictions by Fredrik Mellbin, Copyright 2022 */

#include <vector>
#include "avisynth.h"
#include "Utilities.h"
#include "info.h"

struct OVR
{
	int tf, bf, hint;
};

class FieldHint : public GenericVideoFilter
{
public:
	FieldHint(PClip _child, const char* ovrfile, bool _show, IScriptEnvironment* _env) :
		GenericVideoFilter(_child), show(_show), env(_env), ovr(NULL)
	{
		if(!vi.IsYV12())
			env->ThrowError("FieldHint: requires YV12 source");
		if(!ovrfile)
			env->ThrowError("FieldHint: requires option 'ovr'");
		LoadOVR(ovrfile);
	}
	~FieldHint()
	{
		if(ovr) delete [] ovr;
	}
	
	PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* _env);
	
private:
	IScriptEnvironment* env;
	OVR* ovr;
	bool show;

	void LoadOVR(const char* ovrfile);
	void CopyField(PVideoFrame& to, PVideoFrame& from, int field);
	template<class T> void ThrowError(const char* msg, T arg);
};

void FieldHint::LoadOVR(const char* ovrfile)
{
	int line = 0;
	char buf[80];
	char* pos;
	FILE* fh = fopen(ovrfile, "r");
	if(!fh)
		env->ThrowError("FieldHint: can't open ovr file");

	while(fgets(buf, 80, fh))
	{
		if(buf[strspn(buf, " \t\r\n")] == 0) continue;
		line++;
	}
	fseek(fh, 0, 0);

	ovr = new OVR [line];

	line = 0;
	memset(buf, 0, sizeof(buf));
	while(fgets(buf, 80, fh))
	{
		char hint = 0;
		OVR& entry = ovr[line];
		line++;
		pos = buf + strspn(buf, " \t\r\n");

		if(pos[0] == '#' || pos[0] == 0)
			continue;
		else if(sscanf(pos, " %u, %u, %c", &entry.tf, &entry.bf, &hint) == 3);
		else if(sscanf(pos, " %u, %u", &entry.tf, &entry.bf) == 2);
		else ThrowError("can't parse override at line %d", line);

		entry.hint = HINT_INVALID;
		if(hint == '-')
			entry.hint = PROGRESSIVE;
		else if(hint == '+')
			entry.hint = 0;
		else if(hint != 0)
			ThrowError("can't parse override at line %d", line);

		while(buf[78] != 0 && buf[78] != '\n' && fgets(buf, 80, fh))
			; // slurp the rest of a long line
	}

	vi.num_frames = line;
	fclose(fh);
}

template<class T>
void FieldHint::ThrowError(const char* msg, T arg)
{
	// unsafe: I would use snprintf, but MSVC doesn't have it.
	// no, I don't ever free buf
	char* buf = new char[strlen(msg) + 20];
	sprintf(buf, msg, arg);
	env->ThrowError(buf);
}

PVideoFrame __stdcall FieldHint::GetFrame(int n, IScriptEnvironment* env)
{
        PVideoFrame frame = NULL;
        if (ovr[n].tf == ovr[n].bf) {
            frame = child->GetFrame(ovr[n].tf, env);
            env->MakeWritable(&frame);
        } else {
            PVideoFrame tf = NULL;

            if (ovr[n].tf <= ovr[n].bf)
                tf = child->GetFrame(ovr[n].tf, env);

            PVideoFrame bf = child->GetFrame(ovr[n].bf, env);

            if (ovr[n].tf > ovr[n].bf)
                tf = child->GetFrame(ovr[n].tf, env);

            if (tf->IsWritable()) {
                CopyField(tf, bf, 1);
                frame = tf;
            } else if (bf->IsWritable()) {
                CopyField(bf, tf, 0);
                frame = bf;
            } else {
                frame = env->NewVideoFrame(vi);
                CopyField(frame, tf, 0);
                CopyField(frame, bf, 1);
            }
        }

	if(show)
	{
		char buf[80];
		sprintf(buf, "frm:%d fld:%d,%d%s", n, ovr[n].tf, ovr[n].bf,
				ovr[n].hint == PROGRESSIVE ? " -" : ovr[n].hint != HINT_INVALID ? " +" : "");
                DrawString(frame, 5, 5, buf);
	}
	if(ovr[n].hint == HINT_INVALID)
                RemoveHintingData(frame->GetWritePtr(PLANAR_Y));
	else
                PutHintingData(frame->GetWritePtr(PLANAR_Y), ovr[n].hint);
        return frame;
}

void FieldHint::CopyField(PVideoFrame& to, PVideoFrame& from, int field)
{
	const static int planes[] = {PLANAR_Y, PLANAR_U, PLANAR_V};
	int p;
	for(p = 0; p < (vi.IsYV12() ? 3 : 1); p++)
	{
		env->BitBlt(to->GetWritePtr(planes[p]) + to->GetPitch(planes[p])*field,
					to->GetPitch(planes[p])*2,
					from->GetReadPtr(planes[p]) + from->GetPitch(planes[p])*field,
					from->GetPitch(planes[p])*2,
					from->GetRowSize(planes[p]),
					(from->GetHeight(planes[p]) + !field) / 2);
	}
}

AVSValue __cdecl Create_FieldHint(AVSValue args, void* user_data, IScriptEnvironment* env)
{
	return new FieldHint(args[0].AsClip(),
		args[1].AsString(NULL),
		args[2].AsBool(false),
		env);
}

const AVS_Linkage *AVS_linkage = nullptr;

extern "C" __declspec(dllexport) const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
	AVS_linkage = env->GetAVSLinkage();
	env->AddFunction("FieldHint", "c[ovr]s[show]b", Create_FieldHint, 0);
	return 0;
}

