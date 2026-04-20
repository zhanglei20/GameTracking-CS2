//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Single pass WaveOp Downsample/resolve depth buffer";
	DevShader = false;
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
	DynamicCombo( D_REVERSE_DEPTH, 0..1 );
	DynamicCombo( D_MIP_COUNT, 0..12 );
	
	RWBuffer<float4> g_hWorkgroupCounterBuffer < Attribute("WorkgroupCounterBuffer"); >;
	int g_nGroupCount < Attribute("GroupCount"); UiType(Slider); >;
	int g_nSrcHeight < Attribute("SrcHeight"); UiType(Slider); >;
	int g_nSrcWidth < Attribute("SrcWidth"); UiType(Slider); >;
	RWTexture2D<float4> g_tOutDepthMip1 < Attribute("DepthMip1"); >;
	RWTexture2D<float4> g_tOutDepthMip10 < Attribute("DepthMip10"); >;
	RWTexture2D<float4> g_tOutDepthMip11 < Attribute("DepthMip11"); >;
	RWTexture2D<float4> g_tOutDepthMip2 < Attribute("DepthMip2"); >;
	RWTexture2D<float4> g_tOutDepthMip3 < Attribute("DepthMip3"); >;
	RWTexture2D<float4> g_tOutDepthMip4 < Attribute("DepthMip4"); >;
	RWTexture2D<float4> g_tOutDepthMip5 < Attribute("DepthMip5"); >;
	RWTexture2D<float4> g_tOutDepthMip6 < Attribute("DepthMip6"); >;
	RWTexture2D<float4> g_tOutDepthMip7 < Attribute("DepthMip7"); >;
	RWTexture2D<float4> g_tOutDepthMip8 < Attribute("DepthMip8"); >;
	RWTexture2D<float4> g_tOutDepthMip9 < Attribute("DepthMip9"); >;
	Texture2D g_tSrcDepth < Attribute("DepthBuffer"); SrgbRead(false); >;
	float2 g_vInvSrcSize < Attribute("InvSrcSize"); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3132 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float2 _Globals_1_g_vInvSrcSize : packoffset(c0);
	};
	
	Texture2D<float4> g_tSrcDepth : register(t30, space0);
	SamplerState AddressU_Clamp_AddressV_Clamp_AllowGlobalMipBiasOverride_0_Filter_MinMagMipPoint : register(s14, space0);
	RWTexture2D<float4> _3043 : register(u158, space0);
	
	static uint3 gl_WorkGroupID;
	static uint3 gl_LocalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_WorkGroupID : SV_GroupID;
	    uint3 gl_LocalInvocationID : SV_GroupThreadID;
	};
	
	void MainCs_inner()
	{
	    int2 _5754 = (int2(uint2((((gl_LocalInvocationID.x) & 1u) | (((gl_LocalInvocationID.x >> uint(3)) & 3u) << uint(1))) | (((gl_LocalInvocationID.x >> uint(7)) & 1u) << uint(3)), ((gl_LocalInvocationID.x >> uint(1)) & 3u) | (((gl_LocalInvocationID.x >> uint(5)) & 3u) << uint(2)))) * int2(4, 4)) + int2(gl_WorkGroupID.xy * uint2(64u, 64u));
	    float2 _11517 = float2(_5754) * _Globals_1_g_vInvSrcSize;
	    float4 _24999 = g_tSrcDepth.GatherRed(AddressU_Clamp_AddressV_Clamp_AllowGlobalMipBiasOverride_0_Filter_MinMagMipPoint, _11517, int2(1, 1));
	    float4 _25000 = g_tSrcDepth.GatherRed(AddressU_Clamp_AddressV_Clamp_AllowGlobalMipBiasOverride_0_Filter_MinMagMipPoint, _11517, int2(3, 1));
	    float4 _25001 = g_tSrcDepth.GatherRed(AddressU_Clamp_AddressV_Clamp_AllowGlobalMipBiasOverride_0_Filter_MinMagMipPoint, _11517, int2(1, 3));
	    float4 _21268 = g_tSrcDepth.GatherRed(AddressU_Clamp_AddressV_Clamp_AllowGlobalMipBiasOverride_0_Filter_MinMagMipPoint, _11517, int2(3, 3));
	    int2 _5189 = _5754 >> int2(1, 1);
	    _3043[uint2(_5189)] = max(max(_24999.w, _24999.z), max(_24999.x, _24999.y)).xxxx;
	    _3043[uint2(_5189 + int2(1, 0))] = max(max(_25000.w, _25000.z), max(_25000.x, _25000.y)).xxxx;
	    _3043[uint2(_5189 + int2(0, 1))] = max(max(_25001.w, _25001.z), max(_25001.x, _25001.y)).xxxx;
	    _3043[uint2(_5189 + int2(1, 1))] = max(max(_21268.w, _21268.z), max(_21268.x, _21268.y)).xxxx;
	}
	
	[numthreads(256, 1, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_WorkGroupID = stage_input.gl_WorkGroupID;
	    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
