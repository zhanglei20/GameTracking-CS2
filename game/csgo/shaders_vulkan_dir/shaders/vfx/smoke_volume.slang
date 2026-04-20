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
	float4 vPositionPs : POSITION0  < Semantic( position ); >;                                    
	float4 vTexCoord   : TEXCOORD0  < Semantic( texcoord ); >;                                    
};

VS
{
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1892 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1360
	{
	    float4 _m0[4];
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    _1360 _Globals_1_m0 : packoffset(c4);
	    float3 _Globals_1_m1 : packoffset(c26);
	};
	
	
	static float4 gl_Position;
	static float2 vPositionPs;
	static float2 vTexCoord;
	static float3 output_0;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14817 = float4(vPositionPs, 0.0f, 1.0f);
	    float4 _24010 = mul(float4x4(float4(_Globals_1_m0._m0[0].x, _Globals_1_m0._m0[1].x, _Globals_1_m0._m0[2].x, _Globals_1_m0._m0[3].x), float4(_Globals_1_m0._m0[0].y, _Globals_1_m0._m0[1].y, _Globals_1_m0._m0[2].y, _Globals_1_m0._m0[3].y), float4(_Globals_1_m0._m0[0].z, _Globals_1_m0._m0[1].z, _Globals_1_m0._m0[2].z, _Globals_1_m0._m0[3].z), float4(_Globals_1_m0._m0[0].w, _Globals_1_m0._m0[1].w, _Globals_1_m0._m0[2].w, _Globals_1_m0._m0[3].w)), float4((vTexCoord.x * 2.0f) - 1.0f, ((1.0f - vTexCoord.y) * 2.0f) - 1.0f, 1.0f, 1.0f));
	    _14817.y = -vPositionPs.y;
	    gl_Position = _14817;
	    output_0 = normalize((_24010.xyz / _24010.w.xxx) - _Globals_1_m1);
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionPs = stage_input.vPositionPs;
	    vTexCoord = stage_input.vTexCoord;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
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
	DynamicCombo( D_SMOKE_FULLRES, 0..1 );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_OPTIM, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_QUALITY, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_USE_NOISE_TEXTURE, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_NEW_VISUALS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_PERF_TEST, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_FULLRES, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	cbuffer SmokeConstantBuffer_t < Attribute("SmokeConstantBuffer_t"); >;
	RenderState(StencilRef, 128);
	int g_MixedResolutionScale < Attribute("MIXED_RESOLUTION_SCALE"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture2D g_tDepthNoCharacters < Attribute("DepthNoCharacters"); SrgbRead(false); >;
	Texture2D g_tDepthTexture < Attribute("SceneDepth"); SrgbRead(false); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tMaskTexture < Attribute("SmokeMask"); SrgbRead(false); >;
	Texture2D g_tMboitOptimColorTexture < Attribute("SmokeOptimColorTex"); SrgbRead(true); >;
	Texture2D g_tMboitOptimDepthTexture < Attribute("SmokeOptimDepthTex"); SrgbRead(true); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture3D g_tSmokeNoiseTex < Channel(GG, None(TextureNoise), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture3D g_tSmokeVolumeLPV_Atlas < Attribute("SmokeVolumeLPV_Atlas"); SrgbRead(false); >;
	Texture3D g_tSmokeVolumeTexA_Atlas < Attribute("SmokeVolumeTexA_Atlas"); SrgbRead(false); >;
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
	
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 4023 (name: SmokeConstantBuffer_t), member index 13 (name: _m13) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (22460 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_samplerless_texture_functions : require
	layout(early_fragment_tests) in;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	struct _2410
	{
	    vec4 _m0[16];
	};
	
	struct _2536
	{
	    vec4 _m0[5];
	};
	
	struct _2662
	{
	    vec4 _m0[2];
	};
	
	vec4 _3;
	
	struct _1228
	{
	    vec4 _m0;
	    float _m1;
	    float _m2;
	    vec3 _m3;
	    vec3 _m4;
	};
	
	layout(set = 1) uniform _1228 PerViewConstantBuffer_t;
	
	struct _1867
	{
	    _2410 _m0;
	    _2410 _m1;
	    _2410 _m2;
	    _2410 _m3;
	    _2410 _m4;
	    _2410 _m5;
	    vec4 _m6;
	    vec4 _m7;
	    _2410 _m8;
	    _2410 _m9;
	    _2410 _m10;
	    _2536 _m11;
	    _2662 _m12;
	    uint _m13;
	    float _m14;
	    uint _m15;
	};
	
	layout(set = 1) uniform _1867 SmokeConstantBuffer_t;
	
	struct _983
	{
	    int g_MixedResolutionScale;
	};
	
	layout(set = 1) uniform _983 _Globals_;
	
	struct _1080
	{
	    vec4 _m0;
	    vec4 _m1;
	};
	
	layout(set = 3) uniform _1080 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 1, binding = 56) uniform texture2D g_tDepthTexture;
	layout(set = 1, binding = 58) uniform texture2D g_tDepthNoCharacters;
	layout(set = 1, binding = 57) uniform texture2D g_tMaskTexture;
	layout(set = 1, binding = 53) uniform texture3D g_tSmokeVolumeTexA_Atlas;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 54) uniform texture3D g_tSmokeVolumeLPV_Atlas;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec3 _15861 = normalize(input_0);
	    vec3 _23296 = vec3(1.0) / _15861;
	    vec3 _8251 = _23296 * (SmokeConstantBuffer_t._m6.xyz - PerViewConstantBuffer_t._m3);
	    vec3 _6243 = _23296 * (SmokeConstantBuffer_t._m7.xyz - PerViewConstantBuffer_t._m3);
	    vec3 _7415 = min(_6243, _8251);
	    vec3 _13037 = max(_6243, _8251);
	    vec2 _11253 = max(_7415.xx, _7415.yz);
	    float _12676 = max(_11253.x, _11253.y);
	    vec2 _16933 = min(_13037.xx, _13037.yz);
	    float _14150 = min(_16933.x, _16933.y);
	    if (!(!(_12676 > _14150)))
	    {
	        discard;
	    }
	    float _17986 = ((_12676 < 0.0) ? 0.0 : _12676) + 6.0;
	    ivec2 _11700 = ivec3(ivec2(gl_FragCoord.xy), 0).xy;
	    float _10955 = PerViewConstantBuffer_t._m2 - PerViewConstantBuffer_t._m1;
	    float _15694 = dot(PerViewConstantBuffer_t._m4.xyz, _15861);
	    float _10558 = 1.0 / (((clamp((texelFetch(g_tDepthTexture, _11700, 0).x - PerViewConstantBuffer_t._m1) / _10955, 0.0, 1.0) * PerViewConstantBuffer_t._m0.z) + PerViewConstantBuffer_t._m0.w) * _15694);
	    bool _6681 = SmokeConstantBuffer_t._m15 > 0u;
	    bool _12666;
	    if (_6681)
	    {
	        _12666 = ((1.0 / (((clamp((texelFetch(g_tDepthNoCharacters, ivec3(ivec2(gl_FragCoord.xy * float(_Globals_.g_MixedResolutionScale)), 0).xy, 0).x - PerViewConstantBuffer_t._m1) / _10955, 0.0, 1.0) * PerViewConstantBuffer_t._m0.z) + PerViewConstantBuffer_t._m0.w) * _15694)) - _10558) > 10.0;
	    }
	    else
	    {
	        _12666 = false;
	    }
	    float _4364 = _10558 - 2.0;
	    if (_17986 > _4364)
	    {
	        discard;
	    }
	    vec3 _5607 = PerViewConstantBuffer_t._m3 + (_15861 * _17986);
	    vec3 _4987 = PerViewConstantBuffer_t._m3 + (_15861 * min(_14150, _4364));
	    uint _19697 = uint(texelFetch(g_tMaskTexture, _11700, 0).x);
	    uint _4249;
	    uint _15529;
	    _1017 _5767[1];
	    uint _6386;
	    uint _6864;
	    uint _13136 = 0u;
	    uint _16324 = 0u;
	    uint _17017 = _19697;
	    for (;;)
	    {
	        if (!(_17017 != 0u))
	        {
	            _6864 = _16324;
	            break;
	        }
	        if ((_17017 & 1u) != 0u)
	        {
	            vec3 _8252 = _23296 * (SmokeConstantBuffer_t._m0._m0[_13136].xyz - PerViewConstantBuffer_t._m3);
	            vec3 _6244 = _23296 * (SmokeConstantBuffer_t._m1._m0[_13136].xyz - PerViewConstantBuffer_t._m3);
	            vec3 _7416 = min(_6244, _8252);
	            vec3 _13038 = max(_6244, _8252);
	            vec2 _11254 = max(_7416.xx, _7416.yz);
	            vec2 _16934 = min(_13038.xx, _13038.yz);
	            _5767[_16324]._m0.x = max(_11254.x, _11254.y);
	            _5767[_16324]._m0.y = min(_16934.x, _16934.y);
	            _5767[_16324]._m0.z = float(_13136);
	            _6386 = _16324 + 1u;
	        }
	        else
	        {
	            _6386 = _16324;
	        }
	        if (_6386 >= 1u)
	        {
	            _6864 = _6386;
	            break;
	        }
	        _4249 = _17017 >> uint(1);
	        _15529 = _13136 + 1u;
	        _13136 = _15529;
	        _16324 = _6386;
	        _17017 = _4249;
	        continue;
	    }
	    vec4 _13174;
	    do
	    {
	        _1017 _20544[1] = _5767;
	        vec3 _11835 = _4987 - _5607;
	        int _18242 = int(max(2.0, length(_11835) * 0.25));
	        vec3 _14798 = _11835 / vec3(float(_18242 - 1));
	        float _24637 = length(_14798);
	        vec4 _16305;
	        vec3 _17115;
	        vec3 _17118;
	        _16305 = vec4(0.0);
	        _17115 = vec3(0.0, 0.0, 0.00999999977648258209228515625);
	        _17118 = _5607;
	        float _7831;
	        int _11496;
	        vec3 _12783;
	        float _13150;
	        bool _16054;
	        vec3 _16312;
	        bool _16863;
	        float _17123;
	        uint _17124;
	        vec4 _17152;
	        bool _13137 = false;
	        int _17018 = 0;
	        float _17114 = 0.0;
	        float _17116 = 0.0;
	        uint _17117 = 0u;
	        float _17133 = _17986;
	        for (;;)
	        {
	            if (!(_17018 < _18242))
	            {
	                _13174 = _16305;
	                _16054 = _13137;
	                break;
	            }
	            bool _23149;
	            if (SmokeConstantBuffer_t._m13 != 0u)
	            {
	                bool _12501;
	                if ((_17018 & 15) == 0)
	                {
	                    _12501 = true;
	                }
	                else
	                {
	                    _12501 = _17018 < 16;
	                }
	                _23149 = _12501;
	            }
	            else
	            {
	                _23149 = false;
	            }
	            float _24117 = _23149 ? 0.0 : _17114;
	            float _17855 = _23149 ? 0.0 : _17116;
	            uint _14433 = _23149 ? 0u : _17117;
	            vec4 _13138;
	            vec3 _17119;
	            _13138 = _16305;
	            _17119 = mix(_17115, vec3(0.0, 0.0, 0.00999999977648258209228515625), bvec3(_23149));
	            uint _8897;
	            vec4 _13149;
	            float _14891;
	            float _16311;
	            vec3 _17121;
	            uint _18361;
	            float _16306 = _24117;
	            uint _17019 = 0u;
	            float _17120 = _17855;
	            uint _17134 = _14433;
	            for (;;)
	            {
	                bool _7956_ladder_break = false;
	                do
	                {
	                    if (!(_17019 < _6864))
	                    {
	                        _13150 = _16306;
	                        _16312 = _17119;
	                        _17123 = _17120;
	                        _17124 = _17134;
	                        _17152 = _13138;
	                        _16863 = _13137;
	                        _7956_ladder_break = true;
	                        break;
	                    }
	                    uint _21927 = uint(_20544[_17019]._m0.z);
	                    if (_17133 < _20544[_17019]._m0.x)
	                    {
	                        _13149 = _13138;
	                        _16311 = _16306;
	                        _17121 = _17119;
	                        _14891 = _17120;
	                        _18361 = _17134;
	                        break;
	                    }
	                    if (_17133 > _20544[_17019]._m0.y)
	                    {
	                        _13149 = _13138;
	                        _16311 = _16306;
	                        _17121 = _17119;
	                        _14891 = _17120;
	                        _18361 = _17134;
	                        break;
	                    }
	                    vec3 _10842;
	                    uint _13141;
	                    float _13618;
	                    float _16308;
	                    do
	                    {
	                        bool _12885;
	                        if (SmokeConstantBuffer_t._m13 == 0u)
	                        {
	                            _12885 = true;
	                        }
	                        else
	                        {
	                            _12885 = (_17134 & 3u) != 0u;
	                        }
	                        if (_12885)
	                        {
	                            _13141 = _17134;
	                            _16308 = _16306;
	                            _13618 = _17120;
	                            _10842 = _17119;
	                            break;
	                        }
	                        float _13139;
	                        vec3 _16307;
	                        float _17135;
	                        _13139 = _16306;
	                        _16307 = _17119;
	                        _17135 = _17120;
	                        uint _8087;
	                        vec3 _13140;
	                        float _13189;
	                        float _14382;
	                        uint _17020 = 0u;
	                        for (;;)
	                        {
	                            if (!(_17020 < min(SmokeConstantBuffer_t._m13, 16u)))
	                            {
	                                break;
	                            }
	                            vec3 _21554 = SmokeConstantBuffer_t._m9._m0[_17020].xyz - SmokeConstantBuffer_t._m8._m0[_17020].xyz;
	                            vec3 _14636 = _17118 - SmokeConstantBuffer_t._m8._m0[_17020].xyz;
	                            float _19448 = clamp((length(_14636 - (_21554 * clamp(dot(_14636, _21554) / dot(_21554, _21554), 0.0, 1.0))) * 0.0500000007450580596923828125) * SmokeConstantBuffer_t._m10._m0[_17020].x, 0.0, 1.0);
	                            float _14626 = smoothstep(0.0, 0.00999999977648258209228515625, SmokeConstantBuffer_t._m8._m0[_17020].w) * (1.0 - smoothstep(0.00999999977648258209228515625, 0.20000000298023223876953125, SmokeConstantBuffer_t._m8._m0[_17020].w));
	                            float _6223;
	                            if (_19448 < 1.0)
	                            {
	                                float _18731 = max(_17135, smoothstep(0.0, 1.0, 1.0 - clamp(SmokeConstantBuffer_t._m8._m0[_17020].w + clamp(_19448 + (1.0 - clamp(length(_17118 - SmokeConstantBuffer_t._m9._m0[_17020].xyz) * 0.00999999977648258209228515625, 0.0, 1.0)), 0.0, 1.0), 0.0, 1.0)));
	                                _13140 = mix(_16307, normalize(SmokeConstantBuffer_t._m8._m0[_17020].xyz - SmokeConstantBuffer_t._m9._m0[_17020].xyz), vec3(_18731));
	                                _13189 = _18731;
	                                _6223 = (pow(1.0 - _19448, 64.0) * _14626) * 10.0;
	                            }
	                            else
	                            {
	                                _13140 = _16307;
	                                _13189 = _17135;
	                                _6223 = 0.0;
	                            }
	                            if (SmokeConstantBuffer_t._m9._m0[_17020].w > 0.0)
	                            {
	                                float _10368 = (1.0 - clamp(length(_14636) * 0.00999999977648258209228515625, 0.0, 1.0)) * _14626;
	                                _14382 = max(_13139, max(_10368 * _10368, _6223));
	                            }
	                            else
	                            {
	                                _14382 = _13139;
	                            }
	                            _8087 = _17020 + 1u;
	                            _13139 = _14382;
	                            _16307 = _13140;
	                            _17135 = _13189;
	                            _17020 = _8087;
	                            continue;
	                        }
	                        _13141 = _17134 | 1u;
	                        _16308 = _13139;
	                        _13618 = _17135;
	                        _10842 = _16307;
	                        break;
	                    } while(false);
	                    vec4 _22608;
	                    do
	                    {
	                        vec3 _25170 = _17118 + ((normalize(_10842) * pow(_13618, 3.0)) * 20.0);
	                        vec3 _14658 = clamp((((_25170 - SmokeConstantBuffer_t._m2._m0[int(_21927)].xyz) * vec3(0.0500000007450580596923828125)) + vec3(16.0)) * vec3(0.03125), vec3(0.0), vec3(1.0));
	                        vec3 _21495 = saturate(_14658);
	                        uint _14092 = uint(SmokeConstantBuffer_t._m3._m0[_21927].z);
	                        _21495.x = ((34.0 * float(_14092)) + (_21495.x * 32.0)) * 0.0018450184725224971771240234375;
	                        vec4 _11487 = textureLod(sampler3D(g_tSmokeVolumeTexA_Atlas, g_sTrilinearClamp), _21495.xyz, 0.0);
	                        vec2 _7714 = mix(_11487.xz, _11487.yw, vec2(SmokeConstantBuffer_t._m3._m0[_21927].y));
	                        float _20593 = _7714.x;
	                        float _6734 = _7714.y;
	                        vec4 _13144;
	                        _13144.w = _6734;
	                        float _8283 = distance(_25170, _4987);
	                        vec4 _18056;
	                        if (_20593 > _6734)
	                        {
	                            vec4 _11248;
	                            _11248.w = mix(_6734, _20593, smoothstep(10.0, 40.0, _8283));
	                            _18056 = _11248;
	                        }
	                        else
	                        {
	                            _18056 = _13144.xyzw;
	                        }
	                        float _6665 = clamp(mix(_18056.w, -0.0500000007450580596923828125, _13618), 0.0, 1.0);
	                        if (_6665 > 0.00999999977648258209228515625)
	                        {
	                            vec4 _20413 = textureLod(sampler3D(g_tSmokeVolumeLPV_Atlas, g_sTrilinearClamp), _21495.xyz, 0.0);
	                            float _15720 = clamp(clamp((_6665 - 0.00999999977648258209228515625) * 1.01010096073150634765625, 0.0, 1.0) * max(0.5, clamp((abs(sin((_14658.x * 18.840000152587890625) + (SmokeConstantBuffer_t._m14 * 0.699999988079071044921875))) + abs(cos((_14658.y * 31.40000152587890625) + (SmokeConstantBuffer_t._m14 * 0.5)))) * 0.5, 0.0, 1.0)), 0.0, 1.0) * clamp((SmokeConstantBuffer_t._m5._m0[_21927].x * 2.0) - 0.5, 0.0, 1.0);
	                            float _22281 = clamp(_15720 + ((1.0 - clamp(distance(PerViewConstantBuffer_t._m3, _25170) * 0.100000001490116119384765625, 0.0, 1.0)) * _15720), 0.0, 1.0);
	                            float _13147;
	                            vec3 _13734;
	                            float _15157;
	                            float _16310;
	                            if (_6681)
	                            {
	                                float _13142;
	                                vec3 _16309;
	                                float _17136;
	                                _13142 = SmokeConstantBuffer_t._m14;
	                                _16309 = _25170;
	                                _17136 = 1.0;
	                                uint _8896;
	                                vec3 _13146;
	                                float _14082;
	                                float _18360;
	                                uint _17021 = 0u;
	                                for (;;)
	                                {
	                                    bool _7957_ladder_break = false;
	                                    do
	                                    {
	                                        if (!(_17021 < SmokeConstantBuffer_t._m15))
	                                        {
	                                            _7957_ladder_break = true;
	                                            break;
	                                        }
	                                        if ((uint(SmokeConstantBuffer_t._m12._m0[_17021 >> uint(2)][_17021 & 3u]) & (1u << _14092)) == 0u)
	                                        {
	                                            _13146 = _16309;
	                                            _14082 = _17136;
	                                            _18360 = _13142;
	                                            break;
	                                        }
	                                        float _10810 = SmokeConstantBuffer_t._m14 - SmokeConstantBuffer_t._m11._m0[_17021].w;
	                                        vec3 _13145;
	                                        float _16382;
	                                        float _16480;
	                                        if (_10810 < (SmokeConstantBuffer_t._m3._m0[_21927].x - 0.4000000059604644775390625))
	                                        {
	                                            float _13668 = distance(_16309, SmokeConstantBuffer_t._m11._m0[_17021].xyz);
	                                            vec3 _13143;
	                                            float _16381;
	                                            float _16479;
	                                            if (_13668 < 250.0)
	                                            {
	                                                float _16611 = pow(1.0 - smoothstep(0.0, 2.0, _10810), 128.0);
	                                                float _13560;
	                                                if (!_12666)
	                                                {
	                                                    _13560 = step(_8283, 16.0) * (1.0 - smoothstep(0.0, 7.0, _10810));
	                                                }
	                                                else
	                                                {
	                                                    _13560 = 0.0;
	                                                }
	                                                _13143 = mix(_16309, SmokeConstantBuffer_t._m11._m0[_17021].xyz, vec3(((1.0 - smoothstep(100.0, 250.0, _13668)) * step(_10810 * 1250.0, _13668)) * (1.0 - _16611)));
	                                                _16381 = min(_17136, max(smoothstep(200.0, 240.0, _13668 + (_16611 * 250.0)) + pow(smoothstep(0.5, 5.0, _10810), 1.7999999523162841796875), _13560));
	                                                _16479 = min(_13142, SmokeConstantBuffer_t._m14 - (_10810 * (1.0 - smoothstep(0.0, 5.0, _10810))));
	                                            }
	                                            else
	                                            {
	                                                _13143 = _16309;
	                                                _16381 = _17136;
	                                                _16479 = _13142;
	                                            }
	                                            _13145 = _13143;
	                                            _16382 = _16381;
	                                            _16480 = _16479;
	                                        }
	                                        else
	                                        {
	                                            _13145 = _16309;
	                                            _16382 = _17136;
	                                            _16480 = _13142;
	                                        }
	                                        _13146 = _13145;
	                                        _14082 = _16382;
	                                        _18360 = _16480;
	                                        break;
	                                    } while(false);
	                                    if (_7957_ladder_break)
	                                    {
	                                        break;
	                                    }
	                                    _8896 = _17021 + 1u;
	                                    _13142 = _18360;
	                                    _16309 = _13146;
	                                    _17136 = _14082;
	                                    _17021 = _8896;
	                                    continue;
	                                }
	                                _13147 = _17136;
	                                _16310 = mix(_22281 * 0.0199999995529651641845703125, _22281, _17136);
	                                _15157 = _13142;
	                                _13734 = _16309;
	                            }
	                            else
	                            {
	                                _13147 = 1.0;
	                                _16310 = _22281;
	                                _15157 = SmokeConstantBuffer_t._m14;
	                                _13734 = _25170;
	                            }
	                            vec3 _6444 = _13734 * 0.00999999977648258209228515625;
	                            float _23715 = _6444.z - (_15157 * 0.0500000007450580596923828125);
	                            vec3 _14064 = _6444;
	                            _14064.z = _23715;
	                            vec3 _10565 = _14064 * 2.2999999523162841796875;
	                            vec3 _22220 = floor(_10565);
	                            vec3 _8476 = fract(_10565);
	                            float _13155;
	                            _13155 = 1.0;
	                            float _13374;
	                            float _13156;
	                            float _16208 = -1.0;
	                            for (;;)
	                            {
	                                if (!(_16208 <= 1.0))
	                                {
	                                    break;
	                                }
	                                _13156 = _13155;
	                                float _13375;
	                                float _13157;
	                                float _16209 = -1.0;
	                                for (;;)
	                                {
	                                    if (!(_16209 <= 1.0))
	                                    {
	                                        break;
	                                    }
	                                    _13157 = _13156;
	                                    float _7744;
	                                    float _11312;
	                                    float _16210 = -1.0;
	                                    for (;;)
	                                    {
	                                        if (!(_16210 <= 1.0))
	                                        {
	                                            break;
	                                        }
	                                        vec3 _16399 = vec3(_16208, _16209, _16210);
	                                        vec3 _10495 = _22220 + _16399;
	                                        vec3 _23449 = fract((_10495 - vec3(2.2999999523162841796875) * trunc(_10495 / vec3(2.2999999523162841796875))) * vec3(0.103100001811981201171875, 0.113689996302127838134765625, 0.13786999881267547607421875));
	                                        vec3 _22705 = _23449 + vec3(dot(_23449, _23449.yxz + vec3(19.1900005340576171875)));
	                                        float _18874 = _22705.x;
	                                        float _20358 = _22705.y;
	                                        float _13913 = _22705.z;
	                                        vec3 _22245 = (_16399 + (((vec3(-1.0) + (fract(vec3((_18874 + _20358) * _13913, (_18874 + _13913) * _20358, (_20358 + _13913) * _18874)) * 2.0)) * 0.5) + vec3(0.5))) - _8476;
	                                        float _9450 = dot(_22245, _22245);
	                                        _11312 = (_9450 < _13157) ? _9450 : _13157;
	                                        _7744 = _16210 + 1.0;
	                                        _13157 = _11312;
	                                        _16210 = _7744;
	                                        continue;
	                                    }
	                                    _13375 = _16209 + 1.0;
	                                    _13156 = _13157;
	                                    _16209 = _13375;
	                                    continue;
	                                }
	                                _13374 = _16208 + 1.0;
	                                _13155 = _13156;
	                                _16208 = _13374;
	                                continue;
	                            }
	                            _14064.z = _23715 - (_15157 * 0.02999999932944774627685546875);
	                            vec3 _10566 = _14064 * 6.0;
	                            vec3 _22221 = floor(_10566);
	                            vec3 _8477 = fract(_10566);
	                            float _13158;
	                            _13158 = 1.0;
	                            float _13376;
	                            float _13159;
	                            float _16211 = -1.0;
	                            for (;;)
	                            {
	                                if (!(_16211 <= 1.0))
	                                {
	                                    break;
	                                }
	                                _13159 = _13158;
	                                float _13377;
	                                float _13160;
	                                float _16212 = -1.0;
	                                for (;;)
	                                {
	                                    if (!(_16212 <= 1.0))
	                                    {
	                                        break;
	                                    }
	                                    _13160 = _13159;
	                                    float _7745;
	                                    float _11313;
	                                    float _16213 = -1.0;
	                                    for (;;)
	                                    {
	                                        if (!(_16213 <= 1.0))
	                                        {
	                                            break;
	                                        }
	                                        vec3 _16400 = vec3(_16211, _16212, _16213);
	                                        vec3 _10496 = _22221 + _16400;
	                                        vec3 _23450 = fract((_10496 - vec3(6.0) * trunc(_10496 / vec3(6.0))) * vec3(0.103100001811981201171875, 0.113689996302127838134765625, 0.13786999881267547607421875));
	                                        vec3 _22706 = _23450 + vec3(dot(_23450, _23450.yxz + vec3(19.1900005340576171875)));
	                                        float _18875 = _22706.x;
	                                        float _20359 = _22706.y;
	                                        float _13914 = _22706.z;
	                                        vec3 _22246 = (_16400 + (((vec3(-1.0) + (fract(vec3((_18875 + _20359) * _13914, (_18875 + _13914) * _20359, (_20359 + _13914) * _18875)) * 2.0)) * 0.5) + vec3(0.5))) - _8477;
	                                        float _9451 = dot(_22246, _22246);
	                                        _11313 = (_9451 < _13160) ? _9451 : _13160;
	                                        _7745 = _16213 + 1.0;
	                                        _13160 = _11313;
	                                        _16213 = _7745;
	                                        continue;
	                                    }
	                                    _13377 = _16212 + 1.0;
	                                    _13159 = _13160;
	                                    _16212 = _13377;
	                                    continue;
	                                }
	                                _13376 = _16211 + 1.0;
	                                _13158 = _13159;
	                                _16211 = _13376;
	                                continue;
	                            }
	                            float _8377 = clamp((((1.0 - _13155) * 0.60000002384185791015625) + ((1.0 - _13158) * 0.2800000011920928955078125)) + 0.119999997317790985107421875, 0.0, 1.0);
	                            float _9429;
	                            if (SmokeConstantBuffer_t._m5._m0[_21927].w < 1.0)
	                            {
	                                float _17097 = clamp(SmokeConstantBuffer_t._m5._m0[_21927].w, 9.9999997473787516355514526367188e-05, 0.99989998340606689453125);
	                                float _8419 = smoothstep(0.0, 0.800000011920928955078125, _17097);
	                                float _14551 = smoothstep(0.20000000298023223876953125, 1.0, _17097);
	                                float _12502;
	                                if (_8419 == _14551)
	                                {
	                                    _12502 = _16310 * _17097;
	                                }
	                                else
	                                {
	                                    vec3 _23867 = _14658 - vec3(0.5);
	                                    _23867.z = _23867.z * 1.2000000476837158203125;
	                                    _12502 = _16310 * clamp(smoothstep(_8419, _14551, clamp(length(_23867), 0.0, 1.0)), 0.0, 1.0);
	                                }
	                                _9429 = _12502;
	                            }
	                            else
	                            {
	                                _9429 = _16310;
	                            }
	                            float _15862 = pow(clamp((dot(normalize(_14658 - vec3(0.5)), PerViewLightingConstantBufferGpu_t._m0.xyz) * 0.800000011920928955078125) + 0.20000000298023223876953125, 0.0, 1.0), 2.0);
	                            float _11659;
	                            if (_15862 > 0.0)
	                            {
	                                _11659 = _15862 * _20413.w;
	                            }
	                            else
	                            {
	                                _11659 = _15862;
	                            }
	                            vec3 _7844 = (((_20413.xyz * (1.0 - _9429)) * 0.5) + (saturate(PerViewLightingConstantBufferGpu_t._m1.xyz) * (_11659 * (1.0 - _13618)))) * _8377;
	                            vec3 _23772 = _7844 * SmokeConstantBuffer_t._m4._m0[_21927].xyz;
	                            vec3 _25142 = mix(_7844, _23772 * (dot(_7844.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot((_23772 + vec3(0.001000000047497451305389404296875)).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), vec3(0.5 * (1.0 - SmokeConstantBuffer_t._m5._m0[_21927].z))).xyz;
	                            vec3 _21313 = mix(_25142, _25142 * _13147, vec3(0.60000002384185791015625)).xyz;
	                            float _9049 = smoothstep(0.0, 0.20000000298023223876953125, clamp(mix(_9429 - (1.0 - _8377), _9429 + _8377, _9429), 0.0, 1.0));
	                            _22608 = _13138 + (vec4(clamp((_21313 + ((_21313 * vec3(8.0, 4.0, 0.0)) * _16308)) * _9049, vec3(0.0), vec3(1.0)), _9049) * (1.0 - _13138.w));
	                            break;
	                        }
	                        _22608 = _13138;
	                        break;
	                    } while(false);
	                    _20544[_17019] = _20544[_17019];
	                    if (_22608.w > 0.990999996662139892578125)
	                    {
	                        vec4 _23482 = _22608;
	                        _23482.w = 1.0;
	                        _13150 = _16308;
	                        _16312 = _10842;
	                        _17123 = _13618;
	                        _17124 = _13141;
	                        _17152 = _23482;
	                        _16863 = true;
	                        _7956_ladder_break = true;
	                        break;
	                    }
	                    _13149 = _22608;
	                    _16311 = _16308;
	                    _17121 = _10842;
	                    _14891 = _13618;
	                    _18361 = _13141;
	                    break;
	                } while(false);
	                if (_7956_ladder_break)
	                {
	                    break;
	                }
	                _8897 = _17019 + 1u;
	                _13138 = _13149;
	                _16306 = _16311;
	                _17119 = _17121;
	                _17120 = _14891;
	                _17134 = _18361;
	                _17019 = _8897;
	                continue;
	            }
	            if (_16863)
	            {
	                _13174 = _17152;
	                _16054 = _16863;
	                break;
	            }
	            _12783 = _17118 + _14798;
	            _7831 = _17133 + _24637;
	            _11496 = _17018 + 1;
	            _13137 = _16863;
	            _16305 = _17152;
	            _17114 = _13150;
	            _17115 = _16312;
	            _17116 = _17123;
	            _17117 = _17124;
	            _17118 = _12783;
	            _17133 = _7831;
	            _17018 = _11496;
	            continue;
	        }
	        if (_16054)
	        {
	            break;
	        }
	        break;
	    } while(false);
	    if (_13174.w < 9.9999997473787516355514526367188e-06)
	    {
	        discard;
	    }
	    output_0 = _13174;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
