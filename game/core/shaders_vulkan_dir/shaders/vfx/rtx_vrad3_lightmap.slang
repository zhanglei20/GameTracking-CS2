//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader to generate lightmaps";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
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
	// SPIR-V source (158220 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct MaterialDataMinimal_t
	{
	    f16vec3 vMaterialBits;
	    float16_t _m1;
	    f16vec3 _m2;
	    float16_t _m3;
	    f16vec3 _m4;
	    float16_t _m5;
	    uint _m6;
	    f16vec4 _m7;
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
	
	struct _MatrixStorage_float4x3_ColMajornatural
	{
	    vec4 data[3];
	};
	
	struct SceneGlobalInfoGPU_t_natural
	{
	    vec4 m_vSkyColor;
	    vec4 m_vSkyAmbientBounce;
	    vec4 m_vSunLightIrradiance;
	    vec4 m_vLocalLightMinBounds;
	    vec4 m_vLocalLightMaxBounds;
	    ivec4 m_vLightBinCellCount_nLightCount;
	    _MatrixStorage_float4x3_ColMajornatural m_mIBLTransformI;
	    vec4 m_vIBLCubeMapScale;
	    ivec4 m_vIBLParams;
	    ivec4 m_vBrdfLUTs;
	};
	
	struct Payload_t
	{
	    vec3 material;
	    vec3 _m1;
	    vec3 _m2;
	    float _m3;
	    float _m4;
	    int _m5;
	    bool _m6;
	    MaterialDataMinimal_t _m7;
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
	
	struct _MatrixStorage_float4x4_ColMajornatural
	{
	    vec4 data[4];
	};
	
	struct _Array_natural_vector_float_4_5
	{
	    vec4 data[5];
	};
	
	struct PathTraceBarnLightGPU_t_natural
	{
	    _MatrixStorage_float4x4_ColMajornatural m_mToClipSpace;
	    _MatrixStorage_float4x4_ColMajornatural m_mFromClipSpace;
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
	    _MatrixStorage_float4x3_ColMajornatural m_mBarnIlluminationFromWorld;
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
	
	vec4 _313;
	float _314;
	
	layout(set = 6, binding = 158, std430) buffer RWStructuredBuffer
	{
	    Luxel_t_natural _m0[];
	} g_Luxels;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    SceneGlobalInfoGPU_t_natural _m0[];
	} g_SceneGlobalInfo;
	
	layout(set = 3, binding = 35, std430) readonly buffer g_instanceBuffer
	{
	    PackedRtxInstanceData_t_natural _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 6, binding = 159, std430) buffer g_LightBins
	{
	    uint _m0[];
	} g_LightBins_1;
	
	layout(set = 3, binding = 36, std430) readonly buffer g_Lights
	{
	    PathTraceBarnLightGPU_t_natural _m0[];
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
	
	layout(set = 6, binding = 160, std430) buffer g_LightmapSamples
	{
	    LightmapSample_t_natural _m0[];
	} g_LightmapSamples_1;
	
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
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D[65536];
	layout(set = 3, binding = 15) uniform sampler g_CookieSampler;
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	
	void main()
	{
	    bool _538 = false;
	    bool _638 = false;
	    bool _692 = false;
	    do
	    {
	        uint _767 = (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x) + gl_LaunchIDEXT.x;
	        if (g_PushConstants.m_nEstimate_DimensionCount.x == 0)
	        {
	            g_Luxels._m0[_767].vIrradiance_flSampleCount = vec4(0.0);
	            g_Luxels._m0[_767].vShr = vec4(0.0);
	            g_Luxels._m0[_767].vShg = vec4(0.0);
	            g_Luxels._m0[_767].vShb = vec4(0.0);
	            g_Luxels._m0[_767].vQuadraticr = vec4(0.0);
	            g_Luxels._m0[_767].vQuadraticg = vec4(0.0);
	            g_Luxels._m0[_767].vQuadraticb = vec4(0.0);
	            g_Luxels._m0[_767].vQuadraticFinalrgb = vec4(0.0);
	            g_Luxels._m0[_767].vBakedShadow = vec4(0.0);
	            g_Luxels._m0[_767].vBakedShadowUnoccluded = vec4(0.0);
	            g_Luxels._m0[_767].vBakedShadowLightId = ivec4(255);
	            g_Luxels._m0[_767].vTangent = vec4(0.0);
	            g_Luxels._m0[_767].vNormal = vec4(0.0);
	            g_Luxels._m0[_767].flAmbientOcclusion_vPadding = vec4(0.0);
	        }
	        else
	        {
	            if (imageLoad(g_LightmapBlockConverged, ivec3(gl_LaunchIDEXT / uvec3(4u, 4u, 1u))).x != 0u)
	            {
	                break;
	            }
	        }
	        uvec3 _807 = uvec3(imageSize(g_RandomSamples));
	        ivec3 _752;
	        ivec3 _810 = _752;
	        _810.x = int(_807.x);
	        _810.y = int(_807.y);
	        _810.z = int(_807.z);
	        _752 = _810;
	        ivec2 _819 = ivec2(gl_LaunchIDEXT.xy) - _810.xy * (ivec2(gl_LaunchIDEXT.xy) / _810.xy);
	        uint _820 = uint(g_PushConstants.m_nEstimate_DimensionCount.y);
	        uint _840 = uint(max(1, ((g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	        uvec3 _841 = uvec3(g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.xyz);
	        vec3 _844 = vec3(_841) / (g_SceneGlobalInfo._m0[0].m_vLocalLightMaxBounds.xyz - g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz);
	        vec3 _846 = (-g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz) * _844;
	        uvec4 sampled = texelFetch(g_LuxelChartIDs, ivec2(gl_LaunchIDEXT.xy), 0);
	        uint _850 = sampled.x;
	        if (_850 == 4294967295u)
	        {
	            break;
	        }
	        vec2 _858 = (g_PushConstants.m_vLightmapOffsetAndSize.xy + vec2(gl_LaunchIDEXT.xy)) + vec2(0.5);
	        vec2 vSeed = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_819.xy, 1)))).xy;
	        float flReservoirWt = 0.0;
	        vec4 _431 = vec4(0.0);
	        vec4 _430 = vec4(0.0);
	        vec4 _429 = vec4(0.0);
	        vec4 _428 = vec4(0.0);
	        vec4 _427 = vec4(0.0);
	        int _426 = 0;
	        uint _425 = 0u;
	        int dy = -2;
	        bool _750;
	        bool _751;
	        bool _753;
	        bool _756;
	        for (;;)
	        {
	            if (!(dy <= 2))
	            {
	                break;
	            }
	            int dx = -2;
	            for (;;)
	            {
	                bool _880_ladder_break = false;
	                do
	                {
	                    if (!(dx <= 2))
	                    {
	                        _880_ladder_break = true;
	                        break;
	                    }
	                    ivec2 _894 = ivec2(gl_LaunchIDEXT.xy + uvec2(ivec2(dx, dy)));
	                    int _895 = _894.x;
	                    if (_895 < 0)
	                    {
	                        _753 = true;
	                    }
	                    else
	                    {
	                        _753 = uint(_895) >= gl_LaunchSizeEXT.x;
	                    }
	                    if (_753)
	                    {
	                        break;
	                    }
	                    int _907 = _894.y;
	                    if (_907 < 0)
	                    {
	                        _756 = true;
	                    }
	                    else
	                    {
	                        _756 = uint(_907) >= gl_LaunchSizeEXT.y;
	                    }
	                    if (_756)
	                    {
	                        break;
	                    }
	                    if (texelFetch(g_LuxelChartIDs, ivec2(uvec2(_894)), 0).x != _850)
	                    {
	                        break;
	                    }
	                    uint nSample = (uint(_907) * gl_LaunchSizeEXT.y) + uint(_895);
	                    if (g_LightmapSamples_1._m0[nSample].m_vPositionWs.w <= 0.0)
	                    {
	                        break;
	                    }
	                    vec2 vDx = (g_LightmapSamples_1._m0[nSample].m_vLightmapUv.xy * g_PushConstants.m_vLightmapOffsetAndSize.zw) - _858;
	                    float _956 = 0.79788458347320556640625 * exp(dot(vDx, vDx) * (-2.0));
	                    float _757 = vSeed.y;
	                    do
	                    {
	                        float _961 = flReservoirWt;
	                        float _962 = _961 + _956;
	                        flReservoirWt = _962;
	                        if (_962 == 0.0)
	                        {
	                            _751 = false;
	                            break;
	                        }
	                        float _967 = _956 / flReservoirWt;
	                        do
	                        {
	                            if (_967 <= 0.0)
	                            {
	                                _750 = false;
	                                break;
	                            }
	                            if (_967 >= 1.0)
	                            {
	                                _750 = true;
	                                break;
	                            }
	                            if (_757 < _967)
	                            {
	                                _757 = min(_757 / _967, 0.99999988079071044921875);
	                                _750 = true;
	                                break;
	                            }
	                            _757 = min((_757 - _967) / (1.0 - _967), 0.99999988079071044921875);
	                            _750 = false;
	                            break;
	                        } while(false);
	                        _751 = _750;
	                        break;
	                    } while(false);
	                    vec2 _991 = vSeed;
	                    _991.y = _757;
	                    vSeed = _991;
	                    if (_751)
	                    {
	                        _431 = g_LightmapSamples_1._m0[nSample].m_vPositionWs;
	                        _430 = g_LightmapSamples_1._m0[nSample].m_vShadingNormalWs_vTransmissiveR;
	                        _429 = g_LightmapSamples_1._m0[nSample].m_vInterpolatedNormalWs_vTransmissiveG;
	                        _428 = g_LightmapSamples_1._m0[nSample].m_vFaceNormalWs_vTransmissiveB;
	                        _427 = g_LightmapSamples_1._m0[nSample].m_vTangentWs;
	                        _426 = g_LightmapSamples_1._m0[nSample].m_nInstanceFlags;
	                        _425 = g_LightmapSamples_1._m0[nSample].m_nSampleFlags;
	                    }
	                    break;
	                } while(false);
	                if (_880_ladder_break)
	                {
	                    break;
	                }
	                dx++;
	                continue;
	            }
	            dy++;
	            continue;
	        }
	        if (!(_431.w != 0.0))
	        {
	            break;
	        }
	        vec3 _1011 = abs(_431.xyz);
	        vec3 _424 = _431.xyz + (_428.xyz * ((abs(_431.xyz) + vec3(abs(max(_1011.x, max(_1011.y, _1011.z))))) * 9.9999997473787516355514526367188e-05));
	        vec3 _1027 = abs(_431.xyz);
	        vec3 _423 = _431.xyz + ((-_428.xyz) * ((abs(_431.xyz) + vec3(abs(max(_1027.x, max(_1027.y, _1027.z))))) * 9.9999997473787516355514526367188e-05));
	        f16vec3 _322 = f16vec3(_430.xyz);
	        vec3 _422 = _428.xyz;
	        vec3 _365;
	        vec3 _754 = _365;
	        vec3 _364;
	        vec3 _755 = _364;
	        float _749;
	        if (_430.z >= 0.0)
	        {
	            _749 = 1.0;
	        }
	        else
	        {
	            _749 = -1.0;
	        }
	        float _1053 = (-1.0) / (_749 + _430.z);
	        float _1057 = (_430.x * _430.y) * _1053;
	        vec3 _1062 = _754;
	        _1062.x = 1.0 + (((_749 * _430.x) * _430.x) * _1053);
	        _1062.y = _749 * _1057;
	        _1062.z = (-_749) * _430.x;
	        _754 = _1062;
	        vec3 _1069 = _755;
	        _1069.x = _1057;
	        _1069.y = _749 + ((_430.y * _430.y) * _1053);
	        _1069.z = -_430.y;
	        _755 = _1069;
	        _365 = _1062;
	        _364 = _1069;
	        f16vec3 _320 = f16vec3(vec3(1.0));
	        int _421 = _426;
	        vec3 vTransmissiveRatio = vec3(_430.w, _429.w, _428.w);
	        vec4 _420 = vec4(0.0);
	        vec4 _419 = vec4(0.0);
	        vec4 _418 = vec4(0.0);
	        vec4 _417 = vec4(0.0);
	        vec4 _416 = vec4(0.0);
	        vec4 _415 = vec4(0.0);
	        vec4 _414 = vec4(0.0);
	        vec4 _413 = vec4(0.0);
	        vec4 _412 = vec4(0.0);
	        vec4 _411 = vec4(0.0);
	        ivec4 _410 = ivec4(255);
	        vec4 _409 = vec4(0.0);
	        vec4 _408 = vec4(0.0);
	        vec4 _407 = vec4(0.0);
	        if (all(greaterThanEqual(_431.xyz, g_PushConstants.m_vCordonMins.xyz)))
	        {
	            _753 = all(lessThanEqual(_431.xyz, g_PushConstants.m_vCordonMaxs.xyz));
	        }
	        else
	        {
	            _753 = false;
	        }
	        if (_753)
	        {
	            f16vec4 _316;
	            uint _317;
	            float16_t _318;
	            float16_t _319;
	            float16_t _321;
	            if ((_425 & 2u) != 0u)
	            {
	                f16vec3 _1117 = f16vec3(vec3(0.0));
	                vec3 _432;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _432, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_1117, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1117, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _424 + (_428.xyz * 0.037500001490116119384765625), 0.0, -_428.xyz, 0.07500000298023223876953125, 0);
	                if (p._m5 != (-1))
	                {
	                    _322 = p._m7.vMaterialBits;
	                    _321 = p._m7._m1;
	                    _320 = p._m7._m2;
	                    _319 = p._m7._m3;
	                    _318 = p._m7._m5;
	                    _317 = p._m7._m6;
	                    _316 = p._m7._m7;
	                }
	            }
	            uint _1136 = _425;
	            uint _1137 = _1136 & 4294967292u;
	            _425 = _1137;
	            vec4 _1140 = _408;
	            _1140.x = _429.x;
	            _1140.y = _429.y;
	            _1140.z = _429.z;
	            _408 = _1140;
	            _409 = _427;
	            vec3 _361;
	            float _362;
	            float _363;
	            vec3 _436 = _424;
	            vec3 _435 = _423;
	            vec3 _434 = _422;
	            int _433 = _421;
	            f16vec3 _329 = _322;
	            float16_t _328 = _321;
	            f16vec3 _327 = _320;
	            float16_t _326 = _319;
	            float16_t _325 = _318;
	            uint _324 = _317;
	            f16vec4 _323 = _316;
	            vec3 _370 = _365;
	            vec3 _369 = _364;
	            float _368 = _363;
	            float _367 = _362;
	            vec3 _366 = _361;
	            vec2 _745 = vSeed;
	            float _746;
	            if ((_1137 & 3u) != 0u)
	            {
	                _746 = 0.5;
	            }
	            else
	            {
	                float _1170 = max(_430.w, max(_429.w, _428.w));
	                _746 = _1170 / (_1170 + 1.0);
	            }
	            float _747 = _745.x;
	            bool _744;
	            do
	            {
	                if (_746 <= 0.0)
	                {
	                    _744 = false;
	                    break;
	                }
	                if (_746 >= 1.0)
	                {
	                    _744 = true;
	                    break;
	                }
	                if (_747 < _746)
	                {
	                    _747 = min(_747 / _746, 0.99999988079071044921875);
	                    _744 = true;
	                    break;
	                }
	                _747 = min((_747 - _746) / (1.0 - _746), 0.99999988079071044921875);
	                _744 = false;
	                break;
	            } while(false);
	            vec2 _1198 = _745;
	            _1198.x = _747;
	            _745 = _1198;
	            if (_744)
	            {
	                _436 = _435;
	            }
	            else
	            {
	                _746 = 1.0 - _746;
	            }
	            float _1208 = sqrt(_745.y);
	            float _1210 = 6.283185482025146484375 * _745.x;
	            vec3 _1218 = vec3(cos(_1210) * _1208, sin(_1210) * _1208, sqrt(max(0.0, 1.0 - _745.y)));
	            vec3 _748 = _1218;
	            float _1221 = _746;
	            if (_744)
	            {
	                _746 = -_748.z;
	            }
	            else
	            {
	                _746 = _748.z;
	            }
	            vec3 _1232 = _748;
	            _1232.z = _746;
	            _748 = _1232;
	            vec3 _1239 = mat3(_370, _369, vec3(_329)) * _1232;
	            vec3 _733 = _1239;
	            vec3 _446 = _436;
	            vec3 _445 = _435;
	            vec3 _444 = _434;
	            int _443 = _433;
	            f16vec3 _344 = _329;
	            float16_t _343 = _328;
	            f16vec3 _342 = _327;
	            float16_t _341 = _326;
	            float16_t _340 = _325;
	            uint _339 = _324;
	            f16vec4 _338 = _323;
	            vec3 _380 = _370;
	            vec3 _379 = _369;
	            float _378 = _368;
	            float _377 = _367;
	            vec3 _376 = _366;
	            int _734 = 1;
	            vec3 _735 = vec3(1.0 / (_1221 * (_1218.z * 0.3183098733425140380859375)));
	            vec3 _736 = vec3(0.0);
	            vec3 _447;
	            vec3 _460;
	            vec3 _480;
	            bool _574;
	            float _575;
	            bool _576;
	            vec3 _577;
	            bool _578;
	            vec3 _579;
	            vec3 _580;
	            float _581;
	            float _582;
	            bool _583;
	            vec3 _584;
	            bool _585;
	            vec3 _586;
	            bool _589;
	            bool _590;
	            bool _592;
	            float _593;
	            uint _594;
	            float _595;
	            bool _596;
	            float _597;
	            bool _598;
	            bool _599;
	            float _600;
	            float _601;
	            float _602;
	            bool _603;
	            float _604;
	            bool _605;
	            vec3 _606;
	            bool _607;
	            vec3 _608;
	            vec3 _609;
	            bool _610;
	            bool _611;
	            float _612;
	            vec4 _613;
	            vec4 _614;
	            float _615;
	            vec3 _616;
	            float _617;
	            float _618;
	            bool _619;
	            float _620;
	            vec4 _621;
	            vec2 _622;
	            float _623;
	            float _624;
	            vec4 _625;
	            float _626;
	            vec3 _627;
	            vec3 _628;
	            bool _629;
	            float _630;
	            vec4 _631;
	            vec2 _632;
	            float _633;
	            float _634;
	            vec3 _636;
	            vec3 _637;
	            vec4 _639;
	            float _640;
	            float _641;
	            vec3 _642;
	            vec3 _643;
	            float _644;
	            float _645;
	            bool _646;
	            vec3 _647;
	            vec3 _648;
	            bool _649;
	            bool _650;
	            vec3 _651;
	            bool _656;
	            float _659;
	            float _661;
	            bool _662;
	            vec3 _663;
	            bool _664;
	            vec3 _665;
	            vec3 _666;
	            vec4 _667;
	            vec4 _668;
	            float _669;
	            vec3 _670;
	            float _671;
	            float _672;
	            bool _673;
	            float _674;
	            vec4 _675;
	            vec2 _676;
	            float _677;
	            float _678;
	            vec4 _679;
	            float _680;
	            vec3 _681;
	            vec3 _682;
	            bool _683;
	            float _684;
	            vec4 _685;
	            vec2 _686;
	            float _687;
	            float _688;
	            vec3 _690;
	            vec3 _691;
	            vec4 _693;
	            float _694;
	            float _695;
	            vec3 _696;
	            vec3 _697;
	            float _698;
	            float _699;
	            bool _700;
	            vec3 _701;
	            vec3 _702;
	            bool _703;
	            bool _704;
	            vec3 _705;
	            float _710;
	            bool _711;
	            bool _712;
	            bool _713;
	            vec3 _715;
	            float _717;
	            float _718;
	            bool _721;
	            float _722;
	            float _723;
	            bool _726;
	            bool _727;
	            bool _729;
	            vec3 _731;
	            vec3 _732;
	            vec3 _737;
	            float _738;
	            float _741;
	            vec3 _743;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_734 <= 16))
	                {
	                    break;
	                }
	                if (false)
	                {
	                    if (_734 > (-1))
	                    {
	                        _738 = 1.0;
	                        _737 = vec3(0.0);
	                    }
	                    else
	                    {
	                        if (_734 != (-1))
	                        {
	                            _738 = 0.0;
	                        }
	                        else
	                        {
	                            _738 = 1.0;
	                        }
	                        _737 = _735;
	                    }
	                }
	                else
	                {
	                    _738 = 1.0;
	                    _737 = _735;
	                }
	                if (all(equal(_737, vec3(0.0))))
	                {
	                    break;
	                }
	                vec3 _442 = _446;
	                vec3 _441 = _733;
	                vec2 _1297 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_819.xy, int(1u + uint(_734)))))).xy;
	                f16vec3 _1299 = f16vec3(vec3(0.0));
	                vec2 _1305 = _1297;
	                _1305.y = 0.0;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _447, 3.4028234663852885981170418348452e+38, _1297.y, -1, false, MaterialDataMinimal_t(_1299, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1299, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 4u, 0u, 2u, 0u, _446, 0.0, _733, 56755.83984375, 0);
	                Payload_t _1307 = p;
	                vec2 _1309 = _1297;
	                _1309.y = _1307._m4;
	                vec2 _739 = _1309;
	                if (!(_1307._m5 != (-1)))
	                {
	                    vec2 _1326 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_819.xy, int(1u + uint(_734 + 1)))))).xy;
	                    _739 = _1326;
	                    vec2 _728 = _1326;
	                    if (_733.z < 0.0)
	                    {
	                        float _730 = _728.y;
	                        do
	                        {
	                            if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w <= 0.0)
	                            {
	                                _727 = false;
	                                break;
	                            }
	                            if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w >= 1.0)
	                            {
	                                _727 = true;
	                                break;
	                            }
	                            if (_730 < g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w)
	                            {
	                                _730 = min(_730 / g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                                _727 = true;
	                                break;
	                            }
	                            _730 = min((_730 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                            _727 = false;
	                            break;
	                        } while(false);
	                        vec2 _1362 = _728;
	                        _1362.y = _730;
	                        _728 = _1362;
	                        _729 = _727;
	                    }
	                    else
	                    {
	                        _729 = false;
	                    }
	                    if (_729)
	                    {
	                        float _1370 = sqrt(_728.y);
	                        float _1372 = 6.283185482025146484375 * _728.x;
	                        _731 = vec3(cos(_1372) * _1370, sin(_1372) * _1370, sqrt(max(0.0, 1.0 - _728.y)));
	                        _732 = g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.xyz;
	                    }
	                    else
	                    {
	                        _731 = _733;
	                        _732 = vec3(0.0);
	                    }
	                    if (g_SceneGlobalInfo._m0[0].m_vIBLParams.y >= 0)
	                    {
	                        vec4 _1439 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._m0[0].m_vIBLParams.y], g_Sampler), normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_731, 0.0)), 0.0);
	                        if (dot(_1439.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	                        {
	                            _732 += (g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * _1439.xyz);
	                        }
	                    }
	                    else
	                    {
	                        _732 += g_SceneGlobalInfo._m0[0].m_vSkyColor.xyz;
	                    }
	                    if (_734 > 1)
	                    {
	                        _732 *= g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.w;
	                    }
	                    if (_729)
	                    {
	                        _732 *= g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.xyz;
	                    }
	                    _736 += ((_737 * _732) * _738);
	                    break;
	                }
	                if ((int((g_instanceBuffer_1._m0[uint(_1307._m5)].nMaterialFlags_nInstanceFlags >> uint(16)) & 65535u) & 4) != 0)
	                {
	                    break;
	                }
	                uint _1491 = uint(_1307._m5);
	                vec3 _451 = (_442 + (_441 * _1307._m3)) + (_1307._m1 * ((abs(_442) + vec3(abs(_1307._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _450 = (_442 + (_441 * _1307._m3)) + ((-_1307._m1) * ((abs(_442) + vec3(abs(_1307._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _449 = _1307._m1;
	                int _448 = int((g_instanceBuffer_1._m0[_1491].nMaterialFlags_nInstanceFlags) & 65535u);
	                vec3 _456 = vec3(0.0);
	                vec3 _455 = vec3(0.0);
	                float _454 = 0.0;
	                float _453 = 0.0;
	                vec3 _452 = vec3(0.0);
	                f16vec3 _393 = _1307._m7.vMaterialBits;
	                float16_t _392 = _1307._m7._m1;
	                f16vec3 _391 = _1307._m7._m2;
	                f16vec3 _389 = _1307._m7._m4;
	                float16_t _388 = _1307._m7._m5;
	                uint _387 = _1307._m7._m6;
	                f16vec4 _386 = _1307._m7._m7;
	                float16_t _390 = float16_t(max(float(_1307._m7._m3), 0.07999999821186065673828125));
	                vec3 _1538 = vec3(_1307._m7.vMaterialBits);
	                vec3 _724 = vec3(0.0);
	                vec3 _725 = vec3(0.0);
	                float _1539 = _1538.z;
	                if (_1539 >= 0.0)
	                {
	                    _723 = 1.0;
	                }
	                else
	                {
	                    _723 = -1.0;
	                }
	                float _1546 = (-1.0) / (_723 + _1539);
	                float _1547 = _1538.x;
	                float _1548 = _1538.y;
	                float _1550 = (_1547 * _1548) * _1546;
	                vec3 _1555 = _724;
	                _1555.x = 1.0 + (((_723 * _1547) * _1547) * _1546);
	                _1555.y = _723 * _1550;
	                _1555.z = (-_723) * _1547;
	                _724 = _1555;
	                vec3 _1562 = _725;
	                _1562.x = _1550;
	                _1562.y = _723 + ((_1548 * _1548) * _1546);
	                _1562.z = -_1548;
	                _725 = _1562;
	                _456 = _1555;
	                _455 = _1562;
	                vec3 _1574 = transpose(mat3(_1555, _1562, vec3(_393))) * (-_441);
	                _452 = _1574;
	                vec3 _1582 = vec3(mix(f16vec3(_388), _391, f16vec3(_392)));
	                _454 = dot((_1582 + ((vec3(1.0) - _1582) * pow(max(0.0, 1.0 - _1574.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                if ((_387 & 65535u) == 1u)
	                {
	                    float _1601 = dot(vec3(_386.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                    _453 = _1601 / max(9.9999997473787516355514526367188e-05, _1601 + dot(vec3(_391).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                }
	                f16vec3 _352 = _393;
	                float16_t _351 = _392;
	                f16vec3 _350 = _391;
	                float16_t _349 = _390;
	                f16vec3 _348 = _389;
	                float16_t _347 = _388;
	                uint _346 = _387;
	                f16vec4 _345 = _386;
	                vec3 _385 = _456;
	                vec3 _384 = _455;
	                float _383 = _454;
	                float _382 = _453;
	                vec3 _381 = _452;
	                if (true)
	                {
	                    if ((_448 & 256) != 0)
	                    {
	                        _348 *= float16_t(g_instanceBuffer_1._m0[_1491].fEmissiveBoost);
	                    }
	                    else
	                    {
	                        _348 = f16vec3(vec3(0.0));
	                    }
	                }
	                if (true)
	                {
	                    _726 = any(notEqual(_1307.material, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _726 = false;
	                }
	                vec3 _1642 = _1307.material - _451;
	                float _1643 = length(_1642);
	                vec3 _459 = _451;
	                float _458 = 0.0;
	                vec3 _457 = vec4(_1642 / vec3(_1643), _1643).xyz;
	                if (_726)
	                {
	                    _722 = _1643;
	                }
	                else
	                {
	                    _722 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _459, _458, _457, _722, 1);
	                if (_726)
	                {
	                    _722 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _722 = 0.0;
	                }
	                if (_722 == 1.0)
	                {
	                    _451 = _1307.material;
	                    _449 = vec3(_1307._m7.vMaterialBits);
	                }
	                vec3 _440 = _451;
	                vec3 _439 = _450;
	                vec3 _438 = _449;
	                int _437 = _448;
	                f16vec3 _337 = _352;
	                float16_t _336 = _351;
	                f16vec3 _335 = _350;
	                float16_t _334 = _349;
	                f16vec3 _333 = _348;
	                float16_t _332 = _347;
	                uint _331 = _346;
	                f16vec4 _330 = _345;
	                vec3 _375 = _385;
	                vec3 _374 = _384;
	                float _373 = _383;
	                float _372 = _382;
	                vec3 _371 = _381;
	                if (!(dot(_449, -_733) > 0.0))
	                {
	                    if ((_437 & 1024) != 0)
	                    {
	                        _438 = -_438;
	                        _337 = -_337;
	                        vec3 _1921 = _446;
	                        _446 = _445;
	                        _445 = _1921;
	                    }
	                    else
	                    {
	                        f16vec3 _1702 = f16vec3(vec3(0.0));
	                        vec2 _1708 = _1297;
	                        _1708.y = 0.0;
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _460, 3.4028234663852885981170418348452e+38, _1297.y, -1, false, MaterialDataMinimal_t(_1702, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1702, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 4u, 0u, 2u, 0u, _442, _1307._m3 * 0.99989998340606689453125, _441, _1307._m3 * 1.00010001659393310546875, 0);
	                        vec2 _1714 = _1297;
	                        _1714.y = p._m4;
	                        _739 = _1714;
	                        if (p._m5 != (-1))
	                        {
	                            uint _1723 = uint(p._m5);
	                            vec3 _464 = (_442 + (_441 * p._m3)) + (p._m1 * ((abs(_442) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _463 = (_442 + (_441 * p._m3)) + ((-p._m1) * ((abs(_442) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _462 = p._m1;
	                            int _461 = int((g_instanceBuffer_1._m0[_1723].nMaterialFlags_nInstanceFlags) & 65535u);
	                            vec3 _469 = vec3(0.0);
	                            vec3 _468 = vec3(0.0);
	                            float _467 = 0.0;
	                            float _466 = 0.0;
	                            vec3 _465 = vec3(0.0);
	                            f16vec3 _406 = p._m7.vMaterialBits;
	                            float16_t _405 = p._m7._m1;
	                            f16vec3 _404 = p._m7._m2;
	                            f16vec3 _402 = p._m7._m4;
	                            float16_t _401 = p._m7._m5;
	                            uint _400 = p._m7._m6;
	                            f16vec4 _399 = p._m7._m7;
	                            float16_t _403 = float16_t(max(float(p._m7._m3), 0.07999999821186065673828125));
	                            vec3 _1770 = vec3(p._m7.vMaterialBits);
	                            vec3 _719 = vec3(0.0);
	                            vec3 _720 = vec3(0.0);
	                            float _1771 = _1770.z;
	                            if (_1771 >= 0.0)
	                            {
	                                _718 = 1.0;
	                            }
	                            else
	                            {
	                                _718 = -1.0;
	                            }
	                            float _1778 = (-1.0) / (_718 + _1771);
	                            float _1779 = _1770.x;
	                            float _1780 = _1770.y;
	                            float _1782 = (_1779 * _1780) * _1778;
	                            vec3 _1787 = _719;
	                            _1787.x = 1.0 + (((_718 * _1779) * _1779) * _1778);
	                            _1787.y = _718 * _1782;
	                            _1787.z = (-_718) * _1779;
	                            _719 = _1787;
	                            vec3 _1794 = _720;
	                            _1794.x = _1782;
	                            _1794.y = _718 + ((_1780 * _1780) * _1778);
	                            _1794.z = -_1780;
	                            _720 = _1794;
	                            _469 = _1787;
	                            _468 = _1794;
	                            vec3 _1806 = transpose(mat3(_1787, _1794, vec3(_406))) * (-_441);
	                            _465 = _1806;
	                            vec3 _1814 = vec3(mix(f16vec3(_401), _404, f16vec3(_405)));
	                            _467 = dot((_1814 + ((vec3(1.0) - _1814) * pow(max(0.0, 1.0 - _1806.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if ((_400 & 65535u) == 1u)
	                            {
	                                float _1833 = dot(vec3(_399.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                _466 = _1833 / max(9.9999997473787516355514526367188e-05, _1833 + dot(vec3(_404).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                            }
	                            f16vec3 _360 = _406;
	                            float16_t _359 = _405;
	                            f16vec3 _358 = _404;
	                            float16_t _357 = _403;
	                            f16vec3 _356 = _402;
	                            float16_t _355 = _401;
	                            uint _354 = _400;
	                            f16vec4 _353 = _399;
	                            vec3 _398 = _469;
	                            vec3 _397 = _468;
	                            float _396 = _467;
	                            float _395 = _466;
	                            vec3 _394 = _465;
	                            if (true)
	                            {
	                                if ((_461 & 256) != 0)
	                                {
	                                    _356 *= float16_t(g_instanceBuffer_1._m0[_1723].fEmissiveBoost);
	                                }
	                                else
	                                {
	                                    _356 = f16vec3(vec3(0.0));
	                                }
	                            }
	                            if (true)
	                            {
	                                _721 = any(notEqual(p.material, vec3(3.4028234663852885981170418348452e+38)));
	                            }
	                            else
	                            {
	                                _721 = false;
	                            }
	                            vec3 _1874 = p.material - _464;
	                            float _1875 = length(_1874);
	                            vec3 _472 = _464;
	                            float _471 = 0.0;
	                            vec3 _470 = vec4(_1874 / vec3(_1875), _1875).xyz;
	                            if (_721)
	                            {
	                                _717 = _1875;
	                            }
	                            else
	                            {
	                                _717 = 0.0;
	                            }
	                            p_1 = PayloadShadow_t(1.0);
	                            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _472, _471, _470, _717, 1);
	                            if (_721)
	                            {
	                                _717 = p_1.m_flVisibility;
	                            }
	                            else
	                            {
	                                _717 = 0.0;
	                            }
	                            if (_717 == 1.0)
	                            {
	                                _464 = p.material;
	                                _462 = vec3(p._m7.vMaterialBits);
	                            }
	                            _440 = _464;
	                            _439 = _463;
	                            _438 = _462;
	                            _437 = _461;
	                            _337 = _360;
	                            _336 = _359;
	                            _335 = _358;
	                            _334 = _357;
	                            _333 = _356;
	                            _332 = _355;
	                            _331 = _354;
	                            _330 = _353;
	                            _375 = _398;
	                            _374 = _397;
	                            _373 = _396;
	                            _372 = _395;
	                            _371 = _394;
	                        }
	                        else
	                        {
	                            break;
	                        }
	                    }
	                }
	                vec3 _1938 = (_440 + _439) * 0.5;
	                bool _1939 = _734 != 0;
	                if ((_331 & 65535u) == 1u)
	                {
	                    _712 = any(greaterThan(vec3(_330.xyz), vec3(0.0)));
	                }
	                else
	                {
	                    _712 = false;
	                }
	                if (_712)
	                {
	                    _713 = true;
	                }
	                else
	                {
	                    if ((_331 & 65535u) == 2u)
	                    {
	                        _711 = float(_330.x) > 0.0;
	                    }
	                    else
	                    {
	                        _711 = false;
	                    }
	                    _713 = _711;
	                }
	                vec2 _1973 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_819.xy, int(1u + ((2u * _820) + uint(_734))))))).xy;
	                bool _714 = false;
	                vec3 _1986 = (_440 + _439) * 0.5;
	                uvec3 _1991 = min(uvec3(max(fma(_1986, _844, _846), vec3(0.0))), (_841 - uvec3(1u)));
	                uint _706 = 0u;
	                vec3 _707 = vec3(0.0);
	                for (;;)
	                {
	                    if (!(_706 < _840))
	                    {
	                        break;
	                    }
	                    uint _2004 = _840 * _841.x;
	                    uint _708 = subgroupOr(g_LightBins_1._m0[((((_2004 * _841.y) * _1991.z) + (_2004 * _1991.y)) + (_840 * _1991.x)) + _706]);
	                    vec3 _709 = _707;
	                    for (;;)
	                    {
	                        bool _2024_ladder_break = false;
	                        do
	                        {
	                            if (!(_708 != 0u))
	                            {
	                                _2024_ladder_break = true;
	                                break;
	                            }
	                            uint _2031 = _708;
	                            uint _2035 = uint(findLSB(_2031)) + (_706 * 32u);
	                            uint _2037 = _2031 & (_2031 - 1u);
	                            mat4 _2067 = mat4(vec4(g_Lights_1._m0[_2035].m_mToClipSpace.data[0].x, g_Lights_1._m0[_2035].m_mToClipSpace.data[1].x, g_Lights_1._m0[_2035].m_mToClipSpace.data[2].x, g_Lights_1._m0[_2035].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_2035].m_mToClipSpace.data[0].y, g_Lights_1._m0[_2035].m_mToClipSpace.data[1].y, g_Lights_1._m0[_2035].m_mToClipSpace.data[2].y, g_Lights_1._m0[_2035].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_2035].m_mToClipSpace.data[0].z, g_Lights_1._m0[_2035].m_mToClipSpace.data[1].z, g_Lights_1._m0[_2035].m_mToClipSpace.data[2].z, g_Lights_1._m0[_2035].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_2035].m_mToClipSpace.data[0].w, g_Lights_1._m0[_2035].m_mToClipSpace.data[1].w, g_Lights_1._m0[_2035].m_mToClipSpace.data[2].w, g_Lights_1._m0[_2035].m_mToClipSpace.data[3].w));
	                            if ((uint(g_Lights_1._m0[_2035].m_nPathTraceFlags) & 1u) == 0u)
	                            {
	                                _708 = _2037;
	                                break;
	                            }
	                            if ((g_Lights_1._m0[_2035].m_nPathTraceFlags & 8) != 0)
	                            {
	                                _714 = true;
	                                _708 = _2037;
	                                break;
	                            }
	                            do
	                            {
	                                do
	                                {
	                                    vec4 _2142 = _2067 * vec4(_1986.xyz, 1.0);
	                                    vec3 _2146 = _2142.xyz / vec3(_2142.w);
	                                    vec4 _2148;
	                                    _2148.x = _2146.x;
	                                    _2148.y = _2146.y;
	                                    _2148.z = _2146.z;
	                                    if (all(greaterThanEqual(_2148.xyz, vec3(-1.0, -1.0, 0.0))))
	                                    {
	                                        _703 = all(lessThanEqual(_2148.xyz, vec3(1.0)));
	                                    }
	                                    else
	                                    {
	                                        _703 = false;
	                                    }
	                                    if (!_703)
	                                    {
	                                        _704 = false;
	                                        break;
	                                    }
	                                    if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_2035].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_1986, 1.0)).xyz), vec3(1.0))))
	                                    {
	                                        _704 = false;
	                                        break;
	                                    }
	                                    _704 = true;
	                                    break;
	                                } while(false);
	                                if (!_704)
	                                {
	                                    _705 = vec3(0.0);
	                                    break;
	                                }
	                                vec4 _2180 = _2067 * vec4(_1986.xyz, 1.0);
	                                vec3 _2184 = _2180.xyz / vec3(_2180.w);
	                                vec4 _2186;
	                                _2186.x = _2184.x;
	                                _2186.y = _2184.y;
	                                _2186.z = _2184.z;
	                                if (_1939)
	                                {
	                                    _702 = g_Lights_1._m0[_2035].m_vBounceColor.xyz;
	                                }
	                                else
	                                {
	                                    _702 = g_Lights_1._m0[_2035].m_vColor.xyz;
	                                }
	                                if (true)
	                                {
	                                    if (g_Lights_1._m0[_2035].m_nCookie >= 0)
	                                    {
	                                        if (g_Lights_1._m0[_2035].m_bSphericalCookie != 0)
	                                        {
	                                            vec4 _2229 = vec4(-g_Lights_1._m0[_2035].m_vOrientation.xyz, g_Lights_1._m0[_2035].m_vOrientation.w);
	                                            vec4 _2231 = _2229.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                            vec3 _2234 = _2231.xyz;
	                                            vec3 _2235 = vec4((-normalize(g_Lights_1._m0[_2035].m_vLightPosition.xyz - _1986)).xyz, 0.0).xyz;
	                                            vec4 _2242 = vec4((_2235 * _2231.w) + cross(_2235, _2234), -dot(_2235, _2234));
	                                            vec3 _2243 = _2242.xyz;
	                                            float _2244 = _2229.w;
	                                            vec3 _2246 = _2229.xyz;
	                                            float _2247 = _2242.w;
	                                            vec3 _2255 = vec4(((_2243 * _2244) + (_2246 * _2247)) + cross(_2246, _2243), _314).xyz;
	                                            vec2 _2264 = vec2(atan(_2255.y, -_2255.x) * 0.15915493667125701904296875, acos(_2255.z) * 0.3183098733425140380859375);
	                                            vec2 _2269 = (_2264.xy * g_Lights_1._m0[_2035].m_vCookieParameters.zw) + g_Lights_1._m0[_2035].m_vCookieParameters.xy;
	                                            vec2 _2271 = _2264;
	                                            _2271.x = _2269.x;
	                                            _2271.y = _2269.y;
	                                            _701 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_2035].m_nCookie], g_Sampler), _2271, 0.0).xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _2208 = fma(_2186.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                            vec2 _2213 = (_2208.xy * g_Lights_1._m0[_2035].m_vCookieParameters.zw) + g_Lights_1._m0[_2035].m_vCookieParameters.xy;
	                                            vec2 _2215 = _2208;
	                                            _2215.x = _2213.x;
	                                            _2215.y = _2213.y;
	                                            _701 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_2035].m_nCookie], g_CookieSampler), _2215, 0.0).xyz;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _701 = vec3(1.0);
	                                    }
	                                    _702 *= _701;
	                                }
	                                if (g_Lights_1._m0[_2035].m_nLuminaireType != 0)
	                                {
	                                    _702 = (_702 * g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                }
	                                else
	                                {
	                                    if (!(g_Lights_1._m0[_2035].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _2291 = g_Lights_1._m0[_2035].m_vLightPosition.xyz - _1986;
	                                        _702 *= (vec3(g_Lights_1._m0[_2035].m_vLightPosition.w) / max(vec3(dot(_2291, _2291)), vec3(g_Lights_1._m0[_2035].m_vLightPosition.w)));
	                                    }
	                                }
	                                if (g_Lights_1._m0[_2035].m_vDistanceFade_vSkirt.z > 0.0)
	                                {
	                                    _698 = smoothstep(0.0, 1.0, _2186.xyz.z * g_Lights_1._m0[_2035].m_vDistanceFade_vSkirt.z);
	                                }
	                                else
	                                {
	                                    _698 = 1.0;
	                                }
	                                if (g_Lights_1._m0[_2035].m_vDistanceFade_vSkirt.w > 0.0)
	                                {
	                                    _698 *= smoothstep(0.0, 1.0, (1.0 - _2186.xyz.z) * g_Lights_1._m0[_2035].m_vDistanceFade_vSkirt.w);
	                                }
	                                if (!(g_Lights_1._m0[_2035].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _2332 = g_Lights_1._m0[_2035].m_vLightPosition.xyz - _1986;
	                                    float _2333 = length(_2332);
	                                    vec3 _2335 = _2332 / vec3(_2333);
	                                    float _2341 = _698 * smoothstep(0.0, 1.0, g_Lights_1._m0[_2035].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_2035].m_vDistanceFade_vSkirt.y * _2333));
	                                    if (g_Lights_1._m0[_2035].m_nLuminaireType != 2)
	                                    {
	                                        _700 = g_Lights_1._m0[_2035].m_nLuminaireType != 1;
	                                    }
	                                    else
	                                    {
	                                        _700 = false;
	                                    }
	                                    if (_700)
	                                    {
	                                        float _2353 = 2.0 * g_Lights_1._m0[_2035].m_vOrientation.x;
	                                        float _2357 = 2.0 * g_Lights_1._m0[_2035].m_vOrientation.w;
	                                        vec3 _2371 = vec3((_2353 * g_Lights_1._m0[_2035].m_vOrientation.y) - (_2357 * g_Lights_1._m0[_2035].m_vOrientation.z), (1.0 - (_2353 * g_Lights_1._m0[_2035].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_2035].m_vOrientation.z) * g_Lights_1._m0[_2035].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_2035].m_vOrientation.y) * g_Lights_1._m0[_2035].m_vOrientation.z) + (_2357 * g_Lights_1._m0[_2035].m_vOrientation.x)) * g_Lights_1._m0[_2035].m_vAngleFade.z;
	                                        vec3 _2372 = _2335 - _2371;
	                                        vec3 _2373 = _2335 + _2371;
	                                        do
	                                        {
	                                            vec3 _2376 = _2373 - _2372;
	                                            float _2378 = dot(-_2372, _2376);
	                                            if (_2378 <= 0.0)
	                                            {
	                                                _696 = _2372;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _2383 = dot(_2376, _2376);
	                                                if (_2378 > _2383)
	                                                {
	                                                    _696 = _2373;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    _696 = _2372 + (_2376 * (_2378 / _2383));
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (any(notEqual(_696, vec3(0.0))))
	                                        {
	                                            _697 = normalize(_696);
	                                        }
	                                        else
	                                        {
	                                            _697 = _696;
	                                        }
	                                        float _2407 = 2.0 * g_Lights_1._m0[_2035].m_vOrientation.x;
	                                        float _2410 = 2.0 * g_Lights_1._m0[_2035].m_vOrientation.w;
	                                        _699 = _2341 * clamp(g_Lights_1._m0[_2035].m_vAngleFade.x + (g_Lights_1._m0[_2035].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_2035].m_vOrientation.y) * g_Lights_1._m0[_2035].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_2035].m_vOrientation.z) * g_Lights_1._m0[_2035].m_vOrientation.z), (_2407 * g_Lights_1._m0[_2035].m_vOrientation.y) + (_2410 * g_Lights_1._m0[_2035].m_vOrientation.z), (_2407 * g_Lights_1._m0[_2035].m_vOrientation.z) - (_2410 * g_Lights_1._m0[_2035].m_vOrientation.y)), _697)), 0.0, 1.0);
	                                    }
	                                    else
	                                    {
	                                        _699 = _2341;
	                                    }
	                                }
	                                else
	                                {
	                                    _699 = _698;
	                                }
	                                if (g_Lights_1._m0[_2035].m_nCookie == (-1))
	                                {
	                                    do
	                                    {
	                                        vec2 _2434 = abs(_2186.xyz.xy);
	                                        if (g_Lights_1._m0[_2035].m_vCookieParameters.z == 0.0)
	                                        {
	                                            _694 = smoothstep(1.0, g_Lights_1._m0[_2035].m_vCookieParameters.x, _2434.x) * smoothstep(1.0, g_Lights_1._m0[_2035].m_vCookieParameters.y, _2434.y);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _2439 = _2434.x;
	                                            float _2443 = _2434.y;
	                                            float _2450 = (-0.5) * g_Lights_1._m0[_2035].m_vCookieParameters.z;
	                                            float _2452 = (g_Lights_1._m0[_2035].m_vCookieParameters.x * g_Lights_1._m0[_2035].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_2035].m_vCookieParameters.y * _2439, 2.0 / g_Lights_1._m0[_2035].m_vCookieParameters.z) + pow(g_Lights_1._m0[_2035].m_vCookieParameters.x * _2443, 2.0 / g_Lights_1._m0[_2035].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2450);
	                                            float _2459 = pow(max(pow(_2439, 2.0 / g_Lights_1._m0[_2035].m_vCookieParameters.z) + pow(_2443, 2.0 / g_Lights_1._m0[_2035].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2450);
	                                            if (_2452 < _2459)
	                                            {
	                                                _694 = smoothstep(_2459, _2452, 1.0);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                if (_2459 > 1.0)
	                                                {
	                                                    _695 = 1.0;
	                                                }
	                                                else
	                                                {
	                                                    _695 = 0.0;
	                                                }
	                                                _694 = _695;
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _699 *= _694;
	                                }
	                                _705 = _702 * _699;
	                                break;
	                            } while(false);
	                            if (any(greaterThan(_705, vec3(0.0))))
	                            {
	                                _692 = false;
	                                do
	                                {
	                                    switch (g_Lights_1._m0[_2035].m_nLuminaireType)
	                                    {
	                                        case 0:
	                                        {
	                                            _710 = 1.0;
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2035].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _667 = vec4(normalize(g_Lights_1._m0[_2035].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2947 = g_Lights_1._m0[_2035].m_vLightPosition.xyz - _1986;
	                                                    float _2948 = length(_2947);
	                                                    _667 = vec4(_2947 / vec3(_2948), _2948);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _692 = true;
	                                            _693 = _667;
	                                            break;
	                                        }
	                                        case 1:
	                                        {
	                                            vec3 _2797 = g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].xyz;
	                                            vec3 _2799 = g_Lights_1._m0[_2035].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].xyz;
	                                            float _2800 = length(_2797);
	                                            float _2801 = length(_2799);
	                                            vec3 _2803 = _2797 / vec3(_2800);
	                                            vec3 _2805 = _2799 / vec3(_2801);
	                                            vec3 _2806 = cross(_2803, _2805);
	                                            vec3 _2807 = g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].xyz - _1986;
	                                            float _2808 = dot(_2807, _2806);
	                                            if (_2808 > 0.0)
	                                            {
	                                                _669 = _2808 * (-1.0);
	                                                _670 = _2806 * (-1.0);
	                                            }
	                                            else
	                                            {
	                                                _669 = _2808;
	                                                _670 = _2806;
	                                            }
	                                            float _2817 = dot(_2807, _2803);
	                                            float _2818 = dot(_2807, _2805);
	                                            float _2819 = _2817 + _2800;
	                                            float _2820 = _2818 + _2801;
	                                            vec3 _2823 = vec3(_2817, _2818, _669);
	                                            vec3 _2824 = vec3(_2817, _2820, _669);
	                                            vec3 _2825 = vec3(_2819, _2818, _669);
	                                            vec3 _2826 = vec3(_2819, _2820, _669);
	                                            vec3 _2828 = normalize(cross(_2823, _2825));
	                                            vec3 _2830 = normalize(cross(_2825, _2826));
	                                            vec3 _2832 = normalize(cross(_2826, _2824));
	                                            vec3 _2834 = normalize(cross(_2824, _2823));
	                                            float _2851 = _2828.z;
	                                            float _2855 = (6.283185482025146484375 - acos(clamp(-dot(_2832, _2834), -1.0, 1.0))) - acos(clamp(-dot(_2834, _2828), -1.0, 1.0));
	                                            float _2857 = (acos(clamp(-dot(_2828, _2830), -1.0, 1.0)) + acos(clamp(-dot(_2830, _2832), -1.0, 1.0))) - _2855;
	                                            if (isnan(_2857))
	                                            {
	                                                _671 = 0.0;
	                                            }
	                                            else
	                                            {
	                                                _671 = _2857;
	                                            }
	                                            float _2865 = (_1973.x * _671) + _2855;
	                                            float _2870 = ((cos(_2865) * _2851) - _2832.z) / sin(_2865);
	                                            if (_2870 > 0.0)
	                                            {
	                                                _672 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _672 = -1.0;
	                                            }
	                                            float _2879 = _672;
	                                            float _2881 = clamp((1.0 / sqrt((_2870 * _2870) + (_2851 * _2851))) * _2879, -1.0, 1.0);
	                                            float _2889 = clamp((-(_2881 * _669)) / sqrt(1.0 - (_2881 * _2881)), _2817, _2819);
	                                            float _2892 = sqrt((_2889 * _2889) + (_669 * _669));
	                                            float _2893 = _2892 * _2892;
	                                            float _2896 = _2818 / sqrt(_2893 + (_2818 * _2818));
	                                            float _2903 = _2896 + (_1973.y * ((_2820 / sqrt(_2893 + (_2820 * _2820))) - _2896));
	                                            float _2904 = _2903 * _2903;
	                                            if (_2904 < 0.99999988079071044921875)
	                                            {
	                                                _672 = (_2903 * _2892) / sqrt(1.0 - _2904);
	                                            }
	                                            else
	                                            {
	                                                _672 = _2820;
	                                            }
	                                            vec3 _2921 = ((_1986 + (_2803 * _2889)) + (_2805 * _672)) + (_670 * _669);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2035].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _668 = vec4(normalize(_2921), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2929 = _2921 - _1986;
	                                                    float _2930 = length(_2929);
	                                                    _668 = vec4(_2929 / vec3(_2930), _2930);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _710 = 1.0 / _671;
	                                            _692 = true;
	                                            _693 = _668;
	                                            break;
	                                        }
	                                        case 2:
	                                        {
	                                            do
	                                            {
	                                                vec2 _2725 = (_1973 * 2.0) - vec2(1.0);
	                                                if (all(equal(_2725, vec2(0.0))))
	                                                {
	                                                    _676 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _2730 = _2725.x;
	                                                float _2732 = _2725.y;
	                                                if (abs(_2730) > abs(_2732))
	                                                {
	                                                    _677 = _2730;
	                                                    _678 = 0.785398185253143310546875 * (_2732 / _2730);
	                                                }
	                                                else
	                                                {
	                                                    _677 = _2732;
	                                                    _678 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2730 / _2732));
	                                                }
	                                                _676 = vec2(cos(_678), sin(_678)) * _677;
	                                                break;
	                                            } while(false);
	                                            vec3 _2758 = (g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].xyz * _676.x)) + (g_Lights_1._m0[_2035].m_vLuminaireVectors.data[2].xyz * _676.y);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2035].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _675 = vec4(normalize(_2758), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2766 = _2758 - _1986;
	                                                    float _2767 = length(_2766);
	                                                    _675 = vec4(_2766 / vec3(_2767), _2767);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_675.w))
	                                            {
	                                                _673 = true;
	                                            }
	                                            else
	                                            {
	                                                _673 = isnan(_675.w);
	                                            }
	                                            if (!_673)
	                                            {
	                                                _674 = _675.w * _675.w;
	                                            }
	                                            else
	                                            {
	                                                _674 = 1.0;
	                                            }
	                                            _710 = _674 / (max(0.0, dot(g_Lights_1._m0[_2035].m_vLuminaireVectors.data[3].xyz, -_675.xyz)) * g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].w);
	                                            _692 = true;
	                                            _693 = _675;
	                                            break;
	                                        }
	                                        case 3:
	                                        {
	                                            vec3 _2624 = g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].xyz - _1986;
	                                            float _2625 = dot(_2624, _2624);
	                                            float _2626 = sqrt(_2625);
	                                            vec3 _2628 = _2624 / vec3(_2626);
	                                            float _2629 = _2628.z;
	                                            if (_2629 >= 0.0)
	                                            {
	                                                _680 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _680 = -1.0;
	                                            }
	                                            float _2636 = (-1.0) / (_680 + _2629);
	                                            float _2637 = _2628.x;
	                                            float _2638 = _2628.y;
	                                            float _2640 = (_2637 * _2638) * _2636;
	                                            vec3 _2645 = _681;
	                                            _2645.x = 1.0 + (((_680 * _2637) * _2637) * _2636);
	                                            _2645.y = _680 * _2640;
	                                            _2645.z = (-_680) * _2637;
	                                            _681 = _2645;
	                                            vec3 _2652 = _682;
	                                            _2652.x = _2640;
	                                            _2652.y = _680 + ((_2638 * _2638) * _2636);
	                                            _2652.z = -_2638;
	                                            _682 = _2652;
	                                            float _2660 = g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].x;
	                                            float _2664 = sqrt(max(0.0, 1.0 - (_2660 / _2625)));
	                                            float _2665 = _1973.x;
	                                            float _2668 = (1.0 - _2665) + (_2665 * _2664);
	                                            float _2672 = sqrt(max(0.0, 1.0 - (_2668 * _2668)));
	                                            float _2674 = _1973.y * 6.283185482025146484375;
	                                            float _2676 = _2626 * _2626;
	                                            float _2682 = (_2626 * _2668) - sqrt(max(0.0, _2660 - ((_2676 * _2672) * _2672)));
	                                            float _2688 = ((_2676 + _2660) - (_2682 * _2682)) / ((2.0 * _2626) * g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].x);
	                                            float _2692 = sqrt(max(0.0, 1.0 - (_2688 * _2688)));
	                                            vec3 _2704 = g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].xyz + ((mat3(-_2645, -_2652, -_2628) * vec3(cos(_2674) * _2692, sin(_2674) * _2692, _2688)) * g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].x);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2035].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _679 = vec4(normalize(_2704), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2712 = _2704 - _1986;
	                                                    float _2713 = length(_2712);
	                                                    _679 = vec4(_2712 / vec3(_2713), _2713);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _710 = 0.15915493667125701904296875 / (1.0 - _2664);
	                                            _692 = true;
	                                            _693 = _679;
	                                            break;
	                                        }
	                                        case 4:
	                                        case 5:
	                                        {
	                                            vec2 _689 = _1973;
	                                            if (_1973.x < g_Lights_1._m0[_2035].m_vLuminaireVectors.data[4].y)
	                                            {
	                                                vec2 _2525 = _689;
	                                                _2525.x = clamp(_2525.x / g_Lights_1._m0[_2035].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                                _689 = _2525;
	                                                vec3 _2531 = normalize(g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].xyz);
	                                                if (_2525.x >= 0.5)
	                                                {
	                                                    vec2 _2542 = _689;
	                                                    _2542.x = clamp((2.0 * _2542.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                    _689 = _2542;
	                                                    _690 = -_2531;
	                                                    _691 = g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].xyz;
	                                                }
	                                                else
	                                                {
	                                                    vec2 _2537 = _689;
	                                                    _2537.x = clamp(2.0 * _2537.x, 0.0, 0.99999988079071044921875);
	                                                    _689 = _2537;
	                                                    _690 = _2531;
	                                                    _691 = g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].xyz;
	                                                }
	                                                do
	                                                {
	                                                    vec2 _2553 = (_689 * 2.0) - vec2(1.0);
	                                                    if (all(equal(_2553, vec2(0.0))))
	                                                    {
	                                                        _686 = vec2(0.0);
	                                                        break;
	                                                    }
	                                                    float _2558 = _2553.x;
	                                                    float _2560 = _2553.y;
	                                                    if (abs(_2558) > abs(_2560))
	                                                    {
	                                                        _687 = _2558;
	                                                        _688 = 0.785398185253143310546875 * (_2560 / _2558);
	                                                    }
	                                                    else
	                                                    {
	                                                        _687 = _2560;
	                                                        _688 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2558 / _2560));
	                                                    }
	                                                    _686 = vec2(cos(_688), sin(_688)) * _687;
	                                                    break;
	                                                } while(false);
	                                                _691 += ((g_Lights_1._m0[_2035].m_vLuminaireVectors.data[2].xyz * _686.x) + (g_Lights_1._m0[_2035].m_vLuminaireVectors.data[3].xyz * _686.y));
	                                            }
	                                            else
	                                            {
	                                                vec2 _2504 = _689;
	                                                _2504.x = clamp((_2504.x - g_Lights_1._m0[_2035].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_2035].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                                _689 = _2504;
	                                                vec3 _2519 = (g_Lights_1._m0[_2035].m_vLuminaireVectors.data[2].xyz * cos(_2504.x * 6.283185482025146484375)) + (g_Lights_1._m0[_2035].m_vLuminaireVectors.data[3].xyz * sin(_2504.x * 6.283185482025146484375));
	                                                _690 = normalize(_2519);
	                                                _691 = mix(g_Lights_1._m0[_2035].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].xyz, vec3(_2504.y)) + _2519;
	                                            }
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2035].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _685 = vec4(normalize(_691), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2593 = _691 - _1986;
	                                                    float _2594 = length(_2593);
	                                                    _685 = vec4(_2593 / vec3(_2594), _2594);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_685.w))
	                                            {
	                                                _683 = true;
	                                            }
	                                            else
	                                            {
	                                                _683 = isnan(_685.w);
	                                            }
	                                            if (!_683)
	                                            {
	                                                _684 = _685.w * _685.w;
	                                            }
	                                            else
	                                            {
	                                                _684 = 1.0;
	                                            }
	                                            _710 = _684 / (max(0.0, dot(_690, -_685.xyz)) * g_Lights_1._m0[_2035].m_vLuminaireVectors.data[1].w);
	                                            _692 = true;
	                                            _693 = _685;
	                                            break;
	                                        }
	                                        default:
	                                        {
	                                            _710 = 0.0;
	                                            _692 = true;
	                                            _693 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                            break;
	                                        }
	                                    }
	                                    if (_692)
	                                    {
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                bool _2964 = !(dot(_438, _693.xyz) > 0.0);
	                                vec3 _2965 = vec3(_337);
	                                vec3 _2968 = transpose(mat3(_375, _374, _2965)) * _693.xyz;
	                                do
	                                {
	                                    if (_2964)
	                                    {
	                                        if ((_331 & 65535u) == 1u)
	                                        {
	                                            _662 = any(greaterThan(vec3(_330.xyz), vec3(0.0)));
	                                        }
	                                        else
	                                        {
	                                            _662 = false;
	                                        }
	                                        if (_662)
	                                        {
	                                            _666 = vec3(_330.xyz);
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
	                                        vec3 _2977 = vec3(mix(f16vec3(_332), _335, f16vec3(_336)));
	                                        float _2978 = float(_334);
	                                        do
	                                        {
	                                            float _2981 = _2968.z;
	                                            vec3 _2983 = _2968 + _371;
	                                            if (_2981 <= 0.0)
	                                            {
	                                                _664 = true;
	                                            }
	                                            else
	                                            {
	                                                _664 = _371.z <= 0.0;
	                                            }
	                                            if (_664)
	                                            {
	                                                _663 = vec3(0.0);
	                                                break;
	                                            }
	                                            if (all(equal(_2983, vec3(0.0))))
	                                            {
	                                                _663 = vec3(0.0);
	                                                break;
	                                            }
	                                            vec3 _2996 = normalize(_2983);
	                                            float _2997 = _2996.z;
	                                            float _3005 = _2978 * _2978;
	                                            float _3006 = _3005 * _3005;
	                                            float _3010 = (((_2997 * _3006) - _2997) * _2997) + 1.0;
	                                            float _3014 = _2978 * _2978;
	                                            float _3015 = _3014 * _3014;
	                                            _663 = (_2977 + ((vec3(1.0) - _2977) * pow(max(0.0, 1.0 - dot(_2968, _2996)), 5.0))) * (((_3006 / max(9.9999999392252902907785028219223e-09, _3010 * _3010)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_2981 * sqrt(((_371.z - (_3015 * _371.z)) * _371.z) + _3015)) + (_371.z * sqrt(((_2981 - (_3015 * _2981)) * _2981) + _3015))))) * 0.3183098733425140380859375);
	                                            break;
	                                        } while(false);
	                                        _665 = ((vec3(_335) * (1.0 - float(_336))) * 0.3183098733425140380859375) + _663;
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                float _3061 = dot(_2965, _693.xyz);
	                                if (_2964)
	                                {
	                                    _661 = -_3061;
	                                }
	                                else
	                                {
	                                    _661 = _3061;
	                                }
	                                _709 += (((_705 / vec3(_710)) * (_665 * 3.1415927410125732421875)) * max(0.0, _661));
	                            }
	                            _708 = _2037;
	                            break;
	                        } while(false);
	                        if (_2024_ladder_break)
	                        {
	                            break;
	                        }
	                        continue;
	                    }
	                    _706++;
	                    _707 = _709;
	                    continue;
	                }
	                if (_714)
	                {
	                    vec2 _652 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_819.xy, int(1u + (_820 + uint(_734))))))).xy;
	                    vec3 _3084 = (_440 + _439) * 0.5;
	                    float _653 = 0.0;
	                    vec3 _475 = vec3(0.0);
	                    vec3 _474 = vec3(0.0);
	                    vec4 _473 = vec4(0.0);
	                    int _476 = -1;
	                    uvec3 _3089 = min(uvec3(max(fma(_3084, _844, _846), vec3(0.0))), (_841 - uvec3(1u)));
	                    float _654 = 0.0;
	                    uint _655 = 0u;
	                    for (;;)
	                    {
	                        if (!(_655 < _840))
	                        {
	                            break;
	                        }
	                        uint _3102 = _840 * _841.x;
	                        float _657 = _654;
	                        uint _658 = subgroupOr(g_LightBins_1._m0[((((_3102 * _841.y) * _3089.z) + (_3102 * _3089.y)) + (_840 * _3089.x)) + _655]);
	                        for (;;)
	                        {
	                            bool _3122_ladder_break = false;
	                            do
	                            {
	                                if (!(_658 != 0u))
	                                {
	                                    _3122_ladder_break = true;
	                                    break;
	                                }
	                                uint _3129 = _658;
	                                uint _3133 = uint(findLSB(_3129)) + (_655 * 32u);
	                                uint _3135 = _3129 & (_3129 - 1u);
	                                mat4 _3165 = mat4(vec4(g_Lights_1._m0[_3133].m_mToClipSpace.data[0].x, g_Lights_1._m0[_3133].m_mToClipSpace.data[1].x, g_Lights_1._m0[_3133].m_mToClipSpace.data[2].x, g_Lights_1._m0[_3133].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_3133].m_mToClipSpace.data[0].y, g_Lights_1._m0[_3133].m_mToClipSpace.data[1].y, g_Lights_1._m0[_3133].m_mToClipSpace.data[2].y, g_Lights_1._m0[_3133].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_3133].m_mToClipSpace.data[0].z, g_Lights_1._m0[_3133].m_mToClipSpace.data[1].z, g_Lights_1._m0[_3133].m_mToClipSpace.data[2].z, g_Lights_1._m0[_3133].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_3133].m_mToClipSpace.data[0].w, g_Lights_1._m0[_3133].m_mToClipSpace.data[1].w, g_Lights_1._m0[_3133].m_mToClipSpace.data[2].w, g_Lights_1._m0[_3133].m_mToClipSpace.data[3].w));
	                                if ((uint(g_Lights_1._m0[_3133].m_nPathTraceFlags) & 1u) == 0u)
	                                {
	                                    _658 = _3135;
	                                    break;
	                                }
	                                if (!((g_Lights_1._m0[_3133].m_nPathTraceFlags & 8) != 0))
	                                {
	                                    _658 = _3135;
	                                    break;
	                                }
	                                do
	                                {
	                                    do
	                                    {
	                                        vec4 _3241 = _3165 * vec4(_3084.xyz, 1.0);
	                                        vec3 _3245 = _3241.xyz / vec3(_3241.w);
	                                        vec4 _3247;
	                                        _3247.x = _3245.x;
	                                        _3247.y = _3245.y;
	                                        _3247.z = _3245.z;
	                                        if (all(greaterThanEqual(_3247.xyz, vec3(-1.0, -1.0, 0.0))))
	                                        {
	                                            _649 = all(lessThanEqual(_3247.xyz, vec3(1.0)));
	                                        }
	                                        else
	                                        {
	                                            _649 = false;
	                                        }
	                                        if (!_649)
	                                        {
	                                            _650 = false;
	                                            break;
	                                        }
	                                        if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_3133].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_3084, 1.0)).xyz), vec3(1.0))))
	                                        {
	                                            _650 = false;
	                                            break;
	                                        }
	                                        _650 = true;
	                                        break;
	                                    } while(false);
	                                    if (!_650)
	                                    {
	                                        _651 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec4 _3279 = _3165 * vec4(_3084.xyz, 1.0);
	                                    vec3 _3283 = _3279.xyz / vec3(_3279.w);
	                                    vec4 _3285;
	                                    _3285.x = _3283.x;
	                                    _3285.y = _3283.y;
	                                    _3285.z = _3283.z;
	                                    if (_1939)
	                                    {
	                                        _648 = g_Lights_1._m0[_3133].m_vBounceColor.xyz;
	                                    }
	                                    else
	                                    {
	                                        _648 = g_Lights_1._m0[_3133].m_vColor.xyz;
	                                    }
	                                    if (true)
	                                    {
	                                        if (g_Lights_1._m0[_3133].m_nCookie >= 0)
	                                        {
	                                            if (g_Lights_1._m0[_3133].m_bSphericalCookie != 0)
	                                            {
	                                                vec4 _3328 = vec4(-g_Lights_1._m0[_3133].m_vOrientation.xyz, g_Lights_1._m0[_3133].m_vOrientation.w);
	                                                vec4 _3330 = _3328.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                                vec3 _3333 = _3330.xyz;
	                                                vec3 _3334 = vec4((-normalize(g_Lights_1._m0[_3133].m_vLightPosition.xyz - _3084)).xyz, 0.0).xyz;
	                                                vec4 _3341 = vec4((_3334 * _3330.w) + cross(_3334, _3333), -dot(_3334, _3333));
	                                                vec3 _3342 = _3341.xyz;
	                                                float _3343 = _3328.w;
	                                                vec3 _3345 = _3328.xyz;
	                                                float _3346 = _3341.w;
	                                                vec3 _3354 = vec4(((_3342 * _3343) + (_3345 * _3346)) + cross(_3345, _3342), _314).xyz;
	                                                vec2 _3363 = vec2(atan(_3354.y, -_3354.x) * 0.15915493667125701904296875, acos(_3354.z) * 0.3183098733425140380859375);
	                                                vec2 _3368 = (_3363.xy * g_Lights_1._m0[_3133].m_vCookieParameters.zw) + g_Lights_1._m0[_3133].m_vCookieParameters.xy;
	                                                vec2 _3370 = _3363;
	                                                _3370.x = _3368.x;
	                                                _3370.y = _3368.y;
	                                                _647 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_3133].m_nCookie], g_Sampler), _3370, 0.0).xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _3307 = fma(_3285.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                                vec2 _3312 = (_3307.xy * g_Lights_1._m0[_3133].m_vCookieParameters.zw) + g_Lights_1._m0[_3133].m_vCookieParameters.xy;
	                                                vec2 _3314 = _3307;
	                                                _3314.x = _3312.x;
	                                                _3314.y = _3312.y;
	                                                _647 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_3133].m_nCookie], g_CookieSampler), _3314, 0.0).xyz;
	                                            }
	                                        }
	                                        else
	                                        {
	                                            _647 = vec3(1.0);
	                                        }
	                                        _648 *= _647;
	                                    }
	                                    if (g_Lights_1._m0[_3133].m_nLuminaireType != 0)
	                                    {
	                                        _648 = (_648 * g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                    }
	                                    else
	                                    {
	                                        if (!(g_Lights_1._m0[_3133].m_vLightPosition.w == 0.0))
	                                        {
	                                            vec3 _3390 = g_Lights_1._m0[_3133].m_vLightPosition.xyz - _3084;
	                                            _648 *= (vec3(g_Lights_1._m0[_3133].m_vLightPosition.w) / max(vec3(dot(_3390, _3390)), vec3(g_Lights_1._m0[_3133].m_vLightPosition.w)));
	                                        }
	                                    }
	                                    if (g_Lights_1._m0[_3133].m_vDistanceFade_vSkirt.z > 0.0)
	                                    {
	                                        _644 = smoothstep(0.0, 1.0, _3285.xyz.z * g_Lights_1._m0[_3133].m_vDistanceFade_vSkirt.z);
	                                    }
	                                    else
	                                    {
	                                        _644 = 1.0;
	                                    }
	                                    if (g_Lights_1._m0[_3133].m_vDistanceFade_vSkirt.w > 0.0)
	                                    {
	                                        _644 *= smoothstep(0.0, 1.0, (1.0 - _3285.xyz.z) * g_Lights_1._m0[_3133].m_vDistanceFade_vSkirt.w);
	                                    }
	                                    if (!(g_Lights_1._m0[_3133].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _3431 = g_Lights_1._m0[_3133].m_vLightPosition.xyz - _3084;
	                                        float _3432 = length(_3431);
	                                        vec3 _3434 = _3431 / vec3(_3432);
	                                        float _3440 = _644 * smoothstep(0.0, 1.0, g_Lights_1._m0[_3133].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_3133].m_vDistanceFade_vSkirt.y * _3432));
	                                        if (g_Lights_1._m0[_3133].m_nLuminaireType != 2)
	                                        {
	                                            _646 = g_Lights_1._m0[_3133].m_nLuminaireType != 1;
	                                        }
	                                        else
	                                        {
	                                            _646 = false;
	                                        }
	                                        if (_646)
	                                        {
	                                            float _3452 = 2.0 * g_Lights_1._m0[_3133].m_vOrientation.x;
	                                            float _3456 = 2.0 * g_Lights_1._m0[_3133].m_vOrientation.w;
	                                            vec3 _3470 = vec3((_3452 * g_Lights_1._m0[_3133].m_vOrientation.y) - (_3456 * g_Lights_1._m0[_3133].m_vOrientation.z), (1.0 - (_3452 * g_Lights_1._m0[_3133].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_3133].m_vOrientation.z) * g_Lights_1._m0[_3133].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_3133].m_vOrientation.y) * g_Lights_1._m0[_3133].m_vOrientation.z) + (_3456 * g_Lights_1._m0[_3133].m_vOrientation.x)) * g_Lights_1._m0[_3133].m_vAngleFade.z;
	                                            vec3 _3471 = _3434 - _3470;
	                                            vec3 _3472 = _3434 + _3470;
	                                            do
	                                            {
	                                                vec3 _3475 = _3472 - _3471;
	                                                float _3477 = dot(-_3471, _3475);
	                                                if (_3477 <= 0.0)
	                                                {
	                                                    _642 = _3471;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    float _3482 = dot(_3475, _3475);
	                                                    if (_3477 > _3482)
	                                                    {
	                                                        _642 = _3472;
	                                                        break;
	                                                    }
	                                                    else
	                                                    {
	                                                        _642 = _3471 + (_3475 * (_3477 / _3482));
	                                                        break;
	                                                    }
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (any(notEqual(_642, vec3(0.0))))
	                                            {
	                                                _643 = normalize(_642);
	                                            }
	                                            else
	                                            {
	                                                _643 = _642;
	                                            }
	                                            float _3506 = 2.0 * g_Lights_1._m0[_3133].m_vOrientation.x;
	                                            float _3509 = 2.0 * g_Lights_1._m0[_3133].m_vOrientation.w;
	                                            _645 = _3440 * clamp(g_Lights_1._m0[_3133].m_vAngleFade.x + (g_Lights_1._m0[_3133].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_3133].m_vOrientation.y) * g_Lights_1._m0[_3133].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_3133].m_vOrientation.z) * g_Lights_1._m0[_3133].m_vOrientation.z), (_3506 * g_Lights_1._m0[_3133].m_vOrientation.y) + (_3509 * g_Lights_1._m0[_3133].m_vOrientation.z), (_3506 * g_Lights_1._m0[_3133].m_vOrientation.z) - (_3509 * g_Lights_1._m0[_3133].m_vOrientation.y)), _643)), 0.0, 1.0);
	                                        }
	                                        else
	                                        {
	                                            _645 = _3440;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _645 = _644;
	                                    }
	                                    if (g_Lights_1._m0[_3133].m_nCookie == (-1))
	                                    {
	                                        do
	                                        {
	                                            vec2 _3533 = abs(_3285.xyz.xy);
	                                            if (g_Lights_1._m0[_3133].m_vCookieParameters.z == 0.0)
	                                            {
	                                                _640 = smoothstep(1.0, g_Lights_1._m0[_3133].m_vCookieParameters.x, _3533.x) * smoothstep(1.0, g_Lights_1._m0[_3133].m_vCookieParameters.y, _3533.y);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _3538 = _3533.x;
	                                                float _3542 = _3533.y;
	                                                float _3549 = (-0.5) * g_Lights_1._m0[_3133].m_vCookieParameters.z;
	                                                float _3551 = (g_Lights_1._m0[_3133].m_vCookieParameters.x * g_Lights_1._m0[_3133].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_3133].m_vCookieParameters.y * _3538, 2.0 / g_Lights_1._m0[_3133].m_vCookieParameters.z) + pow(g_Lights_1._m0[_3133].m_vCookieParameters.x * _3542, 2.0 / g_Lights_1._m0[_3133].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3549);
	                                                float _3558 = pow(max(pow(_3538, 2.0 / g_Lights_1._m0[_3133].m_vCookieParameters.z) + pow(_3542, 2.0 / g_Lights_1._m0[_3133].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3549);
	                                                if (_3551 < _3558)
	                                                {
	                                                    _640 = smoothstep(_3558, _3551, 1.0);
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    if (_3558 > 1.0)
	                                                    {
	                                                        _641 = 1.0;
	                                                    }
	                                                    else
	                                                    {
	                                                        _641 = 0.0;
	                                                    }
	                                                    _640 = _641;
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _645 *= _640;
	                                    }
	                                    _651 = _648 * _645;
	                                    break;
	                                } while(false);
	                                float _3581 = dot(_651.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                if (_3581 == 0.0)
	                                {
	                                    _658 = _3135;
	                                    break;
	                                }
	                                _638 = false;
	                                do
	                                {
	                                    switch (g_Lights_1._m0[_3133].m_nLuminaireType)
	                                    {
	                                        case 0:
	                                        {
	                                            _659 = 1.0;
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3133].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _613 = vec4(normalize(g_Lights_1._m0[_3133].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _4047 = g_Lights_1._m0[_3133].m_vLightPosition.xyz - _3084;
	                                                    float _4048 = length(_4047);
	                                                    _613 = vec4(_4047 / vec3(_4048), _4048);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _638 = true;
	                                            _639 = _613;
	                                            break;
	                                        }
	                                        case 1:
	                                        {
	                                            vec3 _3897 = g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].xyz;
	                                            vec3 _3899 = g_Lights_1._m0[_3133].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].xyz;
	                                            float _3900 = length(_3897);
	                                            float _3901 = length(_3899);
	                                            vec3 _3903 = _3897 / vec3(_3900);
	                                            vec3 _3905 = _3899 / vec3(_3901);
	                                            vec3 _3906 = cross(_3903, _3905);
	                                            vec3 _3907 = g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].xyz - _3084;
	                                            float _3908 = dot(_3907, _3906);
	                                            if (_3908 > 0.0)
	                                            {
	                                                _615 = _3908 * (-1.0);
	                                                _616 = _3906 * (-1.0);
	                                            }
	                                            else
	                                            {
	                                                _615 = _3908;
	                                                _616 = _3906;
	                                            }
	                                            float _3917 = dot(_3907, _3903);
	                                            float _3918 = dot(_3907, _3905);
	                                            float _3919 = _3917 + _3900;
	                                            float _3920 = _3918 + _3901;
	                                            vec3 _3923 = vec3(_3917, _3918, _615);
	                                            vec3 _3924 = vec3(_3917, _3920, _615);
	                                            vec3 _3925 = vec3(_3919, _3918, _615);
	                                            vec3 _3926 = vec3(_3919, _3920, _615);
	                                            vec3 _3928 = normalize(cross(_3923, _3925));
	                                            vec3 _3930 = normalize(cross(_3925, _3926));
	                                            vec3 _3932 = normalize(cross(_3926, _3924));
	                                            vec3 _3934 = normalize(cross(_3924, _3923));
	                                            float _3951 = _3928.z;
	                                            float _3955 = (6.283185482025146484375 - acos(clamp(-dot(_3932, _3934), -1.0, 1.0))) - acos(clamp(-dot(_3934, _3928), -1.0, 1.0));
	                                            float _3957 = (acos(clamp(-dot(_3928, _3930), -1.0, 1.0)) + acos(clamp(-dot(_3930, _3932), -1.0, 1.0))) - _3955;
	                                            if (isnan(_3957))
	                                            {
	                                                _617 = 0.0;
	                                            }
	                                            else
	                                            {
	                                                _617 = _3957;
	                                            }
	                                            float _3965 = (_1973.x * _617) + _3955;
	                                            float _3970 = ((cos(_3965) * _3951) - _3932.z) / sin(_3965);
	                                            if (_3970 > 0.0)
	                                            {
	                                                _618 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _618 = -1.0;
	                                            }
	                                            float _3979 = _618;
	                                            float _3981 = clamp((1.0 / sqrt((_3970 * _3970) + (_3951 * _3951))) * _3979, -1.0, 1.0);
	                                            float _3989 = clamp((-(_3981 * _615)) / sqrt(1.0 - (_3981 * _3981)), _3917, _3919);
	                                            float _3992 = sqrt((_3989 * _3989) + (_615 * _615));
	                                            float _3993 = _3992 * _3992;
	                                            float _3996 = _3918 / sqrt(_3993 + (_3918 * _3918));
	                                            float _4003 = _3996 + (_1973.y * ((_3920 / sqrt(_3993 + (_3920 * _3920))) - _3996));
	                                            float _4004 = _4003 * _4003;
	                                            if (_4004 < 0.99999988079071044921875)
	                                            {
	                                                _618 = (_4003 * _3992) / sqrt(1.0 - _4004);
	                                            }
	                                            else
	                                            {
	                                                _618 = _3920;
	                                            }
	                                            vec3 _4021 = ((_3084 + (_3903 * _3989)) + (_3905 * _618)) + (_616 * _615);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3133].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _614 = vec4(normalize(_4021), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _4029 = _4021 - _3084;
	                                                    float _4030 = length(_4029);
	                                                    _614 = vec4(_4029 / vec3(_4030), _4030);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _659 = 1.0 / _617;
	                                            _638 = true;
	                                            _639 = _614;
	                                            break;
	                                        }
	                                        case 2:
	                                        {
	                                            do
	                                            {
	                                                vec2 _3825 = (_1973 * 2.0) - vec2(1.0);
	                                                if (all(equal(_3825, vec2(0.0))))
	                                                {
	                                                    _622 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _3830 = _3825.x;
	                                                float _3832 = _3825.y;
	                                                if (abs(_3830) > abs(_3832))
	                                                {
	                                                    _623 = _3830;
	                                                    _624 = 0.785398185253143310546875 * (_3832 / _3830);
	                                                }
	                                                else
	                                                {
	                                                    _623 = _3832;
	                                                    _624 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3830 / _3832));
	                                                }
	                                                _622 = vec2(cos(_624), sin(_624)) * _623;
	                                                break;
	                                            } while(false);
	                                            vec3 _3858 = (g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].xyz * _622.x)) + (g_Lights_1._m0[_3133].m_vLuminaireVectors.data[2].xyz * _622.y);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3133].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _621 = vec4(normalize(_3858), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3866 = _3858 - _3084;
	                                                    float _3867 = length(_3866);
	                                                    _621 = vec4(_3866 / vec3(_3867), _3867);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_621.w))
	                                            {
	                                                _619 = true;
	                                            }
	                                            else
	                                            {
	                                                _619 = isnan(_621.w);
	                                            }
	                                            if (!_619)
	                                            {
	                                                _620 = _621.w * _621.w;
	                                            }
	                                            else
	                                            {
	                                                _620 = 1.0;
	                                            }
	                                            _659 = _620 / (max(0.0, dot(g_Lights_1._m0[_3133].m_vLuminaireVectors.data[3].xyz, -_621.xyz)) * g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].w);
	                                            _638 = true;
	                                            _639 = _621;
	                                            break;
	                                        }
	                                        case 3:
	                                        {
	                                            vec3 _3724 = g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].xyz - _3084;
	                                            float _3725 = dot(_3724, _3724);
	                                            float _3726 = sqrt(_3725);
	                                            vec3 _3728 = _3724 / vec3(_3726);
	                                            float _3729 = _3728.z;
	                                            if (_3729 >= 0.0)
	                                            {
	                                                _626 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _626 = -1.0;
	                                            }
	                                            float _3736 = (-1.0) / (_626 + _3729);
	                                            float _3737 = _3728.x;
	                                            float _3738 = _3728.y;
	                                            float _3740 = (_3737 * _3738) * _3736;
	                                            vec3 _3745 = _627;
	                                            _3745.x = 1.0 + (((_626 * _3737) * _3737) * _3736);
	                                            _3745.y = _626 * _3740;
	                                            _3745.z = (-_626) * _3737;
	                                            _627 = _3745;
	                                            vec3 _3752 = _628;
	                                            _3752.x = _3740;
	                                            _3752.y = _626 + ((_3738 * _3738) * _3736);
	                                            _3752.z = -_3738;
	                                            _628 = _3752;
	                                            float _3760 = g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].x;
	                                            float _3764 = sqrt(max(0.0, 1.0 - (_3760 / _3725)));
	                                            float _3765 = _1973.x;
	                                            float _3768 = (1.0 - _3765) + (_3765 * _3764);
	                                            float _3772 = sqrt(max(0.0, 1.0 - (_3768 * _3768)));
	                                            float _3774 = _1973.y * 6.283185482025146484375;
	                                            float _3776 = _3726 * _3726;
	                                            float _3782 = (_3726 * _3768) - sqrt(max(0.0, _3760 - ((_3776 * _3772) * _3772)));
	                                            float _3788 = ((_3776 + _3760) - (_3782 * _3782)) / ((2.0 * _3726) * g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].x);
	                                            float _3792 = sqrt(max(0.0, 1.0 - (_3788 * _3788)));
	                                            vec3 _3804 = g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].xyz + ((mat3(-_3745, -_3752, -_3728) * vec3(cos(_3774) * _3792, sin(_3774) * _3792, _3788)) * g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].x);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3133].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _625 = vec4(normalize(_3804), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3812 = _3804 - _3084;
	                                                    float _3813 = length(_3812);
	                                                    _625 = vec4(_3812 / vec3(_3813), _3813);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _659 = 0.15915493667125701904296875 / (1.0 - _3764);
	                                            _638 = true;
	                                            _639 = _625;
	                                            break;
	                                        }
	                                        case 4:
	                                        case 5:
	                                        {
	                                            vec2 _635 = _1973;
	                                            if (_1973.x < g_Lights_1._m0[_3133].m_vLuminaireVectors.data[4].y)
	                                            {
	                                                vec2 _3625 = _635;
	                                                _3625.x = clamp(_3625.x / g_Lights_1._m0[_3133].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                                _635 = _3625;
	                                                vec3 _3631 = normalize(g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].xyz);
	                                                if (_3625.x >= 0.5)
	                                                {
	                                                    vec2 _3642 = _635;
	                                                    _3642.x = clamp((2.0 * _3642.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                    _635 = _3642;
	                                                    _636 = -_3631;
	                                                    _637 = g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].xyz;
	                                                }
	                                                else
	                                                {
	                                                    vec2 _3637 = _635;
	                                                    _3637.x = clamp(2.0 * _3637.x, 0.0, 0.99999988079071044921875);
	                                                    _635 = _3637;
	                                                    _636 = _3631;
	                                                    _637 = g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].xyz;
	                                                }
	                                                do
	                                                {
	                                                    vec2 _3653 = (_635 * 2.0) - vec2(1.0);
	                                                    if (all(equal(_3653, vec2(0.0))))
	                                                    {
	                                                        _632 = vec2(0.0);
	                                                        break;
	                                                    }
	                                                    float _3658 = _3653.x;
	                                                    float _3660 = _3653.y;
	                                                    if (abs(_3658) > abs(_3660))
	                                                    {
	                                                        _633 = _3658;
	                                                        _634 = 0.785398185253143310546875 * (_3660 / _3658);
	                                                    }
	                                                    else
	                                                    {
	                                                        _633 = _3660;
	                                                        _634 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3658 / _3660));
	                                                    }
	                                                    _632 = vec2(cos(_634), sin(_634)) * _633;
	                                                    break;
	                                                } while(false);
	                                                _637 += ((g_Lights_1._m0[_3133].m_vLuminaireVectors.data[2].xyz * _632.x) + (g_Lights_1._m0[_3133].m_vLuminaireVectors.data[3].xyz * _632.y));
	                                            }
	                                            else
	                                            {
	                                                vec2 _3604 = _635;
	                                                _3604.x = clamp((_3604.x - g_Lights_1._m0[_3133].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_3133].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                                _635 = _3604;
	                                                vec3 _3619 = (g_Lights_1._m0[_3133].m_vLuminaireVectors.data[2].xyz * cos(_3604.x * 6.283185482025146484375)) + (g_Lights_1._m0[_3133].m_vLuminaireVectors.data[3].xyz * sin(_3604.x * 6.283185482025146484375));
	                                                _636 = normalize(_3619);
	                                                _637 = mix(g_Lights_1._m0[_3133].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].xyz, vec3(_3604.y)) + _3619;
	                                            }
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3133].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _631 = vec4(normalize(_637), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3693 = _637 - _3084;
	                                                    float _3694 = length(_3693);
	                                                    _631 = vec4(_3693 / vec3(_3694), _3694);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_631.w))
	                                            {
	                                                _629 = true;
	                                            }
	                                            else
	                                            {
	                                                _629 = isnan(_631.w);
	                                            }
	                                            if (!_629)
	                                            {
	                                                _630 = _631.w * _631.w;
	                                            }
	                                            else
	                                            {
	                                                _630 = 1.0;
	                                            }
	                                            _659 = _630 / (max(0.0, dot(_636, -_631.xyz)) * g_Lights_1._m0[_3133].m_vLuminaireVectors.data[1].w);
	                                            _638 = true;
	                                            _639 = _631;
	                                            break;
	                                        }
	                                        default:
	                                        {
	                                            _659 = 0.0;
	                                            _638 = true;
	                                            _639 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                            break;
	                                        }
	                                    }
	                                    if (_638)
	                                    {
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                float _4066 = dot(vec3(_337), _639.xyz);
	                                if ((!(dot(_438, _639.xyz) > 0.0)) && _713)
	                                {
	                                    _612 = -_4066;
	                                }
	                                else
	                                {
	                                    _612 = _4066;
	                                }
	                                float _4073 = (_3581 / _659) * max(0.0, _612);
	                                float _660 = _652.x;
	                                do
	                                {
	                                    float _4078 = _653;
	                                    float _4079 = _4078 + _4073;
	                                    _653 = _4079;
	                                    if (_4079 == 0.0)
	                                    {
	                                        _611 = false;
	                                        break;
	                                    }
	                                    float _4084 = _4073 / _653;
	                                    do
	                                    {
	                                        if (_4084 <= 0.0)
	                                        {
	                                            _610 = false;
	                                            break;
	                                        }
	                                        if (_4084 >= 1.0)
	                                        {
	                                            _610 = true;
	                                            break;
	                                        }
	                                        if (_660 < _4084)
	                                        {
	                                            _660 = min(_660 / _4084, 0.99999988079071044921875);
	                                            _610 = true;
	                                            break;
	                                        }
	                                        _660 = min((_660 - _4084) / (1.0 - _4084), 0.99999988079071044921875);
	                                        _610 = false;
	                                        break;
	                                    } while(false);
	                                    _611 = _610;
	                                    break;
	                                } while(false);
	                                vec2 _4108 = _652;
	                                _4108.x = _660;
	                                _652 = _4108;
	                                if (_611)
	                                {
	                                    _476 = int(_3133);
	                                    _475 = _651 / vec3(_659);
	                                    _473 = _639;
	                                    _657 = _4073;
	                                }
	                                _658 = _3135;
	                                break;
	                            } while(false);
	                            if (_3122_ladder_break)
	                            {
	                                break;
	                            }
	                            continue;
	                        }
	                        _654 = _657;
	                        _655++;
	                        continue;
	                    }
	                    if (_476 != (-1))
	                    {
	                        vec3 _4129 = _475;
	                        vec3 _4130 = _4129 * (_653 / _654);
	                        _475 = _4130;
	                        bool _4137 = !(dot(_438, _473.xyz) > 0.0);
	                        vec3 _4139 = vec3(_337);
	                        vec3 _4142 = transpose(mat3(_375, _374, _4139)) * _473.xyz;
	                        do
	                        {
	                            if (_4137)
	                            {
	                                if ((_331 & 65535u) == 1u)
	                                {
	                                    _605 = any(greaterThan(vec3(_330.xyz), vec3(0.0)));
	                                }
	                                else
	                                {
	                                    _605 = false;
	                                }
	                                if (_605)
	                                {
	                                    _609 = vec3(_330.xyz);
	                                }
	                                else
	                                {
	                                    _609 = vec3(1.0);
	                                }
	                                _608 = _609 * 0.3183098733425140380859375;
	                                break;
	                            }
	                            else
	                            {
	                                vec3 _4151 = vec3(mix(f16vec3(_332), _335, f16vec3(_336)));
	                                float _4152 = float(_334);
	                                do
	                                {
	                                    float _4155 = _4142.z;
	                                    vec3 _4157 = _4142 + _371;
	                                    if (_4155 <= 0.0)
	                                    {
	                                        _607 = true;
	                                    }
	                                    else
	                                    {
	                                        _607 = _371.z <= 0.0;
	                                    }
	                                    if (_607)
	                                    {
	                                        _606 = vec3(0.0);
	                                        break;
	                                    }
	                                    if (all(equal(_4157, vec3(0.0))))
	                                    {
	                                        _606 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec3 _4170 = normalize(_4157);
	                                    float _4171 = _4170.z;
	                                    float _4179 = _4152 * _4152;
	                                    float _4180 = _4179 * _4179;
	                                    float _4184 = (((_4171 * _4180) - _4171) * _4171) + 1.0;
	                                    float _4188 = _4152 * _4152;
	                                    float _4189 = _4188 * _4188;
	                                    _606 = (_4151 + ((vec3(1.0) - _4151) * pow(max(0.0, 1.0 - dot(_4142, _4170)), 5.0))) * (((_4180 / max(9.9999999392252902907785028219223e-09, _4184 * _4184)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_4155 * sqrt(((_371.z - (_4189 * _371.z)) * _371.z) + _4189)) + (_371.z * sqrt(((_4155 - (_4189 * _4155)) * _4155) + _4189))))) * 0.3183098733425140380859375);
	                                    break;
	                                } while(false);
	                                _608 = ((vec3(_335) * (1.0 - float(_336))) * 0.3183098733425140380859375) + _606;
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        vec3 _4234 = _4130 * (_608 * 3.1415927410125732421875);
	                        _475 = _4234;
	                        float _4237 = dot(_4139, _473.xyz);
	                        if (_4137)
	                        {
	                            _604 = -_4237;
	                        }
	                        else
	                        {
	                            _604 = _4237;
	                        }
	                        _475 = _4234 * max(0.0, _604);
	                        if (_4137)
	                        {
	                            if ((_331 & 65535u) == 2u)
	                            {
	                                _603 = float(_330.x) > 0.0;
	                            }
	                            else
	                            {
	                                _603 = false;
	                            }
	                            _656 = _603;
	                        }
	                        else
	                        {
	                            _656 = false;
	                        }
	                        if (_656)
	                        {
	                            float _4270 = pow(clamp(-dot(normalize(_438 + _4139), _473.xyz), 0.0, 1.0), 2.0);
	                            f16vec3 _4271 = f16vec3(vec3(0.0));
	                            if (isinf(_473.w))
	                            {
	                                _599 = true;
	                            }
	                            else
	                            {
	                                _599 = isnan(_473.w);
	                            }
	                            if (!_599)
	                            {
	                                _600 = _473.w;
	                            }
	                            else
	                            {
	                                _600 = 1000.0;
	                            }
	                            vec3 _479 = _440 + (_473.xyz * _600);
	                            float _478 = 0.0;
	                            vec3 _477 = -_473.xyz;
	                            if (_4270 > 0.0)
	                            {
	                                _601 = _600;
	                            }
	                            else
	                            {
	                                _601 = 0.0;
	                            }
	                            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _480, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_4271, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4271, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                            traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _479, _478, _477, _601, 0);
	                            if (p._m5 != (-1))
	                            {
	                                if ((p._m7._m6 & 65535u) == 2u)
	                                {
	                                    _598 = float(p._m7._m7.x) > 0.0;
	                                }
	                                else
	                                {
	                                    _598 = false;
	                                }
	                                if (!_598)
	                                {
	                                    _601 = 0.0;
	                                }
	                                else
	                                {
	                                    _601 = _4270;
	                                }
	                                _602 = _600 - p._m3;
	                            }
	                            else
	                            {
	                                _601 = _4270;
	                                _602 = _600;
	                            }
	                            uint _4328 = uint(int(uint(_330.w)));
	                            float _4332 = _602 * float(_330.x);
	                            _474 = (_4130 * vec3(_335)) * ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4328].m_vTransmissiveLogColor.xyz * (1.0 + (_4332 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4328].m_fTransmissiveSaturation))) * exp(-_4332)) * _601);
	                        }
	                    }
	                    vec4 _716 = _473;
	                    if (_476 != (-1))
	                    {
	                        bool _4363 = any(notEqual(_475, vec3(0.0)));
	                        if (isinf(_716.w))
	                        {
	                            _596 = true;
	                        }
	                        else
	                        {
	                            _596 = isnan(_716.w);
	                        }
	                        if (!_596)
	                        {
	                            _597 = _716.w;
	                        }
	                        else
	                        {
	                            _597 = 56755.83984375;
	                        }
	                        vec4 _4379 = _716;
	                        _4379.w = _597;
	                        _716 = _4379;
	                        do
	                        {
	                            float _4386 = dot(_4379.xyz, g_Lights_1._m0[_476].m_vNearPlane.xyz);
	                            if (_4386 == 0.0)
	                            {
	                                _595 = 0.0;
	                                break;
	                            }
	                            _595 = (g_Lights_1._m0[_476].m_vNearPlane.w - dot(_1938, g_Lights_1._m0[_476].m_vNearPlane.xyz)) * (1.0 / _4386);
	                            break;
	                        } while(false);
	                        if (_595 > 0.0)
	                        {
	                            vec4 _4398 = _716;
	                            _4398.w = min(_4398.w, _595);
	                            _716 = _4398;
	                        }
	                        if (dot(_716.xyz, _438.xyz) < 0.0)
	                        {
	                            _715 = _439;
	                        }
	                        else
	                        {
	                            _715 = _440;
	                        }
	                        vec4 _4410 = _716;
	                        vec3 _4412 = _715 - _1938;
	                        _4410.w = _4410.w + dot(_4410.xyz, _4412);
	                        vec3 _4422 = normalize((_4410.xyz * _4410.w) + _4412);
	                        vec4 _4424 = _4410;
	                        _4424.x = _4422.x;
	                        _4424.y = _4422.y;
	                        _4424.z = _4422.z;
	                        _716 = _4424;
	                        do
	                        {
	                            if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 1) != 0)
	                            {
	                                _594 = 32u;
	                                break;
	                            }
	                            if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 2) != 0)
	                            {
	                                _594 = 16u;
	                                break;
	                            }
	                            _594 = 0u;
	                            break;
	                        } while(false);
	                        vec3 _483 = _715;
	                        float _482 = 0.0;
	                        vec3 _481 = _4424.xyz;
	                        if (_4363)
	                        {
	                            _593 = _4424.w;
	                        }
	                        else
	                        {
	                            _593 = 0.0;
	                        }
	                        p_1 = PayloadShadow_t(1.0);
	                        traceRayEXT(g_AccelStruct, _594, 2u, 1u, 2u, 1u, _483, _482, _481, _593, 1);
	                        if (_4363)
	                        {
	                            _593 = p_1.m_flVisibility;
	                        }
	                        else
	                        {
	                            _593 = 0.0;
	                        }
	                        _715 = (_707 + _474) + (_475 * _593);
	                    }
	                    else
	                    {
	                        _715 = _707;
	                    }
	                }
	                else
	                {
	                    _715 = _707;
	                }
	                _446 = _440;
	                _445 = _439;
	                _444 = _438;
	                _443 = _437;
	                _344 = _337;
	                _343 = _336;
	                _342 = _335;
	                _341 = _334;
	                _340 = _332;
	                _339 = _331;
	                _338 = _330;
	                _380 = _375;
	                _379 = _374;
	                _378 = _373;
	                _377 = _372;
	                _376 = _371;
	                vec3 _4493 = vec3(_335);
	                float _4499 = min(0.89999997615814208984375, max(_4493.x, max(_4493.y, _4493.z)));
	                float _740 = _739.x;
	                do
	                {
	                    if (_4499 <= 0.0)
	                    {
	                        _592 = false;
	                        break;
	                    }
	                    if (_4499 >= 1.0)
	                    {
	                        _592 = true;
	                        break;
	                    }
	                    if (_740 < _4499)
	                    {
	                        _740 = min(_740 / _4499, 0.99999988079071044921875);
	                        _592 = true;
	                        break;
	                    }
	                    _740 = min((_740 - _4499) / (1.0 - _4499), 0.99999988079071044921875);
	                    _592 = false;
	                    break;
	                } while(false);
	                vec2 _4524 = _739;
	                _4524.x = _740;
	                _739 = _4524;
	                if (_592)
	                {
	                    do
	                    {
	                        _741 = 1.0;
	                        float _591 = _739.x;
	                        do
	                        {
	                            if (_377 <= 0.0)
	                            {
	                                _589 = false;
	                                break;
	                            }
	                            if (_377 >= 1.0)
	                            {
	                                _589 = true;
	                                break;
	                            }
	                            if (_591 < _377)
	                            {
	                                _591 = min(_591 / _377, 0.99999988079071044921875);
	                                _589 = true;
	                                break;
	                            }
	                            _591 = min((_591 - _377) / (1.0 - _377), 0.99999988079071044921875);
	                            _589 = false;
	                            break;
	                        } while(false);
	                        vec2 _4556 = _739;
	                        _4556.x = _591;
	                        _739 = _4556;
	                        if (_589)
	                        {
	                            _741 = _377;
	                            _590 = true;
	                            break;
	                        }
	                        else
	                        {
	                            _741 = 1.0 - _377;
	                            _590 = false;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    if (_590)
	                    {
	                        _446 = _445;
	                    }
	                    do
	                    {
	                        vec2 _587 = _739;
	                        if (_590)
	                        {
	                            float _4658 = sqrt(_587.y);
	                            float _4660 = 6.283185482025146484375 * _587.x;
	                            vec3 _4668 = vec3(cos(_4660) * _4658, sin(_4660) * _4658, sqrt(max(0.0, 1.0 - _587.y)));
	                            _4668.z = -_4668.z;
	                            _586 = _4668;
	                            break;
	                        }
	                        else
	                        {
	                            float _588 = _587.x;
	                            do
	                            {
	                                if (_378 <= 0.0)
	                                {
	                                    _585 = false;
	                                    break;
	                                }
	                                if (_378 >= 1.0)
	                                {
	                                    _585 = true;
	                                    break;
	                                }
	                                if (_588 < _378)
	                                {
	                                    _588 = min(_588 / _378, 0.99999988079071044921875);
	                                    _585 = true;
	                                    break;
	                                }
	                                _588 = min((_588 - _378) / (1.0 - _378), 0.99999988079071044921875);
	                                _585 = false;
	                                break;
	                            } while(false);
	                            vec2 _4607 = _587;
	                            _4607.x = _588;
	                            _587 = _4607;
	                            if (_585)
	                            {
	                                float _4611 = float(_341);
	                                float _4619 = ((_4611 * _4611) * sqrt(_587.x)) / sqrt(1.0 - _587.x);
	                                float _4622 = 1.0 / (1.0 + (_4619 * _4619));
	                                float _4625 = sqrt(max(0.0, 1.0 - _4622));
	                                float _4628 = 6.283185482025146484375 * _587.y;
	                                vec3 _4633 = vec3(cos(_4628) * _4625, sin(_4628) * _4625, sqrt(_4622));
	                                if (dot(_376, _4633) > 0.0)
	                                {
	                                    _584 = _4633;
	                                }
	                                else
	                                {
	                                    _584 = -_4633;
	                                }
	                                _586 = -reflect(_376, _584);
	                                break;
	                            }
	                            float _4645 = sqrt(_587.y);
	                            float _4647 = 6.283185482025146484375 * _587.x;
	                            _586 = vec3(cos(_4647) * _4645, sin(_4647) * _4645, sqrt(max(0.0, 1.0 - _587.y)));
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    _733 = _586;
	                    vec3 _4674 = normalize(_586 + _376);
	                    float _4675 = _4674.z;
	                    if (_590)
	                    {
	                        _582 = _586.z * (-0.3183098733425140380859375);
	                    }
	                    else
	                    {
	                        if (_378 > 0.0)
	                        {
	                            float _4686 = float(_341);
	                            float _4687 = _4686 * _4686;
	                            float _4688 = _4687 * _4687;
	                            float _4692 = (((_4675 * _4688) - _4675) * _4675) + 1.0;
	                            _581 = 1.0 - _378;
	                            _582 = _378 * (((_4688 / max(9.9999999392252902907785028219223e-09, _4692 * _4692)) * _4675) / (12.56637096405029296875 * max(0.0, dot(_376, _4674))));
	                        }
	                        else
	                        {
	                            _581 = 1.0;
	                            _582 = 0.0;
	                        }
	                        _582 += (_581 * (_586.z * 0.3183098733425140380859375));
	                    }
	                    if (_582 == 0.0)
	                    {
	                        _583 = true;
	                    }
	                    else
	                    {
	                        _583 = isnan(_582);
	                    }
	                    if (_583)
	                    {
	                        _581 = 3.4028234663852885981170418348452e+38;
	                    }
	                    else
	                    {
	                        _581 = _582;
	                    }
	                    float _742 = _581;
	                    do
	                    {
	                        if (_590)
	                        {
	                            if ((_339 & 65535u) == 1u)
	                            {
	                                _576 = any(greaterThan(vec3(_338.xyz), vec3(0.0)));
	                            }
	                            else
	                            {
	                                _576 = false;
	                            }
	                            if (_576)
	                            {
	                                _580 = vec3(_338.xyz);
	                            }
	                            else
	                            {
	                                _580 = vec3(1.0);
	                            }
	                            _579 = _580 * 0.3183098733425140380859375;
	                            break;
	                        }
	                        else
	                        {
	                            vec3 _4729 = vec3(mix(f16vec3(_340), _342, f16vec3(_343)));
	                            float _4730 = float(_341);
	                            do
	                            {
	                                vec3 _4735 = _733 + _376;
	                                if (_733.z <= 0.0)
	                                {
	                                    _578 = true;
	                                }
	                                else
	                                {
	                                    _578 = _376.z <= 0.0;
	                                }
	                                if (_578)
	                                {
	                                    _577 = vec3(0.0);
	                                    break;
	                                }
	                                if (all(equal(_4735, vec3(0.0))))
	                                {
	                                    _577 = vec3(0.0);
	                                    break;
	                                }
	                                vec3 _4748 = normalize(_4735);
	                                float _4749 = _4748.z;
	                                float _4757 = _4730 * _4730;
	                                float _4758 = _4757 * _4757;
	                                float _4762 = (((_4749 * _4758) - _4749) * _4749) + 1.0;
	                                float _4766 = _4730 * _4730;
	                                float _4767 = _4766 * _4766;
	                                _577 = (_4729 + ((vec3(1.0) - _4729) * pow(max(0.0, 1.0 - dot(_733, _4748)), 5.0))) * (((_4758 / max(9.9999999392252902907785028219223e-09, _4762 * _4762)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_733.z * sqrt(((_376.z - (_4767 * _376.z)) * _376.z) + _4767)) + (_376.z * sqrt(((_733.z - (_4767 * _733.z)) * _733.z) + _4767))))) * 0.3183098733425140380859375);
	                                break;
	                            } while(false);
	                            _579 = ((vec3(_342) * (1.0 - float(_343))) * 0.3183098733425140380859375) + _577;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _4811 = _733;
	                    vec3 _4814 = mat3(_380, _379, vec3(_344)) * _4811;
	                    _733 = _4814;
	                    float _4817 = dot(vec3(_344), _4814);
	                    if (_590)
	                    {
	                        _575 = -_4817;
	                    }
	                    else
	                    {
	                        _575 = _4817;
	                    }
	                    do
	                    {
	                        if ((_443 & 1024) != 0)
	                        {
	                            _574 = true;
	                            break;
	                        }
	                        _574 = (dot(_444, _733) > 0.0) != _590;
	                        break;
	                    } while(false);
	                    if (_574)
	                    {
	                        _743 = (_737 * (_579 * max(0.0, _575))) / vec3((_4499 * _741) * _742);
	                    }
	                    else
	                    {
	                        _743 = vec3(0.0);
	                    }
	                    _735 = _743;
	                }
	                else
	                {
	                    _735 = vec3(0.0);
	                }
	                _734++;
	                _736 = (_736 + ((_715 * _737) * _738)) + ((vec3(_333) * _737) * _738);
	                continue;
	            }
	            vec3 _4857 = abs(_736);
	            float _4862 = max(_4857.x, max(_4857.y, _4857.z));
	            vec3 _4867 = clamp(_736 / vec3(_4862), vec3(-1.0), vec3(1.0)) * clamp(_4862, -100.0, 100.0);
	            float _4868 = dot(_1239, vec3(_329));
	            float _572;
	            vec3 _573;
	            if (_744)
	            {
	                _572 = -_4868;
	                _573 = _4867 * vTransmissiveRatio;
	            }
	            else
	            {
	                _572 = _4868;
	                _573 = _4867;
	            }
	            vec4 _4874 = _420;
	            vec3 _4881 = _4874.xyz + ((_573 * max(0.0, _572)) * 0.3183098733425140380859375);
	            vec4 _4883 = _4874;
	            _4883.x = _4881.x;
	            _4883.y = _4881.y;
	            _4883.z = _4881.z;
	            vec3 _4889 = _4883.xyz + vec3(0.0);
	            vec4 _4891 = _4883;
	            _4891.x = _4889.x;
	            _4891.y = _4889.y;
	            _4891.z = _4889.z;
	            _420 = _4891;
	            if (_572 > 0.0)
	            {
	                vec4 _570;
	                vec4 _4900 = _570;
	                _4900.x = 0.2820948064327239990234375;
	                float _4902 = _1239.y;
	                _4900.y = (-0.48860251903533935546875) * _4902;
	                float _4905 = _1239.z;
	                _4900.z = 0.48860251903533935546875 * _4905;
	                float _4908 = _1239.x;
	                _4900.w = (-0.48860251903533935546875) * _4908;
	                _570 = _4900;
	                vec4 _571;
	                vec4 _4913 = _571;
	                _4913.x = (1.09254848957061767578125 * _4908) * _4902;
	                _4913.y = ((-1.09254848957061767578125) * _4902) * _4905;
	                _4913.z = 0.3153915703296661376953125 * (((3.0 * _4905) * _4905) - 1.0);
	                _4913.w = ((-1.09254848957061767578125) * _4908) * _4905;
	                _571 = _4913;
	                _419 += (_4900 * _573.x);
	                _416 += (_4913 * _573.x);
	                _418 += (_4900 * _573.y);
	                _415 += (_4913 * _573.y);
	                _417 += (_4900 * _573.z);
	                _414 += (_4913 * _573.z);
	                vec4 _4951 = _413;
	                vec3 _4954 = _4951.xyz + (_573 * (0.546274244785308837890625 * ((_4908 * _4908) - (_4902 * _4902))));
	                vec4 _4956 = _4951;
	                _4956.x = _4954.x;
	                _4956.y = _4954.y;
	                _4956.z = _4954.z;
	                _413 = _4956;
	            }
	            vec3 _4968 = (_424 + _423) * 0.5;
	            vec2 _4978 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_819.xy, int(1u + (2u * _820)))))).xy;
	            vec2 _552 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_819.xy, int(1u + _820))))).xy;
	            bool _4991 = (_1137 & 1u) != 0u;
	            bool _553;
	            if (any(notEqual(vTransmissiveRatio, vec3(0.0))))
	            {
	                _553 = true;
	            }
	            else
	            {
	                _553 = _4991;
	            }
	            if (_553)
	            {
	                _553 = true;
	            }
	            else
	            {
	                _553 = (_1137 & 3u) != 0u;
	            }
	            vec4 _554 = vec4(0.0);
	            float _555 = 0.0;
	            uvec3 _5005 = min(uvec3(max(fma(_4968, _844, _846), vec3(0.0))), (_841 - uvec3(1u)));
	            int _557 = -1;
	            float _558 = 0.0;
	            bool _556 = false;
	            uint _559 = 0u;
	            vec3 _560 = vec3(0.0);
	            bool _507;
	            bool _508;
	            vec4 _509;
	            vec4 _510;
	            float _511;
	            vec3 _512;
	            vec4 _513;
	            vec4 _514;
	            float _515;
	            vec3 _516;
	            float _517;
	            float _518;
	            bool _519;
	            float _520;
	            vec4 _521;
	            vec2 _522;
	            float _523;
	            float _524;
	            vec4 _525;
	            float _526;
	            vec3 _527;
	            vec3 _528;
	            bool _529;
	            float _530;
	            vec4 _531;
	            vec2 _532;
	            float _533;
	            float _534;
	            vec3 _536;
	            vec3 _537;
	            vec4 _539;
	            float _540;
	            float _541;
	            vec3 _542;
	            vec3 _543;
	            float _544;
	            float _545;
	            bool _546;
	            vec3 _547;
	            vec3 _548;
	            bool _549;
	            bool _550;
	            vec3 _551;
	            uint _561;
	            vec3 _562;
	            float _567;
	            bool _568;
	            for (;;)
	            {
	                if (!(_559 < _840))
	                {
	                    break;
	                }
	                uint _5018 = _840 * _841.x;
	                int _565 = _557;
	                float _566 = _558;
	                bool _564 = _556;
	                _561 = subgroupOr(g_LightBins_1._m0[((((_5018 * _841.y) * _5005.z) + (_5018 * _5005.y)) + (_840 * _5005.x)) + _559]);
	                _562 = _560;
	                for (;;)
	                {
	                    bool _5041_ladder_break = false;
	                    do
	                    {
	                        if (!(_561 != 0u))
	                        {
	                            _5041_ladder_break = true;
	                            break;
	                        }
	                        uint _5048 = _561;
	                        uint _5052 = uint(findLSB(_5048)) + (_559 * 32u);
	                        uint _5054 = _5048 & (_5048 - 1u);
	                        mat4 _5084 = mat4(vec4(g_Lights_1._m0[_5052].m_mToClipSpace.data[0].x, g_Lights_1._m0[_5052].m_mToClipSpace.data[1].x, g_Lights_1._m0[_5052].m_mToClipSpace.data[2].x, g_Lights_1._m0[_5052].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_5052].m_mToClipSpace.data[0].y, g_Lights_1._m0[_5052].m_mToClipSpace.data[1].y, g_Lights_1._m0[_5052].m_mToClipSpace.data[2].y, g_Lights_1._m0[_5052].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_5052].m_mToClipSpace.data[0].z, g_Lights_1._m0[_5052].m_mToClipSpace.data[1].z, g_Lights_1._m0[_5052].m_mToClipSpace.data[2].z, g_Lights_1._m0[_5052].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_5052].m_mToClipSpace.data[0].w, g_Lights_1._m0[_5052].m_mToClipSpace.data[1].w, g_Lights_1._m0[_5052].m_mToClipSpace.data[2].w, g_Lights_1._m0[_5052].m_mToClipSpace.data[3].w));
	                        if ((g_Lights_1._m0[_5052].m_nPathTraceFlags & 2) == 0)
	                        {
	                            _561 = _5054;
	                            break;
	                        }
	                        do
	                        {
	                            do
	                            {
	                                vec4 _5154 = _5084 * vec4(_4968.xyz, 1.0);
	                                vec3 _5158 = _5154.xyz / vec3(_5154.w);
	                                vec4 _5160;
	                                _5160.x = _5158.x;
	                                _5160.y = _5158.y;
	                                _5160.z = _5158.z;
	                                if (all(greaterThanEqual(_5160.xyz, vec3(-1.0, -1.0, 0.0))))
	                                {
	                                    _549 = all(lessThanEqual(_5160.xyz, vec3(1.0)));
	                                }
	                                else
	                                {
	                                    _549 = false;
	                                }
	                                if (!_549)
	                                {
	                                    _550 = false;
	                                    break;
	                                }
	                                if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_5052].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_4968, 1.0)).xyz), vec3(1.0))))
	                                {
	                                    _550 = false;
	                                    break;
	                                }
	                                _550 = true;
	                                break;
	                            } while(false);
	                            if (!_550)
	                            {
	                                _551 = vec3(0.0);
	                                break;
	                            }
	                            vec4 _5192 = _5084 * vec4(_4968.xyz, 1.0);
	                            vec3 _5196 = _5192.xyz / vec3(_5192.w);
	                            vec4 _5198;
	                            _5198.x = _5196.x;
	                            _5198.y = _5196.y;
	                            _5198.z = _5196.z;
	                            if (false)
	                            {
	                                _548 = g_Lights_1._m0[_5052].m_vBounceColor.xyz;
	                            }
	                            else
	                            {
	                                _548 = g_Lights_1._m0[_5052].m_vColor.xyz;
	                            }
	                            if (true)
	                            {
	                                if (g_Lights_1._m0[_5052].m_nCookie >= 0)
	                                {
	                                    if (g_Lights_1._m0[_5052].m_bSphericalCookie != 0)
	                                    {
	                                        vec4 _5241 = vec4(-g_Lights_1._m0[_5052].m_vOrientation.xyz, g_Lights_1._m0[_5052].m_vOrientation.w);
	                                        vec4 _5243 = _5241.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                        vec3 _5246 = _5243.xyz;
	                                        vec3 _5247 = vec4((-normalize(g_Lights_1._m0[_5052].m_vLightPosition.xyz - _4968)).xyz, 0.0).xyz;
	                                        vec4 _5254 = vec4((_5247 * _5243.w) + cross(_5247, _5246), -dot(_5247, _5246));
	                                        vec3 _5255 = _5254.xyz;
	                                        float _5256 = _5241.w;
	                                        vec3 _5258 = _5241.xyz;
	                                        float _5259 = _5254.w;
	                                        vec3 _5267 = vec4(((_5255 * _5256) + (_5258 * _5259)) + cross(_5258, _5255), _314).xyz;
	                                        vec2 _5276 = vec2(atan(_5267.y, -_5267.x) * 0.15915493667125701904296875, acos(_5267.z) * 0.3183098733425140380859375);
	                                        vec2 _5281 = (_5276.xy * g_Lights_1._m0[_5052].m_vCookieParameters.zw) + g_Lights_1._m0[_5052].m_vCookieParameters.xy;
	                                        vec2 _5283 = _5276;
	                                        _5283.x = _5281.x;
	                                        _5283.y = _5281.y;
	                                        _547 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_5052].m_nCookie], g_Sampler), _5283, 0.0).xyz;
	                                    }
	                                    else
	                                    {
	                                        vec2 _5220 = fma(_5198.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                        vec2 _5225 = (_5220.xy * g_Lights_1._m0[_5052].m_vCookieParameters.zw) + g_Lights_1._m0[_5052].m_vCookieParameters.xy;
	                                        vec2 _5227 = _5220;
	                                        _5227.x = _5225.x;
	                                        _5227.y = _5225.y;
	                                        _547 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_5052].m_nCookie], g_CookieSampler), _5227, 0.0).xyz;
	                                    }
	                                }
	                                else
	                                {
	                                    _547 = vec3(1.0);
	                                }
	                                _548 *= _547;
	                            }
	                            if (g_Lights_1._m0[_5052].m_nLuminaireType != 0)
	                            {
	                                _548 = (_548 * g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                            }
	                            else
	                            {
	                                if (!(g_Lights_1._m0[_5052].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _5303 = g_Lights_1._m0[_5052].m_vLightPosition.xyz - _4968;
	                                    _548 *= (vec3(g_Lights_1._m0[_5052].m_vLightPosition.w) / max(vec3(dot(_5303, _5303)), vec3(g_Lights_1._m0[_5052].m_vLightPosition.w)));
	                                }
	                            }
	                            if (g_Lights_1._m0[_5052].m_vDistanceFade_vSkirt.z > 0.0)
	                            {
	                                _544 = smoothstep(0.0, 1.0, _5198.xyz.z * g_Lights_1._m0[_5052].m_vDistanceFade_vSkirt.z);
	                            }
	                            else
	                            {
	                                _544 = 1.0;
	                            }
	                            if (g_Lights_1._m0[_5052].m_vDistanceFade_vSkirt.w > 0.0)
	                            {
	                                _544 *= smoothstep(0.0, 1.0, (1.0 - _5198.xyz.z) * g_Lights_1._m0[_5052].m_vDistanceFade_vSkirt.w);
	                            }
	                            if (!(g_Lights_1._m0[_5052].m_vLightPosition.w == 0.0))
	                            {
	                                vec3 _5344 = g_Lights_1._m0[_5052].m_vLightPosition.xyz - _4968;
	                                float _5345 = length(_5344);
	                                vec3 _5347 = _5344 / vec3(_5345);
	                                float _5353 = _544 * smoothstep(0.0, 1.0, g_Lights_1._m0[_5052].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_5052].m_vDistanceFade_vSkirt.y * _5345));
	                                if (g_Lights_1._m0[_5052].m_nLuminaireType != 2)
	                                {
	                                    _546 = g_Lights_1._m0[_5052].m_nLuminaireType != 1;
	                                }
	                                else
	                                {
	                                    _546 = false;
	                                }
	                                if (_546)
	                                {
	                                    float _5365 = 2.0 * g_Lights_1._m0[_5052].m_vOrientation.x;
	                                    float _5369 = 2.0 * g_Lights_1._m0[_5052].m_vOrientation.w;
	                                    vec3 _5383 = vec3((_5365 * g_Lights_1._m0[_5052].m_vOrientation.y) - (_5369 * g_Lights_1._m0[_5052].m_vOrientation.z), (1.0 - (_5365 * g_Lights_1._m0[_5052].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_5052].m_vOrientation.z) * g_Lights_1._m0[_5052].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_5052].m_vOrientation.y) * g_Lights_1._m0[_5052].m_vOrientation.z) + (_5369 * g_Lights_1._m0[_5052].m_vOrientation.x)) * g_Lights_1._m0[_5052].m_vAngleFade.z;
	                                    vec3 _5384 = _5347 - _5383;
	                                    vec3 _5385 = _5347 + _5383;
	                                    do
	                                    {
	                                        vec3 _5388 = _5385 - _5384;
	                                        float _5390 = dot(-_5384, _5388);
	                                        if (_5390 <= 0.0)
	                                        {
	                                            _542 = _5384;
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _5395 = dot(_5388, _5388);
	                                            if (_5390 > _5395)
	                                            {
	                                                _542 = _5385;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                _542 = _5384 + (_5388 * (_5390 / _5395));
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (any(notEqual(_542, vec3(0.0))))
	                                    {
	                                        _543 = normalize(_542);
	                                    }
	                                    else
	                                    {
	                                        _543 = _542;
	                                    }
	                                    float _5419 = 2.0 * g_Lights_1._m0[_5052].m_vOrientation.x;
	                                    float _5422 = 2.0 * g_Lights_1._m0[_5052].m_vOrientation.w;
	                                    _545 = _5353 * clamp(g_Lights_1._m0[_5052].m_vAngleFade.x + (g_Lights_1._m0[_5052].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_5052].m_vOrientation.y) * g_Lights_1._m0[_5052].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_5052].m_vOrientation.z) * g_Lights_1._m0[_5052].m_vOrientation.z), (_5419 * g_Lights_1._m0[_5052].m_vOrientation.y) + (_5422 * g_Lights_1._m0[_5052].m_vOrientation.z), (_5419 * g_Lights_1._m0[_5052].m_vOrientation.z) - (_5422 * g_Lights_1._m0[_5052].m_vOrientation.y)), _543)), 0.0, 1.0);
	                                }
	                                else
	                                {
	                                    _545 = _5353;
	                                }
	                            }
	                            else
	                            {
	                                _545 = _544;
	                            }
	                            if (g_Lights_1._m0[_5052].m_nCookie == (-1))
	                            {
	                                do
	                                {
	                                    vec2 _5446 = abs(_5198.xyz.xy);
	                                    if (g_Lights_1._m0[_5052].m_vCookieParameters.z == 0.0)
	                                    {
	                                        _540 = smoothstep(1.0, g_Lights_1._m0[_5052].m_vCookieParameters.x, _5446.x) * smoothstep(1.0, g_Lights_1._m0[_5052].m_vCookieParameters.y, _5446.y);
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        float _5451 = _5446.x;
	                                        float _5455 = _5446.y;
	                                        float _5462 = (-0.5) * g_Lights_1._m0[_5052].m_vCookieParameters.z;
	                                        float _5464 = (g_Lights_1._m0[_5052].m_vCookieParameters.x * g_Lights_1._m0[_5052].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_5052].m_vCookieParameters.y * _5451, 2.0 / g_Lights_1._m0[_5052].m_vCookieParameters.z) + pow(g_Lights_1._m0[_5052].m_vCookieParameters.x * _5455, 2.0 / g_Lights_1._m0[_5052].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _5462);
	                                        float _5471 = pow(max(pow(_5451, 2.0 / g_Lights_1._m0[_5052].m_vCookieParameters.z) + pow(_5455, 2.0 / g_Lights_1._m0[_5052].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _5462);
	                                        if (_5464 < _5471)
	                                        {
	                                            _540 = smoothstep(_5471, _5464, 1.0);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            if (_5471 > 1.0)
	                                            {
	                                                _541 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _541 = 0.0;
	                                            }
	                                            _540 = _541;
	                                            break;
	                                        }
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _545 *= _540;
	                            }
	                            _551 = _548 * _545;
	                            break;
	                        } while(false);
	                        if (all(equal(_551, vec3(0.0))))
	                        {
	                            _561 = _5054;
	                            break;
	                        }
	                        _538 = false;
	                        do
	                        {
	                            switch (g_Lights_1._m0[_5052].m_nLuminaireType)
	                            {
	                                case 0:
	                                {
	                                    _567 = 1.0;
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5052].m_vLightPosition.w == 0.0)
	                                        {
	                                            _513 = vec4(normalize(g_Lights_1._m0[_5052].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _5959 = g_Lights_1._m0[_5052].m_vLightPosition.xyz - _4968;
	                                            float _5960 = length(_5959);
	                                            _513 = vec4(_5959 / vec3(_5960), _5960);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _538 = true;
	                                    _539 = _513;
	                                    break;
	                                }
	                                case 1:
	                                {
	                                    vec3 _5809 = g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].xyz;
	                                    vec3 _5811 = g_Lights_1._m0[_5052].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].xyz;
	                                    float _5812 = length(_5809);
	                                    float _5813 = length(_5811);
	                                    vec3 _5815 = _5809 / vec3(_5812);
	                                    vec3 _5817 = _5811 / vec3(_5813);
	                                    vec3 _5818 = cross(_5815, _5817);
	                                    vec3 _5819 = g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].xyz - _4968;
	                                    float _5820 = dot(_5819, _5818);
	                                    if (_5820 > 0.0)
	                                    {
	                                        _515 = _5820 * (-1.0);
	                                        _516 = _5818 * (-1.0);
	                                    }
	                                    else
	                                    {
	                                        _515 = _5820;
	                                        _516 = _5818;
	                                    }
	                                    float _5829 = dot(_5819, _5815);
	                                    float _5830 = dot(_5819, _5817);
	                                    float _5831 = _5829 + _5812;
	                                    float _5832 = _5830 + _5813;
	                                    vec3 _5835 = vec3(_5829, _5830, _515);
	                                    vec3 _5836 = vec3(_5829, _5832, _515);
	                                    vec3 _5837 = vec3(_5831, _5830, _515);
	                                    vec3 _5838 = vec3(_5831, _5832, _515);
	                                    vec3 _5840 = normalize(cross(_5835, _5837));
	                                    vec3 _5842 = normalize(cross(_5837, _5838));
	                                    vec3 _5844 = normalize(cross(_5838, _5836));
	                                    vec3 _5846 = normalize(cross(_5836, _5835));
	                                    float _5863 = _5840.z;
	                                    float _5867 = (6.283185482025146484375 - acos(clamp(-dot(_5844, _5846), -1.0, 1.0))) - acos(clamp(-dot(_5846, _5840), -1.0, 1.0));
	                                    float _5869 = (acos(clamp(-dot(_5840, _5842), -1.0, 1.0)) + acos(clamp(-dot(_5842, _5844), -1.0, 1.0))) - _5867;
	                                    if (isnan(_5869))
	                                    {
	                                        _517 = 0.0;
	                                    }
	                                    else
	                                    {
	                                        _517 = _5869;
	                                    }
	                                    float _5877 = (_4978.x * _517) + _5867;
	                                    float _5882 = ((cos(_5877) * _5863) - _5844.z) / sin(_5877);
	                                    if (_5882 > 0.0)
	                                    {
	                                        _518 = 1.0;
	                                    }
	                                    else
	                                    {
	                                        _518 = -1.0;
	                                    }
	                                    float _5891 = _518;
	                                    float _5893 = clamp((1.0 / sqrt((_5882 * _5882) + (_5863 * _5863))) * _5891, -1.0, 1.0);
	                                    float _5901 = clamp((-(_5893 * _515)) / sqrt(1.0 - (_5893 * _5893)), _5829, _5831);
	                                    float _5904 = sqrt((_5901 * _5901) + (_515 * _515));
	                                    float _5905 = _5904 * _5904;
	                                    float _5908 = _5830 / sqrt(_5905 + (_5830 * _5830));
	                                    float _5915 = _5908 + (_4978.y * ((_5832 / sqrt(_5905 + (_5832 * _5832))) - _5908));
	                                    float _5916 = _5915 * _5915;
	                                    if (_5916 < 0.99999988079071044921875)
	                                    {
	                                        _518 = (_5915 * _5904) / sqrt(1.0 - _5916);
	                                    }
	                                    else
	                                    {
	                                        _518 = _5832;
	                                    }
	                                    vec3 _5933 = ((_4968 + (_5815 * _5901)) + (_5817 * _518)) + (_516 * _515);
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5052].m_vLightPosition.w == 0.0)
	                                        {
	                                            _514 = vec4(normalize(_5933), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _5941 = _5933 - _4968;
	                                            float _5942 = length(_5941);
	                                            _514 = vec4(_5941 / vec3(_5942), _5942);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _567 = 1.0 / _517;
	                                    _538 = true;
	                                    _539 = _514;
	                                    break;
	                                }
	                                case 2:
	                                {
	                                    do
	                                    {
	                                        vec2 _5737 = (_4978 * 2.0) - vec2(1.0);
	                                        if (all(equal(_5737, vec2(0.0))))
	                                        {
	                                            _522 = vec2(0.0);
	                                            break;
	                                        }
	                                        float _5742 = _5737.x;
	                                        float _5744 = _5737.y;
	                                        if (abs(_5742) > abs(_5744))
	                                        {
	                                            _523 = _5742;
	                                            _524 = 0.785398185253143310546875 * (_5744 / _5742);
	                                        }
	                                        else
	                                        {
	                                            _523 = _5744;
	                                            _524 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_5742 / _5744));
	                                        }
	                                        _522 = vec2(cos(_524), sin(_524)) * _523;
	                                        break;
	                                    } while(false);
	                                    vec3 _5770 = (g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].xyz * _522.x)) + (g_Lights_1._m0[_5052].m_vLuminaireVectors.data[2].xyz * _522.y);
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5052].m_vLightPosition.w == 0.0)
	                                        {
	                                            _521 = vec4(normalize(_5770), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _5778 = _5770 - _4968;
	                                            float _5779 = length(_5778);
	                                            _521 = vec4(_5778 / vec3(_5779), _5779);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (isinf(_521.w))
	                                    {
	                                        _519 = true;
	                                    }
	                                    else
	                                    {
	                                        _519 = isnan(_521.w);
	                                    }
	                                    if (!_519)
	                                    {
	                                        _520 = _521.w * _521.w;
	                                    }
	                                    else
	                                    {
	                                        _520 = 1.0;
	                                    }
	                                    _567 = _520 / (max(0.0, dot(g_Lights_1._m0[_5052].m_vLuminaireVectors.data[3].xyz, -_521.xyz)) * g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].w);
	                                    _538 = true;
	                                    _539 = _521;
	                                    break;
	                                }
	                                case 3:
	                                {
	                                    vec3 _5636 = g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].xyz - _4968;
	                                    float _5637 = dot(_5636, _5636);
	                                    float _5638 = sqrt(_5637);
	                                    vec3 _5640 = _5636 / vec3(_5638);
	                                    float _5641 = _5640.z;
	                                    if (_5641 >= 0.0)
	                                    {
	                                        _526 = 1.0;
	                                    }
	                                    else
	                                    {
	                                        _526 = -1.0;
	                                    }
	                                    float _5648 = (-1.0) / (_526 + _5641);
	                                    float _5649 = _5640.x;
	                                    float _5650 = _5640.y;
	                                    float _5652 = (_5649 * _5650) * _5648;
	                                    vec3 _5657 = _527;
	                                    _5657.x = 1.0 + (((_526 * _5649) * _5649) * _5648);
	                                    _5657.y = _526 * _5652;
	                                    _5657.z = (-_526) * _5649;
	                                    _527 = _5657;
	                                    vec3 _5664 = _528;
	                                    _5664.x = _5652;
	                                    _5664.y = _526 + ((_5650 * _5650) * _5648);
	                                    _5664.z = -_5650;
	                                    _528 = _5664;
	                                    float _5672 = g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].x;
	                                    float _5676 = sqrt(max(0.0, 1.0 - (_5672 / _5637)));
	                                    float _5677 = _4978.x;
	                                    float _5680 = (1.0 - _5677) + (_5677 * _5676);
	                                    float _5684 = sqrt(max(0.0, 1.0 - (_5680 * _5680)));
	                                    float _5686 = _4978.y * 6.283185482025146484375;
	                                    float _5688 = _5638 * _5638;
	                                    float _5694 = (_5638 * _5680) - sqrt(max(0.0, _5672 - ((_5688 * _5684) * _5684)));
	                                    float _5700 = ((_5688 + _5672) - (_5694 * _5694)) / ((2.0 * _5638) * g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].x);
	                                    float _5704 = sqrt(max(0.0, 1.0 - (_5700 * _5700)));
	                                    vec3 _5716 = g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].xyz + ((mat3(-_5657, -_5664, -_5640) * vec3(cos(_5686) * _5704, sin(_5686) * _5704, _5700)) * g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].x);
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5052].m_vLightPosition.w == 0.0)
	                                        {
	                                            _525 = vec4(normalize(_5716), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _5724 = _5716 - _4968;
	                                            float _5725 = length(_5724);
	                                            _525 = vec4(_5724 / vec3(_5725), _5725);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _567 = 0.15915493667125701904296875 / (1.0 - _5676);
	                                    _538 = true;
	                                    _539 = _525;
	                                    break;
	                                }
	                                case 4:
	                                case 5:
	                                {
	                                    vec2 _535 = _4978;
	                                    if (_4978.x < g_Lights_1._m0[_5052].m_vLuminaireVectors.data[4].y)
	                                    {
	                                        vec2 _5537 = _535;
	                                        _5537.x = clamp(_5537.x / g_Lights_1._m0[_5052].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                        _535 = _5537;
	                                        vec3 _5543 = normalize(g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].xyz);
	                                        if (_5537.x >= 0.5)
	                                        {
	                                            vec2 _5554 = _535;
	                                            _5554.x = clamp((2.0 * _5554.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                            _535 = _5554;
	                                            _536 = -_5543;
	                                            _537 = g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _5549 = _535;
	                                            _5549.x = clamp(2.0 * _5549.x, 0.0, 0.99999988079071044921875);
	                                            _535 = _5549;
	                                            _536 = _5543;
	                                            _537 = g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].xyz;
	                                        }
	                                        do
	                                        {
	                                            vec2 _5565 = (_535 * 2.0) - vec2(1.0);
	                                            if (all(equal(_5565, vec2(0.0))))
	                                            {
	                                                _532 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _5570 = _5565.x;
	                                            float _5572 = _5565.y;
	                                            if (abs(_5570) > abs(_5572))
	                                            {
	                                                _533 = _5570;
	                                                _534 = 0.785398185253143310546875 * (_5572 / _5570);
	                                            }
	                                            else
	                                            {
	                                                _533 = _5572;
	                                                _534 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_5570 / _5572));
	                                            }
	                                            _532 = vec2(cos(_534), sin(_534)) * _533;
	                                            break;
	                                        } while(false);
	                                        _537 += ((g_Lights_1._m0[_5052].m_vLuminaireVectors.data[2].xyz * _532.x) + (g_Lights_1._m0[_5052].m_vLuminaireVectors.data[3].xyz * _532.y));
	                                    }
	                                    else
	                                    {
	                                        vec2 _5516 = _535;
	                                        _5516.x = clamp((_5516.x - g_Lights_1._m0[_5052].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_5052].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                        _535 = _5516;
	                                        vec3 _5531 = (g_Lights_1._m0[_5052].m_vLuminaireVectors.data[2].xyz * cos(_5516.x * 6.283185482025146484375)) + (g_Lights_1._m0[_5052].m_vLuminaireVectors.data[3].xyz * sin(_5516.x * 6.283185482025146484375));
	                                        _536 = normalize(_5531);
	                                        _537 = mix(g_Lights_1._m0[_5052].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].xyz, vec3(_5516.y)) + _5531;
	                                    }
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5052].m_vLightPosition.w == 0.0)
	                                        {
	                                            _531 = vec4(normalize(_537), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _5605 = _537 - _4968;
	                                            float _5606 = length(_5605);
	                                            _531 = vec4(_5605 / vec3(_5606), _5606);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (isinf(_531.w))
	                                    {
	                                        _529 = true;
	                                    }
	                                    else
	                                    {
	                                        _529 = isnan(_531.w);
	                                    }
	                                    if (!_529)
	                                    {
	                                        _530 = _531.w * _531.w;
	                                    }
	                                    else
	                                    {
	                                        _530 = 1.0;
	                                    }
	                                    _567 = _530 / (max(0.0, dot(_536, -_531.xyz)) * g_Lights_1._m0[_5052].m_vLuminaireVectors.data[1].w);
	                                    _538 = true;
	                                    _539 = _531;
	                                    break;
	                                }
	                                default:
	                                {
	                                    _567 = 0.0;
	                                    _538 = true;
	                                    _539 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                    break;
	                                }
	                            }
	                            if (_538)
	                            {
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        vec3 _5972 = _551 * (3.1415927410125732421875 / _567);
	                        bool _5976 = !(dot(_422, _539.xyz) > 0.0);
	                        if (!((g_Lights_1._m0[_5052].m_nPathTraceFlags & 8) != 0))
	                        {
	                            vec3 _5983 = abs(_5972);
	                            float _5988 = max(_5983.x, max(_5983.y, _5983.z));
	                            vec3 _5993 = clamp(_5972 / vec3(_5988), vec3(-1.0), vec3(1.0)) * clamp(_5988, -100.0, 100.0);
	                            float _5994 = dot(_539.xyz, vec3(_322));
	                            if (_5976)
	                            {
	                                _511 = -_5994;
	                                _512 = _5993 * vTransmissiveRatio;
	                            }
	                            else
	                            {
	                                _511 = _5994;
	                                _512 = _5993;
	                            }
	                            vec4 _6000 = _420;
	                            vec3 _6007 = _6000.xyz + ((_512 * max(0.0, _511)) * 0.3183098733425140380859375);
	                            vec4 _6009 = _6000;
	                            _6009.x = _6007.x;
	                            _6009.y = _6007.y;
	                            _6009.z = _6007.z;
	                            vec3 _6015 = _6009.xyz + vec3(0.0);
	                            vec4 _6017 = _6009;
	                            _6017.x = _6015.x;
	                            _6017.y = _6015.y;
	                            _6017.z = _6015.z;
	                            _420 = _6017;
	                            if (_511 > 0.0)
	                            {
	                                vec4 _6026 = _509;
	                                _6026.x = 0.2820948064327239990234375;
	                                _6026.y = (-0.48860251903533935546875) * _539.y;
	                                _6026.z = 0.48860251903533935546875 * _539.z;
	                                _6026.w = (-0.48860251903533935546875) * _539.x;
	                                _509 = _6026;
	                                vec4 _6039 = _510;
	                                _6039.x = (1.09254848957061767578125 * _539.x) * _539.y;
	                                _6039.y = ((-1.09254848957061767578125) * _539.y) * _539.z;
	                                _6039.z = 0.3153915703296661376953125 * (((3.0 * _539.z) * _539.z) - 1.0);
	                                _6039.w = ((-1.09254848957061767578125) * _539.x) * _539.z;
	                                _510 = _6039;
	                                _419 += (_6026 * _512.x);
	                                _416 += (_6039 * _512.x);
	                                _418 += (_6026 * _512.y);
	                                _415 += (_6039 * _512.y);
	                                _417 += (_6026 * _512.z);
	                                _414 += (_6039 * _512.z);
	                                vec4 _6077 = _413;
	                                vec3 _6080 = _6077.xyz + (_512 * (0.546274244785308837890625 * ((_539.x * _539.x) - (_539.y * _539.y))));
	                                vec4 _6082 = _6077;
	                                _6082.x = _6080.x;
	                                _6082.y = _6080.y;
	                                _6082.z = _6080.z;
	                                _413 = _6082;
	                            }
	                            _561 = _5054;
	                            break;
	                        }
	                        if (_5976)
	                        {
	                            _568 = !_553;
	                        }
	                        else
	                        {
	                            _568 = false;
	                        }
	                        if (_568)
	                        {
	                            _561 = _5054;
	                            break;
	                        }
	                        float _6099 = max(_5972.x, max(_5972.y, _5972.z));
	                        float _569 = _552.x;
	                        do
	                        {
	                            float _6104 = _555;
	                            float _6105 = _6104 + _6099;
	                            _555 = _6105;
	                            if (_6105 == 0.0)
	                            {
	                                _508 = false;
	                                break;
	                            }
	                            float _6110 = _6099 / _555;
	                            do
	                            {
	                                if (_6110 <= 0.0)
	                                {
	                                    _507 = false;
	                                    break;
	                                }
	                                if (_6110 >= 1.0)
	                                {
	                                    _507 = true;
	                                    break;
	                                }
	                                if (_569 < _6110)
	                                {
	                                    _569 = min(_569 / _6110, 0.99999988079071044921875);
	                                    _507 = true;
	                                    break;
	                                }
	                                _569 = min((_569 - _6110) / (1.0 - _6110), 0.99999988079071044921875);
	                                _507 = false;
	                                break;
	                            } while(false);
	                            _508 = _507;
	                            break;
	                        } while(false);
	                        vec2 _6134 = _552;
	                        _6134.x = _569;
	                        _552 = _6134;
	                        if (_508)
	                        {
	                            _554 = _539;
	                            _565 = int(_5052);
	                            _566 = _6099;
	                            _564 = _5976;
	                            _562 = _5972;
	                        }
	                        _561 = _5054;
	                        break;
	                    } while(false);
	                    if (_5041_ladder_break)
	                    {
	                        break;
	                    }
	                    continue;
	                }
	                _557 = _565;
	                _558 = _566;
	                _556 = _564;
	                _559++;
	                _560 = _562;
	                continue;
	            }
	            bool _6150 = any(notEqual(_560, vec3(0.0)));
	            if (_557 != (-1))
	            {
	                _553 = _6150;
	            }
	            else
	            {
	                _553 = false;
	            }
	            if (_553)
	            {
	                vec3 _6167 = _560;
	                vec3 _6168 = _6167 * (_555 / _558);
	                bool _505;
	                if (isinf(_554.w))
	                {
	                    _505 = true;
	                }
	                else
	                {
	                    _505 = isnan(_554.w);
	                }
	                float _506;
	                if (!_505)
	                {
	                    _506 = _554.w;
	                }
	                else
	                {
	                    _506 = 56755.83984375;
	                }
	                vec4 _6184 = _554;
	                _6184.w = _506;
	                _554 = _6184;
	                float _504;
	                do
	                {
	                    float _6191 = dot(_6184.xyz, g_Lights_1._m0[_557].m_vNearPlane.xyz);
	                    if (_6191 == 0.0)
	                    {
	                        _504 = 0.0;
	                        break;
	                    }
	                    _504 = (g_Lights_1._m0[_557].m_vNearPlane.w - dot(_4968, g_Lights_1._m0[_557].m_vNearPlane.xyz)) * (1.0 / _6191);
	                    break;
	                } while(false);
	                if (_504 > 0.0)
	                {
	                    vec4 _6203 = _554;
	                    _6203.w = min(_6203.w, _504);
	                    _554 = _6203;
	                }
	                if (_556)
	                {
	                    _562 = _423;
	                }
	                else
	                {
	                    _562 = _424;
	                }
	                vec4 _6211 = _554;
	                vec3 _6213 = _562 - _4968;
	                _6211.w = _6211.w + dot(_6211.xyz, _6213);
	                vec3 _6223 = normalize((_6211.xyz * _6211.w) + _6213);
	                vec4 _6225 = _6211;
	                _6225.x = _6223.x;
	                _6225.y = _6223.y;
	                _6225.z = _6223.z;
	                _554 = _6225;
	                if (_4991)
	                {
	                    _561 = 8u;
	                }
	                else
	                {
	                    _561 = 2u;
	                }
	                uint _503;
	                do
	                {
	                    if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 1) != 0)
	                    {
	                        _503 = 32u;
	                        break;
	                    }
	                    if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 2) != 0)
	                    {
	                        _503 = 16u;
	                        break;
	                    }
	                    _503 = 0u;
	                    break;
	                } while(false);
	                vec3 _486 = _562;
	                float _485 = 0.0;
	                vec3 _484 = _554.xyz;
	                float _502;
	                if (_6150)
	                {
	                    _502 = _554.w;
	                }
	                else
	                {
	                    _502 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, _503, _561, 1u, 2u, 1u, _486, _485, _484, _502, 1);
	                if (_6150)
	                {
	                    _502 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _502 = 0.0;
	                }
	                vec4 _6275 = _296[g_Lights_1._m0[_557].m_nBakedShadowIndex + 1] * dot(_6168.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                _412 += (_6275 * _502);
	                _411 += _6275;
	                _410 = mix(_410, ivec4(g_Lights_1._m0[_557].m_nShadowedLightId), notEqual(_6275, vec4(0.0)));
	                if (g_Lights_1._m0[_557].m_nBakedShadowIndex == (-1))
	                {
	                    if (_556)
	                    {
	                        bool _500;
	                        if ((_317 & 65535u) == 2u)
	                        {
	                            _500 = float(_316.x) > 0.0;
	                        }
	                        else
	                        {
	                            _500 = false;
	                        }
	                        _553 = _500;
	                    }
	                    else
	                    {
	                        _553 = false;
	                    }
	                    vec3 _563;
	                    if (_553)
	                    {
	                        float _6318 = pow(clamp(-dot(normalize(_422 + vec3(_322)), _554.xyz), 0.0, 1.0), 2.0);
	                        f16vec3 _6319 = f16vec3(vec3(0.0));
	                        vec3 _490;
	                        bool _496;
	                        if (isinf(_554.w))
	                        {
	                            _496 = true;
	                        }
	                        else
	                        {
	                            _496 = isnan(_554.w);
	                        }
	                        float _497;
	                        if (!_496)
	                        {
	                            _497 = _554.w;
	                        }
	                        else
	                        {
	                            _497 = 1000.0;
	                        }
	                        vec3 _489 = _424 + (_554.xyz * _497);
	                        float _488 = 0.0;
	                        vec3 _487 = -_554.xyz;
	                        float _498;
	                        if (_6318 > 0.0)
	                        {
	                            _498 = _497;
	                        }
	                        else
	                        {
	                            _498 = 0.0;
	                        }
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _490, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_6319, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _6319, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _489, _488, _487, _498, 0);
	                        float _499;
	                        if (p._m5 != (-1))
	                        {
	                            bool _495;
	                            if ((p._m7._m6 & 65535u) == 2u)
	                            {
	                                _495 = float(p._m7._m7.x) > 0.0;
	                            }
	                            else
	                            {
	                                _495 = false;
	                            }
	                            if (!_495)
	                            {
	                                _498 = 0.0;
	                            }
	                            else
	                            {
	                                _498 = _6318;
	                            }
	                            _499 = _497 - p._m3;
	                        }
	                        else
	                        {
	                            _498 = _6318;
	                            _499 = _497;
	                        }
	                        uint _6376 = uint(int(uint(_316.w)));
	                        float _6380 = _499 * float(_316.x);
	                        _560 = vec3(0.0);
	                        _563 = ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_6376].m_vTransmissiveLogColor.xyz * (1.0 + (_6380 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_6376].m_fTransmissiveSaturation))) * exp(-_6380)) * _498) * _6168;
	                    }
	                    else
	                    {
	                        _560 = _6168;
	                        _563 = vec3(0.0);
	                    }
	                    vec3 _6401 = _560 * _502;
	                    vec3 _6406 = abs(_6401);
	                    float _6411 = max(_6406.x, max(_6406.y, _6406.z));
	                    vec3 _6416 = clamp(_6401 / vec3(_6411), vec3(-1.0), vec3(1.0)) * clamp(_6411, -100.0, 100.0);
	                    vec3 _6417 = abs(_563);
	                    float _6422 = max(_6417.x, max(_6417.y, _6417.z));
	                    float _6428 = dot(_554.xyz, vec3(_322));
	                    float _493;
	                    vec3 _494;
	                    if (_556)
	                    {
	                        _493 = -_6428;
	                        _494 = _6416 * vTransmissiveRatio;
	                    }
	                    else
	                    {
	                        _493 = _6428;
	                        _494 = _6416;
	                    }
	                    vec4 _6434 = _420;
	                    vec3 _6441 = _6434.xyz + ((_494 * max(0.0, _493)) * 0.3183098733425140380859375);
	                    vec4 _6443 = _6434;
	                    _6443.x = _6441.x;
	                    _6443.y = _6441.y;
	                    _6443.z = _6441.z;
	                    vec3 _6449 = _6443.xyz + (clamp(_563 / vec3(_6422), vec3(-1.0), vec3(1.0)) * clamp(_6422, -100.0, 100.0));
	                    vec4 _6451 = _6443;
	                    _6451.x = _6449.x;
	                    _6451.y = _6449.y;
	                    _6451.z = _6449.z;
	                    _420 = _6451;
	                    if (_493 > 0.0)
	                    {
	                        vec4 _491;
	                        vec4 _6460 = _491;
	                        _6460.x = 0.2820948064327239990234375;
	                        _6460.y = (-0.48860251903533935546875) * _554.y;
	                        _6460.z = 0.48860251903533935546875 * _554.z;
	                        _6460.w = (-0.48860251903533935546875) * _554.x;
	                        _491 = _6460;
	                        vec4 _492;
	                        vec4 _6473 = _492;
	                        _6473.x = (1.09254848957061767578125 * _554.x) * _554.y;
	                        _6473.y = ((-1.09254848957061767578125) * _554.y) * _554.z;
	                        _6473.z = 0.3153915703296661376953125 * (((3.0 * _554.z) * _554.z) - 1.0);
	                        _6473.w = ((-1.09254848957061767578125) * _554.x) * _554.z;
	                        _492 = _6473;
	                        _419 += (_6460 * _494.x);
	                        _416 += (_6473 * _494.x);
	                        _418 += (_6460 * _494.y);
	                        _415 += (_6473 * _494.y);
	                        _417 += (_6460 * _494.z);
	                        _414 += (_6473 * _494.z);
	                        vec4 _6511 = _413;
	                        vec3 _6514 = _6511.xyz + (_494 * (0.546274244785308837890625 * ((_554.x * _554.x) - (_554.y * _554.y))));
	                        vec4 _6516 = _6511;
	                        _6516.x = _6514.x;
	                        _6516.y = _6514.y;
	                        _6516.z = _6514.z;
	                        _413 = _6516;
	                    }
	                }
	            }
	            float _6527 = sqrt(vSeed.y);
	            float _6529 = 6.283185482025146484375 * vSeed.x;
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _424, 0.0, mat3(_365, _364, vec3(_322)) * vec3(cos(_6529) * _6527, sin(_6529) * _6527, sqrt(max(0.0, 1.0 - vSeed.y))), 16.0, 1);
	            vec4 _6545 = _407;
	            _6545.x = _6545.x + p_1.m_flVisibility;
	            _407 = _6545;
	        }
	        vec4 _6549 = _420;
	        _6549.w = 1.0;
	        _420 = _6549;
	        if (g_PushConstants.m_nEstimate_DimensionCount.x > 0)
	        {
	            vec4 _6558 = g_Luxels._m0[_767].vIrradiance_flSampleCount;
	            float _6601 = 1.0 / (1.0 + _6558.w);
	            vec3 _6605 = mix(_6558.xyz, _420.xyz, vec3(_6601));
	            vec4 _6607 = _6558;
	            _6607.x = _6605.x;
	            _6607.y = _6605.y;
	            _6607.z = _6605.z;
	            vec4 _6612 = vec4(_6601);
	            _6607.w = _6607.w + 1.0;
	            _420 = _6607;
	            _419 = mix(g_Luxels._m0[_767].vShr, _419, _6612);
	            _418 = mix(g_Luxels._m0[_767].vShg, _418, _6612);
	            _417 = mix(g_Luxels._m0[_767].vShb, _417, _6612);
	            _416 = mix(g_Luxels._m0[_767].vQuadraticr, _416, _6612);
	            _415 = mix(g_Luxels._m0[_767].vQuadraticg, _415, _6612);
	            _414 = mix(g_Luxels._m0[_767].vQuadraticb, _414, _6612);
	            _413 = mix(g_Luxels._m0[_767].vQuadraticFinalrgb, _413, _6612);
	            _412 = mix(g_Luxels._m0[_767].vBakedShadow, _412, _6612);
	            _411 = mix(g_Luxels._m0[_767].vBakedShadowUnoccluded, _411, _6612);
	            _410 = mix(_410, g_Luxels._m0[_767].vBakedShadowLightId, notEqual(g_Luxels._m0[_767].vBakedShadowLightId, ivec4(255)));
	            _409 = mix(g_Luxels._m0[_767].vTangent, _409, _6612);
	            _408 = mix(g_Luxels._m0[_767].vNormal, _408, _6612);
	            _407 = mix(g_Luxels._m0[_767].flAmbientOcclusion_vPadding, _407, _6612);
	        }
	        g_Luxels._m0[_767].vIrradiance_flSampleCount = _420;
	        g_Luxels._m0[_767].vShr = _419;
	        g_Luxels._m0[_767].vShg = _418;
	        g_Luxels._m0[_767].vShb = _417;
	        g_Luxels._m0[_767].vQuadraticr = _416;
	        g_Luxels._m0[_767].vQuadraticg = _415;
	        g_Luxels._m0[_767].vQuadraticb = _414;
	        g_Luxels._m0[_767].vQuadraticFinalrgb = _413;
	        g_Luxels._m0[_767].vBakedShadow = _412;
	        g_Luxels._m0[_767].vBakedShadowUnoccluded = _411;
	        g_Luxels._m0[_767].vBakedShadowLightId = _410;
	        g_Luxels._m0[_767].vTangent = _409;
	        g_Luxels._m0[_767].vNormal = _408;
	        g_Luxels._m0[_767].flAmbientOcclusion_vPadding = _407;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
