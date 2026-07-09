//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Computes culling bits for depth bins";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_50
	// Programs: cs
}

MODES
{
	Default();
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

CS
{
	
	cbuffer CullParams_t < Attribute("CullParams_t"); >;
	StructuredBuffer g_CullItems < Attribute("CullItems"); >;
	RWStructuredBuffer g_OutputCullBits < Attribute("OutputCullBits"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3372 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1017
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	};
	
	struct _1935
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    float2 _m4;
	    float2 _m5;
	    float _m6;
	    float _m7;
	    float2 _m8;
	    float _m9;
	    float _m10;
	    float _m11;
	    float _m12;
	    float _m13;
	    float _m14;
	    float _m15;
	    float _m16;
	};
	
	struct _1018
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	};
	
	struct _535
	{
	    _1018 _m0[3];
	};
	
	struct _1936
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    float2 _m4;
	    float2 _m5;
	    float _m6;
	    float _m7;
	    float2 _m8;
	    float _m9;
	    float _m10;
	    float _m11;
	    float _m12;
	    float _m13;
	    float _m14;
	    float _m15;
	    float _m16;
	};
	
	cbuffer CullParams_t : register(b1, space0)
	{
	    float CullParams_t_1_m0 : packoffset(c2.y);
	    float CullParams_t_1_m1 : packoffset(c2.z);
	    float CullParams_t_1_m2 : packoffset(c2.w);
	    uint4 CullParams_t_1_m3 : packoffset(c3);
	    _535 CullParams_t_1_m4 : packoffset(c7);
	};
	
	ByteAddressBuffer g_CullItems : register(t30, space0);
	RWByteAddressBuffer undetermined : register(u158, space0);
	
	static uint3 gl_WorkGroupID;
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_WorkGroupID : SV_GroupID;
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	void MainCs_inner()
	{
	    uint _22151 = (gl_WorkGroupID.y >= CullParams_t_1_m3.z) ? 2u : uint(gl_WorkGroupID.y >= CullParams_t_1_m3.y);
	    uint _3251 = gl_WorkGroupID.y - CullParams_t_1_m3[_22151];
	    float _17281 = (CullParams_t_1_m2 + (float(gl_GlobalInvocationID.x) * CullParams_t_1_m0)) - CullParams_t_1_m1;
	    float _15813 = (CullParams_t_1_m2 + (float(gl_GlobalInvocationID.x + 1u) * CullParams_t_1_m0)) + CullParams_t_1_m1;
	    _1017 _20228;
	    _20228._m0 = CullParams_t_1_m4._m0[_22151]._m0;
	    _20228._m1 = CullParams_t_1_m4._m0[_22151]._m1;
	    _20228._m2 = CullParams_t_1_m4._m0[_22151]._m2;
	    _20228._m3 = CullParams_t_1_m4._m0[_22151]._m3;
	    uint _5249 = _20228._m2 + (_3251 * 32u);
	    uint _19037 = min(_20228._m3, (_5249 + 32u));
	    uint _13155;
	    _13155 = 0u;
	    uint _4284;
	    uint _14382;
	    uint _16208 = _5249;
	    for (;;)
	    {
	        if (!(_16208 < _19037))
	        {
	            break;
	        }
	        _1936 _10769;
	        _10769._m0 = g_CullItems.Load(_16208 * 80 + 0);
	        _10769._m1 = g_CullItems.Load(_16208 * 80 + 4);
	        _10769._m2 = g_CullItems.Load(_16208 * 80 + 8);
	        _10769._m3 = g_CullItems.Load(_16208 * 80 + 12);
	        _10769._m4 = asfloat(g_CullItems.Load2(_16208 * 80 + 16));
	        _10769._m5 = asfloat(g_CullItems.Load2(_16208 * 80 + 24));
	        _10769._m6 = asfloat(g_CullItems.Load(_16208 * 80 + 32));
	        _10769._m7 = asfloat(g_CullItems.Load(_16208 * 80 + 36));
	        _10769._m8 = asfloat(g_CullItems.Load2(_16208 * 80 + 40));
	        _10769._m9 = asfloat(g_CullItems.Load(_16208 * 80 + 48));
	        _10769._m10 = asfloat(g_CullItems.Load(_16208 * 80 + 52));
	        _10769._m11 = asfloat(g_CullItems.Load(_16208 * 80 + 56));
	        _10769._m12 = asfloat(g_CullItems.Load(_16208 * 80 + 60));
	        _10769._m13 = asfloat(g_CullItems.Load(_16208 * 80 + 64));
	        _10769._m14 = asfloat(g_CullItems.Load(_16208 * 80 + 68));
	        _10769._m15 = asfloat(g_CullItems.Load(_16208 * 80 + 72));
	        _10769._m16 = asfloat(g_CullItems.Load(_16208 * 80 + 76));
	        _1935 _22261;
	        _22261._m0 = _10769._m0;
	        _22261._m1 = _10769._m1;
	        _22261._m2 = _10769._m2;
	        _22261._m3 = _10769._m3;
	        _22261._m4 = _10769._m4;
	        _22261._m5 = _10769._m5;
	        _22261._m6 = _10769._m6;
	        _22261._m7 = _10769._m7;
	        _22261._m8 = _10769._m8;
	        _22261._m9 = _10769._m9;
	        _22261._m10 = _10769._m10;
	        _22261._m11 = _10769._m11;
	        _22261._m12 = _10769._m12;
	        _22261._m13 = _10769._m13;
	        _22261._m14 = _10769._m14;
	        _22261._m15 = _10769._m15;
	        _22261._m16 = _10769._m16;
	        bool _12885;
	        if (_22261._m6 <= _15813)
	        {
	            _12885 = _22261._m7 >= _17281;
	        }
	        else
	        {
	            _12885 = false;
	        }
	        if (_12885)
	        {
	            _14382 = _13155 | (1u << _16208);
	        }
	        else
	        {
	            _14382 = _13155;
	        }
	        _4284 = _16208 + 1u;
	        _13155 = _14382;
	        _16208 = _4284;
	        continue;
	    }
	    undetermined.Store(((_20228._m0 + (gl_GlobalInvocationID.x * _20228._m1)) + _3251) * 4 + 0, _13155);
	}
	
	[numthreads(32, 1, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_WorkGroupID = stage_input.gl_WorkGroupID;
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
