//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Computes culling bits for screen space tiles";
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
	DynamicCombo( D_SUBGROUP_SIZE_32, 0..1 );
	
	cbuffer CullParams_t < Attribute("CullParams_t"); >;
	StructuredBuffer g_CullItems < Attribute("CullItems"); >;
	StructuredBuffer g_CullPlanes < Attribute("CullPlanes"); >;
	RWStructuredBuffer g_OutputCullBits < Attribute("OutputCullBits"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (7684 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _2681
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
	
	static bool _5;
	
	cbuffer CullParams_t : register(b1, space0)
	{
	    uint CullParams_t_1_m0 : packoffset(c0.y);
	    uint CullParams_t_1_m1 : packoffset(c0.z);
	    float CullParams_t_1_m2 : packoffset(c0.w);
	    float2 CullParams_t_1_m3 : packoffset(c1);
	    float2 CullParams_t_1_m4 : packoffset(c1.z);
	    uint4 CullParams_t_1_m5 : packoffset(c3);
	    _2681 CullParams_t_1_m6 : packoffset(c4);
	};
	
	ByteAddressBuffer g_CullItems : register(t31, space0);
	ByteAddressBuffer g_CullPlanes : register(t30, space0);
	RWByteAddressBuffer undetermined : register(u158, space0);
	
	static uint3 gl_WorkGroupID;
	static uint3 gl_LocalInvocationID;
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_WorkGroupID : SV_GroupID;
	    uint3 gl_LocalInvocationID : SV_GroupThreadID;
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	groupshared uint _5602;
	
	void MainCs_inner()
	{
	    uint _22151 = (gl_WorkGroupID.z >= CullParams_t_1_m5.z) ? 2u : uint(gl_WorkGroupID.z >= CullParams_t_1_m5.y);
	    uint _3251 = gl_WorkGroupID.z - CullParams_t_1_m5[_22151];
	    _1017 _20228;
	    _20228._m0 = CullParams_t_1_m6._m0[_22151]._m0;
	    _20228._m1 = CullParams_t_1_m6._m0[_22151]._m1;
	    _20228._m2 = CullParams_t_1_m6._m0[_22151]._m2;
	    _20228._m3 = CullParams_t_1_m6._m0[_22151]._m3;
	    float2 _23453 = (float2(gl_GlobalInvocationID.xy) * CullParams_t_1_m3) + CullParams_t_1_m4;
	    uint2 _7433 = gl_WorkGroupID.xy * uint2(8u, 4u);
	    float2 _16631 = (float2(_7433) * CullParams_t_1_m3) + CullParams_t_1_m4;
	    float2 _17028 = (float2(_7433 + uint2(7u, 3u)) * CullParams_t_1_m3) + CullParams_t_1_m4;
	    float2 _4823 = (_17028 + _16631) * 0.5f;
	    float2 _3512 = abs(_17028 - _16631) * 0.5f;
	    uint _3716 = (gl_LocalInvocationID.y * 8u) + gl_LocalInvocationID.x;
	    if (all(bool3(gl_LocalInvocationID.x == uint3(0u, 0u, 0u).x, gl_LocalInvocationID.y == uint3(0u, 0u, 0u).y, gl_LocalInvocationID.z == uint3(0u, 0u, 0u).z)))
	    {
	        _5602 = 0u;
	    }
	    uint _24395 = _20228._m2 + (_3251 * 32u);
	    _1936 _17001;
	    _17001._m0 = g_CullItems.Load((_24395 + _3716) * 80 + 0);
	    _17001._m1 = g_CullItems.Load((_24395 + _3716) * 80 + 4);
	    _17001._m2 = g_CullItems.Load((_24395 + _3716) * 80 + 8);
	    _17001._m3 = g_CullItems.Load((_24395 + _3716) * 80 + 12);
	    _17001._m4 = asfloat(g_CullItems.Load2((_24395 + _3716) * 80 + 16));
	    _17001._m5 = asfloat(g_CullItems.Load2((_24395 + _3716) * 80 + 24));
	    _17001._m6 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 32));
	    _17001._m7 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 36));
	    _17001._m8 = asfloat(g_CullItems.Load2((_24395 + _3716) * 80 + 40));
	    _17001._m9 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 48));
	    _17001._m10 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 52));
	    _17001._m11 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 56));
	    _17001._m12 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 60));
	    _17001._m13 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 64));
	    _17001._m14 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 68));
	    _17001._m15 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 72));
	    _17001._m16 = asfloat(g_CullItems.Load((_24395 + _3716) * 80 + 76));
	    _1935 _21178;
	    _21178._m0 = _17001._m0;
	    _21178._m1 = _17001._m1;
	    _21178._m2 = _17001._m2;
	    _21178._m3 = _17001._m3;
	    _21178._m4 = _17001._m4;
	    _21178._m5 = _17001._m5;
	    _21178._m6 = _17001._m6;
	    _21178._m7 = _17001._m7;
	    _21178._m8 = _17001._m8;
	    _21178._m9 = _17001._m9;
	    _21178._m10 = _17001._m10;
	    _21178._m11 = _17001._m11;
	    _21178._m12 = _17001._m12;
	    _21178._m13 = _17001._m13;
	    _21178._m14 = _17001._m14;
	    _21178._m15 = _17001._m15;
	    _21178._m16 = _17001._m16;
	    float2 _4241 = _21178._m4 - _3512;
	    float2 _5212 = _21178._m5 + _3512;
	    bool2 _20688 = bool2(_4823.x >= _4241.x, _4823.y >= _4241.y);
	    bool2 _8020 = bool2(_5212.x >= _4823.x, _5212.y >= _4823.y);
	    uint _15363;
	    if (all(bool2(_20688.x && _8020.x, _20688.y && _8020.y)))
	    {
	        _15363 = 1u << _3716;
	    }
	    else
	    {
	        _15363 = 0u;
	    }
	    GroupMemoryBarrierWithGroupSync();
	    if (_15363 != 0u)
	    {
	        uint _23780;
	        InterlockedOr(_5602, _15363, _23780);
	    }
	    GroupMemoryBarrierWithGroupSync();
	    uint _17133;
	    _17133 = 0u;
	    uint _3461;
	    uint _12503;
	    bool _13175;
	    bool _13177;
	    bool _13136;
	    bool _16305;
	    uint _17017 = _5602;
	    for (;;)
	    {
	        if (!(_17017 != 0u))
	        {
	            break;
	        }
	        uint _17426 = firstbitlow(_17017);
	        _3461 = _17017 & (_17017 - 1u);
	        _1936 _17002;
	        _17002._m0 = g_CullItems.Load((_24395 + _17426) * 80 + 0);
	        _17002._m1 = g_CullItems.Load((_24395 + _17426) * 80 + 4);
	        _17002._m2 = g_CullItems.Load((_24395 + _17426) * 80 + 8);
	        _17002._m3 = g_CullItems.Load((_24395 + _17426) * 80 + 12);
	        _17002._m4 = asfloat(g_CullItems.Load2((_24395 + _17426) * 80 + 16));
	        _17002._m5 = asfloat(g_CullItems.Load2((_24395 + _17426) * 80 + 24));
	        _17002._m6 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 32));
	        _17002._m7 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 36));
	        _17002._m8 = asfloat(g_CullItems.Load2((_24395 + _17426) * 80 + 40));
	        _17002._m9 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 48));
	        _17002._m10 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 52));
	        _17002._m11 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 56));
	        _17002._m12 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 60));
	        _17002._m13 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 64));
	        _17002._m14 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 68));
	        _17002._m15 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 72));
	        _17002._m16 = asfloat(g_CullItems.Load((_24395 + _17426) * 80 + 76));
	        _1935 _20229;
	        _20229._m0 = _17002._m0;
	        _20229._m1 = _17002._m1;
	        _20229._m2 = _17002._m2;
	        _20229._m3 = _17002._m3;
	        _20229._m4 = _17002._m4;
	        _20229._m5 = _17002._m5;
	        _20229._m6 = _17002._m6;
	        _20229._m7 = _17002._m7;
	        _20229._m8 = _17002._m8;
	        _20229._m9 = _17002._m9;
	        _20229._m10 = _17002._m10;
	        _20229._m11 = _17002._m11;
	        _20229._m12 = _17002._m12;
	        _20229._m13 = _17002._m13;
	        _20229._m14 = _17002._m14;
	        _20229._m15 = _17002._m15;
	        _20229._m16 = _17002._m16;
	        bool _12885;
	        do
	        {
	            if (_20229._m15 == 0.0f)
	            {
	                _12885 = true;
	                break;
	            }
	            float _7381 = _23453.x;
	            float _16189 = _23453.y;
	            _12885 = ((((((_20229._m9 * (_7381 * _7381)) + (_20229._m10 * (_16189 * _16189))) + (_20229._m11 * (_7381 * _16189))) + (_20229._m12 * _7381)) + (_20229._m13 * _16189)) + _20229._m14) >= 0.0f;
	            break;
	        } while(false);
	        bool _16055;
	        if (_12885)
	        {
	            bool _12501;
	            do
	            {
	                if (_20229._m2 != 0u)
	                {
	                    float2 _13155;
	                    _13155 = asfloat(g_CullPlanes.Load2(((_20229._m0 + _20229._m2) - 1u) * 8 + 0));
	                    float2 _6325;
	                    uint _23989;
	                    bool _13174;
	                    bool _16054;
	                    uint _16208 = 0u;
	                    for (;;)
	                    {
	                        if (!(_16208 < _20229._m2))
	                        {
	                            _13174 = _16305;
	                            _16054 = false;
	                            break;
	                        }
	                        _6325 = asfloat(g_CullPlanes.Load2((_20229._m0 + _16208) * 8 + 0));
	                        float2 _6626 = _6325 - _13155;
	                        float2 _10733 = float2(-_6626.y, _6626.x);
	                        if ((dot(_10733, _23453) + CullParams_t_1_m2) < dot(_10733, _6325))
	                        {
	                            _13174 = false;
	                            _16054 = true;
	                            break;
	                        }
	                        _23989 = _16208 + 1u;
	                        _13155 = _6325;
	                        _16208 = _23989;
	                        continue;
	                    }
	                    if (_16054)
	                    {
	                        _12501 = _13174;
	                        break;
	                    }
	                }
	                _12501 = true;
	                break;
	            } while(false);
	            _13175 = _12501;
	            _16055 = _12501;
	        }
	        else
	        {
	            _13175 = _16305;
	            _16055 = false;
	        }
	        bool _16057;
	        if (_16055)
	        {
	            uint _24392 = _20229._m0 + _20229._m2;
	            bool _12502;
	            do
	            {
	                if (_20229._m3 != 0u)
	                {
	                    float2 _13156;
	                    _13156 = asfloat(g_CullPlanes.Load2(((_24392 + _20229._m3) - 1u) * 8 + 0));
	                    float2 _6326;
	                    uint _23990;
	                    bool _13176;
	                    bool _16056;
	                    uint _16209 = 0u;
	                    for (;;)
	                    {
	                        if (!(_16209 < _20229._m3))
	                        {
	                            _13176 = _13136;
	                            _16056 = false;
	                            break;
	                        }
	                        _6326 = asfloat(g_CullPlanes.Load2((_24392 + _16209) * 8 + 0));
	                        float2 _6627 = _6326 - _13156;
	                        float2 _10734 = float2(-_6627.y, _6627.x);
	                        if ((dot(_10734, _23453) + CullParams_t_1_m2) < dot(_10734, _6326))
	                        {
	                            _13176 = false;
	                            _16056 = true;
	                            break;
	                        }
	                        _23990 = _16209 + 1u;
	                        _13156 = _6326;
	                        _16209 = _23990;
	                        continue;
	                    }
	                    if (_16056)
	                    {
	                        _12502 = _13176;
	                        break;
	                    }
	                }
	                _12502 = true;
	                break;
	            } while(false);
	            _13177 = _12502;
	            _16057 = _12502;
	        }
	        else
	        {
	            _13177 = _13136;
	            _16057 = false;
	        }
	        if (_16057)
	        {
	            _12503 = _17133 | (1u << _17426);
	        }
	        else
	        {
	            _12503 = _17133;
	        }
	        _13136 = _13177;
	        _16305 = _13175;
	        _17133 = _12503;
	        _17017 = _3461;
	        continue;
	    }
	    bool _12886;
	    if (gl_GlobalInvocationID.x < CullParams_t_1_m0)
	    {
	        _12886 = gl_GlobalInvocationID.y < CullParams_t_1_m1;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    if (_12886)
	    {
	        undetermined.Store(((_20228._m0 + (((gl_GlobalInvocationID.y * CullParams_t_1_m0) + gl_GlobalInvocationID.x) * _20228._m1)) + _3251) * 4 + 0, _17133);
	    }
	}
	
	[numthreads(8, 4, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_WorkGroupID = stage_input.gl_WorkGroupID;
	    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
