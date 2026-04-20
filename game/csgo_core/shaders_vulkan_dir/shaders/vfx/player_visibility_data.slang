//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "A shader to render player visibility data";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
	CsgoForward();
	Depth("csgo_depth_only.vfx");
	ProjectionDepth("csgo_depth_only.vfx");
	Forward();
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
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3580 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1360
	{
	    float4 _m0[3];
	};
	
	struct _668
	{
	    _1360 _m0;
	};
	
	struct _1486
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _1486 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static uint4 vBlendIndices;
	static uint nInstanceIdx;
	static float3 output_0;
	static float2 output_1;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint4 vBlendIndices : TEXCOORD1;
	    uint nInstanceIdx : TEXCOORD2;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float2 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _13771 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    }
	    _1360 _25207;
	    [unroll]
	    for (int _2ident = 0; _2ident < 3; _2ident++)
	    {
	        _25207._m0[_2ident] = asfloat(g_transformBuffer.Load4(_2ident * 16 + _21785 * 48 + 0));
	    }
	    float3 _22743;
	    if (_13771 > 0u)
	    {
	        _1360 _25208;
	        [unroll]
	        for (int _3ident = 0; _3ident < 3; _3ident++)
	        {
	            _25208._m0[_3ident] = asfloat(g_transformBuffer.Load4(_3ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	        }
	        _22743 = _25208._m0[0].z.xxx;
	    }
	    else
	    {
	        _22743 = 1.0f.xxx;
	    }
	    float3 _12151 = mul(float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]), float4(vPositionOs.xyz * _22743.xyz, 1.0f));
	    float4 _23913 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    output_0 = _12151;
	    output_1 = float2(_23913.zw);
	    _23913.y = -_23913.y;
	    gl_Position = _23913;
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
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	
	RenderState(StencilRef, 1);
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4 g_vPlayerDataVisibility < Attribute("g_vPlayerDataVisibility"); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (824 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float4 _Globals_1_g_vPlayerDataVisibility : packoffset(c0);
	};
	
	
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
	    output_0 = float4(_Globals_1_g_vPlayerDataVisibility.w, abs(_Globals_1_g_vPlayerDataVisibility.x - input_0.z) * 0.015625f, 1.0f - (_Globals_1_g_vPlayerDataVisibility.y * 0.00124999997206032276153564453125f), 1.0f - _Globals_1_g_vPlayerDataVisibility.z);
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
