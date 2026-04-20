//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Expensive shader to visualize a depth texture";
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
	Feature( F_DEPTH_REMAP, 0..1, "Remap range of depth visualization" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vColor      : COLOR0     < Semantic( Color ); >;                                        // D_IMGUI=1
	float4 vPositionPs : POSITION0  < Semantic( position ); >;                                    
	float4 vTexCoord   : TEXCOORD0  < Semantic( texcoord ); >;                                    
};

VS
{
	StaticCombo( S_REVERSE_DEPTH_BUFFER, 0..1 );
	DynamicCombo( D_IMGUI, 0..1 );
	
	float4 g_OrthoParams < Attribute("ImGuiOrthoParams"); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (628 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float2 vPositionPs;
	static float2 vTexCoord;
	static float2 output_0;
	static float4 output_1;
	
	struct VS_INPUT
	{
	    float2 vTexCoord : TEXCOORD0;
	    float2 vPositionPs : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float2 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _18022 = float4(vTexCoord.xy, 0.0f, 1.0f);
	    output_0 = vPositionPs;
	    output_1 = 1.0f.xxxx;
	    _18022.y = -vTexCoord.y;
	    gl_Position = _18022;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionPs = stage_input.vPositionPs;
	    vTexCoord = stage_input.vTexCoord;
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
	StaticCombo( S_REVERSE_DEPTH_BUFFER, 0..1 );
	StaticCombo( S_DEPTH_REMAP, F_DEPTH_REMAP );
	DynamicCombo( D_IMGUI, 0..1 );
	DynamicCombo( D_VR_DEPTH_TEXTURE, 0..2 );
	
	Texture2D g_tDepthTexture < Attribute("InputTexture"); SrgbRead(false); >;
	
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1348 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	Texture2D<float4> g_tDepthTexture : register(t30, space1);
	SamplerComparisonState AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear : register(s15, space1);
	
	static float4 input_0;
	static float4 output_0;
	static float2 input_1;
	
	struct PS_INPUT
	{
	    float2 input_1 : TEXCOORD0;
	    float4 input_0 : TEXCOORD1;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _13155;
	    _13155 = float4(0.0f, 0.0f, 0.0f, 1.0f);
	    int _11515;
	    float4 _13138;
	    int _16208 = 0;
	    for (;;)
	    {
	        if (!(_16208 < 64))
	        {
	            break;
	        }
	        float3 _20312 = _13155.xyz + (0.015625f * g_tDepthTexture.SampleCmpLevelZero(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, input_1.xy, float(_16208) * 0.015625f)).xxx;
	        float4 _20488 = _13155;
	        _20488.x = _20312.x;
	        _20488.y = _20312.y;
	        _13138 = _20488;
	        _13138.z = _20312.z;
	        _11515 = _16208 + 1;
	        _13155 = _13138;
	        _16208 = _11515;
	        continue;
	    }
	    output_0 = _13155 * input_0;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
