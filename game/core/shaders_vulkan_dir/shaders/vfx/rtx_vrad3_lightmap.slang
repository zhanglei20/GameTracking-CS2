//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader to generate lightmaps";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_60
	// Programs: rtx
}

MODES
{
	RayTrace();
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

RTX
{
	StaticCombo( S_EXECUTION_REORDERING, 0..1 );
	DynamicCombo( D_SH_LIGHTMAPS, 0..1 );
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (166136 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#if defined(GL_AMD_gpu_shader_half_float)
	#extension GL_AMD_gpu_shader_half_float : require
	#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
	#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
	#else
	#error No extension available for FP16.
	#endif
	#extension GL_EXT_shader_16bit_storage : require
	#extension GL_EXT_ray_tracing : require
	#extension GL_EXT_nonuniform_qualifier : require
	#extension GL_EXT_samplerless_texture_functions : require
	#if defined(GL_EXT_control_flow_attributes)
	#extension GL_EXT_control_flow_attributes : require
	#define SPIRV_CROSS_FLATTEN [[flatten]]
	#define SPIRV_CROSS_BRANCH [[dont_flatten]]
	#define SPIRV_CROSS_UNROLL [[unroll]]
	#define SPIRV_CROSS_LOOP [[dont_unroll]]
	#else
	#define SPIRV_CROSS_FLATTEN
	#define SPIRV_CROSS_BRANCH
	#define SPIRV_CROSS_UNROLL
	#define SPIRV_CROSS_LOOP
	#endif
	#extension GL_KHR_shader_subgroup_arithmetic : require
	#extension GL_EXT_shader_image_load_formatted : require
	
	struct LightmapSample_t_natural_logical
	{
	    vec4 m_vPositionWs;
	    vec4 m_vShadingNormalWs_vTransmissiveR;
	    vec4 m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 m_vFaceNormalWs_vTransmissiveB;
	    vec4 m_vTangentWs;
	    vec2 m_vLightmapUv;
	    int m_nInstanceFlags;
	    uint m_nSampleFlags;
	};
	
	struct MaterialDataMinimal_t
	{
	    f16vec3 vNormalWs;
	    float16_t flMetalness;
	    f16vec3 vAlbedo;
	    float16_t flRoughness;
	    f16vec3 vEmissive;
	    float16_t flReflectance;
	    uint nMaterialTypeAndFlags;
	    f16vec4 vMaterialBits;
	};
	
	struct Payload_t
	{
	    vec3 vSmoothPositionWs;
	    vec3 vFaceNormalWs;
	    vec3 vInterpolatedNormalWs;
	    float flHitT;
	    float flOpacityRng;
	    int nInstance;
	    bool bFlippedNormal;
	    MaterialDataMinimal_t material;
	};
	
	struct Luxel_t_natural
	{
	    vec4 vIrradiance_flSampleCount;
	    vec4 vShr;
	    vec4 vShg;
	    vec4 vShb;
	    vec4 vQuadraticr;
	    vec4 vQuadraticg;
	    vec4 vQuadraticb;
	    vec4 vQuadraticFinalrgb;
	    vec4 vBakedShadow;
	    vec4 vBakedShadowUnoccluded;
	    ivec4 vBakedShadowLightId;
	    vec4 vTangent;
	    vec4 vNormal;
	    vec4 flAmbientOcclusion_vPadding;
	};
	
	struct SceneGlobalInfoGPU_t_natural_logical
	{
	    vec4 m_vSkyColor;
	    vec4 m_vSkyAmbientBounce;
	    vec4 m_vSunLightIrradiance;
	    vec4 m_vLocalLightMinBounds;
	    vec4 m_vLocalLightMaxBounds;
	    ivec4 m_vLightBinCellCount_nLightCount;
	    mat4x3 m_mIBLTransformI;
	    vec4 m_vIBLCubeMapScale;
	    ivec4 m_vIBLParams;
	    ivec4 m_vBrdfLUTs;
	};
	
	struct SceneGlobalInfoGPU_t_natural
	{
	    vec4 m_vSkyColor;
	    vec4 m_vSkyAmbientBounce;
	    vec4 m_vSunLightIrradiance;
	    vec4 m_vLocalLightMinBounds;
	    vec4 m_vLocalLightMaxBounds;
	    ivec4 m_vLightBinCellCount_nLightCount;
	    mat4x3 m_mIBLTransformI;
	    vec4 m_vIBLCubeMapScale;
	    ivec4 m_vIBLParams;
	    ivec4 m_vBrdfLUTs;
	};
	
	struct LightmapSample_t_natural
	{
	    vec4 m_vPositionWs;
	    vec4 m_vShadingNormalWs_vTransmissiveR;
	    vec4 m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 m_vFaceNormalWs_vTransmissiveB;
	    vec4 m_vTangentWs;
	    vec2 m_vLightmapUv;
	    int m_nInstanceFlags;
	    uint m_nSampleFlags;
	};
	
	struct PackedRtxInstanceData_t_natural_logical
	{
	    uint nSrgbColor;
	    uint nTriangleGeometry;
	    uint nMaterialData;
	    uint nMaterialFlags_nInstanceFlags;
	    float fEmissiveBoost;
	    uint nInstanceFlags;
	    uint _pad1;
	    uint _pad2;
	};
	
	struct PackedRtxInstanceData_t_natural
	{
	    uint nSrgbColor;
	    uint nTriangleGeometry;
	    uint nMaterialData;
	    uint nMaterialFlags_nInstanceFlags;
	    float fEmissiveBoost;
	    uint nInstanceFlags;
	    uint _pad1;
	    uint _pad2;
	};
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	struct _Array_natural_vector_float_4_5
	{
	    vec4 data[5];
	};
	
	struct PathTraceBarnLightGPU_t_natural
	{
	    mat4 m_mToClipSpace;
	    mat4 m_mFromClipSpace;
	    vec4 m_vNearPlane;
	    vec4 m_vLightPosition;
	    vec4 m_vCookieParameters;
	    vec4 m_vColor;
	    vec4 m_vBounceColor;
	    vec4 m_vOrientation;
	    vec4 m_vAngleFade;
	    vec4 m_vDistanceFade_vSkirt;
	    _Array_natural_vector_float_4_5 m_vLuminaireVectors;
	    vec4 m_vMinBounds;
	    vec4 m_vMaxBounds;
	    vec4 m_vIlluminationBoundsCenter;
	    vec4 m_qIlluminationBoundsOrient;
	    vec4 m_vIlluminationBoundsExtent;
	    mat4x3 m_mBarnIlluminationFromWorld;
	    int m_nCookie;
	    int m_nLuminaireType;
	    int m_nPathTraceFlags;
	    int m_bSphericalCookie;
	    int m_nBakedShadowIndex;
	    int m_nShadowedLightId;
	    int m_nPreviewBakedShadowIndex;
	    int _pad;
	};
	
	struct _Array_natural_vector_float_4_480
	{
	    vec4 data[480];
	};
	
	struct SSProfileConstants_natural
	{
	    vec4 m_vNearInv2Variance;
	    vec4 m_vNearInvPi2Variance;
	    vec4 m_vFarInv2Variance;
	    vec4 m_vFarInvPi2Variance_NearWt;
	    vec4 m_vNormalization;
	    uint m_bDualLobeSpecular;
	    float m_fDualLobeRoughness0;
	    float m_fDualLobeRoughness1;
	    float m_fDualLobeRoughnessMix;
	    vec3 m_vTransmissiveLogColor;
	    float m_fTransmissiveSaturation;
	    float m_fFresnelExponent;
	    float m_fPad0;
	    float m_fPad1;
	    float m_fPad2;
	};
	
	struct _Array_natural_SSProfileConstants32
	{
	    SSProfileConstants_natural data[32];
	};
	
	const vec4 _296[5] = vec4[](vec4(0.0), vec4(1.0, 0.0, 0.0, 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	
	struct Luxel_t_natural_logical
	{
	    vec4 vIrradiance_flSampleCount;
	    vec4 vShr;
	    vec4 vShg;
	    vec4 vShb;
	    vec4 vQuadraticr;
	    vec4 vQuadraticg;
	    vec4 vQuadraticb;
	    vec4 vQuadraticFinalrgb;
	    vec4 vBakedShadow;
	    vec4 vBakedShadowUnoccluded;
	    ivec4 vBakedShadowLightId;
	    vec4 vTangent;
	    vec4 vNormal;
	    vec4 flAmbientOcclusion_vPadding;
	};
	
	vec4 _310;
	float _311;
	
	layout(set = 6, binding = 158, std430) buffer RWStructuredBuffer
	{
	    Luxel_t_natural _member0[];
	} g_Luxels;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    layout(row_major) SceneGlobalInfoGPU_t_natural _member0[];
	} g_SceneGlobalInfo;
	
	layout(set = 6, binding = 160, std430) buffer g_LightmapSamples
	{
	    LightmapSample_t_natural _member0[];
	} g_LightmapSamples_1;
	
	layout(set = 3, binding = 35, std430) readonly buffer g_instanceBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer_1;
	
	layout(set = 6, binding = 159, std430) buffer g_LightBins
	{
	    uint _member0[];
	} g_LightBins_1;
	
	layout(set = 3, binding = 36, std430) readonly buffer g_Lights
	{
	    layout(row_major) PathTraceBarnLightGPU_t_natural _member0[];
	} g_Lights_1;
	
	struct SLANG_ParameterGroup_SubsurfaceProfilesConstantBuffer_t_natural
	{
	    uint g_nSampleCount;
	    uint _padA;
	    uint _padB;
	    uint _padC;
	    _Array_natural_vector_float_4_480 g_vSubsurfaceSamples;
	    _Array_natural_SSProfileConstants32 g_SubsurfaceProfile;
	};
	
	layout(set = 3) uniform SLANG_ParameterGroup_SubsurfaceProfilesConstantBuffer_t_natural SubsurfaceProfilesConstantBuffer_t;
	
	layout(push_constant, std430) uniform LightmapPushConstants_t_natural
	{
	    ivec4 m_nEstimate_DimensionCount;
	    vec4 m_vLightmapOffsetAndSize;
	    vec4 m_vCordonMins;
	    vec4 m_vCordonMaxs;
	} g_PushConstants;
	
	layout(set = 6, binding = 162, r32ui) uniform readonly uimage3D g_LightmapBlockConverged;
	layout(set = 6, binding = 161) uniform readonly image3D g_RandomSamples;
	layout(set = 6, binding = 30) uniform utexture2D g_LuxelChartIDs;
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D[65536];
	layout(set = 3, binding = 15) uniform sampler g_CookieSampler;
	
	void main()
	{
	    bool _623 = false;
	    bool _723 = false;
	    bool _777 = false;
	    do
	    {
	        uint _856 = (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x) + gl_LaunchIDEXT.x;
	        if (g_PushConstants.m_nEstimate_DimensionCount.x == 0)
	        {
	            g_Luxels._member0[_856].vIrradiance_flSampleCount = vec4(0.0);
	            g_Luxels._member0[_856].vShr = vec4(0.0);
	            g_Luxels._member0[_856].vShg = vec4(0.0);
	            g_Luxels._member0[_856].vShb = vec4(0.0);
	            g_Luxels._member0[_856].vQuadraticr = vec4(0.0);
	            g_Luxels._member0[_856].vQuadraticg = vec4(0.0);
	            g_Luxels._member0[_856].vQuadraticb = vec4(0.0);
	            g_Luxels._member0[_856].vQuadraticFinalrgb = vec4(0.0);
	            g_Luxels._member0[_856].vBakedShadow = vec4(0.0);
	            g_Luxels._member0[_856].vBakedShadowUnoccluded = vec4(0.0);
	            g_Luxels._member0[_856].vBakedShadowLightId = ivec4(255);
	            g_Luxels._member0[_856].vTangent = vec4(0.0);
	            g_Luxels._member0[_856].vNormal = vec4(0.0);
	            g_Luxels._member0[_856].flAmbientOcclusion_vPadding = vec4(0.0);
	        }
	        else
	        {
	            if (imageLoad(g_LightmapBlockConverged, ivec3(gl_LaunchIDEXT / uvec3(4u, 4u, 1u))).x != 0u)
	            {
	                break;
	            }
	        }
	        uvec3 _896 = uvec3(imageSize(g_RandomSamples));
	        ivec3 _841;
	        ivec3 _899 = _841;
	        _899.x = int(_896.x);
	        _899.y = int(_896.y);
	        _899.z = int(_896.z);
	        _841 = _899;
	        ivec2 _908 = ivec2(gl_LaunchIDEXT.xy) - _899.xy * (ivec2(gl_LaunchIDEXT.xy) / _899.xy);
	        uint _909 = uint(g_PushConstants.m_nEstimate_DimensionCount.y);
	        SceneGlobalInfoGPU_t_natural_logical _912;
	        _912.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	        _912.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	        _912.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	        _912.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	        _912.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	        _912.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	        _912.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	        _912.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	        _912.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	        _912.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	        SceneGlobalInfoGPU_t_natural_logical _917;
	        _917.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	        _917.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	        _917.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	        _917.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	        _917.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	        _917.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	        _917.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	        _917.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	        _917.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	        _917.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	        SceneGlobalInfoGPU_t_natural_logical _922;
	        _922.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	        _922.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	        _922.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	        _922.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	        _922.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	        _922.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	        _922.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	        _922.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	        _922.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	        _922.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	        SceneGlobalInfoGPU_t_natural_logical _927;
	        _927.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	        _927.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	        _927.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	        _927.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	        _927.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	        _927.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	        _927.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	        _927.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	        _927.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	        _927.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	        uint _933 = uint(max(1, ((_927.m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	        uvec3 _934 = uvec3(_922.m_vLightBinCellCount_nLightCount.xyz);
	        vec3 _937 = vec3(_934) / (_917.m_vLocalLightMaxBounds.xyz - _912.m_vLocalLightMinBounds.xyz);
	        vec3 _939 = (-_912.m_vLocalLightMinBounds.xyz) * _937;
	        uvec4 sampled = texelFetch(g_LuxelChartIDs, ivec2(gl_LaunchIDEXT.xy), 0);
	        uint _943 = sampled.x;
	        if (_943 == 4294967295u)
	        {
	            break;
	        }
	        vec2 _951 = (g_PushConstants.m_vLightmapOffsetAndSize.xy + vec2(gl_LaunchIDEXT.xy)) + vec2(0.5);
	        vec2 vSeed = imageLoad(g_RandomSamples, ivec3(_908.xy, 1)).xy;
	        float flReservoirWt = 0.0;
	        vec4 _490 = vec4(0.0);
	        vec4 _489 = vec4(0.0);
	        vec4 _488 = vec4(0.0);
	        vec4 _487 = vec4(0.0);
	        vec4 _486 = vec4(0.0);
	        int _485 = 0;
	        uint _484 = 0u;
	        int dy = -2;
	        bool _839;
	        bool _840;
	        bool _842;
	        bool _843;
	        for (;;)
	        {
	            if (!(dy <= 2))
	            {
	                break;
	            }
	            int dx = -2;
	            for (;;)
	            {
	                bool _971_ladder_break = false;
	                do
	                {
	                    if (!(dx <= 2))
	                    {
	                        _971_ladder_break = true;
	                        break;
	                    }
	                    uvec2 _984 = gl_LaunchIDEXT.xy + uvec2(ivec2(dx, dy));
	                    ivec2 _985 = ivec2(_984);
	                    int _986 = _985.x;
	                    if (_986 < 0)
	                    {
	                        _842 = true;
	                    }
	                    else
	                    {
	                        _842 = uint(_986) >= gl_LaunchSizeEXT.x;
	                    }
	                    if (_842)
	                    {
	                        break;
	                    }
	                    int _998 = _985.y;
	                    if (_998 < 0)
	                    {
	                        _843 = true;
	                    }
	                    else
	                    {
	                        _843 = uint(_998) >= gl_LaunchSizeEXT.y;
	                    }
	                    if (_843)
	                    {
	                        break;
	                    }
	                    if (texelFetch(g_LuxelChartIDs, ivec2(_984), 0).x != _943)
	                    {
	                        break;
	                    }
	                    uint nSample = (uint(_998) * gl_LaunchSizeEXT.y) + uint(_986);
	                    LightmapSample_t_natural_logical _1022;
	                    _1022.m_vPositionWs = g_LightmapSamples_1._member0[nSample].m_vPositionWs;
	                    _1022.m_vShadingNormalWs_vTransmissiveR = g_LightmapSamples_1._member0[nSample].m_vShadingNormalWs_vTransmissiveR;
	                    _1022.m_vInterpolatedNormalWs_vTransmissiveG = g_LightmapSamples_1._member0[nSample].m_vInterpolatedNormalWs_vTransmissiveG;
	                    _1022.m_vFaceNormalWs_vTransmissiveB = g_LightmapSamples_1._member0[nSample].m_vFaceNormalWs_vTransmissiveB;
	                    _1022.m_vTangentWs = g_LightmapSamples_1._member0[nSample].m_vTangentWs;
	                    _1022.m_vLightmapUv = g_LightmapSamples_1._member0[nSample].m_vLightmapUv;
	                    _1022.m_nInstanceFlags = g_LightmapSamples_1._member0[nSample].m_nInstanceFlags;
	                    _1022.m_nSampleFlags = g_LightmapSamples_1._member0[nSample].m_nSampleFlags;
	                    vec2 _483 = _1022.m_vLightmapUv;
	                    if (_1022.m_vPositionWs.w <= 0.0)
	                    {
	                        break;
	                    }
	                    vec2 vDx = (_483.xy * g_PushConstants.m_vLightmapOffsetAndSize.zw) - _951;
	                    float _1041 = 0.79788458347320556640625 * exp(dot(vDx, vDx) * (-2.0));
	                    float _844 = vSeed.y;
	                    do
	                    {
	                        float _1046 = flReservoirWt;
	                        float _1047 = _1046 + _1041;
	                        flReservoirWt = _1047;
	                        if (_1047 == 0.0)
	                        {
	                            _839 = false;
	                            break;
	                        }
	                        float _1052 = _1041 / flReservoirWt;
	                        do
	                        {
	                            if (_1052 <= 0.0)
	                            {
	                                _840 = false;
	                                break;
	                            }
	                            if (_1052 >= 1.0)
	                            {
	                                _840 = true;
	                                break;
	                            }
	                            if (_844 < _1052)
	                            {
	                                _844 = min(_844 / _1052, 0.99999988079071044921875);
	                                _840 = true;
	                                break;
	                            }
	                            _844 = min((_844 - _1052) / (1.0 - _1052), 0.99999988079071044921875);
	                            _840 = false;
	                            break;
	                        } while(false);
	                        _839 = _840;
	                        break;
	                    } while(false);
	                    vec2 _1077 = vSeed;
	                    _1077.y = _844;
	                    vSeed = _1077;
	                    if (_839)
	                    {
	                        _490 = _1022.m_vPositionWs;
	                        _489 = _1022.m_vShadingNormalWs_vTransmissiveR;
	                        _488 = _1022.m_vInterpolatedNormalWs_vTransmissiveG;
	                        _487 = _1022.m_vFaceNormalWs_vTransmissiveB;
	                        _486 = _1022.m_vTangentWs;
	                        _485 = _1022.m_nInstanceFlags;
	                        _484 = _1022.m_nSampleFlags;
	                    }
	                    break;
	                } while(false);
	                if (_971_ladder_break)
	                {
	                    break;
	                }
	                dx++;
	                continue;
	            }
	            dy++;
	            continue;
	        }
	        if (!(_490.w != 0.0))
	        {
	            break;
	        }
	        vec3 _1097 = abs(_490.xyz);
	        vec3 _482 = _490.xyz + (_487.xyz * ((abs(_490.xyz) + vec3(abs(max(_1097.x, max(_1097.y, _1097.z))))) * 9.9999997473787516355514526367188e-05));
	        vec3 _1113 = abs(_490.xyz);
	        vec3 _481 = _490.xyz + ((-_487.xyz) * ((abs(_490.xyz) + vec3(abs(max(_1113.x, max(_1113.y, _1113.z))))) * 9.9999997473787516355514526367188e-05));
	        f16vec3 _322 = f16vec3(_489.xyz);
	        vec3 _480 = _487.xyz;
	        vec3 _372;
	        vec3 _845 = _372;
	        vec3 _371;
	        vec3 _846 = _371;
	        float _838;
	        if (_489.z >= 0.0)
	        {
	            _838 = 1.0;
	        }
	        else
	        {
	            _838 = -1.0;
	        }
	        float _1139 = (-1.0) / (_838 + _489.z);
	        float _1143 = (_489.x * _489.y) * _1139;
	        vec3 _1148 = _845;
	        _1148.x = 1.0 + (((_838 * _489.x) * _489.x) * _1139);
	        _1148.y = _838 * _1143;
	        _1148.z = (-_838) * _489.x;
	        _845 = _1148;
	        vec3 _1155 = _846;
	        _1155.x = _1143;
	        _1155.y = _838 + ((_489.y * _489.y) * _1139);
	        _1155.z = -_489.y;
	        _846 = _1155;
	        _372 = _1148;
	        _371 = _1155;
	        f16vec3 _320 = f16vec3(vec3(1.0));
	        int _479 = _485;
	        vec3 vTransmissiveRatio = vec3(_489.w, _488.w, _487.w);
	        vec4 _478 = vec4(0.0);
	        vec4 _477 = vec4(0.0);
	        vec4 _476 = vec4(0.0);
	        vec4 _475 = vec4(0.0);
	        vec4 _474 = vec4(0.0);
	        vec4 _473 = vec4(0.0);
	        vec4 _472 = vec4(0.0);
	        vec4 _471 = vec4(0.0);
	        vec4 _470 = vec4(0.0);
	        vec4 _469 = vec4(0.0);
	        ivec4 _468 = ivec4(255);
	        vec4 _467 = vec4(0.0);
	        vec4 _466 = vec4(0.0);
	        vec4 _465 = vec4(0.0);
	        if (all(greaterThanEqual(_490.xyz, g_PushConstants.m_vCordonMins.xyz)))
	        {
	            _842 = all(lessThanEqual(_490.xyz, g_PushConstants.m_vCordonMaxs.xyz));
	        }
	        else
	        {
	            _842 = false;
	        }
	        if (_842)
	        {
	            f16vec4 _316;
	            uint _317;
	            float16_t _318;
	            float16_t _319;
	            float16_t _321;
	            if ((_484 & 2u) != 0u)
	            {
	                f16vec3 _1203 = f16vec3(vec3(0.0));
	                vec3 _491;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _491, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_1203, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1203, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _482 + (_487.xyz * 0.037500001490116119384765625), 0.0, -_487.xyz, 0.07500000298023223876953125, 0);
	                if (p.nInstance != (-1))
	                {
	                    _322 = p.material.vNormalWs;
	                    _321 = p.material.flMetalness;
	                    _320 = p.material.vAlbedo;
	                    _319 = p.material.flRoughness;
	                    _318 = p.material.flReflectance;
	                    _317 = p.material.nMaterialTypeAndFlags;
	                    _316 = p.material.vMaterialBits;
	                }
	            }
	            _484 &= 4294967292u;
	            vec4 _1226 = _466;
	            _1226.x = _488.x;
	            _1226.y = _488.y;
	            _1226.z = _488.z;
	            _466 = _1226;
	            _467 = _486;
	            vec3 _368;
	            float _369;
	            float _370;
	            ivec2 _464 = _908;
	            uint _463 = _909;
	            uint _462 = _933;
	            uvec3 _461 = _934;
	            vec3 _460 = _939;
	            vec3 _459 = _937;
	            vec3 _495 = _482;
	            vec3 _494 = _481;
	            vec3 _493 = _480;
	            int _492 = _479;
	            f16vec3 _329 = _322;
	            float16_t _328 = _321;
	            f16vec3 _327 = _320;
	            float16_t _326 = _319;
	            float16_t _325 = _318;
	            uint _324 = _317;
	            f16vec4 _323 = _316;
	            vec3 _377 = _372;
	            vec3 _376 = _371;
	            float _375 = _370;
	            float _374 = _369;
	            vec3 _373 = _368;
	            vec2 _830 = vSeed;
	            float _831;
	            if (false)
	            {
	                _831 = 0.5;
	            }
	            else
	            {
	                float _1254 = max(_489.w, max(_488.w, _487.w));
	                _831 = _1254 / (_1254 + 1.0);
	            }
	            float _832 = _830.x;
	            bool _829;
	            do
	            {
	                if (_831 <= 0.0)
	                {
	                    _829 = false;
	                    break;
	                }
	                if (_831 >= 1.0)
	                {
	                    _829 = true;
	                    break;
	                }
	                if (_832 < _831)
	                {
	                    _832 = min(_832 / _831, 0.99999988079071044921875);
	                    _829 = true;
	                    break;
	                }
	                _832 = min((_832 - _831) / (1.0 - _831), 0.99999988079071044921875);
	                _829 = false;
	                break;
	            } while(false);
	            vec2 _1282 = _830;
	            _1282.x = _832;
	            _830 = _1282;
	            if (_829)
	            {
	                _495 = _494;
	            }
	            else
	            {
	                _831 = 1.0 - _831;
	            }
	            float _1292 = sqrt(_830.y);
	            float _1294 = 6.283185482025146484375 * _830.x;
	            vec3 _1302 = vec3(cos(_1294) * _1292, sin(_1294) * _1292, sqrt(max(0.0, 1.0 - _830.y)));
	            vec3 _833 = _1302;
	            float _1305 = _831;
	            if (_829)
	            {
	                _831 = -_833.z;
	            }
	            else
	            {
	                _831 = _833.z;
	            }
	            vec3 _1316 = _833;
	            _1316.z = _831;
	            _833 = _1316;
	            vec3 _1323 = mat3(_377, _376, vec3(_329)) * _1316;
	            vec3 _818 = _1323;
	            vec3 _523 = _495;
	            vec3 _522 = _494;
	            vec3 _521 = _493;
	            int _520 = _492;
	            f16vec3 _351 = _329;
	            float16_t _350 = _328;
	            f16vec3 _349 = _327;
	            float16_t _348 = _326;
	            float16_t _347 = _325;
	            uint _346 = _324;
	            f16vec4 _345 = _323;
	            vec3 _413 = _377;
	            vec3 _412 = _376;
	            float _411 = _375;
	            float _410 = _374;
	            vec3 _409 = _373;
	            int _819 = 1;
	            vec3 _820 = vec3(1.0 / (_1305 * (_1302.z * 0.3183098733425140380859375)));
	            vec3 _821 = vec3(0.0);
	            vec3 _524;
	            vec3 _540;
	            vec3 _570;
	            bool _660;
	            float _661;
	            bool _662;
	            vec3 _663;
	            bool _664;
	            vec3 _665;
	            vec3 _666;
	            float _667;
	            float _668;
	            bool _669;
	            vec3 _670;
	            bool _671;
	            vec3 _672;
	            bool _675;
	            bool _676;
	            bool _677;
	            float _678;
	            uint _679;
	            float _680;
	            bool _681;
	            float _682;
	            bool _683;
	            bool _684;
	            float _685;
	            float _686;
	            float _687;
	            bool _688;
	            float _689;
	            bool _690;
	            vec3 _691;
	            bool _692;
	            vec3 _693;
	            vec3 _694;
	            bool _695;
	            bool _696;
	            float _697;
	            vec4 _698;
	            vec4 _699;
	            float _700;
	            vec3 _701;
	            float _702;
	            float _703;
	            bool _704;
	            float _705;
	            vec4 _706;
	            vec2 _707;
	            float _708;
	            float _709;
	            vec4 _710;
	            float _711;
	            vec3 _712;
	            vec3 _713;
	            bool _714;
	            float _715;
	            vec4 _716;
	            vec2 _717;
	            float _718;
	            float _719;
	            vec3 _721;
	            vec3 _722;
	            vec4 _724;
	            float _725;
	            float _726;
	            vec3 _727;
	            vec3 _728;
	            float _729;
	            float _730;
	            bool _731;
	            vec3 _732;
	            vec3 _733;
	            bool _734;
	            bool _735;
	            vec3 _736;
	            float _743;
	            bool _745;
	            float _746;
	            bool _747;
	            vec3 _748;
	            bool _749;
	            vec3 _750;
	            vec3 _751;
	            vec4 _752;
	            vec4 _753;
	            float _754;
	            vec3 _755;
	            float _756;
	            float _757;
	            bool _758;
	            float _759;
	            vec4 _760;
	            vec2 _761;
	            float _762;
	            float _763;
	            vec4 _764;
	            float _765;
	            vec3 _766;
	            vec3 _767;
	            bool _768;
	            float _769;
	            vec4 _770;
	            vec2 _771;
	            float _772;
	            float _773;
	            vec3 _775;
	            vec3 _776;
	            vec4 _778;
	            float _779;
	            float _780;
	            vec3 _781;
	            vec3 _782;
	            float _783;
	            float _784;
	            bool _785;
	            vec3 _786;
	            vec3 _787;
	            bool _788;
	            bool _789;
	            vec3 _790;
	            float _795;
	            bool _796;
	            bool _797;
	            bool _798;
	            vec3 _800;
	            float _802;
	            float _803;
	            bool _806;
	            float _807;
	            float _808;
	            bool _811;
	            bool _812;
	            bool _814;
	            vec3 _816;
	            vec3 _817;
	            vec3 _822;
	            float _823;
	            float _826;
	            vec3 _828;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_819 <= 16))
	                {
	                    break;
	                }
	                SPIRV_CROSS_FLATTEN
	                if (false)
	                {
	                    SPIRV_CROSS_FLATTEN
	                    if (_819 > (-1))
	                    {
	                        _823 = 1.0;
	                        _822 = vec3(0.0);
	                    }
	                    else
	                    {
	                        if (_819 != (-1))
	                        {
	                            _823 = 0.0;
	                        }
	                        else
	                        {
	                            _823 = 1.0;
	                        }
	                        _822 = _820;
	                    }
	                }
	                else
	                {
	                    _823 = 1.0;
	                    _822 = _820;
	                }
	                if (all(equal(_822, vec3(0.0))))
	                {
	                    break;
	                }
	                vec3 _519 = _523;
	                vec3 _518 = _818;
	                vec2 _1380 = imageLoad(g_RandomSamples, ivec3(_464.xy, int(1u + uint(_819)))).xy;
	                f16vec3 _1382 = f16vec3(vec3(0.0));
	                vec2 _1388 = _1380;
	                _1388.y = 0.0;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _524, 3.4028234663852885981170418348452e+38, _1380.y, -1, false, MaterialDataMinimal_t(_1382, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1382, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 4u, 0u, 2u, 0u, _523, 0.0, _818, 56755.83984375, 0);
	                Payload_t _1390 = p;
	                vec2 _1392 = _1380;
	                _1392.y = _1390.flOpacityRng;
	                vec2 _824 = _1392;
	                if (!(_1390.nInstance != (-1)))
	                {
	                    vec2 _1408 = imageLoad(g_RandomSamples, ivec3(_464.xy, int(1u + uint(_819 + 1)))).xy;
	                    _824 = _1408;
	                    vec2 _813 = _1408;
	                    if (_818.z < 0.0)
	                    {
	                        float _815 = _813.y;
	                        do
	                        {
	                            if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w <= 0.0)
	                            {
	                                _812 = false;
	                                break;
	                            }
	                            if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w >= 1.0)
	                            {
	                                _812 = true;
	                                break;
	                            }
	                            if (_815 < g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w)
	                            {
	                                _815 = min(_815 / g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                                _812 = true;
	                                break;
	                            }
	                            _815 = min((_815 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                            _812 = false;
	                            break;
	                        } while(false);
	                        vec2 _1444 = _813;
	                        _1444.y = _815;
	                        _813 = _1444;
	                        _814 = _812;
	                    }
	                    else
	                    {
	                        _814 = false;
	                    }
	                    if (_814)
	                    {
	                        float _1452 = sqrt(_813.y);
	                        float _1454 = 6.283185482025146484375 * _813.x;
	                        _816 = vec3(cos(_1454) * _1452, sin(_1454) * _1452, sqrt(max(0.0, 1.0 - _813.y)));
	                        _817 = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.xyz;
	                    }
	                    else
	                    {
	                        _816 = _818;
	                        _817 = vec3(0.0);
	                    }
	                    if (g_SceneGlobalInfo._member0[0].m_vIBLParams.y >= 0)
	                    {
	                        vec4 _1500 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._member0[0].m_vIBLParams.y], g_Sampler), normalize(g_SceneGlobalInfo._member0[0].m_mIBLTransformI * vec4(_816, 0.0)), 0.0);
	                        if (dot(_1500.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.w)
	                        {
	                            _817 += (g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.xyz * _1500.xyz);
	                        }
	                    }
	                    else
	                    {
	                        _817 += g_SceneGlobalInfo._member0[0].m_vSkyColor.xyz;
	                    }
	                    if (_819 > 1)
	                    {
	                        _817 *= g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.w;
	                    }
	                    if (_814)
	                    {
	                        _817 *= g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.xyz;
	                    }
	                    _821 += ((_822 * _817) * _823);
	                    break;
	                }
	                uint _1535 = uint(_1390.nInstance);
	                PackedRtxInstanceData_t_natural_logical _1538;
	                _1538.nSrgbColor = g_instanceBuffer_1._member0[_1535].nSrgbColor;
	                _1538.nTriangleGeometry = g_instanceBuffer_1._member0[_1535].nTriangleGeometry;
	                _1538.nMaterialData = g_instanceBuffer_1._member0[_1535].nMaterialData;
	                _1538.nMaterialFlags_nInstanceFlags = g_instanceBuffer_1._member0[_1535].nMaterialFlags_nInstanceFlags;
	                _1538.fEmissiveBoost = g_instanceBuffer_1._member0[_1535].fEmissiveBoost;
	                _1538.nInstanceFlags = g_instanceBuffer_1._member0[_1535].nInstanceFlags;
	                _1538._pad1 = g_instanceBuffer_1._member0[_1535]._pad1;
	                _1538._pad2 = g_instanceBuffer_1._member0[_1535]._pad2;
	                uint _525 = _1538.nMaterialFlags_nInstanceFlags;
	                if ((int((_525 >> uint(16)) & 65535u) & 4) != 0)
	                {
	                    break;
	                }
	                vec3 _513 = _519;
	                vec3 _512 = _518;
	                vec3 _511 = _1390.vSmoothPositionWs;
	                vec3 _510 = _1390.vFaceNormalWs;
	                float _509 = _1390.flHitT;
	                f16vec3 _403 = _1390.material.vNormalWs;
	                float16_t _402 = _1390.material.flMetalness;
	                f16vec3 _401 = _1390.material.vAlbedo;
	                float16_t _400 = _1390.material.flRoughness;
	                f16vec3 _399 = _1390.material.vEmissive;
	                float16_t _398 = _1390.material.flReflectance;
	                uint _397 = _1390.material.nMaterialTypeAndFlags;
	                f16vec4 _396 = _1390.material.vMaterialBits;
	                uint _1566 = uint(_1390.nInstance);
	                PackedRtxInstanceData_t_natural_logical _1569;
	                _1569.nSrgbColor = g_instanceBuffer_1._member0[_1566].nSrgbColor;
	                _1569.nTriangleGeometry = g_instanceBuffer_1._member0[_1566].nTriangleGeometry;
	                _1569.nMaterialData = g_instanceBuffer_1._member0[_1566].nMaterialData;
	                _1569.nMaterialFlags_nInstanceFlags = g_instanceBuffer_1._member0[_1566].nMaterialFlags_nInstanceFlags;
	                _1569.fEmissiveBoost = g_instanceBuffer_1._member0[_1566].fEmissiveBoost;
	                _1569.nInstanceFlags = g_instanceBuffer_1._member0[_1566].nInstanceFlags;
	                _1569._pad1 = g_instanceBuffer_1._member0[_1566]._pad1;
	                _1569._pad2 = g_instanceBuffer_1._member0[_1566]._pad2;
	                uint _531 = _1569.nMaterialFlags_nInstanceFlags;
	                float _530 = _1569.fEmissiveBoost;
	                vec3 _529 = (_513 + (_512 * _509)) + (_510 * ((abs(_513) + vec3(abs(_509))) * 9.9999997473787516355514526367188e-05));
	                vec3 _528 = (_513 + (_512 * _509)) + ((-_510) * ((abs(_513) + vec3(abs(_509))) * 9.9999997473787516355514526367188e-05));
	                vec3 _527 = _510;
	                int _526 = int(_531 & 65535u);
	                vec3 _536 = vec3(0.0);
	                vec3 _535 = vec3(0.0);
	                float _534 = 0.0;
	                float _533 = 0.0;
	                vec3 _532 = vec3(0.0);
	                f16vec3 _426 = _403;
	                float16_t _425 = _402;
	                f16vec3 _424 = _401;
	                f16vec3 _422 = _399;
	                float16_t _421 = _398;
	                uint _420 = _397;
	                f16vec4 _419 = _396;
	                float16_t _423 = float16_t(max(float(_400), 0.07999999821186065673828125));
	                vec3 _1614 = vec3(_403);
	                vec3 _809 = vec3(0.0);
	                vec3 _810 = vec3(0.0);
	                float _1615 = _1614.z;
	                if (_1615 >= 0.0)
	                {
	                    _808 = 1.0;
	                }
	                else
	                {
	                    _808 = -1.0;
	                }
	                float _1622 = (-1.0) / (_808 + _1615);
	                float _1623 = _1614.x;
	                float _1624 = _1614.y;
	                float _1626 = (_1623 * _1624) * _1622;
	                vec3 _1631 = _809;
	                _1631.x = 1.0 + (((_808 * _1623) * _1623) * _1622);
	                _1631.y = _808 * _1626;
	                _1631.z = (-_808) * _1623;
	                _809 = _1631;
	                vec3 _1638 = _810;
	                _1638.x = _1626;
	                _1638.y = _808 + ((_1624 * _1624) * _1622);
	                _1638.z = -_1624;
	                _810 = _1638;
	                _536 = _1631;
	                _535 = _1638;
	                vec3 _1650 = transpose(mat3(_1631, _1638, vec3(_426))) * (-_512);
	                _532 = _1650;
	                vec3 _1658 = vec3(mix(f16vec3(_421), _424, f16vec3(_425)));
	                _534 = dot((_1658 + ((vec3(1.0) - _1658) * pow(max(0.0, 1.0 - _1650.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                if ((_420 & 65535u) == 1u)
	                {
	                    float _1677 = dot(vec3(_419.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                    _533 = _1677 / max(9.9999997473787516355514526367188e-05, _1677 + dot(vec3(_424).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                }
	                f16vec3 _359 = _426;
	                float16_t _358 = _425;
	                f16vec3 _357 = _424;
	                float16_t _356 = _423;
	                f16vec3 _355 = _422;
	                float16_t _354 = _421;
	                uint _353 = _420;
	                f16vec4 _352 = _419;
	                vec3 _418 = _536;
	                vec3 _417 = _535;
	                float _416 = _534;
	                float _415 = _533;
	                vec3 _414 = _532;
	                if (true)
	                {
	                    if ((_526 & 256) != 0)
	                    {
	                        _355 *= float16_t(_530);
	                    }
	                    else
	                    {
	                        _355 = f16vec3(vec3(0.0));
	                    }
	                }
	                if (true)
	                {
	                    _811 = any(notEqual(_511, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _811 = false;
	                }
	                vec3 _1718 = _511 - _529;
	                float _1719 = length(_1718);
	                vec3 _539 = _529;
	                float _538 = 0.0;
	                vec3 _537 = vec4(_1718 / vec3(_1719), _1719).xyz;
	                if (_811)
	                {
	                    _807 = _1719;
	                }
	                else
	                {
	                    _807 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _539, _538, _537, _807, 1);
	                if (_811)
	                {
	                    _807 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _807 = 0.0;
	                }
	                if (_807 == 1.0)
	                {
	                    _529 = _511;
	                    _527 = vec3(_403);
	                }
	                vec3 _517 = _529;
	                vec3 _516 = _528;
	                vec3 _515 = _527;
	                int _514 = _526;
	                f16vec3 _344 = _359;
	                float16_t _343 = _358;
	                f16vec3 _342 = _357;
	                float16_t _341 = _356;
	                f16vec3 _340 = _355;
	                float16_t _339 = _354;
	                uint _338 = _353;
	                f16vec4 _337 = _352;
	                vec3 _408 = _418;
	                vec3 _407 = _417;
	                float _406 = _416;
	                float _405 = _415;
	                vec3 _404 = _414;
	                if (!(dot(_527, -_818) > 0.0))
	                {
	                    if ((_514 & 1024) != 0)
	                    {
	                        _515 = -_515;
	                        _344 = -_344;
	                        vec3 _2020 = _523;
	                        _523 = _522;
	                        _522 = _2020;
	                    }
	                    else
	                    {
	                        vec2 _1786 = imageLoad(g_RandomSamples, ivec3(_464.xy, int(1u + uint(_819)))).xy;
	                        f16vec3 _1788 = f16vec3(vec3(0.0));
	                        vec2 _1794 = _1786;
	                        _1794.y = 0.0;
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _540, 3.4028234663852885981170418348452e+38, _1786.y, -1, false, MaterialDataMinimal_t(_1788, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1788, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 4u, 0u, 2u, 0u, _519, _1390.flHitT * 0.99989998340606689453125, _518, _1390.flHitT * 1.00010001659393310546875, 0);
	                        vec2 _1800 = _1786;
	                        _1800.y = p.flOpacityRng;
	                        _824 = _1800;
	                        if (p.nInstance != (-1))
	                        {
	                            vec3 _508 = _519;
	                            vec3 _507 = _518;
	                            vec3 _506 = p.vSmoothPositionWs;
	                            vec3 _505 = p.vFaceNormalWs;
	                            float _504 = p.flHitT;
	                            f16vec3 _395 = p.material.vNormalWs;
	                            float16_t _394 = p.material.flMetalness;
	                            f16vec3 _393 = p.material.vAlbedo;
	                            float16_t _392 = p.material.flRoughness;
	                            f16vec3 _391 = p.material.vEmissive;
	                            float16_t _390 = p.material.flReflectance;
	                            uint _389 = p.material.nMaterialTypeAndFlags;
	                            f16vec4 _388 = p.material.vMaterialBits;
	                            uint _1821 = uint(p.nInstance);
	                            PackedRtxInstanceData_t_natural_logical _1824;
	                            _1824.nSrgbColor = g_instanceBuffer_1._member0[_1821].nSrgbColor;
	                            _1824.nTriangleGeometry = g_instanceBuffer_1._member0[_1821].nTriangleGeometry;
	                            _1824.nMaterialData = g_instanceBuffer_1._member0[_1821].nMaterialData;
	                            _1824.nMaterialFlags_nInstanceFlags = g_instanceBuffer_1._member0[_1821].nMaterialFlags_nInstanceFlags;
	                            _1824.fEmissiveBoost = g_instanceBuffer_1._member0[_1821].fEmissiveBoost;
	                            _1824.nInstanceFlags = g_instanceBuffer_1._member0[_1821].nInstanceFlags;
	                            _1824._pad1 = g_instanceBuffer_1._member0[_1821]._pad1;
	                            _1824._pad2 = g_instanceBuffer_1._member0[_1821]._pad2;
	                            uint _546 = _1824.nMaterialFlags_nInstanceFlags;
	                            float _545 = _1824.fEmissiveBoost;
	                            vec3 _544 = (_508 + (_507 * _504)) + (_505 * ((abs(_508) + vec3(abs(_504))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _543 = (_508 + (_507 * _504)) + ((-_505) * ((abs(_508) + vec3(abs(_504))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _542 = _505;
	                            int _541 = int(_546 & 65535u);
	                            vec3 _551 = vec3(0.0);
	                            vec3 _550 = vec3(0.0);
	                            float _549 = 0.0;
	                            float _548 = 0.0;
	                            vec3 _547 = vec3(0.0);
	                            f16vec3 _439 = _395;
	                            float16_t _438 = _394;
	                            f16vec3 _437 = _393;
	                            f16vec3 _435 = _391;
	                            float16_t _434 = _390;
	                            uint _433 = _389;
	                            f16vec4 _432 = _388;
	                            float16_t _436 = float16_t(max(float(_392), 0.07999999821186065673828125));
	                            vec3 _1869 = vec3(_395);
	                            vec3 _804 = vec3(0.0);
	                            vec3 _805 = vec3(0.0);
	                            float _1870 = _1869.z;
	                            if (_1870 >= 0.0)
	                            {
	                                _803 = 1.0;
	                            }
	                            else
	                            {
	                                _803 = -1.0;
	                            }
	                            float _1877 = (-1.0) / (_803 + _1870);
	                            float _1878 = _1869.x;
	                            float _1879 = _1869.y;
	                            float _1881 = (_1878 * _1879) * _1877;
	                            vec3 _1886 = _804;
	                            _1886.x = 1.0 + (((_803 * _1878) * _1878) * _1877);
	                            _1886.y = _803 * _1881;
	                            _1886.z = (-_803) * _1878;
	                            _804 = _1886;
	                            vec3 _1893 = _805;
	                            _1893.x = _1881;
	                            _1893.y = _803 + ((_1879 * _1879) * _1877);
	                            _1893.z = -_1879;
	                            _805 = _1893;
	                            _551 = _1886;
	                            _550 = _1893;
	                            vec3 _1905 = transpose(mat3(_1886, _1893, vec3(_439))) * (-_507);
	                            _547 = _1905;
	                            vec3 _1913 = vec3(mix(f16vec3(_434), _437, f16vec3(_438)));
	                            _549 = dot((_1913 + ((vec3(1.0) - _1913) * pow(max(0.0, 1.0 - _1905.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if ((_433 & 65535u) == 1u)
	                            {
	                                float _1932 = dot(vec3(_432.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                _548 = _1932 / max(9.9999997473787516355514526367188e-05, _1932 + dot(vec3(_437).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                            }
	                            f16vec3 _367 = _439;
	                            float16_t _366 = _438;
	                            f16vec3 _365 = _437;
	                            float16_t _364 = _436;
	                            f16vec3 _363 = _435;
	                            float16_t _362 = _434;
	                            uint _361 = _433;
	                            f16vec4 _360 = _432;
	                            vec3 _431 = _551;
	                            vec3 _430 = _550;
	                            float _429 = _549;
	                            float _428 = _548;
	                            vec3 _427 = _547;
	                            if (true)
	                            {
	                                if ((_541 & 256) != 0)
	                                {
	                                    _363 *= float16_t(_545);
	                                }
	                                else
	                                {
	                                    _363 = f16vec3(vec3(0.0));
	                                }
	                            }
	                            if (true)
	                            {
	                                _806 = any(notEqual(_506, vec3(3.4028234663852885981170418348452e+38)));
	                            }
	                            else
	                            {
	                                _806 = false;
	                            }
	                            vec3 _1973 = _506 - _544;
	                            float _1974 = length(_1973);
	                            vec3 _554 = _544;
	                            float _553 = 0.0;
	                            vec3 _552 = vec4(_1973 / vec3(_1974), _1974).xyz;
	                            if (_806)
	                            {
	                                _802 = _1974;
	                            }
	                            else
	                            {
	                                _802 = 0.0;
	                            }
	                            p_1 = PayloadShadow_t(1.0);
	                            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _554, _553, _552, _802, 1);
	                            if (_806)
	                            {
	                                _802 = p_1.m_flVisibility;
	                            }
	                            else
	                            {
	                                _802 = 0.0;
	                            }
	                            if (_802 == 1.0)
	                            {
	                                _544 = _506;
	                                _542 = vec3(_395);
	                            }
	                            _517 = _544;
	                            _516 = _543;
	                            _515 = _542;
	                            _514 = _541;
	                            _344 = _367;
	                            _343 = _366;
	                            _342 = _365;
	                            _341 = _364;
	                            _340 = _363;
	                            _339 = _362;
	                            _338 = _361;
	                            _337 = _360;
	                            _408 = _431;
	                            _407 = _430;
	                            _406 = _429;
	                            _405 = _428;
	                            _404 = _427;
	                        }
	                        else
	                        {
	                            break;
	                        }
	                    }
	                }
	                vec3 _503 = _517;
	                vec3 _502 = _516;
	                vec3 _501 = _515;
	                f16vec3 _336 = _344;
	                float16_t _335 = _343;
	                f16vec3 _334 = _342;
	                float16_t _333 = _341;
	                float16_t _332 = _339;
	                uint _331 = _338;
	                f16vec4 _330 = _337;
	                vec3 _387 = _408;
	                vec3 _386 = _407;
	                vec3 _385 = _404;
	                vec3 _2037 = (_517 + _516) * 0.5;
	                bool _2038 = _819 != 0;
	                f16vec4 _556 = _337;
	                if ((_338 & 65535u) == 1u)
	                {
	                    _797 = any(greaterThan(vec3(_556.xyz), vec3(0.0)));
	                }
	                else
	                {
	                    _797 = false;
	                }
	                if (_797)
	                {
	                    _798 = true;
	                }
	                else
	                {
	                    f16vec4 _555 = _330;
	                    if ((_331 & 65535u) == 2u)
	                    {
	                        _796 = float(_555.x) > 0.0;
	                    }
	                    else
	                    {
	                        _796 = false;
	                    }
	                    _798 = _796;
	                }
	                vec2 _2076 = imageLoad(g_RandomSamples, ivec3(_464.xy, int(1u + ((2u * _463) + uint(_819))))).xy;
	                bool _799 = false;
	                vec3 _2089 = (_503 + _502) * 0.5;
	                uvec3 _2097 = min(uvec3(max(fma(_2089, _459, _460), vec3(0.0))), (_461 - uvec3(1u)));
	                uint _791 = 0u;
	                vec3 _792 = vec3(0.0);
	                for (;;)
	                {
	                    if (!(_791 < _462))
	                    {
	                        break;
	                    }
	                    uint _2113 = _462 * _461.x;
	                    uint _793 = subgroupOr(g_LightBins_1._member0[((((_2113 * _461.y) * _2097.z) + (_2113 * _2097.y)) + (_462 * _2097.x)) + _791]);
	                    vec3 _794 = _792;
	                    for (;;)
	                    {
	                        if (!(_793 != 0u))
	                        {
	                            break;
	                        }
	                        uint _2137 = _793;
	                        uint _2141 = uint(findLSB(_2137)) + (_791 * 32u);
	                        uint _2143 = _2137 & (_2137 - 1u);
	                        if ((uint(g_Lights_1._member0[_2141].m_nPathTraceFlags) & 1u) == 0u)
	                        {
	                            _793 = _2143;
	                            continue;
	                        }
	                        if ((g_Lights_1._member0[_2141].m_nPathTraceFlags & 8) != 0)
	                        {
	                            _799 = true;
	                            _793 = _2143;
	                            continue;
	                        }
	                        do
	                        {
	                            do
	                            {
	                                vec4 _2169 = g_Lights_1._member0[_2141].m_mToClipSpace * vec4(_2089.xyz, 1.0);
	                                vec3 _2173 = _2169.xyz / vec3(_2169.w);
	                                vec4 _2175;
	                                _2175.x = _2173.x;
	                                _2175.y = _2173.y;
	                                _2175.z = _2173.z;
	                                if (all(greaterThanEqual(_2175.xyz, vec3(-1.0, -1.0, 0.0))))
	                                {
	                                    _788 = all(lessThanEqual(_2175.xyz, vec3(1.0)));
	                                }
	                                else
	                                {
	                                    _788 = false;
	                                }
	                                if (!_788)
	                                {
	                                    _789 = false;
	                                    break;
	                                }
	                                if (!all(lessThanEqual(abs((g_Lights_1._member0[_2141].m_mBarnIlluminationFromWorld * vec4(_2089, 1.0)).xyz), vec3(1.0))))
	                                {
	                                    _789 = false;
	                                    break;
	                                }
	                                _789 = true;
	                                break;
	                            } while(false);
	                            if (!_789)
	                            {
	                                _790 = vec3(0.0);
	                                break;
	                            }
	                            vec4 _2212 = g_Lights_1._member0[_2141].m_mToClipSpace * vec4(_2089.xyz, 1.0);
	                            vec3 _2216 = _2212.xyz / vec3(_2212.w);
	                            vec4 _2218;
	                            _2218.x = _2216.x;
	                            _2218.y = _2216.y;
	                            _2218.z = _2216.z;
	                            if (_2038)
	                            {
	                                _787 = g_Lights_1._member0[_2141].m_vBounceColor.xyz;
	                            }
	                            else
	                            {
	                                _787 = g_Lights_1._member0[_2141].m_vColor.xyz;
	                            }
	                            if (true)
	                            {
	                                if (g_Lights_1._member0[_2141].m_nCookie >= 0)
	                                {
	                                    if (g_Lights_1._member0[_2141].m_bSphericalCookie != 0)
	                                    {
	                                        vec4 _2278 = vec4(-g_Lights_1._member0[_2141].m_vOrientation.xyz, g_Lights_1._member0[_2141].m_vOrientation.w);
	                                        vec4 _2280 = _2278.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                        vec3 _2283 = _2280.xyz;
	                                        vec3 _2284 = vec4((-normalize(g_Lights_1._member0[_2141].m_vLightPosition.xyz - _2089)).xyz, 0.0).xyz;
	                                        vec4 _2291 = vec4((_2284 * _2280.w) + cross(_2284, _2283), -dot(_2284, _2283));
	                                        vec3 _2292 = _2291.xyz;
	                                        float _2293 = _2278.w;
	                                        vec3 _2295 = _2278.xyz;
	                                        float _2296 = _2291.w;
	                                        vec3 _2304 = vec4(((_2292 * _2293) + (_2295 * _2296)) + cross(_2295, _2292), _311).xyz;
	                                        vec2 _2313 = vec2(atan(_2304.y, -_2304.x) * 0.15915493667125701904296875, acos(_2304.z) * 0.3183098733425140380859375);
	                                        vec2 _2320 = (_2313.xy * g_Lights_1._member0[_2141].m_vCookieParameters.zw) + g_Lights_1._member0[_2141].m_vCookieParameters.xy;
	                                        vec2 _2322 = _2313;
	                                        _2322.x = _2320.x;
	                                        _2322.y = _2320.y;
	                                        _786 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_2141].m_nCookie], g_Sampler), _2322, 0.0).xyz;
	                                    }
	                                    else
	                                    {
	                                        vec2 _2249 = fma(_2218.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                        vec2 _2256 = (_2249.xy * g_Lights_1._member0[_2141].m_vCookieParameters.zw) + g_Lights_1._member0[_2141].m_vCookieParameters.xy;
	                                        vec2 _2258 = _2249;
	                                        _2258.x = _2256.x;
	                                        _2258.y = _2256.y;
	                                        _786 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_2141].m_nCookie], g_CookieSampler), _2258, 0.0).xyz;
	                                    }
	                                }
	                                else
	                                {
	                                    _786 = vec3(1.0);
	                                }
	                                _787 *= _786;
	                            }
	                            if (g_Lights_1._member0[_2141].m_nLuminaireType != 0)
	                            {
	                                _787 = (_787 * g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                            }
	                            else
	                            {
	                                if (!(g_Lights_1._member0[_2141].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _2351 = g_Lights_1._member0[_2141].m_vLightPosition.xyz - _2089;
	                                    _787 *= (vec3(g_Lights_1._member0[_2141].m_vLightPosition.w) / max(vec3(dot(_2351, _2351)), vec3(g_Lights_1._member0[_2141].m_vLightPosition.w)));
	                                }
	                            }
	                            if (g_Lights_1._member0[_2141].m_vDistanceFade_vSkirt.z > 0.0)
	                            {
	                                _783 = smoothstep(0.0, 1.0, _2218.xyz.z * g_Lights_1._member0[_2141].m_vDistanceFade_vSkirt.z);
	                            }
	                            else
	                            {
	                                _783 = 1.0;
	                            }
	                            if (g_Lights_1._member0[_2141].m_vDistanceFade_vSkirt.w > 0.0)
	                            {
	                                _783 *= smoothstep(0.0, 1.0, (1.0 - _2218.xyz.z) * g_Lights_1._member0[_2141].m_vDistanceFade_vSkirt.w);
	                            }
	                            if (!(g_Lights_1._member0[_2141].m_vLightPosition.w == 0.0))
	                            {
	                                vec3 _2405 = g_Lights_1._member0[_2141].m_vLightPosition.xyz - _2089;
	                                float _2406 = length(_2405);
	                                vec3 _2408 = _2405 / vec3(_2406);
	                                float _2417 = _783 * smoothstep(0.0, 1.0, g_Lights_1._member0[_2141].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_2141].m_vDistanceFade_vSkirt.y * _2406));
	                                if (g_Lights_1._member0[_2141].m_nLuminaireType != 2)
	                                {
	                                    _785 = g_Lights_1._member0[_2141].m_nLuminaireType != 1;
	                                }
	                                else
	                                {
	                                    _785 = false;
	                                }
	                                if (_785)
	                                {
	                                    float _2436 = 2.0 * g_Lights_1._member0[_2141].m_vOrientation.x;
	                                    float _2440 = 2.0 * g_Lights_1._member0[_2141].m_vOrientation.w;
	                                    vec3 _2454 = vec3((_2436 * g_Lights_1._member0[_2141].m_vOrientation.y) - (_2440 * g_Lights_1._member0[_2141].m_vOrientation.z), (1.0 - (_2436 * g_Lights_1._member0[_2141].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_2141].m_vOrientation.z) * g_Lights_1._member0[_2141].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_2141].m_vOrientation.y) * g_Lights_1._member0[_2141].m_vOrientation.z) + (_2440 * g_Lights_1._member0[_2141].m_vOrientation.x)) * g_Lights_1._member0[_2141].m_vAngleFade.z;
	                                    vec3 _2455 = _2408 - _2454;
	                                    vec3 _2456 = _2408 + _2454;
	                                    do
	                                    {
	                                        vec3 _2459 = _2456 - _2455;
	                                        float _2461 = dot(-_2455, _2459);
	                                        if (_2461 <= 0.0)
	                                        {
	                                            _781 = _2455;
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _2466 = dot(_2459, _2459);
	                                            if (_2461 > _2466)
	                                            {
	                                                _781 = _2456;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                _781 = _2455 + (_2459 * (_2461 / _2466));
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (any(notEqual(_781, vec3(0.0))))
	                                    {
	                                        _782 = normalize(_781);
	                                    }
	                                    else
	                                    {
	                                        _782 = _781;
	                                    }
	                                    float _2490 = 2.0 * g_Lights_1._member0[_2141].m_vOrientation.x;
	                                    float _2493 = 2.0 * g_Lights_1._member0[_2141].m_vOrientation.w;
	                                    _784 = _2417 * clamp(g_Lights_1._member0[_2141].m_vAngleFade.x + (g_Lights_1._member0[_2141].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_2141].m_vOrientation.y) * g_Lights_1._member0[_2141].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_2141].m_vOrientation.z) * g_Lights_1._member0[_2141].m_vOrientation.z), (_2490 * g_Lights_1._member0[_2141].m_vOrientation.y) + (_2493 * g_Lights_1._member0[_2141].m_vOrientation.z), (_2490 * g_Lights_1._member0[_2141].m_vOrientation.z) - (_2493 * g_Lights_1._member0[_2141].m_vOrientation.y)), _782)), 0.0, 1.0);
	                                }
	                                else
	                                {
	                                    _784 = _2417;
	                                }
	                            }
	                            else
	                            {
	                                _784 = _783;
	                            }
	                            if (g_Lights_1._member0[_2141].m_nCookie == (-1))
	                            {
	                                do
	                                {
	                                    vec2 _2522 = abs(_2218.xyz.xy);
	                                    if (g_Lights_1._member0[_2141].m_vCookieParameters.z == 0.0)
	                                    {
	                                        _779 = smoothstep(1.0, g_Lights_1._member0[_2141].m_vCookieParameters.x, _2522.x) * smoothstep(1.0, g_Lights_1._member0[_2141].m_vCookieParameters.y, _2522.y);
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        float _2527 = _2522.x;
	                                        float _2531 = _2522.y;
	                                        float _2538 = (-0.5) * g_Lights_1._member0[_2141].m_vCookieParameters.z;
	                                        float _2540 = (g_Lights_1._member0[_2141].m_vCookieParameters.x * g_Lights_1._member0[_2141].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_2141].m_vCookieParameters.y * _2527, 2.0 / g_Lights_1._member0[_2141].m_vCookieParameters.z) + pow(g_Lights_1._member0[_2141].m_vCookieParameters.x * _2531, 2.0 / g_Lights_1._member0[_2141].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2538);
	                                        float _2547 = pow(max(pow(_2527, 2.0 / g_Lights_1._member0[_2141].m_vCookieParameters.z) + pow(_2531, 2.0 / g_Lights_1._member0[_2141].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2538);
	                                        if (_2540 < _2547)
	                                        {
	                                            _779 = smoothstep(_2547, _2540, 1.0);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            if (_2547 > 1.0)
	                                            {
	                                                _780 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _780 = 0.0;
	                                            }
	                                            _779 = _780;
	                                            break;
	                                        }
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _784 *= _779;
	                            }
	                            _790 = _787 * _784;
	                            break;
	                        } while(false);
	                        SPIRV_CROSS_BRANCH
	                        if (any(greaterThan(_790, vec3(0.0))))
	                        {
	                            _777 = false;
	                            do
	                            {
	                                switch (g_Lights_1._member0[_2141].m_nLuminaireType)
	                                {
	                                    case 0:
	                                    {
	                                        _795 = 1.0;
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2141].m_vLightPosition.w == 0.0)
	                                            {
	                                                _752 = vec4(normalize(g_Lights_1._member0[_2141].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3095 = g_Lights_1._member0[_2141].m_vLightPosition.xyz - _2089;
	                                                float _3096 = length(_3095);
	                                                _752 = vec4(_3095 / vec3(_3096), _3096);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _777 = true;
	                                        _778 = _752;
	                                        break;
	                                    }
	                                    case 1:
	                                    {
	                                        vec3 _2935 = g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].xyz;
	                                        vec3 _2939 = g_Lights_1._member0[_2141].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].xyz;
	                                        float _2940 = length(_2935);
	                                        float _2941 = length(_2939);
	                                        vec3 _2943 = _2935 / vec3(_2940);
	                                        vec3 _2945 = _2939 / vec3(_2941);
	                                        vec3 _2946 = cross(_2943, _2945);
	                                        vec3 _2947 = g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].xyz - _2089;
	                                        float _2948 = dot(_2947, _2946);
	                                        if (_2948 > 0.0)
	                                        {
	                                            _754 = _2948 * (-1.0);
	                                            _755 = _2946 * (-1.0);
	                                        }
	                                        else
	                                        {
	                                            _754 = _2948;
	                                            _755 = _2946;
	                                        }
	                                        float _2957 = dot(_2947, _2943);
	                                        float _2958 = dot(_2947, _2945);
	                                        float _2959 = _2957 + _2940;
	                                        float _2960 = _2958 + _2941;
	                                        vec3 _2963 = vec3(_2957, _2958, _754);
	                                        vec3 _2964 = vec3(_2957, _2960, _754);
	                                        vec3 _2965 = vec3(_2959, _2958, _754);
	                                        vec3 _2966 = vec3(_2959, _2960, _754);
	                                        vec3 _2968 = normalize(cross(_2963, _2965));
	                                        vec3 _2970 = normalize(cross(_2965, _2966));
	                                        vec3 _2972 = normalize(cross(_2966, _2964));
	                                        vec3 _2974 = normalize(cross(_2964, _2963));
	                                        float _2991 = _2968.z;
	                                        float _2995 = (6.283185482025146484375 - acos(clamp(-dot(_2972, _2974), -1.0, 1.0))) - acos(clamp(-dot(_2974, _2968), -1.0, 1.0));
	                                        float _2997 = (acos(clamp(-dot(_2968, _2970), -1.0, 1.0)) + acos(clamp(-dot(_2970, _2972), -1.0, 1.0))) - _2995;
	                                        if (isnan(_2997))
	                                        {
	                                            _756 = 0.0;
	                                        }
	                                        else
	                                        {
	                                            _756 = _2997;
	                                        }
	                                        float _3005 = (_2076.x * _756) + _2995;
	                                        float _3010 = ((cos(_3005) * _2991) - _2972.z) / sin(_3005);
	                                        if (_3010 > 0.0)
	                                        {
	                                            _757 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _757 = -1.0;
	                                        }
	                                        float _3019 = _757;
	                                        float _3021 = clamp((1.0 / sqrt((_3010 * _3010) + (_2991 * _2991))) * _3019, -1.0, 1.0);
	                                        float _3029 = clamp((-(_3021 * _754)) / sqrt(1.0 - (_3021 * _3021)), _2957, _2959);
	                                        float _3032 = sqrt((_3029 * _3029) + (_754 * _754));
	                                        float _3033 = _3032 * _3032;
	                                        float _3036 = _2958 / sqrt(_3033 + (_2958 * _2958));
	                                        float _3043 = _3036 + (_2076.y * ((_2960 / sqrt(_3033 + (_2960 * _2960))) - _3036));
	                                        float _3044 = _3043 * _3043;
	                                        if (_3044 < 0.99999988079071044921875)
	                                        {
	                                            _757 = (_3043 * _3032) / sqrt(1.0 - _3044);
	                                        }
	                                        else
	                                        {
	                                            _757 = _2960;
	                                        }
	                                        vec3 _3061 = ((_2089 + (_2943 * _3029)) + (_2945 * _757)) + (_755 * _754);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2141].m_vLightPosition.w == 0.0)
	                                            {
	                                                _753 = vec4(normalize(_3061), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3072 = _3061 - _2089;
	                                                float _3073 = length(_3072);
	                                                _753 = vec4(_3072 / vec3(_3073), _3073);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _795 = 1.0 / _756;
	                                        _777 = true;
	                                        _778 = _753;
	                                        break;
	                                    }
	                                    case 2:
	                                    {
	                                        do
	                                        {
	                                            vec2 _2843 = (_2076 * 2.0) - vec2(1.0);
	                                            if (all(equal(_2843, vec2(0.0))))
	                                            {
	                                                _761 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _2848 = _2843.x;
	                                            float _2850 = _2843.y;
	                                            if (abs(_2848) > abs(_2850))
	                                            {
	                                                _762 = _2848;
	                                                _763 = 0.785398185253143310546875 * (_2850 / _2848);
	                                            }
	                                            else
	                                            {
	                                                _762 = _2850;
	                                                _763 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2848 / _2850));
	                                            }
	                                            _761 = vec2(cos(_763), sin(_763)) * _762;
	                                            break;
	                                        } while(false);
	                                        vec3 _2884 = (g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].xyz * _761.x)) + (g_Lights_1._member0[_2141].m_vLuminaireVectors.data[2].xyz * _761.y);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2141].m_vLightPosition.w == 0.0)
	                                            {
	                                                _760 = vec4(normalize(_2884), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2895 = _2884 - _2089;
	                                                float _2896 = length(_2895);
	                                                _760 = vec4(_2895 / vec3(_2896), _2896);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_760.w))
	                                        {
	                                            _758 = true;
	                                        }
	                                        else
	                                        {
	                                            _758 = isnan(_760.w);
	                                        }
	                                        if (!_758)
	                                        {
	                                            _759 = _760.w * _760.w;
	                                        }
	                                        else
	                                        {
	                                            _759 = 1.0;
	                                        }
	                                        _795 = _759 / (max(0.0, dot(g_Lights_1._member0[_2141].m_vLuminaireVectors.data[3].xyz, -_760.xyz)) * g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].w);
	                                        _777 = true;
	                                        _778 = _760;
	                                        break;
	                                    }
	                                    case 3:
	                                    {
	                                        vec3 _2738 = g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].xyz - _2089;
	                                        float _2739 = dot(_2738, _2738);
	                                        float _2740 = sqrt(_2739);
	                                        vec3 _2742 = _2738 / vec3(_2740);
	                                        float _2743 = _2742.z;
	                                        if (_2743 >= 0.0)
	                                        {
	                                            _765 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _765 = -1.0;
	                                        }
	                                        float _2750 = (-1.0) / (_765 + _2743);
	                                        float _2751 = _2742.x;
	                                        float _2752 = _2742.y;
	                                        float _2754 = (_2751 * _2752) * _2750;
	                                        vec3 _2759 = _766;
	                                        _2759.x = 1.0 + (((_765 * _2751) * _2751) * _2750);
	                                        _2759.y = _765 * _2754;
	                                        _2759.z = (-_765) * _2751;
	                                        _766 = _2759;
	                                        vec3 _2766 = _767;
	                                        _2766.x = _2754;
	                                        _2766.y = _765 + ((_2752 * _2752) * _2750);
	                                        _2766.z = -_2752;
	                                        _767 = _2766;
	                                        float _2774 = g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].x;
	                                        float _2778 = sqrt(max(0.0, 1.0 - (_2774 / _2739)));
	                                        float _2779 = _2076.x;
	                                        float _2782 = (1.0 - _2779) + (_2779 * _2778);
	                                        float _2786 = sqrt(max(0.0, 1.0 - (_2782 * _2782)));
	                                        float _2788 = _2076.y * 6.283185482025146484375;
	                                        float _2790 = _2740 * _2740;
	                                        float _2796 = (_2740 * _2782) - sqrt(max(0.0, _2774 - ((_2790 * _2786) * _2786)));
	                                        float _2802 = ((_2790 + _2774) - (_2796 * _2796)) / ((2.0 * _2740) * g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].x);
	                                        float _2806 = sqrt(max(0.0, 1.0 - (_2802 * _2802)));
	                                        vec3 _2818 = g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].xyz + ((mat3(-_2759, -_2766, -_2742) * vec3(cos(_2788) * _2806, sin(_2788) * _2806, _2802)) * g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].x);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2141].m_vLightPosition.w == 0.0)
	                                            {
	                                                _764 = vec4(normalize(_2818), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2829 = _2818 - _2089;
	                                                float _2830 = length(_2829);
	                                                _764 = vec4(_2829 / vec3(_2830), _2830);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _795 = 0.15915493667125701904296875 / (1.0 - _2778);
	                                        _777 = true;
	                                        _778 = _764;
	                                        break;
	                                    }
	                                    case 4:
	                                    case 5:
	                                    {
	                                        vec2 _774 = _2076;
	                                        if (_2076.x < g_Lights_1._member0[_2141].m_vLuminaireVectors.data[4].y)
	                                        {
	                                            vec2 _2629 = _774;
	                                            _2629.x = clamp(_2629.x / g_Lights_1._member0[_2141].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                            _774 = _2629;
	                                            vec3 _2635 = normalize(g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].xyz);
	                                            if (_2629.x >= 0.5)
	                                            {
	                                                vec2 _2646 = _774;
	                                                _2646.x = clamp((2.0 * _2646.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                _774 = _2646;
	                                                _775 = -_2635;
	                                                _776 = g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _2641 = _774;
	                                                _2641.x = clamp(2.0 * _2641.x, 0.0, 0.99999988079071044921875);
	                                                _774 = _2641;
	                                                _775 = _2635;
	                                                _776 = g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].xyz;
	                                            }
	                                            do
	                                            {
	                                                vec2 _2657 = (_774 * 2.0) - vec2(1.0);
	                                                if (all(equal(_2657, vec2(0.0))))
	                                                {
	                                                    _771 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _2662 = _2657.x;
	                                                float _2664 = _2657.y;
	                                                if (abs(_2662) > abs(_2664))
	                                                {
	                                                    _772 = _2662;
	                                                    _773 = 0.785398185253143310546875 * (_2664 / _2662);
	                                                }
	                                                else
	                                                {
	                                                    _772 = _2664;
	                                                    _773 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2662 / _2664));
	                                                }
	                                                _771 = vec2(cos(_773), sin(_773)) * _772;
	                                                break;
	                                            } while(false);
	                                            _776 += ((g_Lights_1._member0[_2141].m_vLuminaireVectors.data[2].xyz * _771.x) + (g_Lights_1._member0[_2141].m_vLuminaireVectors.data[3].xyz * _771.y));
	                                        }
	                                        else
	                                        {
	                                            vec2 _2608 = _774;
	                                            _2608.x = clamp((_2608.x - g_Lights_1._member0[_2141].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_2141].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                            _774 = _2608;
	                                            vec3 _2623 = (g_Lights_1._member0[_2141].m_vLuminaireVectors.data[2].xyz * cos(_2608.x * 6.283185482025146484375)) + (g_Lights_1._member0[_2141].m_vLuminaireVectors.data[3].xyz * sin(_2608.x * 6.283185482025146484375));
	                                            _775 = normalize(_2623);
	                                            _776 = mix(g_Lights_1._member0[_2141].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].xyz, vec3(_2608.y)) + _2623;
	                                        }
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2141].m_vLightPosition.w == 0.0)
	                                            {
	                                                _770 = vec4(normalize(_776), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2700 = _776 - _2089;
	                                                float _2701 = length(_2700);
	                                                _770 = vec4(_2700 / vec3(_2701), _2701);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_770.w))
	                                        {
	                                            _768 = true;
	                                        }
	                                        else
	                                        {
	                                            _768 = isnan(_770.w);
	                                        }
	                                        if (!_768)
	                                        {
	                                            _769 = _770.w * _770.w;
	                                        }
	                                        else
	                                        {
	                                            _769 = 1.0;
	                                        }
	                                        _795 = _769 / (max(0.0, dot(_775, -_770.xyz)) * g_Lights_1._member0[_2141].m_vLuminaireVectors.data[1].w);
	                                        _777 = true;
	                                        _778 = _770;
	                                        break;
	                                    }
	                                    default:
	                                    {
	                                        _795 = 0.0;
	                                        _777 = true;
	                                        _778 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                        break;
	                                    }
	                                }
	                                if (_777)
	                                {
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            bool _3113 = !(dot(_501, _778.xyz) > 0.0);
	                            vec3 _3115 = vec3(_336);
	                            vec3 _3120 = transpose(mat3(_387, _386, _3115)) * _778.xyz;
	                            float16_t _445 = _335;
	                            f16vec3 _444 = _334;
	                            float16_t _443 = _333;
	                            float16_t _442 = _332;
	                            uint _441 = _331;
	                            f16vec4 _440 = _330;
	                            vec3 _557 = _385;
	                            do
	                            {
	                                if (_3113)
	                                {
	                                    f16vec4 _558 = _440;
	                                    if ((_441 & 65535u) == 1u)
	                                    {
	                                        _747 = any(greaterThan(vec3(_558.xyz), vec3(0.0)));
	                                    }
	                                    else
	                                    {
	                                        _747 = false;
	                                    }
	                                    if (_747)
	                                    {
	                                        _751 = vec3(_440.xyz);
	                                    }
	                                    else
	                                    {
	                                        _751 = vec3(1.0);
	                                    }
	                                    _750 = _751 * 0.3183098733425140380859375;
	                                    break;
	                                }
	                                else
	                                {
	                                    vec3 _3140 = vec3(mix(f16vec3(_442), _444, f16vec3(_445)));
	                                    float _3142 = float(_443);
	                                    do
	                                    {
	                                        float _3145 = _3120.z;
	                                        vec3 _3147 = _3120 + _557;
	                                        if (_3145 <= 0.0)
	                                        {
	                                            _749 = true;
	                                        }
	                                        else
	                                        {
	                                            _749 = _557.z <= 0.0;
	                                        }
	                                        if (_749)
	                                        {
	                                            _748 = vec3(0.0);
	                                            break;
	                                        }
	                                        if (all(equal(_3147, vec3(0.0))))
	                                        {
	                                            _748 = vec3(0.0);
	                                            break;
	                                        }
	                                        vec3 _3160 = normalize(_3147);
	                                        float _3161 = _3160.z;
	                                        float _3169 = _3142 * _3142;
	                                        float _3170 = _3169 * _3169;
	                                        float _3174 = (((_3161 * _3170) - _3161) * _3161) + 1.0;
	                                        float _3178 = _3142 * _3142;
	                                        float _3179 = _3178 * _3178;
	                                        _748 = (_3140 + ((vec3(1.0) - _3140) * pow(max(0.0, 1.0 - dot(_3120, _3160)), 5.0))) * (((_3170 / max(9.9999999392252902907785028219223e-09, _3174 * _3174)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_3145 * sqrt(((_557.z - (_3179 * _557.z)) * _557.z) + _3179)) + (_557.z * sqrt(((_3145 - (_3179 * _3145)) * _3145) + _3179))))) * 0.3183098733425140380859375);
	                                        break;
	                                    } while(false);
	                                    _750 = ((vec3(_444) * (1.0 - float(_445))) * 0.3183098733425140380859375) + _748;
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            float _3231 = dot(_3115, _778.xyz);
	                            if (_3113)
	                            {
	                                _746 = -_3231;
	                            }
	                            else
	                            {
	                                _746 = _3231;
	                            }
	                            _794 += (((_790 / vec3(_795)) * (_750 * 3.1415927410125732421875)) * max(0.0, _746));
	                        }
	                        _793 = _2143;
	                        continue;
	                    }
	                    _791++;
	                    _792 = _794;
	                    continue;
	                }
	                if (_799)
	                {
	                    vec2 _737 = imageLoad(g_RandomSamples, ivec3(_464.xy, int(1u + (_463 + uint(_819))))).xy;
	                    vec3 _3255 = (_503 + _502) * 0.5;
	                    float _738 = 0.0;
	                    vec3 _563 = vec3(0.0);
	                    vec3 _562 = vec3(0.0);
	                    vec4 _561 = vec4(0.0);
	                    int _564 = -1;
	                    uvec3 _3263 = min(uvec3(max(fma(_3255, _459, _460), vec3(0.0))), (_461 - uvec3(1u)));
	                    float _739 = 0.0;
	                    uint _740 = 0u;
	                    for (;;)
	                    {
	                        if (!(_740 < _462))
	                        {
	                            break;
	                        }
	                        uint _3279 = _462 * _461.x;
	                        float _741 = _739;
	                        uint _742 = subgroupOr(g_LightBins_1._member0[((((_3279 * _461.y) * _3263.z) + (_3279 * _3263.y)) + (_462 * _3263.x)) + _740]);
	                        for (;;)
	                        {
	                            if (!(_742 != 0u))
	                            {
	                                break;
	                            }
	                            uint _3303 = _742;
	                            uint _3307 = uint(findLSB(_3303)) + (_740 * 32u);
	                            uint _3309 = _3303 & (_3303 - 1u);
	                            if ((uint(g_Lights_1._member0[_3307].m_nPathTraceFlags) & 1u) == 0u)
	                            {
	                                _742 = _3309;
	                                continue;
	                            }
	                            if (!((g_Lights_1._member0[_3307].m_nPathTraceFlags & 8) != 0))
	                            {
	                                _742 = _3309;
	                                continue;
	                            }
	                            do
	                            {
	                                do
	                                {
	                                    vec4 _3336 = g_Lights_1._member0[_3307].m_mToClipSpace * vec4(_3255.xyz, 1.0);
	                                    vec3 _3340 = _3336.xyz / vec3(_3336.w);
	                                    vec4 _3342;
	                                    _3342.x = _3340.x;
	                                    _3342.y = _3340.y;
	                                    _3342.z = _3340.z;
	                                    if (all(greaterThanEqual(_3342.xyz, vec3(-1.0, -1.0, 0.0))))
	                                    {
	                                        _734 = all(lessThanEqual(_3342.xyz, vec3(1.0)));
	                                    }
	                                    else
	                                    {
	                                        _734 = false;
	                                    }
	                                    if (!_734)
	                                    {
	                                        _735 = false;
	                                        break;
	                                    }
	                                    if (!all(lessThanEqual(abs((g_Lights_1._member0[_3307].m_mBarnIlluminationFromWorld * vec4(_3255, 1.0)).xyz), vec3(1.0))))
	                                    {
	                                        _735 = false;
	                                        break;
	                                    }
	                                    _735 = true;
	                                    break;
	                                } while(false);
	                                if (!_735)
	                                {
	                                    _736 = vec3(0.0);
	                                    break;
	                                }
	                                vec4 _3379 = g_Lights_1._member0[_3307].m_mToClipSpace * vec4(_3255.xyz, 1.0);
	                                vec3 _3383 = _3379.xyz / vec3(_3379.w);
	                                vec4 _3385;
	                                _3385.x = _3383.x;
	                                _3385.y = _3383.y;
	                                _3385.z = _3383.z;
	                                if (_2038)
	                                {
	                                    _733 = g_Lights_1._member0[_3307].m_vBounceColor.xyz;
	                                }
	                                else
	                                {
	                                    _733 = g_Lights_1._member0[_3307].m_vColor.xyz;
	                                }
	                                if (true)
	                                {
	                                    if (g_Lights_1._member0[_3307].m_nCookie >= 0)
	                                    {
	                                        if (g_Lights_1._member0[_3307].m_bSphericalCookie != 0)
	                                        {
	                                            vec4 _3445 = vec4(-g_Lights_1._member0[_3307].m_vOrientation.xyz, g_Lights_1._member0[_3307].m_vOrientation.w);
	                                            vec4 _3447 = _3445.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                            vec3 _3450 = _3447.xyz;
	                                            vec3 _3451 = vec4((-normalize(g_Lights_1._member0[_3307].m_vLightPosition.xyz - _3255)).xyz, 0.0).xyz;
	                                            vec4 _3458 = vec4((_3451 * _3447.w) + cross(_3451, _3450), -dot(_3451, _3450));
	                                            vec3 _3459 = _3458.xyz;
	                                            float _3460 = _3445.w;
	                                            vec3 _3462 = _3445.xyz;
	                                            float _3463 = _3458.w;
	                                            vec3 _3471 = vec4(((_3459 * _3460) + (_3462 * _3463)) + cross(_3462, _3459), _311).xyz;
	                                            vec2 _3480 = vec2(atan(_3471.y, -_3471.x) * 0.15915493667125701904296875, acos(_3471.z) * 0.3183098733425140380859375);
	                                            vec2 _3487 = (_3480.xy * g_Lights_1._member0[_3307].m_vCookieParameters.zw) + g_Lights_1._member0[_3307].m_vCookieParameters.xy;
	                                            vec2 _3489 = _3480;
	                                            _3489.x = _3487.x;
	                                            _3489.y = _3487.y;
	                                            _732 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_3307].m_nCookie], g_Sampler), _3489, 0.0).xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _3416 = fma(_3385.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                            vec2 _3423 = (_3416.xy * g_Lights_1._member0[_3307].m_vCookieParameters.zw) + g_Lights_1._member0[_3307].m_vCookieParameters.xy;
	                                            vec2 _3425 = _3416;
	                                            _3425.x = _3423.x;
	                                            _3425.y = _3423.y;
	                                            _732 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_3307].m_nCookie], g_CookieSampler), _3425, 0.0).xyz;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _732 = vec3(1.0);
	                                    }
	                                    _733 *= _732;
	                                }
	                                if (g_Lights_1._member0[_3307].m_nLuminaireType != 0)
	                                {
	                                    _733 = (_733 * g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                }
	                                else
	                                {
	                                    if (!(g_Lights_1._member0[_3307].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _3518 = g_Lights_1._member0[_3307].m_vLightPosition.xyz - _3255;
	                                        _733 *= (vec3(g_Lights_1._member0[_3307].m_vLightPosition.w) / max(vec3(dot(_3518, _3518)), vec3(g_Lights_1._member0[_3307].m_vLightPosition.w)));
	                                    }
	                                }
	                                if (g_Lights_1._member0[_3307].m_vDistanceFade_vSkirt.z > 0.0)
	                                {
	                                    _729 = smoothstep(0.0, 1.0, _3385.xyz.z * g_Lights_1._member0[_3307].m_vDistanceFade_vSkirt.z);
	                                }
	                                else
	                                {
	                                    _729 = 1.0;
	                                }
	                                if (g_Lights_1._member0[_3307].m_vDistanceFade_vSkirt.w > 0.0)
	                                {
	                                    _729 *= smoothstep(0.0, 1.0, (1.0 - _3385.xyz.z) * g_Lights_1._member0[_3307].m_vDistanceFade_vSkirt.w);
	                                }
	                                if (!(g_Lights_1._member0[_3307].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _3572 = g_Lights_1._member0[_3307].m_vLightPosition.xyz - _3255;
	                                    float _3573 = length(_3572);
	                                    vec3 _3575 = _3572 / vec3(_3573);
	                                    float _3584 = _729 * smoothstep(0.0, 1.0, g_Lights_1._member0[_3307].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_3307].m_vDistanceFade_vSkirt.y * _3573));
	                                    if (g_Lights_1._member0[_3307].m_nLuminaireType != 2)
	                                    {
	                                        _731 = g_Lights_1._member0[_3307].m_nLuminaireType != 1;
	                                    }
	                                    else
	                                    {
	                                        _731 = false;
	                                    }
	                                    if (_731)
	                                    {
	                                        float _3603 = 2.0 * g_Lights_1._member0[_3307].m_vOrientation.x;
	                                        float _3607 = 2.0 * g_Lights_1._member0[_3307].m_vOrientation.w;
	                                        vec3 _3621 = vec3((_3603 * g_Lights_1._member0[_3307].m_vOrientation.y) - (_3607 * g_Lights_1._member0[_3307].m_vOrientation.z), (1.0 - (_3603 * g_Lights_1._member0[_3307].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_3307].m_vOrientation.z) * g_Lights_1._member0[_3307].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_3307].m_vOrientation.y) * g_Lights_1._member0[_3307].m_vOrientation.z) + (_3607 * g_Lights_1._member0[_3307].m_vOrientation.x)) * g_Lights_1._member0[_3307].m_vAngleFade.z;
	                                        vec3 _3622 = _3575 - _3621;
	                                        vec3 _3623 = _3575 + _3621;
	                                        do
	                                        {
	                                            vec3 _3626 = _3623 - _3622;
	                                            float _3628 = dot(-_3622, _3626);
	                                            if (_3628 <= 0.0)
	                                            {
	                                                _727 = _3622;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _3633 = dot(_3626, _3626);
	                                                if (_3628 > _3633)
	                                                {
	                                                    _727 = _3623;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    _727 = _3622 + (_3626 * (_3628 / _3633));
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (any(notEqual(_727, vec3(0.0))))
	                                        {
	                                            _728 = normalize(_727);
	                                        }
	                                        else
	                                        {
	                                            _728 = _727;
	                                        }
	                                        float _3657 = 2.0 * g_Lights_1._member0[_3307].m_vOrientation.x;
	                                        float _3660 = 2.0 * g_Lights_1._member0[_3307].m_vOrientation.w;
	                                        _730 = _3584 * clamp(g_Lights_1._member0[_3307].m_vAngleFade.x + (g_Lights_1._member0[_3307].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_3307].m_vOrientation.y) * g_Lights_1._member0[_3307].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_3307].m_vOrientation.z) * g_Lights_1._member0[_3307].m_vOrientation.z), (_3657 * g_Lights_1._member0[_3307].m_vOrientation.y) + (_3660 * g_Lights_1._member0[_3307].m_vOrientation.z), (_3657 * g_Lights_1._member0[_3307].m_vOrientation.z) - (_3660 * g_Lights_1._member0[_3307].m_vOrientation.y)), _728)), 0.0, 1.0);
	                                    }
	                                    else
	                                    {
	                                        _730 = _3584;
	                                    }
	                                }
	                                else
	                                {
	                                    _730 = _729;
	                                }
	                                if (g_Lights_1._member0[_3307].m_nCookie == (-1))
	                                {
	                                    do
	                                    {
	                                        vec2 _3689 = abs(_3385.xyz.xy);
	                                        if (g_Lights_1._member0[_3307].m_vCookieParameters.z == 0.0)
	                                        {
	                                            _725 = smoothstep(1.0, g_Lights_1._member0[_3307].m_vCookieParameters.x, _3689.x) * smoothstep(1.0, g_Lights_1._member0[_3307].m_vCookieParameters.y, _3689.y);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _3694 = _3689.x;
	                                            float _3698 = _3689.y;
	                                            float _3705 = (-0.5) * g_Lights_1._member0[_3307].m_vCookieParameters.z;
	                                            float _3707 = (g_Lights_1._member0[_3307].m_vCookieParameters.x * g_Lights_1._member0[_3307].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_3307].m_vCookieParameters.y * _3694, 2.0 / g_Lights_1._member0[_3307].m_vCookieParameters.z) + pow(g_Lights_1._member0[_3307].m_vCookieParameters.x * _3698, 2.0 / g_Lights_1._member0[_3307].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3705);
	                                            float _3714 = pow(max(pow(_3694, 2.0 / g_Lights_1._member0[_3307].m_vCookieParameters.z) + pow(_3698, 2.0 / g_Lights_1._member0[_3307].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3705);
	                                            if (_3707 < _3714)
	                                            {
	                                                _725 = smoothstep(_3714, _3707, 1.0);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                if (_3714 > 1.0)
	                                                {
	                                                    _726 = 1.0;
	                                                }
	                                                else
	                                                {
	                                                    _726 = 0.0;
	                                                }
	                                                _725 = _726;
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _730 *= _725;
	                                }
	                                _736 = _733 * _730;
	                                break;
	                            } while(false);
	                            float _3737 = dot(_736.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if (_3737 == 0.0)
	                            {
	                                _742 = _3309;
	                                continue;
	                            }
	                            _723 = false;
	                            do
	                            {
	                                switch (g_Lights_1._member0[_3307].m_nLuminaireType)
	                                {
	                                    case 0:
	                                    {
	                                        _743 = 1.0;
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3307].m_vLightPosition.w == 0.0)
	                                            {
	                                                _698 = vec4(normalize(g_Lights_1._member0[_3307].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _4263 = g_Lights_1._member0[_3307].m_vLightPosition.xyz - _3255;
	                                                float _4264 = length(_4263);
	                                                _698 = vec4(_4263 / vec3(_4264), _4264);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _723 = true;
	                                        _724 = _698;
	                                        break;
	                                    }
	                                    case 1:
	                                    {
	                                        vec3 _4103 = g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].xyz;
	                                        vec3 _4107 = g_Lights_1._member0[_3307].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].xyz;
	                                        float _4108 = length(_4103);
	                                        float _4109 = length(_4107);
	                                        vec3 _4111 = _4103 / vec3(_4108);
	                                        vec3 _4113 = _4107 / vec3(_4109);
	                                        vec3 _4114 = cross(_4111, _4113);
	                                        vec3 _4115 = g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].xyz - _3255;
	                                        float _4116 = dot(_4115, _4114);
	                                        if (_4116 > 0.0)
	                                        {
	                                            _700 = _4116 * (-1.0);
	                                            _701 = _4114 * (-1.0);
	                                        }
	                                        else
	                                        {
	                                            _700 = _4116;
	                                            _701 = _4114;
	                                        }
	                                        float _4125 = dot(_4115, _4111);
	                                        float _4126 = dot(_4115, _4113);
	                                        float _4127 = _4125 + _4108;
	                                        float _4128 = _4126 + _4109;
	                                        vec3 _4131 = vec3(_4125, _4126, _700);
	                                        vec3 _4132 = vec3(_4125, _4128, _700);
	                                        vec3 _4133 = vec3(_4127, _4126, _700);
	                                        vec3 _4134 = vec3(_4127, _4128, _700);
	                                        vec3 _4136 = normalize(cross(_4131, _4133));
	                                        vec3 _4138 = normalize(cross(_4133, _4134));
	                                        vec3 _4140 = normalize(cross(_4134, _4132));
	                                        vec3 _4142 = normalize(cross(_4132, _4131));
	                                        float _4159 = _4136.z;
	                                        float _4163 = (6.283185482025146484375 - acos(clamp(-dot(_4140, _4142), -1.0, 1.0))) - acos(clamp(-dot(_4142, _4136), -1.0, 1.0));
	                                        float _4165 = (acos(clamp(-dot(_4136, _4138), -1.0, 1.0)) + acos(clamp(-dot(_4138, _4140), -1.0, 1.0))) - _4163;
	                                        if (isnan(_4165))
	                                        {
	                                            _702 = 0.0;
	                                        }
	                                        else
	                                        {
	                                            _702 = _4165;
	                                        }
	                                        float _4173 = (_2076.x * _702) + _4163;
	                                        float _4178 = ((cos(_4173) * _4159) - _4140.z) / sin(_4173);
	                                        if (_4178 > 0.0)
	                                        {
	                                            _703 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _703 = -1.0;
	                                        }
	                                        float _4187 = _703;
	                                        float _4189 = clamp((1.0 / sqrt((_4178 * _4178) + (_4159 * _4159))) * _4187, -1.0, 1.0);
	                                        float _4197 = clamp((-(_4189 * _700)) / sqrt(1.0 - (_4189 * _4189)), _4125, _4127);
	                                        float _4200 = sqrt((_4197 * _4197) + (_700 * _700));
	                                        float _4201 = _4200 * _4200;
	                                        float _4204 = _4126 / sqrt(_4201 + (_4126 * _4126));
	                                        float _4211 = _4204 + (_2076.y * ((_4128 / sqrt(_4201 + (_4128 * _4128))) - _4204));
	                                        float _4212 = _4211 * _4211;
	                                        if (_4212 < 0.99999988079071044921875)
	                                        {
	                                            _703 = (_4211 * _4200) / sqrt(1.0 - _4212);
	                                        }
	                                        else
	                                        {
	                                            _703 = _4128;
	                                        }
	                                        vec3 _4229 = ((_3255 + (_4111 * _4197)) + (_4113 * _703)) + (_701 * _700);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3307].m_vLightPosition.w == 0.0)
	                                            {
	                                                _699 = vec4(normalize(_4229), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _4240 = _4229 - _3255;
	                                                float _4241 = length(_4240);
	                                                _699 = vec4(_4240 / vec3(_4241), _4241);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _743 = 1.0 / _702;
	                                        _723 = true;
	                                        _724 = _699;
	                                        break;
	                                    }
	                                    case 2:
	                                    {
	                                        do
	                                        {
	                                            vec2 _4011 = (_2076 * 2.0) - vec2(1.0);
	                                            if (all(equal(_4011, vec2(0.0))))
	                                            {
	                                                _707 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _4016 = _4011.x;
	                                            float _4018 = _4011.y;
	                                            if (abs(_4016) > abs(_4018))
	                                            {
	                                                _708 = _4016;
	                                                _709 = 0.785398185253143310546875 * (_4018 / _4016);
	                                            }
	                                            else
	                                            {
	                                                _708 = _4018;
	                                                _709 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_4016 / _4018));
	                                            }
	                                            _707 = vec2(cos(_709), sin(_709)) * _708;
	                                            break;
	                                        } while(false);
	                                        vec3 _4052 = (g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].xyz * _707.x)) + (g_Lights_1._member0[_3307].m_vLuminaireVectors.data[2].xyz * _707.y);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3307].m_vLightPosition.w == 0.0)
	                                            {
	                                                _706 = vec4(normalize(_4052), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _4063 = _4052 - _3255;
	                                                float _4064 = length(_4063);
	                                                _706 = vec4(_4063 / vec3(_4064), _4064);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_706.w))
	                                        {
	                                            _704 = true;
	                                        }
	                                        else
	                                        {
	                                            _704 = isnan(_706.w);
	                                        }
	                                        if (!_704)
	                                        {
	                                            _705 = _706.w * _706.w;
	                                        }
	                                        else
	                                        {
	                                            _705 = 1.0;
	                                        }
	                                        _743 = _705 / (max(0.0, dot(g_Lights_1._member0[_3307].m_vLuminaireVectors.data[3].xyz, -_706.xyz)) * g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].w);
	                                        _723 = true;
	                                        _724 = _706;
	                                        break;
	                                    }
	                                    case 3:
	                                    {
	                                        vec3 _3906 = g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].xyz - _3255;
	                                        float _3907 = dot(_3906, _3906);
	                                        float _3908 = sqrt(_3907);
	                                        vec3 _3910 = _3906 / vec3(_3908);
	                                        float _3911 = _3910.z;
	                                        if (_3911 >= 0.0)
	                                        {
	                                            _711 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _711 = -1.0;
	                                        }
	                                        float _3918 = (-1.0) / (_711 + _3911);
	                                        float _3919 = _3910.x;
	                                        float _3920 = _3910.y;
	                                        float _3922 = (_3919 * _3920) * _3918;
	                                        vec3 _3927 = _712;
	                                        _3927.x = 1.0 + (((_711 * _3919) * _3919) * _3918);
	                                        _3927.y = _711 * _3922;
	                                        _3927.z = (-_711) * _3919;
	                                        _712 = _3927;
	                                        vec3 _3934 = _713;
	                                        _3934.x = _3922;
	                                        _3934.y = _711 + ((_3920 * _3920) * _3918);
	                                        _3934.z = -_3920;
	                                        _713 = _3934;
	                                        float _3942 = g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].x;
	                                        float _3946 = sqrt(max(0.0, 1.0 - (_3942 / _3907)));
	                                        float _3947 = _2076.x;
	                                        float _3950 = (1.0 - _3947) + (_3947 * _3946);
	                                        float _3954 = sqrt(max(0.0, 1.0 - (_3950 * _3950)));
	                                        float _3956 = _2076.y * 6.283185482025146484375;
	                                        float _3958 = _3908 * _3908;
	                                        float _3964 = (_3908 * _3950) - sqrt(max(0.0, _3942 - ((_3958 * _3954) * _3954)));
	                                        float _3970 = ((_3958 + _3942) - (_3964 * _3964)) / ((2.0 * _3908) * g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].x);
	                                        float _3974 = sqrt(max(0.0, 1.0 - (_3970 * _3970)));
	                                        vec3 _3986 = g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].xyz + ((mat3(-_3927, -_3934, -_3910) * vec3(cos(_3956) * _3974, sin(_3956) * _3974, _3970)) * g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].x);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3307].m_vLightPosition.w == 0.0)
	                                            {
	                                                _710 = vec4(normalize(_3986), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3997 = _3986 - _3255;
	                                                float _3998 = length(_3997);
	                                                _710 = vec4(_3997 / vec3(_3998), _3998);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _743 = 0.15915493667125701904296875 / (1.0 - _3946);
	                                        _723 = true;
	                                        _724 = _710;
	                                        break;
	                                    }
	                                    case 4:
	                                    case 5:
	                                    {
	                                        vec2 _720 = _2076;
	                                        if (_2076.x < g_Lights_1._member0[_3307].m_vLuminaireVectors.data[4].y)
	                                        {
	                                            vec2 _3797 = _720;
	                                            _3797.x = clamp(_3797.x / g_Lights_1._member0[_3307].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                            _720 = _3797;
	                                            vec3 _3803 = normalize(g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].xyz);
	                                            if (_3797.x >= 0.5)
	                                            {
	                                                vec2 _3814 = _720;
	                                                _3814.x = clamp((2.0 * _3814.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                _720 = _3814;
	                                                _721 = -_3803;
	                                                _722 = g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _3809 = _720;
	                                                _3809.x = clamp(2.0 * _3809.x, 0.0, 0.99999988079071044921875);
	                                                _720 = _3809;
	                                                _721 = _3803;
	                                                _722 = g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].xyz;
	                                            }
	                                            do
	                                            {
	                                                vec2 _3825 = (_720 * 2.0) - vec2(1.0);
	                                                if (all(equal(_3825, vec2(0.0))))
	                                                {
	                                                    _717 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _3830 = _3825.x;
	                                                float _3832 = _3825.y;
	                                                if (abs(_3830) > abs(_3832))
	                                                {
	                                                    _718 = _3830;
	                                                    _719 = 0.785398185253143310546875 * (_3832 / _3830);
	                                                }
	                                                else
	                                                {
	                                                    _718 = _3832;
	                                                    _719 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3830 / _3832));
	                                                }
	                                                _717 = vec2(cos(_719), sin(_719)) * _718;
	                                                break;
	                                            } while(false);
	                                            _722 += ((g_Lights_1._member0[_3307].m_vLuminaireVectors.data[2].xyz * _717.x) + (g_Lights_1._member0[_3307].m_vLuminaireVectors.data[3].xyz * _717.y));
	                                        }
	                                        else
	                                        {
	                                            vec2 _3776 = _720;
	                                            _3776.x = clamp((_3776.x - g_Lights_1._member0[_3307].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_3307].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                            _720 = _3776;
	                                            vec3 _3791 = (g_Lights_1._member0[_3307].m_vLuminaireVectors.data[2].xyz * cos(_3776.x * 6.283185482025146484375)) + (g_Lights_1._member0[_3307].m_vLuminaireVectors.data[3].xyz * sin(_3776.x * 6.283185482025146484375));
	                                            _721 = normalize(_3791);
	                                            _722 = mix(g_Lights_1._member0[_3307].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].xyz, vec3(_3776.y)) + _3791;
	                                        }
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3307].m_vLightPosition.w == 0.0)
	                                            {
	                                                _716 = vec4(normalize(_722), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3868 = _722 - _3255;
	                                                float _3869 = length(_3868);
	                                                _716 = vec4(_3868 / vec3(_3869), _3869);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_716.w))
	                                        {
	                                            _714 = true;
	                                        }
	                                        else
	                                        {
	                                            _714 = isnan(_716.w);
	                                        }
	                                        if (!_714)
	                                        {
	                                            _715 = _716.w * _716.w;
	                                        }
	                                        else
	                                        {
	                                            _715 = 1.0;
	                                        }
	                                        _743 = _715 / (max(0.0, dot(_721, -_716.xyz)) * g_Lights_1._member0[_3307].m_vLuminaireVectors.data[1].w);
	                                        _723 = true;
	                                        _724 = _716;
	                                        break;
	                                    }
	                                    default:
	                                    {
	                                        _743 = 0.0;
	                                        _723 = true;
	                                        _724 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                        break;
	                                    }
	                                }
	                                if (_723)
	                                {
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            float _4284 = dot(vec3(_336), _724.xyz);
	                            if ((!(dot(_501, _724.xyz) > 0.0)) && _798)
	                            {
	                                _697 = -_4284;
	                            }
	                            else
	                            {
	                                _697 = _4284;
	                            }
	                            float _4291 = (_3737 / _743) * max(0.0, _697);
	                            float _744 = _737.x;
	                            do
	                            {
	                                float _4296 = _738;
	                                float _4297 = _4296 + _4291;
	                                _738 = _4297;
	                                if (_4297 == 0.0)
	                                {
	                                    _695 = false;
	                                    break;
	                                }
	                                float _4302 = _4291 / _738;
	                                do
	                                {
	                                    if (_4302 <= 0.0)
	                                    {
	                                        _696 = false;
	                                        break;
	                                    }
	                                    if (_4302 >= 1.0)
	                                    {
	                                        _696 = true;
	                                        break;
	                                    }
	                                    if (_744 < _4302)
	                                    {
	                                        _744 = min(_744 / _4302, 0.99999988079071044921875);
	                                        _696 = true;
	                                        break;
	                                    }
	                                    _744 = min((_744 - _4302) / (1.0 - _4302), 0.99999988079071044921875);
	                                    _696 = false;
	                                    break;
	                                } while(false);
	                                _695 = _696;
	                                break;
	                            } while(false);
	                            vec2 _4327 = _737;
	                            _4327.x = _744;
	                            _737 = _4327;
	                            if (_695)
	                            {
	                                _564 = int(_3307);
	                                _563 = _736 / vec3(_743);
	                                _561 = _724;
	                                _741 = _4291;
	                            }
	                            _742 = _3309;
	                            continue;
	                        }
	                        _739 = _741;
	                        _740++;
	                        continue;
	                    }
	                    if (_564 != (-1))
	                    {
	                        vec3 _4347 = _563;
	                        vec3 _4348 = _4347 * (_738 / _739);
	                        bool _4357 = !(dot(_501, _561.xyz) > 0.0);
	                        vec3 _4360 = vec3(_336);
	                        vec3 _4365 = transpose(mat3(_387, _386, _4360)) * _561.xyz;
	                        float16_t _452 = _335;
	                        f16vec3 _451 = _334;
	                        float16_t _450 = _333;
	                        float16_t _449 = _332;
	                        uint _448 = _331;
	                        f16vec4 _447 = _330;
	                        vec3 _560 = _385;
	                        do
	                        {
	                            if (_4357)
	                            {
	                                f16vec4 _565 = _447;
	                                if ((_448 & 65535u) == 1u)
	                                {
	                                    _690 = any(greaterThan(vec3(_565.xyz), vec3(0.0)));
	                                }
	                                else
	                                {
	                                    _690 = false;
	                                }
	                                if (_690)
	                                {
	                                    _694 = vec3(_447.xyz);
	                                }
	                                else
	                                {
	                                    _694 = vec3(1.0);
	                                }
	                                _693 = _694 * 0.3183098733425140380859375;
	                                break;
	                            }
	                            else
	                            {
	                                vec3 _4384 = vec3(mix(f16vec3(_449), _451, f16vec3(_452)));
	                                float _4386 = float(_450);
	                                do
	                                {
	                                    float _4389 = _4365.z;
	                                    vec3 _4391 = _4365 + _560;
	                                    if (_4389 <= 0.0)
	                                    {
	                                        _692 = true;
	                                    }
	                                    else
	                                    {
	                                        _692 = _560.z <= 0.0;
	                                    }
	                                    if (_692)
	                                    {
	                                        _691 = vec3(0.0);
	                                        break;
	                                    }
	                                    if (all(equal(_4391, vec3(0.0))))
	                                    {
	                                        _691 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec3 _4404 = normalize(_4391);
	                                    float _4405 = _4404.z;
	                                    float _4413 = _4386 * _4386;
	                                    float _4414 = _4413 * _4413;
	                                    float _4418 = (((_4405 * _4414) - _4405) * _4405) + 1.0;
	                                    float _4422 = _4386 * _4386;
	                                    float _4423 = _4422 * _4422;
	                                    _691 = (_4384 + ((vec3(1.0) - _4384) * pow(max(0.0, 1.0 - dot(_4365, _4404)), 5.0))) * (((_4414 / max(9.9999999392252902907785028219223e-09, _4418 * _4418)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_4389 * sqrt(((_560.z - (_4423 * _560.z)) * _560.z) + _4423)) + (_560.z * sqrt(((_4389 - (_4423 * _4389)) * _4389) + _4423))))) * 0.3183098733425140380859375);
	                                    break;
	                                } while(false);
	                                _693 = ((vec3(_451) * (1.0 - float(_452))) * 0.3183098733425140380859375) + _691;
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        float _4477 = dot(_4360, _561.xyz);
	                        if (_4357)
	                        {
	                            _689 = -_4477;
	                        }
	                        else
	                        {
	                            _689 = _4477;
	                        }
	                        _563 = (_4348 * (_693 * 3.1415927410125732421875)) * max(0.0, _689);
	                        if (_4357)
	                        {
	                            f16vec4 _559 = _330;
	                            if ((_331 & 65535u) == 2u)
	                            {
	                                _688 = float(_559.x) > 0.0;
	                            }
	                            else
	                            {
	                                _688 = false;
	                            }
	                            _745 = _688;
	                        }
	                        else
	                        {
	                            _745 = false;
	                        }
	                        if (_745)
	                        {
	                            f16vec4 _446 = _330;
	                            uint _4508 = uint(_330.w);
	                            float _4513 = pow(clamp(-dot(normalize(_501 + _4360), _561.xyz), 0.0, 1.0), 2.0);
	                            f16vec3 _4514 = f16vec3(vec3(0.0));
	                            if (isinf(_561.w))
	                            {
	                                _684 = true;
	                            }
	                            else
	                            {
	                                _684 = isnan(_561.w);
	                            }
	                            if (!_684)
	                            {
	                                _685 = _561.w;
	                            }
	                            else
	                            {
	                                _685 = 1000.0;
	                            }
	                            vec3 _569 = _503 + (_561.xyz * _685);
	                            float _568 = 0.0;
	                            vec3 _567 = -_561.xyz;
	                            if (_4513 > 0.0)
	                            {
	                                _686 = _685;
	                            }
	                            else
	                            {
	                                _686 = 0.0;
	                            }
	                            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _570, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_4514, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4514, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                            traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _569, _568, _567, _686, 0);
	                            if (p.nInstance != (-1))
	                            {
	                                f16vec4 _566 = p.material.vMaterialBits;
	                                if ((p.material.nMaterialTypeAndFlags & 65535u) == 2u)
	                                {
	                                    _683 = float(_566.x) > 0.0;
	                                }
	                                else
	                                {
	                                    _683 = false;
	                                }
	                                if (!_683)
	                                {
	                                    _686 = 0.0;
	                                }
	                                else
	                                {
	                                    _686 = _4513;
	                                }
	                                _687 = _685 - p.flHitT;
	                            }
	                            else
	                            {
	                                _686 = _4513;
	                                _687 = _685;
	                            }
	                            float _4576 = _687 * float(_446.x);
	                            _562 = (_4348 * vec3(_334)) * ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4508].m_vTransmissiveLogColor.xyz * (1.0 + (_4576 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4508].m_fTransmissiveSaturation))) * exp(-_4576)) * _686);
	                        }
	                    }
	                    vec4 _801 = _561;
	                    if (_564 != (-1))
	                    {
	                        bool _4604 = any(notEqual(_563, vec3(0.0)));
	                        if (isinf(_801.w))
	                        {
	                            _681 = true;
	                        }
	                        else
	                        {
	                            _681 = isnan(_801.w);
	                        }
	                        if (!_681)
	                        {
	                            _682 = _801.w;
	                        }
	                        else
	                        {
	                            _682 = 56755.83984375;
	                        }
	                        vec4 _4621 = _801;
	                        _4621.w = _682;
	                        _801 = _4621;
	                        do
	                        {
	                            float _4630 = dot(_4621.xyz, g_Lights_1._member0[_564].m_vNearPlane.xyz);
	                            if (_4630 == 0.0)
	                            {
	                                _680 = 0.0;
	                                break;
	                            }
	                            _680 = (g_Lights_1._member0[_564].m_vNearPlane.w - dot(_2037, g_Lights_1._member0[_564].m_vNearPlane.xyz)) * (1.0 / _4630);
	                            break;
	                        } while(false);
	                        if (_680 > 0.0)
	                        {
	                            vec4 _4642 = _801;
	                            _4642.w = min(_4642.w, _680);
	                            _801 = _4642;
	                        }
	                        if (dot(_801.xyz, _501.xyz) < 0.0)
	                        {
	                            _800 = _516;
	                        }
	                        else
	                        {
	                            _800 = _517;
	                        }
	                        vec4 _4655 = _801;
	                        vec3 _4657 = _800 - _2037;
	                        _4655.w = _4655.w + dot(_4655.xyz, _4657);
	                        vec3 _4667 = normalize((_4655.xyz * _4655.w) + _4657);
	                        vec4 _4669 = _4655;
	                        _4669.x = _4667.x;
	                        _4669.y = _4667.y;
	                        _4669.z = _4667.z;
	                        _801 = _4669;
	                        do
	                        {
	                            SceneGlobalInfoGPU_t_natural_logical _4679;
	                            _4679.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	                            _4679.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	                            _4679.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	                            _4679.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	                            _4679.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	                            _4679.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	                            _4679.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	                            _4679.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	                            _4679.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	                            _4679.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	                            if ((_4679.m_vBrdfLUTs.z & 1) != 0)
	                            {
	                                _679 = 32u;
	                                break;
	                            }
	                            if ((_4679.m_vBrdfLUTs.z & 2) != 0)
	                            {
	                                _679 = 16u;
	                                break;
	                            }
	                            _679 = 0u;
	                            break;
	                        } while(false);
	                        vec3 _573 = _800;
	                        float _572 = 0.0;
	                        vec3 _571 = _4669.xyz;
	                        if (_4604)
	                        {
	                            _678 = _4669.w;
	                        }
	                        else
	                        {
	                            _678 = 0.0;
	                        }
	                        p_1 = PayloadShadow_t(1.0);
	                        traceRayEXT(g_AccelStruct, _679, 2u, 1u, 2u, 1u, _573, _572, _571, _678, 1);
	                        if (_4604)
	                        {
	                            _678 = p_1.m_flVisibility;
	                        }
	                        else
	                        {
	                            _678 = 0.0;
	                        }
	                        _800 = (_792 + _562) + (_563 * _678);
	                    }
	                    else
	                    {
	                        _800 = _792;
	                    }
	                }
	                else
	                {
	                    _800 = _792;
	                }
	                _523 = _517;
	                _522 = _516;
	                _521 = _515;
	                _520 = _514;
	                _351 = _344;
	                _350 = _343;
	                _349 = _342;
	                _348 = _341;
	                _347 = _339;
	                _346 = _338;
	                _345 = _337;
	                _413 = _408;
	                _412 = _407;
	                _411 = _406;
	                _410 = _405;
	                _409 = _404;
	                vec3 _4739 = vec3(_342);
	                float _4745 = min(0.89999997615814208984375, max(_4739.x, max(_4739.y, _4739.z)));
	                float _825 = _824.x;
	                do
	                {
	                    if (_4745 <= 0.0)
	                    {
	                        _677 = false;
	                        break;
	                    }
	                    if (_4745 >= 1.0)
	                    {
	                        _677 = true;
	                        break;
	                    }
	                    if (_825 < _4745)
	                    {
	                        _825 = min(_825 / _4745, 0.99999988079071044921875);
	                        _677 = true;
	                        break;
	                    }
	                    _825 = min((_825 - _4745) / (1.0 - _4745), 0.99999988079071044921875);
	                    _677 = false;
	                    break;
	                } while(false);
	                vec2 _4770 = _824;
	                _4770.x = _825;
	                _824 = _4770;
	                if (_677)
	                {
	                    float _500 = _410;
	                    do
	                    {
	                        _826 = 1.0;
	                        do
	                        {
	                            if (_500 <= 0.0)
	                            {
	                                _676 = false;
	                                break;
	                            }
	                            if (_500 >= 1.0)
	                            {
	                                _676 = true;
	                                break;
	                            }
	                            if (_824.x < _500)
	                            {
	                                vec2 _4793 = _824;
	                                _4793.x = min(_4793.x / _500, 0.99999988079071044921875);
	                                _824 = _4793;
	                                _676 = true;
	                                break;
	                            }
	                            vec2 _4798 = _824;
	                            _4798.x = min((_4798.x - _500) / (1.0 - _500), 0.99999988079071044921875);
	                            _824 = _4798;
	                            _676 = false;
	                            break;
	                        } while(false);
	                        if (_676)
	                        {
	                            _826 = _500;
	                            _675 = true;
	                            break;
	                        }
	                        else
	                        {
	                            _826 = 1.0 - _500;
	                            _675 = false;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    if (_675)
	                    {
	                        _523 = _522;
	                    }
	                    f16vec3 _384 = _351;
	                    float16_t _383 = _350;
	                    f16vec3 _382 = _349;
	                    float16_t _381 = _348;
	                    float16_t _380 = _347;
	                    uint _379 = _346;
	                    f16vec4 _378 = _345;
	                    vec3 _499 = _413;
	                    vec3 _498 = _412;
	                    float _497 = _411;
	                    vec3 _496 = _409;
	                    do
	                    {
	                        vec2 _673 = _824;
	                        if (_675)
	                        {
	                            float _4909 = sqrt(_673.y);
	                            float _4911 = 6.283185482025146484375 * _673.x;
	                            vec3 _4919 = vec3(cos(_4911) * _4909, sin(_4911) * _4909, sqrt(max(0.0, 1.0 - _673.y)));
	                            _4919.z = -_4919.z;
	                            _672 = _4919;
	                            break;
	                        }
	                        else
	                        {
	                            float _674 = _673.x;
	                            do
	                            {
	                                if (_497 <= 0.0)
	                                {
	                                    _671 = false;
	                                    break;
	                                }
	                                if (_497 >= 1.0)
	                                {
	                                    _671 = true;
	                                    break;
	                                }
	                                if (_674 < _497)
	                                {
	                                    _674 = min(_674 / _497, 0.99999988079071044921875);
	                                    _671 = true;
	                                    break;
	                                }
	                                _674 = min((_674 - _497) / (1.0 - _497), 0.99999988079071044921875);
	                                _671 = false;
	                                break;
	                            } while(false);
	                            vec2 _4857 = _673;
	                            _4857.x = _674;
	                            _673 = _4857;
	                            if (_671)
	                            {
	                                float _4862 = float(_381);
	                                float _4870 = ((_4862 * _4862) * sqrt(_673.x)) / sqrt(1.0 - _673.x);
	                                float _4873 = 1.0 / (1.0 + (_4870 * _4870));
	                                float _4876 = sqrt(max(0.0, 1.0 - _4873));
	                                float _4879 = 6.283185482025146484375 * _673.y;
	                                vec3 _4884 = vec3(cos(_4879) * _4876, sin(_4879) * _4876, sqrt(_4873));
	                                if (dot(_496, _4884) > 0.0)
	                                {
	                                    _670 = _4884;
	                                }
	                                else
	                                {
	                                    _670 = -_4884;
	                                }
	                                _672 = -reflect(_496, _670);
	                                break;
	                            }
	                            float _4896 = sqrt(_673.y);
	                            float _4898 = 6.283185482025146484375 * _673.x;
	                            _672 = vec3(cos(_4898) * _4896, sin(_4898) * _4896, sqrt(max(0.0, 1.0 - _673.y)));
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    _818 = _672;
	                    vec3 _4926 = normalize(_672 + _496);
	                    float _4927 = _4926.z;
	                    if (_675)
	                    {
	                        _668 = _672.z * (-0.3183098733425140380859375);
	                    }
	                    else
	                    {
	                        if (_497 > 0.0)
	                        {
	                            float _4940 = float(_381);
	                            float _4941 = _4940 * _4940;
	                            float _4942 = _4941 * _4941;
	                            float _4946 = (((_4927 * _4942) - _4927) * _4927) + 1.0;
	                            _667 = 1.0 - _497;
	                            _668 = _497 * (((_4942 / max(9.9999999392252902907785028219223e-09, _4946 * _4946)) * _4927) / (12.56637096405029296875 * max(0.0, dot(_496, _4926))));
	                        }
	                        else
	                        {
	                            _667 = 1.0;
	                            _668 = 0.0;
	                        }
	                        _668 += (_667 * (_672.z * 0.3183098733425140380859375));
	                    }
	                    if (_668 == 0.0)
	                    {
	                        _669 = true;
	                    }
	                    else
	                    {
	                        _669 = isnan(_668);
	                    }
	                    if (_669)
	                    {
	                        _667 = 3.4028234663852885981170418348452e+38;
	                    }
	                    else
	                    {
	                        _667 = _668;
	                    }
	                    float _827 = _667;
	                    do
	                    {
	                        if (_675)
	                        {
	                            f16vec4 _574 = _378;
	                            if ((_379 & 65535u) == 1u)
	                            {
	                                _662 = any(greaterThan(vec3(_574.xyz), vec3(0.0)));
	                            }
	                            else
	                            {
	                                _662 = false;
	                            }
	                            if (_662)
	                            {
	                                _666 = vec3(_378.xyz);
	                            }
	                            else
	                            {
	                                _666 = vec3(1.0);
	                            }
	                            _665 = _666 * 0.3183098733425140380859375;
	                            break;
	                        }
	                        else
	                        {
	                            vec3 _4987 = vec3(mix(f16vec3(_380), _382, f16vec3(_383)));
	                            float _4989 = float(_381);
	                            do
	                            {
	                                vec3 _4994 = _818 + _496;
	                                if (_818.z <= 0.0)
	                                {
	                                    _664 = true;
	                                }
	                                else
	                                {
	                                    _664 = _496.z <= 0.0;
	                                }
	                                if (_664)
	                                {
	                                    _663 = vec3(0.0);
	                                    break;
	                                }
	                                if (all(equal(_4994, vec3(0.0))))
	                                {
	                                    _663 = vec3(0.0);
	                                    break;
	                                }
	                                vec3 _5007 = normalize(_4994);
	                                float _5008 = _5007.z;
	                                float _5016 = _4989 * _4989;
	                                float _5017 = _5016 * _5016;
	                                float _5021 = (((_5008 * _5017) - _5008) * _5008) + 1.0;
	                                float _5025 = _4989 * _4989;
	                                float _5026 = _5025 * _5025;
	                                _663 = (_4987 + ((vec3(1.0) - _4987) * pow(max(0.0, 1.0 - dot(_818, _5007)), 5.0))) * (((_5017 / max(9.9999999392252902907785028219223e-09, _5021 * _5021)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_818.z * sqrt(((_496.z - (_5026 * _496.z)) * _496.z) + _5026)) + (_496.z * sqrt(((_818.z - (_5026 * _818.z)) * _818.z) + _5026))))) * 0.3183098733425140380859375);
	                                break;
	                            } while(false);
	                            _665 = ((vec3(_382) * (1.0 - float(_383))) * 0.3183098733425140380859375) + _663;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _5076 = _818;
	                    vec3 _5082 = mat3(_499, _498, vec3(_384)) * _5076;
	                    _818 = _5082;
	                    float _5085 = dot(vec3(_351), _5082);
	                    if (_675)
	                    {
	                        _661 = -_5085;
	                    }
	                    else
	                    {
	                        _661 = _5085;
	                    }
	                    do
	                    {
	                        if ((_520 & 1024) != 0)
	                        {
	                            _660 = true;
	                            break;
	                        }
	                        _660 = (dot(_521, _818) > 0.0) != _675;
	                        break;
	                    } while(false);
	                    if (_660)
	                    {
	                        _828 = (_822 * (_665 * max(0.0, _661))) / vec3((_4745 * _826) * _827);
	                    }
	                    else
	                    {
	                        _828 = vec3(0.0);
	                    }
	                    _820 = _828;
	                }
	                else
	                {
	                    _820 = vec3(0.0);
	                }
	                _819++;
	                _821 = (_821 + ((_800 * _822) * _823)) + ((vec3(_340) * _822) * _823);
	                continue;
	            }
	            vec3 _5126 = abs(_821);
	            float _5131 = max(_5126.x, max(_5126.y, _5126.z));
	            vec3 _5136 = clamp(_821 / vec3(_5131), vec3(-1.0), vec3(1.0)) * clamp(_5131, -100.0, 100.0);
	            float _5137 = dot(_1323, vec3(_329));
	            float _834;
	            vec3 _835;
	            if (_829)
	            {
	                _834 = -_5137;
	                _835 = _5136 * vTransmissiveRatio;
	            }
	            else
	            {
	                _834 = _5137;
	                _835 = _5136;
	            }
	            vec4 _5143 = _478;
	            vec3 _5150 = _5143.xyz + ((_835 * max(0.0, _834)) * 0.3183098733425140380859375);
	            vec4 _5152 = _5143;
	            _5152.x = _5150.x;
	            _5152.y = _5150.y;
	            _5152.z = _5150.z;
	            vec3 _5158 = _5152.xyz + vec3(0.0);
	            vec4 _5160 = _5152;
	            _5160.x = _5158.x;
	            _5160.y = _5158.y;
	            _5160.z = _5158.z;
	            _478 = _5160;
	            if (_834 > 0.0)
	            {
	                vec4 _836;
	                vec4 _5168 = _836;
	                _5168.x = 0.2820948064327239990234375;
	                float _5170 = _1323.y;
	                _5168.y = (-0.48860251903533935546875) * _5170;
	                float _5173 = _1323.z;
	                _5168.z = 0.48860251903533935546875 * _5173;
	                float _5176 = _1323.x;
	                _5168.w = (-0.48860251903533935546875) * _5176;
	                _836 = _5168;
	                vec4 _837;
	                vec4 _5181 = _837;
	                _5181.x = (1.09254848957061767578125 * _5176) * _5170;
	                _5181.y = ((-1.09254848957061767578125) * _5170) * _5173;
	                _5181.z = 0.3153915703296661376953125 * (((3.0 * _5173) * _5173) - 1.0);
	                _5181.w = ((-1.09254848957061767578125) * _5176) * _5173;
	                _837 = _5181;
	                _477 += (_5168 * _835.x);
	                _474 += (_5181 * _835.x);
	                _476 += (_5168 * _835.y);
	                _473 += (_5181 * _835.y);
	                _475 += (_5168 * _835.z);
	                _472 += (_5181 * _835.z);
	                vec4 _5220 = _471;
	                vec3 _5223 = _5220.xyz + (_835 * (0.546274244785308837890625 * ((_5176 * _5176) - (_5170 * _5170))));
	                vec4 _5225 = _5220;
	                _5225.x = _5223.x;
	                _5225.y = _5223.y;
	                _5225.z = _5223.z;
	                _471 = _5225;
	            }
	            vec3 _458 = _480;
	            f16vec3 _315 = _322;
	            uint _314 = _317;
	            f16vec4 _313 = _316;
	            uint _457 = _933;
	            uvec3 _456 = _934;
	            vec3 _455 = _939;
	            vec3 _454 = _937;
	            vec3 _5238 = (_482 + _481) * 0.5;
	            vec2 _5246 = imageLoad(g_RandomSamples, ivec3(_908.xy, int(1u + (2u * _909)))).xy;
	            vec2 _637 = imageLoad(g_RandomSamples, ivec3(_908.xy, int(1u + _909))).xy;
	            bool _638;
	            if (any(notEqual(vTransmissiveRatio, vec3(0.0))))
	            {
	                _638 = true;
	            }
	            else
	            {
	                _638 = false;
	            }
	            if (_638)
	            {
	                _638 = true;
	            }
	            else
	            {
	                _638 = false;
	            }
	            vec4 _639 = vec4(0.0);
	            float _640 = 0.0;
	            uvec3 _5270 = min(uvec3(max(fma(_5238, _454, _455), vec3(0.0))), (_456 - uvec3(1u)));
	            int _642 = -1;
	            float _643 = 0.0;
	            bool _641 = false;
	            uint _644 = 0u;
	            vec3 _645 = vec3(0.0);
	            bool _596;
	            bool _597;
	            vec4 _598;
	            vec4 _599;
	            float _600;
	            vec3 _601;
	            float _602;
	            float _603;
	            bool _604;
	            float _605;
	            vec4 _606;
	            vec2 _607;
	            float _608;
	            float _609;
	            vec4 _610;
	            float _611;
	            vec3 _612;
	            vec3 _613;
	            bool _614;
	            float _615;
	            vec4 _616;
	            vec2 _617;
	            float _618;
	            float _619;
	            vec3 _621;
	            vec3 _622;
	            vec4 _624;
	            float _625;
	            float _626;
	            vec3 _627;
	            vec3 _628;
	            float _629;
	            float _630;
	            bool _631;
	            vec3 _632;
	            vec3 _633;
	            bool _634;
	            bool _635;
	            vec3 _636;
	            float _646;
	            uint _647;
	            vec3 _648;
	            vec3 _649;
	            float _652;
	            float _653;
	            vec4 _654;
	            vec4 _655;
	            bool _656;
	            for (;;)
	            {
	                if (!(_644 < _457))
	                {
	                    break;
	                }
	                uint _5286 = _457 * _456.x;
	                int _651 = _642;
	                _646 = _643;
	                bool _650 = _641;
	                _647 = subgroupOr(g_LightBins_1._member0[((((_5286 * _456.y) * _5270.z) + (_5286 * _5270.y)) + (_457 * _5270.x)) + _644]);
	                _648 = _645;
	                for (;;)
	                {
	                    if (!(_647 != 0u))
	                    {
	                        break;
	                    }
	                    uint _5313 = _647;
	                    uint _5317 = uint(findLSB(_5313)) + (_644 * 32u);
	                    uint _5319 = _5313 & (_5313 - 1u);
	                    if ((g_Lights_1._member0[_5317].m_nPathTraceFlags & 2) == 0)
	                    {
	                        _647 = _5319;
	                        continue;
	                    }
	                    do
	                    {
	                        do
	                        {
	                            vec4 _5337 = g_Lights_1._member0[_5317].m_mToClipSpace * vec4(_5238.xyz, 1.0);
	                            vec3 _5341 = _5337.xyz / vec3(_5337.w);
	                            vec4 _5343;
	                            _5343.x = _5341.x;
	                            _5343.y = _5341.y;
	                            _5343.z = _5341.z;
	                            if (all(greaterThanEqual(_5343.xyz, vec3(-1.0, -1.0, 0.0))))
	                            {
	                                _634 = all(lessThanEqual(_5343.xyz, vec3(1.0)));
	                            }
	                            else
	                            {
	                                _634 = false;
	                            }
	                            if (!_634)
	                            {
	                                _635 = false;
	                                break;
	                            }
	                            if (!all(lessThanEqual(abs((g_Lights_1._member0[_5317].m_mBarnIlluminationFromWorld * vec4(_5238, 1.0)).xyz), vec3(1.0))))
	                            {
	                                _635 = false;
	                                break;
	                            }
	                            _635 = true;
	                            break;
	                        } while(false);
	                        if (!_635)
	                        {
	                            _636 = vec3(0.0);
	                            break;
	                        }
	                        vec4 _5380 = g_Lights_1._member0[_5317].m_mToClipSpace * vec4(_5238.xyz, 1.0);
	                        vec3 _5384 = _5380.xyz / vec3(_5380.w);
	                        vec4 _5386;
	                        _5386.x = _5384.x;
	                        _5386.y = _5384.y;
	                        _5386.z = _5384.z;
	                        if (false)
	                        {
	                            _633 = g_Lights_1._member0[_5317].m_vBounceColor.xyz;
	                        }
	                        else
	                        {
	                            _633 = g_Lights_1._member0[_5317].m_vColor.xyz;
	                        }
	                        if (true)
	                        {
	                            if (g_Lights_1._member0[_5317].m_nCookie >= 0)
	                            {
	                                if (g_Lights_1._member0[_5317].m_bSphericalCookie != 0)
	                                {
	                                    vec4 _5446 = vec4(-g_Lights_1._member0[_5317].m_vOrientation.xyz, g_Lights_1._member0[_5317].m_vOrientation.w);
	                                    vec4 _5448 = _5446.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                    vec3 _5451 = _5448.xyz;
	                                    vec3 _5452 = vec4((-normalize(g_Lights_1._member0[_5317].m_vLightPosition.xyz - _5238)).xyz, 0.0).xyz;
	                                    vec4 _5459 = vec4((_5452 * _5448.w) + cross(_5452, _5451), -dot(_5452, _5451));
	                                    vec3 _5460 = _5459.xyz;
	                                    float _5461 = _5446.w;
	                                    vec3 _5463 = _5446.xyz;
	                                    float _5464 = _5459.w;
	                                    vec3 _5472 = vec4(((_5460 * _5461) + (_5463 * _5464)) + cross(_5463, _5460), _311).xyz;
	                                    vec2 _5481 = vec2(atan(_5472.y, -_5472.x) * 0.15915493667125701904296875, acos(_5472.z) * 0.3183098733425140380859375);
	                                    vec2 _5488 = (_5481.xy * g_Lights_1._member0[_5317].m_vCookieParameters.zw) + g_Lights_1._member0[_5317].m_vCookieParameters.xy;
	                                    vec2 _5490 = _5481;
	                                    _5490.x = _5488.x;
	                                    _5490.y = _5488.y;
	                                    _632 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_5317].m_nCookie], g_Sampler), _5490, 0.0).xyz;
	                                }
	                                else
	                                {
	                                    vec2 _5417 = fma(_5386.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                    vec2 _5424 = (_5417.xy * g_Lights_1._member0[_5317].m_vCookieParameters.zw) + g_Lights_1._member0[_5317].m_vCookieParameters.xy;
	                                    vec2 _5426 = _5417;
	                                    _5426.x = _5424.x;
	                                    _5426.y = _5424.y;
	                                    _632 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_5317].m_nCookie], g_CookieSampler), _5426, 0.0).xyz;
	                                }
	                            }
	                            else
	                            {
	                                _632 = vec3(1.0);
	                            }
	                            _633 *= _632;
	                        }
	                        if (g_Lights_1._member0[_5317].m_nLuminaireType != 0)
	                        {
	                            _633 = (_633 * g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                        }
	                        else
	                        {
	                            if (!(g_Lights_1._member0[_5317].m_vLightPosition.w == 0.0))
	                            {
	                                vec3 _5519 = g_Lights_1._member0[_5317].m_vLightPosition.xyz - _5238;
	                                _633 *= (vec3(g_Lights_1._member0[_5317].m_vLightPosition.w) / max(vec3(dot(_5519, _5519)), vec3(g_Lights_1._member0[_5317].m_vLightPosition.w)));
	                            }
	                        }
	                        if (g_Lights_1._member0[_5317].m_vDistanceFade_vSkirt.z > 0.0)
	                        {
	                            _629 = smoothstep(0.0, 1.0, _5386.xyz.z * g_Lights_1._member0[_5317].m_vDistanceFade_vSkirt.z);
	                        }
	                        else
	                        {
	                            _629 = 1.0;
	                        }
	                        if (g_Lights_1._member0[_5317].m_vDistanceFade_vSkirt.w > 0.0)
	                        {
	                            _629 *= smoothstep(0.0, 1.0, (1.0 - _5386.xyz.z) * g_Lights_1._member0[_5317].m_vDistanceFade_vSkirt.w);
	                        }
	                        if (!(g_Lights_1._member0[_5317].m_vLightPosition.w == 0.0))
	                        {
	                            vec3 _5573 = g_Lights_1._member0[_5317].m_vLightPosition.xyz - _5238;
	                            float _5574 = length(_5573);
	                            vec3 _5576 = _5573 / vec3(_5574);
	                            float _5585 = _629 * smoothstep(0.0, 1.0, g_Lights_1._member0[_5317].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_5317].m_vDistanceFade_vSkirt.y * _5574));
	                            if (g_Lights_1._member0[_5317].m_nLuminaireType != 2)
	                            {
	                                _631 = g_Lights_1._member0[_5317].m_nLuminaireType != 1;
	                            }
	                            else
	                            {
	                                _631 = false;
	                            }
	                            if (_631)
	                            {
	                                float _5604 = 2.0 * g_Lights_1._member0[_5317].m_vOrientation.x;
	                                float _5608 = 2.0 * g_Lights_1._member0[_5317].m_vOrientation.w;
	                                vec3 _5622 = vec3((_5604 * g_Lights_1._member0[_5317].m_vOrientation.y) - (_5608 * g_Lights_1._member0[_5317].m_vOrientation.z), (1.0 - (_5604 * g_Lights_1._member0[_5317].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_5317].m_vOrientation.z) * g_Lights_1._member0[_5317].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_5317].m_vOrientation.y) * g_Lights_1._member0[_5317].m_vOrientation.z) + (_5608 * g_Lights_1._member0[_5317].m_vOrientation.x)) * g_Lights_1._member0[_5317].m_vAngleFade.z;
	                                vec3 _5623 = _5576 - _5622;
	                                vec3 _5624 = _5576 + _5622;
	                                do
	                                {
	                                    vec3 _5627 = _5624 - _5623;
	                                    float _5629 = dot(-_5623, _5627);
	                                    if (_5629 <= 0.0)
	                                    {
	                                        _627 = _5623;
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        float _5634 = dot(_5627, _5627);
	                                        if (_5629 > _5634)
	                                        {
	                                            _627 = _5624;
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            _627 = _5623 + (_5627 * (_5629 / _5634));
	                                            break;
	                                        }
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                if (any(notEqual(_627, vec3(0.0))))
	                                {
	                                    _628 = normalize(_627);
	                                }
	                                else
	                                {
	                                    _628 = _627;
	                                }
	                                float _5658 = 2.0 * g_Lights_1._member0[_5317].m_vOrientation.x;
	                                float _5661 = 2.0 * g_Lights_1._member0[_5317].m_vOrientation.w;
	                                _630 = _5585 * clamp(g_Lights_1._member0[_5317].m_vAngleFade.x + (g_Lights_1._member0[_5317].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_5317].m_vOrientation.y) * g_Lights_1._member0[_5317].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_5317].m_vOrientation.z) * g_Lights_1._member0[_5317].m_vOrientation.z), (_5658 * g_Lights_1._member0[_5317].m_vOrientation.y) + (_5661 * g_Lights_1._member0[_5317].m_vOrientation.z), (_5658 * g_Lights_1._member0[_5317].m_vOrientation.z) - (_5661 * g_Lights_1._member0[_5317].m_vOrientation.y)), _628)), 0.0, 1.0);
	                            }
	                            else
	                            {
	                                _630 = _5585;
	                            }
	                        }
	                        else
	                        {
	                            _630 = _629;
	                        }
	                        if (g_Lights_1._member0[_5317].m_nCookie == (-1))
	                        {
	                            do
	                            {
	                                vec2 _5690 = abs(_5386.xyz.xy);
	                                if (g_Lights_1._member0[_5317].m_vCookieParameters.z == 0.0)
	                                {
	                                    _625 = smoothstep(1.0, g_Lights_1._member0[_5317].m_vCookieParameters.x, _5690.x) * smoothstep(1.0, g_Lights_1._member0[_5317].m_vCookieParameters.y, _5690.y);
	                                    break;
	                                }
	                                else
	                                {
	                                    float _5695 = _5690.x;
	                                    float _5699 = _5690.y;
	                                    float _5706 = (-0.5) * g_Lights_1._member0[_5317].m_vCookieParameters.z;
	                                    float _5708 = (g_Lights_1._member0[_5317].m_vCookieParameters.x * g_Lights_1._member0[_5317].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_5317].m_vCookieParameters.y * _5695, 2.0 / g_Lights_1._member0[_5317].m_vCookieParameters.z) + pow(g_Lights_1._member0[_5317].m_vCookieParameters.x * _5699, 2.0 / g_Lights_1._member0[_5317].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _5706);
	                                    float _5715 = pow(max(pow(_5695, 2.0 / g_Lights_1._member0[_5317].m_vCookieParameters.z) + pow(_5699, 2.0 / g_Lights_1._member0[_5317].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _5706);
	                                    if (_5708 < _5715)
	                                    {
	                                        _625 = smoothstep(_5715, _5708, 1.0);
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        if (_5715 > 1.0)
	                                        {
	                                            _626 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _626 = 0.0;
	                                        }
	                                        _625 = _626;
	                                        break;
	                                    }
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            _630 *= _625;
	                        }
	                        _636 = _633 * _630;
	                        break;
	                    } while(false);
	                    if (all(equal(_636, vec3(0.0))))
	                    {
	                        _647 = _5319;
	                        continue;
	                    }
	                    _623 = false;
	                    do
	                    {
	                        switch (g_Lights_1._member0[_5317].m_nLuminaireType)
	                        {
	                            case 0:
	                            {
	                                _652 = 1.0;
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5317].m_vLightPosition.w == 0.0)
	                                    {
	                                        _598 = vec4(normalize(g_Lights_1._member0[_5317].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _6263 = g_Lights_1._member0[_5317].m_vLightPosition.xyz - _5238;
	                                        float _6264 = length(_6263);
	                                        _598 = vec4(_6263 / vec3(_6264), _6264);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _623 = true;
	                                _624 = _598;
	                                break;
	                            }
	                            case 1:
	                            {
	                                vec3 _6103 = g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].xyz;
	                                vec3 _6107 = g_Lights_1._member0[_5317].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].xyz;
	                                float _6108 = length(_6103);
	                                float _6109 = length(_6107);
	                                vec3 _6111 = _6103 / vec3(_6108);
	                                vec3 _6113 = _6107 / vec3(_6109);
	                                vec3 _6114 = cross(_6111, _6113);
	                                vec3 _6115 = g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].xyz - _5238;
	                                float _6116 = dot(_6115, _6114);
	                                if (_6116 > 0.0)
	                                {
	                                    _600 = _6116 * (-1.0);
	                                    _601 = _6114 * (-1.0);
	                                }
	                                else
	                                {
	                                    _600 = _6116;
	                                    _601 = _6114;
	                                }
	                                float _6125 = dot(_6115, _6111);
	                                float _6126 = dot(_6115, _6113);
	                                float _6127 = _6125 + _6108;
	                                float _6128 = _6126 + _6109;
	                                vec3 _6131 = vec3(_6125, _6126, _600);
	                                vec3 _6132 = vec3(_6125, _6128, _600);
	                                vec3 _6133 = vec3(_6127, _6126, _600);
	                                vec3 _6134 = vec3(_6127, _6128, _600);
	                                vec3 _6136 = normalize(cross(_6131, _6133));
	                                vec3 _6138 = normalize(cross(_6133, _6134));
	                                vec3 _6140 = normalize(cross(_6134, _6132));
	                                vec3 _6142 = normalize(cross(_6132, _6131));
	                                float _6159 = _6136.z;
	                                float _6163 = (6.283185482025146484375 - acos(clamp(-dot(_6140, _6142), -1.0, 1.0))) - acos(clamp(-dot(_6142, _6136), -1.0, 1.0));
	                                float _6165 = (acos(clamp(-dot(_6136, _6138), -1.0, 1.0)) + acos(clamp(-dot(_6138, _6140), -1.0, 1.0))) - _6163;
	                                if (isnan(_6165))
	                                {
	                                    _602 = 0.0;
	                                }
	                                else
	                                {
	                                    _602 = _6165;
	                                }
	                                float _6173 = (_5246.x * _602) + _6163;
	                                float _6178 = ((cos(_6173) * _6159) - _6140.z) / sin(_6173);
	                                if (_6178 > 0.0)
	                                {
	                                    _603 = 1.0;
	                                }
	                                else
	                                {
	                                    _603 = -1.0;
	                                }
	                                float _6187 = _603;
	                                float _6189 = clamp((1.0 / sqrt((_6178 * _6178) + (_6159 * _6159))) * _6187, -1.0, 1.0);
	                                float _6197 = clamp((-(_6189 * _600)) / sqrt(1.0 - (_6189 * _6189)), _6125, _6127);
	                                float _6200 = sqrt((_6197 * _6197) + (_600 * _600));
	                                float _6201 = _6200 * _6200;
	                                float _6204 = _6126 / sqrt(_6201 + (_6126 * _6126));
	                                float _6211 = _6204 + (_5246.y * ((_6128 / sqrt(_6201 + (_6128 * _6128))) - _6204));
	                                float _6212 = _6211 * _6211;
	                                if (_6212 < 0.99999988079071044921875)
	                                {
	                                    _603 = (_6211 * _6200) / sqrt(1.0 - _6212);
	                                }
	                                else
	                                {
	                                    _603 = _6128;
	                                }
	                                vec3 _6229 = ((_5238 + (_6111 * _6197)) + (_6113 * _603)) + (_601 * _600);
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5317].m_vLightPosition.w == 0.0)
	                                    {
	                                        _599 = vec4(normalize(_6229), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _6240 = _6229 - _5238;
	                                        float _6241 = length(_6240);
	                                        _599 = vec4(_6240 / vec3(_6241), _6241);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _652 = 1.0 / _602;
	                                _623 = true;
	                                _624 = _599;
	                                break;
	                            }
	                            case 2:
	                            {
	                                do
	                                {
	                                    vec2 _6011 = (_5246 * 2.0) - vec2(1.0);
	                                    if (all(equal(_6011, vec2(0.0))))
	                                    {
	                                        _607 = vec2(0.0);
	                                        break;
	                                    }
	                                    float _6016 = _6011.x;
	                                    float _6018 = _6011.y;
	                                    if (abs(_6016) > abs(_6018))
	                                    {
	                                        _608 = _6016;
	                                        _609 = 0.785398185253143310546875 * (_6018 / _6016);
	                                    }
	                                    else
	                                    {
	                                        _608 = _6018;
	                                        _609 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_6016 / _6018));
	                                    }
	                                    _607 = vec2(cos(_609), sin(_609)) * _608;
	                                    break;
	                                } while(false);
	                                vec3 _6052 = (g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].xyz * _607.x)) + (g_Lights_1._member0[_5317].m_vLuminaireVectors.data[2].xyz * _607.y);
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5317].m_vLightPosition.w == 0.0)
	                                    {
	                                        _606 = vec4(normalize(_6052), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _6063 = _6052 - _5238;
	                                        float _6064 = length(_6063);
	                                        _606 = vec4(_6063 / vec3(_6064), _6064);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                if (isinf(_606.w))
	                                {
	                                    _604 = true;
	                                }
	                                else
	                                {
	                                    _604 = isnan(_606.w);
	                                }
	                                if (!_604)
	                                {
	                                    _605 = _606.w * _606.w;
	                                }
	                                else
	                                {
	                                    _605 = 1.0;
	                                }
	                                _652 = _605 / (max(0.0, dot(g_Lights_1._member0[_5317].m_vLuminaireVectors.data[3].xyz, -_606.xyz)) * g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].w);
	                                _623 = true;
	                                _624 = _606;
	                                break;
	                            }
	                            case 3:
	                            {
	                                vec3 _5906 = g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].xyz - _5238;
	                                float _5907 = dot(_5906, _5906);
	                                float _5908 = sqrt(_5907);
	                                vec3 _5910 = _5906 / vec3(_5908);
	                                float _5911 = _5910.z;
	                                if (_5911 >= 0.0)
	                                {
	                                    _611 = 1.0;
	                                }
	                                else
	                                {
	                                    _611 = -1.0;
	                                }
	                                float _5918 = (-1.0) / (_611 + _5911);
	                                float _5919 = _5910.x;
	                                float _5920 = _5910.y;
	                                float _5922 = (_5919 * _5920) * _5918;
	                                vec3 _5927 = _612;
	                                _5927.x = 1.0 + (((_611 * _5919) * _5919) * _5918);
	                                _5927.y = _611 * _5922;
	                                _5927.z = (-_611) * _5919;
	                                _612 = _5927;
	                                vec3 _5934 = _613;
	                                _5934.x = _5922;
	                                _5934.y = _611 + ((_5920 * _5920) * _5918);
	                                _5934.z = -_5920;
	                                _613 = _5934;
	                                float _5942 = g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].x;
	                                float _5946 = sqrt(max(0.0, 1.0 - (_5942 / _5907)));
	                                float _5947 = _5246.x;
	                                float _5950 = (1.0 - _5947) + (_5947 * _5946);
	                                float _5954 = sqrt(max(0.0, 1.0 - (_5950 * _5950)));
	                                float _5956 = _5246.y * 6.283185482025146484375;
	                                float _5958 = _5908 * _5908;
	                                float _5964 = (_5908 * _5950) - sqrt(max(0.0, _5942 - ((_5958 * _5954) * _5954)));
	                                float _5970 = ((_5958 + _5942) - (_5964 * _5964)) / ((2.0 * _5908) * g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].x);
	                                float _5974 = sqrt(max(0.0, 1.0 - (_5970 * _5970)));
	                                vec3 _5986 = g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].xyz + ((mat3(-_5927, -_5934, -_5910) * vec3(cos(_5956) * _5974, sin(_5956) * _5974, _5970)) * g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].x);
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5317].m_vLightPosition.w == 0.0)
	                                    {
	                                        _610 = vec4(normalize(_5986), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _5997 = _5986 - _5238;
	                                        float _5998 = length(_5997);
	                                        _610 = vec4(_5997 / vec3(_5998), _5998);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _652 = 0.15915493667125701904296875 / (1.0 - _5946);
	                                _623 = true;
	                                _624 = _610;
	                                break;
	                            }
	                            case 4:
	                            case 5:
	                            {
	                                vec2 _620 = _5246;
	                                if (_5246.x < g_Lights_1._member0[_5317].m_vLuminaireVectors.data[4].y)
	                                {
	                                    vec2 _5797 = _620;
	                                    _5797.x = clamp(_5797.x / g_Lights_1._member0[_5317].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                    _620 = _5797;
	                                    vec3 _5803 = normalize(g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].xyz);
	                                    if (_5797.x >= 0.5)
	                                    {
	                                        vec2 _5814 = _620;
	                                        _5814.x = clamp((2.0 * _5814.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                        _620 = _5814;
	                                        _621 = -_5803;
	                                        _622 = g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].xyz;
	                                    }
	                                    else
	                                    {
	                                        vec2 _5809 = _620;
	                                        _5809.x = clamp(2.0 * _5809.x, 0.0, 0.99999988079071044921875);
	                                        _620 = _5809;
	                                        _621 = _5803;
	                                        _622 = g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].xyz;
	                                    }
	                                    do
	                                    {
	                                        vec2 _5825 = (_620 * 2.0) - vec2(1.0);
	                                        if (all(equal(_5825, vec2(0.0))))
	                                        {
	                                            _617 = vec2(0.0);
	                                            break;
	                                        }
	                                        float _5830 = _5825.x;
	                                        float _5832 = _5825.y;
	                                        if (abs(_5830) > abs(_5832))
	                                        {
	                                            _618 = _5830;
	                                            _619 = 0.785398185253143310546875 * (_5832 / _5830);
	                                        }
	                                        else
	                                        {
	                                            _618 = _5832;
	                                            _619 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_5830 / _5832));
	                                        }
	                                        _617 = vec2(cos(_619), sin(_619)) * _618;
	                                        break;
	                                    } while(false);
	                                    _622 += ((g_Lights_1._member0[_5317].m_vLuminaireVectors.data[2].xyz * _617.x) + (g_Lights_1._member0[_5317].m_vLuminaireVectors.data[3].xyz * _617.y));
	                                }
	                                else
	                                {
	                                    vec2 _5776 = _620;
	                                    _5776.x = clamp((_5776.x - g_Lights_1._member0[_5317].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_5317].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                    _620 = _5776;
	                                    vec3 _5791 = (g_Lights_1._member0[_5317].m_vLuminaireVectors.data[2].xyz * cos(_5776.x * 6.283185482025146484375)) + (g_Lights_1._member0[_5317].m_vLuminaireVectors.data[3].xyz * sin(_5776.x * 6.283185482025146484375));
	                                    _621 = normalize(_5791);
	                                    _622 = mix(g_Lights_1._member0[_5317].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].xyz, vec3(_5776.y)) + _5791;
	                                }
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5317].m_vLightPosition.w == 0.0)
	                                    {
	                                        _616 = vec4(normalize(_622), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _5868 = _622 - _5238;
	                                        float _5869 = length(_5868);
	                                        _616 = vec4(_5868 / vec3(_5869), _5869);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                if (isinf(_616.w))
	                                {
	                                    _614 = true;
	                                }
	                                else
	                                {
	                                    _614 = isnan(_616.w);
	                                }
	                                if (!_614)
	                                {
	                                    _615 = _616.w * _616.w;
	                                }
	                                else
	                                {
	                                    _615 = 1.0;
	                                }
	                                _652 = _615 / (max(0.0, dot(_621, -_616.xyz)) * g_Lights_1._member0[_5317].m_vLuminaireVectors.data[1].w);
	                                _623 = true;
	                                _624 = _616;
	                                break;
	                            }
	                            default:
	                            {
	                                _652 = 0.0;
	                                _623 = true;
	                                _624 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                break;
	                            }
	                        }
	                        if (_623)
	                        {
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _6276 = _636 * (3.1415927410125732421875 / _652);
	                    bool _6281 = !(dot(_458, _624.xyz) > 0.0);
	                    if (!((g_Lights_1._member0[_5317].m_nPathTraceFlags & 8) != 0))
	                    {
	                        vec3 _6292 = abs(_6276);
	                        float _6297 = max(_6292.x, max(_6292.y, _6292.z));
	                        vec3 _6302 = clamp(_6276 / vec3(_6297), vec3(-1.0), vec3(1.0)) * clamp(_6297, -100.0, 100.0);
	                        float _6303 = dot(_624.xyz, vec3(_315));
	                        if (_6281)
	                        {
	                            _653 = -_6303;
	                            _649 = _6302 * vTransmissiveRatio;
	                        }
	                        else
	                        {
	                            _653 = _6303;
	                            _649 = _6302;
	                        }
	                        vec4 _6309 = _478;
	                        vec3 _6316 = _6309.xyz + ((_649 * max(0.0, _653)) * 0.3183098733425140380859375);
	                        vec4 _6318 = _6309;
	                        _6318.x = _6316.x;
	                        _6318.y = _6316.y;
	                        _6318.z = _6316.z;
	                        vec3 _6324 = _6318.xyz + vec3(0.0);
	                        vec4 _6326 = _6318;
	                        _6326.x = _6324.x;
	                        _6326.y = _6324.y;
	                        _6326.z = _6324.z;
	                        _478 = _6326;
	                        if (_653 > 0.0)
	                        {
	                            vec4 _6334 = _654;
	                            _6334.x = 0.2820948064327239990234375;
	                            _6334.y = (-0.48860251903533935546875) * _624.y;
	                            _6334.z = 0.48860251903533935546875 * _624.z;
	                            _6334.w = (-0.48860251903533935546875) * _624.x;
	                            _654 = _6334;
	                            vec4 _6347 = _655;
	                            _6347.x = (1.09254848957061767578125 * _624.x) * _624.y;
	                            _6347.y = ((-1.09254848957061767578125) * _624.y) * _624.z;
	                            _6347.z = 0.3153915703296661376953125 * (((3.0 * _624.z) * _624.z) - 1.0);
	                            _6347.w = ((-1.09254848957061767578125) * _624.x) * _624.z;
	                            _655 = _6347;
	                            _477 += (_6334 * _649.x);
	                            _474 += (_6347 * _649.x);
	                            _476 += (_6334 * _649.y);
	                            _473 += (_6347 * _649.y);
	                            _475 += (_6334 * _649.z);
	                            _472 += (_6347 * _649.z);
	                            vec4 _6386 = _471;
	                            vec3 _6389 = _6386.xyz + (_649 * (0.546274244785308837890625 * ((_624.x * _624.x) - (_624.y * _624.y))));
	                            vec4 _6391 = _6386;
	                            _6391.x = _6389.x;
	                            _6391.y = _6389.y;
	                            _6391.z = _6389.z;
	                            _471 = _6391;
	                        }
	                        _647 = _5319;
	                        continue;
	                    }
	                    if (_6281)
	                    {
	                        _656 = !_638;
	                    }
	                    else
	                    {
	                        _656 = false;
	                    }
	                    if (_656)
	                    {
	                        _647 = _5319;
	                        continue;
	                    }
	                    float _6409 = max(_6276.x, max(_6276.y, _6276.z));
	                    float _657 = _637.x;
	                    do
	                    {
	                        float _6414 = _640;
	                        float _6415 = _6414 + _6409;
	                        _640 = _6415;
	                        if (_6415 == 0.0)
	                        {
	                            _596 = false;
	                            break;
	                        }
	                        float _6420 = _6409 / _640;
	                        do
	                        {
	                            if (_6420 <= 0.0)
	                            {
	                                _597 = false;
	                                break;
	                            }
	                            if (_6420 >= 1.0)
	                            {
	                                _597 = true;
	                                break;
	                            }
	                            if (_657 < _6420)
	                            {
	                                _657 = min(_657 / _6420, 0.99999988079071044921875);
	                                _597 = true;
	                                break;
	                            }
	                            _657 = min((_657 - _6420) / (1.0 - _6420), 0.99999988079071044921875);
	                            _597 = false;
	                            break;
	                        } while(false);
	                        _596 = _597;
	                        break;
	                    } while(false);
	                    vec2 _6445 = _637;
	                    _6445.x = _657;
	                    _637 = _6445;
	                    if (_596)
	                    {
	                        _639 = _624;
	                        _651 = int(_5317);
	                        _646 = _6409;
	                        _650 = _6281;
	                        _648 = _6276;
	                    }
	                    _647 = _5319;
	                    continue;
	                }
	                _642 = _651;
	                _643 = _646;
	                _641 = _650;
	                _644++;
	                _645 = _648;
	                continue;
	            }
	            bool _6460 = any(notEqual(_645, vec3(0.0)));
	            if (_642 != (-1))
	            {
	                _638 = _6460;
	            }
	            else
	            {
	                _638 = false;
	            }
	            if (_638)
	            {
	                vec3 _6474 = _645;
	                vec3 _6475 = _6474 * (_640 / _643);
	                bool _594;
	                if (isinf(_639.w))
	                {
	                    _594 = true;
	                }
	                else
	                {
	                    _594 = isnan(_639.w);
	                }
	                float _595;
	                if (!_594)
	                {
	                    _595 = _639.w;
	                }
	                else
	                {
	                    _595 = 56755.83984375;
	                }
	                vec4 _6492 = _639;
	                _6492.w = _595;
	                _639 = _6492;
	                float _593;
	                do
	                {
	                    float _6501 = dot(_6492.xyz, g_Lights_1._member0[_642].m_vNearPlane.xyz);
	                    if (_6501 == 0.0)
	                    {
	                        _593 = 0.0;
	                        break;
	                    }
	                    _593 = (g_Lights_1._member0[_642].m_vNearPlane.w - dot(_5238, g_Lights_1._member0[_642].m_vNearPlane.xyz)) * (1.0 / _6501);
	                    break;
	                } while(false);
	                if (_593 > 0.0)
	                {
	                    vec4 _6513 = _639;
	                    _6513.w = min(_6513.w, _593);
	                    _639 = _6513;
	                }
	                if (_641)
	                {
	                    _648 = _481;
	                }
	                else
	                {
	                    _648 = _482;
	                }
	                vec4 _6521 = _639;
	                vec3 _6523 = _648 - _5238;
	                _6521.w = _6521.w + dot(_6521.xyz, _6523);
	                vec3 _6533 = normalize((_6521.xyz * _6521.w) + _6523);
	                vec4 _6535 = _6521;
	                _6535.x = _6533.x;
	                _6535.y = _6533.y;
	                _6535.z = _6533.z;
	                _639 = _6535;
	                if (false)
	                {
	                    _647 = 8u;
	                }
	                else
	                {
	                    _647 = 2u;
	                }
	                uint _592;
	                do
	                {
	                    SceneGlobalInfoGPU_t_natural_logical _6548;
	                    _6548.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	                    _6548.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	                    _6548.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	                    _6548.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	                    _6548.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	                    _6548.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	                    _6548.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	                    _6548.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	                    _6548.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	                    _6548.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	                    if ((_6548.m_vBrdfLUTs.z & 1) != 0)
	                    {
	                        _592 = 32u;
	                        break;
	                    }
	                    if ((_6548.m_vBrdfLUTs.z & 2) != 0)
	                    {
	                        _592 = 16u;
	                        break;
	                    }
	                    _592 = 0u;
	                    break;
	                } while(false);
	                vec3 _578 = _648;
	                float _577 = 0.0;
	                vec3 _576 = _639.xyz;
	                float _591;
	                if (_6460)
	                {
	                    _591 = _639.w;
	                }
	                else
	                {
	                    _591 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, _592, _647, 1u, 2u, 1u, _578, _577, _576, _591, 1);
	                if (_6460)
	                {
	                    _591 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _591 = 0.0;
	                }
	                vec4 _6586 = _296[g_Lights_1._member0[_642].m_nBakedShadowIndex + 1] * dot(_6475.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                _470 += (_6586 * _591);
	                _469 += _6586;
	                _468 = mix(_468, ivec4(g_Lights_1._member0[_642].m_nShadowedLightId), notEqual(_6586, vec4(0.0)));
	                if (g_Lights_1._member0[_642].m_nBakedShadowIndex == (-1))
	                {
	                    if (_641)
	                    {
	                        f16vec4 _575 = _313;
	                        bool _589;
	                        if ((_314 & 65535u) == 2u)
	                        {
	                            _589 = float(_575.x) > 0.0;
	                        }
	                        else
	                        {
	                            _589 = false;
	                        }
	                        _638 = _589;
	                    }
	                    else
	                    {
	                        _638 = false;
	                    }
	                    if (_638)
	                    {
	                        f16vec4 _453 = _313;
	                        uint _6629 = uint(_313.w);
	                        float _6634 = pow(clamp(-dot(normalize(_458 + vec3(_315)), _639.xyz), 0.0, 1.0), 2.0);
	                        f16vec3 _6635 = f16vec3(vec3(0.0));
	                        vec3 _583;
	                        bool _585;
	                        if (isinf(_639.w))
	                        {
	                            _585 = true;
	                        }
	                        else
	                        {
	                            _585 = isnan(_639.w);
	                        }
	                        float _586;
	                        if (!_585)
	                        {
	                            _586 = _639.w;
	                        }
	                        else
	                        {
	                            _586 = 1000.0;
	                        }
	                        vec3 _582 = _482 + (_639.xyz * _586);
	                        float _581 = 0.0;
	                        vec3 _580 = -_639.xyz;
	                        float _587;
	                        if (_6634 > 0.0)
	                        {
	                            _587 = _586;
	                        }
	                        else
	                        {
	                            _587 = 0.0;
	                        }
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _583, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_6635, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _6635, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _582, _581, _580, _587, 0);
	                        float _588;
	                        if (p.nInstance != (-1))
	                        {
	                            f16vec4 _579 = p.material.vMaterialBits;
	                            bool _584;
	                            if ((p.material.nMaterialTypeAndFlags & 65535u) == 2u)
	                            {
	                                _584 = float(_579.x) > 0.0;
	                            }
	                            else
	                            {
	                                _584 = false;
	                            }
	                            if (!_584)
	                            {
	                                _587 = 0.0;
	                            }
	                            else
	                            {
	                                _587 = _6634;
	                            }
	                            _588 = _586 - p.flHitT;
	                        }
	                        else
	                        {
	                            _587 = _6634;
	                            _588 = _586;
	                        }
	                        float _6697 = _588 * float(_453.x);
	                        _645 = vec3(0.0);
	                        _649 = ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_6629].m_vTransmissiveLogColor.xyz * (1.0 + (_6697 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_6629].m_fTransmissiveSaturation))) * exp(-_6697)) * _587) * _6475;
	                    }
	                    else
	                    {
	                        _645 = _6475;
	                        _649 = vec3(0.0);
	                    }
	                    vec3 _6718 = _645;
	                    vec3 _6719 = _6718 * _591;
	                    vec3 _6723 = abs(_6719);
	                    float _6728 = max(_6723.x, max(_6723.y, _6723.z));
	                    vec3 _6733 = clamp(_6719 / vec3(_6728), vec3(-1.0), vec3(1.0)) * clamp(_6728, -100.0, 100.0);
	                    vec3 _6735 = abs(_649);
	                    float _6740 = max(_6735.x, max(_6735.y, _6735.z));
	                    float _6746 = dot(_639.xyz, vec3(_315));
	                    if (_641)
	                    {
	                        _646 = -_6746;
	                        _645 = _6733 * vTransmissiveRatio;
	                    }
	                    else
	                    {
	                        _646 = _6746;
	                        _645 = _6733;
	                    }
	                    vec4 _6753 = _478;
	                    vec3 _6760 = _6753.xyz + ((_645 * max(0.0, _646)) * 0.3183098733425140380859375);
	                    vec4 _6762 = _6753;
	                    _6762.x = _6760.x;
	                    _6762.y = _6760.y;
	                    _6762.z = _6760.z;
	                    vec3 _6768 = _6762.xyz + (clamp(_649 / vec3(_6740), vec3(-1.0), vec3(1.0)) * clamp(_6740, -100.0, 100.0));
	                    vec4 _6770 = _6762;
	                    _6770.x = _6768.x;
	                    _6770.y = _6768.y;
	                    _6770.z = _6768.z;
	                    _478 = _6770;
	                    if (_646 > 0.0)
	                    {
	                        vec4 _658;
	                        vec4 _6778 = _658;
	                        _6778.x = 0.2820948064327239990234375;
	                        _6778.y = (-0.48860251903533935546875) * _639.y;
	                        _6778.z = 0.48860251903533935546875 * _639.z;
	                        _6778.w = (-0.48860251903533935546875) * _639.x;
	                        _658 = _6778;
	                        vec4 _659;
	                        vec4 _6791 = _659;
	                        _6791.x = (1.09254848957061767578125 * _639.x) * _639.y;
	                        _6791.y = ((-1.09254848957061767578125) * _639.y) * _639.z;
	                        _6791.z = 0.3153915703296661376953125 * (((3.0 * _639.z) * _639.z) - 1.0);
	                        _6791.w = ((-1.09254848957061767578125) * _639.x) * _639.z;
	                        _659 = _6791;
	                        _477 += (_6778 * _645.x);
	                        _474 += (_6791 * _645.x);
	                        _476 += (_6778 * _645.y);
	                        _473 += (_6791 * _645.y);
	                        _475 += (_6778 * _645.z);
	                        _472 += (_6791 * _645.z);
	                        vec4 _6830 = _471;
	                        vec3 _6833 = _6830.xyz + (_645 * (0.546274244785308837890625 * ((_639.x * _639.x) - (_639.y * _639.y))));
	                        vec4 _6835 = _6830;
	                        _6835.x = _6833.x;
	                        _6835.y = _6833.y;
	                        _6835.z = _6833.z;
	                        _471 = _6835;
	                    }
	                }
	            }
	            float _6847 = sqrt(vSeed.y);
	            float _6849 = 6.283185482025146484375 * vSeed.x;
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _482, 0.0, mat3(_372, _371, vec3(_322)) * vec3(cos(_6849) * _6847, sin(_6849) * _6847, sqrt(max(0.0, 1.0 - vSeed.y))), 16.0, 1);
	            vec4 _6865 = _465;
	            _6865.x = _6865.x + p_1.m_flVisibility;
	            _465 = _6865;
	        }
	        vec4 _6869 = _478;
	        _6869.w = 1.0;
	        _478 = _6869;
	        if (g_PushConstants.m_nEstimate_DimensionCount.x > 0)
	        {
	            Luxel_t_natural_logical _6892;
	            _6892.vIrradiance_flSampleCount = g_Luxels._member0[_856].vIrradiance_flSampleCount;
	            _6892.vShr = g_Luxels._member0[_856].vShr;
	            _6892.vShg = g_Luxels._member0[_856].vShg;
	            _6892.vShb = g_Luxels._member0[_856].vShb;
	            _6892.vQuadraticr = g_Luxels._member0[_856].vQuadraticr;
	            _6892.vQuadraticg = g_Luxels._member0[_856].vQuadraticg;
	            _6892.vQuadraticb = g_Luxels._member0[_856].vQuadraticb;
	            _6892.vQuadraticFinalrgb = g_Luxels._member0[_856].vQuadraticFinalrgb;
	            _6892.vBakedShadow = g_Luxels._member0[_856].vBakedShadow;
	            _6892.vBakedShadowUnoccluded = g_Luxels._member0[_856].vBakedShadowUnoccluded;
	            _6892.vBakedShadowLightId = g_Luxels._member0[_856].vBakedShadowLightId;
	            _6892.vTangent = g_Luxels._member0[_856].vTangent;
	            _6892.vNormal = g_Luxels._member0[_856].vNormal;
	            _6892.flAmbientOcclusion_vPadding = g_Luxels._member0[_856].flAmbientOcclusion_vPadding;
	            vec4 _6893 = _6892.vIrradiance_flSampleCount;
	            float _6909 = 1.0 / (1.0 + _6893.w);
	            vec3 _6913 = mix(_6893.xyz, _478.xyz, vec3(_6909));
	            vec4 _6915 = _6893;
	            _6915.x = _6913.x;
	            _6915.y = _6913.y;
	            _6915.z = _6913.z;
	            vec4 _6920 = vec4(_6909);
	            _6915.w = _6915.w + 1.0;
	            _478 = _6915;
	            _477 = mix(_6892.vShr, _477, _6920);
	            _476 = mix(_6892.vShg, _476, _6920);
	            _475 = mix(_6892.vShb, _475, _6920);
	            _474 = mix(_6892.vQuadraticr, _474, _6920);
	            _473 = mix(_6892.vQuadraticg, _473, _6920);
	            _472 = mix(_6892.vQuadraticb, _472, _6920);
	            _471 = mix(_6892.vQuadraticFinalrgb, _471, _6920);
	            _470 = mix(_6892.vBakedShadow, _470, _6920);
	            _469 = mix(_6892.vBakedShadowUnoccluded, _469, _6920);
	            _468 = mix(_468, _6892.vBakedShadowLightId, notEqual(_6892.vBakedShadowLightId, ivec4(255)));
	            _467 = mix(_6892.vTangent, _467, _6920);
	            _466 = mix(_6892.vNormal, _466, _6920);
	            _465 = mix(_6892.flAmbientOcclusion_vPadding, _465, _6920);
	        }
	        g_Luxels._member0[_856].vIrradiance_flSampleCount = _478;
	        g_Luxels._member0[_856].vShr = _477;
	        g_Luxels._member0[_856].vShg = _476;
	        g_Luxels._member0[_856].vShb = _475;
	        g_Luxels._member0[_856].vQuadraticr = _474;
	        g_Luxels._member0[_856].vQuadraticg = _473;
	        g_Luxels._member0[_856].vQuadraticb = _472;
	        g_Luxels._member0[_856].vQuadraticFinalrgb = _471;
	        g_Luxels._member0[_856].vBakedShadow = _470;
	        g_Luxels._member0[_856].vBakedShadowUnoccluded = _469;
	        g_Luxels._member0[_856].vBakedShadowLightId = _468;
	        g_Luxels._member0[_856].vTangent = _467;
	        g_Luxels._member0[_856].vNormal = _466;
	        g_Luxels._member0[_856].flAmbientOcclusion_vPadding = _465;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
