//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader used by the SFM's volumetric lights";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Forward();
	DotaForward();
	VrForward();
	ToolsVis();
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

VS
{
	StaticCombo( S_TOOLS_ENABLED, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1592 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b0, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	    float3 PerViewConstantBuffer_t_1_m2 : packoffset(c26);
	    float3 PerViewConstantBuffer_t_1_m3 : packoffset(c28);
	};
	
	
	static float4 gl_Position;
	static float3 input_0;
	static float input_1;
	static float input_2;
	static float input_3;
	static float4 output_0;
	static float output_1;
	static float output_2;
	static float output_3;
	
	struct VS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float input_1 : TEXCOORD1;
	    float input_2 : TEXCOORD2;
	    float input_3 : TEXCOORD3;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float output_1 : TEXCOORD1;
	    float output_2 : TEXCOORD2;
	    float output_3 : TEXCOORD3;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _17895 = mul(PerViewConstantBuffer_t_1_m0, (float4(input_0.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    _17895.y = -_17895.y;
	    gl_Position = _17895;
	    output_0 = float4(input_0, dot(PerViewConstantBuffer_t_1_m3, input_0.xyz - PerViewConstantBuffer_t_1_m2.xyz));
	    output_1 = input_1;
	    output_2 = input_2;
	    output_3 = input_3;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_TOOLS_ENABLED, 0..1 );
	DynamicCombo( D_SFM_SCENE_DEPTH_MSAA, 0..1 );
	DynamicCombo( D_LINEAR_DEPTH_BUFFER, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer SFMLightsConstantBuffer_t < Attribute("SFMLightsConstantBuffer_t"); >;
	Texture2DArray g_tSFMCookieTextureArray < Attribute("SFMLightCookieTexture"); SrgbRead(false); >;
	Texture2DArray g_tSFMShadowDepthTexture < Attribute("SFMShadowDepthTexture"); SrgbRead(false); >;
	Texture2D g_tSceneDepth < Attribute("SFMSceneDepth"); SrgbRead(false); >;
	Texture2D g_tSceneDepthMS < Attribute("SFMSceneDepth"); SrgbRead(false); >;
	
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (280 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 output_0;
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    output_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
	}
	
	PS_OUTPUT MainPs()
	{
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(translucent, true);
	
}
