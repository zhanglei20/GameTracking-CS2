//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Player Visibility Stencil Proxy (box version of player model)";
	DevShader = true;
	Version = 1;
	
	// VcsVersion: 70
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
	float3 vPositionOs : POSITION0  < Semantic( PosXyz ); >;                                      
};

VS
{
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer StencilProxyConstantBuffer_t < Attribute("StencilProxyConstantBuffer_t"); >;
	float g_flProxyScale < Default(1); Attribute("g_flProxyScale"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3044 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _352
	{
	    float4 _m0[3];
	};
	
	struct _1281
	{
	    _352 _m0[32];
	};
	
	struct _2284
	{
	    float4 _m0[4];
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float _Globals_1_g_flProxyScale : packoffset(c0);
	};
	
	cbuffer StencilProxyConstantBuffer_t : register(b4, space0)
	{
	    _1281 StencilProxyConstantBuffer_t_1_m0 : packoffset(c0);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _2284 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	    float3 PerViewConstantBuffer_t_1_m2 : packoffset(c26);
	};
	
	
	static float4 gl_Position;
	static int gl_InstanceIndex;
	static int gl_BaseInstanceARB;
	cbuffer SPIRV_Cross_VertexInfo
	{
	    int SPIRV_Cross_BaseVertex;
	    int SPIRV_Cross_BaseInstance;
	};
	
	static float3 vPositionOs;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint gl_InstanceIndex : SV_InstanceID;
	};
	
	struct PS_INPUT
	{
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float3 _13397 = mul(float4(vPositionOs.xyz * _Globals_1_g_flProxyScale, 1.0f), float4x3(float3(StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[0].x, StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[1].x, StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[2].x), float3(StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[0].y, StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[1].y, StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[2].y), float3(StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[0].z, StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[1].z, StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[2].z), float3(StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[0].w, StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[1].w, StencilProxyConstantBuffer_t_1_m0._m0[uint(gl_InstanceIndex - gl_BaseInstanceARB)]._m0[2].w))).xyz;
	    float4 _24787 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), (float4((_13397 + (normalize(PerViewConstantBuffer_t_1_m2.xyz - _13397) * 8.0f)).xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    _24787.y = -_24787.y;
	    gl_Position = _24787;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    gl_InstanceIndex = int(stage_input.gl_InstanceIndex);
	    gl_BaseInstanceARB = SPIRV_Cross_BaseInstance;
	    vPositionOs = stage_input.vPositionOs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	
	RenderState(StencilRef, 1);
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (280 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 output_0;
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    output_0 = float4(1.0f, 0.0f, 0.0f, 1.0f);
	}
	
	PS_OUTPUT MainPs()
	{
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
