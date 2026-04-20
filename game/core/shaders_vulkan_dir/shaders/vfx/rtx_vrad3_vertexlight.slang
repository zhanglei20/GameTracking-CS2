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
	// SPIR-V source (109320 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	float _274;
	vec4 _275;
	
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
	    bool _471 = false;
	    bool _525 = false;
	    do
	    {
	        uvec2 vTriangle = gl_LaunchIDEXT.xy / uvec2(4u);
	        uint nSampleIndex = (gl_LaunchIDEXT.x + (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x)) + ((gl_LaunchIDEXT.z * gl_LaunchSizeEXT.x) * gl_LaunchSizeEXT.y);
	        int nTriangle = int(vTriangle.x + ((gl_LaunchSizeEXT.x / 4u) * vTriangle.y));
	        if (nTriangle >= g_PushConstants.m_nTriangleCount_Unused0.x)
	        {
	            break;
	        }
	        vec2 _614 = (vec2((gl_LaunchIDEXT.xy - (vTriangle.xy * uvec2(4u))).xy) + vec2(0.5)) * vec2(0.25);
	        float _616 = sqrt(_614.x);
	        vec3 _621 = vec3(1.0 - _616, _616 * (1.0 - _614.y), _274);
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
	        uvec3 _646 = uvec3(imageSize(g_RandomSamples));
	        ivec3 _581;
	        ivec3 _649 = _581;
	        _649.x = int(_646.x);
	        _649.y = int(_646.y);
	        _649.z = int(_646.z);
	        _581 = _649;
	        ivec2 _658 = ivec2(gl_LaunchIDEXT.xy) - _649.xy * (ivec2(gl_LaunchIDEXT.xy) / _649.xy);
	        uint _659 = uint(g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.y);
	        uint _679 = uint(max(1, ((g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	        uvec3 _680 = uvec3(g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.xyz);
	        vec3 _683 = vec3(_680) / (g_SceneGlobalInfo._m0[0].m_vLocalLightMaxBounds.xyz - g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz);
	        vec3 _685 = (-g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz) * _683;
	        int _686 = 3 * nTriangle;
	        vec3 v0 = vec3(g_Triangles_1._m0[_686 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._m0[(_686 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._m0[(_686 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        int _704 = _686 + 1;
	        vec3 v1 = vec3(g_Triangles_1._m0[_704 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._m0[(_704 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._m0[(_704 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        int _722 = _686 + 2;
	        vec3 v2 = vec3(g_Triangles_1._m0[_722 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._m0[(_722 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._m0[(_722 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        vec3 _743 = normalize(cross(v1 - v0, v2 - v0));
	        float _744 = _621.x;
	        float _746 = _621.y;
	        vec3 _359 = ((v0 * ((1.0 - _744) - _746)) + (v1 * _744)) + (v2 * _746);
	        f16vec3 _283 = f16vec3(_743);
	        vec3 _357 = _743;
	        vec3 _319;
	        vec3 _582 = _319;
	        vec3 _318;
	        vec3 _583 = _318;
	        float _756 = _743.z;
	        float _580;
	        if (_756 >= 0.0)
	        {
	            _580 = 1.0;
	        }
	        else
	        {
	            _580 = -1.0;
	        }
	        float _763 = (-1.0) / (_580 + _756);
	        float _764 = _743.x;
	        float _765 = _743.y;
	        float _767 = (_764 * _765) * _763;
	        vec3 _772 = _582;
	        _772.x = 1.0 + (((_580 * _764) * _764) * _763);
	        _772.y = _580 * _767;
	        _772.z = (-_580) * _764;
	        _582 = _772;
	        vec3 _779 = _583;
	        _779.x = _767;
	        _779.y = _580 + ((_765 * _765) * _763);
	        _779.z = -_765;
	        _583 = _779;
	        _319 = _772;
	        _318 = _779;
	        f16vec3 _281 = f16vec3(vec3(1.0));
	        vec3 _788 = _359;
	        float _791 = abs(1.0);
	        vec3 _796 = _788 + (_357 * ((abs(_788) + vec3(_791)) * 9.9999997473787516355514526367188e-05));
	        _359 = _796;
	        vec2 _803 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_658.xy, 1)))).xy;
	        bool _584;
	        if (all(greaterThanEqual(_796.xyz, g_PushConstants.m_vCordonMins.xyz)))
	        {
	            _584 = all(lessThanEqual(_359.xyz, g_PushConstants.m_vCordonMaxs.xyz));
	        }
	        else
	        {
	            _584 = false;
	        }
	        vec3 vIrradiance;
	        if (_584)
	        {
	            vec3 _315;
	            float _316;
	            float _317;
	            f16vec4 _277;
	            uint _278;
	            float16_t _279;
	            float16_t _280;
	            float16_t _282;
	            int _356;
	            vec3 _358;
	            float _840 = _803.y;
	            float _841 = sqrt(_840);
	            float _843 = 6.283185482025146484375 * _803.x;
	            vec3 _851 = vec3(cos(_843) * _841, sin(_843) * _841, sqrt(max(0.0, 1.0 - _840)));
	            vec3 _854 = vec3(_283);
	            vec3 _856 = mat3(_319, _318, _854) * _851;
	            vec3 _569 = _856;
	            vec3 _369 = _359;
	            vec3 _368 = _358;
	            vec3 _367 = _357;
	            int _366 = _356;
	            f16vec3 _298 = _283;
	            float16_t _297 = _282;
	            f16vec3 _296 = _281;
	            float16_t _295 = _280;
	            float16_t _294 = _279;
	            uint _293 = _278;
	            f16vec4 _292 = _277;
	            vec3 _329 = _319;
	            vec3 _328 = _318;
	            float _327 = _317;
	            float _326 = _316;
	            vec3 _325 = _315;
	            int _570 = 1;
	            vec3 _571 = vec3(1.0 / (_851.z * 0.3183098733425140380859375));
	            vec3 _572 = vec3(0.0);
	            vec3 _370;
	            vec3 _383;
	            vec3 _403;
	            bool _407;
	            float _408;
	            bool _409;
	            vec3 _410;
	            bool _411;
	            vec3 _412;
	            vec3 _413;
	            float _414;
	            float _415;
	            bool _416;
	            vec3 _417;
	            bool _418;
	            vec3 _419;
	            bool _422;
	            bool _423;
	            bool _425;
	            float _426;
	            uint _427;
	            float _428;
	            bool _429;
	            float _430;
	            bool _431;
	            bool _432;
	            float _433;
	            float _434;
	            float _435;
	            bool _436;
	            float _437;
	            bool _438;
	            vec3 _439;
	            bool _440;
	            vec3 _441;
	            vec3 _442;
	            bool _443;
	            bool _444;
	            float _445;
	            vec4 _446;
	            vec4 _447;
	            float _448;
	            vec3 _449;
	            float _450;
	            float _451;
	            bool _452;
	            float _453;
	            vec4 _454;
	            vec2 _455;
	            float _456;
	            float _457;
	            vec4 _458;
	            float _459;
	            vec3 _460;
	            vec3 _461;
	            bool _462;
	            float _463;
	            vec4 _464;
	            vec2 _465;
	            float _466;
	            float _467;
	            vec3 _469;
	            vec3 _470;
	            vec4 _472;
	            float _473;
	            float _474;
	            vec3 _475;
	            vec3 _476;
	            float _477;
	            float _478;
	            bool _479;
	            vec3 _480;
	            vec3 _481;
	            bool _482;
	            bool _483;
	            vec3 _484;
	            bool _489;
	            float _492;
	            float _494;
	            bool _495;
	            vec3 _496;
	            bool _497;
	            vec3 _498;
	            vec3 _499;
	            vec4 _500;
	            vec4 _501;
	            float _502;
	            vec3 _503;
	            float _504;
	            float _505;
	            bool _506;
	            float _507;
	            vec4 _508;
	            vec2 _509;
	            float _510;
	            float _511;
	            vec4 _512;
	            float _513;
	            vec3 _514;
	            vec3 _515;
	            bool _516;
	            float _517;
	            vec4 _518;
	            vec2 _519;
	            float _520;
	            float _521;
	            vec3 _523;
	            vec3 _524;
	            vec4 _526;
	            float _527;
	            float _528;
	            vec3 _529;
	            vec3 _530;
	            float _531;
	            float _532;
	            bool _533;
	            vec3 _534;
	            vec3 _535;
	            bool _536;
	            bool _537;
	            vec3 _538;
	            float _543;
	            bool _544;
	            bool _545;
	            bool _546;
	            vec3 _548;
	            float _550;
	            float _551;
	            bool _554;
	            float _555;
	            float _556;
	            bool _559;
	            float _560;
	            float _561;
	            float _562;
	            bool _563;
	            bool _565;
	            vec3 _567;
	            vec3 _568;
	            vec3 _573;
	            float _574;
	            float _577;
	            vec3 _579;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_570 <= 16))
	                {
	                    break;
	                }
	                if (false)
	                {
	                    if (_570 > (-1))
	                    {
	                        _574 = 1.0;
	                        _573 = vec3(0.0);
	                    }
	                    else
	                    {
	                        if (_570 != (-1))
	                        {
	                            _574 = 0.0;
	                        }
	                        else
	                        {
	                            _574 = 1.0;
	                        }
	                        _573 = _571;
	                    }
	                }
	                else
	                {
	                    _574 = 1.0;
	                    _573 = _571;
	                }
	                if (all(equal(_573, vec3(0.0))))
	                {
	                    break;
	                }
	                vec3 _365 = _369;
	                vec3 _364 = _569;
	                vec2 _901 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_658.xy, int(1u + uint(_570)))))).xy;
	                f16vec3 _903 = f16vec3(vec3(0.0));
	                vec2 _909 = _901;
	                _909.y = 0.0;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _370, 3.4028234663852885981170418348452e+38, _901.y, -1, false, MaterialDataMinimal_t(_903, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _903, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 4u, 0u, 2u, 0u, _369, 0.0, _569, 56755.83984375, 0);
	                Payload_t _911 = p;
	                vec2 _913 = _901;
	                _913.y = _911._m4;
	                vec2 _575 = _913;
	                if (!(_911._m5 != (-1)))
	                {
	                    vec2 _930 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_658.xy, int(1u + uint(_570 + 1)))))).xy;
	                    _575 = _930;
	                    vec2 _564 = _930;
	                    if (_569.z < 0.0)
	                    {
	                        float _566 = _564.y;
	                        do
	                        {
	                            if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w <= 0.0)
	                            {
	                                _563 = false;
	                                break;
	                            }
	                            if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w >= 1.0)
	                            {
	                                _563 = true;
	                                break;
	                            }
	                            if (_566 < g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w)
	                            {
	                                _566 = min(_566 / g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                                _563 = true;
	                                break;
	                            }
	                            _566 = min((_566 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                            _563 = false;
	                            break;
	                        } while(false);
	                        vec2 _966 = _564;
	                        _966.y = _566;
	                        _564 = _966;
	                        _565 = _563;
	                    }
	                    else
	                    {
	                        _565 = false;
	                    }
	                    if (_565)
	                    {
	                        float _978 = sqrt(_564.y);
	                        float _980 = 6.283185482025146484375 * _564.x;
	                        _567 = vec3(cos(_980) * _978, sin(_980) * _978, sqrt(max(0.0, 1.0 - _564.y)));
	                        _568 = g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.xyz;
	                    }
	                    else
	                    {
	                        _567 = _569;
	                        _568 = g_SceneGlobalInfo._m0[0].m_vSkyColor.xyz;
	                    }
	                    if (g_SceneGlobalInfo._m0[0].m_vIBLParams.x >= 0)
	                    {
	                        vec3 _1036 = clamp(normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_567, 0.0)), vec3(-1.0), vec3(1.0));
	                        float _1037 = _1036.y;
	                        float _1038 = _1036.x;
	                        float _1039 = _1037 / _1038;
	                        float _1040 = abs(_1039);
	                        bool _1041 = _1040 < 1.0;
	                        if (_1041)
	                        {
	                            _561 = _1040;
	                        }
	                        else
	                        {
	                            _561 = 1.0 / _1040;
	                        }
	                        float _1046 = _561;
	                        float _1047 = _1046 * _1046;
	                        float _1052 = (1.0 + (((-0.3018949925899505615234375) + (0.087292902171611785888671875 * _1047)) * _1047)) * _1046;
	                        if (_1041)
	                        {
	                            _561 = _1052;
	                        }
	                        else
	                        {
	                            _561 = 1.57079601287841796875 - _1052;
	                        }
	                        float _1063 = uintBitsToFloat((floatBitsToUint(_561) & 2147483647u) | (floatBitsToUint(_1039) & 2147483648u));
	                        if (_1038 < 0.0)
	                        {
	                            _562 = _1063 + uintBitsToFloat(1078530011u | (floatBitsToUint(_1037) & 2147483648u));
	                        }
	                        else
	                        {
	                            _562 = _1063;
	                        }
	                        float _1075 = _1036.z;
	                        float _1076 = abs(_1075);
	                        float _1084 = (((-0.15658299624919891357421875) * _1076) + 1.57079637050628662109375) * intBitsToFloat(532487669 + (floatBitsToInt(1.0 - _1076) >> 1));
	                        if (_1075 >= 0.0)
	                        {
	                            _560 = _1084;
	                        }
	                        else
	                        {
	                            _560 = 3.1415927410125732421875 - _1084;
	                        }
	                        vec3 _1099 = g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * textureLod(sampler2D(g_bindless_Texture2D[g_SceneGlobalInfo._m0[0].m_vIBLParams.x], g_Sampler), vec2(_562 * 0.15915493667125701904296875, _560 * 0.3183098733425140380859375), 0.0).xyz;
	                        if (dot(_1099.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	                        {
	                            _568 += _1099;
	                        }
	                    }
	                    if (g_SceneGlobalInfo._m0[0].m_vIBLParams.y >= 0)
	                    {
	                        vec4 _1146 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._m0[0].m_vIBLParams.y], g_Sampler), normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_567, 0.0)), 0.0);
	                        if (dot(_1146.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	                        {
	                            _568 += (g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * _1146.xyz);
	                        }
	                    }
	                    if (_570 > 1)
	                    {
	                        _568 *= g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.w;
	                    }
	                    if (_565)
	                    {
	                        _568 *= g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.xyz;
	                    }
	                    _572 += ((_573 * _568) * _574);
	                    break;
	                }
	                if ((int((g_instanceBuffer_1._m0[uint(_911._m5)].nMaterialFlags_nInstanceFlags >> uint(16)) & 65535u) & 4) != 0)
	                {
	                    break;
	                }
	                uint _1198 = uint(_911._m5);
	                vec3 _374 = (_365 + (_364 * _911._m3)) + (_911._m1 * ((abs(_365) + vec3(abs(_911._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _373 = (_365 + (_364 * _911._m3)) + ((-_911._m1) * ((abs(_365) + vec3(abs(_911._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _372 = _911._m1;
	                int _371 = int((g_instanceBuffer_1._m0[_1198].nMaterialFlags_nInstanceFlags) & 65535u);
	                vec3 _379 = vec3(0.0);
	                vec3 _378 = vec3(0.0);
	                float _377 = 0.0;
	                float _376 = 0.0;
	                vec3 _375 = vec3(0.0);
	                f16vec3 _342 = _911._m7.vMaterialBits;
	                float16_t _341 = _911._m7._m1;
	                f16vec3 _340 = _911._m7._m2;
	                f16vec3 _338 = _911._m7._m4;
	                float16_t _337 = _911._m7._m5;
	                uint _336 = _911._m7._m6;
	                f16vec4 _335 = _911._m7._m7;
	                float16_t _339 = float16_t(max(float(_911._m7._m3), 0.07999999821186065673828125));
	                vec3 _1245 = vec3(_911._m7.vMaterialBits);
	                vec3 _557 = vec3(0.0);
	                vec3 _558 = vec3(0.0);
	                float _1246 = _1245.z;
	                if (_1246 >= 0.0)
	                {
	                    _556 = 1.0;
	                }
	                else
	                {
	                    _556 = -1.0;
	                }
	                float _1253 = (-1.0) / (_556 + _1246);
	                float _1254 = _1245.x;
	                float _1255 = _1245.y;
	                float _1257 = (_1254 * _1255) * _1253;
	                vec3 _1262 = _557;
	                _1262.x = 1.0 + (((_556 * _1254) * _1254) * _1253);
	                _1262.y = _556 * _1257;
	                _1262.z = (-_556) * _1254;
	                _557 = _1262;
	                vec3 _1269 = _558;
	                _1269.x = _1257;
	                _1269.y = _556 + ((_1255 * _1255) * _1253);
	                _1269.z = -_1255;
	                _558 = _1269;
	                _379 = _1262;
	                _378 = _1269;
	                vec3 _1281 = transpose(mat3(_1262, _1269, vec3(_342))) * (-_364);
	                _375 = _1281;
	                vec3 _1289 = vec3(mix(f16vec3(_337), _340, f16vec3(_341)));
	                _377 = dot((_1289 + ((vec3(1.0) - _1289) * pow(max(0.0, 1.0 - _1281.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                if ((_336 & 65535u) == 1u)
	                {
	                    float _1308 = dot(vec3(_335.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                    _376 = _1308 / max(9.9999997473787516355514526367188e-05, _1308 + dot(vec3(_340).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                }
	                f16vec3 _306 = _342;
	                float16_t _305 = _341;
	                f16vec3 _304 = _340;
	                float16_t _303 = _339;
	                f16vec3 _302 = _338;
	                float16_t _301 = _337;
	                uint _300 = _336;
	                f16vec4 _299 = _335;
	                vec3 _334 = _379;
	                vec3 _333 = _378;
	                float _332 = _377;
	                float _331 = _376;
	                vec3 _330 = _375;
	                if (true)
	                {
	                    if ((_371 & 256) != 0)
	                    {
	                        _302 *= float16_t(g_instanceBuffer_1._m0[_1198].fEmissiveBoost);
	                    }
	                    else
	                    {
	                        _302 = f16vec3(vec3(0.0));
	                    }
	                }
	                if (true)
	                {
	                    _559 = any(notEqual(_911.material, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _559 = false;
	                }
	                vec3 _1349 = _911.material - _374;
	                float _1350 = length(_1349);
	                vec3 _382 = _374;
	                float _381 = 0.0;
	                vec3 _380 = vec4(_1349 / vec3(_1350), _1350).xyz;
	                if (_559)
	                {
	                    _555 = _1350;
	                }
	                else
	                {
	                    _555 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _382, _381, _380, _555, 1);
	                if (_559)
	                {
	                    _555 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _555 = 0.0;
	                }
	                if (_555 == 1.0)
	                {
	                    _374 = _911.material;
	                    _372 = vec3(_911._m7.vMaterialBits);
	                }
	                vec3 _363 = _374;
	                vec3 _362 = _373;
	                vec3 _361 = _372;
	                int _360 = _371;
	                f16vec3 _291 = _306;
	                float16_t _290 = _305;
	                f16vec3 _289 = _304;
	                float16_t _288 = _303;
	                f16vec3 _287 = _302;
	                float16_t _286 = _301;
	                uint _285 = _300;
	                f16vec4 _284 = _299;
	                vec3 _324 = _334;
	                vec3 _323 = _333;
	                float _322 = _332;
	                float _321 = _331;
	                vec3 _320 = _330;
	                if (!(dot(_372, -_569) > 0.0))
	                {
	                    if ((_360 & 1024) != 0)
	                    {
	                        _361 = -_361;
	                        _291 = -_291;
	                        vec3 _1628 = _369;
	                        _369 = _368;
	                        _368 = _1628;
	                    }
	                    else
	                    {
	                        f16vec3 _1409 = f16vec3(vec3(0.0));
	                        vec2 _1415 = _901;
	                        _1415.y = 0.0;
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _383, 3.4028234663852885981170418348452e+38, _901.y, -1, false, MaterialDataMinimal_t(_1409, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1409, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 4u, 0u, 2u, 0u, _365, _911._m3 * 0.99989998340606689453125, _364, _911._m3 * 1.00010001659393310546875, 0);
	                        vec2 _1421 = _901;
	                        _1421.y = p._m4;
	                        _575 = _1421;
	                        if (p._m5 != (-1))
	                        {
	                            uint _1430 = uint(p._m5);
	                            vec3 _387 = (_365 + (_364 * p._m3)) + (p._m1 * ((abs(_365) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _386 = (_365 + (_364 * p._m3)) + ((-p._m1) * ((abs(_365) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _385 = p._m1;
	                            int _384 = int((g_instanceBuffer_1._m0[_1430].nMaterialFlags_nInstanceFlags) & 65535u);
	                            vec3 _392 = vec3(0.0);
	                            vec3 _391 = vec3(0.0);
	                            float _390 = 0.0;
	                            float _389 = 0.0;
	                            vec3 _388 = vec3(0.0);
	                            f16vec3 _355 = p._m7.vMaterialBits;
	                            float16_t _354 = p._m7._m1;
	                            f16vec3 _353 = p._m7._m2;
	                            f16vec3 _351 = p._m7._m4;
	                            float16_t _350 = p._m7._m5;
	                            uint _349 = p._m7._m6;
	                            f16vec4 _348 = p._m7._m7;
	                            float16_t _352 = float16_t(max(float(p._m7._m3), 0.07999999821186065673828125));
	                            vec3 _1477 = vec3(p._m7.vMaterialBits);
	                            vec3 _552 = vec3(0.0);
	                            vec3 _553 = vec3(0.0);
	                            float _1478 = _1477.z;
	                            if (_1478 >= 0.0)
	                            {
	                                _551 = 1.0;
	                            }
	                            else
	                            {
	                                _551 = -1.0;
	                            }
	                            float _1485 = (-1.0) / (_551 + _1478);
	                            float _1486 = _1477.x;
	                            float _1487 = _1477.y;
	                            float _1489 = (_1486 * _1487) * _1485;
	                            vec3 _1494 = _552;
	                            _1494.x = 1.0 + (((_551 * _1486) * _1486) * _1485);
	                            _1494.y = _551 * _1489;
	                            _1494.z = (-_551) * _1486;
	                            _552 = _1494;
	                            vec3 _1501 = _553;
	                            _1501.x = _1489;
	                            _1501.y = _551 + ((_1487 * _1487) * _1485);
	                            _1501.z = -_1487;
	                            _553 = _1501;
	                            _392 = _1494;
	                            _391 = _1501;
	                            vec3 _1513 = transpose(mat3(_1494, _1501, vec3(_355))) * (-_364);
	                            _388 = _1513;
	                            vec3 _1521 = vec3(mix(f16vec3(_350), _353, f16vec3(_354)));
	                            _390 = dot((_1521 + ((vec3(1.0) - _1521) * pow(max(0.0, 1.0 - _1513.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if ((_349 & 65535u) == 1u)
	                            {
	                                float _1540 = dot(vec3(_348.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                _389 = _1540 / max(9.9999997473787516355514526367188e-05, _1540 + dot(vec3(_353).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                            }
	                            f16vec3 _314 = _355;
	                            float16_t _313 = _354;
	                            f16vec3 _312 = _353;
	                            float16_t _311 = _352;
	                            f16vec3 _310 = _351;
	                            float16_t _309 = _350;
	                            uint _308 = _349;
	                            f16vec4 _307 = _348;
	                            vec3 _347 = _392;
	                            vec3 _346 = _391;
	                            float _345 = _390;
	                            float _344 = _389;
	                            vec3 _343 = _388;
	                            if (true)
	                            {
	                                if ((_384 & 256) != 0)
	                                {
	                                    _310 *= float16_t(g_instanceBuffer_1._m0[_1430].fEmissiveBoost);
	                                }
	                                else
	                                {
	                                    _310 = f16vec3(vec3(0.0));
	                                }
	                            }
	                            if (true)
	                            {
	                                _554 = any(notEqual(p.material, vec3(3.4028234663852885981170418348452e+38)));
	                            }
	                            else
	                            {
	                                _554 = false;
	                            }
	                            vec3 _1581 = p.material - _387;
	                            float _1582 = length(_1581);
	                            vec3 _395 = _387;
	                            float _394 = 0.0;
	                            vec3 _393 = vec4(_1581 / vec3(_1582), _1582).xyz;
	                            if (_554)
	                            {
	                                _550 = _1582;
	                            }
	                            else
	                            {
	                                _550 = 0.0;
	                            }
	                            p_1 = PayloadShadow_t(1.0);
	                            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _395, _394, _393, _550, 1);
	                            if (_554)
	                            {
	                                _550 = p_1.m_flVisibility;
	                            }
	                            else
	                            {
	                                _550 = 0.0;
	                            }
	                            if (_550 == 1.0)
	                            {
	                                _387 = p.material;
	                                _385 = vec3(p._m7.vMaterialBits);
	                            }
	                            _363 = _387;
	                            _362 = _386;
	                            _361 = _385;
	                            _360 = _384;
	                            _291 = _314;
	                            _290 = _313;
	                            _289 = _312;
	                            _288 = _311;
	                            _287 = _310;
	                            _286 = _309;
	                            _285 = _308;
	                            _284 = _307;
	                            _324 = _347;
	                            _323 = _346;
	                            _322 = _345;
	                            _321 = _344;
	                            _320 = _343;
	                        }
	                        else
	                        {
	                            break;
	                        }
	                    }
	                }
	                vec3 _1645 = (_363 + _362) * 0.5;
	                bool _1646 = _570 != 0;
	                if ((_285 & 65535u) == 1u)
	                {
	                    _545 = any(greaterThan(vec3(_284.xyz), vec3(0.0)));
	                }
	                else
	                {
	                    _545 = false;
	                }
	                if (_545)
	                {
	                    _546 = true;
	                }
	                else
	                {
	                    if ((_285 & 65535u) == 2u)
	                    {
	                        _544 = float(_284.x) > 0.0;
	                    }
	                    else
	                    {
	                        _544 = false;
	                    }
	                    _546 = _544;
	                }
	                vec2 _1680 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_658.xy, int(1u + ((2u * _659) + uint(_570))))))).xy;
	                bool _547 = false;
	                vec3 _1693 = (_363 + _362) * 0.5;
	                uvec3 _1698 = min(uvec3(max(fma(_1693, _683, _685), vec3(0.0))), (_680 - uvec3(1u)));
	                uint _539 = 0u;
	                vec3 _540 = vec3(0.0);
	                for (;;)
	                {
	                    if (!(_539 < _679))
	                    {
	                        break;
	                    }
	                    uint _1711 = _679 * _680.x;
	                    uint _541 = subgroupOr(g_LightBins_1._m0[((((_1711 * _680.y) * _1698.z) + (_1711 * _1698.y)) + (_679 * _1698.x)) + _539]);
	                    vec3 _542 = _540;
	                    for (;;)
	                    {
	                        bool _1731_ladder_break = false;
	                        do
	                        {
	                            if (!(_541 != 0u))
	                            {
	                                _1731_ladder_break = true;
	                                break;
	                            }
	                            uint _1738 = _541;
	                            uint _1742 = uint(findLSB(_1738)) + (_539 * 32u);
	                            uint _1744 = _1738 & (_1738 - 1u);
	                            mat4 _1774 = mat4(vec4(g_Lights_1._m0[_1742].m_mToClipSpace.data[0].x, g_Lights_1._m0[_1742].m_mToClipSpace.data[1].x, g_Lights_1._m0[_1742].m_mToClipSpace.data[2].x, g_Lights_1._m0[_1742].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_1742].m_mToClipSpace.data[0].y, g_Lights_1._m0[_1742].m_mToClipSpace.data[1].y, g_Lights_1._m0[_1742].m_mToClipSpace.data[2].y, g_Lights_1._m0[_1742].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_1742].m_mToClipSpace.data[0].z, g_Lights_1._m0[_1742].m_mToClipSpace.data[1].z, g_Lights_1._m0[_1742].m_mToClipSpace.data[2].z, g_Lights_1._m0[_1742].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_1742].m_mToClipSpace.data[0].w, g_Lights_1._m0[_1742].m_mToClipSpace.data[1].w, g_Lights_1._m0[_1742].m_mToClipSpace.data[2].w, g_Lights_1._m0[_1742].m_mToClipSpace.data[3].w));
	                            if ((uint(g_Lights_1._m0[_1742].m_nPathTraceFlags) & 1u) == 0u)
	                            {
	                                _541 = _1744;
	                                break;
	                            }
	                            if ((g_Lights_1._m0[_1742].m_nPathTraceFlags & 8) != 0)
	                            {
	                                _547 = true;
	                                _541 = _1744;
	                                break;
	                            }
	                            do
	                            {
	                                do
	                                {
	                                    vec4 _1849 = _1774 * vec4(_1693.xyz, 1.0);
	                                    vec3 _1853 = _1849.xyz / vec3(_1849.w);
	                                    vec4 _1855;
	                                    _1855.x = _1853.x;
	                                    _1855.y = _1853.y;
	                                    _1855.z = _1853.z;
	                                    if (all(greaterThanEqual(_1855.xyz, vec3(-1.0, -1.0, 0.0))))
	                                    {
	                                        _536 = all(lessThanEqual(_1855.xyz, vec3(1.0)));
	                                    }
	                                    else
	                                    {
	                                        _536 = false;
	                                    }
	                                    if (!_536)
	                                    {
	                                        _537 = false;
	                                        break;
	                                    }
	                                    if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_1742].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_1693, 1.0)).xyz), vec3(1.0))))
	                                    {
	                                        _537 = false;
	                                        break;
	                                    }
	                                    _537 = true;
	                                    break;
	                                } while(false);
	                                if (!_537)
	                                {
	                                    _538 = vec3(0.0);
	                                    break;
	                                }
	                                vec4 _1887 = _1774 * vec4(_1693.xyz, 1.0);
	                                vec3 _1891 = _1887.xyz / vec3(_1887.w);
	                                vec4 _1893;
	                                _1893.x = _1891.x;
	                                _1893.y = _1891.y;
	                                _1893.z = _1891.z;
	                                if (_1646)
	                                {
	                                    _535 = g_Lights_1._m0[_1742].m_vBounceColor.xyz;
	                                }
	                                else
	                                {
	                                    _535 = g_Lights_1._m0[_1742].m_vColor.xyz;
	                                }
	                                if (true)
	                                {
	                                    if (g_Lights_1._m0[_1742].m_nCookie >= 0)
	                                    {
	                                        if (g_Lights_1._m0[_1742].m_bSphericalCookie != 0)
	                                        {
	                                            vec4 _1936 = vec4(-g_Lights_1._m0[_1742].m_vOrientation.xyz, g_Lights_1._m0[_1742].m_vOrientation.w);
	                                            vec4 _1938 = _1936.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                            vec3 _1941 = _1938.xyz;
	                                            vec3 _1942 = vec4((-normalize(g_Lights_1._m0[_1742].m_vLightPosition.xyz - _1693)).xyz, 0.0).xyz;
	                                            vec4 _1949 = vec4((_1942 * _1938.w) + cross(_1942, _1941), -dot(_1942, _1941));
	                                            vec3 _1950 = _1949.xyz;
	                                            float _1951 = _1936.w;
	                                            vec3 _1953 = _1936.xyz;
	                                            float _1954 = _1949.w;
	                                            vec3 _1962 = vec4(((_1950 * _1951) + (_1953 * _1954)) + cross(_1953, _1950), _274).xyz;
	                                            vec2 _1971 = vec2(atan(_1962.y, -_1962.x) * 0.15915493667125701904296875, acos(_1962.z) * 0.3183098733425140380859375);
	                                            vec2 _1976 = (_1971.xy * g_Lights_1._m0[_1742].m_vCookieParameters.zw) + g_Lights_1._m0[_1742].m_vCookieParameters.xy;
	                                            vec2 _1978 = _1971;
	                                            _1978.x = _1976.x;
	                                            _1978.y = _1976.y;
	                                            _534 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_1742].m_nCookie], g_Sampler), _1978, 0.0).xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _1915 = fma(_1893.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                            vec2 _1920 = (_1915.xy * g_Lights_1._m0[_1742].m_vCookieParameters.zw) + g_Lights_1._m0[_1742].m_vCookieParameters.xy;
	                                            vec2 _1922 = _1915;
	                                            _1922.x = _1920.x;
	                                            _1922.y = _1920.y;
	                                            _534 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_1742].m_nCookie], g_CookieSampler), _1922, 0.0).xyz;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _534 = vec3(1.0);
	                                    }
	                                    _535 *= _534;
	                                }
	                                if (g_Lights_1._m0[_1742].m_nLuminaireType != 0)
	                                {
	                                    _535 = (_535 * g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                }
	                                else
	                                {
	                                    if (!(g_Lights_1._m0[_1742].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _1998 = g_Lights_1._m0[_1742].m_vLightPosition.xyz - _1693;
	                                        _535 *= (vec3(g_Lights_1._m0[_1742].m_vLightPosition.w) / max(vec3(dot(_1998, _1998)), vec3(g_Lights_1._m0[_1742].m_vLightPosition.w)));
	                                    }
	                                }
	                                if (g_Lights_1._m0[_1742].m_vDistanceFade_vSkirt.z > 0.0)
	                                {
	                                    _531 = smoothstep(0.0, 1.0, _1893.xyz.z * g_Lights_1._m0[_1742].m_vDistanceFade_vSkirt.z);
	                                }
	                                else
	                                {
	                                    _531 = 1.0;
	                                }
	                                if (g_Lights_1._m0[_1742].m_vDistanceFade_vSkirt.w > 0.0)
	                                {
	                                    _531 *= smoothstep(0.0, 1.0, (1.0 - _1893.xyz.z) * g_Lights_1._m0[_1742].m_vDistanceFade_vSkirt.w);
	                                }
	                                if (!(g_Lights_1._m0[_1742].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _2039 = g_Lights_1._m0[_1742].m_vLightPosition.xyz - _1693;
	                                    float _2040 = length(_2039);
	                                    vec3 _2042 = _2039 / vec3(_2040);
	                                    float _2048 = _531 * smoothstep(0.0, 1.0, g_Lights_1._m0[_1742].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_1742].m_vDistanceFade_vSkirt.y * _2040));
	                                    if (g_Lights_1._m0[_1742].m_nLuminaireType != 2)
	                                    {
	                                        _533 = g_Lights_1._m0[_1742].m_nLuminaireType != 1;
	                                    }
	                                    else
	                                    {
	                                        _533 = false;
	                                    }
	                                    if (_533)
	                                    {
	                                        float _2060 = 2.0 * g_Lights_1._m0[_1742].m_vOrientation.x;
	                                        float _2064 = 2.0 * g_Lights_1._m0[_1742].m_vOrientation.w;
	                                        vec3 _2078 = vec3((_2060 * g_Lights_1._m0[_1742].m_vOrientation.y) - (_2064 * g_Lights_1._m0[_1742].m_vOrientation.z), (1.0 - (_2060 * g_Lights_1._m0[_1742].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_1742].m_vOrientation.z) * g_Lights_1._m0[_1742].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_1742].m_vOrientation.y) * g_Lights_1._m0[_1742].m_vOrientation.z) + (_2064 * g_Lights_1._m0[_1742].m_vOrientation.x)) * g_Lights_1._m0[_1742].m_vAngleFade.z;
	                                        vec3 _2079 = _2042 - _2078;
	                                        vec3 _2080 = _2042 + _2078;
	                                        do
	                                        {
	                                            vec3 _2083 = _2080 - _2079;
	                                            float _2085 = dot(-_2079, _2083);
	                                            if (_2085 <= 0.0)
	                                            {
	                                                _529 = _2079;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _2090 = dot(_2083, _2083);
	                                                if (_2085 > _2090)
	                                                {
	                                                    _529 = _2080;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    _529 = _2079 + (_2083 * (_2085 / _2090));
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (any(notEqual(_529, vec3(0.0))))
	                                        {
	                                            _530 = normalize(_529);
	                                        }
	                                        else
	                                        {
	                                            _530 = _529;
	                                        }
	                                        float _2114 = 2.0 * g_Lights_1._m0[_1742].m_vOrientation.x;
	                                        float _2117 = 2.0 * g_Lights_1._m0[_1742].m_vOrientation.w;
	                                        _532 = _2048 * clamp(g_Lights_1._m0[_1742].m_vAngleFade.x + (g_Lights_1._m0[_1742].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_1742].m_vOrientation.y) * g_Lights_1._m0[_1742].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_1742].m_vOrientation.z) * g_Lights_1._m0[_1742].m_vOrientation.z), (_2114 * g_Lights_1._m0[_1742].m_vOrientation.y) + (_2117 * g_Lights_1._m0[_1742].m_vOrientation.z), (_2114 * g_Lights_1._m0[_1742].m_vOrientation.z) - (_2117 * g_Lights_1._m0[_1742].m_vOrientation.y)), _530)), 0.0, 1.0);
	                                    }
	                                    else
	                                    {
	                                        _532 = _2048;
	                                    }
	                                }
	                                else
	                                {
	                                    _532 = _531;
	                                }
	                                if (g_Lights_1._m0[_1742].m_nCookie == (-1))
	                                {
	                                    do
	                                    {
	                                        vec2 _2141 = abs(_1893.xyz.xy);
	                                        if (g_Lights_1._m0[_1742].m_vCookieParameters.z == 0.0)
	                                        {
	                                            _527 = smoothstep(1.0, g_Lights_1._m0[_1742].m_vCookieParameters.x, _2141.x) * smoothstep(1.0, g_Lights_1._m0[_1742].m_vCookieParameters.y, _2141.y);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _2146 = _2141.x;
	                                            float _2150 = _2141.y;
	                                            float _2157 = (-0.5) * g_Lights_1._m0[_1742].m_vCookieParameters.z;
	                                            float _2159 = (g_Lights_1._m0[_1742].m_vCookieParameters.x * g_Lights_1._m0[_1742].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_1742].m_vCookieParameters.y * _2146, 2.0 / g_Lights_1._m0[_1742].m_vCookieParameters.z) + pow(g_Lights_1._m0[_1742].m_vCookieParameters.x * _2150, 2.0 / g_Lights_1._m0[_1742].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2157);
	                                            float _2166 = pow(max(pow(_2146, 2.0 / g_Lights_1._m0[_1742].m_vCookieParameters.z) + pow(_2150, 2.0 / g_Lights_1._m0[_1742].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2157);
	                                            if (_2159 < _2166)
	                                            {
	                                                _527 = smoothstep(_2166, _2159, 1.0);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                if (_2166 > 1.0)
	                                                {
	                                                    _528 = 1.0;
	                                                }
	                                                else
	                                                {
	                                                    _528 = 0.0;
	                                                }
	                                                _527 = _528;
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _532 *= _527;
	                                }
	                                _538 = _535 * _532;
	                                break;
	                            } while(false);
	                            if (any(greaterThan(_538, vec3(0.0))))
	                            {
	                                _525 = false;
	                                do
	                                {
	                                    switch (g_Lights_1._m0[_1742].m_nLuminaireType)
	                                    {
	                                        case 0:
	                                        {
	                                            _543 = 1.0;
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1742].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _500 = vec4(normalize(g_Lights_1._m0[_1742].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2654 = g_Lights_1._m0[_1742].m_vLightPosition.xyz - _1693;
	                                                    float _2655 = length(_2654);
	                                                    _500 = vec4(_2654 / vec3(_2655), _2655);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _525 = true;
	                                            _526 = _500;
	                                            break;
	                                        }
	                                        case 1:
	                                        {
	                                            vec3 _2504 = g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].xyz;
	                                            vec3 _2506 = g_Lights_1._m0[_1742].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].xyz;
	                                            float _2507 = length(_2504);
	                                            float _2508 = length(_2506);
	                                            vec3 _2510 = _2504 / vec3(_2507);
	                                            vec3 _2512 = _2506 / vec3(_2508);
	                                            vec3 _2513 = cross(_2510, _2512);
	                                            vec3 _2514 = g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].xyz - _1693;
	                                            float _2515 = dot(_2514, _2513);
	                                            if (_2515 > 0.0)
	                                            {
	                                                _502 = _2515 * (-1.0);
	                                                _503 = _2513 * (-1.0);
	                                            }
	                                            else
	                                            {
	                                                _502 = _2515;
	                                                _503 = _2513;
	                                            }
	                                            float _2524 = dot(_2514, _2510);
	                                            float _2525 = dot(_2514, _2512);
	                                            float _2526 = _2524 + _2507;
	                                            float _2527 = _2525 + _2508;
	                                            vec3 _2530 = vec3(_2524, _2525, _502);
	                                            vec3 _2531 = vec3(_2524, _2527, _502);
	                                            vec3 _2532 = vec3(_2526, _2525, _502);
	                                            vec3 _2533 = vec3(_2526, _2527, _502);
	                                            vec3 _2535 = normalize(cross(_2530, _2532));
	                                            vec3 _2537 = normalize(cross(_2532, _2533));
	                                            vec3 _2539 = normalize(cross(_2533, _2531));
	                                            vec3 _2541 = normalize(cross(_2531, _2530));
	                                            float _2558 = _2535.z;
	                                            float _2562 = (6.283185482025146484375 - acos(clamp(-dot(_2539, _2541), -1.0, 1.0))) - acos(clamp(-dot(_2541, _2535), -1.0, 1.0));
	                                            float _2564 = (acos(clamp(-dot(_2535, _2537), -1.0, 1.0)) + acos(clamp(-dot(_2537, _2539), -1.0, 1.0))) - _2562;
	                                            if (isnan(_2564))
	                                            {
	                                                _504 = 0.0;
	                                            }
	                                            else
	                                            {
	                                                _504 = _2564;
	                                            }
	                                            float _2572 = (_1680.x * _504) + _2562;
	                                            float _2577 = ((cos(_2572) * _2558) - _2539.z) / sin(_2572);
	                                            if (_2577 > 0.0)
	                                            {
	                                                _505 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _505 = -1.0;
	                                            }
	                                            float _2586 = _505;
	                                            float _2588 = clamp((1.0 / sqrt((_2577 * _2577) + (_2558 * _2558))) * _2586, -1.0, 1.0);
	                                            float _2596 = clamp((-(_2588 * _502)) / sqrt(1.0 - (_2588 * _2588)), _2524, _2526);
	                                            float _2599 = sqrt((_2596 * _2596) + (_502 * _502));
	                                            float _2600 = _2599 * _2599;
	                                            float _2603 = _2525 / sqrt(_2600 + (_2525 * _2525));
	                                            float _2610 = _2603 + (_1680.y * ((_2527 / sqrt(_2600 + (_2527 * _2527))) - _2603));
	                                            float _2611 = _2610 * _2610;
	                                            if (_2611 < 0.99999988079071044921875)
	                                            {
	                                                _505 = (_2610 * _2599) / sqrt(1.0 - _2611);
	                                            }
	                                            else
	                                            {
	                                                _505 = _2527;
	                                            }
	                                            vec3 _2628 = ((_1693 + (_2510 * _2596)) + (_2512 * _505)) + (_503 * _502);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1742].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _501 = vec4(normalize(_2628), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2636 = _2628 - _1693;
	                                                    float _2637 = length(_2636);
	                                                    _501 = vec4(_2636 / vec3(_2637), _2637);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _543 = 1.0 / _504;
	                                            _525 = true;
	                                            _526 = _501;
	                                            break;
	                                        }
	                                        case 2:
	                                        {
	                                            do
	                                            {
	                                                vec2 _2432 = (_1680 * 2.0) - vec2(1.0);
	                                                if (all(equal(_2432, vec2(0.0))))
	                                                {
	                                                    _509 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _2437 = _2432.x;
	                                                float _2439 = _2432.y;
	                                                if (abs(_2437) > abs(_2439))
	                                                {
	                                                    _510 = _2437;
	                                                    _511 = 0.785398185253143310546875 * (_2439 / _2437);
	                                                }
	                                                else
	                                                {
	                                                    _510 = _2439;
	                                                    _511 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2437 / _2439));
	                                                }
	                                                _509 = vec2(cos(_511), sin(_511)) * _510;
	                                                break;
	                                            } while(false);
	                                            vec3 _2465 = (g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].xyz * _509.x)) + (g_Lights_1._m0[_1742].m_vLuminaireVectors.data[2].xyz * _509.y);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1742].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _508 = vec4(normalize(_2465), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2473 = _2465 - _1693;
	                                                    float _2474 = length(_2473);
	                                                    _508 = vec4(_2473 / vec3(_2474), _2474);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_508.w))
	                                            {
	                                                _506 = true;
	                                            }
	                                            else
	                                            {
	                                                _506 = isnan(_508.w);
	                                            }
	                                            if (!_506)
	                                            {
	                                                _507 = _508.w * _508.w;
	                                            }
	                                            else
	                                            {
	                                                _507 = 1.0;
	                                            }
	                                            _543 = _507 / (max(0.0, dot(g_Lights_1._m0[_1742].m_vLuminaireVectors.data[3].xyz, -_508.xyz)) * g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].w);
	                                            _525 = true;
	                                            _526 = _508;
	                                            break;
	                                        }
	                                        case 3:
	                                        {
	                                            vec3 _2331 = g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].xyz - _1693;
	                                            float _2332 = dot(_2331, _2331);
	                                            float _2333 = sqrt(_2332);
	                                            vec3 _2335 = _2331 / vec3(_2333);
	                                            float _2336 = _2335.z;
	                                            if (_2336 >= 0.0)
	                                            {
	                                                _513 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _513 = -1.0;
	                                            }
	                                            float _2343 = (-1.0) / (_513 + _2336);
	                                            float _2344 = _2335.x;
	                                            float _2345 = _2335.y;
	                                            float _2347 = (_2344 * _2345) * _2343;
	                                            vec3 _2352 = _514;
	                                            _2352.x = 1.0 + (((_513 * _2344) * _2344) * _2343);
	                                            _2352.y = _513 * _2347;
	                                            _2352.z = (-_513) * _2344;
	                                            _514 = _2352;
	                                            vec3 _2359 = _515;
	                                            _2359.x = _2347;
	                                            _2359.y = _513 + ((_2345 * _2345) * _2343);
	                                            _2359.z = -_2345;
	                                            _515 = _2359;
	                                            float _2367 = g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].x;
	                                            float _2371 = sqrt(max(0.0, 1.0 - (_2367 / _2332)));
	                                            float _2372 = _1680.x;
	                                            float _2375 = (1.0 - _2372) + (_2372 * _2371);
	                                            float _2379 = sqrt(max(0.0, 1.0 - (_2375 * _2375)));
	                                            float _2381 = _1680.y * 6.283185482025146484375;
	                                            float _2383 = _2333 * _2333;
	                                            float _2389 = (_2333 * _2375) - sqrt(max(0.0, _2367 - ((_2383 * _2379) * _2379)));
	                                            float _2395 = ((_2383 + _2367) - (_2389 * _2389)) / ((2.0 * _2333) * g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].x);
	                                            float _2399 = sqrt(max(0.0, 1.0 - (_2395 * _2395)));
	                                            vec3 _2411 = g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].xyz + ((mat3(-_2352, -_2359, -_2335) * vec3(cos(_2381) * _2399, sin(_2381) * _2399, _2395)) * g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].x);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1742].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _512 = vec4(normalize(_2411), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2419 = _2411 - _1693;
	                                                    float _2420 = length(_2419);
	                                                    _512 = vec4(_2419 / vec3(_2420), _2420);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _543 = 0.15915493667125701904296875 / (1.0 - _2371);
	                                            _525 = true;
	                                            _526 = _512;
	                                            break;
	                                        }
	                                        case 4:
	                                        case 5:
	                                        {
	                                            vec2 _522 = _1680;
	                                            if (_1680.x < g_Lights_1._m0[_1742].m_vLuminaireVectors.data[4].y)
	                                            {
	                                                vec2 _2232 = _522;
	                                                _2232.x = clamp(_2232.x / g_Lights_1._m0[_1742].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                                _522 = _2232;
	                                                vec3 _2238 = normalize(g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].xyz);
	                                                if (_2232.x >= 0.5)
	                                                {
	                                                    vec2 _2249 = _522;
	                                                    _2249.x = clamp((2.0 * _2249.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                    _522 = _2249;
	                                                    _523 = -_2238;
	                                                    _524 = g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].xyz;
	                                                }
	                                                else
	                                                {
	                                                    vec2 _2244 = _522;
	                                                    _2244.x = clamp(2.0 * _2244.x, 0.0, 0.99999988079071044921875);
	                                                    _522 = _2244;
	                                                    _523 = _2238;
	                                                    _524 = g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].xyz;
	                                                }
	                                                do
	                                                {
	                                                    vec2 _2260 = (_522 * 2.0) - vec2(1.0);
	                                                    if (all(equal(_2260, vec2(0.0))))
	                                                    {
	                                                        _519 = vec2(0.0);
	                                                        break;
	                                                    }
	                                                    float _2265 = _2260.x;
	                                                    float _2267 = _2260.y;
	                                                    if (abs(_2265) > abs(_2267))
	                                                    {
	                                                        _520 = _2265;
	                                                        _521 = 0.785398185253143310546875 * (_2267 / _2265);
	                                                    }
	                                                    else
	                                                    {
	                                                        _520 = _2267;
	                                                        _521 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2265 / _2267));
	                                                    }
	                                                    _519 = vec2(cos(_521), sin(_521)) * _520;
	                                                    break;
	                                                } while(false);
	                                                _524 += ((g_Lights_1._m0[_1742].m_vLuminaireVectors.data[2].xyz * _519.x) + (g_Lights_1._m0[_1742].m_vLuminaireVectors.data[3].xyz * _519.y));
	                                            }
	                                            else
	                                            {
	                                                vec2 _2211 = _522;
	                                                _2211.x = clamp((_2211.x - g_Lights_1._m0[_1742].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_1742].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                                _522 = _2211;
	                                                vec3 _2226 = (g_Lights_1._m0[_1742].m_vLuminaireVectors.data[2].xyz * cos(_2211.x * 6.283185482025146484375)) + (g_Lights_1._m0[_1742].m_vLuminaireVectors.data[3].xyz * sin(_2211.x * 6.283185482025146484375));
	                                                _523 = normalize(_2226);
	                                                _524 = mix(g_Lights_1._m0[_1742].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].xyz, vec3(_2211.y)) + _2226;
	                                            }
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_1742].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _518 = vec4(normalize(_524), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _2300 = _524 - _1693;
	                                                    float _2301 = length(_2300);
	                                                    _518 = vec4(_2300 / vec3(_2301), _2301);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_518.w))
	                                            {
	                                                _516 = true;
	                                            }
	                                            else
	                                            {
	                                                _516 = isnan(_518.w);
	                                            }
	                                            if (!_516)
	                                            {
	                                                _517 = _518.w * _518.w;
	                                            }
	                                            else
	                                            {
	                                                _517 = 1.0;
	                                            }
	                                            _543 = _517 / (max(0.0, dot(_523, -_518.xyz)) * g_Lights_1._m0[_1742].m_vLuminaireVectors.data[1].w);
	                                            _525 = true;
	                                            _526 = _518;
	                                            break;
	                                        }
	                                        default:
	                                        {
	                                            _543 = 0.0;
	                                            _525 = true;
	                                            _526 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                            break;
	                                        }
	                                    }
	                                    if (_525)
	                                    {
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                bool _2671 = !(dot(_361, _526.xyz) > 0.0);
	                                vec3 _2672 = vec3(_291);
	                                vec3 _2675 = transpose(mat3(_324, _323, _2672)) * _526.xyz;
	                                do
	                                {
	                                    if (_2671)
	                                    {
	                                        if ((_285 & 65535u) == 1u)
	                                        {
	                                            _495 = any(greaterThan(vec3(_284.xyz), vec3(0.0)));
	                                        }
	                                        else
	                                        {
	                                            _495 = false;
	                                        }
	                                        if (_495)
	                                        {
	                                            _499 = vec3(_284.xyz);
	                                        }
	                                        else
	                                        {
	                                            _499 = vec3(1.0);
	                                        }
	                                        _498 = _499 * 0.3183098733425140380859375;
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _2684 = vec3(mix(f16vec3(_286), _289, f16vec3(_290)));
	                                        float _2685 = float(_288);
	                                        do
	                                        {
	                                            float _2688 = _2675.z;
	                                            vec3 _2690 = _2675 + _320;
	                                            if (_2688 <= 0.0)
	                                            {
	                                                _497 = true;
	                                            }
	                                            else
	                                            {
	                                                _497 = _320.z <= 0.0;
	                                            }
	                                            if (_497)
	                                            {
	                                                _496 = vec3(0.0);
	                                                break;
	                                            }
	                                            if (all(equal(_2690, vec3(0.0))))
	                                            {
	                                                _496 = vec3(0.0);
	                                                break;
	                                            }
	                                            vec3 _2703 = normalize(_2690);
	                                            float _2704 = _2703.z;
	                                            float _2712 = _2685 * _2685;
	                                            float _2713 = _2712 * _2712;
	                                            float _2717 = (((_2704 * _2713) - _2704) * _2704) + 1.0;
	                                            float _2721 = _2685 * _2685;
	                                            float _2722 = _2721 * _2721;
	                                            _496 = (_2684 + ((vec3(1.0) - _2684) * pow(max(0.0, 1.0 - dot(_2675, _2703)), 5.0))) * (((_2713 / max(9.9999999392252902907785028219223e-09, _2717 * _2717)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_2688 * sqrt(((_320.z - (_2722 * _320.z)) * _320.z) + _2722)) + (_320.z * sqrt(((_2688 - (_2722 * _2688)) * _2688) + _2722))))) * 0.3183098733425140380859375);
	                                            break;
	                                        } while(false);
	                                        _498 = ((vec3(_289) * (1.0 - float(_290))) * 0.3183098733425140380859375) + _496;
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                float _2768 = dot(_2672, _526.xyz);
	                                if (_2671)
	                                {
	                                    _494 = -_2768;
	                                }
	                                else
	                                {
	                                    _494 = _2768;
	                                }
	                                _542 += (((_538 / vec3(_543)) * (_498 * 3.1415927410125732421875)) * max(0.0, _494));
	                            }
	                            _541 = _1744;
	                            break;
	                        } while(false);
	                        if (_1731_ladder_break)
	                        {
	                            break;
	                        }
	                        continue;
	                    }
	                    _539++;
	                    _540 = _542;
	                    continue;
	                }
	                if (_547)
	                {
	                    vec2 _485 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_658.xy, int(1u + (_659 + uint(_570))))))).xy;
	                    vec3 _2791 = (_363 + _362) * 0.5;
	                    float _486 = 0.0;
	                    vec3 _398 = vec3(0.0);
	                    vec3 _397 = vec3(0.0);
	                    vec4 _396 = vec4(0.0);
	                    int _399 = -1;
	                    uvec3 _2796 = min(uvec3(max(fma(_2791, _683, _685), vec3(0.0))), (_680 - uvec3(1u)));
	                    float _487 = 0.0;
	                    uint _488 = 0u;
	                    for (;;)
	                    {
	                        if (!(_488 < _679))
	                        {
	                            break;
	                        }
	                        uint _2809 = _679 * _680.x;
	                        float _490 = _487;
	                        uint _491 = subgroupOr(g_LightBins_1._m0[((((_2809 * _680.y) * _2796.z) + (_2809 * _2796.y)) + (_679 * _2796.x)) + _488]);
	                        for (;;)
	                        {
	                            bool _2829_ladder_break = false;
	                            do
	                            {
	                                if (!(_491 != 0u))
	                                {
	                                    _2829_ladder_break = true;
	                                    break;
	                                }
	                                uint _2836 = _491;
	                                uint _2840 = uint(findLSB(_2836)) + (_488 * 32u);
	                                uint _2842 = _2836 & (_2836 - 1u);
	                                mat4 _2872 = mat4(vec4(g_Lights_1._m0[_2840].m_mToClipSpace.data[0].x, g_Lights_1._m0[_2840].m_mToClipSpace.data[1].x, g_Lights_1._m0[_2840].m_mToClipSpace.data[2].x, g_Lights_1._m0[_2840].m_mToClipSpace.data[3].x), vec4(g_Lights_1._m0[_2840].m_mToClipSpace.data[0].y, g_Lights_1._m0[_2840].m_mToClipSpace.data[1].y, g_Lights_1._m0[_2840].m_mToClipSpace.data[2].y, g_Lights_1._m0[_2840].m_mToClipSpace.data[3].y), vec4(g_Lights_1._m0[_2840].m_mToClipSpace.data[0].z, g_Lights_1._m0[_2840].m_mToClipSpace.data[1].z, g_Lights_1._m0[_2840].m_mToClipSpace.data[2].z, g_Lights_1._m0[_2840].m_mToClipSpace.data[3].z), vec4(g_Lights_1._m0[_2840].m_mToClipSpace.data[0].w, g_Lights_1._m0[_2840].m_mToClipSpace.data[1].w, g_Lights_1._m0[_2840].m_mToClipSpace.data[2].w, g_Lights_1._m0[_2840].m_mToClipSpace.data[3].w));
	                                if ((uint(g_Lights_1._m0[_2840].m_nPathTraceFlags) & 1u) == 0u)
	                                {
	                                    _491 = _2842;
	                                    break;
	                                }
	                                if (!((g_Lights_1._m0[_2840].m_nPathTraceFlags & 8) != 0))
	                                {
	                                    _491 = _2842;
	                                    break;
	                                }
	                                do
	                                {
	                                    do
	                                    {
	                                        vec4 _2948 = _2872 * vec4(_2791.xyz, 1.0);
	                                        vec3 _2952 = _2948.xyz / vec3(_2948.w);
	                                        vec4 _2954;
	                                        _2954.x = _2952.x;
	                                        _2954.y = _2952.y;
	                                        _2954.z = _2952.z;
	                                        if (all(greaterThanEqual(_2954.xyz, vec3(-1.0, -1.0, 0.0))))
	                                        {
	                                            _482 = all(lessThanEqual(_2954.xyz, vec3(1.0)));
	                                        }
	                                        else
	                                        {
	                                            _482 = false;
	                                        }
	                                        if (!_482)
	                                        {
	                                            _483 = false;
	                                            break;
	                                        }
	                                        if (!all(lessThanEqual(abs((mat4x3(vec3(g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[0].x, g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[1].x, g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[2].x), vec3(g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[0].y, g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[1].y, g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[2].y), vec3(g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[0].z, g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[1].z, g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[2].z), vec3(g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[0].w, g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[1].w, g_Lights_1._m0[_2840].m_mBarnIlluminationFromWorld.data[2].w)) * vec4(_2791, 1.0)).xyz), vec3(1.0))))
	                                        {
	                                            _483 = false;
	                                            break;
	                                        }
	                                        _483 = true;
	                                        break;
	                                    } while(false);
	                                    if (!_483)
	                                    {
	                                        _484 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec4 _2986 = _2872 * vec4(_2791.xyz, 1.0);
	                                    vec3 _2990 = _2986.xyz / vec3(_2986.w);
	                                    vec4 _2992;
	                                    _2992.x = _2990.x;
	                                    _2992.y = _2990.y;
	                                    _2992.z = _2990.z;
	                                    if (_1646)
	                                    {
	                                        _481 = g_Lights_1._m0[_2840].m_vBounceColor.xyz;
	                                    }
	                                    else
	                                    {
	                                        _481 = g_Lights_1._m0[_2840].m_vColor.xyz;
	                                    }
	                                    if (true)
	                                    {
	                                        if (g_Lights_1._m0[_2840].m_nCookie >= 0)
	                                        {
	                                            if (g_Lights_1._m0[_2840].m_bSphericalCookie != 0)
	                                            {
	                                                vec4 _3035 = vec4(-g_Lights_1._m0[_2840].m_vOrientation.xyz, g_Lights_1._m0[_2840].m_vOrientation.w);
	                                                vec4 _3037 = _3035.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                                vec3 _3040 = _3037.xyz;
	                                                vec3 _3041 = vec4((-normalize(g_Lights_1._m0[_2840].m_vLightPosition.xyz - _2791)).xyz, 0.0).xyz;
	                                                vec4 _3048 = vec4((_3041 * _3037.w) + cross(_3041, _3040), -dot(_3041, _3040));
	                                                vec3 _3049 = _3048.xyz;
	                                                float _3050 = _3035.w;
	                                                vec3 _3052 = _3035.xyz;
	                                                float _3053 = _3048.w;
	                                                vec3 _3061 = vec4(((_3049 * _3050) + (_3052 * _3053)) + cross(_3052, _3049), _274).xyz;
	                                                vec2 _3070 = vec2(atan(_3061.y, -_3061.x) * 0.15915493667125701904296875, acos(_3061.z) * 0.3183098733425140380859375);
	                                                vec2 _3075 = (_3070.xy * g_Lights_1._m0[_2840].m_vCookieParameters.zw) + g_Lights_1._m0[_2840].m_vCookieParameters.xy;
	                                                vec2 _3077 = _3070;
	                                                _3077.x = _3075.x;
	                                                _3077.y = _3075.y;
	                                                _480 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_2840].m_nCookie], g_Sampler), _3077, 0.0).xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _3014 = fma(_2992.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                                vec2 _3019 = (_3014.xy * g_Lights_1._m0[_2840].m_vCookieParameters.zw) + g_Lights_1._m0[_2840].m_vCookieParameters.xy;
	                                                vec2 _3021 = _3014;
	                                                _3021.x = _3019.x;
	                                                _3021.y = _3019.y;
	                                                _480 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._m0[_2840].m_nCookie], g_CookieSampler), _3021, 0.0).xyz;
	                                            }
	                                        }
	                                        else
	                                        {
	                                            _480 = vec3(1.0);
	                                        }
	                                        _481 *= _480;
	                                    }
	                                    if (g_Lights_1._m0[_2840].m_nLuminaireType != 0)
	                                    {
	                                        _481 = (_481 * g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                    }
	                                    else
	                                    {
	                                        if (!(g_Lights_1._m0[_2840].m_vLightPosition.w == 0.0))
	                                        {
	                                            vec3 _3097 = g_Lights_1._m0[_2840].m_vLightPosition.xyz - _2791;
	                                            _481 *= (vec3(g_Lights_1._m0[_2840].m_vLightPosition.w) / max(vec3(dot(_3097, _3097)), vec3(g_Lights_1._m0[_2840].m_vLightPosition.w)));
	                                        }
	                                    }
	                                    if (g_Lights_1._m0[_2840].m_vDistanceFade_vSkirt.z > 0.0)
	                                    {
	                                        _477 = smoothstep(0.0, 1.0, _2992.xyz.z * g_Lights_1._m0[_2840].m_vDistanceFade_vSkirt.z);
	                                    }
	                                    else
	                                    {
	                                        _477 = 1.0;
	                                    }
	                                    if (g_Lights_1._m0[_2840].m_vDistanceFade_vSkirt.w > 0.0)
	                                    {
	                                        _477 *= smoothstep(0.0, 1.0, (1.0 - _2992.xyz.z) * g_Lights_1._m0[_2840].m_vDistanceFade_vSkirt.w);
	                                    }
	                                    if (!(g_Lights_1._m0[_2840].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _3138 = g_Lights_1._m0[_2840].m_vLightPosition.xyz - _2791;
	                                        float _3139 = length(_3138);
	                                        vec3 _3141 = _3138 / vec3(_3139);
	                                        float _3147 = _477 * smoothstep(0.0, 1.0, g_Lights_1._m0[_2840].m_vDistanceFade_vSkirt.x + (g_Lights_1._m0[_2840].m_vDistanceFade_vSkirt.y * _3139));
	                                        if (g_Lights_1._m0[_2840].m_nLuminaireType != 2)
	                                        {
	                                            _479 = g_Lights_1._m0[_2840].m_nLuminaireType != 1;
	                                        }
	                                        else
	                                        {
	                                            _479 = false;
	                                        }
	                                        if (_479)
	                                        {
	                                            float _3159 = 2.0 * g_Lights_1._m0[_2840].m_vOrientation.x;
	                                            float _3163 = 2.0 * g_Lights_1._m0[_2840].m_vOrientation.w;
	                                            vec3 _3177 = vec3((_3159 * g_Lights_1._m0[_2840].m_vOrientation.y) - (_3163 * g_Lights_1._m0[_2840].m_vOrientation.z), (1.0 - (_3159 * g_Lights_1._m0[_2840].m_vOrientation.x)) - ((2.0 * g_Lights_1._m0[_2840].m_vOrientation.z) * g_Lights_1._m0[_2840].m_vOrientation.z), ((2.0 * g_Lights_1._m0[_2840].m_vOrientation.y) * g_Lights_1._m0[_2840].m_vOrientation.z) + (_3163 * g_Lights_1._m0[_2840].m_vOrientation.x)) * g_Lights_1._m0[_2840].m_vAngleFade.z;
	                                            vec3 _3178 = _3141 - _3177;
	                                            vec3 _3179 = _3141 + _3177;
	                                            do
	                                            {
	                                                vec3 _3182 = _3179 - _3178;
	                                                float _3184 = dot(-_3178, _3182);
	                                                if (_3184 <= 0.0)
	                                                {
	                                                    _475 = _3178;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    float _3189 = dot(_3182, _3182);
	                                                    if (_3184 > _3189)
	                                                    {
	                                                        _475 = _3179;
	                                                        break;
	                                                    }
	                                                    else
	                                                    {
	                                                        _475 = _3178 + (_3182 * (_3184 / _3189));
	                                                        break;
	                                                    }
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (any(notEqual(_475, vec3(0.0))))
	                                            {
	                                                _476 = normalize(_475);
	                                            }
	                                            else
	                                            {
	                                                _476 = _475;
	                                            }
	                                            float _3213 = 2.0 * g_Lights_1._m0[_2840].m_vOrientation.x;
	                                            float _3216 = 2.0 * g_Lights_1._m0[_2840].m_vOrientation.w;
	                                            _478 = _3147 * clamp(g_Lights_1._m0[_2840].m_vAngleFade.x + (g_Lights_1._m0[_2840].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._m0[_2840].m_vOrientation.y) * g_Lights_1._m0[_2840].m_vOrientation.y)) - ((2.0 * g_Lights_1._m0[_2840].m_vOrientation.z) * g_Lights_1._m0[_2840].m_vOrientation.z), (_3213 * g_Lights_1._m0[_2840].m_vOrientation.y) + (_3216 * g_Lights_1._m0[_2840].m_vOrientation.z), (_3213 * g_Lights_1._m0[_2840].m_vOrientation.z) - (_3216 * g_Lights_1._m0[_2840].m_vOrientation.y)), _476)), 0.0, 1.0);
	                                        }
	                                        else
	                                        {
	                                            _478 = _3147;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _478 = _477;
	                                    }
	                                    if (g_Lights_1._m0[_2840].m_nCookie == (-1))
	                                    {
	                                        do
	                                        {
	                                            vec2 _3240 = abs(_2992.xyz.xy);
	                                            if (g_Lights_1._m0[_2840].m_vCookieParameters.z == 0.0)
	                                            {
	                                                _473 = smoothstep(1.0, g_Lights_1._m0[_2840].m_vCookieParameters.x, _3240.x) * smoothstep(1.0, g_Lights_1._m0[_2840].m_vCookieParameters.y, _3240.y);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _3245 = _3240.x;
	                                                float _3249 = _3240.y;
	                                                float _3256 = (-0.5) * g_Lights_1._m0[_2840].m_vCookieParameters.z;
	                                                float _3258 = (g_Lights_1._m0[_2840].m_vCookieParameters.x * g_Lights_1._m0[_2840].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._m0[_2840].m_vCookieParameters.y * _3245, 2.0 / g_Lights_1._m0[_2840].m_vCookieParameters.z) + pow(g_Lights_1._m0[_2840].m_vCookieParameters.x * _3249, 2.0 / g_Lights_1._m0[_2840].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3256);
	                                                float _3265 = pow(max(pow(_3245, 2.0 / g_Lights_1._m0[_2840].m_vCookieParameters.z) + pow(_3249, 2.0 / g_Lights_1._m0[_2840].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3256);
	                                                if (_3258 < _3265)
	                                                {
	                                                    _473 = smoothstep(_3265, _3258, 1.0);
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    if (_3265 > 1.0)
	                                                    {
	                                                        _474 = 1.0;
	                                                    }
	                                                    else
	                                                    {
	                                                        _474 = 0.0;
	                                                    }
	                                                    _473 = _474;
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _478 *= _473;
	                                    }
	                                    _484 = _481 * _478;
	                                    break;
	                                } while(false);
	                                float _3288 = dot(_484.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                if (_3288 == 0.0)
	                                {
	                                    _491 = _2842;
	                                    break;
	                                }
	                                _471 = false;
	                                do
	                                {
	                                    switch (g_Lights_1._m0[_2840].m_nLuminaireType)
	                                    {
	                                        case 0:
	                                        {
	                                            _492 = 1.0;
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2840].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _446 = vec4(normalize(g_Lights_1._m0[_2840].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3754 = g_Lights_1._m0[_2840].m_vLightPosition.xyz - _2791;
	                                                    float _3755 = length(_3754);
	                                                    _446 = vec4(_3754 / vec3(_3755), _3755);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _471 = true;
	                                            _472 = _446;
	                                            break;
	                                        }
	                                        case 1:
	                                        {
	                                            vec3 _3604 = g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].xyz - g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].xyz;
	                                            vec3 _3606 = g_Lights_1._m0[_2840].m_vLuminaireVectors.data[2].xyz - g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].xyz;
	                                            float _3607 = length(_3604);
	                                            float _3608 = length(_3606);
	                                            vec3 _3610 = _3604 / vec3(_3607);
	                                            vec3 _3612 = _3606 / vec3(_3608);
	                                            vec3 _3613 = cross(_3610, _3612);
	                                            vec3 _3614 = g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].xyz - _2791;
	                                            float _3615 = dot(_3614, _3613);
	                                            if (_3615 > 0.0)
	                                            {
	                                                _448 = _3615 * (-1.0);
	                                                _449 = _3613 * (-1.0);
	                                            }
	                                            else
	                                            {
	                                                _448 = _3615;
	                                                _449 = _3613;
	                                            }
	                                            float _3624 = dot(_3614, _3610);
	                                            float _3625 = dot(_3614, _3612);
	                                            float _3626 = _3624 + _3607;
	                                            float _3627 = _3625 + _3608;
	                                            vec3 _3630 = vec3(_3624, _3625, _448);
	                                            vec3 _3631 = vec3(_3624, _3627, _448);
	                                            vec3 _3632 = vec3(_3626, _3625, _448);
	                                            vec3 _3633 = vec3(_3626, _3627, _448);
	                                            vec3 _3635 = normalize(cross(_3630, _3632));
	                                            vec3 _3637 = normalize(cross(_3632, _3633));
	                                            vec3 _3639 = normalize(cross(_3633, _3631));
	                                            vec3 _3641 = normalize(cross(_3631, _3630));
	                                            float _3658 = _3635.z;
	                                            float _3662 = (6.283185482025146484375 - acos(clamp(-dot(_3639, _3641), -1.0, 1.0))) - acos(clamp(-dot(_3641, _3635), -1.0, 1.0));
	                                            float _3664 = (acos(clamp(-dot(_3635, _3637), -1.0, 1.0)) + acos(clamp(-dot(_3637, _3639), -1.0, 1.0))) - _3662;
	                                            if (isnan(_3664))
	                                            {
	                                                _450 = 0.0;
	                                            }
	                                            else
	                                            {
	                                                _450 = _3664;
	                                            }
	                                            float _3672 = (_1680.x * _450) + _3662;
	                                            float _3677 = ((cos(_3672) * _3658) - _3639.z) / sin(_3672);
	                                            if (_3677 > 0.0)
	                                            {
	                                                _451 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _451 = -1.0;
	                                            }
	                                            float _3686 = _451;
	                                            float _3688 = clamp((1.0 / sqrt((_3677 * _3677) + (_3658 * _3658))) * _3686, -1.0, 1.0);
	                                            float _3696 = clamp((-(_3688 * _448)) / sqrt(1.0 - (_3688 * _3688)), _3624, _3626);
	                                            float _3699 = sqrt((_3696 * _3696) + (_448 * _448));
	                                            float _3700 = _3699 * _3699;
	                                            float _3703 = _3625 / sqrt(_3700 + (_3625 * _3625));
	                                            float _3710 = _3703 + (_1680.y * ((_3627 / sqrt(_3700 + (_3627 * _3627))) - _3703));
	                                            float _3711 = _3710 * _3710;
	                                            if (_3711 < 0.99999988079071044921875)
	                                            {
	                                                _451 = (_3710 * _3699) / sqrt(1.0 - _3711);
	                                            }
	                                            else
	                                            {
	                                                _451 = _3627;
	                                            }
	                                            vec3 _3728 = ((_2791 + (_3610 * _3696)) + (_3612 * _451)) + (_449 * _448);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2840].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _447 = vec4(normalize(_3728), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3736 = _3728 - _2791;
	                                                    float _3737 = length(_3736);
	                                                    _447 = vec4(_3736 / vec3(_3737), _3737);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _492 = 1.0 / _450;
	                                            _471 = true;
	                                            _472 = _447;
	                                            break;
	                                        }
	                                        case 2:
	                                        {
	                                            do
	                                            {
	                                                vec2 _3532 = (_1680 * 2.0) - vec2(1.0);
	                                                if (all(equal(_3532, vec2(0.0))))
	                                                {
	                                                    _455 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _3537 = _3532.x;
	                                                float _3539 = _3532.y;
	                                                if (abs(_3537) > abs(_3539))
	                                                {
	                                                    _456 = _3537;
	                                                    _457 = 0.785398185253143310546875 * (_3539 / _3537);
	                                                }
	                                                else
	                                                {
	                                                    _456 = _3539;
	                                                    _457 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3537 / _3539));
	                                                }
	                                                _455 = vec2(cos(_457), sin(_457)) * _456;
	                                                break;
	                                            } while(false);
	                                            vec3 _3565 = (g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].xyz * _455.x)) + (g_Lights_1._m0[_2840].m_vLuminaireVectors.data[2].xyz * _455.y);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2840].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _454 = vec4(normalize(_3565), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3573 = _3565 - _2791;
	                                                    float _3574 = length(_3573);
	                                                    _454 = vec4(_3573 / vec3(_3574), _3574);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_454.w))
	                                            {
	                                                _452 = true;
	                                            }
	                                            else
	                                            {
	                                                _452 = isnan(_454.w);
	                                            }
	                                            if (!_452)
	                                            {
	                                                _453 = _454.w * _454.w;
	                                            }
	                                            else
	                                            {
	                                                _453 = 1.0;
	                                            }
	                                            _492 = _453 / (max(0.0, dot(g_Lights_1._m0[_2840].m_vLuminaireVectors.data[3].xyz, -_454.xyz)) * g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].w);
	                                            _471 = true;
	                                            _472 = _454;
	                                            break;
	                                        }
	                                        case 3:
	                                        {
	                                            vec3 _3431 = g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].xyz - _2791;
	                                            float _3432 = dot(_3431, _3431);
	                                            float _3433 = sqrt(_3432);
	                                            vec3 _3435 = _3431 / vec3(_3433);
	                                            float _3436 = _3435.z;
	                                            if (_3436 >= 0.0)
	                                            {
	                                                _459 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _459 = -1.0;
	                                            }
	                                            float _3443 = (-1.0) / (_459 + _3436);
	                                            float _3444 = _3435.x;
	                                            float _3445 = _3435.y;
	                                            float _3447 = (_3444 * _3445) * _3443;
	                                            vec3 _3452 = _460;
	                                            _3452.x = 1.0 + (((_459 * _3444) * _3444) * _3443);
	                                            _3452.y = _459 * _3447;
	                                            _3452.z = (-_459) * _3444;
	                                            _460 = _3452;
	                                            vec3 _3459 = _461;
	                                            _3459.x = _3447;
	                                            _3459.y = _459 + ((_3445 * _3445) * _3443);
	                                            _3459.z = -_3445;
	                                            _461 = _3459;
	                                            float _3467 = g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].x * g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].x;
	                                            float _3471 = sqrt(max(0.0, 1.0 - (_3467 / _3432)));
	                                            float _3472 = _1680.x;
	                                            float _3475 = (1.0 - _3472) + (_3472 * _3471);
	                                            float _3479 = sqrt(max(0.0, 1.0 - (_3475 * _3475)));
	                                            float _3481 = _1680.y * 6.283185482025146484375;
	                                            float _3483 = _3433 * _3433;
	                                            float _3489 = (_3433 * _3475) - sqrt(max(0.0, _3467 - ((_3483 * _3479) * _3479)));
	                                            float _3495 = ((_3483 + _3467) - (_3489 * _3489)) / ((2.0 * _3433) * g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].x);
	                                            float _3499 = sqrt(max(0.0, 1.0 - (_3495 * _3495)));
	                                            vec3 _3511 = g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].xyz + ((mat3(-_3452, -_3459, -_3435) * vec3(cos(_3481) * _3499, sin(_3481) * _3499, _3495)) * g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].x);
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2840].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _458 = vec4(normalize(_3511), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3519 = _3511 - _2791;
	                                                    float _3520 = length(_3519);
	                                                    _458 = vec4(_3519 / vec3(_3520), _3520);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            _492 = 0.15915493667125701904296875 / (1.0 - _3471);
	                                            _471 = true;
	                                            _472 = _458;
	                                            break;
	                                        }
	                                        case 4:
	                                        case 5:
	                                        {
	                                            vec2 _468 = _1680;
	                                            if (_1680.x < g_Lights_1._m0[_2840].m_vLuminaireVectors.data[4].y)
	                                            {
	                                                vec2 _3332 = _468;
	                                                _3332.x = clamp(_3332.x / g_Lights_1._m0[_2840].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                                _468 = _3332;
	                                                vec3 _3338 = normalize(g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].xyz - g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].xyz);
	                                                if (_3332.x >= 0.5)
	                                                {
	                                                    vec2 _3349 = _468;
	                                                    _3349.x = clamp((2.0 * _3349.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                    _468 = _3349;
	                                                    _469 = -_3338;
	                                                    _470 = g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].xyz;
	                                                }
	                                                else
	                                                {
	                                                    vec2 _3344 = _468;
	                                                    _3344.x = clamp(2.0 * _3344.x, 0.0, 0.99999988079071044921875);
	                                                    _468 = _3344;
	                                                    _469 = _3338;
	                                                    _470 = g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].xyz;
	                                                }
	                                                do
	                                                {
	                                                    vec2 _3360 = (_468 * 2.0) - vec2(1.0);
	                                                    if (all(equal(_3360, vec2(0.0))))
	                                                    {
	                                                        _465 = vec2(0.0);
	                                                        break;
	                                                    }
	                                                    float _3365 = _3360.x;
	                                                    float _3367 = _3360.y;
	                                                    if (abs(_3365) > abs(_3367))
	                                                    {
	                                                        _466 = _3365;
	                                                        _467 = 0.785398185253143310546875 * (_3367 / _3365);
	                                                    }
	                                                    else
	                                                    {
	                                                        _466 = _3367;
	                                                        _467 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3365 / _3367));
	                                                    }
	                                                    _465 = vec2(cos(_467), sin(_467)) * _466;
	                                                    break;
	                                                } while(false);
	                                                _470 += ((g_Lights_1._m0[_2840].m_vLuminaireVectors.data[2].xyz * _465.x) + (g_Lights_1._m0[_2840].m_vLuminaireVectors.data[3].xyz * _465.y));
	                                            }
	                                            else
	                                            {
	                                                vec2 _3311 = _468;
	                                                _3311.x = clamp((_3311.x - g_Lights_1._m0[_2840].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._m0[_2840].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                                _468 = _3311;
	                                                vec3 _3326 = (g_Lights_1._m0[_2840].m_vLuminaireVectors.data[2].xyz * cos(_3311.x * 6.283185482025146484375)) + (g_Lights_1._m0[_2840].m_vLuminaireVectors.data[3].xyz * sin(_3311.x * 6.283185482025146484375));
	                                                _469 = normalize(_3326);
	                                                _470 = mix(g_Lights_1._m0[_2840].m_vLuminaireVectors.data[0].xyz, g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].xyz, vec3(_3311.y)) + _3326;
	                                            }
	                                            do
	                                            {
	                                                if (g_Lights_1._m0[_2840].m_vLightPosition.w == 0.0)
	                                                {
	                                                    _464 = vec4(normalize(_470), uintBitsToFloat(0x7f800000u /* inf */));
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    vec3 _3400 = _470 - _2791;
	                                                    float _3401 = length(_3400);
	                                                    _464 = vec4(_3400 / vec3(_3401), _3401);
	                                                    break;
	                                                }
	                                                break;
	                                            } while(false);
	                                            if (isinf(_464.w))
	                                            {
	                                                _462 = true;
	                                            }
	                                            else
	                                            {
	                                                _462 = isnan(_464.w);
	                                            }
	                                            if (!_462)
	                                            {
	                                                _463 = _464.w * _464.w;
	                                            }
	                                            else
	                                            {
	                                                _463 = 1.0;
	                                            }
	                                            _492 = _463 / (max(0.0, dot(_469, -_464.xyz)) * g_Lights_1._m0[_2840].m_vLuminaireVectors.data[1].w);
	                                            _471 = true;
	                                            _472 = _464;
	                                            break;
	                                        }
	                                        default:
	                                        {
	                                            _492 = 0.0;
	                                            _471 = true;
	                                            _472 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                            break;
	                                        }
	                                    }
	                                    if (_471)
	                                    {
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                float _3773 = dot(vec3(_291), _472.xyz);
	                                if ((!(dot(_361, _472.xyz) > 0.0)) && _546)
	                                {
	                                    _445 = -_3773;
	                                }
	                                else
	                                {
	                                    _445 = _3773;
	                                }
	                                float _3780 = (_3288 / _492) * max(0.0, _445);
	                                float _493 = _485.x;
	                                do
	                                {
	                                    float _3785 = _486;
	                                    float _3786 = _3785 + _3780;
	                                    _486 = _3786;
	                                    if (_3786 == 0.0)
	                                    {
	                                        _444 = false;
	                                        break;
	                                    }
	                                    float _3791 = _3780 / _486;
	                                    do
	                                    {
	                                        if (_3791 <= 0.0)
	                                        {
	                                            _443 = false;
	                                            break;
	                                        }
	                                        if (_3791 >= 1.0)
	                                        {
	                                            _443 = true;
	                                            break;
	                                        }
	                                        if (_493 < _3791)
	                                        {
	                                            _493 = min(_493 / _3791, 0.99999988079071044921875);
	                                            _443 = true;
	                                            break;
	                                        }
	                                        _493 = min((_493 - _3791) / (1.0 - _3791), 0.99999988079071044921875);
	                                        _443 = false;
	                                        break;
	                                    } while(false);
	                                    _444 = _443;
	                                    break;
	                                } while(false);
	                                vec2 _3815 = _485;
	                                _3815.x = _493;
	                                _485 = _3815;
	                                if (_444)
	                                {
	                                    _399 = int(_2840);
	                                    _398 = _484 / vec3(_492);
	                                    _396 = _472;
	                                    _490 = _3780;
	                                }
	                                _491 = _2842;
	                                break;
	                            } while(false);
	                            if (_2829_ladder_break)
	                            {
	                                break;
	                            }
	                            continue;
	                        }
	                        _487 = _490;
	                        _488++;
	                        continue;
	                    }
	                    if (_399 != (-1))
	                    {
	                        vec3 _3836 = _398;
	                        vec3 _3837 = _3836 * (_486 / _487);
	                        _398 = _3837;
	                        bool _3844 = !(dot(_361, _396.xyz) > 0.0);
	                        vec3 _3846 = vec3(_291);
	                        vec3 _3849 = transpose(mat3(_324, _323, _3846)) * _396.xyz;
	                        do
	                        {
	                            if (_3844)
	                            {
	                                if ((_285 & 65535u) == 1u)
	                                {
	                                    _438 = any(greaterThan(vec3(_284.xyz), vec3(0.0)));
	                                }
	                                else
	                                {
	                                    _438 = false;
	                                }
	                                if (_438)
	                                {
	                                    _442 = vec3(_284.xyz);
	                                }
	                                else
	                                {
	                                    _442 = vec3(1.0);
	                                }
	                                _441 = _442 * 0.3183098733425140380859375;
	                                break;
	                            }
	                            else
	                            {
	                                vec3 _3858 = vec3(mix(f16vec3(_286), _289, f16vec3(_290)));
	                                float _3859 = float(_288);
	                                do
	                                {
	                                    float _3862 = _3849.z;
	                                    vec3 _3864 = _3849 + _320;
	                                    if (_3862 <= 0.0)
	                                    {
	                                        _440 = true;
	                                    }
	                                    else
	                                    {
	                                        _440 = _320.z <= 0.0;
	                                    }
	                                    if (_440)
	                                    {
	                                        _439 = vec3(0.0);
	                                        break;
	                                    }
	                                    if (all(equal(_3864, vec3(0.0))))
	                                    {
	                                        _439 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec3 _3877 = normalize(_3864);
	                                    float _3878 = _3877.z;
	                                    float _3886 = _3859 * _3859;
	                                    float _3887 = _3886 * _3886;
	                                    float _3891 = (((_3878 * _3887) - _3878) * _3878) + 1.0;
	                                    float _3895 = _3859 * _3859;
	                                    float _3896 = _3895 * _3895;
	                                    _439 = (_3858 + ((vec3(1.0) - _3858) * pow(max(0.0, 1.0 - dot(_3849, _3877)), 5.0))) * (((_3887 / max(9.9999999392252902907785028219223e-09, _3891 * _3891)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_3862 * sqrt(((_320.z - (_3896 * _320.z)) * _320.z) + _3896)) + (_320.z * sqrt(((_3862 - (_3896 * _3862)) * _3862) + _3896))))) * 0.3183098733425140380859375);
	                                    break;
	                                } while(false);
	                                _441 = ((vec3(_289) * (1.0 - float(_290))) * 0.3183098733425140380859375) + _439;
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        vec3 _3941 = _3837 * (_441 * 3.1415927410125732421875);
	                        _398 = _3941;
	                        float _3944 = dot(_3846, _396.xyz);
	                        if (_3844)
	                        {
	                            _437 = -_3944;
	                        }
	                        else
	                        {
	                            _437 = _3944;
	                        }
	                        _398 = _3941 * max(0.0, _437);
	                        if (_3844)
	                        {
	                            if ((_285 & 65535u) == 2u)
	                            {
	                                _436 = float(_284.x) > 0.0;
	                            }
	                            else
	                            {
	                                _436 = false;
	                            }
	                            _489 = _436;
	                        }
	                        else
	                        {
	                            _489 = false;
	                        }
	                        if (_489)
	                        {
	                            float _3977 = pow(clamp(-dot(normalize(_361 + _3846), _396.xyz), 0.0, 1.0), 2.0);
	                            f16vec3 _3978 = f16vec3(vec3(0.0));
	                            if (isinf(_396.w))
	                            {
	                                _432 = true;
	                            }
	                            else
	                            {
	                                _432 = isnan(_396.w);
	                            }
	                            if (!_432)
	                            {
	                                _433 = _396.w;
	                            }
	                            else
	                            {
	                                _433 = 1000.0;
	                            }
	                            vec3 _402 = _363 + (_396.xyz * _433);
	                            float _401 = 0.0;
	                            vec3 _400 = -_396.xyz;
	                            if (_3977 > 0.0)
	                            {
	                                _434 = _433;
	                            }
	                            else
	                            {
	                                _434 = 0.0;
	                            }
	                            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _403, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_3978, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _3978, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                            traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _402, _401, _400, _434, 0);
	                            if (p._m5 != (-1))
	                            {
	                                if ((p._m7._m6 & 65535u) == 2u)
	                                {
	                                    _431 = float(p._m7._m7.x) > 0.0;
	                                }
	                                else
	                                {
	                                    _431 = false;
	                                }
	                                if (!_431)
	                                {
	                                    _434 = 0.0;
	                                }
	                                else
	                                {
	                                    _434 = _3977;
	                                }
	                                _435 = _433 - p._m3;
	                            }
	                            else
	                            {
	                                _434 = _3977;
	                                _435 = _433;
	                            }
	                            uint _4035 = uint(int(uint(_284.w)));
	                            float _4039 = _435 * float(_284.x);
	                            _397 = (_3837 * vec3(_289)) * ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4035].m_vTransmissiveLogColor.xyz * (1.0 + (_4039 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4035].m_fTransmissiveSaturation))) * exp(-_4039)) * _434);
	                        }
	                    }
	                    vec4 _549 = _396;
	                    if (_399 != (-1))
	                    {
	                        bool _4070 = any(notEqual(_398, vec3(0.0)));
	                        if (isinf(_549.w))
	                        {
	                            _429 = true;
	                        }
	                        else
	                        {
	                            _429 = isnan(_549.w);
	                        }
	                        if (!_429)
	                        {
	                            _430 = _549.w;
	                        }
	                        else
	                        {
	                            _430 = 56755.83984375;
	                        }
	                        vec4 _4086 = _549;
	                        _4086.w = _430;
	                        _549 = _4086;
	                        do
	                        {
	                            float _4093 = dot(_4086.xyz, g_Lights_1._m0[_399].m_vNearPlane.xyz);
	                            if (_4093 == 0.0)
	                            {
	                                _428 = 0.0;
	                                break;
	                            }
	                            _428 = (g_Lights_1._m0[_399].m_vNearPlane.w - dot(_1645, g_Lights_1._m0[_399].m_vNearPlane.xyz)) * (1.0 / _4093);
	                            break;
	                        } while(false);
	                        if (_428 > 0.0)
	                        {
	                            vec4 _4105 = _549;
	                            _4105.w = min(_4105.w, _428);
	                            _549 = _4105;
	                        }
	                        if (dot(_549.xyz, _361.xyz) < 0.0)
	                        {
	                            _548 = _362;
	                        }
	                        else
	                        {
	                            _548 = _363;
	                        }
	                        vec4 _4117 = _549;
	                        vec3 _4119 = _548 - _1645;
	                        _4117.w = _4117.w + dot(_4117.xyz, _4119);
	                        vec3 _4129 = normalize((_4117.xyz * _4117.w) + _4119);
	                        vec4 _4131 = _4117;
	                        _4131.x = _4129.x;
	                        _4131.y = _4129.y;
	                        _4131.z = _4129.z;
	                        _549 = _4131;
	                        do
	                        {
	                            if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 1) != 0)
	                            {
	                                _427 = 32u;
	                                break;
	                            }
	                            if ((g_SceneGlobalInfo._m0[0].m_vBrdfLUTs.z & 2) != 0)
	                            {
	                                _427 = 16u;
	                                break;
	                            }
	                            _427 = 0u;
	                            break;
	                        } while(false);
	                        vec3 _406 = _548;
	                        float _405 = 0.0;
	                        vec3 _404 = _4131.xyz;
	                        if (_4070)
	                        {
	                            _426 = _4131.w;
	                        }
	                        else
	                        {
	                            _426 = 0.0;
	                        }
	                        p_1 = PayloadShadow_t(1.0);
	                        traceRayEXT(g_AccelStruct, _427, 2u, 1u, 2u, 1u, _406, _405, _404, _426, 1);
	                        if (_4070)
	                        {
	                            _426 = p_1.m_flVisibility;
	                        }
	                        else
	                        {
	                            _426 = 0.0;
	                        }
	                        _548 = (_540 + _397) + (_398 * _426);
	                    }
	                    else
	                    {
	                        _548 = _540;
	                    }
	                }
	                else
	                {
	                    _548 = _540;
	                }
	                _369 = _363;
	                _368 = _362;
	                _367 = _361;
	                _366 = _360;
	                _298 = _291;
	                _297 = _290;
	                _296 = _289;
	                _295 = _288;
	                _294 = _286;
	                _293 = _285;
	                _292 = _284;
	                _329 = _324;
	                _328 = _323;
	                _327 = _322;
	                _326 = _321;
	                _325 = _320;
	                vec3 _4200 = vec3(_289);
	                float _4206 = min(0.89999997615814208984375, max(_4200.x, max(_4200.y, _4200.z)));
	                float _576 = _575.x;
	                do
	                {
	                    if (_4206 <= 0.0)
	                    {
	                        _425 = false;
	                        break;
	                    }
	                    if (_4206 >= 1.0)
	                    {
	                        _425 = true;
	                        break;
	                    }
	                    if (_576 < _4206)
	                    {
	                        _576 = min(_576 / _4206, 0.99999988079071044921875);
	                        _425 = true;
	                        break;
	                    }
	                    _576 = min((_576 - _4206) / (1.0 - _4206), 0.99999988079071044921875);
	                    _425 = false;
	                    break;
	                } while(false);
	                vec2 _4231 = _575;
	                _4231.x = _576;
	                _575 = _4231;
	                if (_425)
	                {
	                    do
	                    {
	                        _577 = 1.0;
	                        float _424 = _575.x;
	                        do
	                        {
	                            if (_326 <= 0.0)
	                            {
	                                _422 = false;
	                                break;
	                            }
	                            if (_326 >= 1.0)
	                            {
	                                _422 = true;
	                                break;
	                            }
	                            if (_424 < _326)
	                            {
	                                _424 = min(_424 / _326, 0.99999988079071044921875);
	                                _422 = true;
	                                break;
	                            }
	                            _424 = min((_424 - _326) / (1.0 - _326), 0.99999988079071044921875);
	                            _422 = false;
	                            break;
	                        } while(false);
	                        vec2 _4263 = _575;
	                        _4263.x = _424;
	                        _575 = _4263;
	                        if (_422)
	                        {
	                            _577 = _326;
	                            _423 = true;
	                            break;
	                        }
	                        else
	                        {
	                            _577 = 1.0 - _326;
	                            _423 = false;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    if (_423)
	                    {
	                        _369 = _368;
	                    }
	                    do
	                    {
	                        vec2 _420 = _575;
	                        if (_423)
	                        {
	                            float _4365 = sqrt(_420.y);
	                            float _4367 = 6.283185482025146484375 * _420.x;
	                            vec3 _4375 = vec3(cos(_4367) * _4365, sin(_4367) * _4365, sqrt(max(0.0, 1.0 - _420.y)));
	                            _4375.z = -_4375.z;
	                            _419 = _4375;
	                            break;
	                        }
	                        else
	                        {
	                            float _421 = _420.x;
	                            do
	                            {
	                                if (_327 <= 0.0)
	                                {
	                                    _418 = false;
	                                    break;
	                                }
	                                if (_327 >= 1.0)
	                                {
	                                    _418 = true;
	                                    break;
	                                }
	                                if (_421 < _327)
	                                {
	                                    _421 = min(_421 / _327, 0.99999988079071044921875);
	                                    _418 = true;
	                                    break;
	                                }
	                                _421 = min((_421 - _327) / (1.0 - _327), 0.99999988079071044921875);
	                                _418 = false;
	                                break;
	                            } while(false);
	                            vec2 _4314 = _420;
	                            _4314.x = _421;
	                            _420 = _4314;
	                            if (_418)
	                            {
	                                float _4318 = float(_295);
	                                float _4326 = ((_4318 * _4318) * sqrt(_420.x)) / sqrt(1.0 - _420.x);
	                                float _4329 = 1.0 / (1.0 + (_4326 * _4326));
	                                float _4332 = sqrt(max(0.0, 1.0 - _4329));
	                                float _4335 = 6.283185482025146484375 * _420.y;
	                                vec3 _4340 = vec3(cos(_4335) * _4332, sin(_4335) * _4332, sqrt(_4329));
	                                if (dot(_325, _4340) > 0.0)
	                                {
	                                    _417 = _4340;
	                                }
	                                else
	                                {
	                                    _417 = -_4340;
	                                }
	                                _419 = -reflect(_325, _417);
	                                break;
	                            }
	                            float _4352 = sqrt(_420.y);
	                            float _4354 = 6.283185482025146484375 * _420.x;
	                            _419 = vec3(cos(_4354) * _4352, sin(_4354) * _4352, sqrt(max(0.0, 1.0 - _420.y)));
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    _569 = _419;
	                    vec3 _4381 = normalize(_419 + _325);
	                    float _4382 = _4381.z;
	                    if (_423)
	                    {
	                        _415 = _419.z * (-0.3183098733425140380859375);
	                    }
	                    else
	                    {
	                        if (_327 > 0.0)
	                        {
	                            float _4393 = float(_295);
	                            float _4394 = _4393 * _4393;
	                            float _4395 = _4394 * _4394;
	                            float _4399 = (((_4382 * _4395) - _4382) * _4382) + 1.0;
	                            _414 = 1.0 - _327;
	                            _415 = _327 * (((_4395 / max(9.9999999392252902907785028219223e-09, _4399 * _4399)) * _4382) / (12.56637096405029296875 * max(0.0, dot(_325, _4381))));
	                        }
	                        else
	                        {
	                            _414 = 1.0;
	                            _415 = 0.0;
	                        }
	                        _415 += (_414 * (_419.z * 0.3183098733425140380859375));
	                    }
	                    if (_415 == 0.0)
	                    {
	                        _416 = true;
	                    }
	                    else
	                    {
	                        _416 = isnan(_415);
	                    }
	                    if (_416)
	                    {
	                        _414 = 3.4028234663852885981170418348452e+38;
	                    }
	                    else
	                    {
	                        _414 = _415;
	                    }
	                    float _578 = _414;
	                    do
	                    {
	                        if (_423)
	                        {
	                            if ((_293 & 65535u) == 1u)
	                            {
	                                _409 = any(greaterThan(vec3(_292.xyz), vec3(0.0)));
	                            }
	                            else
	                            {
	                                _409 = false;
	                            }
	                            if (_409)
	                            {
	                                _413 = vec3(_292.xyz);
	                            }
	                            else
	                            {
	                                _413 = vec3(1.0);
	                            }
	                            _412 = _413 * 0.3183098733425140380859375;
	                            break;
	                        }
	                        else
	                        {
	                            vec3 _4436 = vec3(mix(f16vec3(_294), _296, f16vec3(_297)));
	                            float _4437 = float(_295);
	                            do
	                            {
	                                vec3 _4442 = _569 + _325;
	                                if (_569.z <= 0.0)
	                                {
	                                    _411 = true;
	                                }
	                                else
	                                {
	                                    _411 = _325.z <= 0.0;
	                                }
	                                if (_411)
	                                {
	                                    _410 = vec3(0.0);
	                                    break;
	                                }
	                                if (all(equal(_4442, vec3(0.0))))
	                                {
	                                    _410 = vec3(0.0);
	                                    break;
	                                }
	                                vec3 _4455 = normalize(_4442);
	                                float _4456 = _4455.z;
	                                float _4464 = _4437 * _4437;
	                                float _4465 = _4464 * _4464;
	                                float _4469 = (((_4456 * _4465) - _4456) * _4456) + 1.0;
	                                float _4473 = _4437 * _4437;
	                                float _4474 = _4473 * _4473;
	                                _410 = (_4436 + ((vec3(1.0) - _4436) * pow(max(0.0, 1.0 - dot(_569, _4455)), 5.0))) * (((_4465 / max(9.9999999392252902907785028219223e-09, _4469 * _4469)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_569.z * sqrt(((_325.z - (_4474 * _325.z)) * _325.z) + _4474)) + (_325.z * sqrt(((_569.z - (_4474 * _569.z)) * _569.z) + _4474))))) * 0.3183098733425140380859375);
	                                break;
	                            } while(false);
	                            _412 = ((vec3(_296) * (1.0 - float(_297))) * 0.3183098733425140380859375) + _410;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _4518 = _569;
	                    vec3 _4521 = mat3(_329, _328, vec3(_298)) * _4518;
	                    _569 = _4521;
	                    float _4524 = dot(vec3(_298), _4521);
	                    if (_423)
	                    {
	                        _408 = -_4524;
	                    }
	                    else
	                    {
	                        _408 = _4524;
	                    }
	                    do
	                    {
	                        if ((_366 & 1024) != 0)
	                        {
	                            _407 = true;
	                            break;
	                        }
	                        _407 = (dot(_367, _569) > 0.0) != _423;
	                        break;
	                    } while(false);
	                    if (_407)
	                    {
	                        _579 = (_573 * (_412 * max(0.0, _408))) / vec3((_4206 * _577) * _578);
	                    }
	                    else
	                    {
	                        _579 = vec3(0.0);
	                    }
	                    _571 = _579;
	                }
	                else
	                {
	                    _571 = vec3(0.0);
	                }
	                _570++;
	                _572 = (_572 + ((_548 * _573) * _574)) + ((vec3(_287) * _573) * _574);
	                continue;
	            }
	            vIrradiance = (_572 * max(0.0, dot(_856, _854))) * 0.3183098733425140380859375;
	        }
	        else
	        {
	            vIrradiance = vec3(0.0);
	        }
	        vec4 _4568 = g_Samples._m0[nSampleIndex].vIrradiance_flSampleCount;
	        vec3 _4570 = abs(vIrradiance);
	        float _4575 = max(_4570.x, max(_4570.y, _4570.z));
	        vec3 _4586 = mix(_4568.xyz, clamp(vIrradiance / vec3(_4575), vec3(-1.0), vec3(1.0)) * clamp(_4575, -100.0, 100.0), vec3(1.0 / (1.0 + _4568.w)));
	        vec4 _4588 = _4568;
	        _4588.x = _4586.x;
	        _4588.y = _4586.y;
	        _4588.z = _4586.z;
	        _4588.w = _4588.w + 1.0;
	        g_Samples._m0[nSampleIndex].vIrradiance_flSampleCount = _4588;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
