//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Smoke Volume";
	DevShader = true;
	Version = 2;
	
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
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_OPTIM, 0..1 );
	DynamicCombo( D_SMOKE_INSTANCES, 1..6 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicCombo( D_SMOKE_QUALITY, 0..1 );
	DynamicCombo( D_SMOKE_USE_NOISE_TEXTURE, 0..1 );
	DynamicCombo( D_SMOKE_NEW_VISUALS, 0..1 );
	DynamicCombo( D_SMOKE_PERF_TEST, 0..1 );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_OPTIM, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_QUALITY, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_USE_NOISE_TEXTURE, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_NEW_VISUALS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_PERF_TEST, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	cbuffer SmokeConstantBuffer_t < Attribute("SmokeConstantBuffer_t"); >;
	int g_MixedResolutionScale < Attribute("MIXED_RESOLUTION_SCALE"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	RWTexture2D<float4> g_tColorOutput < Attribute("ColorOutput"); >;
	Texture2D g_tDepthNoCharacters < Attribute("DepthNoCharacters"); SrgbRead(false); >;
	Texture2D g_tDepthTexture < Attribute("SceneDepth"); SrgbRead(false); >;
	RWTexture2D<float4> g_tExtraMomentsOutput < Attribute("ExtraMomentsOutput"); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	Texture2D g_tMaskTexture < Attribute("SmokeMask"); SrgbRead(true); >;
	RWTexture2D<float4> g_tMboitOptimColorTexture < Attribute("SmokeOptimColorTex"); >;
	Texture2D g_tMboitOptimColorTexture < Attribute("SmokeOptimColorTex"); SrgbRead(true); >;
	RWTexture2D<float4> g_tMboitOptimDepthTexture < Attribute("SmokeOptimDepthTex"); >;
	Texture2D g_tMboitOptimDepthTexture < Attribute("SmokeOptimDepthTex"); SrgbRead(true); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	RWTexture2D<float4> g_tMomentsOutput < Attribute("MomentsOutput"); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture3D g_tSmokeNoiseTex < Channel(AGGB, None(TextureNoise), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture3D g_tSmokeVolumeLPV_Atlas < Attribute("SmokeVolumeLPV_Atlas"); SrgbRead(false); >;
	Texture3D g_tSmokeVolumeTexA_Atlas < Attribute("SmokeVolumeTexA_Atlas"); SrgbRead(false); >;
	RWTexture2D<float4> g_tZerothOutput < Attribute("ZerothOutput"); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	
	// Noise
	CreateInputTexture2D(TextureNoise, Srgb, 8, "", "_z0000", "Noise", Default4(1, 1, 1, 1));
	
	// Settings
	bool g_bExtraSample < Default(1); UiType(CheckBox); UiGroup("Settings"); >;
	float g_flAOEffectDistance < Default(20); Range(0, 100); UiType(Slider); UiGroup("Settings"); >;
	float g_flAOEffectStrength < Default(0.07); Range(0, 0.2); UiType(Slider); UiGroup("Settings"); >;
	float g_flAmbientStrength < Default(1); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flBoilStrength < Default(1); Range(-1, 1); UiType(Slider); UiGroup("Settings"); >;
	float g_flCSMDepthBiasX10 < Default(-0.04); Range(-0.1, 0.1); UiType(Slider); UiGroup("Settings"); >;
	float g_flDensity < Default(1); Range(0, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flDirectStrength < Default(1); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flInteriorDarkening < Default(1); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseMax < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseMin < Range(-8, 8); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseNormalStrength < Default(0.5); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseNormalStrengthDirect < Default(1); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseOffset < Default(0.1); Range(-4, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoisePower < Default(1); Range(0.01, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseScaleHigh < Default(8); Range(0, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseScaleLow < Default(2.3); Range(0, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseSpeed < Default(1); Range(0, 10); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseStrengthHigh < Default(0.25); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseStrengthLow < Default(0.5); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flRayStepLength < Default(4); Range(0.1, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flRimLightStrength < Default(0.25); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flSmokeNoiseStrength < Default(1); Range(0, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flVolumeNormalBlend < Default(0.35); UiType(Slider); UiGroup("Settings"); >;
	float g_flWispy < UiType(Slider); UiGroup("Settings"); >;
	int g_nShadowInterpolateRaySteps < Default(4); Range(1, 12); UiType(Slider); UiGroup("Settings"); >;
	int g_nShadowQuality < Range4(0, 0, 0, 0, 4, 4, 4, 4); UiOptions("0=1,1=8,2=12,3=25,4=Interpolate Ray"); UiType(Enum); UiGroup("Settings"); >;
	float3 g_vSmokeColor < Default3(1, 1, 1); UiType(Color); UiGroup("Settings"); Expression(SrgbGammaToLinear(this)); >;
	
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (164 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	void MainCs_inner()
	{
	}
	
	[numthreads(8, 8, 1)]
	void MainCs()
	{
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
