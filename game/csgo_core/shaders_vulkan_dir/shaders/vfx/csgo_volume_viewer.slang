//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CS2 Volume Viewer";
	DevShader = true;
	Version = 1;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	ToolsUtil();
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float3 vPositionOs  : POSITION0  < Semantic( PosXyz ); >;                                     
	float2 nInstanceIdx : TEXCOORD13 < Semantic( InstanceTransformUv ); >;                        
};

VS
{
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3064 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1125
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    float _m7;
	};
	
	struct _1108
	{
	    float4 _m0[3];
	};
	
	struct _164
	{
	    _1108 _m0;
	};
	
	struct _1234
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer _Globals_ : register(b0, space0)
	{
	    _1234 _Globals_1_m0 : packoffset(c0);
	    float4 _Globals_1_m1 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static uint nInstanceIdx;
	static float3 output_0;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint nInstanceIdx : TEXCOORD3;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _1108 _25207;
	    [unroll]
	    for (int _1ident = 0; _1ident < 3; _1ident++)
	    {
	        _25207._m0[_1ident] = asfloat(g_transformBuffer.Load4(_1ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	    }
	    float3 _22743;
	    if (((g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u) > 0u)
	    {
	        _22743 = _25207._m0[0].z.xxx;
	    }
	    else
	    {
	        _22743 = 1.0f.xxx;
	    }
	    float3 _12151 = mul(float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]), float4(vPositionOs.xyz * _22743.xyz, 1.0f));
	    float4 _23552 = mul(float4x4(float4(_Globals_1_m0._m0[0].x, _Globals_1_m0._m0[1].x, _Globals_1_m0._m0[2].x, _Globals_1_m0._m0[3].x), float4(_Globals_1_m0._m0[0].y, _Globals_1_m0._m0[1].y, _Globals_1_m0._m0[2].y, _Globals_1_m0._m0[3].y), float4(_Globals_1_m0._m0[0].z, _Globals_1_m0._m0[1].z, _Globals_1_m0._m0[2].z, _Globals_1_m0._m0[3].z), float4(_Globals_1_m0._m0[0].w, _Globals_1_m0._m0[1].w, _Globals_1_m0._m0[2].w, _Globals_1_m0._m0[3].w)), (float4(_12151.xyz, 1.0f) + (_Globals_1_m1 * 1.0f)).xyzw);
	    output_0 = _12151;
	    _23552.y = -_23552.y;
	    gl_Position = _23552;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	Texture3D g_tVolume < Channel(RGB, None(TextureVolume), Linear); OutputFormat(BC7); SrgbRead(false); >;
	
	// Volume
	CreateInputTexture2D(TextureVolume, Srgb, 8, "", "_z0000", "Volume", Default4(1, 1, 1, 1));
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2496 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float3 _Globals_1_m0 : packoffset(c26);
	};
	
	Texture3D<float4> g_tVolume : register(t30, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_AllowGlobalMipBiasOverride_0_Filter_MinMagMipLinear : register(s14, space1);
	
	static float3 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float3 _8082 = normalize(input_0.xyz - _Globals_1_m0);
	    float3 _13136;
	    float3 _16324;
	    _13136 = 0.0f.xxx;
	    _16324 = (input_0.xyz + 16.0f.xxx) * 0.03125f;
	    int _3048;
	    float3 _4203;
	    float3 _25163;
	    float3 _20237;
	    int _17017 = 0;
	    for (;;)
	    {
	        _3048 = _17017 + 1;
	        if (!(_3048 < 64))
	        {
	            _20237 = _13136;
	            break;
	        }
	        _25163 = _13136.xyz + g_tVolume.SampleLevel(AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_AllowGlobalMipBiasOverride_0_Filter_MinMagMipLinear, _16324.xyz, 0.0f).xyz;
	        _4203 = _16324 + (_8082 * 0.0199999995529651641845703125f);
	        bool _12885;
	        if (_4203.x < 0.0f)
	        {
	            _12885 = true;
	        }
	        else
	        {
	            _12885 = _4203.y < 0.0f;
	        }
	        bool _12886;
	        if (_12885)
	        {
	            _12886 = true;
	        }
	        else
	        {
	            _12886 = _4203.z < 0.0f;
	        }
	        bool _12888;
	        if (_12886)
	        {
	            _12888 = true;
	        }
	        else
	        {
	            bool _12887;
	            if (_4203.x > 1.0f)
	            {
	                _12887 = true;
	            }
	            else
	            {
	                _12887 = _4203.y > 1.0f;
	            }
	            bool _12501;
	            if (_12887)
	            {
	                _12501 = true;
	            }
	            else
	            {
	                _12501 = _4203.z > 1.0f;
	            }
	            _12888 = _12501;
	        }
	        if (_12888)
	        {
	            _20237 = _25163;
	            break;
	        }
	        _13136 = _25163;
	        _16324 = _4203;
	        _17017 = _3048;
	        continue;
	    }
	    output_0 = float4(_20237.xyz / float(_3048).xxx, 1.0f);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
