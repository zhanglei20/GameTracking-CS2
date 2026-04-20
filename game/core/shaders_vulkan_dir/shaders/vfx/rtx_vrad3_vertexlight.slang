//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "General shaders for baked lighting preview in Hammer";
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
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (106880 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct VertexLightSample_t_natural
	{
	    vec4 vIrradiance_flSampleCount;
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
	
	float _265;
	vec4 _266;
	
	layout(set = 6, binding = 160, std430) buffer RWStructuredBuffer
	{
	    VertexLightSample_t_natural _m0[];
	} g_Samples;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    SceneGlobalInfoGPU_t_natural _m0[];
	} g_SceneGlobalInfo;
	
	layout(set = 6, binding = 158, std430) buffer g_Triangles
	{
	    float _m0[];
	} g_Triangles_1;
	
	layout(set = 3, binding = 35, std430) readonly buffer g_instanceBuffer
	{
	    PackedRtxInstanceData_t_natural _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 6, binding = 161, std430) buffer g_LightBins
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
	
	layout(push_constant, std430) uniform VertexLightPushConstants_t_natural
	{
	    ivec4 m_nEstimate_nDimensionCount_nVertexStride_nMinSamples;
	    ivec4 m_nTriangleCount_Unused0;
	    vec4 m_vCordonMins;
	    vec4 m_vCordonMaxs;
	} g_PushConstants;
	
	layout(set = 6, binding = 159, r32ui) uniform readonly uimage3D g_TrianglesConverged;
	layout(set = 6, binding = 162) uniform readonly image3D g_RandomSamples;
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D[65536];
	layout(set = 3, binding = 15) uniform sampler g_CookieSampler;
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	
	void main()
	{
	    bool _462 = false;
	    bool _516 = false;
	    do
	    {
	        uvec2 vTriangle = gl_LaunchIDEXT.xy / uvec2(4u);
	        uint nSampleIndex = (gl_LaunchIDEXT.x + (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x)) + ((gl_LaunchIDEXT.z * gl_LaunchSizeEXT.x) * gl_LaunchSizeEXT.y);
	        int nTriangle = int(vTriangle.x + ((gl_LaunchSizeEXT.x / 4u) * vTriangle.y));
	        if (nTriangle >= g_PushConstants.m_nTriangleCount_Unused0.x)
	        {
	            break;
	        }
	        vec2 _602 = (vec2((gl_LaunchIDEXT.xy - (vTriangle.xy * uvec2(4u))).xy) + vec2(0.5)) * vec2(0.25);
	        float _604 = sqrt(_602.x);
	        vec3 _609 = vec3(1.0 - _604, _604 * (1.0 - _602.y), _265);
	        if (g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.x == 0)
	        {
	            g_Samples._m0[nSampleIndex].vIrradiance_flSampleCount = vec4(0.0);
	        }
	        else
	        {
	            if (imageLoad(g_TrianglesConverged, ivec3(uvec3(ivec3(ivec2(vTriangle), 0)))).x != 0u)
	            {
	                break;
	            }
	        }
	        uvec3 _634 = uvec3(imageSize(g_RandomSamples));
	        ivec3 _569;
	        ivec3 _637 = _569;
	        _637.x = int(_634.x);
	        _637.y = int(_634.y);
	        _637.z = int(_634.z);
	        _569 = _637;
	        ivec2 _646 = ivec2(gl_LaunchIDEXT.xy) - _637.xy * (ivec2(gl_LaunchIDEXT.xy) / _637.xy);
	        uint _647 = uint(g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.y);
	        uint _667 = uint(max(1, ((g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	        uvec3 _668 = uvec3(g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.xyz);
	        vec3 _671 = vec3(_668) / (g_SceneGlobalInfo._m0[0].m_vLocalLightMaxBounds.xyz - g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz);
	        vec3 _673 = (-g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz) * _671;
	        int _674 = 3 * nTriangle;
	        vec3 v0 = vec3(g_Triangles_1._m0[_674 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._m0[(_674 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._m0[(_674 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        int _692 = _674 + 1;
	        vec3 v1 = vec3(g_Triangles_1._m0[_692 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._m0[(_692 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._m0[(_692 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        int _710 = _674 + 2;
	        vec3 v2 = vec3(g_Triangles_1._m0[_710 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._m0[(_710 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._m0[(_710 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        vec3 _731 = normalize(cross(v1 - v0, v2 - v0));
	        float _732 = _609.x;
	        float _734 = _609.y;
	        vec3 _350 = ((v0 * ((1.0 - _732) - _734)) + (v1 * _732)) + (v2 * _734);
	        f16vec3 _274 = f16vec3(_731);
	        vec3 _348 = _731;
	        vec3 _310;
	        vec3 _570 = _310;
	        vec3 _309;
	        vec3 _571 = _309;
	        float _744 = _731.z;
	        float _568;
	        if (_744 >= 0.0)
	        {
	            _568 = 1.0;
	        }
	        else
	        {
	            _568 = -1.0;
	        }
	        float _751 = (-1.0) / (_568 + _744);
	        float _752 = _731.x;
	        float _753 = _731.y;
	        float _755 = (_752 * _753) * _751;
	        vec3 _760 = _570;
	        _760.x = 1.0 + (((_568 * _752) * _752) * _751);
	        _760.y = _568 * _755;
	        _760.z = (-_568) * _752;
	        _570 = _760;
	        vec3 _767 = _571;
	        _767.x = _755;
	        _767.y = _568 + ((_753 * _753) * _751);
	        _767.z = -_753;
	        _571 = _767;
	        _310 = _760;
	        _309 = _767;
	        f16vec3 _272 = f16vec3(vec3(1.0));
	        vec3 _776 = _350;
	        float _779 = abs(1.0);
	        vec3 _784 = _776 + (_348 * ((abs(_776) + vec3(_779)) * 9.9999997473787516355514526367188e-05));
	        _350 = _784;
	        vec2 _791 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_646.xy, 1)))).xy;
	        bool _572;
	        if (all(greaterThanEqual(_784.xyz, g_PushConstants.m_vCordonMins.xyz)))
	        {
	            _572 = all(lessThanEqual(_350.xyz, g_PushConstants.m_vCordonMaxs.xyz));
	        }
	        else
	        {
	            _572 = false;
	        }
	        vec3 vIrradiance;
	        if (_572)
	        {
	            vec3 _306;
	            float _307;
	            float _308;
	            f16vec4 _268;
	            uint _269;
	            float16_t _270;
	            float16_t _271;
	            float16_t _273;
	            int _347;
	            vec3 _349;
	            float _828 = _791.y;
	            float _829 = sqrt(_828);
	            float _831 = 6.283185482025146484375 * _791.x;
	            vec3 _839 = vec3(cos(_831) * _829, sin(_831) * _829, sqrt(max(0.0, 1.0 - _828)));
	            vec3 _842 = vec3(_274);
	            vec3 _844 = mat3(_310, _309, _842) * _839;
	            vec3 _557 = _844;
	            vec3 _360 = _350;
	            vec3 _359 = _349;
	            vec3 _358 = _348;
	            int _357 = _347;
	            f16vec3 _289 = _274;
	            float16_t _288 = _273;
	            f16vec3 _287 = _272;
	            float16_t _286 = _271;
	            float16_t _285 = _270;
	            uint _284 = _269;
	            f16vec4 _283 = _268;
	            vec3 _320 = _310;
	            vec3 _319 = _309;
	            float _318 = _308;
	            float _317 = _307;
	            vec3 _316 = _306;
	            int _558 = 1;
	            vec3 _559 = vec3(1.0 / (_839.z * 0.3183098733425140380859375));
	            vec3 _560 = vec3(0.0);
	            vec3 _361;
	            vec3 _374;
	            vec3 _394;
	            bool _398;
	            float _399;
	            bool _400;
	            vec3 _401;
	            bool _402;
	            vec3 _403;
	            vec3 _404;
	            float _405;
	            float _406;
	            bool _407;
	            vec3 _408;
	            bool _409;
	            vec3 _410;
	            bool _413;
	            bool _414;
	            bool _416;
	            float _417;
	            uint _418;
	            float _419;
	            bool _420;
	            float _421;
	            bool _422;
	            bool _423;
	            float _424;
	            float _425;
	            float _426;
	            bool _427;
	            float _428;
	            bool _429;
	            vec3 _430;
	            bool _431;
	            vec3 _432;
	            vec3 _433;
	            bool _434;
	            bool _435;
	            float _436;
	            vec4 _437;
	            vec4 _438;
	            float _439;
	            vec3 _440;
	            float _441;
	            float _442;
	            bool _443;
	            float _444;
	            vec4 _445;
	            vec2 _446;
	            float _447;
	            float _448;
	            vec4 _449;
	            float _450;
	            vec3 _451;
	            vec3 _452;
	            bool _453;
	            float _454;
	            vec4 _455;
	            vec2 _456;
	            float _457;
	            float _458;
	            vec3 _460;
	            vec3 _461;
	            vec4 _463;
	            float _464;
	            float _465;
	            vec3 _466;
	            vec3 _467;
	            float _468;
	            float _469;
	            bool _470;
	            vec3 _471;
	            vec3 _472;
	            bool _473;
	            bool _474;
	            vec3 _475;
	            bool _480;
	            float _483;
	            float _485;
	            bool _486;
	            vec3 _487;
	            bool _488;
	            vec3 _489;
	            vec3 _490;
	            vec4 _491;
	            vec4 _492;
	            float _493;
	            vec3 _494;
	            float _495;
	            float _496;
	            bool _497;
	            float _498;
	            vec4 _499;
	            vec2 _500;
	            float _501;
	            float _502;
	            vec4 _503;
	            float _504;
	            vec3 _505;
	            vec3 _506;
	            bool _507;
	            float _508;
	            vec4 _509;
	            vec2 _510;
	            float _511;
	            float _512;
	            vec3 _514;
	            vec3 _515;
	            vec4 _517;
	            float _518;
	            float _519;
	            vec3 _520;
	            vec3 _521;
	            float _522;
	            float _523;
	            bool _524;
	            vec3 _525;
	            vec3 _526;
	            bool _527;
	            bool _528;
	            vec3 _529;
	            float _534;
	            bool _535;
	            bool _536;
	            bool _537;
	            vec3 _539;
	            float _541;
	            float _542;
	            bool _545;
	            float _546;
	            float _547;
	            bool _550;
	            bool _551;
	            bool _553;
	            vec3 _555;
	            vec3 _556;
	            vec3 _561;
	            float _562;
	            float _565;
	            vec3 _567;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_558 <= 16))
	                {
	                    break;
	                }
	                if (false)
	                {
	                    if (_558 > (-1))
	                    {
	                        _562 = 1.0;
	                        _561 = vec3(0.0);
	                    }
	                    else
	                    {
	                        if (_558 != (-1))
	                        {
	                            _562 = 0.0;
	                        }
	                        else
	                        {
	                            _562 = 1.0;
	                        }
	                        _561 = _559;
	                    }
	                }
	                else
	                {
	                    _562 = 1.0;
	                    _561 = _559;
	                }
	                if (all(equal(_561, vec3(0.0))))
	                {
	                    break;
	                }
	                vec3 _356 = _360;
	                vec3 _355 = _557;
	                vec2 _889 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_646.xy, int(1u + uint(_558)))))).xy;
	                f16vec3 _891 = f16vec3(vec3(0.0));
	                vec2 _897 = _889;
	                _897.y = 0.0;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _361, 3.4028234663852885981170418348452e+38, _889.y, -1, false, MaterialDataMinimal_t(_891, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _891, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 4u, 0u, 2u, 0u, _360, 0.0, _557, 56755.83984375, 0);
	                Payload_t _899 = p;
	                vec2 _901 = _889;
	                _901.y = _899._m4;
	                vec2 _563 = _901;
	                if (!(_899._m5 != (-1)))
	                {
	                    vec2 _918 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_646.xy, int(1u + uint(_558 + 1)))))).xy;
	                    _563 = _918;
	                    vec2 _552 = _918;
	                    if (_557.z < 0.0)
	                    {
	                        float _554 = _552.y;
	                        do
	                        {
	                            if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w <= 0.0)
	                            {
	                                _551 = false;
	                                break;
	                            }
	                            if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w >= 1.0)
	                            {
	                                _551 = true;
	                                break;
	                            }
	                            if (_554 < g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w)
	                            {
	                                _554 = min(_554 / g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                                _551 = true;
	                                break;
	                            }
	                            _554 = min((_554 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                            _551 = false;
	                            break;
	                        } while(false);
	                        vec2 _954 = _552;
	                        _954.y = _554;
	                        _552 = _954;
	                        _553 = _551;
	                    }
	                    else
	                    {
	                        _553 = false;
	                    }
	                    if (_553)
	                    {
	                        float _962 = sqrt(_552.y);
	                        float _964 = 6.283185482025146484375 * _552.x;
	                        _555 = vec3(cos(_964) * _962, sin(_964) * _962, sqrt(max(0.0, 1.0 - _552.y)));
	                        _556 = g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.xyz;
	                    }
	                    else
	                    {
	                        _555 = _557;
	                        _556 = vec3(0.0);
	                    }
	                    if (g_SceneGlobalInfo._m0[0].m_vIBLParams.y >= 0)
	                    {
	                        vec4 _1031 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._m0[0].m_vIBLParams.y], g_Sampler), normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_555, 0.0)), 0.0);
	                        if (dot(_1031.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	                        {
	                            _556 += (g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * _1031.xyz);
	                        }
	                    }
	                    else
	                    {
	                        _556 += g_SceneGlobalInfo._m0[0].m_vSkyColor.xyz;
	                    }
	                    if (_558 > 1)
	                    {
	                        _556 *= g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.w;
	                    }
	                    if (_553)
	                    {
	                        _556 *= g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.xyz;
	                    }
	                    _560 += ((_561 * _556) * _562);
	                    break;
	                }
	                if ((int((g_instanceBuffer_1._m0[uint(_899._m5)].nMaterialFlags_nInstanceFlags >> uint(16)) & 65535u) & 4) != 0)
	                {
	                    break;
	                }
	                uint _1083 = uint(_899._m5);
	                vec3 _365 = (_356 + (_355 * _899._m3)) + (_899._m1 * ((abs(_356) + vec3(abs(_899._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _364 = (_356 + (_355 * _899._m3)) + ((-_899._m1) * ((abs(_356) + vec3(abs(_899._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _363 = _899._m1;
	                int _362 = int((g_instanceBuffer_1._m0[_1083].nMaterialFlags_nInstanceFlags) & 65535u);
	                vec3 _370 = vec3(0.0);
	                vec3 _369 = vec3(0.0);
	                float _368 = 0.0;
	                float _367 = 0.0;
	                vec3 _366 = vec3(0.0);
	                f16vec3 _333 = _899._m7.vMaterialBits;
	                float16_t _332 = _899._m7._m1;
	                f16vec3 _331 = _899._m7._m2;
	                f16vec3 _329 = _899._m7._m4;
	                float16_t _328 = _899._m7._m5;
	                uint _327 = _899._m7._m6;
	                f16vec4 _326 = _899._m7._m7;
	                float16_t _330 = float16_t(max(float(_899._m7._m3), 0.07999999821186065673828125));
	                vec3 _1130 = vec3(_899._m7.vMaterialBits);
	                vec3 _548 = vec3(0.0);
	                vec3 _549 = vec3(0.0);
	                float _1131 = _1130.z;
	                if (_1131 >= 0.0)
	                {
	                    _547 = 1.0;
	                }
	                else
	                {
	                    _547 = -1.0;
	                }
	                float _1138 = (-1.0) / (_547 + _1131);
	                float _1139 = _1130.x;
	                float _1140 = _1130.y;
	                float _1142 = (_1139 * _1140) * _1138;
	                vec3 _1147 = _548;
	                _1147.x = 1.0 + (((_547 * _1139) * _1139) * _1138);
	                _1147.y = _547 * _1142;
	                _1147.z = (-_547) * _1139;
	                _548 = _1147;
	                vec3 _1154 = _549;
	                _1154.x = _1142;
	                _1154.y = _547 + ((_1140 * _1140) * _1138);
	                _1154.z = -_1140;
	                _549 = _1154;
	                _370 = _1147;
	                _369 = _1154;
	                vec3 _1166 = transpose(mat3(_1147, _1154, vec3(_333))) * (-_355);
	                _366 = _1166;
	                vec3 _1174 = vec3(mix(f16vec3(_328), _331, f16vec3(_332)));
	                _368 = dot((_1174 + ((vec3(1.0) - _1174) * pow(max(0.0, 1.0 - _1166.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                if ((_327 & 65535u) == 1u)
	                {
	                    float _1193 = dot(vec3(_326.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                    _367 = _1193 / max(9.9999997473787516355514526367188e-05, _1193 + dot(vec3(_331).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                }
	                f16vec3 _297 = _333;
	                float16_t _296 = _332;
	                f16vec3 _295 = _331;
	                float16_t _294 = _330;
	                f16vec3 _293 = _329;
	                float16_t _292 = _328;
	                uint _291 = _327;
	                f16vec4 _290 = _326;
	                vec3 _325 = _370;
	                vec3 _324 = _369;
	                float _323 = _368;
	                float _322 = _367;
	                vec3 _321 = _366;
	                if (true)
	                {
	                    if ((_362 & 256) != 0)
	                    {
	                        _293 *= float16_t(g_instanceBuffer_1._m0[_1083].fEmissiveBoost);
	                    }
	                    else
	                    {
	                        _293 = f16vec3(vec3(0.0));
	                    }
	                }
	                if (true)
	                {
	                    _550 = any(notEqual(_899.material, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _550 = false;
	                }
	                vec3 _1234 = _899.material - _365;
	                float _1235 = length(_1234);
	                vec3 _373 = _365;
	                float _372 = 0.0;
	                vec3 _371 = vec4(_1234 / vec3(_1235), _1235).xyz;
	                if (_550)
	                {
	                    _546 = _1235;
	                }
	                else
	                {
	                    _546 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _373, _372, _371, _546, 1);
	                if (_550)
	                {
	                    _546 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _546 = 0.0;
	                }
	                if (_546 == 1.0)
	                {
	                    _365 = _899.material;
	                    _363 = vec3(_899._m7.vMaterialBits);
	                }
	                vec3 _354 = _365;
	                vec3 _353 = _364;
	                vec3 _352 = _363;
	                int _351 = _362;
	                f16vec3 _282 = _297;
	                float16_t _281 = _296;
	                f16vec3 _280 = _295;
	                float16_t _279 = _294;
	                f16vec3 _278 = _293;
	                float16_t _277 = _292;
	                uint _276 = _291;
	                f16vec4 _275 = _290;
	                vec3 _315 = _325;
	                vec3 _314 = _324;
	                float _313 = _323;
	                float _312 = _322;
	                vec3 _311 = _321;
	                if (!(dot(_363, -_557) > 0.0))
	                {
	                    if ((_351 & 1024) != 0)
	                    {
	                        _352 = -_352;
	                        _282 = -_282;
	                        vec3 _1513 = _360;
	                        _360 = _359;
	                        _359 = _1513;
	                    }
	                    else
	                    {
	                        f16vec3 _1294 = f16vec3(vec3(0.0));
	                        vec2 _1300 = _889;
	                        _1300.y = 0.0;
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _374, 3.4028234663852885981170418348452e+38, _889.y, -1, false, MaterialDataMinimal_t(_1294, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1294, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 4u, 0u, 2u, 0u, _356, _899._m3 * 0.99989998340606689453125, _355, _899._m3 * 1.00010001659393310546875, 0);
	                        vec2 _1306 = _889;
	                        _1306.y = p._m4;
	                        _563 = _1306;
	                        if (p._m5 != (-1))
	                        {
	                            uint _1315 = uint(p._m5);
	                            vec3 _378 = (_356 + (_355 * p._m3)) + (p._m1 * ((abs(_356) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _377 = (_356 + (_355 * p._m3)) + ((-p._m1) * ((abs(_356) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _376 = p._m1;
	                            int _375 = int((g_instanceBuffer_1._m0[_1315].nMaterialFlags_nInstanceFlags) & 65535u);
	                            vec3 _383 = vec3(0.0);
	                            vec3 _382 = vec3(0.0);
	                            float _381 = 0.0;
	                            float _380 = 0.0;
	                            vec3 _379 = vec3(0.0);
	                            f16vec3 _346 = p._m7.vMaterialBits;
	                            float16_t _345 = p._m7._m1;
	                            f16vec3 _344 = p._m7._m2;
	                            f16vec3 _342 = p._m7._m4;
	                            float16_t _341 = p._m7._m5;
	                            uint _340 = p._m7._m6;
	                            f16vec4 _339 = p._m7._m7;
	                            float16_t _343 = float16_t(max(float(p._m7._m3), 0.07999999821186065673828125));
	                            vec3 _1362 = vec3(p._m7.vMaterialBits);
	                            vec3 _543 = vec3(0.0);
	                            vec3 _544 = vec3(0.0);
	                            float _1363 = _1362.z;
	                            if (_1363 >= 0.0)
	                            {
	                                _542 = 1.0;
	                            }
	                            else
	                            {
	                                _542 = -1.0;
	                            }
	                            float _1370 = (-1.0) / (_542 + _1363);
	                            float _1371 = _1362.x;
	                            float _1372 = _1362.y;
	                            float _1374 = (_1371 * _1372) * _1370;
	                            vec3 _1379 = _543;
	                            _1379.x = 1.0 + (((_542 * _1371) * _1371) * _1370);
	                            _1379.y = _542 * _1374;
	                            _1379.z = (-_542) * _1371;
	                            _543 = _1379;
	                            vec3 _1386 = _544;
	                            _1386.x = _1374;
	                            _1386.y = _542 + ((_1372 * _1372) * _1370);
	                            _1386.z = -_1372;
	                            _544 = _1386;
	                            _383 = _1379;
	                            _382 = _1386;
	                            vec3 _1398 = transpose(mat3(_1379, _1386, vec3(_346))) * (-_355);
	                            _379 = _1398;
	                            vec3 _1406 = vec3(mix(f16vec3(_341), _344, f16vec3(_345)));
	                            _381 = dot((_1406 + ((vec3(1.0) - _1406) * pow(max(0.0, 1.0 - _1398.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if ((_340 & 65535u) == 1u)
	                            {
	                                float _1425 = dot(vec3(_339.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                _380 = _1425 / max(9.9999997473787516355514526367188e-05, _1425 + dot(vec3(_344).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                            }
	                            f16vec3 _305 = _346;
	                            float16_t _304 = _345;
	                            f16vec3 _303 = _344;
	                            float16_t _302 = _343;
	                            f16vec3 _301 = _342;
	                            float16_t _300 = _341;
	                            uint _299 = _340;
	                            f16vec4 _298 = _339;
	                            vec3 _338 = _383;
	                            vec3 _337 = _382;
	                            float _336 = _381;
	                            float _335 = _380;
	                            vec3 _334 = _379;
	                            if (true)
	                            {
	                                if ((_375 & 256) != 0)
	                                {
	                                    _301 *= float16_t(g_instanceBuffer_1._m0[_1315].fEmissiveBoost);
	                                }
	                                else
	                                {
	                                    _301 = f16vec3(vec3(0.0));
	                                }
	                            }
	                            if (true)
	                            {
	                                _545 = any(notEqual(p.material, vec3(3.4028234663852885981170418348452e+38)));
	                            }
	                            else
	                            {
	                                _545 = false;
	                            }
	                            vec3 _1466 = p.material - _378;
	                            float _1467 = length(_1466);
	                            vec3 _386 = _378;
	                            float _385 = 0.0;
	                            vec3 _384 = vec4(_1466 / vec3(_1467), _1467).xyz;
	                            if (_545)
	                            {
	                                _541 = _1467;
	                            }
	                            else
	                            {
	                                _541 = 0.0;
	                            }
	                            p_1 = PayloadShadow_t(1.0);
	                            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _386, _385, _384, _541, 1);
	                            if (_545)
	                            {
	                                _541 = p_1.m_flVisibility;
	                            }
	                            else
	                            {
	                                _541 = 0.0;
	                            }
	                            if (_541 == 1.0)
	                            {
	                                _378 = p.material;
	                                _376 = vec3(p._m7.vMaterialBits);
	                            }
	                            _354 = _378;
	                            _353 = _377;
	                            _352 = _376;
	                            _351 = _375;
	                            _282 = _305;
	                            _281 = _304;
	                            _280 = _303;
	                            _279 = _302;
	                            _278 = _301;
	                            _277 = _300;
	                            _276 = _299;
	                            _275 = _298;
	                            _315 = _338;
	                            _314 = _337;
	                            _313 = _336;
	                            _312 = _335;
	                            _311 = _334;
	                        }
	                        else
	                        {
	                            break;
	                        }
	                    }
	                }
	                vec3 _1530 = (_354 + _353) * 0.5;
	                bool _1531 = _558 != 0;
	                if ((_276 & 65535u) == 1u)
	                {
	                    _536 = any(greaterThan(vec3(_275.xyz), vec3(0.0)));
	                }
	                else
	                {
	                    _536 = false;
	                }
	                if (_536)
	                {
	                    _537 = true;
	                }
	                else
	                {
	                    if ((_276 & 65535u) == 2u)
	                    {
	                        _535 = float(_275.x) > 0.0;
	                    }
	                    else
	                    {
	                        _535 = false;
	                    }
	                    _537 = _535;
	                }
	                vec2 _1565 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_646.xy, int(1u + ((2u * _647) + uint(_558))))))).xy;
	                bool _538 = false;
	                vec3 _1578 = (_354 + _353) * 0.5;
	                uvec3 _1583 = min(uvec3(max(fma(_1578, _671, _673), vec3(0.0))), (_668 - uvec3(1u)));
	                uint _530 = 0u;
	                vec3 _531 = vec3(0.0);
	                for (;;)
	                {
	                    if (!(_530 < _667))
	                    {
	                        break;
	                    }
	                    uint _1596 = _667 * _668.x;
	                    uint _532 = subgroupOr(g_LightBins_1._m0[((((_1596 * _668.y) * _1583.z) + (_1596 * _1583.y)) + (_667 * _1583.x)) + _530]);
	                    vec3 _533 = _531;
	                    for (;;)
	                    {
	                        bool _1616_ladder_break = false;
	                        do
	                        {
	                            if (!(_532 != 0u))
	                            {
	                                _1616_ladder_break = true;
	                                break;
	                            }
	                            uint _1623 = _532;
	                            uint _1627 = uint(findLSB(_1623)) + (_530 * 32u);
	                            uint _1629 = _1623 & (_1623 - 1u);
	                            mat4 _1659 = mat4(vec4(g_Lights_1._m0[_1627].m_mToClipSpace.data[0].x, g_Lights_1._m0[_1627].m_mToClipSpace.data[1].x, g_Lights_1._m0[_1627].m_mToClipSpace.data[2].x, g_Lights_1._m0[_1627].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_1627].m_mToClipSpace.data[0].y, g_Lights_1._m0[_1627].m_mToClipSpace.data[1].y, g_Lights_1._m0[_1627].m_mToClipSpace.data[2].y, g_Lights_1._m0[_1627].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_1627].m_mToClipSpace.data[0].z, g_Lights_1._m0[_1627].m_mToClipSpace.data[1].z, g_Lights_1._m0[_1627].m_mToClipSpace.data[2].z, g_Lights_1._m0[_1627].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_1627].m_mToClipSpace.data[0].w, g_Lights_1._m0[_1627].m_mToClipSpace.data[1].w, g_Lights_1._m0[_1627].m_mToClipSpace.data[2].w, g_Lights_1._m0[_1627].m_mToClipSpace.data[3].w));
	                            if ((uint(g_Lights_1._m0[_1627].m_nPathTraceFlags) & 1u) == 0u)
	                            {
	                                _532 = _1629;
	                                break;
	                            }
	                            if ((g_Lights_1._m0[_1627].m_nPathTraceFlags & 8) != 0)
	                            {
	                                _538 = true;
	                                _532 = _1629;
	                                break;
	                            }
	                            do
	                            {
	                                do
	                                {
	                                    vec4 _1734 = _1659 * vec4(_1578.xyz, 1.0);
	                                    vec3 _1738 = _1734.xyz / vec3(_1734.w);
	                                    vec4 _1740;
	                                    _1740.x = _1738.x;
	                                    _1740.y = _1738.y;
	                                    _1740.z = _1738.z;
	                                    if (all(greaterThanEqual(_1740.xyz, vec3(-1.0, -1.0, 0.0))))
	                                    {
	                                        _527 = all(lessThanEqual(_1740.xyz, vec3(1.0)));
	                                    }
	                                    else
	                                    {
	                                        _527 = false;
	                                    }
	                                    if (!_527)
	                                    {
	                                        _528 = false;
	                                        break;
	                                    }
	                                    if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_1627].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_1578, 1.0)).xyz), vec3(1.0))))
	                                    {
	                                        _528 = false;
	                                        break;
	                                    }
	                                    _528 = true;
	                                    break;
	                                } while(false);
	                                if (!_528)
	                                {
	                                    _529 = vec3(0.0);
	                                    break;
	                                }
	                                vec4 _1772 = _1659 * vec4(_1578.xyz, 1.0);
	                                vec3 _1776 = _1772.xyz / vec3(_1772.w);
	                                vec4 _1778;
	                                _1778.x = _1776.x;
	                                _1778.y = _1776.y;
	                                _1778.z = _1776.z;
	                                if (_1531)
	                                {
	                                    _526 = g_Lights_1._m0[_1627].m_vBounceColor.xyz;
	                                }
	                                else
	                                {
	                                    _526 = g_Lights_1._m0[_1627].m_vColor.xyz;
	                                }
	                                if (true)
	                                {
	                                    if (g_Lights_1._m0[_1627].m_nCookie >= 0)
	                                    {
	                                        if (g_Lights_1._m0[_1627].m_bSphericalCookie != 0)
	                                        {
	                                            vec4 _1821 = vec4(-g_Lights_1._m0[_1627].m_vOrientation.xyz, g_Lights_1._m0[_1627].m_vOrientation.w);
	                                            vec4 _1823 = _1821.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                            vec3 _1826 = _1823.xyz;
	                                            vec3 _1827 = vec4((-normalize(g_Lights_1._m0[_1627].m_vLightPosition.xyz - _1578)).xyz, 0.0).xyz;
	                                            vec4 _1834 = vec4((_1827 * _1823.w) + cross(_1827, _1826), -dot(_1827, _1826));
	                                            vec3 _1835 = _1834.xyz;
	                                            float _1836 = _1821.w;
	                                            vec3 _1838 = _1821.xyz;
	                                            float _1839 = _1834.w;
	                                            vec3 _1847 = vec4(((_1835 * _1836) + (_1838 * _1839)) + cross(_1838, _1835), _265).xyz;
	                                            vec2 _1856 = vec2(atan(_1847.y, -_1847.x) * 0.15915493667125701904296875, acos(_1847.z) * 0.3183098733425140380859375);
	                                            vec2 _1861 = (_1856.xy * g_Lights_1._m0[_1627].m_vCookieParameters.zw) + g_Lights_1._m0[_1627].m_vCookieParameters.xy;
	                                            vec2 _1863 = _1856;
	                                            _1863.x = _1861.x;
	                                            _1863.y = _1861.y;
	                                            _525 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_1627].m_nCookie], g_Sampler), _1863, 0.0).xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _1800 = fma(_1778.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                            vec2 _1805 = (_1800.xy * g_Lights_1._m0[_1627].m_vCookieParameters.zw) + g_Lights_1._m0[_1627].m_vCookieParameters.xy;
	                                            vec2 _1807 = _1800;
	                                            _1807.x = _1805.x;
	                                            _1807.y = _1805.y;
	                                            _525 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_1627].m_nCookie], g_CookieSampler), _1807, 0.0).xyz;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _525 = vec3(1.0);
	                                    }
	                                    _526 *= _525;
	                                }
	                                if (g_Lights_1._m0[_1627].m_nLuminaireType != 0)
	                                {
	                                    _526 = (_526 * g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                }
	                                else
	                                {
	                                    if (!(g_Lights_1._m0[_1627].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _1883 = g_Lights_1._m0[_1627].m_vLightPosition.xyz - _1578;
	                                        _526 *= (vec3(g_Lights_1._m0[_1627].m_vLightPosition.w) / max(vec3(dot(_1883, _1883)), vec3(g_Lights_1._m0[_1627].m_vLightPosition.w)));
	                                    }
	                                }
	                                if (g_Lights_1._m0[_1627].m_vDistanceFade_vSkirt.z > 0.0)
	                                {
	                                    _522 = smoothstep(0.0, 1.0, _1778.xyz.z * g_Lights_1._m0[_1627].m_vDistanceFade_vSkirt.z);
	                                }
	                                else
	                                {
	                                    _522 = 1.0;
	                                }
	                                if (g_Lights_1._m0[_1627].m_vDistanceFade_vSkirt.w > 0.0)
	                                {
	                                    _522 *= smoothstep(0.0, 1.0, (1.0 - _1778.xyz.z) * g_Lights_1._m0[_1627].m_vDistanceFade_vSkirt.w);
	                                }
	                                if (!(g_Lights_1._m0[_1627].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _1924 = g_Lights_1._m0[_1627].m_vLightPosition.xyz - _1578;
	                                    float _1925 = length(_1924);
	                                    vec3 _1927 = _1924 / vec3(_1925);
	                                    float _1933 = _522 * smoothstep(0.0, 1.0, g_Lights_1._m0[_1627].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_1627].m_vDistanceFade_vSkirt.y * _1925));
	                                    if (g_Lights_1._m0[_1627].m_nLuminaireType != 2)
	                                    {
	                                        _524 = g_Lights_1._m0[_1627].m_nLuminaireType != 1;
	                                    }
	                                    else
	                                    {
	                                        _524 = false;
	                                    }
	                                    if (_524)
	                                    {
	                                        float _1945 = 2.0 * g_Lights_1._m0[_1627].m_vOrientation.x;
	                                        float _1949 = 2.0 * g_Lights_1._m0[_1627].m_vOrientation.w;
	                                        vec3 _1963 = vec3((_1945 * g_Lights_1._m0[_1627].m_vOrientation.y) - (_1949 * g_Lights_1._m0[_1627].m_vOrientation.z), (1.0 - (_1945 * g_Lights_1._m0[_1627].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_1627].m_vOrientation.z) * g_Lights_1._m0[_1627].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_1627].m_vOrientation.y) * g_Lights_1._m0[_1627].m_vOrientation.z) + (_1949 * g_Lights_1._m0[_1627].m_vOrientation.x)) * g_Lights_1._m0[_1627].m_vAngleFade.z;
	                                        vec3 _1964 = _1927 - _1963;
	                                        vec3 _1965 = _1927 + _1963;
	                                        do
	                                        {
	                                            vec3 _1968 = _1965 - _1964;
	                                            float _1970 = dot(-_1964, _1968);
	                                            if (_1970 <= 0.0)
	                                            {
	                                                _520 = _1964;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _1975 = dot(_1968, _1968);
	                                                if (_1970 > _1975)
	                                                {
	                                                    _520 = _1965;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    _520 = _1964 + (_1968 * (_1970 / _1975));
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (any(notEqual(_520, vec3(0.0))))
	                                        {
	                                            _521 = normalize(_520);
	                                        }
	                                        else
	                                        {
	                                            _521 = _520;
	                                        }
	                                        float _1999 = 2.0 * g_Lights_1._m0[_1627].m_vOrientation.x;
	                                        float _2002 = 2.0 * g_Lights_1._m0[_1627].m_vOrientation.w;
	                                        _523 = _1933 * clamp(g_Lights_1._m0[_1627].m_vAngleFade.x + (g_Lights_1._m0[_1627].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_1627].m_vOrientation.y) * g_Lights_1._m0[_1627].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_1627].m_vOrientation.z) * g_Lights_1._m0[_1627].m_vOrientation.z), (_1999 * g_Lights_1._m0[_1627].m_vOrientation.y) + (_2002 * g_Lights_1._m0[_1627].m_vOrientation.z), (_1999 * g_Lights_1._m0[_1627].m_vOrientation.z) - (_2002 * g_Lights_1._m0[_1627].m_vOrientation.y)), _521)), 0.0, 1.0);
	                                    }
	                                    else
	                                    {
	                                        _523 = _1933;
	                                    }
	                                }
	                                else
	                                {
	                                    _523 = _522;
	                                }
	                                if (g_Lights_1._m0[_1627].m_nCookie == (-1))
	                                {
	                                    do
	                                    {
	                                        vec2 _2026 = abs(_1778.xyz.xy);
	                                        if (g_Lights_1._m0[_1627].m_vCookieParameters.z == 0.0)
	                                        {
	                                            _518 = smoothstep(1.0, g_Lights_1._m0[_1627].m_vCookieParameters.x, _2026.x) * smoothstep(1.0, g_Lights_1._m0[_1627].m_vCookieParameters.y, _2026.y);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _2031 = _2026.x;
	                                            float _2035 = _2026.y;
	                                            float _2042 = (-0.5) * g_Lights_1._m0[_1627].m_vCookieParameters.z;
	                                            float _2044 = (g_Lights_1._m0[_1627].m_vCookieParameters.x * g_Lights_1._m0[_1627].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_1627].m_vCookieParameters.y * _2031, 2.0 / g_Lights_1._m0[_1627].m_vCookieParameters.z) + pow(g_Lights_1._m0[_1627].m_vCookieParameters.x * _2035, 2.0 / g_Lights_1._m0[_1627].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2042);
	                                            float _2051 = pow(max(pow(_2031, 2.0 / g_Lights_1._m0[_1627].m_vCookieParameters.z) + pow(_2035, 2.0 / g_Lights_1._m0[_1627].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2042);
	                                            if (_2044 < _2051)
	                                            {
	                                                _518 = smoothstep(_2051, _2044, 1.0);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                if (_2051 > 1.0)
	                                                {
	                                                    _519 = 1.0;
	                                                }
	                                                else
	                                                {
	                                                    _519 = 0.0;
	                                                }
	                                                _518 = _519;
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _523 *= _518;
	                                }
	                                _529 = _526 * _523;
	                                break;
	                            } while(false);
	                            if (any(greaterThan(_529, vec3(0.0))))
	                            {
	                                _516 = false;
	                                do
	                                {
	                                    switch (g_Lights_1._m0[_1627].m_nLuminaireType)
	                                    {
	                                        case 0:
	                                        {
	                                            _534 = 1.0;
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1627].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _491 = vec4(normalize(g_Lights_1._m0[_1627].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2539 = g_Lights_1._m0[_1627].m_vLightPosition.xyz - _1578;
	                                                    float _2540 = length(_2539);
	                                                    _491 = vec4(_2539 / vec3(_2540), _2540);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _516 = true;
	                                            _517 = _491;
	                                            break;
	                                        }
	                                        case 1:
	                                        {
	                                            vec3 _2389 = g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].xyz;
	                                            vec3 _2391 = g_Lights_1._m0[_1627].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].xyz;
	                                            float _2392 = length(_2389);
	                                            float _2393 = length(_2391);
	                                            vec3 _2395 = _2389 / vec3(_2392);
	                                            vec3 _2397 = _2391 / vec3(_2393);
	                                            vec3 _2398 = cross(_2395, _2397);
	                                            vec3 _2399 = g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].xyz - _1578;
	                                            float _2400 = dot(_2399, _2398);
	                                            if (_2400 > 0.0)
	                                            {
	                                                _493 = _2400 * (-1.0);
	                                                _494 = _2398 * (-1.0);
	                                            }
	                                            else
	                                            {
	                                                _493 = _2400;
	                                                _494 = _2398;
	                                            }
	                                            float _2409 = dot(_2399, _2395);
	                                            float _2410 = dot(_2399, _2397);
	                                            float _2411 = _2409 + _2392;
	                                            float _2412 = _2410 + _2393;
	                                            vec3 _2415 = vec3(_2409, _2410, _493);
	                                            vec3 _2416 = vec3(_2409, _2412, _493);
	                                            vec3 _2417 = vec3(_2411, _2410, _493);
	                                            vec3 _2418 = vec3(_2411, _2412, _493);
	                                            vec3 _2420 = normalize(cross(_2415, _2417));
	                                            vec3 _2422 = normalize(cross(_2417, _2418));
	                                            vec3 _2424 = normalize(cross(_2418, _2416));
	                                            vec3 _2426 = normalize(cross(_2416, _2415));
	                                            float _2443 = _2420.z;
	                                            float _2447 = (6.283185482025146484375 - acos(clamp(-dot(_2424, _2426), -1.0, 1.0))) - acos(clamp(-dot(_2426, _2420), -1.0, 1.0));
	                                            float _2449 = (acos(clamp(-dot(_2420, _2422), -1.0, 1.0)) + acos(clamp(-dot(_2422, _2424), -1.0, 1.0))) - _2447;
	                                            if (isnan(_2449))
	                                            {
	                                                _495 = 0.0;
	                                            }
	                                            else
	                                            {
	                                                _495 = _2449;
	                                            }
	                                            float _2457 = (_1565.x * _495) + _2447;
	                                            float _2462 = ((cos(_2457) * _2443) - _2424.z) / sin(_2457);
	                                            if (_2462 > 0.0)
	                                            {
	                                                _496 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _496 = -1.0;
	                                            }
	                                            float _2471 = _496;
	                                            float _2473 = clamp((1.0 / sqrt((_2462 * _2462) + (_2443 * _2443))) * _2471, -1.0, 1.0);
	                                            float _2481 = clamp((-(_2473 * _493)) / sqrt(1.0 - (_2473 * _2473)), _2409, _2411);
	                                            float _2484 = sqrt((_2481 * _2481) + (_493 * _493));
	                                            float _2485 = _2484 * _2484;
	                                            float _2488 = _2410 / sqrt(_2485 + (_2410 * _2410));
	                                            float _2495 = _2488 + (_1565.y * ((_2412 / sqrt(_2485 + (_2412 * _2412))) - _2488));
	                                            float _2496 = _2495 * _2495;
	                                            if (_2496 < 0.99999988079071044921875)
	                                            {
	                                                _496 = (_2495 * _2484) / sqrt(1.0 - _2496);
	                                            }
	                                            else
	                                            {
	                                                _496 = _2412;
	                                            }
	                                            vec3 _2513 = ((_1578 + (_2395 * _2481)) + (_2397 * _496)) + (_494 * _493);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1627].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _492 = vec4(normalize(_2513), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2521 = _2513 - _1578;
	                                                    float _2522 = length(_2521);
	                                                    _492 = vec4(_2521 / vec3(_2522), _2522);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _534 = 1.0 / _495;
	                                            _516 = true;
	                                            _517 = _492;
	                                            break;
	                                        }
	                                        case 2:
	                                        {
	                                            do
	                                            {
	                                                vec2 _2317 = (_1565 * 2.0) - vec2(1.0);
	                                                if (all(equal(_2317, vec2(0.0))))
	                                                {
	                                                    _500 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _2322 = _2317.x;
	                                                float _2324 = _2317.y;
	                                                if (abs(_2322) > abs(_2324))
	                                                {
	                                                    _501 = _2322;
	                                                    _502 = 0.785398185253143310546875 * (_2324 / _2322);
	                                                }
	                                                else
	                                                {
	                                                    _501 = _2324;
	                                                    _502 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2322 / _2324));
	                                                }
	                                                _500 = vec2(cos(_502), sin(_502)) * _501;
	                                                break;
	                                            } while(false);
	                                            vec3 _2350 = (g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].xyz * _500.x)) + (g_Lights_1._m0[_1627].m_vLuminaireVectors.data[2].xyz * _500.y);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1627].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _499 = vec4(normalize(_2350), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2358 = _2350 - _1578;
	                                                    float _2359 = length(_2358);
	                                                    _499 = vec4(_2358 / vec3(_2359), _2359);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_499.w))
	                                            {
	                                                _497 = true;
	                                            }
	                                            else
	                                            {
	                                                _497 = isnan(_499.w);
	                                            }
	                                            if (!_497)
	                                            {
	                                                _498 = _499.w * _499.w;
	                                            }
	                                            else
	                                            {
	                                                _498 = 1.0;
	                                            }
	                                            _534 = _498 / (max(0.0, dot(g_Lights_1._m0[_1627].m_vLuminaireVectors.data[3].xyz, -_499.xyz)) * g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].w);
	                                            _516 = true;
	                                            _517 = _499;
	                                            break;
	                                        }
	                                        case 3:
	                                        {
	                                            vec3 _2216 = g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].xyz - _1578;
	                                            float _2217 = dot(_2216, _2216);
	                                            float _2218 = sqrt(_2217);
	                                            vec3 _2220 = _2216 / vec3(_2218);
	                                            float _2221 = _2220.z;
	                                            if (_2221 >= 0.0)
	                                            {
	                                                _504 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _504 = -1.0;
	                                            }
	                                            float _2228 = (-1.0) / (_504 + _2221);
	                                            float _2229 = _2220.x;
	                                            float _2230 = _2220.y;
	                                            float _2232 = (_2229 * _2230) * _2228;
	                                            vec3 _2237 = _505;
	                                            _2237.x = 1.0 + (((_504 * _2229) * _2229) * _2228);
	                                            _2237.y = _504 * _2232;
	                                            _2237.z = (-_504) * _2229;
	                                            _505 = _2237;
	                                            vec3 _2244 = _506;
	                                            _2244.x = _2232;
	                                            _2244.y = _504 + ((_2230 * _2230) * _2228);
	                                            _2244.z = -_2230;
	                                            _506 = _2244;
	                                            float _2252 = g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].x;
	                                            float _2256 = sqrt(max(0.0, 1.0 - (_2252 / _2217)));
	                                            float _2257 = _1565.x;
	                                            float _2260 = (1.0 - _2257) + (_2257 * _2256);
	                                            float _2264 = sqrt(max(0.0, 1.0 - (_2260 * _2260)));
	                                            float _2266 = _1565.y * 6.283185482025146484375;
	                                            float _2268 = _2218 * _2218;
	                                            float _2274 = (_2218 * _2260) - sqrt(max(0.0, _2252 - ((_2268 * _2264) * _2264)));
	                                            float _2280 = ((_2268 + _2252) - (_2274 * _2274)) / ((2.0 * _2218) * g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].x);
	                                            float _2284 = sqrt(max(0.0, 1.0 - (_2280 * _2280)));
	                                            vec3 _2296 = g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].xyz + ((mat3(-_2237, -_2244, -_2220) * vec3(cos(_2266) * _2284, sin(_2266) * _2284, _2280)) * g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].x);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1627].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _503 = vec4(normalize(_2296), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2304 = _2296 - _1578;
	                                                    float _2305 = length(_2304);
	                                                    _503 = vec4(_2304 / vec3(_2305), _2305);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _534 = 0.15915493667125701904296875 / (1.0 - _2256);
	                                            _516 = true;
	                                            _517 = _503;
	                                            break;
	                                        }
	                                        case 4:
	                                        case 5:
	                                        {
	                                            vec2 _513 = _1565;
	                                            if (_1565.x < g_Lights_1._m0[_1627].m_vLuminaireVectors.data[4].y)
	                                            {
	                                                vec2 _2117 = _513;
	                                                _2117.x = clamp(_2117.x / g_Lights_1._m0[_1627].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                                _513 = _2117;
	                                                vec3 _2123 = normalize(g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].xyz);
	                                                if (_2117.x >= 0.5)
	                                                {
	                                                    vec2 _2134 = _513;
	                                                    _2134.x = clamp((2.0 * _2134.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                    _513 = _2134;
	                                                    _514 = -_2123;
	                                                    _515 = g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].xyz;
	                                                }
	                                                else
	                                                {
	                                                    vec2 _2129 = _513;
	                                                    _2129.x = clamp(2.0 * _2129.x, 0.0, 0.99999988079071044921875);
	                                                    _513 = _2129;
	                                                    _514 = _2123;
	                                                    _515 = g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].xyz;
	                                                }
	                                                do
	                                                {
	                                                    vec2 _2145 = (_513 * 2.0) - vec2(1.0);
	                                                    if (all(equal(_2145, vec2(0.0))))
	                                                    {
	                                                        _510 = vec2(0.0);
	                                                        break;
	                                                    }
	                                                    float _2150 = _2145.x;
	                                                    float _2152 = _2145.y;
	                                                    if (abs(_2150) > abs(_2152))
	                                                    {
	                                                        _511 = _2150;
	                                                        _512 = 0.785398185253143310546875 * (_2152 / _2150);
	                                                    }
	                                                    else
	                                                    {
	                                                        _511 = _2152;
	                                                        _512 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2150 / _2152));
	                                                    }
	                                                    _510 = vec2(cos(_512), sin(_512)) * _511;
	                                                    break;
	                                                } while(false);
	                                                _515 += ((g_Lights_1._m0[_1627].m_vLuminaireVectors.data[2].xyz * _510.x) + (g_Lights_1._m0[_1627].m_vLuminaireVectors.data[3].xyz * _510.y));
	                                            }
	                                            else
	                                            {
	                                                vec2 _2096 = _513;
	                                                _2096.x = clamp((_2096.x - g_Lights_1._m0[_1627].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_1627].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                                _513 = _2096;
	                                                vec3 _2111 = (g_Lights_1._m0[_1627].m_vLuminaireVectors.data[2].xyz * cos(_2096.x * 6.283185482025146484375)) + (g_Lights_1._m0[_1627].m_vLuminaireVectors.data[3].xyz * sin(_2096.x * 6.283185482025146484375));
	                                                _514 = normalize(_2111);
	                                                _515 = mix(g_Lights_1._m0[_1627].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].xyz, vec3(_2096.y)) + _2111;
	                                            }
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1627].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _509 = vec4(normalize(_515), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2185 = _515 - _1578;
	                                                    float _2186 = length(_2185);
	                                                    _509 = vec4(_2185 / vec3(_2186), _2186);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_509.w))
	                                            {
	                                                _507 = true;
	                                            }
	                                            else
	                                            {
	                                                _507 = isnan(_509.w);
	                                            }
	                                            if (!_507)
	                                            {
	                                                _508 = _509.w * _509.w;
	                                            }
	                                            else
	                                            {
	                                                _508 = 1.0;
	                                            }
	                                            _534 = _508 / (max(0.0, dot(_514, -_509.xyz)) * g_Lights_1._m0[_1627].m_vLuminaireVectors.data[1].w);
	                                            _516 = true;
	                                            _517 = _509;
	                                            break;
	                                        }
	                                        default:
	                                        {
	                                            _534 = 0.0;
	                                            _516 = true;
	                                            _517 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                            break;
	                                        }
	                                    }
	                                    if (_516)
	                                    {
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                bool _2556 = !(dot(_352, _517.xyz) > 0.0);
	                                vec3 _2557 = vec3(_282);
	                                vec3 _2560 = transpose(mat3(_315, _314, _2557)) * _517.xyz;
	                                do
	                                {
	                                    if (_2556)
	                                    {
	                                        if ((_276 & 65535u) == 1u)
	                                        {
	                                            _486 = any(greaterThan(vec3(_275.xyz), vec3(0.0)));
	                                        }
	                                        else
	                                        {
	                                            _486 = false;
	                                        }
	                                        if (_486)
	                                        {
	                                            _490 = vec3(_275.xyz);
	                                        }
	                                        else
	                                        {
	                                            _490 = vec3(1.0);
	                                        }
	                                        _489 = _490 * 0.3183098733425140380859375;
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _2569 = vec3(mix(f16vec3(_277), _280, f16vec3(_281)));
	                                        float _2570 = float(_279);
	                                        do
	                                        {
	                                            float _2573 = _2560.z;
	                                            vec3 _2575 = _2560 + _311;
	                                            if (_2573 <= 0.0)
	                                            {
	                                                _488 = true;
	                                            }
	                                            else
	                                            {
	                                                _488 = _311.z <= 0.0;
	                                            }
	                                            if (_488)
	                                            {
	                                                _487 = vec3(0.0);
	                                                break;
	                                            }
	                                            if (all(equal(_2575, vec3(0.0))))
	                                            {
	                                                _487 = vec3(0.0);
	                                                break;
	                                            }
	                                            vec3 _2588 = normalize(_2575);
	                                            float _2589 = _2588.z;
	                                            float _2597 = _2570 * _2570;
	                                            float _2598 = _2597 * _2597;
	                                            float _2602 = (((_2589 * _2598) - _2589) * _2589) + 1.0;
	                                            float _2606 = _2570 * _2570;
	                                            float _2607 = _2606 * _2606;
	                                            _487 = (_2569 + ((vec3(1.0) - _2569) * pow(max(0.0, 1.0 - dot(_2560, _2588)), 5.0))) * (((_2598 / max(9.9999999392252902907785028219223e-09, _2602 * _2602)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_2573 * sqrt(((_311.z - (_2607 * _311.z)) * _311.z) + _2607)) + (_311.z * sqrt(((_2573 - (_2607 * _2573)) * _2573) + _2607))))) * 0.3183098733425140380859375);
	                                            break;
	                                        } while(false);
	                                        _489 = ((vec3(_280) * (1.0 - float(_281))) * 0.3183098733425140380859375) + _487;
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                float _2653 = dot(_2557, _517.xyz);
	                                if (_2556)
	                                {
	                                    _485 = -_2653;
	                                }
	                                else
	                                {
	                                    _485 = _2653;
	                                }
	                                _533 += (((_529 / vec3(_534)) * (_489 * 3.1415927410125732421875)) * max(0.0, _485));
	                            }
	                            _532 = _1629;
	                            break;
	                        } while(false);
	                        if (_1616_ladder_break)
	                        {
	                            break;
	                        }
	                        continue;
	                    }
	                    _530++;
	                    _531 = _533;
	                    continue;
	                }
	                if (_538)
	                {
	                    vec2 _476 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_646.xy, int(1u + (_647 + uint(_558))))))).xy;
	                    vec3 _2676 = (_354 + _353) * 0.5;
	                    float _477 = 0.0;
	                    vec3 _389 = vec3(0.0);
	                    vec3 _388 = vec3(0.0);
	                    vec4 _387 = vec4(0.0);
	                    int _390 = -1;
	                    uvec3 _2681 = min(uvec3(max(fma(_2676, _671, _673), vec3(0.0))), (_668 - uvec3(1u)));
	                    float _478 = 0.0;
	                    uint _479 = 0u;
	                    for (;;)
	                    {
	                        if (!(_479 < _667))
	                        {
	                            break;
	                        }
	                        uint _2694 = _667 * _668.x;
	                        float _481 = _478;
	                        uint _482 = subgroupOr(g_LightBins_1._m0[((((_2694 * _668.y) * _2681.z) + (_2694 * _2681.y)) + (_667 * _2681.x)) + _479]);
	                        for (;;)
	                        {
	                            bool _2714_ladder_break = false;
	                            do
	                            {
	                                if (!(_482 != 0u))
	                                {
	                                    _2714_ladder_break = true;
	                                    break;
	                                }
	                                uint _2721 = _482;
	                                uint _2725 = uint(findLSB(_2721)) + (_479 * 32u);
	                                uint _2727 = _2721 & (_2721 - 1u);
	                                mat4 _2757 = mat4(vec4(g_Lights_1._m0[_2725].m_mToClipSpace.data[0].x, g_Lights_1._m0[_2725].m_mToClipSpace.data[1].x, g_Lights_1._m0[_2725].m_mToClipSpace.data[2].x, g_Lights_1._m0[_2725].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_2725].m_mToClipSpace.data[0].y, g_Lights_1._m0[_2725].m_mToClipSpace.data[1].y, g_Lights_1._m0[_2725].m_mToClipSpace.data[2].y, g_Lights_1._m0[_2725].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_2725].m_mToClipSpace.data[0].z, g_Lights_1._m0[_2725].m_mToClipSpace.data[1].z, g_Lights_1._m0[_2725].m_mToClipSpace.data[2].z, g_Lights_1._m0[_2725].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_2725].m_mToClipSpace.data[0].w, g_Lights_1._m0[_2725].m_mToClipSpace.data[1].w, g_Lights_1._m0[_2725].m_mToClipSpace.data[2].w, g_Lights_1._m0[_2725].m_mToClipSpace.data[3].w));
	                                if ((uint(g_Lights_1._m0[_2725].m_nPathTraceFlags) & 1u) == 0u)
	                                {
	                                    _482 = _2727;
	                                    break;
	                                }
	                                if (!((g_Lights_1._m0[_2725].m_nPathTraceFlags & 8) != 0))
	                                {
	                                    _482 = _2727;
	                                    break;
	                                }
	                                do
	                                {
	                                    do
	                                    {
	                                        vec4 _2833 = _2757 * vec4(_2676.xyz, 1.0);
	                                        vec3 _2837 = _2833.xyz / vec3(_2833.w);
	                                        vec4 _2839;
	                                        _2839.x = _2837.x;
	                                        _2839.y = _2837.y;
	                                        _2839.z = _2837.z;
	                                        if (all(greaterThanEqual(_2839.xyz, vec3(-1.0, -1.0, 0.0))))
	                                        {
	                                            _473 = all(lessThanEqual(_2839.xyz, vec3(1.0)));
	                                        }
	                                        else
	                                        {
	                                            _473 = false;
	                                        }
	                                        if (!_473)
	                                        {
	                                            _474 = false;
	                                            break;
	                                        }
	                                        if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_2725].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_2676, 1.0)).xyz), vec3(1.0))))
	                                        {
	                                            _474 = false;
	                                            break;
	                                        }
	                                        _474 = true;
	                                        break;
	                                    } while(false);
	                                    if (!_474)
	                                    {
	                                        _475 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec4 _2871 = _2757 * vec4(_2676.xyz, 1.0);
	                                    vec3 _2875 = _2871.xyz / vec3(_2871.w);
	                                    vec4 _2877;
	                                    _2877.x = _2875.x;
	                                    _2877.y = _2875.y;
	                                    _2877.z = _2875.z;
	                                    if (_1531)
	                                    {
	                                        _472 = g_Lights_1._m0[_2725].m_vBounceColor.xyz;
	                                    }
	                                    else
	                                    {
	                                        _472 = g_Lights_1._m0[_2725].m_vColor.xyz;
	                                    }
	                                    if (true)
	                                    {
	                                        if (g_Lights_1._m0[_2725].m_nCookie >= 0)
	                                        {
	                                            if (g_Lights_1._m0[_2725].m_bSphericalCookie != 0)
	                                            {
	                                                vec4 _2920 = vec4(-g_Lights_1._m0[_2725].m_vOrientation.xyz, g_Lights_1._m0[_2725].m_vOrientation.w);
	                                                vec4 _2922 = _2920.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                                vec3 _2925 = _2922.xyz;
	                                                vec3 _2926 = vec4((-normalize(g_Lights_1._m0[_2725].m_vLightPosition.xyz - _2676)).xyz, 0.0).xyz;
	                                                vec4 _2933 = vec4((_2926 * _2922.w) + cross(_2926, _2925), -dot(_2926, _2925));
	                                                vec3 _2934 = _2933.xyz;
	                                                float _2935 = _2920.w;
	                                                vec3 _2937 = _2920.xyz;
	                                                float _2938 = _2933.w;
	                                                vec3 _2946 = vec4(((_2934 * _2935) + (_2937 * _2938)) + cross(_2937, _2934), _265).xyz;
	                                                vec2 _2955 = vec2(atan(_2946.y, -_2946.x) * 0.15915493667125701904296875, acos(_2946.z) * 0.3183098733425140380859375);
	                                                vec2 _2960 = (_2955.xy * g_Lights_1._m0[_2725].m_vCookieParameters.zw) + g_Lights_1._m0[_2725].m_vCookieParameters.xy;
	                                                vec2 _2962 = _2955;
	                                                _2962.x = _2960.x;
	                                                _2962.y = _2960.y;
	                                                _471 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_2725].m_nCookie], g_Sampler), _2962, 0.0).xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _2899 = fma(_2877.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                                vec2 _2904 = (_2899.xy * g_Lights_1._m0[_2725].m_vCookieParameters.zw) + g_Lights_1._m0[_2725].m_vCookieParameters.xy;
	                                                vec2 _2906 = _2899;
	                                                _2906.x = _2904.x;
	                                                _2906.y = _2904.y;
	                                                _471 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_2725].m_nCookie], g_CookieSampler), _2906, 0.0).xyz;
	                                            }
	                                        }
	                                        else
	                                        {
	                                            _471 = vec3(1.0);
	                                        }
	                                        _472 *= _471;
	                                    }
	                                    if (g_Lights_1._m0[_2725].m_nLuminaireType != 0)
	                                    {
	                                        _472 = (_472 * g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                    }
	                                    else
	                                    {
	                                        if (!(g_Lights_1._m0[_2725].m_vLightPosition.w == 0.0))
	                                        {
	                                            vec3 _2982 = g_Lights_1._m0[_2725].m_vLightPosition.xyz - _2676;
	                                            _472 *= (vec3(g_Lights_1._m0[_2725].m_vLightPosition.w) / max(vec3(dot(_2982, _2982)), vec3(g_Lights_1._m0[_2725].m_vLightPosition.w)));
	                                        }
	                                    }
	                                    if (g_Lights_1._m0[_2725].m_vDistanceFade_vSkirt.z > 0.0)
	                                    {
	                                        _468 = smoothstep(0.0, 1.0, _2877.xyz.z * g_Lights_1._m0[_2725].m_vDistanceFade_vSkirt.z);
	                                    }
	                                    else
	                                    {
	                                        _468 = 1.0;
	                                    }
	                                    if (g_Lights_1._m0[_2725].m_vDistanceFade_vSkirt.w > 0.0)
	                                    {
	                                        _468 *= smoothstep(0.0, 1.0, (1.0 - _2877.xyz.z) * g_Lights_1._m0[_2725].m_vDistanceFade_vSkirt.w);
	                                    }
	                                    if (!(g_Lights_1._m0[_2725].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _3023 = g_Lights_1._m0[_2725].m_vLightPosition.xyz - _2676;
	                                        float _3024 = length(_3023);
	                                        vec3 _3026 = _3023 / vec3(_3024);
	                                        float _3032 = _468 * smoothstep(0.0, 1.0, g_Lights_1._m0[_2725].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_2725].m_vDistanceFade_vSkirt.y * _3024));
	                                        if (g_Lights_1._m0[_2725].m_nLuminaireType != 2)
	                                        {
	                                            _470 = g_Lights_1._m0[_2725].m_nLuminaireType != 1;
	                                        }
	                                        else
	                                        {
	                                            _470 = false;
	                                        }
	                                        if (_470)
	                                        {
	                                            float _3044 = 2.0 * g_Lights_1._m0[_2725].m_vOrientation.x;
	                                            float _3048 = 2.0 * g_Lights_1._m0[_2725].m_vOrientation.w;
	                                            vec3 _3062 = vec3((_3044 * g_Lights_1._m0[_2725].m_vOrientation.y) - (_3048 * g_Lights_1._m0[_2725].m_vOrientation.z), (1.0 - (_3044 * g_Lights_1._m0[_2725].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_2725].m_vOrientation.z) * g_Lights_1._m0[_2725].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_2725].m_vOrientation.y) * g_Lights_1._m0[_2725].m_vOrientation.z) + (_3048 * g_Lights_1._m0[_2725].m_vOrientation.x)) * g_Lights_1._m0[_2725].m_vAngleFade.z;
	                                            vec3 _3063 = _3026 - _3062;
	                                            vec3 _3064 = _3026 + _3062;
	                                            do
	                                            {
	                                                vec3 _3067 = _3064 - _3063;
	                                                float _3069 = dot(-_3063, _3067);
	                                                if (_3069 <= 0.0)
	                                                {
	                                                    _466 = _3063;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    float _3074 = dot(_3067, _3067);
	                                                    if (_3069 > _3074)
	                                                    {
	                                                        _466 = _3064;
	                                                        break;
	                                                    }
	                                                    else
	                                                    {
	                                                        _466 = _3063 + (_3067 * (_3069 / _3074));
	                                                        break;
	                                                    }
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (any(notEqual(_466, vec3(0.0))))
	                                            {
	                                                _467 = normalize(_466);
	                                            }
	                                            else
	                                            {
	                                                _467 = _466;
	                                            }
	                                            float _3098 = 2.0 * g_Lights_1._m0[_2725].m_vOrientation.x;
	                                            float _3101 = 2.0 * g_Lights_1._m0[_2725].m_vOrientation.w;
	                                            _469 = _3032 * clamp(g_Lights_1._m0[_2725].m_vAngleFade.x + (g_Lights_1._m0[_2725].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_2725].m_vOrientation.y) * g_Lights_1._m0[_2725].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_2725].m_vOrientation.z) * g_Lights_1._m0[_2725].m_vOrientation.z), (_3098 * g_Lights_1._m0[_2725].m_vOrientation.y) + (_3101 * g_Lights_1._m0[_2725].m_vOrientation.z), (_3098 * g_Lights_1._m0[_2725].m_vOrientation.z) - (_3101 * g_Lights_1._m0[_2725].m_vOrientation.y)), _467)), 0.0, 1.0);
	                                        }
	                                        else
	                                        {
	                                            _469 = _3032;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _469 = _468;
	                                    }
	                                    if (g_Lights_1._m0[_2725].m_nCookie == (-1))
	                                    {
	                                        do
	                                        {
	                                            vec2 _3125 = abs(_2877.xyz.xy);
	                                            if (g_Lights_1._m0[_2725].m_vCookieParameters.z == 0.0)
	                                            {
	                                                _464 = smoothstep(1.0, g_Lights_1._m0[_2725].m_vCookieParameters.x, _3125.x) * smoothstep(1.0, g_Lights_1._m0[_2725].m_vCookieParameters.y, _3125.y);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _3130 = _3125.x;
	                                                float _3134 = _3125.y;
	                                                float _3141 = (-0.5) * g_Lights_1._m0[_2725].m_vCookieParameters.z;
	                                                float _3143 = (g_Lights_1._m0[_2725].m_vCookieParameters.x * g_Lights_1._m0[_2725].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_2725].m_vCookieParameters.y * _3130, 2.0 / g_Lights_1._m0[_2725].m_vCookieParameters.z) + pow(g_Lights_1._m0[_2725].m_vCookieParameters.x * _3134, 2.0 / g_Lights_1._m0[_2725].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3141);
	                                                float _3150 = pow(max(pow(_3130, 2.0 / g_Lights_1._m0[_2725].m_vCookieParameters.z) + pow(_3134, 2.0 / g_Lights_1._m0[_2725].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3141);
	                                                if (_3143 < _3150)
	                                                {
	                                                    _464 = smoothstep(_3150, _3143, 1.0);
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    if (_3150 > 1.0)
	                                                    {
	                                                        _465 = 1.0;
	                                                    }
	                                                    else
	                                                    {
	                                                        _465 = 0.0;
	                                                    }
	                                                    _464 = _465;
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _469 *= _464;
	                                    }
	                                    _475 = _472 * _469;
	                                    break;
	                                } while(false);
	                                float _3173 = dot(_475.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                if (_3173 == 0.0)
	                                {
	                                    _482 = _2727;
	                                    break;
	                                }
	                                _462 = false;
	                                do
	                                {
	                                    switch (g_Lights_1._m0[_2725].m_nLuminaireType)
	                                    {
	                                        case 0:
	                                        {
	                                            _483 = 1.0;
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2725].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _437 = vec4(normalize(g_Lights_1._m0[_2725].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3639 = g_Lights_1._m0[_2725].m_vLightPosition.xyz - _2676;
	                                                    float _3640 = length(_3639);
	                                                    _437 = vec4(_3639 / vec3(_3640), _3640);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _462 = true;
	                                            _463 = _437;
	                                            break;
	                                        }
	                                        case 1:
	                                        {
	                                            vec3 _3489 = g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].xyz;
	                                            vec3 _3491 = g_Lights_1._m0[_2725].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].xyz;
	                                            float _3492 = length(_3489);
	                                            float _3493 = length(_3491);
	                                            vec3 _3495 = _3489 / vec3(_3492);
	                                            vec3 _3497 = _3491 / vec3(_3493);
	                                            vec3 _3498 = cross(_3495, _3497);
	                                            vec3 _3499 = g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].xyz - _2676;
	                                            float _3500 = dot(_3499, _3498);
	                                            if (_3500 > 0.0)
	                                            {
	                                                _439 = _3500 * (-1.0);
	                                                _440 = _3498 * (-1.0);
	                                            }
	                                            else
	                                            {
	                                                _439 = _3500;
	                                                _440 = _3498;
	                                            }
	                                            float _3509 = dot(_3499, _3495);
	                                            float _3510 = dot(_3499, _3497);
	                                            float _3511 = _3509 + _3492;
	                                            float _3512 = _3510 + _3493;
	                                            vec3 _3515 = vec3(_3509, _3510, _439);
	                                            vec3 _3516 = vec3(_3509, _3512, _439);
	                                            vec3 _3517 = vec3(_3511, _3510, _439);
	                                            vec3 _3518 = vec3(_3511, _3512, _439);
	                                            vec3 _3520 = normalize(cross(_3515, _3517));
	                                            vec3 _3522 = normalize(cross(_3517, _3518));
	                                            vec3 _3524 = normalize(cross(_3518, _3516));
	                                            vec3 _3526 = normalize(cross(_3516, _3515));
	                                            float _3543 = _3520.z;
	                                            float _3547 = (6.283185482025146484375 - acos(clamp(-dot(_3524, _3526), -1.0, 1.0))) - acos(clamp(-dot(_3526, _3520), -1.0, 1.0));
	                                            float _3549 = (acos(clamp(-dot(_3520, _3522), -1.0, 1.0)) + acos(clamp(-dot(_3522, _3524), -1.0, 1.0))) - _3547;
	                                            if (isnan(_3549))
	                                            {
	                                                _441 = 0.0;
	                                            }
	                                            else
	                                            {
	                                                _441 = _3549;
	                                            }
	                                            float _3557 = (_1565.x * _441) + _3547;
	                                            float _3562 = ((cos(_3557) * _3543) - _3524.z) / sin(_3557);
	                                            if (_3562 > 0.0)
	                                            {
	                                                _442 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _442 = -1.0;
	                                            }
	                                            float _3571 = _442;
	                                            float _3573 = clamp((1.0 / sqrt((_3562 * _3562) + (_3543 * _3543))) * _3571, -1.0, 1.0);
	                                            float _3581 = clamp((-(_3573 * _439)) / sqrt(1.0 - (_3573 * _3573)), _3509, _3511);
	                                            float _3584 = sqrt((_3581 * _3581) + (_439 * _439));
	                                            float _3585 = _3584 * _3584;
	                                            float _3588 = _3510 / sqrt(_3585 + (_3510 * _3510));
	                                            float _3595 = _3588 + (_1565.y * ((_3512 / sqrt(_3585 + (_3512 * _3512))) - _3588));
	                                            float _3596 = _3595 * _3595;
	                                            if (_3596 < 0.99999988079071044921875)
	                                            {
	                                                _442 = (_3595 * _3584) / sqrt(1.0 - _3596);
	                                            }
	                                            else
	                                            {
	                                                _442 = _3512;
	                                            }
	                                            vec3 _3613 = ((_2676 + (_3495 * _3581)) + (_3497 * _442)) + (_440 * _439);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2725].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _438 = vec4(normalize(_3613), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3621 = _3613 - _2676;
	                                                    float _3622 = length(_3621);
	                                                    _438 = vec4(_3621 / vec3(_3622), _3622);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _483 = 1.0 / _441;
	                                            _462 = true;
	                                            _463 = _438;
	                                            break;
	                                        }
	                                        case 2:
	                                        {
	                                            do
	                                            {
	                                                vec2 _3417 = (_1565 * 2.0) - vec2(1.0);
	                                                if (all(equal(_3417, vec2(0.0))))
	                                                {
	                                                    _446 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _3422 = _3417.x;
	                                                float _3424 = _3417.y;
	                                                if (abs(_3422) > abs(_3424))
	                                                {
	                                                    _447 = _3422;
	                                                    _448 = 0.785398185253143310546875 * (_3424 / _3422);
	                                                }
	                                                else
	                                                {
	                                                    _447 = _3424;
	                                                    _448 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3422 / _3424));
	                                                }
	                                                _446 = vec2(cos(_448), sin(_448)) * _447;
	                                                break;
	                                            } while(false);
	                                            vec3 _3450 = (g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].xyz * _446.x)) + (g_Lights_1._m0[_2725].m_vLuminaireVectors.data[2].xyz * _446.y);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2725].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _445 = vec4(normalize(_3450), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3458 = _3450 - _2676;
	                                                    float _3459 = length(_3458);
	                                                    _445 = vec4(_3458 / vec3(_3459), _3459);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_445.w))
	                                            {
	                                                _443 = true;
	                                            }
	                                            else
	                                            {
	                                                _443 = isnan(_445.w);
	                                            }
	                                            if (!_443)
	                                            {
	                                                _444 = _445.w * _445.w;
	                                            }
	                                            else
	                                            {
	                                                _444 = 1.0;
	                                            }
	                                            _483 = _444 / (max(0.0, dot(g_Lights_1._m0[_2725].m_vLuminaireVectors.data[3].xyz, -_445.xyz)) * g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].w);
	                                            _462 = true;
	                                            _463 = _445;
	                                            break;
	                                        }
	                                        case 3:
	                                        {
	                                            vec3 _3316 = g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].xyz - _2676;
	                                            float _3317 = dot(_3316, _3316);
	                                            float _3318 = sqrt(_3317);
	                                            vec3 _3320 = _3316 / vec3(_3318);
	                                            float _3321 = _3320.z;
	                                            if (_3321 >= 0.0)
	                                            {
	                                                _450 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _450 = -1.0;
	                                            }
	                                            float _3328 = (-1.0) / (_450 + _3321);
	                                            float _3329 = _3320.x;
	                                            float _3330 = _3320.y;
	                                            float _3332 = (_3329 * _3330) * _3328;
	                                            vec3 _3337 = _451;
	                                            _3337.x = 1.0 + (((_450 * _3329) * _3329) * _3328);
	                                            _3337.y = _450 * _3332;
	                                            _3337.z = (-_450) * _3329;
	                                            _451 = _3337;
	                                            vec3 _3344 = _452;
	                                            _3344.x = _3332;
	                                            _3344.y = _450 + ((_3330 * _3330) * _3328);
	                                            _3344.z = -_3330;
	                                            _452 = _3344;
	                                            float _3352 = g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].x;
	                                            float _3356 = sqrt(max(0.0, 1.0 - (_3352 / _3317)));
	                                            float _3357 = _1565.x;
	                                            float _3360 = (1.0 - _3357) + (_3357 * _3356);
	                                            float _3364 = sqrt(max(0.0, 1.0 - (_3360 * _3360)));
	                                            float _3366 = _1565.y * 6.283185482025146484375;
	                                            float _3368 = _3318 * _3318;
	                                            float _3374 = (_3318 * _3360) - sqrt(max(0.0, _3352 - ((_3368 * _3364) * _3364)));
	                                            float _3380 = ((_3368 + _3352) - (_3374 * _3374)) / ((2.0 * _3318) * g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].x);
	                                            float _3384 = sqrt(max(0.0, 1.0 - (_3380 * _3380)));
	                                            vec3 _3396 = g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].xyz + ((mat3(-_3337, -_3344, -_3320) * vec3(cos(_3366) * _3384, sin(_3366) * _3384, _3380)) * g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].x);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2725].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _449 = vec4(normalize(_3396), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3404 = _3396 - _2676;
	                                                    float _3405 = length(_3404);
	                                                    _449 = vec4(_3404 / vec3(_3405), _3405);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _483 = 0.15915493667125701904296875 / (1.0 - _3356);
	                                            _462 = true;
	                                            _463 = _449;
	                                            break;
	                                        }
	                                        case 4:
	                                        case 5:
	                                        {
	                                            vec2 _459 = _1565;
	                                            if (_1565.x < g_Lights_1._m0[_2725].m_vLuminaireVectors.data[4].y)
	                                            {
	                                                vec2 _3217 = _459;
	                                                _3217.x = clamp(_3217.x / g_Lights_1._m0[_2725].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                                _459 = _3217;
	                                                vec3 _3223 = normalize(g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].xyz);
	                                                if (_3217.x >= 0.5)
	                                                {
	                                                    vec2 _3234 = _459;
	                                                    _3234.x = clamp((2.0 * _3234.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                    _459 = _3234;
	                                                    _460 = -_3223;
	                                                    _461 = g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].xyz;
	                                                }
	                                                else
	                                                {
	                                                    vec2 _3229 = _459;
	                                                    _3229.x = clamp(2.0 * _3229.x, 0.0, 0.99999988079071044921875);
	                                                    _459 = _3229;
	                                                    _460 = _3223;
	                                                    _461 = g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].xyz;
	                                                }
	                                                do
	                                                {
	                                                    vec2 _3245 = (_459 * 2.0) - vec2(1.0);
	                                                    if (all(equal(_3245, vec2(0.0))))
	                                                    {
	                                                        _456 = vec2(0.0);
	                                                        break;
	                                                    }
	                                                    float _3250 = _3245.x;
	                                                    float _3252 = _3245.y;
	                                                    if (abs(_3250) > abs(_3252))
	                                                    {
	                                                        _457 = _3250;
	                                                        _458 = 0.785398185253143310546875 * (_3252 / _3250);
	                                                    }
	                                                    else
	                                                    {
	                                                        _457 = _3252;
	                                                        _458 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3250 / _3252));
	                                                    }
	                                                    _456 = vec2(cos(_458), sin(_458)) * _457;
	                                                    break;
	                                                } while(false);
	                                                _461 += ((g_Lights_1._m0[_2725].m_vLuminaireVectors.data[2].xyz * _456.x) + (g_Lights_1._m0[_2725].m_vLuminaireVectors.data[3].xyz * _456.y));
	                                            }
	                                            else
	                                            {
	                                                vec2 _3196 = _459;
	                                                _3196.x = clamp((_3196.x - g_Lights_1._m0[_2725].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_2725].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                                _459 = _3196;
	                                                vec3 _3211 = (g_Lights_1._m0[_2725].m_vLuminaireVectors.data[2].xyz * cos(_3196.x * 6.283185482025146484375)) + (g_Lights_1._m0[_2725].m_vLuminaireVectors.data[3].xyz * sin(_3196.x * 6.283185482025146484375));
	                                                _460 = normalize(_3211);
	                                                _461 = mix(g_Lights_1._m0[_2725].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].xyz, vec3(_3196.y)) + _3211;
	                                            }
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2725].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _455 = vec4(normalize(_461), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3285 = _461 - _2676;
	                                                    float _3286 = length(_3285);
	                                                    _455 = vec4(_3285 / vec3(_3286), _3286);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_455.w))
	                                            {
	                                                _453 = true;
	                                            }
	                                            else
	                                            {
	                                                _453 = isnan(_455.w);
	                                            }
	                                            if (!_453)
	                                            {
	                                                _454 = _455.w * _455.w;
	                                            }
	                                            else
	                                            {
	                                                _454 = 1.0;
	                                            }
	                                            _483 = _454 / (max(0.0, dot(_460, -_455.xyz)) * g_Lights_1._m0[_2725].m_vLuminaireVectors.data[1].w);
	                                            _462 = true;
	                                            _463 = _455;
	                                            break;
	                                        }
	                                        default:
	                                        {
	                                            _483 = 0.0;
	                                            _462 = true;
	                                            _463 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                            break;
	                                        }
	                                    }
	                                    if (_462)
	                                    {
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                float _3658 = dot(vec3(_282), _463.xyz);
	                                if ((!(dot(_352, _463.xyz) > 0.0)) && _537)
	                                {
	                                    _436 = -_3658;
	                                }
	                                else
	                                {
	                                    _436 = _3658;
	                                }
	                                float _3665 = (_3173 / _483) * max(0.0, _436);
	                                float _484 = _476.x;
	                                do
	                                {
	                                    float _3670 = _477;
	                                    float _3671 = _3670 + _3665;
	                                    _477 = _3671;
	                                    if (_3671 == 0.0)
	                                    {
	                                        _435 = false;
	                                        break;
	                                    }
	                                    float _3676 = _3665 / _477;
	                                    do
	                                    {
	                                        if (_3676 <= 0.0)
	                                        {
	                                            _434 = false;
	                                            break;
	                                        }
	                                        if (_3676 >= 1.0)
	                                        {
	                                            _434 = true;
	                                            break;
	                                        }
	                                        if (_484 < _3676)
	                                        {
	                                            _484 = min(_484 / _3676, 0.99999988079071044921875);
	                                            _434 = true;
	                                            break;
	                                        }
	                                        _484 = min((_484 - _3676) / (1.0 - _3676), 0.99999988079071044921875);
	                                        _434 = false;
	                                        break;
	                                    } while(false);
	                                    _435 = _434;
	                                    break;
	                                } while(false);
	                                vec2 _3700 = _476;
	                                _3700.x = _484;
	                                _476 = _3700;
	                                if (_435)
	                                {
	                                    _390 = int(_2725);
	                                    _389 = _475 / vec3(_483);
	                                    _387 = _463;
	                                    _481 = _3665;
	                                }
	                                _482 = _2727;
	                                break;
	                            } while(false);
	                            if (_2714_ladder_break)
	                            {
	                                break;
	                            }
	                            continue;
	                        }
	                        _478 = _481;
	                        _479++;
	                        continue;
	                    }
	                    if (_390 != (-1))
	                    {
	                        vec3 _3721 = _389;
	                        vec3 _3722 = _3721 * (_477 / _478);
	                        _389 = _3722;
	                        bool _3729 = !(dot(_352, _387.xyz) > 0.0);
	                        vec3 _3731 = vec3(_282);
	                        vec3 _3734 = transpose(mat3(_315, _314, _3731)) * _387.xyz;
	                        do
	                        {
	                            if (_3729)
	                            {
	                                if ((_276 & 65535u) == 1u)
	                                {
	                                    _429 = any(greaterThan(vec3(_275.xyz), vec3(0.0)));
	                                }
	                                else
	                                {
	                                    _429 = false;
	                                }
	                                if (_429)
	                                {
	                                    _433 = vec3(_275.xyz);
	                                }
	                                else
	                                {
	                                    _433 = vec3(1.0);
	                                }
	                                _432 = _433 * 0.3183098733425140380859375;
	                                break;
	                            }
	                            else
	                            {
	                                vec3 _3743 = vec3(mix(f16vec3(_277), _280, f16vec3(_281)));
	                                float _3744 = float(_279);
	                                do
	                                {
	                                    float _3747 = _3734.z;
	                                    vec3 _3749 = _3734 + _311;
	                                    if (_3747 <= 0.0)
	                                    {
	                                        _431 = true;
	                                    }
	                                    else
	                                    {
	                                        _431 = _311.z <= 0.0;
	                                    }
	                                    if (_431)
	                                    {
	                                        _430 = vec3(0.0);
	                                        break;
	                                    }
	                                    if (all(equal(_3749, vec3(0.0))))
	                                    {
	                                        _430 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec3 _3762 = normalize(_3749);
	                                    float _3763 = _3762.z;
	                                    float _3771 = _3744 * _3744;
	                                    float _3772 = _3771 * _3771;
	                                    float _3776 = (((_3763 * _3772) - _3763) * _3763) + 1.0;
	                                    float _3780 = _3744 * _3744;
	                                    float _3781 = _3780 * _3780;
	                                    _430 = (_3743 + ((vec3(1.0) - _3743) * pow(max(0.0, 1.0 - dot(_3734, _3762)), 5.0))) * (((_3772 / max(9.9999999392252902907785028219223e-09, _3776 * _3776)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_3747 * sqrt(((_311.z - (_3781 * _311.z)) * _311.z) + _3781)) + (_311.z * sqrt(((_3747 - (_3781 * _3747)) * _3747) + _3781))))) * 0.3183098733425140380859375);
	                                    break;
	                                } while(false);
	                                _432 = ((vec3(_280) * (1.0 - float(_281))) * 0.3183098733425140380859375) + _430;
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        vec3 _3826 = _3722 * (_432 * 3.1415927410125732421875);
	                        _389 = _3826;
	                        float _3829 = dot(_3731, _387.xyz);
	                        if (_3729)
	                        {
	                            _428 = -_3829;
	                        }
	                        else
	                        {
	                            _428 = _3829;
	                        }
	                        _389 = _3826 * max(0.0, _428);
	                        if (_3729)
	                        {
	                            if ((_276 & 65535u) == 2u)
	                            {
	                                _427 = float(_275.x) > 0.0;
	                            }
	                            else
	                            {
	                                _427 = false;
	                            }
	                            _480 = _427;
	                        }
	                        else
	                        {
	                            _480 = false;
	                        }
	                        if (_480)
	                        {
	                            float _3862 = pow(clamp(-dot(normalize(_352 + _3731), _387.xyz), 0.0, 1.0), 2.0);
	                            f16vec3 _3863 = f16vec3(vec3(0.0));
	                            if (isinf(_387.w))
	                            {
	                                _423 = true;
	                            }
	                            else
	                            {
	                                _423 = isnan(_387.w);
	                            }
	                            if (!_423)
	                            {
	                                _424 = _387.w;
	                            }
	                            else
	                            {
	                                _424 = 1000.0;
	                            }
	                            vec3 _393 = _354 + (_387.xyz * _424);
	                            float _392 = 0.0;
	                            vec3 _391 = -_387.xyz;
	                            if (_3862 > 0.0)
	                            {
	                                _425 = _424;
	                            }
	                            else
	                            {
	                                _425 = 0.0;
	                            }
	                            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _394, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_3863, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _3863, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                            traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _393, _392, _391, _425, 0);
	                            if (p._m5 != (-1))
	                            {
	                                if ((p._m7._m6 & 65535u) == 2u)
	                                {
	                                    _422 = float(p._m7._m7.x) > 0.0;
	                                }
	                                else
	                                {
	                                    _422 = false;
	                                }
	                                if (!_422)
	                                {
	                                    _425 = 0.0;
	                                }
	                                else
	                                {
	                                    _425 = _3862;
	                                }
	                                _426 = _424 - p._m3;
	                            }
	                            else
	                            {
	                                _425 = _3862;
	                                _426 = _424;
	                            }
	                            uint _3920 = uint(int(uint(_275.w)));
	                            float _3924 = _426 * float(_275.x);
	                            _388 = (_3722 * vec3(_280)) * ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_3920].m_vTransmissiveLogColor.xyz * (1.0 + (_3924 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_3920].m_fTransmissiveSaturation))) * exp(-_3924)) * _425);
	                        }
	                    }
	                    vec4 _540 = _387;
	                    if (_390 != (-1))
	                    {
	                        bool _3955 = any(notEqual(_389, vec3(0.0)));
	                        if (isinf(_540.w))
	                        {
	                            _420 = true;
	                        }
	                        else
	                        {
	                            _420 = isnan(_540.w);
	                        }
	                        if (!_420)
	                        {
	                            _421 = _540.w;
	                        }
	                        else
	                        {
	                            _421 = 56755.83984375;
	                        }
	                        vec4 _3971 = _540;
	                        _3971.w = _421;
	                        _540 = _3971;
	                        do
	                        {
	                            float _3978 = dot(_3971.xyz, g_Lights_1._m0[_390].m_vNearPlane.xyz);
	                            if (_3978 == 0.0)
	                            {
	                                _419 = 0.0;
	                                break;
	                            }
	                            _419 = (g_Lights_1._m0[_390].m_vNearPlane.w - dot(_1530, g_Lights_1._m0[_390].m_vNearPlane.xyz)) * (1.0 / _3978);
	                            break;
	                        } while(false);
	                        if (_419 > 0.0)
	                        {
	                            vec4 _3990 = _540;
	                            _3990.w = min(_3990.w, _419);
	                            _540 = _3990;
	                        }
	                        if (dot(_540.xyz, _352.xyz) < 0.0)
	                        {
	                            _539 = _353;
	                        }
	                        else
	                        {
	                            _539 = _354;
	                        }
	                        vec4 _4002 = _540;
	                        vec3 _4004 = _539 - _1530;
	                        _4002.w = _4002.w + dot(_4002.xyz, _4004);
	                        vec3 _4014 = normalize((_4002.xyz * _4002.w) + _4004);
	                        vec4 _4016 = _4002;
	                        _4016.x = _4014.x;
	                        _4016.y = _4014.y;
	                        _4016.z = _4014.z;
	                        _540 = _4016;
	                        do
	                        {
	                            if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 1) != 0)
	                            {
	                                _418 = 32u;
	                                break;
	                            }
	                            if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 2) != 0)
	                            {
	                                _418 = 16u;
	                                break;
	                            }
	                            _418 = 0u;
	                            break;
	                        } while(false);
	                        vec3 _397 = _539;
	                        float _396 = 0.0;
	                        vec3 _395 = _4016.xyz;
	                        if (_3955)
	                        {
	                            _417 = _4016.w;
	                        }
	                        else
	                        {
	                            _417 = 0.0;
	                        }
	                        p_1 = PayloadShadow_t(1.0);
	                        traceRayEXT(g_AccelStruct, _418, 2u, 1u, 2u, 1u, _397, _396, _395, _417, 1);
	                        if (_3955)
	                        {
	                            _417 = p_1.m_flVisibility;
	                        }
	                        else
	                        {
	                            _417 = 0.0;
	                        }
	                        _539 = (_531 + _388) + (_389 * _417);
	                    }
	                    else
	                    {
	                        _539 = _531;
	                    }
	                }
	                else
	                {
	                    _539 = _531;
	                }
	                _360 = _354;
	                _359 = _353;
	                _358 = _352;
	                _357 = _351;
	                _289 = _282;
	                _288 = _281;
	                _287 = _280;
	                _286 = _279;
	                _285 = _277;
	                _284 = _276;
	                _283 = _275;
	                _320 = _315;
	                _319 = _314;
	                _318 = _313;
	                _317 = _312;
	                _316 = _311;
	                vec3 _4085 = vec3(_280);
	                float _4091 = min(0.89999997615814208984375, max(_4085.x, max(_4085.y, _4085.z)));
	                float _564 = _563.x;
	                do
	                {
	                    if (_4091 <= 0.0)
	                    {
	                        _416 = false;
	                        break;
	                    }
	                    if (_4091 >= 1.0)
	                    {
	                        _416 = true;
	                        break;
	                    }
	                    if (_564 < _4091)
	                    {
	                        _564 = min(_564 / _4091, 0.99999988079071044921875);
	                        _416 = true;
	                        break;
	                    }
	                    _564 = min((_564 - _4091) / (1.0 - _4091), 0.99999988079071044921875);
	                    _416 = false;
	                    break;
	                } while(false);
	                vec2 _4116 = _563;
	                _4116.x = _564;
	                _563 = _4116;
	                if (_416)
	                {
	                    do
	                    {
	                        _565 = 1.0;
	                        float _415 = _563.x;
	                        do
	                        {
	                            if (_317 <= 0.0)
	                            {
	                                _413 = false;
	                                break;
	                            }
	                            if (_317 >= 1.0)
	                            {
	                                _413 = true;
	                                break;
	                            }
	                            if (_415 < _317)
	                            {
	                                _415 = min(_415 / _317, 0.99999988079071044921875);
	                                _413 = true;
	                                break;
	                            }
	                            _415 = min((_415 - _317) / (1.0 - _317), 0.99999988079071044921875);
	                            _413 = false;
	                            break;
	                        } while(false);
	                        vec2 _4148 = _563;
	                        _4148.x = _415;
	                        _563 = _4148;
	                        if (_413)
	                        {
	                            _565 = _317;
	                            _414 = true;
	                            break;
	                        }
	                        else
	                        {
	                            _565 = 1.0 - _317;
	                            _414 = false;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    if (_414)
	                    {
	                        _360 = _359;
	                    }
	                    do
	                    {
	                        vec2 _411 = _563;
	                        if (_414)
	                        {
	                            float _4250 = sqrt(_411.y);
	                            float _4252 = 6.283185482025146484375 * _411.x;
	                            vec3 _4260 = vec3(cos(_4252) * _4250, sin(_4252) * _4250, sqrt(max(0.0, 1.0 - _411.y)));
	                            _4260.z = -_4260.z;
	                            _410 = _4260;
	                            break;
	                        }
	                        else
	                        {
	                            float _412 = _411.x;
	                            do
	                            {
	                                if (_318 <= 0.0)
	                                {
	                                    _409 = false;
	                                    break;
	                                }
	                                if (_318 >= 1.0)
	                                {
	                                    _409 = true;
	                                    break;
	                                }
	                                if (_412 < _318)
	                                {
	                                    _412 = min(_412 / _318, 0.99999988079071044921875);
	                                    _409 = true;
	                                    break;
	                                }
	                                _412 = min((_412 - _318) / (1.0 - _318), 0.99999988079071044921875);
	                                _409 = false;
	                                break;
	                            } while(false);
	                            vec2 _4199 = _411;
	                            _4199.x = _412;
	                            _411 = _4199;
	                            if (_409)
	                            {
	                                float _4203 = float(_286);
	                                float _4211 = ((_4203 * _4203) * sqrt(_411.x)) / sqrt(1.0 - _411.x);
	                                float _4214 = 1.0 / (1.0 + (_4211 * _4211));
	                                float _4217 = sqrt(max(0.0, 1.0 - _4214));
	                                float _4220 = 6.283185482025146484375 * _411.y;
	                                vec3 _4225 = vec3(cos(_4220) * _4217, sin(_4220) * _4217, sqrt(_4214));
	                                if (dot(_316, _4225) > 0.0)
	                                {
	                                    _408 = _4225;
	                                }
	                                else
	                                {
	                                    _408 = -_4225;
	                                }
	                                _410 = -reflect(_316, _408);
	                                break;
	                            }
	                            float _4237 = sqrt(_411.y);
	                            float _4239 = 6.283185482025146484375 * _411.x;
	                            _410 = vec3(cos(_4239) * _4237, sin(_4239) * _4237, sqrt(max(0.0, 1.0 - _411.y)));
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    _557 = _410;
	                    vec3 _4266 = normalize(_410 + _316);
	                    float _4267 = _4266.z;
	                    if (_414)
	                    {
	                        _406 = _410.z * (-0.3183098733425140380859375);
	                    }
	                    else
	                    {
	                        if (_318 > 0.0)
	                        {
	                            float _4278 = float(_286);
	                            float _4279 = _4278 * _4278;
	                            float _4280 = _4279 * _4279;
	                            float _4284 = (((_4267 * _4280) - _4267) * _4267) + 1.0;
	                            _405 = 1.0 - _318;
	                            _406 = _318 * (((_4280 / max(9.9999999392252902907785028219223e-09, _4284 * _4284)) * _4267) / (12.56637096405029296875 * max(0.0, dot(_316, _4266))));
	                        }
	                        else
	                        {
	                            _405 = 1.0;
	                            _406 = 0.0;
	                        }
	                        _406 += (_405 * (_410.z * 0.3183098733425140380859375));
	                    }
	                    if (_406 == 0.0)
	                    {
	                        _407 = true;
	                    }
	                    else
	                    {
	                        _407 = isnan(_406);
	                    }
	                    if (_407)
	                    {
	                        _405 = 3.4028234663852885981170418348452e+38;
	                    }
	                    else
	                    {
	                        _405 = _406;
	                    }
	                    float _566 = _405;
	                    do
	                    {
	                        if (_414)
	                        {
	                            if ((_284 & 65535u) == 1u)
	                            {
	                                _400 = any(greaterThan(vec3(_283.xyz), vec3(0.0)));
	                            }
	                            else
	                            {
	                                _400 = false;
	                            }
	                            if (_400)
	                            {
	                                _404 = vec3(_283.xyz);
	                            }
	                            else
	                            {
	                                _404 = vec3(1.0);
	                            }
	                            _403 = _404 * 0.3183098733425140380859375;
	                            break;
	                        }
	                        else
	                        {
	                            vec3 _4321 = vec3(mix(f16vec3(_285), _287, f16vec3(_288)));
	                            float _4322 = float(_286);
	                            do
	                            {
	                                vec3 _4327 = _557 + _316;
	                                if (_557.z <= 0.0)
	                                {
	                                    _402 = true;
	                                }
	                                else
	                                {
	                                    _402 = _316.z <= 0.0;
	                                }
	                                if (_402)
	                                {
	                                    _401 = vec3(0.0);
	                                    break;
	                                }
	                                if (all(equal(_4327, vec3(0.0))))
	                                {
	                                    _401 = vec3(0.0);
	                                    break;
	                                }
	                                vec3 _4340 = normalize(_4327);
	                                float _4341 = _4340.z;
	                                float _4349 = _4322 * _4322;
	                                float _4350 = _4349 * _4349;
	                                float _4354 = (((_4341 * _4350) - _4341) * _4341) + 1.0;
	                                float _4358 = _4322 * _4322;
	                                float _4359 = _4358 * _4358;
	                                _401 = (_4321 + ((vec3(1.0) - _4321) * pow(max(0.0, 1.0 - dot(_557, _4340)), 5.0))) * (((_4350 / max(9.9999999392252902907785028219223e-09, _4354 * _4354)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_557.z * sqrt(((_316.z - (_4359 * _316.z)) * _316.z) + _4359)) + (_316.z * sqrt(((_557.z - (_4359 * _557.z)) * _557.z) + _4359))))) * 0.3183098733425140380859375);
	                                break;
	                            } while(false);
	                            _403 = ((vec3(_287) * (1.0 - float(_288))) * 0.3183098733425140380859375) + _401;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _4403 = _557;
	                    vec3 _4406 = mat3(_320, _319, vec3(_289)) * _4403;
	                    _557 = _4406;
	                    float _4409 = dot(vec3(_289), _4406);
	                    if (_414)
	                    {
	                        _399 = -_4409;
	                    }
	                    else
	                    {
	                        _399 = _4409;
	                    }
	                    do
	                    {
	                        if ((_357 & 1024) != 0)
	                        {
	                            _398 = true;
	                            break;
	                        }
	                        _398 = (dot(_358, _557) > 0.0) != _414;
	                        break;
	                    } while(false);
	                    if (_398)
	                    {
	                        _567 = (_561 * (_403 * max(0.0, _399))) / vec3((_4091 * _565) * _566);
	                    }
	                    else
	                    {
	                        _567 = vec3(0.0);
	                    }
	                    _559 = _567;
	                }
	                else
	                {
	                    _559 = vec3(0.0);
	                }
	                _558++;
	                _560 = (_560 + ((_539 * _561) * _562)) + ((vec3(_278) * _561) * _562);
	                continue;
	            }
	            vIrradiance = (_560 * max(0.0, dot(_844, _842))) * 0.3183098733425140380859375;
	        }
	        else
	        {
	            vIrradiance = vec3(0.0);
	        }
	        vec4 _4453 = g_Samples._m0[nSampleIndex].vIrradiance_flSampleCount;
	        vec3 _4455 = abs(vIrradiance);
	        float _4460 = max(_4455.x, max(_4455.y, _4455.z));
	        vec3 _4471 = mix(_4453.xyz, clamp(vIrradiance / vec3(_4460), vec3(-1.0), vec3(1.0)) * clamp(_4460, -100.0, 100.0), vec3(1.0 / (1.0 + _4453.w)));
	        vec4 _4473 = _4453;
	        _4473.x = _4471.x;
	        _4473.y = _4471.y;
	        _4473.z = _4471.z;
	        _4473.w = _4473.w + 1.0;
	        g_Samples._m0[nSampleIndex].vIrradiance_flSampleCount = _4473;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
