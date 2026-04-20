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
	// SPIR-V source (160660 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	const vec4 _304[5] = vec4[](vec4(0.0), vec4(1.0, 0.0, 0.0, 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	
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
	
	vec4 _322;
	float _323;
	
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
	    bool _547 = false;
	    bool _647 = false;
	    bool _701 = false;
	    do
	    {
	        uint _779 = (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x) + gl_LaunchIDEXT.x;
	        if (g_PushConstants.m_nEstimate_DimensionCount.x == 0)
	        {
	            g_Luxels._m0[_779].vIrradiance_flSampleCount = vec4(0.0);
	            g_Luxels._m0[_779].vShr = vec4(0.0);
	            g_Luxels._m0[_779].vShg = vec4(0.0);
	            g_Luxels._m0[_779].vShb = vec4(0.0);
	            g_Luxels._m0[_779].vQuadraticr = vec4(0.0);
	            g_Luxels._m0[_779].vQuadraticg = vec4(0.0);
	            g_Luxels._m0[_779].vQuadraticb = vec4(0.0);
	            g_Luxels._m0[_779].vQuadraticFinalrgb = vec4(0.0);
	            g_Luxels._m0[_779].vBakedShadow = vec4(0.0);
	            g_Luxels._m0[_779].vBakedShadowUnoccluded = vec4(0.0);
	            g_Luxels._m0[_779].vBakedShadowLightId = ivec4(255);
	            g_Luxels._m0[_779].vTangent = vec4(0.0);
	            g_Luxels._m0[_779].vNormal = vec4(0.0);
	            g_Luxels._m0[_779].flAmbientOcclusion_vPadding = vec4(0.0);
	        }
	        else
	        {
	            if (imageLoad(g_LightmapBlockConverged, ivec3(gl_LaunchIDEXT / uvec3(4u, 4u, 1u))).x != 0u)
	            {
	                break;
	            }
	        }
	        uvec3 _819 = uvec3(imageSize(g_RandomSamples));
	        ivec3 _764;
	        ivec3 _822 = _764;
	        _822.x = int(_819.x);
	        _822.y = int(_819.y);
	        _822.z = int(_819.z);
	        _764 = _822;
	        ivec2 _831 = ivec2(gl_LaunchIDEXT.xy) - _822.xy * (ivec2(gl_LaunchIDEXT.xy) / _822.xy);
	        uint _832 = uint(g_PushConstants.m_nEstimate_DimensionCount.y);
	        uint _852 = uint(max(1, ((g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	        uvec3 _853 = uvec3(g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.xyz);
	        vec3 _856 = vec3(_853) / (g_SceneGlobalInfo._m0[0].m_vLocalLightMaxBounds.xyz - g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz);
	        vec3 _858 = (-g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz) * _856;
	        uvec4 sampled = texelFetch(g_LuxelChartIDs, ivec2(gl_LaunchIDEXT.xy), 0);
	        uint _862 = sampled.x;
	        if (_862 == 4294967295u)
	        {
	            break;
	        }
	        vec2 _870 = (g_PushConstants.m_vLightmapOffsetAndSize.xy + vec2(gl_LaunchIDEXT.xy)) + vec2(0.5);
	        vec2 vSeed = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_831.xy, 1)))).xy;
	        float flReservoirWt = 0.0;
	        vec4 _440 = vec4(0.0);
	        vec4 _439 = vec4(0.0);
	        vec4 _438 = vec4(0.0);
	        vec4 _437 = vec4(0.0);
	        vec4 _436 = vec4(0.0);
	        int _435 = 0;
	        uint _434 = 0u;
	        int dy = -2;
	        bool _762;
	        bool _763;
	        bool _765;
	        bool _768;
	        for (;;)
	        {
	            if (!(dy <= 2))
	            {
	                break;
	            }
	            int dx = -2;
	            for (;;)
	            {
	                bool _892_ladder_break = false;
	                do
	                {
	                    if (!(dx <= 2))
	                    {
	                        _892_ladder_break = true;
	                        break;
	                    }
	                    ivec2 _906 = ivec2(gl_LaunchIDEXT.xy + uvec2(ivec2(dx, dy)));
	                    int _907 = _906.x;
	                    if (_907 < 0)
	                    {
	                        _765 = true;
	                    }
	                    else
	                    {
	                        _765 = uint(_907) >= gl_LaunchSizeEXT.x;
	                    }
	                    if (_765)
	                    {
	                        break;
	                    }
	                    int _919 = _906.y;
	                    if (_919 < 0)
	                    {
	                        _768 = true;
	                    }
	                    else
	                    {
	                        _768 = uint(_919) >= gl_LaunchSizeEXT.y;
	                    }
	                    if (_768)
	                    {
	                        break;
	                    }
	                    if (texelFetch(g_LuxelChartIDs, ivec2(uvec2(_906)), 0).x != _862)
	                    {
	                        break;
	                    }
	                    uint nSample = (uint(_919) * gl_LaunchSizeEXT.y) + uint(_907);
	                    if (g_LightmapSamples_1._m0[nSample].m_vPositionWs.w <= 0.0)
	                    {
	                        break;
	                    }
	                    vec2 vDx = (g_LightmapSamples_1._m0[nSample].m_vLightmapUv.xy * g_PushConstants.m_vLightmapOffsetAndSize.zw) - _870;
	                    float _968 = 0.79788458347320556640625 * exp(dot(vDx, vDx) * (-2.0));
	                    float _769 = vSeed.y;
	                    do
	                    {
	                        float _973 = flReservoirWt;
	                        float _974 = _973 + _968;
	                        flReservoirWt = _974;
	                        if (_974 == 0.0)
	                        {
	                            _763 = false;
	                            break;
	                        }
	                        float _979 = _968 / flReservoirWt;
	                        do
	                        {
	                            if (_979 <= 0.0)
	                            {
	                                _762 = false;
	                                break;
	                            }
	                            if (_979 >= 1.0)
	                            {
	                                _762 = true;
	                                break;
	                            }
	                            if (_769 < _979)
	                            {
	                                _769 = min(_769 / _979, 0.99999988079071044921875);
	                                _762 = true;
	                                break;
	                            }
	                            _769 = min((_769 - _979) / (1.0 - _979), 0.99999988079071044921875);
	                            _762 = false;
	                            break;
	                        } while(false);
	                        _763 = _762;
	                        break;
	                    } while(false);
	                    vec2 _1003 = vSeed;
	                    _1003.y = _769;
	                    vSeed = _1003;
	                    if (_763)
	                    {
	                        _440 = g_LightmapSamples_1._m0[nSample].m_vPositionWs;
	                        _439 = g_LightmapSamples_1._m0[nSample].m_vShadingNormalWs_vTransmissiveR;
	                        _438 = g_LightmapSamples_1._m0[nSample].m_vInterpolatedNormalWs_vTransmissiveG;
	                        _437 = g_LightmapSamples_1._m0[nSample].m_vFaceNormalWs_vTransmissiveB;
	                        _436 = g_LightmapSamples_1._m0[nSample].m_vTangentWs;
	                        _435 = g_LightmapSamples_1._m0[nSample].m_nInstanceFlags;
	                        _434 = g_LightmapSamples_1._m0[nSample].m_nSampleFlags;
	                    }
	                    break;
	                } while(false);
	                if (_892_ladder_break)
	                {
	                    break;
	                }
	                dx++;
	                continue;
	            }
	            dy++;
	            continue;
	        }
	        if (!(_440.w != 0.0))
	        {
	            break;
	        }
	        vec3 _1023 = abs(_440.xyz);
	        vec3 _433 = _440.xyz + (_437.xyz * ((abs(_440.xyz) + vec3(abs(max(_1023.x, max(_1023.y, _1023.z))))) * 9.9999997473787516355514526367188e-05));
	        vec3 _1039 = abs(_440.xyz);
	        vec3 _432 = _440.xyz + ((-_437.xyz) * ((abs(_440.xyz) + vec3(abs(max(_1039.x, max(_1039.y, _1039.z))))) * 9.9999997473787516355514526367188e-05));
	        f16vec3 _331 = f16vec3(_439.xyz);
	        vec3 _431 = _437.xyz;
	        vec3 _374;
	        vec3 _766 = _374;
	        vec3 _373;
	        vec3 _767 = _373;
	        float _761;
	        if (_439.z >= 0.0)
	        {
	            _761 = 1.0;
	        }
	        else
	        {
	            _761 = -1.0;
	        }
	        float _1065 = (-1.0) / (_761 + _439.z);
	        float _1069 = (_439.x * _439.y) * _1065;
	        vec3 _1074 = _766;
	        _1074.x = 1.0 + (((_761 * _439.x) * _439.x) * _1065);
	        _1074.y = _761 * _1069;
	        _1074.z = (-_761) * _439.x;
	        _766 = _1074;
	        vec3 _1081 = _767;
	        _1081.x = _1069;
	        _1081.y = _761 + ((_439.y * _439.y) * _1065);
	        _1081.z = -_439.y;
	        _767 = _1081;
	        _374 = _1074;
	        _373 = _1081;
	        f16vec3 _329 = f16vec3(vec3(1.0));
	        int _430 = _435;
	        vec3 vTransmissiveRatio = vec3(_439.w, _438.w, _437.w);
	        vec4 _429 = vec4(0.0);
	        vec4 _428 = vec4(0.0);
	        vec4 _427 = vec4(0.0);
	        vec4 _426 = vec4(0.0);
	        vec4 _425 = vec4(0.0);
	        vec4 _424 = vec4(0.0);
	        vec4 _423 = vec4(0.0);
	        vec4 _422 = vec4(0.0);
	        vec4 _421 = vec4(0.0);
	        vec4 _420 = vec4(0.0);
	        ivec4 _419 = ivec4(255);
	        vec4 _418 = vec4(0.0);
	        vec4 _417 = vec4(0.0);
	        vec4 _416 = vec4(0.0);
	        if (all(greaterThanEqual(_440.xyz, g_PushConstants.m_vCordonMins.xyz)))
	        {
	            _765 = all(lessThanEqual(_440.xyz, g_PushConstants.m_vCordonMaxs.xyz));
	        }
	        else
	        {
	            _765 = false;
	        }
	        if (_765)
	        {
	            f16vec4 _325;
	            uint _326;
	            float16_t _327;
	            float16_t _328;
	            float16_t _330;
	            if ((_434 & 2u) != 0u)
	            {
	                f16vec3 _1129 = f16vec3(vec3(0.0));
	                vec3 _441;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _441, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_1129, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1129, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _433 + (_437.xyz * 0.037500001490116119384765625), 0.0, -_437.xyz, 0.07500000298023223876953125, 0);
	                if (p._m5 != (-1))
	                {
	                    _331 = p._m7.vMaterialBits;
	                    _330 = p._m7._m1;
	                    _329 = p._m7._m2;
	                    _328 = p._m7._m3;
	                    _327 = p._m7._m5;
	                    _326 = p._m7._m6;
	                    _325 = p._m7._m7;
	                }
	            }
	            uint _1148 = _434;
	            uint _1149 = _1148 & 4294967292u;
	            _434 = _1149;
	            vec4 _1152 = _417;
	            _1152.x = _438.x;
	            _1152.y = _438.y;
	            _1152.z = _438.z;
	            _417 = _1152;
	            _418 = _436;
	            vec3 _370;
	            float _371;
	            float _372;
	            vec3 _445 = _433;
	            vec3 _444 = _432;
	            vec3 _443 = _431;
	            int _442 = _430;
	            f16vec3 _338 = _331;
	            float16_t _337 = _330;
	            f16vec3 _336 = _329;
	            float16_t _335 = _328;
	            float16_t _334 = _327;
	            uint _333 = _326;
	            f16vec4 _332 = _325;
	            vec3 _379 = _374;
	            vec3 _378 = _373;
	            float _377 = _372;
	            float _376 = _371;
	            vec3 _375 = _370;
	            vec2 _757 = vSeed;
	            float _758;
	            if ((_1149 & 3u) != 0u)
	            {
	                _758 = 0.5;
	            }
	            else
	            {
	                float _1182 = max(_439.w, max(_438.w, _437.w));
	                _758 = _1182 / (_1182 + 1.0);
	            }
	            float _759 = _757.x;
	            bool _756;
	            do
	            {
	                if (_758 <= 0.0)
	                {
	                    _756 = false;
	                    break;
	                }
	                if (_758 >= 1.0)
	                {
	                    _756 = true;
	                    break;
	                }
	                if (_759 < _758)
	                {
	                    _759 = min(_759 / _758, 0.99999988079071044921875);
	                    _756 = true;
	                    break;
	                }
	                _759 = min((_759 - _758) / (1.0 - _758), 0.99999988079071044921875);
	                _756 = false;
	                break;
	            } while(false);
	            vec2 _1210 = _757;
	            _1210.x = _759;
	            _757 = _1210;
	            if (_756)
	            {
	                _445 = _444;
	            }
	            else
	            {
	                _758 = 1.0 - _758;
	            }
	            float _1220 = sqrt(_757.y);
	            float _1222 = 6.283185482025146484375 * _757.x;
	            vec3 _1230 = vec3(cos(_1222) * _1220, sin(_1222) * _1220, sqrt(max(0.0, 1.0 - _757.y)));
	            vec3 _760 = _1230;
	            float _1233 = _758;
	            if (_756)
	            {
	                _758 = -_760.z;
	            }
	            else
	            {
	                _758 = _760.z;
	            }
	            vec3 _1244 = _760;
	            _1244.z = _758;
	            _760 = _1244;
	            vec3 _1251 = mat3(_379, _378, vec3(_338)) * _1244;
	            vec3 _745 = _1251;
	            vec3 _455 = _445;
	            vec3 _454 = _444;
	            vec3 _453 = _443;
	            int _452 = _442;
	            f16vec3 _353 = _338;
	            float16_t _352 = _337;
	            f16vec3 _351 = _336;
	            float16_t _350 = _335;
	            float16_t _349 = _334;
	            uint _348 = _333;
	            f16vec4 _347 = _332;
	            vec3 _389 = _379;
	            vec3 _388 = _378;
	            float _387 = _377;
	            float _386 = _376;
	            vec3 _385 = _375;
	            int _746 = 1;
	            vec3 _747 = vec3(1.0 / (_1233 * (_1230.z * 0.3183098733425140380859375)));
	            vec3 _748 = vec3(0.0);
	            vec3 _456;
	            vec3 _469;
	            vec3 _489;
	            bool _583;
	            float _584;
	            bool _585;
	            vec3 _586;
	            bool _587;
	            vec3 _588;
	            vec3 _589;
	            float _590;
	            float _591;
	            bool _592;
	            vec3 _593;
	            bool _594;
	            vec3 _595;
	            bool _598;
	            bool _599;
	            bool _601;
	            float _602;
	            uint _603;
	            float _604;
	            bool _605;
	            float _606;
	            bool _607;
	            bool _608;
	            float _609;
	            float _610;
	            float _611;
	            bool _612;
	            float _613;
	            bool _614;
	            vec3 _615;
	            bool _616;
	            vec3 _617;
	            vec3 _618;
	            bool _619;
	            bool _620;
	            float _621;
	            vec4 _622;
	            vec4 _623;
	            float _624;
	            vec3 _625;
	            float _626;
	            float _627;
	            bool _628;
	            float _629;
	            vec4 _630;
	            vec2 _631;
	            float _632;
	            float _633;
	            vec4 _634;
	            float _635;
	            vec3 _636;
	            vec3 _637;
	            bool _638;
	            float _639;
	            vec4 _640;
	            vec2 _641;
	            float _642;
	            float _643;
	            vec3 _645;
	            vec3 _646;
	            vec4 _648;
	            float _649;
	            float _650;
	            vec3 _651;
	            vec3 _652;
	            float _653;
	            float _654;
	            bool _655;
	            vec3 _656;
	            vec3 _657;
	            bool _658;
	            bool _659;
	            vec3 _660;
	            bool _665;
	            float _668;
	            float _670;
	            bool _671;
	            vec3 _672;
	            bool _673;
	            vec3 _674;
	            vec3 _675;
	            vec4 _676;
	            vec4 _677;
	            float _678;
	            vec3 _679;
	            float _680;
	            float _681;
	            bool _682;
	            float _683;
	            vec4 _684;
	            vec2 _685;
	            float _686;
	            float _687;
	            vec4 _688;
	            float _689;
	            vec3 _690;
	            vec3 _691;
	            bool _692;
	            float _693;
	            vec4 _694;
	            vec2 _695;
	            float _696;
	            float _697;
	            vec3 _699;
	            vec3 _700;
	            vec4 _702;
	            float _703;
	            float _704;
	            vec3 _705;
	            vec3 _706;
	            float _707;
	            float _708;
	            bool _709;
	            vec3 _710;
	            vec3 _711;
	            bool _712;
	            bool _713;
	            vec3 _714;
	            float _719;
	            bool _720;
	            bool _721;
	            bool _722;
	            vec3 _724;
	            float _726;
	            float _727;
	            bool _730;
	            float _731;
	            float _732;
	            bool _735;
	            float _736;
	            float _737;
	            float _738;
	            bool _739;
	            bool _741;
	            vec3 _743;
	            vec3 _744;
	            vec3 _749;
	            float _750;
	            float _753;
	            vec3 _755;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_746 <= 16))
	                {
	                    break;
	                }
	                if (false)
	                {
	                    if (_746 > (-1))
	                    {
	                        _750 = 1.0;
	                        _749 = vec3(0.0);
	                    }
	                    else
	                    {
	                        if (_746 != (-1))
	                        {
	                            _750 = 0.0;
	                        }
	                        else
	                        {
	                            _750 = 1.0;
	                        }
	                        _749 = _747;
	                    }
	                }
	                else
	                {
	                    _750 = 1.0;
	                    _749 = _747;
	                }
	                if (all(equal(_749, vec3(0.0))))
	                {
	                    break;
	                }
	                vec3 _451 = _455;
	                vec3 _450 = _745;
	                vec2 _1309 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_831.xy, int(1u + uint(_746)))))).xy;
	                f16vec3 _1311 = f16vec3(vec3(0.0));
	                vec2 _1317 = _1309;
	                _1317.y = 0.0;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _456, 3.4028234663852885981170418348452e+38, _1309.y, -1, false, MaterialDataMinimal_t(_1311, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1311, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 4u, 0u, 2u, 0u, _455, 0.0, _745, 56755.83984375, 0);
	                Payload_t _1319 = p;
	                vec2 _1321 = _1309;
	                _1321.y = _1319._m4;
	                vec2 _751 = _1321;
	                if (!(_1319._m5 != (-1)))
	                {
	                    vec2 _1338 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_831.xy, int(1u + uint(_746 + 1)))))).xy;
	                    _751 = _1338;
	                    vec2 _740 = _1338;
	                    if (_745.z < 0.0)
	                    {
	                        float _742 = _740.y;
	                        do
	                        {
	                            if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w <= 0.0)
	                            {
	                                _739 = false;
	                                break;
	                            }
	                            if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w >= 1.0)
	                            {
	                                _739 = true;
	                                break;
	                            }
	                            if (_742 < g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w)
	                            {
	                                _742 = min(_742 / g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                                _739 = true;
	                                break;
	                            }
	                            _742 = min((_742 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                            _739 = false;
	                            break;
	                        } while(false);
	                        vec2 _1374 = _740;
	                        _1374.y = _742;
	                        _740 = _1374;
	                        _741 = _739;
	                    }
	                    else
	                    {
	                        _741 = false;
	                    }
	                    if (_741)
	                    {
	                        float _1386 = sqrt(_740.y);
	                        float _1388 = 6.283185482025146484375 * _740.x;
	                        _743 = vec3(cos(_1388) * _1386, sin(_1388) * _1386, sqrt(max(0.0, 1.0 - _740.y)));
	                        _744 = g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.xyz;
	                    }
	                    else
	                    {
	                        _743 = _745;
	                        _744 = g_SceneGlobalInfo._m0[0].m_vSkyColor.xyz;
	                    }
	                    if (g_SceneGlobalInfo._m0[0].m_vIBLParams.x >= 0)
	                    {
	                        vec3 _1444 = clamp(normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_743, 0.0)), vec3(-1.0), vec3(1.0));
	                        float _1445 = _1444.y;
	                        float _1446 = _1444.x;
	                        float _1447 = _1445 / _1446;
	                        float _1448 = abs(_1447);
	                        bool _1449 = _1448 < 1.0;
	                        if (_1449)
	                        {
	                            _737 = _1448;
	                        }
	                        else
	                        {
	                            _737 = 1.0 / _1448;
	                        }
	                        float _1454 = _737;
	                        float _1455 = _1454 * _1454;
	                        float _1460 = (1.0 + (((-0.3018949925899505615234375) + (0.087292902171611785888671875 * _1455)) * _1455)) * _1454;
	                        if (_1449)
	                        {
	                            _737 = _1460;
	                        }
	                        else
	                        {
	                            _737 = 1.57079601287841796875 - _1460;
	                        }
	                        float _1471 = uintBitsToFloat((floatBitsToUint(_737) & 2147483647u) | (floatBitsToUint(_1447) & 2147483648u));
	                        if (_1446 < 0.0)
	                        {
	                            _738 = _1471 + uintBitsToFloat(1078530011u | (floatBitsToUint(_1445) & 2147483648u));
	                        }
	                        else
	                        {
	                            _738 = _1471;
	                        }
	                        float _1483 = _1444.z;
	                        float _1484 = abs(_1483);
	                        float _1492 = (((-0.15658299624919891357421875) * _1484) + 1.57079637050628662109375) * intBitsToFloat(532487669 + (floatBitsToInt(1.0 - _1484) >> 1));
	                        if (_1483 >= 0.0)
	                        {
	                            _736 = _1492;
	                        }
	                        else
	                        {
	                            _736 = 3.1415927410125732421875 - _1492;
	                        }
	                        vec3 _1507 = g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * textureLod(sampler2D(g_bindless_Texture2D[g_SceneGlobalInfo._m0[0].m_vIBLParams.x], g_Sampler), vec2(_738 * 0.15915493667125701904296875, _736 * 0.3183098733425140380859375), 0.0).xyz;
	                        if (dot(_1507.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	                        {
	                            _744 += _1507;
	                        }
	                    }
	                    if (g_SceneGlobalInfo._m0[0].m_vIBLParams.y >= 0)
	                    {
	                        vec4 _1554 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._m0[0].m_vIBLParams.y], g_Sampler), normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_743, 0.0)), 0.0);
	                        if (dot(_1554.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	                        {
	                            _744 += (g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * _1554.xyz);
	                        }
	                    }
	                    if (_746 > 1)
	                    {
	                        _744 *= g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.w;
	                    }
	                    if (_741)
	                    {
	                        _744 *= g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.xyz;
	                    }
	                    _748 += ((_749 * _744) * _750);
	                    break;
	                }
	                if ((int((g_instanceBuffer_1._m0[uint(_1319._m5)].nMaterialFlags_nInstanceFlags >> uint(16)) & 65535u) & 4) != 0)
	                {
	                    break;
	                }
	                uint _1606 = uint(_1319._m5);
	                vec3 _460 = (_451 + (_450 * _1319._m3)) + (_1319._m1 * ((abs(_451) + vec3(abs(_1319._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _459 = (_451 + (_450 * _1319._m3)) + ((-_1319._m1) * ((abs(_451) + vec3(abs(_1319._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _458 = _1319._m1;
	                int _457 = int((g_instanceBuffer_1._m0[_1606].nMaterialFlags_nInstanceFlags) & 65535u);
	                vec3 _465 = vec3(0.0);
	                vec3 _464 = vec3(0.0);
	                float _463 = 0.0;
	                float _462 = 0.0;
	                vec3 _461 = vec3(0.0);
	                f16vec3 _402 = _1319._m7.vMaterialBits;
	                float16_t _401 = _1319._m7._m1;
	                f16vec3 _400 = _1319._m7._m2;
	                f16vec3 _398 = _1319._m7._m4;
	                float16_t _397 = _1319._m7._m5;
	                uint _396 = _1319._m7._m6;
	                f16vec4 _395 = _1319._m7._m7;
	                float16_t _399 = float16_t(max(float(_1319._m7._m3), 0.07999999821186065673828125));
	                vec3 _1653 = vec3(_1319._m7.vMaterialBits);
	                vec3 _733 = vec3(0.0);
	                vec3 _734 = vec3(0.0);
	                float _1654 = _1653.z;
	                if (_1654 >= 0.0)
	                {
	                    _732 = 1.0;
	                }
	                else
	                {
	                    _732 = -1.0;
	                }
	                float _1661 = (-1.0) / (_732 + _1654);
	                float _1662 = _1653.x;
	                float _1663 = _1653.y;
	                float _1665 = (_1662 * _1663) * _1661;
	                vec3 _1670 = _733;
	                _1670.x = 1.0 + (((_732 * _1662) * _1662) * _1661);
	                _1670.y = _732 * _1665;
	                _1670.z = (-_732) * _1662;
	                _733 = _1670;
	                vec3 _1677 = _734;
	                _1677.x = _1665;
	                _1677.y = _732 + ((_1663 * _1663) * _1661);
	                _1677.z = -_1663;
	                _734 = _1677;
	                _465 = _1670;
	                _464 = _1677;
	                vec3 _1689 = transpose(mat3(_1670, _1677, vec3(_402))) * (-_450);
	                _461 = _1689;
	                vec3 _1697 = vec3(mix(f16vec3(_397), _400, f16vec3(_401)));
	                _463 = dot((_1697 + ((vec3(1.0) - _1697) * pow(max(0.0, 1.0 - _1689.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                if ((_396 & 65535u) == 1u)
	                {
	                    float _1716 = dot(vec3(_395.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                    _462 = _1716 / max(9.9999997473787516355514526367188e-05, _1716 + dot(vec3(_400).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                }
	                f16vec3 _361 = _402;
	                float16_t _360 = _401;
	                f16vec3 _359 = _400;
	                float16_t _358 = _399;
	                f16vec3 _357 = _398;
	                float16_t _356 = _397;
	                uint _355 = _396;
	                f16vec4 _354 = _395;
	                vec3 _394 = _465;
	                vec3 _393 = _464;
	                float _392 = _463;
	                float _391 = _462;
	                vec3 _390 = _461;
	                if (true)
	                {
	                    if ((_457 & 256) != 0)
	                    {
	                        _357 *= float16_t(g_instanceBuffer_1._m0[_1606].fEmissiveBoost);
	                    }
	                    else
	                    {
	                        _357 = f16vec3(vec3(0.0));
	                    }
	                }
	                if (true)
	                {
	                    _735 = any(notEqual(_1319.material, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _735 = false;
	                }
	                vec3 _1757 = _1319.material - _460;
	                float _1758 = length(_1757);
	                vec3 _468 = _460;
	                float _467 = 0.0;
	                vec3 _466 = vec4(_1757 / vec3(_1758), _1758).xyz;
	                if (_735)
	                {
	                    _731 = _1758;
	                }
	                else
	                {
	                    _731 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _468, _467, _466, _731, 1);
	                if (_735)
	                {
	                    _731 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _731 = 0.0;
	                }
	                if (_731 == 1.0)
	                {
	                    _460 = _1319.material;
	                    _458 = vec3(_1319._m7.vMaterialBits);
	                }
	                vec3 _449 = _460;
	                vec3 _448 = _459;
	                vec3 _447 = _458;
	                int _446 = _457;
	                f16vec3 _346 = _361;
	                float16_t _345 = _360;
	                f16vec3 _344 = _359;
	                float16_t _343 = _358;
	                f16vec3 _342 = _357;
	                float16_t _341 = _356;
	                uint _340 = _355;
	                f16vec4 _339 = _354;
	                vec3 _384 = _394;
	                vec3 _383 = _393;
	                float _382 = _392;
	                float _381 = _391;
	                vec3 _380 = _390;
	                if (!(dot(_458, -_745) > 0.0))
	                {
	                    if ((_446 & 1024) != 0)
	                    {
	                        _447 = -_447;
	                        _346 = -_346;
	                        vec3 _2036 = _455;
	                        _455 = _454;
	                        _454 = _2036;
	                    }
	                    else
	                    {
	                        f16vec3 _1817 = f16vec3(vec3(0.0));
	                        vec2 _1823 = _1309;
	                        _1823.y = 0.0;
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _469, 3.4028234663852885981170418348452e+38, _1309.y, -1, false, MaterialDataMinimal_t(_1817, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1817, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 4u, 0u, 2u, 0u, _451, _1319._m3 * 0.99989998340606689453125, _450, _1319._m3 * 1.00010001659393310546875, 0);
	                        vec2 _1829 = _1309;
	                        _1829.y = p._m4;
	                        _751 = _1829;
	                        if (p._m5 != (-1))
	                        {
	                            uint _1838 = uint(p._m5);
	                            vec3 _473 = (_451 + (_450 * p._m3)) + (p._m1 * ((abs(_451) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _472 = (_451 + (_450 * p._m3)) + ((-p._m1) * ((abs(_451) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _471 = p._m1;
	                            int _470 = int((g_instanceBuffer_1._m0[_1838].nMaterialFlags_nInstanceFlags) & 65535u);
	                            vec3 _478 = vec3(0.0);
	                            vec3 _477 = vec3(0.0);
	                            float _476 = 0.0;
	                            float _475 = 0.0;
	                            vec3 _474 = vec3(0.0);
	                            f16vec3 _415 = p._m7.vMaterialBits;
	                            float16_t _414 = p._m7._m1;
	                            f16vec3 _413 = p._m7._m2;
	                            f16vec3 _411 = p._m7._m4;
	                            float16_t _410 = p._m7._m5;
	                            uint _409 = p._m7._m6;
	                            f16vec4 _408 = p._m7._m7;
	                            float16_t _412 = float16_t(max(float(p._m7._m3), 0.07999999821186065673828125));
	                            vec3 _1885 = vec3(p._m7.vMaterialBits);
	                            vec3 _728 = vec3(0.0);
	                            vec3 _729 = vec3(0.0);
	                            float _1886 = _1885.z;
	                            if (_1886 >= 0.0)
	                            {
	                                _727 = 1.0;
	                            }
	                            else
	                            {
	                                _727 = -1.0;
	                            }
	                            float _1893 = (-1.0) / (_727 + _1886);
	                            float _1894 = _1885.x;
	                            float _1895 = _1885.y;
	                            float _1897 = (_1894 * _1895) * _1893;
	                            vec3 _1902 = _728;
	                            _1902.x = 1.0 + (((_727 * _1894) * _1894) * _1893);
	                            _1902.y = _727 * _1897;
	                            _1902.z = (-_727) * _1894;
	                            _728 = _1902;
	                            vec3 _1909 = _729;
	                            _1909.x = _1897;
	                            _1909.y = _727 + ((_1895 * _1895) * _1893);
	                            _1909.z = -_1895;
	                            _729 = _1909;
	                            _478 = _1902;
	                            _477 = _1909;
	                            vec3 _1921 = transpose(mat3(_1902, _1909, vec3(_415))) * (-_450);
	                            _474 = _1921;
	                            vec3 _1929 = vec3(mix(f16vec3(_410), _413, f16vec3(_414)));
	                            _476 = dot((_1929 + ((vec3(1.0) - _1929) * pow(max(0.0, 1.0 - _1921.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if ((_409 & 65535u) == 1u)
	                            {
	                                float _1948 = dot(vec3(_408.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                _475 = _1948 / max(9.9999997473787516355514526367188e-05, _1948 + dot(vec3(_413).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                            }
	                            f16vec3 _369 = _415;
	                            float16_t _368 = _414;
	                            f16vec3 _367 = _413;
	                            float16_t _366 = _412;
	                            f16vec3 _365 = _411;
	                            float16_t _364 = _410;
	                            uint _363 = _409;
	                            f16vec4 _362 = _408;
	                            vec3 _407 = _478;
	                            vec3 _406 = _477;
	                            float _405 = _476;
	                            float _404 = _475;
	                            vec3 _403 = _474;
	                            if (true)
	                            {
	                                if ((_470 & 256) != 0)
	                                {
	                                    _365 *= float16_t(g_instanceBuffer_1._m0[_1838].fEmissiveBoost);
	                                }
	                                else
	                                {
	                                    _365 = f16vec3(vec3(0.0));
	                                }
	                            }
	                            if (true)
	                            {
	                                _730 = any(notEqual(p.material, vec3(3.4028234663852885981170418348452e+38)));
	                            }
	                            else
	                            {
	                                _730 = false;
	                            }
	                            vec3 _1989 = p.material - _473;
	                            float _1990 = length(_1989);
	                            vec3 _481 = _473;
	                            float _480 = 0.0;
	                            vec3 _479 = vec4(_1989 / vec3(_1990), _1990).xyz;
	                            if (_730)
	                            {
	                                _726 = _1990;
	                            }
	                            else
	                            {
	                                _726 = 0.0;
	                            }
	                            p_1 = PayloadShadow_t(1.0);
	                            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _481, _480, _479, _726, 1);
	                            if (_730)
	                            {
	                                _726 = p_1.m_flVisibility;
	                            }
	                            else
	                            {
	                                _726 = 0.0;
	                            }
	                            if (_726 == 1.0)
	                            {
	                                _473 = p.material;
	                                _471 = vec3(p._m7.vMaterialBits);
	                            }
	                            _449 = _473;
	                            _448 = _472;
	                            _447 = _471;
	                            _446 = _470;
	                            _346 = _369;
	                            _345 = _368;
	                            _344 = _367;
	                            _343 = _366;
	                            _342 = _365;
	                            _341 = _364;
	                            _340 = _363;
	                            _339 = _362;
	                            _384 = _407;
	                            _383 = _406;
	                            _382 = _405;
	                            _381 = _404;
	                            _380 = _403;
	                        }
	                        else
	                        {
	                            break;
	                        }
	                    }
	                }
	                vec3 _2053 = (_449 + _448) * 0.5;
	                bool _2054 = _746 != 0;
	                if ((_340 & 65535u) == 1u)
	                {
	                    _721 = any(greaterThan(vec3(_339.xyz), vec3(0.0)));
	                }
	                else
	                {
	                    _721 = false;
	                }
	                if (_721)
	                {
	                    _722 = true;
	                }
	                else
	                {
	                    if ((_340 & 65535u) == 2u)
	                    {
	                        _720 = float(_339.x) > 0.0;
	                    }
	                    else
	                    {
	                        _720 = false;
	                    }
	                    _722 = _720;
	                }
	                vec2 _2088 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_831.xy, int(1u + ((2u * _832) + uint(_746))))))).xy;
	                bool _723 = false;
	                vec3 _2101 = (_449 + _448) * 0.5;
	                uvec3 _2106 = min(uvec3(max(fma(_2101, _856, _858), vec3(0.0))), (_853 - uvec3(1u)));
	                uint _715 = 0u;
	                vec3 _716 = vec3(0.0);
	                for (;;)
	                {
	                    if (!(_715 < _852))
	                    {
	                        break;
	                    }
	                    uint _2119 = _852 * _853.x;
	                    uint _717 = subgroupOr(g_LightBins_1._m0[((((_2119 * _853.y) * _2106.z) + (_2119 * _2106.y)) + (_852 * _2106.x)) + _715]);
	                    vec3 _718 = _716;
	                    for (;;)
	                    {
	                        bool _2139_ladder_break = false;
	                        do
	                        {
	                            if (!(_717 != 0u))
	                            {
	                                _2139_ladder_break = true;
	                                break;
	                            }
	                            uint _2146 = _717;
	                            uint _2150 = uint(findLSB(_2146)) + (_715 * 32u);
	                            uint _2152 = _2146 & (_2146 - 1u);
	                            mat4 _2182 = mat4(vec4(g_Lights_1._m0[_2150].m_mToClipSpace.data[0].x, g_Lights_1._m0[_2150].m_mToClipSpace.data[1].x, g_Lights_1._m0[_2150].m_mToClipSpace.data[2].x, g_Lights_1._m0[_2150].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_2150].m_mToClipSpace.data[0].y, g_Lights_1._m0[_2150].m_mToClipSpace.data[1].y, g_Lights_1._m0[_2150].m_mToClipSpace.data[2].y, g_Lights_1._m0[_2150].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_2150].m_mToClipSpace.data[0].z, g_Lights_1._m0[_2150].m_mToClipSpace.data[1].z, g_Lights_1._m0[_2150].m_mToClipSpace.data[2].z, g_Lights_1._m0[_2150].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_2150].m_mToClipSpace.data[0].w, g_Lights_1._m0[_2150].m_mToClipSpace.data[1].w, g_Lights_1._m0[_2150].m_mToClipSpace.data[2].w, g_Lights_1._m0[_2150].m_mToClipSpace.data[3].w));
	                            if ((uint(g_Lights_1._m0[_2150].m_nPathTraceFlags) & 1u) == 0u)
	                            {
	                                _717 = _2152;
	                                break;
	                            }
	                            if ((g_Lights_1._m0[_2150].m_nPathTraceFlags & 8) != 0)
	                            {
	                                _723 = true;
	                                _717 = _2152;
	                                break;
	                            }
	                            do
	                            {
	                                do
	                                {
	                                    vec4 _2257 = _2182 * vec4(_2101.xyz, 1.0);
	                                    vec3 _2261 = _2257.xyz / vec3(_2257.w);
	                                    vec4 _2263;
	                                    _2263.x = _2261.x;
	                                    _2263.y = _2261.y;
	                                    _2263.z = _2261.z;
	                                    if (all(greaterThanEqual(_2263.xyz, vec3(-1.0, -1.0, 0.0))))
	                                    {
	                                        _712 = all(lessThanEqual(_2263.xyz, vec3(1.0)));
	                                    }
	                                    else
	                                    {
	                                        _712 = false;
	                                    }
	                                    if (!_712)
	                                    {
	                                        _713 = false;
	                                        break;
	                                    }
	                                    if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_2150].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_2101, 1.0)).xyz), vec3(1.0))))
	                                    {
	                                        _713 = false;
	                                        break;
	                                    }
	                                    _713 = true;
	                                    break;
	                                } while(false);
	                                if (!_713)
	                                {
	                                    _714 = vec3(0.0);
	                                    break;
	                                }
	                                vec4 _2295 = _2182 * vec4(_2101.xyz, 1.0);
	                                vec3 _2299 = _2295.xyz / vec3(_2295.w);
	                                vec4 _2301;
	                                _2301.x = _2299.x;
	                                _2301.y = _2299.y;
	                                _2301.z = _2299.z;
	                                if (_2054)
	                                {
	                                    _711 = g_Lights_1._m0[_2150].m_vBounceColor.xyz;
	                                }
	                                else
	                                {
	                                    _711 = g_Lights_1._m0[_2150].m_vColor.xyz;
	                                }
	                                if (true)
	                                {
	                                    if (g_Lights_1._m0[_2150].m_nCookie >= 0)
	                                    {
	                                        if (g_Lights_1._m0[_2150].m_bSphericalCookie != 0)
	                                        {
	                                            vec4 _2344 = vec4(-g_Lights_1._m0[_2150].m_vOrientation.xyz, g_Lights_1._m0[_2150].m_vOrientation.w);
	                                            vec4 _2346 = _2344.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                            vec3 _2349 = _2346.xyz;
	                                            vec3 _2350 = vec4((-normalize(g_Lights_1._m0[_2150].m_vLightPosition.xyz - _2101)).xyz, 0.0).xyz;
	                                            vec4 _2357 = vec4((_2350 * _2346.w) + cross(_2350, _2349), -dot(_2350, _2349));
	                                            vec3 _2358 = _2357.xyz;
	                                            float _2359 = _2344.w;
	                                            vec3 _2361 = _2344.xyz;
	                                            float _2362 = _2357.w;
	                                            vec3 _2370 = vec4(((_2358 * _2359) + (_2361 * _2362)) + cross(_2361, _2358), _323).xyz;
	                                            vec2 _2379 = vec2(atan(_2370.y, -_2370.x) * 0.15915493667125701904296875, acos(_2370.z) * 0.3183098733425140380859375);
	                                            vec2 _2384 = (_2379.xy * g_Lights_1._m0[_2150].m_vCookieParameters.zw) + g_Lights_1._m0[_2150].m_vCookieParameters.xy;
	                                            vec2 _2386 = _2379;
	                                            _2386.x = _2384.x;
	                                            _2386.y = _2384.y;
	                                            _710 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_2150].m_nCookie], g_Sampler), _2386, 0.0).xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _2323 = fma(_2301.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                            vec2 _2328 = (_2323.xy * g_Lights_1._m0[_2150].m_vCookieParameters.zw) + g_Lights_1._m0[_2150].m_vCookieParameters.xy;
	                                            vec2 _2330 = _2323;
	                                            _2330.x = _2328.x;
	                                            _2330.y = _2328.y;
	                                            _710 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_2150].m_nCookie], g_CookieSampler), _2330, 0.0).xyz;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _710 = vec3(1.0);
	                                    }
	                                    _711 *= _710;
	                                }
	                                if (g_Lights_1._m0[_2150].m_nLuminaireType != 0)
	                                {
	                                    _711 = (_711 * g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                }
	                                else
	                                {
	                                    if (!(g_Lights_1._m0[_2150].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _2406 = g_Lights_1._m0[_2150].m_vLightPosition.xyz - _2101;
	                                        _711 *= (vec3(g_Lights_1._m0[_2150].m_vLightPosition.w) / max(vec3(dot(_2406, _2406)), vec3(g_Lights_1._m0[_2150].m_vLightPosition.w)));
	                                    }
	                                }
	                                if (g_Lights_1._m0[_2150].m_vDistanceFade_vSkirt.z > 0.0)
	                                {
	                                    _707 = smoothstep(0.0, 1.0, _2301.xyz.z * g_Lights_1._m0[_2150].m_vDistanceFade_vSkirt.z);
	                                }
	                                else
	                                {
	                                    _707 = 1.0;
	                                }
	                                if (g_Lights_1._m0[_2150].m_vDistanceFade_vSkirt.w > 0.0)
	                                {
	                                    _707 *= smoothstep(0.0, 1.0, (1.0 - _2301.xyz.z) * g_Lights_1._m0[_2150].m_vDistanceFade_vSkirt.w);
	                                }
	                                if (!(g_Lights_1._m0[_2150].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _2447 = g_Lights_1._m0[_2150].m_vLightPosition.xyz - _2101;
	                                    float _2448 = length(_2447);
	                                    vec3 _2450 = _2447 / vec3(_2448);
	                                    float _2456 = _707 * smoothstep(0.0, 1.0, g_Lights_1._m0[_2150].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_2150].m_vDistanceFade_vSkirt.y * _2448));
	                                    if (g_Lights_1._m0[_2150].m_nLuminaireType != 2)
	                                    {
	                                        _709 = g_Lights_1._m0[_2150].m_nLuminaireType != 1;
	                                    }
	                                    else
	                                    {
	                                        _709 = false;
	                                    }
	                                    if (_709)
	                                    {
	                                        float _2468 = 2.0 * g_Lights_1._m0[_2150].m_vOrientation.x;
	                                        float _2472 = 2.0 * g_Lights_1._m0[_2150].m_vOrientation.w;
	                                        vec3 _2486 = vec3((_2468 * g_Lights_1._m0[_2150].m_vOrientation.y) - (_2472 * g_Lights_1._m0[_2150].m_vOrientation.z), (1.0 - (_2468 * g_Lights_1._m0[_2150].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_2150].m_vOrientation.z) * g_Lights_1._m0[_2150].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_2150].m_vOrientation.y) * g_Lights_1._m0[_2150].m_vOrientation.z) + (_2472 * g_Lights_1._m0[_2150].m_vOrientation.x)) * g_Lights_1._m0[_2150].m_vAngleFade.z;
	                                        vec3 _2487 = _2450 - _2486;
	                                        vec3 _2488 = _2450 + _2486;
	                                        do
	                                        {
	                                            vec3 _2491 = _2488 - _2487;
	                                            float _2493 = dot(-_2487, _2491);
	                                            if (_2493 <= 0.0)
	                                            {
	                                                _705 = _2487;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _2498 = dot(_2491, _2491);
	                                                if (_2493 > _2498)
	                                                {
	                                                    _705 = _2488;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    _705 = _2487 + (_2491 * (_2493 / _2498));
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (any(notEqual(_705, vec3(0.0))))
	                                        {
	                                            _706 = normalize(_705);
	                                        }
	                                        else
	                                        {
	                                            _706 = _705;
	                                        }
	                                        float _2522 = 2.0 * g_Lights_1._m0[_2150].m_vOrientation.x;
	                                        float _2525 = 2.0 * g_Lights_1._m0[_2150].m_vOrientation.w;
	                                        _708 = _2456 * clamp(g_Lights_1._m0[_2150].m_vAngleFade.x + (g_Lights_1._m0[_2150].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_2150].m_vOrientation.y) * g_Lights_1._m0[_2150].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_2150].m_vOrientation.z) * g_Lights_1._m0[_2150].m_vOrientation.z), (_2522 * g_Lights_1._m0[_2150].m_vOrientation.y) + (_2525 * g_Lights_1._m0[_2150].m_vOrientation.z), (_2522 * g_Lights_1._m0[_2150].m_vOrientation.z) - (_2525 * g_Lights_1._m0[_2150].m_vOrientation.y)), _706)), 0.0, 1.0);
	                                    }
	                                    else
	                                    {
	                                        _708 = _2456;
	                                    }
	                                }
	                                else
	                                {
	                                    _708 = _707;
	                                }
	                                if (g_Lights_1._m0[_2150].m_nCookie == (-1))
	                                {
	                                    do
	                                    {
	                                        vec2 _2549 = abs(_2301.xyz.xy);
	                                        if (g_Lights_1._m0[_2150].m_vCookieParameters.z == 0.0)
	                                        {
	                                            _703 = smoothstep(1.0, g_Lights_1._m0[_2150].m_vCookieParameters.x, _2549.x) * smoothstep(1.0, g_Lights_1._m0[_2150].m_vCookieParameters.y, _2549.y);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _2554 = _2549.x;
	                                            float _2558 = _2549.y;
	                                            float _2565 = (-0.5) * g_Lights_1._m0[_2150].m_vCookieParameters.z;
	                                            float _2567 = (g_Lights_1._m0[_2150].m_vCookieParameters.x * g_Lights_1._m0[_2150].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_2150].m_vCookieParameters.y * _2554, 2.0 / g_Lights_1._m0[_2150].m_vCookieParameters.z) + pow(g_Lights_1._m0[_2150].m_vCookieParameters.x * _2558, 2.0 / g_Lights_1._m0[_2150].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2565);
	                                            float _2574 = pow(max(pow(_2554, 2.0 / g_Lights_1._m0[_2150].m_vCookieParameters.z) + pow(_2558, 2.0 / g_Lights_1._m0[_2150].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2565);
	                                            if (_2567 < _2574)
	                                            {
	                                                _703 = smoothstep(_2574, _2567, 1.0);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                if (_2574 > 1.0)
	                                                {
	                                                    _704 = 1.0;
	                                                }
	                                                else
	                                                {
	                                                    _704 = 0.0;
	                                                }
	                                                _703 = _704;
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _708 *= _703;
	                                }
	                                _714 = _711 * _708;
	                                break;
	                            } while(false);
	                            if (any(greaterThan(_714, vec3(0.0))))
	                            {
	                                _701 = false;
	                                do
	                                {
	                                    switch (g_Lights_1._m0[_2150].m_nLuminaireType)
	                                    {
	                                        case 0:
	                                        {
	                                            _719 = 1.0;
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2150].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _676 = vec4(normalize(g_Lights_1._m0[_2150].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3062 = g_Lights_1._m0[_2150].m_vLightPosition.xyz - _2101;
	                                                    float _3063 = length(_3062);
	                                                    _676 = vec4(_3062 / vec3(_3063), _3063);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _701 = true;
	                                            _702 = _676;
	                                            break;
	                                        }
	                                        case 1:
	                                        {
	                                            vec3 _2912 = g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].xyz;
	                                            vec3 _2914 = g_Lights_1._m0[_2150].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].xyz;
	                                            float _2915 = length(_2912);
	                                            float _2916 = length(_2914);
	                                            vec3 _2918 = _2912 / vec3(_2915);
	                                            vec3 _2920 = _2914 / vec3(_2916);
	                                            vec3 _2921 = cross(_2918, _2920);
	                                            vec3 _2922 = g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].xyz - _2101;
	                                            float _2923 = dot(_2922, _2921);
	                                            if (_2923 > 0.0)
	                                            {
	                                                _678 = _2923 * (-1.0);
	                                                _679 = _2921 * (-1.0);
	                                            }
	                                            else
	                                            {
	                                                _678 = _2923;
	                                                _679 = _2921;
	                                            }
	                                            float _2932 = dot(_2922, _2918);
	                                            float _2933 = dot(_2922, _2920);
	                                            float _2934 = _2932 + _2915;
	                                            float _2935 = _2933 + _2916;
	                                            vec3 _2938 = vec3(_2932, _2933, _678);
	                                            vec3 _2939 = vec3(_2932, _2935, _678);
	                                            vec3 _2940 = vec3(_2934, _2933, _678);
	                                            vec3 _2941 = vec3(_2934, _2935, _678);
	                                            vec3 _2943 = normalize(cross(_2938, _2940));
	                                            vec3 _2945 = normalize(cross(_2940, _2941));
	                                            vec3 _2947 = normalize(cross(_2941, _2939));
	                                            vec3 _2949 = normalize(cross(_2939, _2938));
	                                            float _2966 = _2943.z;
	                                            float _2970 = (6.283185482025146484375 - acos(clamp(-dot(_2947, _2949), -1.0, 1.0))) - acos(clamp(-dot(_2949, _2943), -1.0, 1.0));
	                                            float _2972 = (acos(clamp(-dot(_2943, _2945), -1.0, 1.0)) + acos(clamp(-dot(_2945, _2947), -1.0, 1.0))) - _2970;
	                                            if (isnan(_2972))
	                                            {
	                                                _680 = 0.0;
	                                            }
	                                            else
	                                            {
	                                                _680 = _2972;
	                                            }
	                                            float _2980 = (_2088.x * _680) + _2970;
	                                            float _2985 = ((cos(_2980) * _2966) - _2947.z) / sin(_2980);
	                                            if (_2985 > 0.0)
	                                            {
	                                                _681 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _681 = -1.0;
	                                            }
	                                            float _2994 = _681;
	                                            float _2996 = clamp((1.0 / sqrt((_2985 * _2985) + (_2966 * _2966))) * _2994, -1.0, 1.0);
	                                            float _3004 = clamp((-(_2996 * _678)) / sqrt(1.0 - (_2996 * _2996)), _2932, _2934);
	                                            float _3007 = sqrt((_3004 * _3004) + (_678 * _678));
	                                            float _3008 = _3007 * _3007;
	                                            float _3011 = _2933 / sqrt(_3008 + (_2933 * _2933));
	                                            float _3018 = _3011 + (_2088.y * ((_2935 / sqrt(_3008 + (_2935 * _2935))) - _3011));
	                                            float _3019 = _3018 * _3018;
	                                            if (_3019 < 0.99999988079071044921875)
	                                            {
	                                                _681 = (_3018 * _3007) / sqrt(1.0 - _3019);
	                                            }
	                                            else
	                                            {
	                                                _681 = _2935;
	                                            }
	                                            vec3 _3036 = ((_2101 + (_2918 * _3004)) + (_2920 * _681)) + (_679 * _678);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2150].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _677 = vec4(normalize(_3036), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3044 = _3036 - _2101;
	                                                    float _3045 = length(_3044);
	                                                    _677 = vec4(_3044 / vec3(_3045), _3045);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _719 = 1.0 / _680;
	                                            _701 = true;
	                                            _702 = _677;
	                                            break;
	                                        }
	                                        case 2:
	                                        {
	                                            do
	                                            {
	                                                vec2 _2840 = (_2088 * 2.0) - vec2(1.0);
	                                                if (all(equal(_2840, vec2(0.0))))
	                                                {
	                                                    _685 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _2845 = _2840.x;
	                                                float _2847 = _2840.y;
	                                                if (abs(_2845) > abs(_2847))
	                                                {
	                                                    _686 = _2845;
	                                                    _687 = 0.785398185253143310546875 * (_2847 / _2845);
	                                                }
	                                                else
	                                                {
	                                                    _686 = _2847;
	                                                    _687 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2845 / _2847));
	                                                }
	                                                _685 = vec2(cos(_687), sin(_687)) * _686;
	                                                break;
	                                            } while(false);
	                                            vec3 _2873 = (g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].xyz * _685.x)) + (g_Lights_1._m0[_2150].m_vLuminaireVectors.data[2].xyz * _685.y);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2150].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _684 = vec4(normalize(_2873), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2881 = _2873 - _2101;
	                                                    float _2882 = length(_2881);
	                                                    _684 = vec4(_2881 / vec3(_2882), _2882);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_684.w))
	                                            {
	                                                _682 = true;
	                                            }
	                                            else
	                                            {
	                                                _682 = isnan(_684.w);
	                                            }
	                                            if (!_682)
	                                            {
	                                                _683 = _684.w * _684.w;
	                                            }
	                                            else
	                                            {
	                                                _683 = 1.0;
	                                            }
	                                            _719 = _683 / (max(0.0, dot(g_Lights_1._m0[_2150].m_vLuminaireVectors.data[3].xyz, -_684.xyz)) * g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].w);
	                                            _701 = true;
	                                            _702 = _684;
	                                            break;
	                                        }
	                                        case 3:
	                                        {
	                                            vec3 _2739 = g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].xyz - _2101;
	                                            float _2740 = dot(_2739, _2739);
	                                            float _2741 = sqrt(_2740);
	                                            vec3 _2743 = _2739 / vec3(_2741);
	                                            float _2744 = _2743.z;
	                                            if (_2744 >= 0.0)
	                                            {
	                                                _689 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _689 = -1.0;
	                                            }
	                                            float _2751 = (-1.0) / (_689 + _2744);
	                                            float _2752 = _2743.x;
	                                            float _2753 = _2743.y;
	                                            float _2755 = (_2752 * _2753) * _2751;
	                                            vec3 _2760 = _690;
	                                            _2760.x = 1.0 + (((_689 * _2752) * _2752) * _2751);
	                                            _2760.y = _689 * _2755;
	                                            _2760.z = (-_689) * _2752;
	                                            _690 = _2760;
	                                            vec3 _2767 = _691;
	                                            _2767.x = _2755;
	                                            _2767.y = _689 + ((_2753 * _2753) * _2751);
	                                            _2767.z = -_2753;
	                                            _691 = _2767;
	                                            float _2775 = g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].x;
	                                            float _2779 = sqrt(max(0.0, 1.0 - (_2775 / _2740)));
	                                            float _2780 = _2088.x;
	                                            float _2783 = (1.0 - _2780) + (_2780 * _2779);
	                                            float _2787 = sqrt(max(0.0, 1.0 - (_2783 * _2783)));
	                                            float _2789 = _2088.y * 6.283185482025146484375;
	                                            float _2791 = _2741 * _2741;
	                                            float _2797 = (_2741 * _2783) - sqrt(max(0.0, _2775 - ((_2791 * _2787) * _2787)));
	                                            float _2803 = ((_2791 + _2775) - (_2797 * _2797)) / ((2.0 * _2741) * g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].x);
	                                            float _2807 = sqrt(max(0.0, 1.0 - (_2803 * _2803)));
	                                            vec3 _2819 = g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].xyz + ((mat3(-_2760, -_2767, -_2743) * vec3(cos(_2789) * _2807, sin(_2789) * _2807, _2803)) * g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].x);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2150].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _688 = vec4(normalize(_2819), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2827 = _2819 - _2101;
	                                                    float _2828 = length(_2827);
	                                                    _688 = vec4(_2827 / vec3(_2828), _2828);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _719 = 0.15915493667125701904296875 / (1.0 - _2779);
	                                            _701 = true;
	                                            _702 = _688;
	                                            break;
	                                        }
	                                        case 4:
	                                        case 5:
	                                        {
	                                            vec2 _698 = _2088;
	                                            if (_2088.x < g_Lights_1._m0[_2150].m_vLuminaireVectors.data[4].y)
	                                            {
	                                                vec2 _2640 = _698;
	                                                _2640.x = clamp(_2640.x / g_Lights_1._m0[_2150].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                                _698 = _2640;
	                                                vec3 _2646 = normalize(g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].xyz);
	                                                if (_2640.x >= 0.5)
	                                                {
	                                                    vec2 _2657 = _698;
	                                                    _2657.x = clamp((2.0 * _2657.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                    _698 = _2657;
	                                                    _699 = -_2646;
	                                                    _700 = g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].xyz;
	                                                }
	                                                else
	                                                {
	                                                    vec2 _2652 = _698;
	                                                    _2652.x = clamp(2.0 * _2652.x, 0.0, 0.99999988079071044921875);
	                                                    _698 = _2652;
	                                                    _699 = _2646;
	                                                    _700 = g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].xyz;
	                                                }
	                                                do
	                                                {
	                                                    vec2 _2668 = (_698 * 2.0) - vec2(1.0);
	                                                    if (all(equal(_2668, vec2(0.0))))
	                                                    {
	                                                        _695 = vec2(0.0);
	                                                        break;
	                                                    }
	                                                    float _2673 = _2668.x;
	                                                    float _2675 = _2668.y;
	                                                    if (abs(_2673) > abs(_2675))
	                                                    {
	                                                        _696 = _2673;
	                                                        _697 = 0.785398185253143310546875 * (_2675 / _2673);
	                                                    }
	                                                    else
	                                                    {
	                                                        _696 = _2675;
	                                                        _697 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2673 / _2675));
	                                                    }
	                                                    _695 = vec2(cos(_697), sin(_697)) * _696;
	                                                    break;
	                                                } while(false);
	                                                _700 += ((g_Lights_1._m0[_2150].m_vLuminaireVectors.data[2].xyz * _695.x) + (g_Lights_1._m0[_2150].m_vLuminaireVectors.data[3].xyz * _695.y));
	                                            }
	                                            else
	                                            {
	                                                vec2 _2619 = _698;
	                                                _2619.x = clamp((_2619.x - g_Lights_1._m0[_2150].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_2150].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                                _698 = _2619;
	                                                vec3 _2634 = (g_Lights_1._m0[_2150].m_vLuminaireVectors.data[2].xyz * cos(_2619.x * 6.283185482025146484375)) + (g_Lights_1._m0[_2150].m_vLuminaireVectors.data[3].xyz * sin(_2619.x * 6.283185482025146484375));
	                                                _699 = normalize(_2634);
	                                                _700 = mix(g_Lights_1._m0[_2150].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].xyz, vec3(_2619.y)) + _2634;
	                                            }
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2150].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _694 = vec4(normalize(_700), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2708 = _700 - _2101;
	                                                    float _2709 = length(_2708);
	                                                    _694 = vec4(_2708 / vec3(_2709), _2709);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_694.w))
	                                            {
	                                                _692 = true;
	                                            }
	                                            else
	                                            {
	                                                _692 = isnan(_694.w);
	                                            }
	                                            if (!_692)
	                                            {
	                                                _693 = _694.w * _694.w;
	                                            }
	                                            else
	                                            {
	                                                _693 = 1.0;
	                                            }
	                                            _719 = _693 / (max(0.0, dot(_699, -_694.xyz)) * g_Lights_1._m0[_2150].m_vLuminaireVectors.data[1].w);
	                                            _701 = true;
	                                            _702 = _694;
	                                            break;
	                                        }
	                                        default:
	                                        {
	                                            _719 = 0.0;
	                                            _701 = true;
	                                            _702 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                            break;
	                                        }
	                                    }
	                                    if (_701)
	                                    {
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                bool _3079 = !(dot(_447, _702.xyz) > 0.0);
	                                vec3 _3080 = vec3(_346);
	                                vec3 _3083 = transpose(mat3(_384, _383, _3080)) * _702.xyz;
	                                do
	                                {
	                                    if (_3079)
	                                    {
	                                        if ((_340 & 65535u) == 1u)
	                                        {
	                                            _671 = any(greaterThan(vec3(_339.xyz), vec3(0.0)));
	                                        }
	                                        else
	                                        {
	                                            _671 = false;
	                                        }
	                                        if (_671)
	                                        {
	                                            _675 = vec3(_339.xyz);
	                                        }
	                                        else
	                                        {
	                                            _675 = vec3(1.0);
	                                        }
	                                        _674 = _675 * 0.3183098733425140380859375;
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _3092 = vec3(mix(f16vec3(_341), _344, f16vec3(_345)));
	                                        float _3093 = float(_343);
	                                        do
	                                        {
	                                            float _3096 = _3083.z;
	                                            vec3 _3098 = _3083 + _380;
	                                            if (_3096 <= 0.0)
	                                            {
	                                                _673 = true;
	                                            }
	                                            else
	                                            {
	                                                _673 = _380.z <= 0.0;
	                                            }
	                                            if (_673)
	                                            {
	                                                _672 = vec3(0.0);
	                                                break;
	                                            }
	                                            if (all(equal(_3098, vec3(0.0))))
	                                            {
	                                                _672 = vec3(0.0);
	                                                break;
	                                            }
	                                            vec3 _3111 = normalize(_3098);
	                                            float _3112 = _3111.z;
	                                            float _3120 = _3093 * _3093;
	                                            float _3121 = _3120 * _3120;
	                                            float _3125 = (((_3112 * _3121) - _3112) * _3112) + 1.0;
	                                            float _3129 = _3093 * _3093;
	                                            float _3130 = _3129 * _3129;
	                                            _672 = (_3092 + ((vec3(1.0) - _3092) * pow(max(0.0, 1.0 - dot(_3083, _3111)), 5.0))) * (((_3121 / max(9.9999999392252902907785028219223e-09, _3125 * _3125)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_3096 * sqrt(((_380.z - (_3130 * _380.z)) * _380.z) + _3130)) + (_380.z * sqrt(((_3096 - (_3130 * _3096)) * _3096) + _3130))))) * 0.3183098733425140380859375);
	                                            break;
	                                        } while(false);
	                                        _674 = ((vec3(_344) * (1.0 - float(_345))) * 0.3183098733425140380859375) + _672;
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                float _3176 = dot(_3080, _702.xyz);
	                                if (_3079)
	                                {
	                                    _670 = -_3176;
	                                }
	                                else
	                                {
	                                    _670 = _3176;
	                                }
	                                _718 += (((_714 / vec3(_719)) * (_674 * 3.1415927410125732421875)) * max(0.0, _670));
	                            }
	                            _717 = _2152;
	                            break;
	                        } while(false);
	                        if (_2139_ladder_break)
	                        {
	                            break;
	                        }
	                        continue;
	                    }
	                    _715++;
	                    _716 = _718;
	                    continue;
	                }
	                if (_723)
	                {
	                    vec2 _661 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_831.xy, int(1u + (_832 + uint(_746))))))).xy;
	                    vec3 _3199 = (_449 + _448) * 0.5;
	                    float _662 = 0.0;
	                    vec3 _484 = vec3(0.0);
	                    vec3 _483 = vec3(0.0);
	                    vec4 _482 = vec4(0.0);
	                    int _485 = -1;
	                    uvec3 _3204 = min(uvec3(max(fma(_3199, _856, _858), vec3(0.0))), (_853 - uvec3(1u)));
	                    float _663 = 0.0;
	                    uint _664 = 0u;
	                    for (;;)
	                    {
	                        if (!(_664 < _852))
	                        {
	                            break;
	                        }
	                        uint _3217 = _852 * _853.x;
	                        float _666 = _663;
	                        uint _667 = subgroupOr(g_LightBins_1._m0[((((_3217 * _853.y) * _3204.z) + (_3217 * _3204.y)) + (_852 * _3204.x)) + _664]);
	                        for (;;)
	                        {
	                            bool _3237_ladder_break = false;
	                            do
	                            {
	                                if (!(_667 != 0u))
	                                {
	                                    _3237_ladder_break = true;
	                                    break;
	                                }
	                                uint _3244 = _667;
	                                uint _3248 = uint(findLSB(_3244)) + (_664 * 32u);
	                                uint _3250 = _3244 & (_3244 - 1u);
	                                mat4 _3280 = mat4(vec4(g_Lights_1._m0[_3248].m_mToClipSpace.data[0].x, g_Lights_1._m0[_3248].m_mToClipSpace.data[1].x, g_Lights_1._m0[_3248].m_mToClipSpace.data[2].x, g_Lights_1._m0[_3248].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_3248].m_mToClipSpace.data[0].y, g_Lights_1._m0[_3248].m_mToClipSpace.data[1].y, g_Lights_1._m0[_3248].m_mToClipSpace.data[2].y, g_Lights_1._m0[_3248].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_3248].m_mToClipSpace.data[0].z, g_Lights_1._m0[_3248].m_mToClipSpace.data[1].z, g_Lights_1._m0[_3248].m_mToClipSpace.data[2].z, g_Lights_1._m0[_3248].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_3248].m_mToClipSpace.data[0].w, g_Lights_1._m0[_3248].m_mToClipSpace.data[1].w, g_Lights_1._m0[_3248].m_mToClipSpace.data[2].w, g_Lights_1._m0[_3248].m_mToClipSpace.data[3].w));
	                                if ((uint(g_Lights_1._m0[_3248].m_nPathTraceFlags) & 1u) == 0u)
	                                {
	                                    _667 = _3250;
	                                    break;
	                                }
	                                if (!((g_Lights_1._m0[_3248].m_nPathTraceFlags & 8) != 0))
	                                {
	                                    _667 = _3250;
	                                    break;
	                                }
	                                do
	                                {
	                                    do
	                                    {
	                                        vec4 _3356 = _3280 * vec4(_3199.xyz, 1.0);
	                                        vec3 _3360 = _3356.xyz / vec3(_3356.w);
	                                        vec4 _3362;
	                                        _3362.x = _3360.x;
	                                        _3362.y = _3360.y;
	                                        _3362.z = _3360.z;
	                                        if (all(greaterThanEqual(_3362.xyz, vec3(-1.0, -1.0, 0.0))))
	                                        {
	                                            _658 = all(lessThanEqual(_3362.xyz, vec3(1.0)));
	                                        }
	                                        else
	                                        {
	                                            _658 = false;
	                                        }
	                                        if (!_658)
	                                        {
	                                            _659 = false;
	                                            break;
	                                        }
	                                        if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_3248].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_3199, 1.0)).xyz), vec3(1.0))))
	                                        {
	                                            _659 = false;
	                                            break;
	                                        }
	                                        _659 = true;
	                                        break;
	                                    } while(false);
	                                    if (!_659)
	                                    {
	                                        _660 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec4 _3394 = _3280 * vec4(_3199.xyz, 1.0);
	                                    vec3 _3398 = _3394.xyz / vec3(_3394.w);
	                                    vec4 _3400;
	                                    _3400.x = _3398.x;
	                                    _3400.y = _3398.y;
	                                    _3400.z = _3398.z;
	                                    if (_2054)
	                                    {
	                                        _657 = g_Lights_1._m0[_3248].m_vBounceColor.xyz;
	                                    }
	                                    else
	                                    {
	                                        _657 = g_Lights_1._m0[_3248].m_vColor.xyz;
	                                    }
	                                    if (true)
	                                    {
	                                        if (g_Lights_1._m0[_3248].m_nCookie >= 0)
	                                        {
	                                            if (g_Lights_1._m0[_3248].m_bSphericalCookie != 0)
	                                            {
	                                                vec4 _3443 = vec4(-g_Lights_1._m0[_3248].m_vOrientation.xyz, g_Lights_1._m0[_3248].m_vOrientation.w);
	                                                vec4 _3445 = _3443.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                                vec3 _3448 = _3445.xyz;
	                                                vec3 _3449 = vec4((-normalize(g_Lights_1._m0[_3248].m_vLightPosition.xyz - _3199)).xyz, 0.0).xyz;
	                                                vec4 _3456 = vec4((_3449 * _3445.w) + cross(_3449, _3448), -dot(_3449, _3448));
	                                                vec3 _3457 = _3456.xyz;
	                                                float _3458 = _3443.w;
	                                                vec3 _3460 = _3443.xyz;
	                                                float _3461 = _3456.w;
	                                                vec3 _3469 = vec4(((_3457 * _3458) + (_3460 * _3461)) + cross(_3460, _3457), _323).xyz;
	                                                vec2 _3478 = vec2(atan(_3469.y, -_3469.x) * 0.15915493667125701904296875, acos(_3469.z) * 0.3183098733425140380859375);
	                                                vec2 _3483 = (_3478.xy * g_Lights_1._m0[_3248].m_vCookieParameters.zw) + g_Lights_1._m0[_3248].m_vCookieParameters.xy;
	                                                vec2 _3485 = _3478;
	                                                _3485.x = _3483.x;
	                                                _3485.y = _3483.y;
	                                                _656 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_3248].m_nCookie], g_Sampler), _3485, 0.0).xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _3422 = fma(_3400.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                                vec2 _3427 = (_3422.xy * g_Lights_1._m0[_3248].m_vCookieParameters.zw) + g_Lights_1._m0[_3248].m_vCookieParameters.xy;
	                                                vec2 _3429 = _3422;
	                                                _3429.x = _3427.x;
	                                                _3429.y = _3427.y;
	                                                _656 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_3248].m_nCookie], g_CookieSampler), _3429, 0.0).xyz;
	                                            }
	                                        }
	                                        else
	                                        {
	                                            _656 = vec3(1.0);
	                                        }
	                                        _657 *= _656;
	                                    }
	                                    if (g_Lights_1._m0[_3248].m_nLuminaireType != 0)
	                                    {
	                                        _657 = (_657 * g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                    }
	                                    else
	                                    {
	                                        if (!(g_Lights_1._m0[_3248].m_vLightPosition.w == 0.0))
	                                        {
	                                            vec3 _3505 = g_Lights_1._m0[_3248].m_vLightPosition.xyz - _3199;
	                                            _657 *= (vec3(g_Lights_1._m0[_3248].m_vLightPosition.w) / max(vec3(dot(_3505, _3505)), vec3(g_Lights_1._m0[_3248].m_vLightPosition.w)));
	                                        }
	                                    }
	                                    if (g_Lights_1._m0[_3248].m_vDistanceFade_vSkirt.z > 0.0)
	                                    {
	                                        _653 = smoothstep(0.0, 1.0, _3400.xyz.z * g_Lights_1._m0[_3248].m_vDistanceFade_vSkirt.z);
	                                    }
	                                    else
	                                    {
	                                        _653 = 1.0;
	                                    }
	                                    if (g_Lights_1._m0[_3248].m_vDistanceFade_vSkirt.w > 0.0)
	                                    {
	                                        _653 *= smoothstep(0.0, 1.0, (1.0 - _3400.xyz.z) * g_Lights_1._m0[_3248].m_vDistanceFade_vSkirt.w);
	                                    }
	                                    if (!(g_Lights_1._m0[_3248].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _3546 = g_Lights_1._m0[_3248].m_vLightPosition.xyz - _3199;
	                                        float _3547 = length(_3546);
	                                        vec3 _3549 = _3546 / vec3(_3547);
	                                        float _3555 = _653 * smoothstep(0.0, 1.0, g_Lights_1._m0[_3248].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_3248].m_vDistanceFade_vSkirt.y * _3547));
	                                        if (g_Lights_1._m0[_3248].m_nLuminaireType != 2)
	                                        {
	                                            _655 = g_Lights_1._m0[_3248].m_nLuminaireType != 1;
	                                        }
	                                        else
	                                        {
	                                            _655 = false;
	                                        }
	                                        if (_655)
	                                        {
	                                            float _3567 = 2.0 * g_Lights_1._m0[_3248].m_vOrientation.x;
	                                            float _3571 = 2.0 * g_Lights_1._m0[_3248].m_vOrientation.w;
	                                            vec3 _3585 = vec3((_3567 * g_Lights_1._m0[_3248].m_vOrientation.y) - (_3571 * g_Lights_1._m0[_3248].m_vOrientation.z), (1.0 - (_3567 * g_Lights_1._m0[_3248].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_3248].m_vOrientation.z) * g_Lights_1._m0[_3248].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_3248].m_vOrientation.y) * g_Lights_1._m0[_3248].m_vOrientation.z) + (_3571 * g_Lights_1._m0[_3248].m_vOrientation.x)) * g_Lights_1._m0[_3248].m_vAngleFade.z;
	                                            vec3 _3586 = _3549 - _3585;
	                                            vec3 _3587 = _3549 + _3585;
	                                            do
	                                            {
	                                                vec3 _3590 = _3587 - _3586;
	                                                float _3592 = dot(-_3586, _3590);
	                                                if (_3592 <= 0.0)
	                                                {
	                                                    _651 = _3586;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    float _3597 = dot(_3590, _3590);
	                                                    if (_3592 > _3597)
	                                                    {
	                                                        _651 = _3587;
	                                                        break;
	                                                    }
	                                                    else
	                                                    {
	                                                        _651 = _3586 + (_3590 * (_3592 / _3597));
	                                                        break;
	                                                    }
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (any(notEqual(_651, vec3(0.0))))
	                                            {
	                                                _652 = normalize(_651);
	                                            }
	                                            else
	                                            {
	                                                _652 = _651;
	                                            }
	                                            float _3621 = 2.0 * g_Lights_1._m0[_3248].m_vOrientation.x;
	                                            float _3624 = 2.0 * g_Lights_1._m0[_3248].m_vOrientation.w;
	                                            _654 = _3555 * clamp(g_Lights_1._m0[_3248].m_vAngleFade.x + (g_Lights_1._m0[_3248].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_3248].m_vOrientation.y) * g_Lights_1._m0[_3248].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_3248].m_vOrientation.z) * g_Lights_1._m0[_3248].m_vOrientation.z), (_3621 * g_Lights_1._m0[_3248].m_vOrientation.y) + (_3624 * g_Lights_1._m0[_3248].m_vOrientation.z), (_3621 * g_Lights_1._m0[_3248].m_vOrientation.z) - (_3624 * g_Lights_1._m0[_3248].m_vOrientation.y)), _652)), 0.0, 1.0);
	                                        }
	                                        else
	                                        {
	                                            _654 = _3555;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _654 = _653;
	                                    }
	                                    if (g_Lights_1._m0[_3248].m_nCookie == (-1))
	                                    {
	                                        do
	                                        {
	                                            vec2 _3648 = abs(_3400.xyz.xy);
	                                            if (g_Lights_1._m0[_3248].m_vCookieParameters.z == 0.0)
	                                            {
	                                                _649 = smoothstep(1.0, g_Lights_1._m0[_3248].m_vCookieParameters.x, _3648.x) * smoothstep(1.0, g_Lights_1._m0[_3248].m_vCookieParameters.y, _3648.y);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _3653 = _3648.x;
	                                                float _3657 = _3648.y;
	                                                float _3664 = (-0.5) * g_Lights_1._m0[_3248].m_vCookieParameters.z;
	                                                float _3666 = (g_Lights_1._m0[_3248].m_vCookieParameters.x * g_Lights_1._m0[_3248].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_3248].m_vCookieParameters.y * _3653, 2.0 / g_Lights_1._m0[_3248].m_vCookieParameters.z) + pow(g_Lights_1._m0[_3248].m_vCookieParameters.x * _3657, 2.0 / g_Lights_1._m0[_3248].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3664);
	                                                float _3673 = pow(max(pow(_3653, 2.0 / g_Lights_1._m0[_3248].m_vCookieParameters.z) + pow(_3657, 2.0 / g_Lights_1._m0[_3248].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3664);
	                                                if (_3666 < _3673)
	                                                {
	                                                    _649 = smoothstep(_3673, _3666, 1.0);
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    if (_3673 > 1.0)
	                                                    {
	                                                        _650 = 1.0;
	                                                    }
	                                                    else
	                                                    {
	                                                        _650 = 0.0;
	                                                    }
	                                                    _649 = _650;
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _654 *= _649;
	                                    }
	                                    _660 = _657 * _654;
	                                    break;
	                                } while(false);
	                                float _3696 = dot(_660.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                if (_3696 == 0.0)
	                                {
	                                    _667 = _3250;
	                                    break;
	                                }
	                                _647 = false;
	                                do
	                                {
	                                    switch (g_Lights_1._m0[_3248].m_nLuminaireType)
	                                    {
	                                        case 0:
	                                        {
	                                            _668 = 1.0;
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3248].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _622 = vec4(normalize(g_Lights_1._m0[_3248].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _4162 = g_Lights_1._m0[_3248].m_vLightPosition.xyz - _3199;
	                                                    float _4163 = length(_4162);
	                                                    _622 = vec4(_4162 / vec3(_4163), _4163);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _647 = true;
	                                            _648 = _622;
	                                            break;
	                                        }
	                                        case 1:
	                                        {
	                                            vec3 _4012 = g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].xyz;
	                                            vec3 _4014 = g_Lights_1._m0[_3248].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].xyz;
	                                            float _4015 = length(_4012);
	                                            float _4016 = length(_4014);
	                                            vec3 _4018 = _4012 / vec3(_4015);
	                                            vec3 _4020 = _4014 / vec3(_4016);
	                                            vec3 _4021 = cross(_4018, _4020);
	                                            vec3 _4022 = g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].xyz - _3199;
	                                            float _4023 = dot(_4022, _4021);
	                                            if (_4023 > 0.0)
	                                            {
	                                                _624 = _4023 * (-1.0);
	                                                _625 = _4021 * (-1.0);
	                                            }
	                                            else
	                                            {
	                                                _624 = _4023;
	                                                _625 = _4021;
	                                            }
	                                            float _4032 = dot(_4022, _4018);
	                                            float _4033 = dot(_4022, _4020);
	                                            float _4034 = _4032 + _4015;
	                                            float _4035 = _4033 + _4016;
	                                            vec3 _4038 = vec3(_4032, _4033, _624);
	                                            vec3 _4039 = vec3(_4032, _4035, _624);
	                                            vec3 _4040 = vec3(_4034, _4033, _624);
	                                            vec3 _4041 = vec3(_4034, _4035, _624);
	                                            vec3 _4043 = normalize(cross(_4038, _4040));
	                                            vec3 _4045 = normalize(cross(_4040, _4041));
	                                            vec3 _4047 = normalize(cross(_4041, _4039));
	                                            vec3 _4049 = normalize(cross(_4039, _4038));
	                                            float _4066 = _4043.z;
	                                            float _4070 = (6.283185482025146484375 - acos(clamp(-dot(_4047, _4049), -1.0, 1.0))) - acos(clamp(-dot(_4049, _4043), -1.0, 1.0));
	                                            float _4072 = (acos(clamp(-dot(_4043, _4045), -1.0, 1.0)) + acos(clamp(-dot(_4045, _4047), -1.0, 1.0))) - _4070;
	                                            if (isnan(_4072))
	                                            {
	                                                _626 = 0.0;
	                                            }
	                                            else
	                                            {
	                                                _626 = _4072;
	                                            }
	                                            float _4080 = (_2088.x * _626) + _4070;
	                                            float _4085 = ((cos(_4080) * _4066) - _4047.z) / sin(_4080);
	                                            if (_4085 > 0.0)
	                                            {
	                                                _627 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _627 = -1.0;
	                                            }
	                                            float _4094 = _627;
	                                            float _4096 = clamp((1.0 / sqrt((_4085 * _4085) + (_4066 * _4066))) * _4094, -1.0, 1.0);
	                                            float _4104 = clamp((-(_4096 * _624)) / sqrt(1.0 - (_4096 * _4096)), _4032, _4034);
	                                            float _4107 = sqrt((_4104 * _4104) + (_624 * _624));
	                                            float _4108 = _4107 * _4107;
	                                            float _4111 = _4033 / sqrt(_4108 + (_4033 * _4033));
	                                            float _4118 = _4111 + (_2088.y * ((_4035 / sqrt(_4108 + (_4035 * _4035))) - _4111));
	                                            float _4119 = _4118 * _4118;
	                                            if (_4119 < 0.99999988079071044921875)
	                                            {
	                                                _627 = (_4118 * _4107) / sqrt(1.0 - _4119);
	                                            }
	                                            else
	                                            {
	                                                _627 = _4035;
	                                            }
	                                            vec3 _4136 = ((_3199 + (_4018 * _4104)) + (_4020 * _627)) + (_625 * _624);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3248].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _623 = vec4(normalize(_4136), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _4144 = _4136 - _3199;
	                                                    float _4145 = length(_4144);
	                                                    _623 = vec4(_4144 / vec3(_4145), _4145);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _668 = 1.0 / _626;
	                                            _647 = true;
	                                            _648 = _623;
	                                            break;
	                                        }
	                                        case 2:
	                                        {
	                                            do
	                                            {
	                                                vec2 _3940 = (_2088 * 2.0) - vec2(1.0);
	                                                if (all(equal(_3940, vec2(0.0))))
	                                                {
	                                                    _631 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _3945 = _3940.x;
	                                                float _3947 = _3940.y;
	                                                if (abs(_3945) > abs(_3947))
	                                                {
	                                                    _632 = _3945;
	                                                    _633 = 0.785398185253143310546875 * (_3947 / _3945);
	                                                }
	                                                else
	                                                {
	                                                    _632 = _3947;
	                                                    _633 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3945 / _3947));
	                                                }
	                                                _631 = vec2(cos(_633), sin(_633)) * _632;
	                                                break;
	                                            } while(false);
	                                            vec3 _3973 = (g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].xyz * _631.x)) + (g_Lights_1._m0[_3248].m_vLuminaireVectors.data[2].xyz * _631.y);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3248].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _630 = vec4(normalize(_3973), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3981 = _3973 - _3199;
	                                                    float _3982 = length(_3981);
	                                                    _630 = vec4(_3981 / vec3(_3982), _3982);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_630.w))
	                                            {
	                                                _628 = true;
	                                            }
	                                            else
	                                            {
	                                                _628 = isnan(_630.w);
	                                            }
	                                            if (!_628)
	                                            {
	                                                _629 = _630.w * _630.w;
	                                            }
	                                            else
	                                            {
	                                                _629 = 1.0;
	                                            }
	                                            _668 = _629 / (max(0.0, dot(g_Lights_1._m0[_3248].m_vLuminaireVectors.data[3].xyz, -_630.xyz)) * g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].w);
	                                            _647 = true;
	                                            _648 = _630;
	                                            break;
	                                        }
	                                        case 3:
	                                        {
	                                            vec3 _3839 = g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].xyz - _3199;
	                                            float _3840 = dot(_3839, _3839);
	                                            float _3841 = sqrt(_3840);
	                                            vec3 _3843 = _3839 / vec3(_3841);
	                                            float _3844 = _3843.z;
	                                            if (_3844 >= 0.0)
	                                            {
	                                                _635 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _635 = -1.0;
	                                            }
	                                            float _3851 = (-1.0) / (_635 + _3844);
	                                            float _3852 = _3843.x;
	                                            float _3853 = _3843.y;
	                                            float _3855 = (_3852 * _3853) * _3851;
	                                            vec3 _3860 = _636;
	                                            _3860.x = 1.0 + (((_635 * _3852) * _3852) * _3851);
	                                            _3860.y = _635 * _3855;
	                                            _3860.z = (-_635) * _3852;
	                                            _636 = _3860;
	                                            vec3 _3867 = _637;
	                                            _3867.x = _3855;
	                                            _3867.y = _635 + ((_3853 * _3853) * _3851);
	                                            _3867.z = -_3853;
	                                            _637 = _3867;
	                                            float _3875 = g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].x;
	                                            float _3879 = sqrt(max(0.0, 1.0 - (_3875 / _3840)));
	                                            float _3880 = _2088.x;
	                                            float _3883 = (1.0 - _3880) + (_3880 * _3879);
	                                            float _3887 = sqrt(max(0.0, 1.0 - (_3883 * _3883)));
	                                            float _3889 = _2088.y * 6.283185482025146484375;
	                                            float _3891 = _3841 * _3841;
	                                            float _3897 = (_3841 * _3883) - sqrt(max(0.0, _3875 - ((_3891 * _3887) * _3887)));
	                                            float _3903 = ((_3891 + _3875) - (_3897 * _3897)) / ((2.0 * _3841) * g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].x);
	                                            float _3907 = sqrt(max(0.0, 1.0 - (_3903 * _3903)));
	                                            vec3 _3919 = g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].xyz + ((mat3(-_3860, -_3867, -_3843) * vec3(cos(_3889) * _3907, sin(_3889) * _3907, _3903)) * g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].x);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3248].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _634 = vec4(normalize(_3919), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3927 = _3919 - _3199;
	                                                    float _3928 = length(_3927);
	                                                    _634 = vec4(_3927 / vec3(_3928), _3928);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _668 = 0.15915493667125701904296875 / (1.0 - _3879);
	                                            _647 = true;
	                                            _648 = _634;
	                                            break;
	                                        }
	                                        case 4:
	                                        case 5:
	                                        {
	                                            vec2 _644 = _2088;
	                                            if (_2088.x < g_Lights_1._m0[_3248].m_vLuminaireVectors.data[4].y)
	                                            {
	                                                vec2 _3740 = _644;
	                                                _3740.x = clamp(_3740.x / g_Lights_1._m0[_3248].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                                _644 = _3740;
	                                                vec3 _3746 = normalize(g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].xyz);
	                                                if (_3740.x >= 0.5)
	                                                {
	                                                    vec2 _3757 = _644;
	                                                    _3757.x = clamp((2.0 * _3757.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                    _644 = _3757;
	                                                    _645 = -_3746;
	                                                    _646 = g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].xyz;
	                                                }
	                                                else
	                                                {
	                                                    vec2 _3752 = _644;
	                                                    _3752.x = clamp(2.0 * _3752.x, 0.0, 0.99999988079071044921875);
	                                                    _644 = _3752;
	                                                    _645 = _3746;
	                                                    _646 = g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].xyz;
	                                                }
	                                                do
	                                                {
	                                                    vec2 _3768 = (_644 * 2.0) - vec2(1.0);
	                                                    if (all(equal(_3768, vec2(0.0))))
	                                                    {
	                                                        _641 = vec2(0.0);
	                                                        break;
	                                                    }
	                                                    float _3773 = _3768.x;
	                                                    float _3775 = _3768.y;
	                                                    if (abs(_3773) > abs(_3775))
	                                                    {
	                                                        _642 = _3773;
	                                                        _643 = 0.785398185253143310546875 * (_3775 / _3773);
	                                                    }
	                                                    else
	                                                    {
	                                                        _642 = _3775;
	                                                        _643 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3773 / _3775));
	                                                    }
	                                                    _641 = vec2(cos(_643), sin(_643)) * _642;
	                                                    break;
	                                                } while(false);
	                                                _646 += ((g_Lights_1._m0[_3248].m_vLuminaireVectors.data[2].xyz * _641.x) + (g_Lights_1._m0[_3248].m_vLuminaireVectors.data[3].xyz * _641.y));
	                                            }
	                                            else
	                                            {
	                                                vec2 _3719 = _644;
	                                                _3719.x = clamp((_3719.x - g_Lights_1._m0[_3248].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_3248].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                                _644 = _3719;
	                                                vec3 _3734 = (g_Lights_1._m0[_3248].m_vLuminaireVectors.data[2].xyz * cos(_3719.x * 6.283185482025146484375)) + (g_Lights_1._m0[_3248].m_vLuminaireVectors.data[3].xyz * sin(_3719.x * 6.283185482025146484375));
	                                                _645 = normalize(_3734);
	                                                _646 = mix(g_Lights_1._m0[_3248].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].xyz, vec3(_3719.y)) + _3734;
	                                            }
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_3248].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _640 = vec4(normalize(_646), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3808 = _646 - _3199;
	                                                    float _3809 = length(_3808);
	                                                    _640 = vec4(_3808 / vec3(_3809), _3809);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_640.w))
	                                            {
	                                                _638 = true;
	                                            }
	                                            else
	                                            {
	                                                _638 = isnan(_640.w);
	                                            }
	                                            if (!_638)
	                                            {
	                                                _639 = _640.w * _640.w;
	                                            }
	                                            else
	                                            {
	                                                _639 = 1.0;
	                                            }
	                                            _668 = _639 / (max(0.0, dot(_645, -_640.xyz)) * g_Lights_1._m0[_3248].m_vLuminaireVectors.data[1].w);
	                                            _647 = true;
	                                            _648 = _640;
	                                            break;
	                                        }
	                                        default:
	                                        {
	                                            _668 = 0.0;
	                                            _647 = true;
	                                            _648 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                            break;
	                                        }
	                                    }
	                                    if (_647)
	                                    {
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                float _4181 = dot(vec3(_346), _648.xyz);
	                                if ((!(dot(_447, _648.xyz) > 0.0)) && _722)
	                                {
	                                    _621 = -_4181;
	                                }
	                                else
	                                {
	                                    _621 = _4181;
	                                }
	                                float _4188 = (_3696 / _668) * max(0.0, _621);
	                                float _669 = _661.x;
	                                do
	                                {
	                                    float _4193 = _662;
	                                    float _4194 = _4193 + _4188;
	                                    _662 = _4194;
	                                    if (_4194 == 0.0)
	                                    {
	                                        _620 = false;
	                                        break;
	                                    }
	                                    float _4199 = _4188 / _662;
	                                    do
	                                    {
	                                        if (_4199 <= 0.0)
	                                        {
	                                            _619 = false;
	                                            break;
	                                        }
	                                        if (_4199 >= 1.0)
	                                        {
	                                            _619 = true;
	                                            break;
	                                        }
	                                        if (_669 < _4199)
	                                        {
	                                            _669 = min(_669 / _4199, 0.99999988079071044921875);
	                                            _619 = true;
	                                            break;
	                                        }
	                                        _669 = min((_669 - _4199) / (1.0 - _4199), 0.99999988079071044921875);
	                                        _619 = false;
	                                        break;
	                                    } while(false);
	                                    _620 = _619;
	                                    break;
	                                } while(false);
	                                vec2 _4223 = _661;
	                                _4223.x = _669;
	                                _661 = _4223;
	                                if (_620)
	                                {
	                                    _485 = int(_3248);
	                                    _484 = _660 / vec3(_668);
	                                    _482 = _648;
	                                    _666 = _4188;
	                                }
	                                _667 = _3250;
	                                break;
	                            } while(false);
	                            if (_3237_ladder_break)
	                            {
	                                break;
	                            }
	                            continue;
	                        }
	                        _663 = _666;
	                        _664++;
	                        continue;
	                    }
	                    if (_485 != (-1))
	                    {
	                        vec3 _4244 = _484;
	                        vec3 _4245 = _4244 * (_662 / _663);
	                        _484 = _4245;
	                        bool _4252 = !(dot(_447, _482.xyz) > 0.0);
	                        vec3 _4254 = vec3(_346);
	                        vec3 _4257 = transpose(mat3(_384, _383, _4254)) * _482.xyz;
	                        do
	                        {
	                            if (_4252)
	                            {
	                                if ((_340 & 65535u) == 1u)
	                                {
	                                    _614 = any(greaterThan(vec3(_339.xyz), vec3(0.0)));
	                                }
	                                else
	                                {
	                                    _614 = false;
	                                }
	                                if (_614)
	                                {
	                                    _618 = vec3(_339.xyz);
	                                }
	                                else
	                                {
	                                    _618 = vec3(1.0);
	                                }
	                                _617 = _618 * 0.3183098733425140380859375;
	                                break;
	                            }
	                            else
	                            {
	                                vec3 _4266 = vec3(mix(f16vec3(_341), _344, f16vec3(_345)));
	                                float _4267 = float(_343);
	                                do
	                                {
	                                    float _4270 = _4257.z;
	                                    vec3 _4272 = _4257 + _380;
	                                    if (_4270 <= 0.0)
	                                    {
	                                        _616 = true;
	                                    }
	                                    else
	                                    {
	                                        _616 = _380.z <= 0.0;
	                                    }
	                                    if (_616)
	                                    {
	                                        _615 = vec3(0.0);
	                                        break;
	                                    }
	                                    if (all(equal(_4272, vec3(0.0))))
	                                    {
	                                        _615 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec3 _4285 = normalize(_4272);
	                                    float _4286 = _4285.z;
	                                    float _4294 = _4267 * _4267;
	                                    float _4295 = _4294 * _4294;
	                                    float _4299 = (((_4286 * _4295) - _4286) * _4286) + 1.0;
	                                    float _4303 = _4267 * _4267;
	                                    float _4304 = _4303 * _4303;
	                                    _615 = (_4266 + ((vec3(1.0) - _4266) * pow(max(0.0, 1.0 - dot(_4257, _4285)), 5.0))) * (((_4295 / max(9.9999999392252902907785028219223e-09, _4299 * _4299)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_4270 * sqrt(((_380.z - (_4304 * _380.z)) * _380.z) + _4304)) + (_380.z * sqrt(((_4270 - (_4304 * _4270)) * _4270) + _4304))))) * 0.3183098733425140380859375);
	                                    break;
	                                } while(false);
	                                _617 = ((vec3(_344) * (1.0 - float(_345))) * 0.3183098733425140380859375) + _615;
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        vec3 _4349 = _4245 * (_617 * 3.1415927410125732421875);
	                        _484 = _4349;
	                        float _4352 = dot(_4254, _482.xyz);
	                        if (_4252)
	                        {
	                            _613 = -_4352;
	                        }
	                        else
	                        {
	                            _613 = _4352;
	                        }
	                        _484 = _4349 * max(0.0, _613);
	                        if (_4252)
	                        {
	                            if ((_340 & 65535u) == 2u)
	                            {
	                                _612 = float(_339.x) > 0.0;
	                            }
	                            else
	                            {
	                                _612 = false;
	                            }
	                            _665 = _612;
	                        }
	                        else
	                        {
	                            _665 = false;
	                        }
	                        if (_665)
	                        {
	                            float _4385 = pow(clamp(-dot(normalize(_447 + _4254), _482.xyz), 0.0, 1.0), 2.0);
	                            f16vec3 _4386 = f16vec3(vec3(0.0));
	                            if (isinf(_482.w))
	                            {
	                                _608 = true;
	                            }
	                            else
	                            {
	                                _608 = isnan(_482.w);
	                            }
	                            if (!_608)
	                            {
	                                _609 = _482.w;
	                            }
	                            else
	                            {
	                                _609 = 1000.0;
	                            }
	                            vec3 _488 = _449 + (_482.xyz * _609);
	                            float _487 = 0.0;
	                            vec3 _486 = -_482.xyz;
	                            if (_4385 > 0.0)
	                            {
	                                _610 = _609;
	                            }
	                            else
	                            {
	                                _610 = 0.0;
	                            }
	                            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _489, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_4386, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4386, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                            traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _488, _487, _486, _610, 0);
	                            if (p._m5 != (-1))
	                            {
	                                if ((p._m7._m6 & 65535u) == 2u)
	                                {
	                                    _607 = float(p._m7._m7.x) > 0.0;
	                                }
	                                else
	                                {
	                                    _607 = false;
	                                }
	                                if (!_607)
	                                {
	                                    _610 = 0.0;
	                                }
	                                else
	                                {
	                                    _610 = _4385;
	                                }
	                                _611 = _609 - p._m3;
	                            }
	                            else
	                            {
	                                _610 = _4385;
	                                _611 = _609;
	                            }
	                            uint _4443 = uint(int(uint(_339.w)));
	                            float _4447 = _611 * float(_339.x);
	                            _483 = (_4245 * vec3(_344)) * ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4443].m_vTransmissiveLogColor.xyz * (1.0 + (_4447 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4443].m_fTransmissiveSaturation))) * exp(-_4447)) * _610);
	                        }
	                    }
	                    vec4 _725 = _482;
	                    if (_485 != (-1))
	                    {
	                        bool _4478 = any(notEqual(_484, vec3(0.0)));
	                        if (isinf(_725.w))
	                        {
	                            _605 = true;
	                        }
	                        else
	                        {
	                            _605 = isnan(_725.w);
	                        }
	                        if (!_605)
	                        {
	                            _606 = _725.w;
	                        }
	                        else
	                        {
	                            _606 = 56755.83984375;
	                        }
	                        vec4 _4494 = _725;
	                        _4494.w = _606;
	                        _725 = _4494;
	                        do
	                        {
	                            float _4501 = dot(_4494.xyz, g_Lights_1._m0[_485].m_vNearPlane.xyz);
	                            if (_4501 == 0.0)
	                            {
	                                _604 = 0.0;
	                                break;
	                            }
	                            _604 = (g_Lights_1._m0[_485].m_vNearPlane.w - dot(_2053, g_Lights_1._m0[_485].m_vNearPlane.xyz)) * (1.0 / _4501);
	                            break;
	                        } while(false);
	                        if (_604 > 0.0)
	                        {
	                            vec4 _4513 = _725;
	                            _4513.w = min(_4513.w, _604);
	                            _725 = _4513;
	                        }
	                        if (dot(_725.xyz, _447.xyz) < 0.0)
	                        {
	                            _724 = _448;
	                        }
	                        else
	                        {
	                            _724 = _449;
	                        }
	                        vec4 _4525 = _725;
	                        vec3 _4527 = _724 - _2053;
	                        _4525.w = _4525.w + dot(_4525.xyz, _4527);
	                        vec3 _4537 = normalize((_4525.xyz * _4525.w) + _4527);
	                        vec4 _4539 = _4525;
	                        _4539.x = _4537.x;
	                        _4539.y = _4537.y;
	                        _4539.z = _4537.z;
	                        _725 = _4539;
	                        do
	                        {
	                            if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 1) != 0)
	                            {
	                                _603 = 32u;
	                                break;
	                            }
	                            if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 2) != 0)
	                            {
	                                _603 = 16u;
	                                break;
	                            }
	                            _603 = 0u;
	                            break;
	                        } while(false);
	                        vec3 _492 = _724;
	                        float _491 = 0.0;
	                        vec3 _490 = _4539.xyz;
	                        if (_4478)
	                        {
	                            _602 = _4539.w;
	                        }
	                        else
	                        {
	                            _602 = 0.0;
	                        }
	                        p_1 = PayloadShadow_t(1.0);
	                        traceRayEXT(g_AccelStruct, _603, 2u, 1u, 2u, 1u, _492, _491, _490, _602, 1);
	                        if (_4478)
	                        {
	                            _602 = p_1.m_flVisibility;
	                        }
	                        else
	                        {
	                            _602 = 0.0;
	                        }
	                        _724 = (_716 + _483) + (_484 * _602);
	                    }
	                    else
	                    {
	                        _724 = _716;
	                    }
	                }
	                else
	                {
	                    _724 = _716;
	                }
	                _455 = _449;
	                _454 = _448;
	                _453 = _447;
	                _452 = _446;
	                _353 = _346;
	                _352 = _345;
	                _351 = _344;
	                _350 = _343;
	                _349 = _341;
	                _348 = _340;
	                _347 = _339;
	                _389 = _384;
	                _388 = _383;
	                _387 = _382;
	                _386 = _381;
	                _385 = _380;
	                vec3 _4608 = vec3(_344);
	                float _4614 = min(0.89999997615814208984375, max(_4608.x, max(_4608.y, _4608.z)));
	                float _752 = _751.x;
	                do
	                {
	                    if (_4614 <= 0.0)
	                    {
	                        _601 = false;
	                        break;
	                    }
	                    if (_4614 >= 1.0)
	                    {
	                        _601 = true;
	                        break;
	                    }
	                    if (_752 < _4614)
	                    {
	                        _752 = min(_752 / _4614, 0.99999988079071044921875);
	                        _601 = true;
	                        break;
	                    }
	                    _752 = min((_752 - _4614) / (1.0 - _4614), 0.99999988079071044921875);
	                    _601 = false;
	                    break;
	                } while(false);
	                vec2 _4639 = _751;
	                _4639.x = _752;
	                _751 = _4639;
	                if (_601)
	                {
	                    do
	                    {
	                        _753 = 1.0;
	                        float _600 = _751.x;
	                        do
	                        {
	                            if (_386 <= 0.0)
	                            {
	                                _598 = false;
	                                break;
	                            }
	                            if (_386 >= 1.0)
	                            {
	                                _598 = true;
	                                break;
	                            }
	                            if (_600 < _386)
	                            {
	                                _600 = min(_600 / _386, 0.99999988079071044921875);
	                                _598 = true;
	                                break;
	                            }
	                            _600 = min((_600 - _386) / (1.0 - _386), 0.99999988079071044921875);
	                            _598 = false;
	                            break;
	                        } while(false);
	                        vec2 _4671 = _751;
	                        _4671.x = _600;
	                        _751 = _4671;
	                        if (_598)
	                        {
	                            _753 = _386;
	                            _599 = true;
	                            break;
	                        }
	                        else
	                        {
	                            _753 = 1.0 - _386;
	                            _599 = false;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    if (_599)
	                    {
	                        _455 = _454;
	                    }
	                    do
	                    {
	                        vec2 _596 = _751;
	                        if (_599)
	                        {
	                            float _4773 = sqrt(_596.y);
	                            float _4775 = 6.283185482025146484375 * _596.x;
	                            vec3 _4783 = vec3(cos(_4775) * _4773, sin(_4775) * _4773, sqrt(max(0.0, 1.0 - _596.y)));
	                            _4783.z = -_4783.z;
	                            _595 = _4783;
	                            break;
	                        }
	                        else
	                        {
	                            float _597 = _596.x;
	                            do
	                            {
	                                if (_387 <= 0.0)
	                                {
	                                    _594 = false;
	                                    break;
	                                }
	                                if (_387 >= 1.0)
	                                {
	                                    _594 = true;
	                                    break;
	                                }
	                                if (_597 < _387)
	                                {
	                                    _597 = min(_597 / _387, 0.99999988079071044921875);
	                                    _594 = true;
	                                    break;
	                                }
	                                _597 = min((_597 - _387) / (1.0 - _387), 0.99999988079071044921875);
	                                _594 = false;
	                                break;
	                            } while(false);
	                            vec2 _4722 = _596;
	                            _4722.x = _597;
	                            _596 = _4722;
	                            if (_594)
	                            {
	                                float _4726 = float(_350);
	                                float _4734 = ((_4726 * _4726) * sqrt(_596.x)) / sqrt(1.0 - _596.x);
	                                float _4737 = 1.0 / (1.0 + (_4734 * _4734));
	                                float _4740 = sqrt(max(0.0, 1.0 - _4737));
	                                float _4743 = 6.283185482025146484375 * _596.y;
	                                vec3 _4748 = vec3(cos(_4743) * _4740, sin(_4743) * _4740, sqrt(_4737));
	                                if (dot(_385, _4748) > 0.0)
	                                {
	                                    _593 = _4748;
	                                }
	                                else
	                                {
	                                    _593 = -_4748;
	                                }
	                                _595 = -reflect(_385, _593);
	                                break;
	                            }
	                            float _4760 = sqrt(_596.y);
	                            float _4762 = 6.283185482025146484375 * _596.x;
	                            _595 = vec3(cos(_4762) * _4760, sin(_4762) * _4760, sqrt(max(0.0, 1.0 - _596.y)));
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    _745 = _595;
	                    vec3 _4789 = normalize(_595 + _385);
	                    float _4790 = _4789.z;
	                    if (_599)
	                    {
	                        _591 = _595.z * (-0.3183098733425140380859375);
	                    }
	                    else
	                    {
	                        if (_387 > 0.0)
	                        {
	                            float _4801 = float(_350);
	                            float _4802 = _4801 * _4801;
	                            float _4803 = _4802 * _4802;
	                            float _4807 = (((_4790 * _4803) - _4790) * _4790) + 1.0;
	                            _590 = 1.0 - _387;
	                            _591 = _387 * (((_4803 / max(9.9999999392252902907785028219223e-09, _4807 * _4807)) * _4790) / (12.56637096405029296875 * max(0.0, dot(_385, _4789))));
	                        }
	                        else
	                        {
	                            _590 = 1.0;
	                            _591 = 0.0;
	                        }
	                        _591 += (_590 * (_595.z * 0.3183098733425140380859375));
	                    }
	                    if (_591 == 0.0)
	                    {
	                        _592 = true;
	                    }
	                    else
	                    {
	                        _592 = isnan(_591);
	                    }
	                    if (_592)
	                    {
	                        _590 = 3.4028234663852885981170418348452e+38;
	                    }
	                    else
	                    {
	                        _590 = _591;
	                    }
	                    float _754 = _590;
	                    do
	                    {
	                        if (_599)
	                        {
	                            if ((_348 & 65535u) == 1u)
	                            {
	                                _585 = any(greaterThan(vec3(_347.xyz), vec3(0.0)));
	                            }
	                            else
	                            {
	                                _585 = false;
	                            }
	                            if (_585)
	                            {
	                                _589 = vec3(_347.xyz);
	                            }
	                            else
	                            {
	                                _589 = vec3(1.0);
	                            }
	                            _588 = _589 * 0.3183098733425140380859375;
	                            break;
	                        }
	                        else
	                        {
	                            vec3 _4844 = vec3(mix(f16vec3(_349), _351, f16vec3(_352)));
	                            float _4845 = float(_350);
	                            do
	                            {
	                                vec3 _4850 = _745 + _385;
	                                if (_745.z <= 0.0)
	                                {
	                                    _587 = true;
	                                }
	                                else
	                                {
	                                    _587 = _385.z <= 0.0;
	                                }
	                                if (_587)
	                                {
	                                    _586 = vec3(0.0);
	                                    break;
	                                }
	                                if (all(equal(_4850, vec3(0.0))))
	                                {
	                                    _586 = vec3(0.0);
	                                    break;
	                                }
	                                vec3 _4863 = normalize(_4850);
	                                float _4864 = _4863.z;
	                                float _4872 = _4845 * _4845;
	                                float _4873 = _4872 * _4872;
	                                float _4877 = (((_4864 * _4873) - _4864) * _4864) + 1.0;
	                                float _4881 = _4845 * _4845;
	                                float _4882 = _4881 * _4881;
	                                _586 = (_4844 + ((vec3(1.0) - _4844) * pow(max(0.0, 1.0 - dot(_745, _4863)), 5.0))) * (((_4873 / max(9.9999999392252902907785028219223e-09, _4877 * _4877)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_745.z * sqrt(((_385.z - (_4882 * _385.z)) * _385.z) + _4882)) + (_385.z * sqrt(((_745.z - (_4882 * _745.z)) * _745.z) + _4882))))) * 0.3183098733425140380859375);
	                                break;
	                            } while(false);
	                            _588 = ((vec3(_351) * (1.0 - float(_352))) * 0.3183098733425140380859375) + _586;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _4926 = _745;
	                    vec3 _4929 = mat3(_389, _388, vec3(_353)) * _4926;
	                    _745 = _4929;
	                    float _4932 = dot(vec3(_353), _4929);
	                    if (_599)
	                    {
	                        _584 = -_4932;
	                    }
	                    else
	                    {
	                        _584 = _4932;
	                    }
	                    do
	                    {
	                        if ((_452 & 1024) != 0)
	                        {
	                            _583 = true;
	                            break;
	                        }
	                        _583 = (dot(_453, _745) > 0.0) != _599;
	                        break;
	                    } while(false);
	                    if (_583)
	                    {
	                        _755 = (_749 * (_588 * max(0.0, _584))) / vec3((_4614 * _753) * _754);
	                    }
	                    else
	                    {
	                        _755 = vec3(0.0);
	                    }
	                    _747 = _755;
	                }
	                else
	                {
	                    _747 = vec3(0.0);
	                }
	                _746++;
	                _748 = (_748 + ((_724 * _749) * _750)) + ((vec3(_342) * _749) * _750);
	                continue;
	            }
	            vec3 _4972 = abs(_748);
	            float _4977 = max(_4972.x, max(_4972.y, _4972.z));
	            vec3 _4982 = clamp(_748 / vec3(_4977), vec3(-1.0), vec3(1.0)) * clamp(_4977, -100.0, 100.0);
	            float _4983 = dot(_1251, vec3(_338));
	            float _581;
	            vec3 _582;
	            if (_756)
	            {
	                _581 = -_4983;
	                _582 = _4982 * vTransmissiveRatio;
	            }
	            else
	            {
	                _581 = _4983;
	                _582 = _4982;
	            }
	            vec4 _4989 = _429;
	            vec3 _4996 = _4989.xyz + ((_582 * max(0.0, _581)) * 0.3183098733425140380859375);
	            vec4 _4998 = _4989;
	            _4998.x = _4996.x;
	            _4998.y = _4996.y;
	            _4998.z = _4996.z;
	            vec3 _5004 = _4998.xyz + vec3(0.0);
	            vec4 _5006 = _4998;
	            _5006.x = _5004.x;
	            _5006.y = _5004.y;
	            _5006.z = _5004.z;
	            _429 = _5006;
	            if (_581 > 0.0)
	            {
	                vec4 _579;
	                vec4 _5015 = _579;
	                _5015.x = 0.2820948064327239990234375;
	                float _5017 = _1251.y;
	                _5015.y = (-0.48860251903533935546875) * _5017;
	                float _5020 = _1251.z;
	                _5015.z = 0.48860251903533935546875 * _5020;
	                float _5023 = _1251.x;
	                _5015.w = (-0.48860251903533935546875) * _5023;
	                _579 = _5015;
	                vec4 _580;
	                vec4 _5028 = _580;
	                _5028.x = (1.09254848957061767578125 * _5023) * _5017;
	                _5028.y = ((-1.09254848957061767578125) * _5017) * _5020;
	                _5028.z = 0.3153915703296661376953125 * (((3.0 * _5020) * _5020) - 1.0);
	                _5028.w = ((-1.09254848957061767578125) * _5023) * _5020;
	                _580 = _5028;
	                _428 += (_5015 * _582.x);
	                _425 += (_5028 * _582.x);
	                _427 += (_5015 * _582.y);
	                _424 += (_5028 * _582.y);
	                _426 += (_5015 * _582.z);
	                _423 += (_5028 * _582.z);
	                vec4 _5066 = _422;
	                vec3 _5069 = _5066.xyz + (_582 * (0.546274244785308837890625 * ((_5023 * _5023) - (_5017 * _5017))));
	                vec4 _5071 = _5066;
	                _5071.x = _5069.x;
	                _5071.y = _5069.y;
	                _5071.z = _5069.z;
	                _422 = _5071;
	            }
	            vec3 _5083 = (_433 + _432) * 0.5;
	            vec2 _5093 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_831.xy, int(1u + (2u * _832)))))).xy;
	            vec2 _561 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_831.xy, int(1u + _832))))).xy;
	            bool _5106 = (_1149 & 1u) != 0u;
	            bool _562;
	            if (any(notEqual(vTransmissiveRatio, vec3(0.0))))
	            {
	                _562 = true;
	            }
	            else
	            {
	                _562 = _5106;
	            }
	            if (_562)
	            {
	                _562 = true;
	            }
	            else
	            {
	                _562 = (_1149 & 3u) != 0u;
	            }
	            vec4 _563 = vec4(0.0);
	            float _564 = 0.0;
	            uvec3 _5120 = min(uvec3(max(fma(_5083, _856, _858), vec3(0.0))), (_853 - uvec3(1u)));
	            int _566 = -1;
	            float _567 = 0.0;
	            bool _565 = false;
	            uint _568 = 0u;
	            vec3 _569 = vec3(0.0);
	            bool _516;
	            bool _517;
	            vec4 _518;
	            vec4 _519;
	            float _520;
	            vec3 _521;
	            vec4 _522;
	            vec4 _523;
	            float _524;
	            vec3 _525;
	            float _526;
	            float _527;
	            bool _528;
	            float _529;
	            vec4 _530;
	            vec2 _531;
	            float _532;
	            float _533;
	            vec4 _534;
	            float _535;
	            vec3 _536;
	            vec3 _537;
	            bool _538;
	            float _539;
	            vec4 _540;
	            vec2 _541;
	            float _542;
	            float _543;
	            vec3 _545;
	            vec3 _546;
	            vec4 _548;
	            float _549;
	            float _550;
	            vec3 _551;
	            vec3 _552;
	            float _553;
	            float _554;
	            bool _555;
	            vec3 _556;
	            vec3 _557;
	            bool _558;
	            bool _559;
	            vec3 _560;
	            uint _570;
	            vec3 _571;
	            float _576;
	            bool _577;
	            for (;;)
	            {
	                if (!(_568 < _852))
	                {
	                    break;
	                }
	                uint _5133 = _852 * _853.x;
	                int _574 = _566;
	                float _575 = _567;
	                bool _573 = _565;
	                _570 = subgroupOr(g_LightBins_1._m0[((((_5133 * _853.y) * _5120.z) + (_5133 * _5120.y)) + (_852 * _5120.x)) + _568]);
	                _571 = _569;
	                for (;;)
	                {
	                    bool _5156_ladder_break = false;
	                    do
	                    {
	                        if (!(_570 != 0u))
	                        {
	                            _5156_ladder_break = true;
	                            break;
	                        }
	                        uint _5163 = _570;
	                        uint _5167 = uint(findLSB(_5163)) + (_568 * 32u);
	                        uint _5169 = _5163 & (_5163 - 1u);
	                        mat4 _5199 = mat4(vec4(g_Lights_1._m0[_5167].m_mToClipSpace.data[0].x, g_Lights_1._m0[_5167].m_mToClipSpace.data[1].x, g_Lights_1._m0[_5167].m_mToClipSpace.data[2].x, g_Lights_1._m0[_5167].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_5167].m_mToClipSpace.data[0].y, g_Lights_1._m0[_5167].m_mToClipSpace.data[1].y, g_Lights_1._m0[_5167].m_mToClipSpace.data[2].y, g_Lights_1._m0[_5167].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_5167].m_mToClipSpace.data[0].z, g_Lights_1._m0[_5167].m_mToClipSpace.data[1].z, g_Lights_1._m0[_5167].m_mToClipSpace.data[2].z, g_Lights_1._m0[_5167].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_5167].m_mToClipSpace.data[0].w, g_Lights_1._m0[_5167].m_mToClipSpace.data[1].w, g_Lights_1._m0[_5167].m_mToClipSpace.data[2].w, g_Lights_1._m0[_5167].m_mToClipSpace.data[3].w));
	                        if ((g_Lights_1._m0[_5167].m_nPathTraceFlags & 2) == 0)
	                        {
	                            _570 = _5169;
	                            break;
	                        }
	                        do
	                        {
	                            do
	                            {
	                                vec4 _5269 = _5199 * vec4(_5083.xyz, 1.0);
	                                vec3 _5273 = _5269.xyz / vec3(_5269.w);
	                                vec4 _5275;
	                                _5275.x = _5273.x;
	                                _5275.y = _5273.y;
	                                _5275.z = _5273.z;
	                                if (all(greaterThanEqual(_5275.xyz, vec3(-1.0, -1.0, 0.0))))
	                                {
	                                    _558 = all(lessThanEqual(_5275.xyz, vec3(1.0)));
	                                }
	                                else
	                                {
	                                    _558 = false;
	                                }
	                                if (!_558)
	                                {
	                                    _559 = false;
	                                    break;
	                                }
	                                if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_5167].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_5083, 1.0)).xyz), vec3(1.0))))
	                                {
	                                    _559 = false;
	                                    break;
	                                }
	                                _559 = true;
	                                break;
	                            } while(false);
	                            if (!_559)
	                            {
	                                _560 = vec3(0.0);
	                                break;
	                            }
	                            vec4 _5307 = _5199 * vec4(_5083.xyz, 1.0);
	                            vec3 _5311 = _5307.xyz / vec3(_5307.w);
	                            vec4 _5313;
	                            _5313.x = _5311.x;
	                            _5313.y = _5311.y;
	                            _5313.z = _5311.z;
	                            if (false)
	                            {
	                                _557 = g_Lights_1._m0[_5167].m_vBounceColor.xyz;
	                            }
	                            else
	                            {
	                                _557 = g_Lights_1._m0[_5167].m_vColor.xyz;
	                            }
	                            if (true)
	                            {
	                                if (g_Lights_1._m0[_5167].m_nCookie >= 0)
	                                {
	                                    if (g_Lights_1._m0[_5167].m_bSphericalCookie != 0)
	                                    {
	                                        vec4 _5356 = vec4(-g_Lights_1._m0[_5167].m_vOrientation.xyz, g_Lights_1._m0[_5167].m_vOrientation.w);
	                                        vec4 _5358 = _5356.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                        vec3 _5361 = _5358.xyz;
	                                        vec3 _5362 = vec4((-normalize(g_Lights_1._m0[_5167].m_vLightPosition.xyz - _5083)).xyz, 0.0).xyz;
	                                        vec4 _5369 = vec4((_5362 * _5358.w) + cross(_5362, _5361), -dot(_5362, _5361));
	                                        vec3 _5370 = _5369.xyz;
	                                        float _5371 = _5356.w;
	                                        vec3 _5373 = _5356.xyz;
	                                        float _5374 = _5369.w;
	                                        vec3 _5382 = vec4(((_5370 * _5371) + (_5373 * _5374)) + cross(_5373, _5370), _323).xyz;
	                                        vec2 _5391 = vec2(atan(_5382.y, -_5382.x) * 0.15915493667125701904296875, acos(_5382.z) * 0.3183098733425140380859375);
	                                        vec2 _5396 = (_5391.xy * g_Lights_1._m0[_5167].m_vCookieParameters.zw) + g_Lights_1._m0[_5167].m_vCookieParameters.xy;
	                                        vec2 _5398 = _5391;
	                                        _5398.x = _5396.x;
	                                        _5398.y = _5396.y;
	                                        _556 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_5167].m_nCookie], g_Sampler), _5398, 0.0).xyz;
	                                    }
	                                    else
	                                    {
	                                        vec2 _5335 = fma(_5313.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                        vec2 _5340 = (_5335.xy * g_Lights_1._m0[_5167].m_vCookieParameters.zw) + g_Lights_1._m0[_5167].m_vCookieParameters.xy;
	                                        vec2 _5342 = _5335;
	                                        _5342.x = _5340.x;
	                                        _5342.y = _5340.y;
	                                        _556 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_5167].m_nCookie], g_CookieSampler), _5342, 0.0).xyz;
	                                    }
	                                }
	                                else
	                                {
	                                    _556 = vec3(1.0);
	                                }
	                                _557 *= _556;
	                            }
	                            if (g_Lights_1._m0[_5167].m_nLuminaireType != 0)
	                            {
	                                _557 = (_557 * g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                            }
	                            else
	                            {
	                                if (!(g_Lights_1._m0[_5167].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _5418 = g_Lights_1._m0[_5167].m_vLightPosition.xyz - _5083;
	                                    _557 *= (vec3(g_Lights_1._m0[_5167].m_vLightPosition.w) / max(vec3(dot(_5418, _5418)), vec3(g_Lights_1._m0[_5167].m_vLightPosition.w)));
	                                }
	                            }
	                            if (g_Lights_1._m0[_5167].m_vDistanceFade_vSkirt.z > 0.0)
	                            {
	                                _553 = smoothstep(0.0, 1.0, _5313.xyz.z * g_Lights_1._m0[_5167].m_vDistanceFade_vSkirt.z);
	                            }
	                            else
	                            {
	                                _553 = 1.0;
	                            }
	                            if (g_Lights_1._m0[_5167].m_vDistanceFade_vSkirt.w > 0.0)
	                            {
	                                _553 *= smoothstep(0.0, 1.0, (1.0 - _5313.xyz.z) * g_Lights_1._m0[_5167].m_vDistanceFade_vSkirt.w);
	                            }
	                            if (!(g_Lights_1._m0[_5167].m_vLightPosition.w == 0.0))
	                            {
	                                vec3 _5459 = g_Lights_1._m0[_5167].m_vLightPosition.xyz - _5083;
	                                float _5460 = length(_5459);
	                                vec3 _5462 = _5459 / vec3(_5460);
	                                float _5468 = _553 * smoothstep(0.0, 1.0, g_Lights_1._m0[_5167].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_5167].m_vDistanceFade_vSkirt.y * _5460));
	                                if (g_Lights_1._m0[_5167].m_nLuminaireType != 2)
	                                {
	                                    _555 = g_Lights_1._m0[_5167].m_nLuminaireType != 1;
	                                }
	                                else
	                                {
	                                    _555 = false;
	                                }
	                                if (_555)
	                                {
	                                    float _5480 = 2.0 * g_Lights_1._m0[_5167].m_vOrientation.x;
	                                    float _5484 = 2.0 * g_Lights_1._m0[_5167].m_vOrientation.w;
	                                    vec3 _5498 = vec3((_5480 * g_Lights_1._m0[_5167].m_vOrientation.y) - (_5484 * g_Lights_1._m0[_5167].m_vOrientation.z), (1.0 - (_5480 * g_Lights_1._m0[_5167].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_5167].m_vOrientation.z) * g_Lights_1._m0[_5167].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_5167].m_vOrientation.y) * g_Lights_1._m0[_5167].m_vOrientation.z) + (_5484 * g_Lights_1._m0[_5167].m_vOrientation.x)) * g_Lights_1._m0[_5167].m_vAngleFade.z;
	                                    vec3 _5499 = _5462 - _5498;
	                                    vec3 _5500 = _5462 + _5498;
	                                    do
	                                    {
	                                        vec3 _5503 = _5500 - _5499;
	                                        float _5505 = dot(-_5499, _5503);
	                                        if (_5505 <= 0.0)
	                                        {
	                                            _551 = _5499;
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _5510 = dot(_5503, _5503);
	                                            if (_5505 > _5510)
	                                            {
	                                                _551 = _5500;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                _551 = _5499 + (_5503 * (_5505 / _5510));
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (any(notEqual(_551, vec3(0.0))))
	                                    {
	                                        _552 = normalize(_551);
	                                    }
	                                    else
	                                    {
	                                        _552 = _551;
	                                    }
	                                    float _5534 = 2.0 * g_Lights_1._m0[_5167].m_vOrientation.x;
	                                    float _5537 = 2.0 * g_Lights_1._m0[_5167].m_vOrientation.w;
	                                    _554 = _5468 * clamp(g_Lights_1._m0[_5167].m_vAngleFade.x + (g_Lights_1._m0[_5167].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_5167].m_vOrientation.y) * g_Lights_1._m0[_5167].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_5167].m_vOrientation.z) * g_Lights_1._m0[_5167].m_vOrientation.z), (_5534 * g_Lights_1._m0[_5167].m_vOrientation.y) + (_5537 * g_Lights_1._m0[_5167].m_vOrientation.z), (_5534 * g_Lights_1._m0[_5167].m_vOrientation.z) - (_5537 * g_Lights_1._m0[_5167].m_vOrientation.y)), _552)), 0.0, 1.0);
	                                }
	                                else
	                                {
	                                    _554 = _5468;
	                                }
	                            }
	                            else
	                            {
	                                _554 = _553;
	                            }
	                            if (g_Lights_1._m0[_5167].m_nCookie == (-1))
	                            {
	                                do
	                                {
	                                    vec2 _5561 = abs(_5313.xyz.xy);
	                                    if (g_Lights_1._m0[_5167].m_vCookieParameters.z == 0.0)
	                                    {
	                                        _549 = smoothstep(1.0, g_Lights_1._m0[_5167].m_vCookieParameters.x, _5561.x) * smoothstep(1.0, g_Lights_1._m0[_5167].m_vCookieParameters.y, _5561.y);
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        float _5566 = _5561.x;
	                                        float _5570 = _5561.y;
	                                        float _5577 = (-0.5) * g_Lights_1._m0[_5167].m_vCookieParameters.z;
	                                        float _5579 = (g_Lights_1._m0[_5167].m_vCookieParameters.x * g_Lights_1._m0[_5167].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_5167].m_vCookieParameters.y * _5566, 2.0 / g_Lights_1._m0[_5167].m_vCookieParameters.z) + pow(g_Lights_1._m0[_5167].m_vCookieParameters.x * _5570, 2.0 / g_Lights_1._m0[_5167].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _5577);
	                                        float _5586 = pow(max(pow(_5566, 2.0 / g_Lights_1._m0[_5167].m_vCookieParameters.z) + pow(_5570, 2.0 / g_Lights_1._m0[_5167].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _5577);
	                                        if (_5579 < _5586)
	                                        {
	                                            _549 = smoothstep(_5586, _5579, 1.0);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            if (_5586 > 1.0)
	                                            {
	                                                _550 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _550 = 0.0;
	                                            }
	                                            _549 = _550;
	                                            break;
	                                        }
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _554 *= _549;
	                            }
	                            _560 = _557 * _554;
	                            break;
	                        } while(false);
	                        if (all(equal(_560, vec3(0.0))))
	                        {
	                            _570 = _5169;
	                            break;
	                        }
	                        _547 = false;
	                        do
	                        {
	                            switch (g_Lights_1._m0[_5167].m_nLuminaireType)
	                            {
	                                case 0:
	                                {
	                                    _576 = 1.0;
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5167].m_vLightPosition.w == 0.0)
	                                        {
	                                            _522 = vec4(normalize(g_Lights_1._m0[_5167].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _6074 = g_Lights_1._m0[_5167].m_vLightPosition.xyz - _5083;
	                                            float _6075 = length(_6074);
	                                            _522 = vec4(_6074 / vec3(_6075), _6075);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _547 = true;
	                                    _548 = _522;
	                                    break;
	                                }
	                                case 1:
	                                {
	                                    vec3 _5924 = g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].xyz;
	                                    vec3 _5926 = g_Lights_1._m0[_5167].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].xyz;
	                                    float _5927 = length(_5924);
	                                    float _5928 = length(_5926);
	                                    vec3 _5930 = _5924 / vec3(_5927);
	                                    vec3 _5932 = _5926 / vec3(_5928);
	                                    vec3 _5933 = cross(_5930, _5932);
	                                    vec3 _5934 = g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].xyz - _5083;
	                                    float _5935 = dot(_5934, _5933);
	                                    if (_5935 > 0.0)
	                                    {
	                                        _524 = _5935 * (-1.0);
	                                        _525 = _5933 * (-1.0);
	                                    }
	                                    else
	                                    {
	                                        _524 = _5935;
	                                        _525 = _5933;
	                                    }
	                                    float _5944 = dot(_5934, _5930);
	                                    float _5945 = dot(_5934, _5932);
	                                    float _5946 = _5944 + _5927;
	                                    float _5947 = _5945 + _5928;
	                                    vec3 _5950 = vec3(_5944, _5945, _524);
	                                    vec3 _5951 = vec3(_5944, _5947, _524);
	                                    vec3 _5952 = vec3(_5946, _5945, _524);
	                                    vec3 _5953 = vec3(_5946, _5947, _524);
	                                    vec3 _5955 = normalize(cross(_5950, _5952));
	                                    vec3 _5957 = normalize(cross(_5952, _5953));
	                                    vec3 _5959 = normalize(cross(_5953, _5951));
	                                    vec3 _5961 = normalize(cross(_5951, _5950));
	                                    float _5978 = _5955.z;
	                                    float _5982 = (6.283185482025146484375 - acos(clamp(-dot(_5959, _5961), -1.0, 1.0))) - acos(clamp(-dot(_5961, _5955), -1.0, 1.0));
	                                    float _5984 = (acos(clamp(-dot(_5955, _5957), -1.0, 1.0)) + acos(clamp(-dot(_5957, _5959), -1.0, 1.0))) - _5982;
	                                    if (isnan(_5984))
	                                    {
	                                        _526 = 0.0;
	                                    }
	                                    else
	                                    {
	                                        _526 = _5984;
	                                    }
	                                    float _5992 = (_5093.x * _526) + _5982;
	                                    float _5997 = ((cos(_5992) * _5978) - _5959.z) / sin(_5992);
	                                    if (_5997 > 0.0)
	                                    {
	                                        _527 = 1.0;
	                                    }
	                                    else
	                                    {
	                                        _527 = -1.0;
	                                    }
	                                    float _6006 = _527;
	                                    float _6008 = clamp((1.0 / sqrt((_5997 * _5997) + (_5978 * _5978))) * _6006, -1.0, 1.0);
	                                    float _6016 = clamp((-(_6008 * _524)) / sqrt(1.0 - (_6008 * _6008)), _5944, _5946);
	                                    float _6019 = sqrt((_6016 * _6016) + (_524 * _524));
	                                    float _6020 = _6019 * _6019;
	                                    float _6023 = _5945 / sqrt(_6020 + (_5945 * _5945));
	                                    float _6030 = _6023 + (_5093.y * ((_5947 / sqrt(_6020 + (_5947 * _5947))) - _6023));
	                                    float _6031 = _6030 * _6030;
	                                    if (_6031 < 0.99999988079071044921875)
	                                    {
	                                        _527 = (_6030 * _6019) / sqrt(1.0 - _6031);
	                                    }
	                                    else
	                                    {
	                                        _527 = _5947;
	                                    }
	                                    vec3 _6048 = ((_5083 + (_5930 * _6016)) + (_5932 * _527)) + (_525 * _524);
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5167].m_vLightPosition.w == 0.0)
	                                        {
	                                            _523 = vec4(normalize(_6048), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _6056 = _6048 - _5083;
	                                            float _6057 = length(_6056);
	                                            _523 = vec4(_6056 / vec3(_6057), _6057);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _576 = 1.0 / _526;
	                                    _547 = true;
	                                    _548 = _523;
	                                    break;
	                                }
	                                case 2:
	                                {
	                                    do
	                                    {
	                                        vec2 _5852 = (_5093 * 2.0) - vec2(1.0);
	                                        if (all(equal(_5852, vec2(0.0))))
	                                        {
	                                            _531 = vec2(0.0);
	                                            break;
	                                        }
	                                        float _5857 = _5852.x;
	                                        float _5859 = _5852.y;
	                                        if (abs(_5857) > abs(_5859))
	                                        {
	                                            _532 = _5857;
	                                            _533 = 0.785398185253143310546875 * (_5859 / _5857);
	                                        }
	                                        else
	                                        {
	                                            _532 = _5859;
	                                            _533 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_5857 / _5859));
	                                        }
	                                        _531 = vec2(cos(_533), sin(_533)) * _532;
	                                        break;
	                                    } while(false);
	                                    vec3 _5885 = (g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].xyz * _531.x)) + (g_Lights_1._m0[_5167].m_vLuminaireVectors.data[2].xyz * _531.y);
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5167].m_vLightPosition.w == 0.0)
	                                        {
	                                            _530 = vec4(normalize(_5885), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _5893 = _5885 - _5083;
	                                            float _5894 = length(_5893);
	                                            _530 = vec4(_5893 / vec3(_5894), _5894);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (isinf(_530.w))
	                                    {
	                                        _528 = true;
	                                    }
	                                    else
	                                    {
	                                        _528 = isnan(_530.w);
	                                    }
	                                    if (!_528)
	                                    {
	                                        _529 = _530.w * _530.w;
	                                    }
	                                    else
	                                    {
	                                        _529 = 1.0;
	                                    }
	                                    _576 = _529 / (max(0.0, dot(g_Lights_1._m0[_5167].m_vLuminaireVectors.data[3].xyz, -_530.xyz)) * g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].w);
	                                    _547 = true;
	                                    _548 = _530;
	                                    break;
	                                }
	                                case 3:
	                                {
	                                    vec3 _5751 = g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].xyz - _5083;
	                                    float _5752 = dot(_5751, _5751);
	                                    float _5753 = sqrt(_5752);
	                                    vec3 _5755 = _5751 / vec3(_5753);
	                                    float _5756 = _5755.z;
	                                    if (_5756 >= 0.0)
	                                    {
	                                        _535 = 1.0;
	                                    }
	                                    else
	                                    {
	                                        _535 = -1.0;
	                                    }
	                                    float _5763 = (-1.0) / (_535 + _5756);
	                                    float _5764 = _5755.x;
	                                    float _5765 = _5755.y;
	                                    float _5767 = (_5764 * _5765) * _5763;
	                                    vec3 _5772 = _536;
	                                    _5772.x = 1.0 + (((_535 * _5764) * _5764) * _5763);
	                                    _5772.y = _535 * _5767;
	                                    _5772.z = (-_535) * _5764;
	                                    _536 = _5772;
	                                    vec3 _5779 = _537;
	                                    _5779.x = _5767;
	                                    _5779.y = _535 + ((_5765 * _5765) * _5763);
	                                    _5779.z = -_5765;
	                                    _537 = _5779;
	                                    float _5787 = g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].x;
	                                    float _5791 = sqrt(max(0.0, 1.0 - (_5787 / _5752)));
	                                    float _5792 = _5093.x;
	                                    float _5795 = (1.0 - _5792) + (_5792 * _5791);
	                                    float _5799 = sqrt(max(0.0, 1.0 - (_5795 * _5795)));
	                                    float _5801 = _5093.y * 6.283185482025146484375;
	                                    float _5803 = _5753 * _5753;
	                                    float _5809 = (_5753 * _5795) - sqrt(max(0.0, _5787 - ((_5803 * _5799) * _5799)));
	                                    float _5815 = ((_5803 + _5787) - (_5809 * _5809)) / ((2.0 * _5753) * g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].x);
	                                    float _5819 = sqrt(max(0.0, 1.0 - (_5815 * _5815)));
	                                    vec3 _5831 = g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].xyz + ((mat3(-_5772, -_5779, -_5755) * vec3(cos(_5801) * _5819, sin(_5801) * _5819, _5815)) * g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].x);
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5167].m_vLightPosition.w == 0.0)
	                                        {
	                                            _534 = vec4(normalize(_5831), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _5839 = _5831 - _5083;
	                                            float _5840 = length(_5839);
	                                            _534 = vec4(_5839 / vec3(_5840), _5840);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _576 = 0.15915493667125701904296875 / (1.0 - _5791);
	                                    _547 = true;
	                                    _548 = _534;
	                                    break;
	                                }
	                                case 4:
	                                case 5:
	                                {
	                                    vec2 _544 = _5093;
	                                    if (_5093.x < g_Lights_1._m0[_5167].m_vLuminaireVectors.data[4].y)
	                                    {
	                                        vec2 _5652 = _544;
	                                        _5652.x = clamp(_5652.x / g_Lights_1._m0[_5167].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                        _544 = _5652;
	                                        vec3 _5658 = normalize(g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].xyz);
	                                        if (_5652.x >= 0.5)
	                                        {
	                                            vec2 _5669 = _544;
	                                            _5669.x = clamp((2.0 * _5669.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                            _544 = _5669;
	                                            _545 = -_5658;
	                                            _546 = g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _5664 = _544;
	                                            _5664.x = clamp(2.0 * _5664.x, 0.0, 0.99999988079071044921875);
	                                            _544 = _5664;
	                                            _545 = _5658;
	                                            _546 = g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].xyz;
	                                        }
	                                        do
	                                        {
	                                            vec2 _5680 = (_544 * 2.0) - vec2(1.0);
	                                            if (all(equal(_5680, vec2(0.0))))
	                                            {
	                                                _541 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _5685 = _5680.x;
	                                            float _5687 = _5680.y;
	                                            if (abs(_5685) > abs(_5687))
	                                            {
	                                                _542 = _5685;
	                                                _543 = 0.785398185253143310546875 * (_5687 / _5685);
	                                            }
	                                            else
	                                            {
	                                                _542 = _5687;
	                                                _543 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_5685 / _5687));
	                                            }
	                                            _541 = vec2(cos(_543), sin(_543)) * _542;
	                                            break;
	                                        } while(false);
	                                        _546 += ((g_Lights_1._m0[_5167].m_vLuminaireVectors.data[2].xyz * _541.x) + (g_Lights_1._m0[_5167].m_vLuminaireVectors.data[3].xyz * _541.y));
	                                    }
	                                    else
	                                    {
	                                        vec2 _5631 = _544;
	                                        _5631.x = clamp((_5631.x - g_Lights_1._m0[_5167].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_5167].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                        _544 = _5631;
	                                        vec3 _5646 = (g_Lights_1._m0[_5167].m_vLuminaireVectors.data[2].xyz * cos(_5631.x * 6.283185482025146484375)) + (g_Lights_1._m0[_5167].m_vLuminaireVectors.data[3].xyz * sin(_5631.x * 6.283185482025146484375));
	                                        _545 = normalize(_5646);
	                                        _546 = mix(g_Lights_1._m0[_5167].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].xyz, vec3(_5631.y)) + _5646;
	                                    }
	                                    do
	                                    {
	                                        if (g_Lights_1._m0[_5167].m_vLightPosition.w == 0.0)
	                                        {
	                                            _540 = vec4(normalize(_546), uintBitsToFloat(0x7f800000u /* inf */));
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            vec3 _5720 = _546 - _5083;
	                                            float _5721 = length(_5720);
	                                            _540 = vec4(_5720 / vec3(_5721), _5721);
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (isinf(_540.w))
	                                    {
	                                        _538 = true;
	                                    }
	                                    else
	                                    {
	                                        _538 = isnan(_540.w);
	                                    }
	                                    if (!_538)
	                                    {
	                                        _539 = _540.w * _540.w;
	                                    }
	                                    else
	                                    {
	                                        _539 = 1.0;
	                                    }
	                                    _576 = _539 / (max(0.0, dot(_545, -_540.xyz)) * g_Lights_1._m0[_5167].m_vLuminaireVectors.data[1].w);
	                                    _547 = true;
	                                    _548 = _540;
	                                    break;
	                                }
	                                default:
	                                {
	                                    _576 = 0.0;
	                                    _547 = true;
	                                    _548 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                    break;
	                                }
	                            }
	                            if (_547)
	                            {
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        vec3 _6087 = _560 * (3.1415927410125732421875 / _576);
	                        bool _6091 = !(dot(_431, _548.xyz) > 0.0);
	                        if (!((g_Lights_1._m0[_5167].m_nPathTraceFlags & 8) != 0))
	                        {
	                            vec3 _6098 = abs(_6087);
	                            float _6103 = max(_6098.x, max(_6098.y, _6098.z));
	                            vec3 _6108 = clamp(_6087 / vec3(_6103), vec3(-1.0), vec3(1.0)) * clamp(_6103, -100.0, 100.0);
	                            float _6109 = dot(_548.xyz, vec3(_331));
	                            if (_6091)
	                            {
	                                _520 = -_6109;
	                                _521 = _6108 * vTransmissiveRatio;
	                            }
	                            else
	                            {
	                                _520 = _6109;
	                                _521 = _6108;
	                            }
	                            vec4 _6115 = _429;
	                            vec3 _6122 = _6115.xyz + ((_521 * max(0.0, _520)) * 0.3183098733425140380859375);
	                            vec4 _6124 = _6115;
	                            _6124.x = _6122.x;
	                            _6124.y = _6122.y;
	                            _6124.z = _6122.z;
	                            vec3 _6130 = _6124.xyz + vec3(0.0);
	                            vec4 _6132 = _6124;
	                            _6132.x = _6130.x;
	                            _6132.y = _6130.y;
	                            _6132.z = _6130.z;
	                            _429 = _6132;
	                            if (_520 > 0.0)
	                            {
	                                vec4 _6141 = _518;
	                                _6141.x = 0.2820948064327239990234375;
	                                _6141.y = (-0.48860251903533935546875) * _548.y;
	                                _6141.z = 0.48860251903533935546875 * _548.z;
	                                _6141.w = (-0.48860251903533935546875) * _548.x;
	                                _518 = _6141;
	                                vec4 _6154 = _519;
	                                _6154.x = (1.09254848957061767578125 * _548.x) * _548.y;
	                                _6154.y = ((-1.09254848957061767578125) * _548.y) * _548.z;
	                                _6154.z = 0.3153915703296661376953125 * (((3.0 * _548.z) * _548.z) - 1.0);
	                                _6154.w = ((-1.09254848957061767578125) * _548.x) * _548.z;
	                                _519 = _6154;
	                                _428 += (_6141 * _521.x);
	                                _425 += (_6154 * _521.x);
	                                _427 += (_6141 * _521.y);
	                                _424 += (_6154 * _521.y);
	                                _426 += (_6141 * _521.z);
	                                _423 += (_6154 * _521.z);
	                                vec4 _6192 = _422;
	                                vec3 _6195 = _6192.xyz + (_521 * (0.546274244785308837890625 * ((_548.x * _548.x) - (_548.y * _548.y))));
	                                vec4 _6197 = _6192;
	                                _6197.x = _6195.x;
	                                _6197.y = _6195.y;
	                                _6197.z = _6195.z;
	                                _422 = _6197;
	                            }
	                            _570 = _5169;
	                            break;
	                        }
	                        if (_6091)
	                        {
	                            _577 = !_562;
	                        }
	                        else
	                        {
	                            _577 = false;
	                        }
	                        if (_577)
	                        {
	                            _570 = _5169;
	                            break;
	                        }
	                        float _6214 = max(_6087.x, max(_6087.y, _6087.z));
	                        float _578 = _561.x;
	                        do
	                        {
	                            float _6219 = _564;
	                            float _6220 = _6219 + _6214;
	                            _564 = _6220;
	                            if (_6220 == 0.0)
	                            {
	                                _517 = false;
	                                break;
	                            }
	                            float _6225 = _6214 / _564;
	                            do
	                            {
	                                if (_6225 <= 0.0)
	                                {
	                                    _516 = false;
	                                    break;
	                                }
	                                if (_6225 >= 1.0)
	                                {
	                                    _516 = true;
	                                    break;
	                                }
	                                if (_578 < _6225)
	                                {
	                                    _578 = min(_578 / _6225, 0.99999988079071044921875);
	                                    _516 = true;
	                                    break;
	                                }
	                                _578 = min((_578 - _6225) / (1.0 - _6225), 0.99999988079071044921875);
	                                _516 = false;
	                                break;
	                            } while(false);
	                            _517 = _516;
	                            break;
	                        } while(false);
	                        vec2 _6249 = _561;
	                        _6249.x = _578;
	                        _561 = _6249;
	                        if (_517)
	                        {
	                            _563 = _548;
	                            _574 = int(_5167);
	                            _575 = _6214;
	                            _573 = _6091;
	                            _571 = _6087;
	                        }
	                        _570 = _5169;
	                        break;
	                    } while(false);
	                    if (_5156_ladder_break)
	                    {
	                        break;
	                    }
	                    continue;
	                }
	                _566 = _574;
	                _567 = _575;
	                _565 = _573;
	                _568++;
	                _569 = _571;
	                continue;
	            }
	            bool _6265 = any(notEqual(_569, vec3(0.0)));
	            if (_566 != (-1))
	            {
	                _562 = _6265;
	            }
	            else
	            {
	                _562 = false;
	            }
	            if (_562)
	            {
	                vec3 _6282 = _569;
	                vec3 _6283 = _6282 * (_564 / _567);
	                bool _514;
	                if (isinf(_563.w))
	                {
	                    _514 = true;
	                }
	                else
	                {
	                    _514 = isnan(_563.w);
	                }
	                float _515;
	                if (!_514)
	                {
	                    _515 = _563.w;
	                }
	                else
	                {
	                    _515 = 56755.83984375;
	                }
	                vec4 _6299 = _563;
	                _6299.w = _515;
	                _563 = _6299;
	                float _513;
	                do
	                {
	                    float _6306 = dot(_6299.xyz, g_Lights_1._m0[_566].m_vNearPlane.xyz);
	                    if (_6306 == 0.0)
	                    {
	                        _513 = 0.0;
	                        break;
	                    }
	                    _513 = (g_Lights_1._m0[_566].m_vNearPlane.w - dot(_5083, g_Lights_1._m0[_566].m_vNearPlane.xyz)) * (1.0 / _6306);
	                    break;
	                } while(false);
	                if (_513 > 0.0)
	                {
	                    vec4 _6318 = _563;
	                    _6318.w = min(_6318.w, _513);
	                    _563 = _6318;
	                }
	                if (_565)
	                {
	                    _571 = _432;
	                }
	                else
	                {
	                    _571 = _433;
	                }
	                vec4 _6326 = _563;
	                vec3 _6328 = _571 - _5083;
	                _6326.w = _6326.w + dot(_6326.xyz, _6328);
	                vec3 _6338 = normalize((_6326.xyz * _6326.w) + _6328);
	                vec4 _6340 = _6326;
	                _6340.x = _6338.x;
	                _6340.y = _6338.y;
	                _6340.z = _6338.z;
	                _563 = _6340;
	                if (_5106)
	                {
	                    _570 = 8u;
	                }
	                else
	                {
	                    _570 = 2u;
	                }
	                uint _512;
	                do
	                {
	                    if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 1) != 0)
	                    {
	                        _512 = 32u;
	                        break;
	                    }
	                    if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 2) != 0)
	                    {
	                        _512 = 16u;
	                        break;
	                    }
	                    _512 = 0u;
	                    break;
	                } while(false);
	                vec3 _495 = _571;
	                float _494 = 0.0;
	                vec3 _493 = _563.xyz;
	                float _511;
	                if (_6265)
	                {
	                    _511 = _563.w;
	                }
	                else
	                {
	                    _511 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, _512, _570, 1u, 2u, 1u, _495, _494, _493, _511, 1);
	                if (_6265)
	                {
	                    _511 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _511 = 0.0;
	                }
	                vec4 _6390 = _304[g_Lights_1._m0[_566].m_nBakedShadowIndex + 1] * dot(_6283.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                _421 += (_6390 * _511);
	                _420 += _6390;
	                _419 = mix(_419, ivec4(g_Lights_1._m0[_566].m_nShadowedLightId), notEqual(_6390, vec4(0.0)));
	                if (g_Lights_1._m0[_566].m_nBakedShadowIndex == (-1))
	                {
	                    if (_565)
	                    {
	                        bool _509;
	                        if ((_326 & 65535u) == 2u)
	                        {
	                            _509 = float(_325.x) > 0.0;
	                        }
	                        else
	                        {
	                            _509 = false;
	                        }
	                        _562 = _509;
	                    }
	                    else
	                    {
	                        _562 = false;
	                    }
	                    vec3 _572;
	                    if (_562)
	                    {
	                        float _6433 = pow(clamp(-dot(normalize(_431 + vec3(_331)), _563.xyz), 0.0, 1.0), 2.0);
	                        f16vec3 _6434 = f16vec3(vec3(0.0));
	                        vec3 _499;
	                        bool _505;
	                        if (isinf(_563.w))
	                        {
	                            _505 = true;
	                        }
	                        else
	                        {
	                            _505 = isnan(_563.w);
	                        }
	                        float _506;
	                        if (!_505)
	                        {
	                            _506 = _563.w;
	                        }
	                        else
	                        {
	                            _506 = 1000.0;
	                        }
	                        vec3 _498 = _433 + (_563.xyz * _506);
	                        float _497 = 0.0;
	                        vec3 _496 = -_563.xyz;
	                        float _507;
	                        if (_6433 > 0.0)
	                        {
	                            _507 = _506;
	                        }
	                        else
	                        {
	                            _507 = 0.0;
	                        }
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _499, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_6434, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _6434, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _498, _497, _496, _507, 0);
	                        float _508;
	                        if (p._m5 != (-1))
	                        {
	                            bool _504;
	                            if ((p._m7._m6 & 65535u) == 2u)
	                            {
	                                _504 = float(p._m7._m7.x) > 0.0;
	                            }
	                            else
	                            {
	                                _504 = false;
	                            }
	                            if (!_504)
	                            {
	                                _507 = 0.0;
	                            }
	                            else
	                            {
	                                _507 = _6433;
	                            }
	                            _508 = _506 - p._m3;
	                        }
	                        else
	                        {
	                            _507 = _6433;
	                            _508 = _506;
	                        }
	                        uint _6491 = uint(int(uint(_325.w)));
	                        float _6495 = _508 * float(_325.x);
	                        _569 = vec3(0.0);
	                        _572 = ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_6491].m_vTransmissiveLogColor.xyz * (1.0 + (_6495 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_6491].m_fTransmissiveSaturation))) * exp(-_6495)) * _507) * _6283;
	                    }
	                    else
	                    {
	                        _569 = _6283;
	                        _572 = vec3(0.0);
	                    }
	                    vec3 _6516 = _569 * _511;
	                    vec3 _6521 = abs(_6516);
	                    float _6526 = max(_6521.x, max(_6521.y, _6521.z));
	                    vec3 _6531 = clamp(_6516 / vec3(_6526), vec3(-1.0), vec3(1.0)) * clamp(_6526, -100.0, 100.0);
	                    vec3 _6532 = abs(_572);
	                    float _6537 = max(_6532.x, max(_6532.y, _6532.z));
	                    float _6543 = dot(_563.xyz, vec3(_331));
	                    float _502;
	                    vec3 _503;
	                    if (_565)
	                    {
	                        _502 = -_6543;
	                        _503 = _6531 * vTransmissiveRatio;
	                    }
	                    else
	                    {
	                        _502 = _6543;
	                        _503 = _6531;
	                    }
	                    vec4 _6549 = _429;
	                    vec3 _6556 = _6549.xyz + ((_503 * max(0.0, _502)) * 0.3183098733425140380859375);
	                    vec4 _6558 = _6549;
	                    _6558.x = _6556.x;
	                    _6558.y = _6556.y;
	                    _6558.z = _6556.z;
	                    vec3 _6564 = _6558.xyz + (clamp(_572 / vec3(_6537), vec3(-1.0), vec3(1.0)) * clamp(_6537, -100.0, 100.0));
	                    vec4 _6566 = _6558;
	                    _6566.x = _6564.x;
	                    _6566.y = _6564.y;
	                    _6566.z = _6564.z;
	                    _429 = _6566;
	                    if (_502 > 0.0)
	                    {
	                        vec4 _500;
	                        vec4 _6575 = _500;
	                        _6575.x = 0.2820948064327239990234375;
	                        _6575.y = (-0.48860251903533935546875) * _563.y;
	                        _6575.z = 0.48860251903533935546875 * _563.z;
	                        _6575.w = (-0.48860251903533935546875) * _563.x;
	                        _500 = _6575;
	                        vec4 _501;
	                        vec4 _6588 = _501;
	                        _6588.x = (1.09254848957061767578125 * _563.x) * _563.y;
	                        _6588.y = ((-1.09254848957061767578125) * _563.y) * _563.z;
	                        _6588.z = 0.3153915703296661376953125 * (((3.0 * _563.z) * _563.z) - 1.0);
	                        _6588.w = ((-1.09254848957061767578125) * _563.x) * _563.z;
	                        _501 = _6588;
	                        _428 += (_6575 * _503.x);
	                        _425 += (_6588 * _503.x);
	                        _427 += (_6575 * _503.y);
	                        _424 += (_6588 * _503.y);
	                        _426 += (_6575 * _503.z);
	                        _423 += (_6588 * _503.z);
	                        vec4 _6626 = _422;
	                        vec3 _6629 = _6626.xyz + (_503 * (0.546274244785308837890625 * ((_563.x * _563.x) - (_563.y * _563.y))));
	                        vec4 _6631 = _6626;
	                        _6631.x = _6629.x;
	                        _6631.y = _6629.y;
	                        _6631.z = _6629.z;
	                        _422 = _6631;
	                    }
	                }
	            }
	            float _6642 = sqrt(vSeed.y);
	            float _6644 = 6.283185482025146484375 * vSeed.x;
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _433, 0.0, mat3(_374, _373, vec3(_331)) * vec3(cos(_6644) * _6642, sin(_6644) * _6642, sqrt(max(0.0, 1.0 - vSeed.y))), 16.0, 1);
	            vec4 _6660 = _416;
	            _6660.x = _6660.x + p_1.m_flVisibility;
	            _416 = _6660;
	        }
	        vec4 _6664 = _429;
	        _6664.w = 1.0;
	        _429 = _6664;
	        if (g_PushConstants.m_nEstimate_DimensionCount.x > 0)
	        {
	            vec4 _6673 = g_Luxels._m0[_779].vIrradiance_flSampleCount;
	            float _6716 = 1.0 / (1.0 + _6673.w);
	            vec3 _6720 = mix(_6673.xyz, _429.xyz, vec3(_6716));
	            vec4 _6722 = _6673;
	            _6722.x = _6720.x;
	            _6722.y = _6720.y;
	            _6722.z = _6720.z;
	            vec4 _6727 = vec4(_6716);
	            _6722.w = _6722.w + 1.0;
	            _429 = _6722;
	            _428 = mix(g_Luxels._m0[_779].vShr, _428, _6727);
	            _427 = mix(g_Luxels._m0[_779].vShg, _427, _6727);
	            _426 = mix(g_Luxels._m0[_779].vShb, _426, _6727);
	            _425 = mix(g_Luxels._m0[_779].vQuadraticr, _425, _6727);
	            _424 = mix(g_Luxels._m0[_779].vQuadraticg, _424, _6727);
	            _423 = mix(g_Luxels._m0[_779].vQuadraticb, _423, _6727);
	            _422 = mix(g_Luxels._m0[_779].vQuadraticFinalrgb, _422, _6727);
	            _421 = mix(g_Luxels._m0[_779].vBakedShadow, _421, _6727);
	            _420 = mix(g_Luxels._m0[_779].vBakedShadowUnoccluded, _420, _6727);
	            _419 = mix(_419, g_Luxels._m0[_779].vBakedShadowLightId, notEqual(g_Luxels._m0[_779].vBakedShadowLightId, ivec4(255)));
	            _418 = mix(g_Luxels._m0[_779].vTangent, _418, _6727);
	            _417 = mix(g_Luxels._m0[_779].vNormal, _417, _6727);
	            _416 = mix(g_Luxels._m0[_779].flAmbientOcclusion_vPadding, _416, _6727);
	        }
	        g_Luxels._m0[_779].vIrradiance_flSampleCount = _429;
	        g_Luxels._m0[_779].vShr = _428;
	        g_Luxels._m0[_779].vShg = _427;
	        g_Luxels._m0[_779].vShb = _426;
	        g_Luxels._m0[_779].vQuadraticr = _425;
	        g_Luxels._m0[_779].vQuadraticg = _424;
	        g_Luxels._m0[_779].vQuadraticb = _423;
	        g_Luxels._m0[_779].vQuadraticFinalrgb = _422;
	        g_Luxels._m0[_779].vBakedShadow = _421;
	        g_Luxels._m0[_779].vBakedShadowUnoccluded = _420;
	        g_Luxels._m0[_779].vBakedShadowLightId = _419;
	        g_Luxels._m0[_779].vTangent = _418;
	        g_Luxels._m0[_779].vNormal = _417;
	        g_Luxels._m0[_779].flAmbientOcclusion_vPadding = _416;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
