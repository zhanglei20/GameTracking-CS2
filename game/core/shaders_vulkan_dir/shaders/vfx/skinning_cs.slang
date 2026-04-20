//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Vertex Skinning CS";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
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
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicCombo( D_MORPH, 0..1 );
	DynamicCombo( D_EIGHT_BONE_SKINNING, 0..1 );
	DynamicCombo( D_TOOLS_VIS, 0..1 );
	DynamicCombo( D_LATTICE_DEFORMER, 0..1 );
	DynamicComboRule( Allow1( D_MORPH, D_LATTICE_DEFORMER ) );
	
	cbuffer VertexCachePushConstants < Source(ExternalDescSet); Attribute("VertexCachePushConstants"); >;
	ByteAddressBuffer g_inputVB < Attribute("InputVB"); SrgbRead(false); >;
	StructuredBuffer g_instances < Attribute("Instances"); SrgbRead(false); >;
	int g_nMorphTextureAtlasWidth < Attribute("MorphTextureAtlasWidth"); UiType(Slider); >;
	RWByteAddressBuffer g_outputVB < Attribute("OutputVB"); >;
	Texture2D g_tCompositeMorphTextureAtlas < Attribute("CompositeMorphTextureAtlas"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (11716 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1017
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	};
	
	struct _1949
	{
	    float4 _m0[3];
	};
	
	struct _1844
	{
	    _1949 _m0;
	};
	
	static float4 _3;
	
	ByteAddressBuffer g_instances : register(t37, space0);
	ByteAddressBuffer g_inputVB : register(t36, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	RWByteAddressBuffer undetermined : register(u158, space0);
	cbuffer _1170_3444
	{
	    uint _3444_m0 : packoffset(c0);
	    uint _3444_m1 : packoffset(c0.y);
	    uint _3444_m2 : packoffset(c0.z);
	    uint _3444_m3 : packoffset(c0.w);
	    uint _3444_m4 : packoffset(c1);
	    uint _3444_m5 : packoffset(c1.y);
	    uint _3444_m6 : packoffset(c1.z);
	    uint _3444_m7 : packoffset(c1.w);
	    uint _3444_m8 : packoffset(c2);
	    uint _3444_m9 : packoffset(c2.y);
	};
	
	
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	void MainCs_inner()
	{
	    do
	    {
	        if (gl_GlobalInvocationID.x >= _3444_m0)
	        {
	            break;
	        }
	        if (gl_GlobalInvocationID.y >= _3444_m9)
	        {
	            break;
	        }
	        uint _13724 = _3444_m8 + gl_GlobalInvocationID.y;
	        uint _3973 = g_instances.Load(_13724 * 16 + 0) + (gl_GlobalInvocationID.x * _3444_m3);
	        uint _20858 = _3973 + _3444_m1;
	        uint _6233 = g_inputVB.Load((_20858 / 4u) * 4 + 0);
	        uint _6234 = g_inputVB.Load(((_20858 + 4u) / 4u) * 4 + 0);
	        uint _14347 = g_inputVB.Load(((_20858 + 8u) / 4u) * 4 + 0);
	        float4 _9716;
	        float3 _24878;
	        if (_3444_m7 == 4294967295u)
	        {
	            uint _23043 = uint(int(_3973 + _3444_m6)) / 4u;
	            float _22483 = (float((g_inputVB.Load(_23043 * 4 + 0) >> 12u) & 1023u) * 0.00195503421127796173095703125f) - 1.0f;
	            float _7589 = (float((g_inputVB.Load(_23043 * 4 + 0) >> 22u) & 1023u) * 0.00195503421127796173095703125f) - 1.0f;
	            float _23404 = (1.0f - abs(_22483)) - abs(_7589);
	            float3 _8254 = float3(_22483, _7589, _23404);
	            float _24228 = clamp(-_23404, 0.0f, 1.0f);
	            float2 _7335 = float2(_22483, _7589);
	            bool2 _10803 = bool2(_7335.x >= 0.0f.xx.x, _7335.y >= 0.0f.xx.y);
	            float2 _14501 = (-_24228).xx;
	            float2 _8565 = _24228.xx;
	            float2 _14350 = _7335 + float2(_10803.x ? _14501.x : _8565.x, _10803.y ? _14501.y : _8565.y);
	            _8254.x = _14350.x;
	            _8254.y = _14350.y;
	            float3 _21001 = normalize(_8254);
	            float _6384 = _21001.z;
	            float _8220 = (_6384 >= 0.0f) ? 1.0f : (-1.0f);
	            float _16417 = (-1.0f) / (_8220 + _6384);
	            float _14755 = _21001.x;
	            float3 _23176 = float3(1.0f + (((_8220 * _14755) * _14755) * _16417), _8220 * ((_14755 * _21001.y) * _16417), (-_8220) * _14755);
	            float _23966 = float((g_inputVB.Load(_23043 * 4 + 0) >> uint(1)) & 2047u) * 0.003069460391998291015625f;
	            _9716 = float4((_23176 * cos(_23966)) + (cross(_21001, _23176) * sin(_23966)), ((g_inputVB.Load(_23043 * 4 + 0) & 1u) == 0u) ? (-1.0f) : 1.0f);
	            _24878 = _21001;
	        }
	        else
	        {
	            uint _20861 = _3973 + _3444_m6;
	            float4 _12501;
	            if (_3444_m7 < 4294967295u)
	            {
	                uint _21336 = _3973 + _3444_m7;
	                _12501 = asfloat(uint4(g_inputVB.Load((_21336 / 4u) * 4 + 0), g_inputVB.Load(((_21336 + 4u) / 4u) * 4 + 0), g_inputVB.Load(((_21336 + 8u) / 4u) * 4 + 0), g_inputVB.Load(((_21336 + 12u) / 4u) * 4 + 0)));
	            }
	            else
	            {
	                _12501 = float4(0.0f, 0.0f, 1.0f, 1.0f);
	            }
	            _9716 = _12501;
	            _24878 = asfloat(uint3(g_inputVB.Load((_20861 / 4u) * 4 + 0), g_inputVB.Load(((_20861 + 4u) / 4u) * 4 + 0), g_inputVB.Load(((_20861 + 8u) / 4u) * 4 + 0)));
	        }
	        uint _3718 = g_instances.Load(_13724 * 16 + 8) & 15u;
	        uint4 _18844;
	        if (_3444_m2 < 4294967295u)
	        {
	            uint4 _12503;
	            if (_3444_m4 == 16u)
	            {
	                uint _21337 = _3973 + _3444_m2;
	                uint _12585 = _21337 / 4u;
	                uint _6760 = (_21337 + 4u) / 4u;
	                _12503 = uint4(g_inputVB.Load(_12585 * 4 + 0) & 65535u, g_inputVB.Load(_12585 * 4 + 0) >> uint(16), g_inputVB.Load(_6760 * 4 + 0) & 65535u, g_inputVB.Load(_6760 * 4 + 0) >> uint(16));
	            }
	            else
	            {
	                uint4 _12502;
	                if (_3444_m4 == 10u)
	                {
	                    uint _23045 = uint(int(_3973 + _3444_m2)) / 4u;
	                    uint4 _25107 = uint4(4294967295u, 4294967295u, 4294967295u, 4294967295u);
	                    _25107.x = g_inputVB.Load(_23045 * 4 + 0) & 1023u;
	                    _25107.y = (g_inputVB.Load(_23045 * 4 + 0) >> uint(10)) & 1023u;
	                    _25107.z = (g_inputVB.Load(_23045 * 4 + 0) >> uint(20)) & 1023u;
	                    _12502 = _25107;
	                }
	                else
	                {
	                    uint _23044 = uint(int(_3973 + _3444_m2)) / 4u;
	                    _12502 = uint4(g_inputVB.Load(_23044 * 4 + 0) & 255u, (g_inputVB.Load(_23044 * 4 + 0) >> uint(8)) & 255u, (g_inputVB.Load(_23044 * 4 + 0) >> uint(16)) & 255u, (g_inputVB.Load(_23044 * 4 + 0) >> uint(24)) & 255u);
	                }
	                _12503 = _12502;
	            }
	            _18844 = _12503;
	        }
	        else
	        {
	            _18844 = uint4(4294967295u, 4294967295u, 4294967295u, 4294967295u);
	        }
	        float4 _19210;
	        _19210.x = 1.0f;
	        float4 _11521;
	        if (_3444_m5 < 4294967295u)
	        {
	            uint _23046 = uint(int(_3973 + _3444_m5)) / 4u;
	            _11521 = float4(float(g_inputVB.Load(_23046 * 4 + 0) & 255u), float((g_inputVB.Load(_23046 * 4 + 0) >> uint(8)) & 255u), float((g_inputVB.Load(_23046 * 4 + 0) >> uint(16)) & 255u), float((g_inputVB.Load(_23046 * 4 + 0) >> uint(24)) & 255u)) * 0.0039215688593685626983642578125f;
	        }
	        else
	        {
	            _11521 = _19210;
	        }
	        int _12463 = int(g_instances.Load(_13724 * 16 + 8) >> uint(4));
	        uint4 _24078 = _18844;
	        float4 _14049 = _11521;
	        float3x4 _20691;
	        if (_18844.x < 4294967295u)
	        {
	            uint _13628 = uint(_12463 + 2);
	            _1949 _25208;
	            [unroll]
	            for (int _3ident = 0; _3ident < 3; _3ident++)
	            {
	                _25208._m0[_3ident] = asfloat(g_transformBuffer.Load4(_3ident * 16 + (_13628 + _18844.x) * 48 + 0));
	            }
	            float3x4 _13155;
	            _13155 = float3x4(_25208._m0[0] * _11521.x, _25208._m0[1] * _11521.x, _25208._m0[2] * _11521.x);
	            uint _18440;
	            float3x4 _25251;
	            uint _16208 = 1u;
	            for (;;)
	            {
	                if (!(_16208 < _3718))
	                {
	                    break;
	                }
	                _1949 _25209;
	                [unroll]
	                for (int _4ident = 0; _4ident < 3; _4ident++)
	                {
	                    _25209._m0[_4ident] = asfloat(g_transformBuffer.Load4(_4ident * 16 + (_13628 + _24078[_16208]) * 48 + 0));
	                }
	                _25251 = float3x4(_13155[0] + (_25209._m0[0] * _14049[_16208]), _13155[1] + (_25209._m0[1] * _14049[_16208]), _13155[2] + (_25209._m0[2] * _14049[_16208]));
	                _18440 = _16208 + 1u;
	                _13155 = _25251;
	                _16208 = _18440;
	                continue;
	            }
	            _20691 = _13155;
	        }
	        else
	        {
	            _1949 _25207;
	            [unroll]
	            for (int _5ident = 0; _5ident < 3; _5ident++)
	            {
	                _25207._m0[_5ident] = asfloat(g_transformBuffer.Load4(_5ident * 16 + _12463 * 48 + 0));
	            }
	            _20691 = float3x4(_25207._m0[0] * _11521.x, _25207._m0[1] * _11521.x, _25207._m0[2] * _11521.x);
	        }
	        float3 _11198 = normalize(mul(_20691, float4(_24878.xyz, 0.0f)));
	        float3 _19629 = mul(_20691, float4(_9716.xyz, 0.0f));
	        float3 _19000 = _11198 / ((abs(_11198.x) + abs(_11198.y)) + abs(_11198.z)).xxx;
	        float2 _19321;
	        if (_19000.z >= 0.0f)
	        {
	            _19321 = _19000.xy;
	        }
	        else
	        {
	            float2 _8488 = _19000.xy;
	            bool2 _19837 = bool2(_8488.x >= 0.0f.xx.x, _8488.y >= 0.0f.xx.y);
	            _19321 = (1.0f.xx - abs(_19000.yx)) * float2(_19837.x ? 1.0f.xx.x : (-1.0f).xx.x, _19837.y ? 1.0f.xx.y : (-1.0f).xx.y);
	        }
	        float3 _19001 = _19629 / ((abs(_19629.x) + abs(_19629.y)) + abs(_19629.z)).xxx;
	        float2 _19322;
	        if (_19001.z >= 0.0f)
	        {
	            _19322 = _19001.xy;
	        }
	        else
	        {
	            float2 _8489 = _19001.xy;
	            bool2 _19838 = bool2(_8489.x >= 0.0f.xx.x, _8489.y >= 0.0f.xx.y);
	            _19322 = (1.0f.xx - abs(_19001.yx)) * float2(_19838.x ? 1.0f.xx.x : (-1.0f).xx.x, _19838.y ? 1.0f.xx.y : (-1.0f).xx.y);
	        }
	        uint _15034 = g_instances.Load(_13724 * 16 + 4);
	        uint _5273 = 24u * (gl_GlobalInvocationID.x + _15034);
	        uint3 _9171 = asuint(mul(_20691, float4(asfloat(uint3(_6233, _6234, _14347)), 1.0f)));
	        undetermined.Store((_5273 / 4u) * 4 + 0, _9171.x);
	        undetermined.Store(((_5273 + 4u) / 4u) * 4 + 0, _9171.y);
	        undetermined.Store(((_5273 + 8u) / 4u) * 4 + 0, _9171.z);
	        undetermined.Store(((_5273 + 12u) / 4u) * 4 + 0, (uint((clamp(clamp((_19321.x * 0.5f) + 0.5f, 0.0f, 1.0f), 0.0f, 1.0f) * 65535.0f) + 0.5f)) | (uint((clamp(clamp((_19321.y * 0.5f) + 0.5f, 0.0f, 1.0f), 0.0f, 1.0f) * 65535.0f) + 0.5f) << uint(16)));
	        undetermined.Store(((_5273 + 16u) / 4u) * 4 + 0, (uint((_9716.w < 0.0f) ? 0 : 1) | (uint((clamp(clamp((_19322.x * 0.5f) + 0.5f, 0.0f, 1.0f), 0.0f, 1.0f) * 32767.0f) + 0.5f) << uint(1))) | (uint((clamp(clamp((_19322.y * 0.5f) + 0.5f, 0.0f, 1.0f), 0.0f, 1.0f) * 32767.0f) + 0.5f) << uint(16)));
	        undetermined.Store(((_5273 + 20u) / 4u) * 4 + 0, 0u);
	        break;
	    } while(false);
	}
	
	[numthreads(64, 1, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
