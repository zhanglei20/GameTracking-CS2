//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Composite morph texture";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
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
	float4 vPositionWeights      : POSITION0  < Semantic( None ); >;                              
	float4 vTexCoords            : TEXCOORD0  < Semantic( None ); >;                              
	float4 vOffsetsPositionSpeed : TEXCOORD1  < Semantic( None ); >;                              
	float4 vRangesPositionSpeed  : TEXCOORD2  < Semantic( None ); >;                              
	float4 vOffsetsNormalWrinkle : TEXCOORD3  < Semantic( None ); >;                              
	float4 vRangesNormalWrinkle  : TEXCOORD4  < Semantic( None ); >;                              
};

VS
{
	DynamicCombo( D_COMPOSITETYPE, 0..1 );
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (900 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float4 vPositionWeights;
	static float4 vTexCoords;
	static float4 vOffsetsPositionSpeed;
	static float4 vRangesPositionSpeed;
	static float4 output_0;
	static float4 output_1;
	static float2 output_2;
	static float2 output_3;
	
	struct VS_INPUT
	{
	    float4 vPositionWeights : TEXCOORD0;
	    float4 vRangesPositionSpeed : TEXCOORD1;
	    float4 vTexCoords : TEXCOORD2;
	    float4 vOffsetsPositionSpeed : TEXCOORD3;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float2 output_2 : TEXCOORD2;
	    float2 output_3 : TEXCOORD3;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _11357 = float4(vPositionWeights.xy, 1.0f, 1.0f);
	    output_0 = vTexCoords;
	    output_1 = vOffsetsPositionSpeed;
	    output_2 = float2(vPositionWeights.zw);
	    output_3 = float2(vRangesPositionSpeed.xy);
	    _11357.y = -vPositionWeights.y;
	    gl_Position = _11357;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionWeights = stage_input.vPositionWeights;
	    vTexCoords = stage_input.vTexCoords;
	    vOffsetsPositionSpeed = stage_input.vOffsetsPositionSpeed;
	    vRangesPositionSpeed = stage_input.vRangesPositionSpeed;
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
	DynamicCombo( D_COMPOSITETYPE, 0..1 );
	
	Texture2D g_tSourceMorphAtlas < Attribute("SourceMorphAtlas"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1260 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	Texture2D<float4> g_tSourceMorphAtlas : register(t30, space1);
	SamplerState Filter_MinMagMipPoint : register(s14, space1);
	
	static float2 input_0;
	static float4 input_1;
	static float4 input_2;
	static float2 input_3;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_2 : TEXCOORD0;
	    float4 input_1 : TEXCOORD1;
	    float2 input_3 : TEXCOORD2;
	    float2 input_0 : TEXCOORD3;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _8623 = (g_tSourceMorphAtlas.Sample(Filter_MinMagMipPoint, input_0.xy).xyzw * input_1.xyzw) + input_2.xyzw;
	    float _11354 = _8623.w;
	    output_0 = float4(_8623.xyz * (((1.0f - _11354) * input_3.x) + (_11354 * input_3.y)), 0.0f);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
