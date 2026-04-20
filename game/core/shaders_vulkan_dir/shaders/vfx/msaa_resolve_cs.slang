//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "MSAA Resolve";
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
	DynamicCombo( D_MSAA_SAMPLES, 0..2 );
	DynamicCombo( D_4X_DOWNSAMPLE, 0..1 );
	
	RWTexture2D<float4> OutputTexture < Attribute("OutputTexture"); >;
	RWTexture2D<float4> QuarterResOutputTexture < Attribute("QuarterResOutputTexture"); >;
	Texture2D g_tSourceMsaa < Attribute("InputTexture"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1668 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	RWTexture2D<float4> _3407 : register(u158, space0);
	Texture2DMS<float4> g_tSourceMsaa_unexpectedTypeId438_1075 : register(t30, space0);
	
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	void MainCs_inner()
	{
	    float3 _13155;
	    _13155 = 0.0f.xxx;
	    uint _9913;
	    float3 _10794;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < 2u))
	        {
	            break;
	        }
	        float4 _3401 = g_tSourceMsaa_unexpectedTypeId438_1075.Load(int2(gl_GlobalInvocationID.xy), int(_16208));
	        _10794 = _13155.xyz + (_3401.xyz * (0.5f / (max(_3401.x, max(_3401.y, _3401.z)) + 1.0f))).xyz;
	        _9913 = _16208 + 1u;
	        _13155 = _10794;
	        _16208 = _9913;
	        continue;
	    }
	    _3407[gl_GlobalInvocationID.xy] = float4((_13155.xyz * (1.0f / (1.0f - max(_13155.x, max(_13155.y, _13155.z))))).xyz, 1.0f);
	}
	
	[numthreads(8, 8, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
