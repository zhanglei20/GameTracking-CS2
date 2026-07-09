//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Error shader";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
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

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                          
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2720 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1119
	{
	    float3x4 _m0;
	};
	
	struct _1126
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
	
	struct _1120
	{
	    row_major float3x4 _m0;
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer PerViewConstantBuffer_t : register(b0, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static uint vPositionOs;
	static uint4 vBlendIndices;
	static float3 nInstanceIdx;
	static float3 output_0;
	
	struct VS_INPUT
	{
	    float3 nInstanceIdx : TEXCOORD0;
	    uint4 vBlendIndices : TEXCOORD1;
	    uint vPositionOs : TEXCOORD2;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _1126 _24007;
	    _24007._m0 = g_instanceBuffer.Load(vPositionOs * 32 + 0);
	    _24007._m1 = g_instanceBuffer.Load(vPositionOs * 32 + 4);
	    _24007._m2 = g_instanceBuffer.Load(vPositionOs * 32 + 8);
	    _24007._m3 = g_instanceBuffer.Load(vPositionOs * 32 + 12);
	    _24007._m4 = g_instanceBuffer.Load(vPositionOs * 32 + 16);
	    _24007._m5 = g_instanceBuffer.Load(vPositionOs * 32 + 20);
	    _24007._m6 = g_instanceBuffer.Load(vPositionOs * 32 + 24);
	    _24007._m7 = asfloat(g_instanceBuffer.Load(vPositionOs * 32 + 28));
	    _1125 _20228;
	    _20228._m0 = _24007._m0;
	    _20228._m1 = _24007._m1;
	    _20228._m2 = _24007._m2;
	    _20228._m3 = _24007._m3;
	    _20228._m4 = _24007._m4;
	    _20228._m5 = _24007._m5;
	    _20228._m6 = _24007._m6;
	    _20228._m7 = _24007._m7;
	    uint _16987 = (_20228._m5 >> uint(16)) & 15u;
	    uint _21709;
	    if (_16987 == 1u)
	    {
	        _21709 = _20228._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21709 = _20228._m1;
	    }
	    _1120 _11578;
	    _11578._m0 = asfloat(uint3x4(g_transformBuffer.Load4(_21709 * 48 + 0), g_transformBuffer.Load4(_21709 * 48 + 16), g_transformBuffer.Load4(_21709 * 48 + 32)));
	    _1119 _21957;
	    _21957._m0 = _11578._m0;
	    float3 _22743;
	    if (_16987 > 0u)
	    {
	        _1120 _10769;
	        _10769._m0 = asfloat(uint3x4(g_transformBuffer.Load4(_20228._m1 * 48 + 0), g_transformBuffer.Load4(_20228._m1 * 48 + 16), g_transformBuffer.Load4(_20228._m1 * 48 + 32)));
	        _1119 _20229;
	        _20229._m0 = _10769._m0;
	        _22743 = _20229._m0[0].z.xxx;
	    }
	    else
	    {
	        _22743 = 1.0f.xxx;
	    }
	    float3 _12151 = mul(_21957._m0, float4(nInstanceIdx.xyz * _22743.xyz, 1.0f));
	    float4 _17914 = mul(PerViewConstantBuffer_t_1_m0, (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    output_0 = _12151;
	    _17914.y = -_17914.y;
	    gl_Position = _17914;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vBlendIndices = stage_input.vBlendIndices;
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
	
	float g_flTime < Attribute("Time"); UiType(Slider); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1232 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flTime : packoffset(c0);
	};
	
	
	static float3 input_0;
	static float4 output_0;
	static float4 output_1;
	static float4 output_2;
	static float4 output_3;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	    float4 output_1 : SV_Target1;
	    float4 output_2 : SV_Target2;
	    float4 output_3 : SV_Target3;
	};
	
	void MainPs_inner()
	{
	    output_0 = float4(lerp(0.100000001490116119384765625f, (sin(_Globals_1_g_flTime * 6.0f) * 0.5f) + 0.5f, 2.0f * frac(((floor(input_0.x * 0.5f) + floor(input_0.y * 0.5f)) + floor(input_0.z * 0.5f)) * 0.5f)), 0.0f, 0.0f, 1.0f);
	    output_1 = 0.0f.xxxx;
	    output_2 = 0.0f.xxxx;
	    output_3 = 0.0f.xxxx;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
