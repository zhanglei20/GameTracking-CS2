//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Used to draw the skybox";
	DevShader = false;
	Version = 5;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
	Forward();
	CsgoForward();
	ToolsVis();
	ToolsShadingComplexity(S_MODE_TOOLS_SHADING_COMPLEXITY);
}

FEATURES
{
	Feature( F_LIGHTING_ONLY, 0..1, "Rendering" );
	Feature( F_TEXTURE_FORMAT2, 0..6 (0="BC6H (HDR compressed - recommended)", 1="Dxt1 (LDR)", 2="HDR (float16)", 3="RGB (8-bit uncompressed)", 4="YCoCg (dxt compressed)", 5="RGBM (dxt compressed)", 6="RGBM (8-bit uncompressed)"), "Format" );
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
	StaticCombo( S_LIGHTING_ONLY, F_LIGHTING_ONLY );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4x4 g_matSkyWsToOs < Attribute("SkyWsToOs"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 4459 (name: PerViewConstantBuffer_t), member index 1 (name: _m1) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2860 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	struct anon_g_matSkyWsToOs
	{
	    vec4 _m0[4];
	};
	
	struct _2167
	{
	    anon_g_matSkyWsToOs g_matSkyWsToOs;
	};
	
	layout(set = 0) uniform _2167 _Globals_;
	
	struct _2403
	{
	    anon_g_matSkyWsToOs _m0;
	    float _m1;
	    float _m2;
	    vec4 _m3;
	    vec3 _m4;
	};
	
	layout(set = 0) uniform _2403 PerViewConstantBuffer_t;
	
	layout(location = 0) in vec4 vPositionOs;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	
	void main()
	{
	    vec3 _5578 = PerViewConstantBuffer_t._m4.xyz + (vPositionOs.xyz * (PerViewConstantBuffer_t._m1 + PerViewConstantBuffer_t._m2));
	    vec4 _23552 = (vec4(_5578.xyz, 1.0) + (PerViewConstantBuffer_t._m3 * 1.0)).xyzw * mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	    output_0 = normalize((mat4(vec4(_Globals_.g_matSkyWsToOs._m0[0].x, _Globals_.g_matSkyWsToOs._m0[1].x, _Globals_.g_matSkyWsToOs._m0[2].x, _Globals_.g_matSkyWsToOs._m0[3].x), vec4(_Globals_.g_matSkyWsToOs._m0[0].y, _Globals_.g_matSkyWsToOs._m0[1].y, _Globals_.g_matSkyWsToOs._m0[2].y, _Globals_.g_matSkyWsToOs._m0[3].y), vec4(_Globals_.g_matSkyWsToOs._m0[0].z, _Globals_.g_matSkyWsToOs._m0[1].z, _Globals_.g_matSkyWsToOs._m0[2].z, _Globals_.g_matSkyWsToOs._m0[3].z), vec4(_Globals_.g_matSkyWsToOs._m0[0].w, _Globals_.g_matSkyWsToOs._m0[1].w, _Globals_.g_matSkyWsToOs._m0[2].w, _Globals_.g_matSkyWsToOs._m0[3].w)) * vec4(vPositionOs.xyz, 0.0)).xyz);
	    output_1 = _5578;
	    _23552.y = -_23552.y;
	    gl_Position = _23552;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_SHADING_COMPLEXITY, 0..1 );
	StaticCombo( S_TEXTURE_FORMAT, F_TEXTURE_FORMAT2 );
	DynamicCombo( D_FOG_TYPE, 0..2 );
	DynamicCombo( D_MIN_ANGULAR_FOG, 0..1 );
	DynamicCombo( D_QUAD_OVERDRAW, 0..1 );
	DynamicComboRule( Requires( D_MIN_ANGULAR_FOG, D_FOG_TYPE=2 ) );
	DynamicComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, D_FOG_TYPE ) );
	DynamicComboRule( Requires( D_QUAD_OVERDRAW, S_MODE_TOOLS_SHADING_COMPLEXITY ) );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	float g_flFogMaxDotEnd < Attribute("FogMaxEnd"); UiType(Slider); >;
	float g_flFogMaxDotStart < Attribute("FogMaxStart"); UiType(Slider); >;
	float g_flFogMinDotEnd < Attribute("FogMinEnd"); UiType(Slider); >;
	float g_flFogMinDotStart < Attribute("FogMinStart"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	RWTexture2D<float4> g_tQuadOverdrawMutexUAV < Attribute("QuadOverdrawMutexUAV"); >;
	RWTexture2D<float4> g_tQuadOverdrawUAV < Attribute("QuadOverdrawUAV"); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Linear); OutputFormat(RGBA16161616F); SrgbRead(false); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Linear); OutputFormat(BC6H); SrgbRead(false); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, Box(SkyTexture), Srgb); OutputFormat(DXT5); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	float4 g_vShadingComplexity < Source(ShadingComplexity); UiType(VectorText); >;
	float3 g_vTint < Default3(1, 1, 1); Attribute("SkyTint"); UiType(VectorText); >;
	
	// Texture
	CreateInputTexture2D(SkyTexture, Linear, 8, "ConvertToYCoCg", "", "Texture", Default4(0, 0, 0, 1));
	CreateInputTexture2D(SkyTexture, Srgb, 8, "", "", "Texture", Default4(1, 1, 1, 0));
	float g_flBrightnessExposureBias < Range(-10, 10); UiType(Slider); UiGroup("Texture"); Expression(pow(2,this)); >;
	float g_flRenderOnlyExposureBias < Range(-10, 10); UiType(Slider); UiGroup("Texture"); Expression(pow(2,this)); >;
	
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1828 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 _2;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flBrightnessExposureBias : packoffset(c4.z);
	    float _Globals_1_g_flRenderOnlyExposureBias : packoffset(c4.w);
	    float3 _Globals_1_g_vTint : packoffset(c5);
	};
	
	TextureCube<float4> g_tSkyTexture : register(t52, space1);
	SamplerState DefaultSamplerState_0 : register(s25, space1);
	
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
	    float4 _3401 = g_tSkyTexture.Sample(DefaultSamplerState_0, normalize(input_0.xyz).xyz);
	    float4 _18900;
	    _18900.x = _3401.x;
	    _18900.y = _3401.y;
	    _18900.z = _3401.z;
	    float3 _11003 = _18900.xyz * _Globals_1_g_flBrightnessExposureBias;
	    float4 _8673;
	    _8673.x = _11003.x;
	    _8673.y = _11003.y;
	    _8673.z = _11003.z;
	    float3 _11004 = _8673.xyz * _Globals_1_g_flRenderOnlyExposureBias;
	    float4 _8674;
	    _8674.x = _11004.x;
	    _8674.y = _11004.y;
	    _8674.z = _11004.z;
	    output_0 = float4(max(_8674.xyz * _Globals_1_g_vTint.xyz, 0.0f.xxx), 1.0f);
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
	
	
	
	BoolAttribute(sky, true);
	TextureAttribute(SkyTexture, g_tSkyTexture);
	FloatAttribute(SkyBrightnessExposureBias, g_flBrightnessExposureBias);
	
	#if (S_TEXTURE_FORMAT == 1)
		IntAttribute(SkyTextureFormat, 1);
	#endif
	#if (S_TEXTURE_FORMAT == 0)
		IntAttribute(SkyTextureFormat, 0);
	#endif
	#if (S_TEXTURE_FORMAT == 3)
		IntAttribute(SkyTextureFormat, 3);
	#endif
	#if (S_TEXTURE_FORMAT == 2)
		IntAttribute(SkyTextureFormat, 2);
	#endif
	#if (S_TEXTURE_FORMAT == 5)
		IntAttribute(SkyTextureFormat, 5);
	#endif
	#if (S_TEXTURE_FORMAT == 4)
		IntAttribute(SkyTextureFormat, 4);
	#endif
	#if (S_TEXTURE_FORMAT == 6)
		IntAttribute(SkyTextureFormat, 6);
	#endif
}
