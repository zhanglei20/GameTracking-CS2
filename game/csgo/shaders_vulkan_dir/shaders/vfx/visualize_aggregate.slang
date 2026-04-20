//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	ToolsVis();
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
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nInstanceBufferIndex < Attribute("InstanceID"); UiType(Slider); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3616 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1948
	{
	    float4 _m0[3];
	};
	
	struct _1844
	{
	    _1948 _m0;
	};
	
	struct _2074
	{
	    float4 _m0[4];
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    int _Globals_1_g_nInstanceBufferIndex : packoffset(c0);
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _2074 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static uint nInstanceIdx;
	static float3 output_0;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint nInstanceIdx : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _21116 = (nInstanceIdx + 1u) * 2654435769u;
	    uint _3320 = _21116 & 4294901759u;
	    _1948 _25207;
	    [unroll]
	    for (int _1ident = 0; _1ident < 3; _1ident++)
	    {
	        _25207._m0[_1ident] = asfloat(g_transformBuffer.Load4(_1ident * 16 + g_instanceBuffer.Load(uint(_Globals_1_g_nInstanceBufferIndex) * 32 + 4) * 48 + 0));
	    }
	    float4 _6989 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), (float4(mul(float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]), float4(vPositionOs.xyz, 1.0f)).xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float3 _23610 = float3(float((_3320 >> uint(16)) & 255u) * 0.0039215688593685626983642578125f, float((_3320 >> uint(8)) & 255u) * 0.0039215688593685626983642578125f, float((_3320) & 255u) * 0.0039215688593685626983642578125f).xyz;
	    float3 _12245 = _23610 * _23610;
	    float3 _23482;
	    if ((_21116 & 65536u) != 0u)
	    {
	        _23482 = _12245.xyz * float3(0.25f, 0.5f, 0.75f);
	    }
	    else
	    {
	        _23482 = _12245;
	    }
	    output_0 = _23482;
	    _6989.y = -_6989.y;
	    gl_Position = _6989;
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
	DynamicCombo( D_WIREFRAME, 0..1 );
	DynamicCombo( D_OVERWRITE_DEPTH, 0..1 );
	
	float g_fDepth < Attribute("DepthValue"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (628 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static bool gl_FrontFacing;
	static float3 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    bool gl_FrontFacing : SV_IsFrontFace;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    bool3 _16564 = gl_FrontFacing.xxx;
	    output_0 = float4(float3(_16564.x ? 1.0f.xxx.x : float3(0.20000000298023223876953125f, 0.20000000298023223876953125f, 0.449999988079071044921875f).x, _16564.y ? 1.0f.xxx.y : float3(0.20000000298023223876953125f, 0.20000000298023223876953125f, 0.449999988079071044921875f).y, _16564.z ? 1.0f.xxx.z : float3(0.20000000298023223876953125f, 0.20000000298023223876953125f, 0.449999988079071044921875f).z) * input_0.xyz, 0.0f);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FrontFacing = stage_input.gl_FrontFacing;
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
