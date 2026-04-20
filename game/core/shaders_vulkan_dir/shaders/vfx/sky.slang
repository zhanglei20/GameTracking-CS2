//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Used to draw the skybox";
	DevShader = false;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
	// Programs: ps, vs
}

MODES
{
	Default();
	Forward();
	VrForward();
}

FEATURES
{
	Feature( F_LIGHTING_ONLY, 0..1, "Rendering" );
	Feature( F_TEXTURE_FORMAT, 0..5 (0="HDR (float16)", 1="RGB (8-bit uncompressed)", 2="YCoCg (dxt compressed)", 3="Dxt1 (LDR)", 4="RGBM (dxt compressed)", 5="RGBM (8-bit uncompressed)"), "Format" );
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
	float4x4 g_matSkyWsToOs < Attribute("SkyWsToOs"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 4459 (name: PerViewConstantBuffer_t), member index 1 (name: _m1) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2812 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	struct anon_g_matSkyWsToOs
	{
	    vec4 _m0[4];
	};
	
	struct _1915
	{
	    anon_g_matSkyWsToOs g_matSkyWsToOs;
	};
	
	layout(set = 0) uniform _1915 _Globals_;
	
	struct _2151
	{
	    anon_g_matSkyWsToOs _m0;
	    float _m1;
	    float _m2;
	    vec4 _m3;
	    vec3 _m4;
	};
	
	layout(set = 0) uniform _2151 PerViewConstantBuffer_t;
	
	layout(location = 0) in vec4 vPositionOs;
	layout(location = 0) out vec3 output_0;
	
	void main()
	{
	    vec4 _23552 = (vec4((PerViewConstantBuffer_t._m4.xyz + (vPositionOs.xyz * (PerViewConstantBuffer_t._m1 + PerViewConstantBuffer_t._m2))).xyz, 1.0) + (PerViewConstantBuffer_t._m3 * 1.0)).xyzw * mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	    output_0 = normalize((mat4(vec4(_Globals_.g_matSkyWsToOs._m0[0].x, _Globals_.g_matSkyWsToOs._m0[1].x, _Globals_.g_matSkyWsToOs._m0[2].x, _Globals_.g_matSkyWsToOs._m0[3].x), vec4(_Globals_.g_matSkyWsToOs._m0[0].y, _Globals_.g_matSkyWsToOs._m0[1].y, _Globals_.g_matSkyWsToOs._m0[2].y, _Globals_.g_matSkyWsToOs._m0[3].y), vec4(_Globals_.g_matSkyWsToOs._m0[0].z, _Globals_.g_matSkyWsToOs._m0[1].z, _Globals_.g_matSkyWsToOs._m0[2].z, _Globals_.g_matSkyWsToOs._m0[3].z), vec4(_Globals_.g_matSkyWsToOs._m0[0].w, _Globals_.g_matSkyWsToOs._m0[1].w, _Globals_.g_matSkyWsToOs._m0[2].w, _Globals_.g_matSkyWsToOs._m0[3].w)) * vec4(vPositionOs.xyz, 0.0)).xyz);
	    _23552.y = -_23552.y;
	    gl_Position = _23552;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_TEXTURE_FORMAT, F_TEXTURE_FORMAT );
	DynamicCombo( D_RENDER_TO_CUBE_MAP, 0..1 );
	DynamicCombo( D_FOG_TYPE, 0..2 );
	DynamicCombo( D_MIN_ANGULAR_FOG, 0..1 );
	DynamicComboRule( Requires( D_MIN_ANGULAR_FOG, D_FOG_TYPE=2 ) );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	float g_flFogMaxDotEnd < Attribute("FogMaxEnd"); UiType(Slider); >;
	float g_flFogMaxDotStart < Attribute("FogMaxStart"); UiType(Slider); >;
	float g_flFogMinDotEnd < Attribute("FogMinEnd"); UiType(Slider); >;
	float g_flFogMinDotStart < Attribute("FogMinStart"); UiType(Slider); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Linear); OutputFormat(RGBA16161616F); SrgbRead(false); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, Box(SkyTexture), Srgb); OutputFormat(DXT5); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(DXT5); SrgbRead(true); >;
	float3 g_vTint < Default3(1, 1, 1); Attribute("SkyTint"); UiType(VectorText); >;
	
	// Texture
	CreateInputTexture2D(SkyTexture, Linear, 8, "ConvertToYCoCg", "", "Texture", Default4(0, 0, 0, 1));
	CreateInputTexture2D(SkyTexture, Srgb, 8, "", "", "Texture", Default4(1, 1, 1, 0));
	float g_flBrightnessExposureBias < Range(-5, 5); UiType(Slider); UiGroup("Texture"); Expression(pow(2,this)); >;
	float g_flRenderOnlyExposureBias < Range(-5, 5); UiType(Slider); UiGroup("Texture"); Expression(pow(2,this)); >;
	
	#if (S_TEXTURE_FORMAT == 0)
		TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Linear); OutputFormat(RGBA16161616F); SrgbRead(false); >;
	#endif
	#if (S_TEXTURE_FORMAT == 1)
		TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	#endif
	#if (S_TEXTURE_FORMAT == 2)
		TextureCube g_tSkyTexture < Channel(RGBA, Box(SkyTexture), Srgb); OutputFormat(DXT5); SrgbRead(true); >;
	#endif
	#if (S_TEXTURE_FORMAT == 3)
		TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	#endif
	#if (S_TEXTURE_FORMAT == 4)
		TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(DXT5); SrgbRead(true); >;
	#endif
	#if (S_TEXTURE_FORMAT == 5)
		TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 2 (name: g_vTint) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2340 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	vec4 _2;
	
	struct _1064
	{
	    float g_flBrightnessExposureBias;
	    float g_flRenderOnlyExposureBias;
	    vec3 g_vTint;
	};
	
	layout(set = 1) uniform _1064 _Globals_;
	
	struct _985
	{
	    float _m0;
	};
	
	layout(set = 1) uniform _985 PerViewConstantBuffer_t;
	
	layout(set = 1, binding = 30) uniform textureCube g_tSkyTexture;
	layout(set = 1, binding = 14) uniform sampler DefaultSamplerState_0;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _3401 = texture(samplerCube(g_tSkyTexture, DefaultSamplerState_0), normalize(input_0.xyz).xyz);
	    vec4 _18900;
	    _18900.x = _3401.x;
	    _18900.y = _3401.y;
	    _18900.z = _3401.z;
	    vec3 _11003 = _18900.xyz * _Globals_.g_flBrightnessExposureBias;
	    vec4 _8673;
	    _8673.x = _11003.x;
	    _8673.y = _11003.y;
	    _8673.z = _11003.z;
	    vec3 _11004 = _8673.xyz * _Globals_.g_flRenderOnlyExposureBias;
	    vec4 _8674;
	    _8674.x = _11004.x;
	    _8674.y = _11004.y;
	    _8674.z = _11004.z;
	    vec3 _15697 = max(_8674.xyz * _Globals_.g_vTint.xyz, vec3(0.0));
	    vec4 _9186;
	    _9186.x = _15697.x;
	    _9186.y = _15697.y;
	    _9186.z = _15697.z;
	    vec3 _11005 = _9186.xyz * PerViewConstantBuffer_t._m0;
	    float _15073 = _11005.x;
	    vec4 _8675;
	    _8675.x = _15073;
	    _8675.y = _11005.y;
	    _8675.z = _11005.z;
	    output_0 = vec4(_15073, _11005.yz, dot(_8675.xyz, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(sky, true);
	TextureAttribute(SkyTexture, g_tSkyTexture);
	FloatAttribute(SkyBrightnessExposureBias, g_flBrightnessExposureBias);
	
	#if (S_TEXTURE_FORMAT == 0)
		IntAttribute(SkyTextureFormat, 0);
	#endif
	#if (S_TEXTURE_FORMAT == 1)
		IntAttribute(SkyTextureFormat, 1);
	#endif
	#if (S_TEXTURE_FORMAT == 2)
		IntAttribute(SkyTextureFormat, 2);
	#endif
	#if (S_TEXTURE_FORMAT == 3)
		IntAttribute(SkyTextureFormat, 3);
	#endif
	#if (S_TEXTURE_FORMAT == 4)
		IntAttribute(SkyTextureFormat, 4);
	#endif
	#if (S_TEXTURE_FORMAT == 5)
		IntAttribute(SkyTextureFormat, 5);
	#endif
}
