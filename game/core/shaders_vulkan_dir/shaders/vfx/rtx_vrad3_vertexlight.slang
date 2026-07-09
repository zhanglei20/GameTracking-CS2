//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "General shaders for baked lighting preview in Hammer";
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
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (113180 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    f16vec3 vNormalWs;
	    float16_t flMetalness;
	    f16vec3 vAlbedo;
	    float16_t flRoughness;
	    f16vec3 vEmissive;
	    float16_t flReflectance;
	    uint nMaterialTypeAndFlags;
	    f16vec4 vMaterialBits;
	};
	
	struct VertexLightSample_t_natural_logical
	{
	    vec4 vIrradiance_flSampleCount;
	};
	
	struct VertexLightSample_t_natural
	{
	    vec4 vIrradiance_flSampleCount;
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
	
	float _264;
	vec4 _265;
	
	layout(set = 6, binding = 160, std430) buffer RWStructuredBuffer
	{
	    VertexLightSample_t_natural _member0[];
	} g_Samples;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    layout(row_major) SceneGlobalInfoGPU_t_natural _member0[];
	} g_SceneGlobalInfo;
	
	layout(set = 6, binding = 158, std430) buffer g_Triangles
	{
	    float _member0[];
	} g_Triangles_1;
	
	layout(set = 3, binding = 35, std430) readonly buffer g_instanceBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer_1;
	
	layout(set = 6, binding = 161, std430) buffer g_LightBins
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
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D[65536];
	layout(set = 3, binding = 15) uniform sampler g_CookieSampler;
	
	void main()
	{
	    bool _544 = false;
	    bool _598 = false;
	    do
	    {
	        uvec2 vTriangle = gl_LaunchIDEXT.xy / uvec2(4u);
	        uint nSampleIndex = (gl_LaunchIDEXT.x + (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x)) + ((gl_LaunchIDEXT.z * gl_LaunchSizeEXT.x) * gl_LaunchSizeEXT.y);
	        int nTriangle = int(vTriangle.x + ((gl_LaunchSizeEXT.x / 4u) * vTriangle.y));
	        if (nTriangle >= g_PushConstants.m_nTriangleCount_Unused0.x)
	        {
	            break;
	        }
	        vec2 _684 = (vec2((gl_LaunchIDEXT.xy - (vTriangle.xy * uvec2(4u))).xy) + vec2(0.5)) * vec2(0.25);
	        float _686 = sqrt(_684.x);
	        vec3 _691 = vec3(1.0 - _686, _686 * (1.0 - _684.y), _264);
	        if (g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.x == 0)
	        {
	            g_Samples._member0[nSampleIndex].vIrradiance_flSampleCount = vec4(0.0);
	        }
	        else
	        {
	            if (imageLoad(g_TrianglesConverged, ivec3(ivec2(vTriangle), 0)).x != 0u)
	            {
	                break;
	            }
	        }
	        uvec3 _714 = uvec3(imageSize(g_RandomSamples));
	        ivec3 _651;
	        ivec3 _717 = _651;
	        _717.x = int(_714.x);
	        _717.y = int(_714.y);
	        _717.z = int(_714.z);
	        _651 = _717;
	        ivec2 _726 = ivec2(gl_LaunchIDEXT.xy) - _717.xy * (ivec2(gl_LaunchIDEXT.xy) / _717.xy);
	        SceneGlobalInfoGPU_t_natural_logical _730;
	        _730.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	        _730.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	        _730.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	        _730.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	        _730.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	        _730.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	        _730.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	        _730.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	        _730.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	        _730.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	        SceneGlobalInfoGPU_t_natural_logical _735;
	        _735.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	        _735.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	        _735.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	        _735.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	        _735.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	        _735.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	        _735.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	        _735.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	        _735.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	        _735.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	        SceneGlobalInfoGPU_t_natural_logical _740;
	        _740.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	        _740.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	        _740.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	        _740.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	        _740.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	        _740.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	        _740.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	        _740.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	        _740.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	        _740.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	        SceneGlobalInfoGPU_t_natural_logical _745;
	        _745.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	        _745.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	        _745.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	        _745.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	        _745.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	        _745.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	        _745.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	        _745.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	        _745.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	        _745.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	        uvec3 _752 = uvec3(_740.m_vLightBinCellCount_nLightCount.xyz);
	        vec3 _755 = vec3(_752) / (_735.m_vLocalLightMaxBounds.xyz - _730.m_vLocalLightMinBounds.xyz);
	        int _758 = 3 * nTriangle;
	        vec3 v0 = vec3(g_Triangles_1._member0[_758 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._member0[(_758 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._member0[(_758 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        int _776 = _758 + 1;
	        vec3 v1 = vec3(g_Triangles_1._member0[_776 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._member0[(_776 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._member0[(_776 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        int _794 = _758 + 2;
	        vec3 v2 = vec3(g_Triangles_1._member0[_794 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._member0[(_794 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._member0[(_794 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        vec3 _815 = normalize(cross(v1 - v0, v2 - v0));
	        float _816 = _691.x;
	        float _818 = _691.y;
	        vec3 _824 = ((v0 * ((1.0 - _816) - _818)) + (v1 * _816)) + (v2 * _818);
	        f16vec3 _273 = f16vec3(_815);
	        vec3 _399 = _815;
	        vec3 _316;
	        vec3 _652 = _316;
	        vec3 _315;
	        vec3 _653 = _315;
	        float _828 = _815.z;
	        float _650;
	        if (_828 >= 0.0)
	        {
	            _650 = 1.0;
	        }
	        else
	        {
	            _650 = -1.0;
	        }
	        float _835 = (-1.0) / (_650 + _828);
	        float _836 = _815.x;
	        float _837 = _815.y;
	        float _839 = (_836 * _837) * _835;
	        vec3 _844 = _652;
	        _844.x = 1.0 + (((_650 * _836) * _836) * _835);
	        _844.y = _650 * _839;
	        _844.z = (-_650) * _836;
	        _652 = _844;
	        vec3 _851 = _653;
	        _851.x = _839;
	        _851.y = _650 + ((_837 * _837) * _835);
	        _851.z = -_837;
	        _653 = _851;
	        _316 = _844;
	        _315 = _851;
	        f16vec3 _271 = f16vec3(vec3(1.0));
	        float _861 = abs(1.0);
	        vec3 _866 = _824 + (_815 * ((abs(_824) + vec3(_861)) * 9.9999997473787516355514526367188e-05));
	        vec3 _401 = _866;
	        vec2 _871 = imageLoad(g_RandomSamples, ivec3(_726.xy, 1)).xy;
	        bool _654;
	        if (all(greaterThanEqual(_866.xyz, g_PushConstants.m_vCordonMins.xyz)))
	        {
	            _654 = all(lessThanEqual(_401.xyz, g_PushConstants.m_vCordonMaxs.xyz));
	        }
	        else
	        {
	            _654 = false;
	        }
	        vec3 vIrradiance;
	        if (_654)
	        {
	            vec3 _312;
	            float _313;
	            float _314;
	            f16vec4 _267;
	            uint _268;
	            float16_t _269;
	            float16_t _270;
	            float16_t _272;
	            int _398;
	            vec3 _400;
	            ivec2 _397 = _726;
	            uint _396 = uint(g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.y);
	            uint _395 = uint(max(1, ((_745.m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	            uvec3 _394 = _752;
	            vec3 _393 = (-_730.m_vLocalLightMinBounds.xyz) * _755;
	            vec3 _392 = _755;
	            float _908 = _871.y;
	            float _909 = sqrt(_908);
	            float _911 = 6.283185482025146484375 * _871.x;
	            vec3 _919 = vec3(cos(_911) * _909, sin(_911) * _909, sqrt(max(0.0, 1.0 - _908)));
	            vec3 _922 = vec3(_273);
	            vec3 _924 = mat3(_316, _315, _922) * _919;
	            vec3 _639 = _924;
	            vec3 _429 = _401;
	            vec3 _428 = _400;
	            vec3 _427 = _399;
	            int _426 = _398;
	            f16vec3 _295 = _273;
	            float16_t _294 = _272;
	            f16vec3 _293 = _271;
	            float16_t _292 = _270;
	            float16_t _291 = _269;
	            uint _290 = _268;
	            f16vec4 _289 = _267;
	            vec3 _352 = _316;
	            vec3 _351 = _315;
	            float _350 = _314;
	            float _349 = _313;
	            vec3 _348 = _312;
	            int _640 = 1;
	            vec3 _641 = vec3(1.0 / (_919.z * 0.3183098733425140380859375));
	            vec3 _642 = vec3(0.0);
	            vec3 _430;
	            vec3 _446;
	            vec3 _476;
	            bool _481;
	            float _482;
	            bool _483;
	            vec3 _484;
	            bool _485;
	            vec3 _486;
	            vec3 _487;
	            float _488;
	            float _489;
	            bool _490;
	            vec3 _491;
	            bool _492;
	            vec3 _493;
	            bool _496;
	            bool _497;
	            bool _498;
	            float _499;
	            uint _500;
	            float _501;
	            bool _502;
	            float _503;
	            bool _504;
	            bool _505;
	            float _506;
	            float _507;
	            float _508;
	            bool _509;
	            float _510;
	            bool _511;
	            vec3 _512;
	            bool _513;
	            vec3 _514;
	            vec3 _515;
	            bool _516;
	            bool _517;
	            float _518;
	            vec4 _519;
	            vec4 _520;
	            float _521;
	            vec3 _522;
	            float _523;
	            float _524;
	            bool _525;
	            float _526;
	            vec4 _527;
	            vec2 _528;
	            float _529;
	            float _530;
	            vec4 _531;
	            float _532;
	            vec3 _533;
	            vec3 _534;
	            bool _535;
	            float _536;
	            vec4 _537;
	            vec2 _538;
	            float _539;
	            float _540;
	            vec3 _542;
	            vec3 _543;
	            vec4 _545;
	            float _546;
	            float _547;
	            vec3 _548;
	            vec3 _549;
	            float _550;
	            float _551;
	            bool _552;
	            vec3 _553;
	            vec3 _554;
	            bool _555;
	            bool _556;
	            vec3 _557;
	            float _564;
	            bool _566;
	            float _567;
	            bool _568;
	            vec3 _569;
	            bool _570;
	            vec3 _571;
	            vec3 _572;
	            vec4 _573;
	            vec4 _574;
	            float _575;
	            vec3 _576;
	            float _577;
	            float _578;
	            bool _579;
	            float _580;
	            vec4 _581;
	            vec2 _582;
	            float _583;
	            float _584;
	            vec4 _585;
	            float _586;
	            vec3 _587;
	            vec3 _588;
	            bool _589;
	            float _590;
	            vec4 _591;
	            vec2 _592;
	            float _593;
	            float _594;
	            vec3 _596;
	            vec3 _597;
	            vec4 _599;
	            float _600;
	            float _601;
	            vec3 _602;
	            vec3 _603;
	            float _604;
	            float _605;
	            bool _606;
	            vec3 _607;
	            vec3 _608;
	            bool _609;
	            bool _610;
	            vec3 _611;
	            float _616;
	            bool _617;
	            bool _618;
	            bool _619;
	            vec3 _621;
	            float _623;
	            float _624;
	            bool _627;
	            float _628;
	            float _629;
	            bool _632;
	            bool _633;
	            bool _635;
	            vec3 _637;
	            vec3 _638;
	            vec3 _643;
	            float _644;
	            float _647;
	            vec3 _649;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_640 <= 16))
	                {
	                    break;
	                }
	                SPIRV_CROSS_FLATTEN
	                if (false)
	                {
	                    SPIRV_CROSS_FLATTEN
	                    if (_640 > (-1))
	                    {
	                        _644 = 1.0;
	                        _643 = vec3(0.0);
	                    }
	                    else
	                    {
	                        if (_640 != (-1))
	                        {
	                            _644 = 0.0;
	                        }
	                        else
	                        {
	                            _644 = 1.0;
	                        }
	                        _643 = _641;
	                    }
	                }
	                else
	                {
	                    _644 = 1.0;
	                    _643 = _641;
	                }
	                if (all(equal(_643, vec3(0.0))))
	                {
	                    break;
	                }
	                vec3 _425 = _429;
	                vec3 _424 = _639;
	                vec2 _968 = imageLoad(g_RandomSamples, ivec3(_397.xy, int(1u + uint(_640)))).xy;
	                f16vec3 _970 = f16vec3(vec3(0.0));
	                vec2 _976 = _968;
	                _976.y = 0.0;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _430, 3.4028234663852885981170418348452e+38, _968.y, -1, false, MaterialDataMinimal_t(_970, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _970, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 4u, 0u, 2u, 0u, _429, 0.0, _639, 56755.83984375, 0);
	                Payload_t _978 = p;
	                vec2 _980 = _968;
	                _980.y = _978.flOpacityRng;
	                vec2 _645 = _980;
	                if (!(_978.nInstance != (-1)))
	                {
	                    vec2 _996 = imageLoad(g_RandomSamples, ivec3(_397.xy, int(1u + uint(_640 + 1)))).xy;
	                    _645 = _996;
	                    vec2 _634 = _996;
	                    if (_639.z < 0.0)
	                    {
	                        float _636 = _634.y;
	                        do
	                        {
	                            if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w <= 0.0)
	                            {
	                                _633 = false;
	                                break;
	                            }
	                            if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w >= 1.0)
	                            {
	                                _633 = true;
	                                break;
	                            }
	                            if (_636 < g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w)
	                            {
	                                _636 = min(_636 / g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                                _633 = true;
	                                break;
	                            }
	                            _636 = min((_636 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                            _633 = false;
	                            break;
	                        } while(false);
	                        vec2 _1032 = _634;
	                        _1032.y = _636;
	                        _634 = _1032;
	                        _635 = _633;
	                    }
	                    else
	                    {
	                        _635 = false;
	                    }
	                    if (_635)
	                    {
	                        float _1040 = sqrt(_634.y);
	                        float _1042 = 6.283185482025146484375 * _634.x;
	                        _637 = vec3(cos(_1042) * _1040, sin(_1042) * _1040, sqrt(max(0.0, 1.0 - _634.y)));
	                        _638 = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.xyz;
	                    }
	                    else
	                    {
	                        _637 = _639;
	                        _638 = vec3(0.0);
	                    }
	                    if (g_SceneGlobalInfo._member0[0].m_vIBLParams.y >= 0)
	                    {
	                        vec4 _1088 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._member0[0].m_vIBLParams.y], g_Sampler), normalize(g_SceneGlobalInfo._member0[0].m_mIBLTransformI * vec4(_637, 0.0)), 0.0);
	                        if (dot(_1088.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.w)
	                        {
	                            _638 += (g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.xyz * _1088.xyz);
	                        }
	                    }
	                    else
	                    {
	                        _638 += g_SceneGlobalInfo._member0[0].m_vSkyColor.xyz;
	                    }
	                    if (_640 > 1)
	                    {
	                        _638 *= g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.w;
	                    }
	                    if (_635)
	                    {
	                        _638 *= g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.xyz;
	                    }
	                    _642 += ((_643 * _638) * _644);
	                    break;
	                }
	                uint _1123 = uint(_978.nInstance);
	                PackedRtxInstanceData_t_natural_logical _1126;
	                _1126.nSrgbColor = g_instanceBuffer_1._member0[_1123].nSrgbColor;
	                _1126.nTriangleGeometry = g_instanceBuffer_1._member0[_1123].nTriangleGeometry;
	                _1126.nMaterialData = g_instanceBuffer_1._member0[_1123].nMaterialData;
	                _1126.nMaterialFlags_nInstanceFlags = g_instanceBuffer_1._member0[_1123].nMaterialFlags_nInstanceFlags;
	                _1126.fEmissiveBoost = g_instanceBuffer_1._member0[_1123].fEmissiveBoost;
	                _1126.nInstanceFlags = g_instanceBuffer_1._member0[_1123].nInstanceFlags;
	                _1126._pad1 = g_instanceBuffer_1._member0[_1123]._pad1;
	                _1126._pad2 = g_instanceBuffer_1._member0[_1123]._pad2;
	                uint _431 = _1126.nMaterialFlags_nInstanceFlags;
	                if ((int((_431 >> uint(16)) & 65535u) & 4) != 0)
	                {
	                    break;
	                }
	                vec3 _419 = _425;
	                vec3 _418 = _424;
	                vec3 _417 = _978.vSmoothPositionWs;
	                vec3 _416 = _978.vFaceNormalWs;
	                float _415 = _978.flHitT;
	                f16vec3 _342 = _978.material.vNormalWs;
	                float16_t _341 = _978.material.flMetalness;
	                f16vec3 _340 = _978.material.vAlbedo;
	                float16_t _339 = _978.material.flRoughness;
	                f16vec3 _338 = _978.material.vEmissive;
	                float16_t _337 = _978.material.flReflectance;
	                uint _336 = _978.material.nMaterialTypeAndFlags;
	                f16vec4 _335 = _978.material.vMaterialBits;
	                uint _1154 = uint(_978.nInstance);
	                PackedRtxInstanceData_t_natural_logical _1157;
	                _1157.nSrgbColor = g_instanceBuffer_1._member0[_1154].nSrgbColor;
	                _1157.nTriangleGeometry = g_instanceBuffer_1._member0[_1154].nTriangleGeometry;
	                _1157.nMaterialData = g_instanceBuffer_1._member0[_1154].nMaterialData;
	                _1157.nMaterialFlags_nInstanceFlags = g_instanceBuffer_1._member0[_1154].nMaterialFlags_nInstanceFlags;
	                _1157.fEmissiveBoost = g_instanceBuffer_1._member0[_1154].fEmissiveBoost;
	                _1157.nInstanceFlags = g_instanceBuffer_1._member0[_1154].nInstanceFlags;
	                _1157._pad1 = g_instanceBuffer_1._member0[_1154]._pad1;
	                _1157._pad2 = g_instanceBuffer_1._member0[_1154]._pad2;
	                uint _437 = _1157.nMaterialFlags_nInstanceFlags;
	                float _436 = _1157.fEmissiveBoost;
	                vec3 _435 = (_419 + (_418 * _415)) + (_416 * ((abs(_419) + vec3(abs(_415))) * 9.9999997473787516355514526367188e-05));
	                vec3 _434 = (_419 + (_418 * _415)) + ((-_416) * ((abs(_419) + vec3(abs(_415))) * 9.9999997473787516355514526367188e-05));
	                vec3 _433 = _416;
	                int _432 = int(_437 & 65535u);
	                vec3 _442 = vec3(0.0);
	                vec3 _441 = vec3(0.0);
	                float _440 = 0.0;
	                float _439 = 0.0;
	                vec3 _438 = vec3(0.0);
	                f16vec3 _365 = _342;
	                float16_t _364 = _341;
	                f16vec3 _363 = _340;
	                f16vec3 _361 = _338;
	                float16_t _360 = _337;
	                uint _359 = _336;
	                f16vec4 _358 = _335;
	                float16_t _362 = float16_t(max(float(_339), 0.07999999821186065673828125));
	                vec3 _1202 = vec3(_342);
	                vec3 _630 = vec3(0.0);
	                vec3 _631 = vec3(0.0);
	                float _1203 = _1202.z;
	                if (_1203 >= 0.0)
	                {
	                    _629 = 1.0;
	                }
	                else
	                {
	                    _629 = -1.0;
	                }
	                float _1210 = (-1.0) / (_629 + _1203);
	                float _1211 = _1202.x;
	                float _1212 = _1202.y;
	                float _1214 = (_1211 * _1212) * _1210;
	                vec3 _1219 = _630;
	                _1219.x = 1.0 + (((_629 * _1211) * _1211) * _1210);
	                _1219.y = _629 * _1214;
	                _1219.z = (-_629) * _1211;
	                _630 = _1219;
	                vec3 _1226 = _631;
	                _1226.x = _1214;
	                _1226.y = _629 + ((_1212 * _1212) * _1210);
	                _1226.z = -_1212;
	                _631 = _1226;
	                _442 = _1219;
	                _441 = _1226;
	                vec3 _1238 = transpose(mat3(_1219, _1226, vec3(_365))) * (-_418);
	                _438 = _1238;
	                vec3 _1246 = vec3(mix(f16vec3(_360), _363, f16vec3(_364)));
	                _440 = dot((_1246 + ((vec3(1.0) - _1246) * pow(max(0.0, 1.0 - _1238.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                if ((_359 & 65535u) == 1u)
	                {
	                    float _1265 = dot(vec3(_358.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                    _439 = _1265 / max(9.9999997473787516355514526367188e-05, _1265 + dot(vec3(_363).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                }
	                f16vec3 _303 = _365;
	                float16_t _302 = _364;
	                f16vec3 _301 = _363;
	                float16_t _300 = _362;
	                f16vec3 _299 = _361;
	                float16_t _298 = _360;
	                uint _297 = _359;
	                f16vec4 _296 = _358;
	                vec3 _357 = _442;
	                vec3 _356 = _441;
	                float _355 = _440;
	                float _354 = _439;
	                vec3 _353 = _438;
	                if (true)
	                {
	                    if ((_432 & 256) != 0)
	                    {
	                        _299 *= float16_t(_436);
	                    }
	                    else
	                    {
	                        _299 = f16vec3(vec3(0.0));
	                    }
	                }
	                if (true)
	                {
	                    _632 = any(notEqual(_417, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _632 = false;
	                }
	                vec3 _1306 = _417 - _435;
	                float _1307 = length(_1306);
	                vec3 _445 = _435;
	                float _444 = 0.0;
	                vec3 _443 = vec4(_1306 / vec3(_1307), _1307).xyz;
	                if (_632)
	                {
	                    _628 = _1307;
	                }
	                else
	                {
	                    _628 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _445, _444, _443, _628, 1);
	                if (_632)
	                {
	                    _628 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _628 = 0.0;
	                }
	                if (_628 == 1.0)
	                {
	                    _435 = _417;
	                    _433 = vec3(_342);
	                }
	                vec3 _423 = _435;
	                vec3 _422 = _434;
	                vec3 _421 = _433;
	                int _420 = _432;
	                f16vec3 _288 = _303;
	                float16_t _287 = _302;
	                f16vec3 _286 = _301;
	                float16_t _285 = _300;
	                f16vec3 _284 = _299;
	                float16_t _283 = _298;
	                uint _282 = _297;
	                f16vec4 _281 = _296;
	                vec3 _347 = _357;
	                vec3 _346 = _356;
	                float _345 = _355;
	                float _344 = _354;
	                vec3 _343 = _353;
	                if (!(dot(_433, -_639) > 0.0))
	                {
	                    if ((_420 & 1024) != 0)
	                    {
	                        _421 = -_421;
	                        _288 = -_288;
	                        vec3 _1608 = _429;
	                        _429 = _428;
	                        _428 = _1608;
	                    }
	                    else
	                    {
	                        vec2 _1374 = imageLoad(g_RandomSamples, ivec3(_397.xy, int(1u + uint(_640)))).xy;
	                        f16vec3 _1376 = f16vec3(vec3(0.0));
	                        vec2 _1382 = _1374;
	                        _1382.y = 0.0;
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _446, 3.4028234663852885981170418348452e+38, _1374.y, -1, false, MaterialDataMinimal_t(_1376, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1376, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 4u, 0u, 2u, 0u, _425, _978.flHitT * 0.99989998340606689453125, _424, _978.flHitT * 1.00010001659393310546875, 0);
	                        vec2 _1388 = _1374;
	                        _1388.y = p.flOpacityRng;
	                        _645 = _1388;
	                        if (p.nInstance != (-1))
	                        {
	                            vec3 _414 = _425;
	                            vec3 _413 = _424;
	                            vec3 _412 = p.vSmoothPositionWs;
	                            vec3 _411 = p.vFaceNormalWs;
	                            float _410 = p.flHitT;
	                            f16vec3 _334 = p.material.vNormalWs;
	                            float16_t _333 = p.material.flMetalness;
	                            f16vec3 _332 = p.material.vAlbedo;
	                            float16_t _331 = p.material.flRoughness;
	                            f16vec3 _330 = p.material.vEmissive;
	                            float16_t _329 = p.material.flReflectance;
	                            uint _328 = p.material.nMaterialTypeAndFlags;
	                            f16vec4 _327 = p.material.vMaterialBits;
	                            uint _1409 = uint(p.nInstance);
	                            PackedRtxInstanceData_t_natural_logical _1412;
	                            _1412.nSrgbColor = g_instanceBuffer_1._member0[_1409].nSrgbColor;
	                            _1412.nTriangleGeometry = g_instanceBuffer_1._member0[_1409].nTriangleGeometry;
	                            _1412.nMaterialData = g_instanceBuffer_1._member0[_1409].nMaterialData;
	                            _1412.nMaterialFlags_nInstanceFlags = g_instanceBuffer_1._member0[_1409].nMaterialFlags_nInstanceFlags;
	                            _1412.fEmissiveBoost = g_instanceBuffer_1._member0[_1409].fEmissiveBoost;
	                            _1412.nInstanceFlags = g_instanceBuffer_1._member0[_1409].nInstanceFlags;
	                            _1412._pad1 = g_instanceBuffer_1._member0[_1409]._pad1;
	                            _1412._pad2 = g_instanceBuffer_1._member0[_1409]._pad2;
	                            uint _452 = _1412.nMaterialFlags_nInstanceFlags;
	                            float _451 = _1412.fEmissiveBoost;
	                            vec3 _450 = (_414 + (_413 * _410)) + (_411 * ((abs(_414) + vec3(abs(_410))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _449 = (_414 + (_413 * _410)) + ((-_411) * ((abs(_414) + vec3(abs(_410))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _448 = _411;
	                            int _447 = int(_452 & 65535u);
	                            vec3 _457 = vec3(0.0);
	                            vec3 _456 = vec3(0.0);
	                            float _455 = 0.0;
	                            float _454 = 0.0;
	                            vec3 _453 = vec3(0.0);
	                            f16vec3 _378 = _334;
	                            float16_t _377 = _333;
	                            f16vec3 _376 = _332;
	                            f16vec3 _374 = _330;
	                            float16_t _373 = _329;
	                            uint _372 = _328;
	                            f16vec4 _371 = _327;
	                            float16_t _375 = float16_t(max(float(_331), 0.07999999821186065673828125));
	                            vec3 _1457 = vec3(_334);
	                            vec3 _625 = vec3(0.0);
	                            vec3 _626 = vec3(0.0);
	                            float _1458 = _1457.z;
	                            if (_1458 >= 0.0)
	                            {
	                                _624 = 1.0;
	                            }
	                            else
	                            {
	                                _624 = -1.0;
	                            }
	                            float _1465 = (-1.0) / (_624 + _1458);
	                            float _1466 = _1457.x;
	                            float _1467 = _1457.y;
	                            float _1469 = (_1466 * _1467) * _1465;
	                            vec3 _1474 = _625;
	                            _1474.x = 1.0 + (((_624 * _1466) * _1466) * _1465);
	                            _1474.y = _624 * _1469;
	                            _1474.z = (-_624) * _1466;
	                            _625 = _1474;
	                            vec3 _1481 = _626;
	                            _1481.x = _1469;
	                            _1481.y = _624 + ((_1467 * _1467) * _1465);
	                            _1481.z = -_1467;
	                            _626 = _1481;
	                            _457 = _1474;
	                            _456 = _1481;
	                            vec3 _1493 = transpose(mat3(_1474, _1481, vec3(_378))) * (-_413);
	                            _453 = _1493;
	                            vec3 _1501 = vec3(mix(f16vec3(_373), _376, f16vec3(_377)));
	                            _455 = dot((_1501 + ((vec3(1.0) - _1501) * pow(max(0.0, 1.0 - _1493.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if ((_372 & 65535u) == 1u)
	                            {
	                                float _1520 = dot(vec3(_371.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                _454 = _1520 / max(9.9999997473787516355514526367188e-05, _1520 + dot(vec3(_376).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                            }
	                            f16vec3 _311 = _378;
	                            float16_t _310 = _377;
	                            f16vec3 _309 = _376;
	                            float16_t _308 = _375;
	                            f16vec3 _307 = _374;
	                            float16_t _306 = _373;
	                            uint _305 = _372;
	                            f16vec4 _304 = _371;
	                            vec3 _370 = _457;
	                            vec3 _369 = _456;
	                            float _368 = _455;
	                            float _367 = _454;
	                            vec3 _366 = _453;
	                            if (true)
	                            {
	                                if ((_447 & 256) != 0)
	                                {
	                                    _307 *= float16_t(_451);
	                                }
	                                else
	                                {
	                                    _307 = f16vec3(vec3(0.0));
	                                }
	                            }
	                            if (true)
	                            {
	                                _627 = any(notEqual(_412, vec3(3.4028234663852885981170418348452e+38)));
	                            }
	                            else
	                            {
	                                _627 = false;
	                            }
	                            vec3 _1561 = _412 - _450;
	                            float _1562 = length(_1561);
	                            vec3 _460 = _450;
	                            float _459 = 0.0;
	                            vec3 _458 = vec4(_1561 / vec3(_1562), _1562).xyz;
	                            if (_627)
	                            {
	                                _623 = _1562;
	                            }
	                            else
	                            {
	                                _623 = 0.0;
	                            }
	                            p_1 = PayloadShadow_t(1.0);
	                            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _460, _459, _458, _623, 1);
	                            if (_627)
	                            {
	                                _623 = p_1.m_flVisibility;
	                            }
	                            else
	                            {
	                                _623 = 0.0;
	                            }
	                            if (_623 == 1.0)
	                            {
	                                _450 = _412;
	                                _448 = vec3(_334);
	                            }
	                            _423 = _450;
	                            _422 = _449;
	                            _421 = _448;
	                            _420 = _447;
	                            _288 = _311;
	                            _287 = _310;
	                            _286 = _309;
	                            _285 = _308;
	                            _284 = _307;
	                            _283 = _306;
	                            _282 = _305;
	                            _281 = _304;
	                            _347 = _370;
	                            _346 = _369;
	                            _345 = _368;
	                            _344 = _367;
	                            _343 = _366;
	                        }
	                        else
	                        {
	                            break;
	                        }
	                    }
	                }
	                vec3 _409 = _423;
	                vec3 _408 = _422;
	                vec3 _407 = _421;
	                f16vec3 _280 = _288;
	                float16_t _279 = _287;
	                f16vec3 _278 = _286;
	                float16_t _277 = _285;
	                float16_t _276 = _283;
	                uint _275 = _282;
	                f16vec4 _274 = _281;
	                vec3 _326 = _347;
	                vec3 _325 = _346;
	                vec3 _324 = _343;
	                vec3 _1625 = (_423 + _422) * 0.5;
	                bool _1626 = _640 != 0;
	                f16vec4 _462 = _281;
	                if ((_282 & 65535u) == 1u)
	                {
	                    _618 = any(greaterThan(vec3(_462.xyz), vec3(0.0)));
	                }
	                else
	                {
	                    _618 = false;
	                }
	                if (_618)
	                {
	                    _619 = true;
	                }
	                else
	                {
	                    f16vec4 _461 = _274;
	                    if ((_275 & 65535u) == 2u)
	                    {
	                        _617 = float(_461.x) > 0.0;
	                    }
	                    else
	                    {
	                        _617 = false;
	                    }
	                    _619 = _617;
	                }
	                vec2 _1664 = imageLoad(g_RandomSamples, ivec3(_397.xy, int(1u + ((2u * _396) + uint(_640))))).xy;
	                bool _620 = false;
	                vec3 _1677 = (_409 + _408) * 0.5;
	                uvec3 _1685 = min(uvec3(max(fma(_1677, _392, _393), vec3(0.0))), (_394 - uvec3(1u)));
	                uint _612 = 0u;
	                vec3 _613 = vec3(0.0);
	                for (;;)
	                {
	                    if (!(_612 < _395))
	                    {
	                        break;
	                    }
	                    uint _1701 = _395 * _394.x;
	                    uint _614 = subgroupOr(g_LightBins_1._member0[((((_1701 * _394.y) * _1685.z) + (_1701 * _1685.y)) + (_395 * _1685.x)) + _612]);
	                    vec3 _615 = _613;
	                    for (;;)
	                    {
	                        if (!(_614 != 0u))
	                        {
	                            break;
	                        }
	                        uint _1725 = _614;
	                        uint _1729 = uint(findLSB(_1725)) + (_612 * 32u);
	                        uint _1731 = _1725 & (_1725 - 1u);
	                        if ((uint(g_Lights_1._member0[_1729].m_nPathTraceFlags) & 1u) == 0u)
	                        {
	                            _614 = _1731;
	                            continue;
	                        }
	                        if ((g_Lights_1._member0[_1729].m_nPathTraceFlags & 8) != 0)
	                        {
	                            _620 = true;
	                            _614 = _1731;
	                            continue;
	                        }
	                        do
	                        {
	                            do
	                            {
	                                vec4 _1757 = g_Lights_1._member0[_1729].m_mToClipSpace * vec4(_1677.xyz, 1.0);
	                                vec3 _1761 = _1757.xyz / vec3(_1757.w);
	                                vec4 _1763;
	                                _1763.x = _1761.x;
	                                _1763.y = _1761.y;
	                                _1763.z = _1761.z;
	                                if (all(greaterThanEqual(_1763.xyz, vec3(-1.0, -1.0, 0.0))))
	                                {
	                                    _609 = all(lessThanEqual(_1763.xyz, vec3(1.0)));
	                                }
	                                else
	                                {
	                                    _609 = false;
	                                }
	                                if (!_609)
	                                {
	                                    _610 = false;
	                                    break;
	                                }
	                                if (!all(lessThanEqual(abs((g_Lights_1._member0[_1729].m_mBarnIlluminationFromWorld * vec4(_1677, 1.0)).xyz), vec3(1.0))))
	                                {
	                                    _610 = false;
	                                    break;
	                                }
	                                _610 = true;
	                                break;
	                            } while(false);
	                            if (!_610)
	                            {
	                                _611 = vec3(0.0);
	                                break;
	                            }
	                            vec4 _1800 = g_Lights_1._member0[_1729].m_mToClipSpace * vec4(_1677.xyz, 1.0);
	                            vec3 _1804 = _1800.xyz / vec3(_1800.w);
	                            vec4 _1806;
	                            _1806.x = _1804.x;
	                            _1806.y = _1804.y;
	                            _1806.z = _1804.z;
	                            if (_1626)
	                            {
	                                _608 = g_Lights_1._member0[_1729].m_vBounceColor.xyz;
	                            }
	                            else
	                            {
	                                _608 = g_Lights_1._member0[_1729].m_vColor.xyz;
	                            }
	                            if (true)
	                            {
	                                if (g_Lights_1._member0[_1729].m_nCookie >= 0)
	                                {
	                                    if (g_Lights_1._member0[_1729].m_bSphericalCookie != 0)
	                                    {
	                                        vec4 _1866 = vec4(-g_Lights_1._member0[_1729].m_vOrientation.xyz, g_Lights_1._member0[_1729].m_vOrientation.w);
	                                        vec4 _1868 = _1866.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                        vec3 _1871 = _1868.xyz;
	                                        vec3 _1872 = vec4((-normalize(g_Lights_1._member0[_1729].m_vLightPosition.xyz - _1677)).xyz, 0.0).xyz;
	                                        vec4 _1879 = vec4((_1872 * _1868.w) + cross(_1872, _1871), -dot(_1872, _1871));
	                                        vec3 _1880 = _1879.xyz;
	                                        float _1881 = _1866.w;
	                                        vec3 _1883 = _1866.xyz;
	                                        float _1884 = _1879.w;
	                                        vec3 _1892 = vec4(((_1880 * _1881) + (_1883 * _1884)) + cross(_1883, _1880), _264).xyz;
	                                        vec2 _1901 = vec2(atan(_1892.y, -_1892.x) * 0.15915493667125701904296875, acos(_1892.z) * 0.3183098733425140380859375);
	                                        vec2 _1908 = (_1901.xy * g_Lights_1._member0[_1729].m_vCookieParameters.zw) + g_Lights_1._member0[_1729].m_vCookieParameters.xy;
	                                        vec2 _1910 = _1901;
	                                        _1910.x = _1908.x;
	                                        _1910.y = _1908.y;
	                                        _607 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_1729].m_nCookie], g_Sampler), _1910, 0.0).xyz;
	                                    }
	                                    else
	                                    {
	                                        vec2 _1837 = fma(_1806.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                        vec2 _1844 = (_1837.xy * g_Lights_1._member0[_1729].m_vCookieParameters.zw) + g_Lights_1._member0[_1729].m_vCookieParameters.xy;
	                                        vec2 _1846 = _1837;
	                                        _1846.x = _1844.x;
	                                        _1846.y = _1844.y;
	                                        _607 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_1729].m_nCookie], g_CookieSampler), _1846, 0.0).xyz;
	                                    }
	                                }
	                                else
	                                {
	                                    _607 = vec3(1.0);
	                                }
	                                _608 *= _607;
	                            }
	                            if (g_Lights_1._member0[_1729].m_nLuminaireType != 0)
	                            {
	                                _608 = (_608 * g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                            }
	                            else
	                            {
	                                if (!(g_Lights_1._member0[_1729].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _1939 = g_Lights_1._member0[_1729].m_vLightPosition.xyz - _1677;
	                                    _608 *= (vec3(g_Lights_1._member0[_1729].m_vLightPosition.w) / max(vec3(dot(_1939, _1939)), vec3(g_Lights_1._member0[_1729].m_vLightPosition.w)));
	                                }
	                            }
	                            if (g_Lights_1._member0[_1729].m_vDistanceFade_vSkirt.z > 0.0)
	                            {
	                                _604 = smoothstep(0.0, 1.0, _1806.xyz.z * g_Lights_1._member0[_1729].m_vDistanceFade_vSkirt.z);
	                            }
	                            else
	                            {
	                                _604 = 1.0;
	                            }
	                            if (g_Lights_1._member0[_1729].m_vDistanceFade_vSkirt.w > 0.0)
	                            {
	                                _604 *= smoothstep(0.0, 1.0, (1.0 - _1806.xyz.z) * g_Lights_1._member0[_1729].m_vDistanceFade_vSkirt.w);
	                            }
	                            if (!(g_Lights_1._member0[_1729].m_vLightPosition.w == 0.0))
	                            {
	                                vec3 _1993 = g_Lights_1._member0[_1729].m_vLightPosition.xyz - _1677;
	                                float _1994 = length(_1993);
	                                vec3 _1996 = _1993 / vec3(_1994);
	                                float _2005 = _604 * smoothstep(0.0, 1.0, g_Lights_1._member0[_1729].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_1729].m_vDistanceFade_vSkirt.y * _1994));
	                                if (g_Lights_1._member0[_1729].m_nLuminaireType != 2)
	                                {
	                                    _606 = g_Lights_1._member0[_1729].m_nLuminaireType != 1;
	                                }
	                                else
	                                {
	                                    _606 = false;
	                                }
	                                if (_606)
	                                {
	                                    float _2024 = 2.0 * g_Lights_1._member0[_1729].m_vOrientation.x;
	                                    float _2028 = 2.0 * g_Lights_1._member0[_1729].m_vOrientation.w;
	                                    vec3 _2042 = vec3((_2024 * g_Lights_1._member0[_1729].m_vOrientation.y) - (_2028 * g_Lights_1._member0[_1729].m_vOrientation.z), (1.0 - (_2024 * g_Lights_1._member0[_1729].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_1729].m_vOrientation.z) * g_Lights_1._member0[_1729].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_1729].m_vOrientation.y) * g_Lights_1._member0[_1729].m_vOrientation.z) + (_2028 * g_Lights_1._member0[_1729].m_vOrientation.x)) * g_Lights_1._member0[_1729].m_vAngleFade.z;
	                                    vec3 _2043 = _1996 - _2042;
	                                    vec3 _2044 = _1996 + _2042;
	                                    do
	                                    {
	                                        vec3 _2047 = _2044 - _2043;
	                                        float _2049 = dot(-_2043, _2047);
	                                        if (_2049 <= 0.0)
	                                        {
	                                            _602 = _2043;
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _2054 = dot(_2047, _2047);
	                                            if (_2049 > _2054)
	                                            {
	                                                _602 = _2044;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                _602 = _2043 + (_2047 * (_2049 / _2054));
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (any(notEqual(_602, vec3(0.0))))
	                                    {
	                                        _603 = normalize(_602);
	                                    }
	                                    else
	                                    {
	                                        _603 = _602;
	                                    }
	                                    float _2078 = 2.0 * g_Lights_1._member0[_1729].m_vOrientation.x;
	                                    float _2081 = 2.0 * g_Lights_1._member0[_1729].m_vOrientation.w;
	                                    _605 = _2005 * clamp(g_Lights_1._member0[_1729].m_vAngleFade.x + (g_Lights_1._member0[_1729].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_1729].m_vOrientation.y) * g_Lights_1._member0[_1729].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_1729].m_vOrientation.z) * g_Lights_1._member0[_1729].m_vOrientation.z), (_2078 * g_Lights_1._member0[_1729].m_vOrientation.y) + (_2081 * g_Lights_1._member0[_1729].m_vOrientation.z), (_2078 * g_Lights_1._member0[_1729].m_vOrientation.z) - (_2081 * g_Lights_1._member0[_1729].m_vOrientation.y)), _603)), 0.0, 1.0);
	                                }
	                                else
	                                {
	                                    _605 = _2005;
	                                }
	                            }
	                            else
	                            {
	                                _605 = _604;
	                            }
	                            if (g_Lights_1._member0[_1729].m_nCookie == (-1))
	                            {
	                                do
	                                {
	                                    vec2 _2110 = abs(_1806.xyz.xy);
	                                    if (g_Lights_1._member0[_1729].m_vCookieParameters.z == 0.0)
	                                    {
	                                        _600 = smoothstep(1.0, g_Lights_1._member0[_1729].m_vCookieParameters.x, _2110.x) * smoothstep(1.0, g_Lights_1._member0[_1729].m_vCookieParameters.y, _2110.y);
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        float _2115 = _2110.x;
	                                        float _2119 = _2110.y;
	                                        float _2126 = (-0.5) * g_Lights_1._member0[_1729].m_vCookieParameters.z;
	                                        float _2128 = (g_Lights_1._member0[_1729].m_vCookieParameters.x * g_Lights_1._member0[_1729].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_1729].m_vCookieParameters.y * _2115, 2.0 / g_Lights_1._member0[_1729].m_vCookieParameters.z) + pow(g_Lights_1._member0[_1729].m_vCookieParameters.x * _2119, 2.0 / g_Lights_1._member0[_1729].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2126);
	                                        float _2135 = pow(max(pow(_2115, 2.0 / g_Lights_1._member0[_1729].m_vCookieParameters.z) + pow(_2119, 2.0 / g_Lights_1._member0[_1729].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2126);
	                                        if (_2128 < _2135)
	                                        {
	                                            _600 = smoothstep(_2135, _2128, 1.0);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            if (_2135 > 1.0)
	                                            {
	                                                _601 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _601 = 0.0;
	                                            }
	                                            _600 = _601;
	                                            break;
	                                        }
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _605 *= _600;
	                            }
	                            _611 = _608 * _605;
	                            break;
	                        } while(false);
	                        SPIRV_CROSS_BRANCH
	                        if (any(greaterThan(_611, vec3(0.0))))
	                        {
	                            _598 = false;
	                            do
	                            {
	                                switch (g_Lights_1._member0[_1729].m_nLuminaireType)
	                                {
	                                    case 0:
	                                    {
	                                        _616 = 1.0;
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1729].m_vLightPosition.w == 0.0)
	                                            {
	                                                _573 = vec4(normalize(g_Lights_1._member0[_1729].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2683 = g_Lights_1._member0[_1729].m_vLightPosition.xyz - _1677;
	                                                float _2684 = length(_2683);
	                                                _573 = vec4(_2683 / vec3(_2684), _2684);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _598 = true;
	                                        _599 = _573;
	                                        break;
	                                    }
	                                    case 1:
	                                    {
	                                        vec3 _2523 = g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].xyz;
	                                        vec3 _2527 = g_Lights_1._member0[_1729].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].xyz;
	                                        float _2528 = length(_2523);
	                                        float _2529 = length(_2527);
	                                        vec3 _2531 = _2523 / vec3(_2528);
	                                        vec3 _2533 = _2527 / vec3(_2529);
	                                        vec3 _2534 = cross(_2531, _2533);
	                                        vec3 _2535 = g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].xyz - _1677;
	                                        float _2536 = dot(_2535, _2534);
	                                        if (_2536 > 0.0)
	                                        {
	                                            _575 = _2536 * (-1.0);
	                                            _576 = _2534 * (-1.0);
	                                        }
	                                        else
	                                        {
	                                            _575 = _2536;
	                                            _576 = _2534;
	                                        }
	                                        float _2545 = dot(_2535, _2531);
	                                        float _2546 = dot(_2535, _2533);
	                                        float _2547 = _2545 + _2528;
	                                        float _2548 = _2546 + _2529;
	                                        vec3 _2551 = vec3(_2545, _2546, _575);
	                                        vec3 _2552 = vec3(_2545, _2548, _575);
	                                        vec3 _2553 = vec3(_2547, _2546, _575);
	                                        vec3 _2554 = vec3(_2547, _2548, _575);
	                                        vec3 _2556 = normalize(cross(_2551, _2553));
	                                        vec3 _2558 = normalize(cross(_2553, _2554));
	                                        vec3 _2560 = normalize(cross(_2554, _2552));
	                                        vec3 _2562 = normalize(cross(_2552, _2551));
	                                        float _2579 = _2556.z;
	                                        float _2583 = (6.283185482025146484375 - acos(clamp(-dot(_2560, _2562), -1.0, 1.0))) - acos(clamp(-dot(_2562, _2556), -1.0, 1.0));
	                                        float _2585 = (acos(clamp(-dot(_2556, _2558), -1.0, 1.0)) + acos(clamp(-dot(_2558, _2560), -1.0, 1.0))) - _2583;
	                                        if (isnan(_2585))
	                                        {
	                                            _577 = 0.0;
	                                        }
	                                        else
	                                        {
	                                            _577 = _2585;
	                                        }
	                                        float _2593 = (_1664.x * _577) + _2583;
	                                        float _2598 = ((cos(_2593) * _2579) - _2560.z) / sin(_2593);
	                                        if (_2598 > 0.0)
	                                        {
	                                            _578 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _578 = -1.0;
	                                        }
	                                        float _2607 = _578;
	                                        float _2609 = clamp((1.0 / sqrt((_2598 * _2598) + (_2579 * _2579))) * _2607, -1.0, 1.0);
	                                        float _2617 = clamp((-(_2609 * _575)) / sqrt(1.0 - (_2609 * _2609)), _2545, _2547);
	                                        float _2620 = sqrt((_2617 * _2617) + (_575 * _575));
	                                        float _2621 = _2620 * _2620;
	                                        float _2624 = _2546 / sqrt(_2621 + (_2546 * _2546));
	                                        float _2631 = _2624 + (_1664.y * ((_2548 / sqrt(_2621 + (_2548 * _2548))) - _2624));
	                                        float _2632 = _2631 * _2631;
	                                        if (_2632 < 0.99999988079071044921875)
	                                        {
	                                            _578 = (_2631 * _2620) / sqrt(1.0 - _2632);
	                                        }
	                                        else
	                                        {
	                                            _578 = _2548;
	                                        }
	                                        vec3 _2649 = ((_1677 + (_2531 * _2617)) + (_2533 * _578)) + (_576 * _575);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1729].m_vLightPosition.w == 0.0)
	                                            {
	                                                _574 = vec4(normalize(_2649), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2660 = _2649 - _1677;
	                                                float _2661 = length(_2660);
	                                                _574 = vec4(_2660 / vec3(_2661), _2661);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _616 = 1.0 / _577;
	                                        _598 = true;
	                                        _599 = _574;
	                                        break;
	                                    }
	                                    case 2:
	                                    {
	                                        do
	                                        {
	                                            vec2 _2431 = (_1664 * 2.0) - vec2(1.0);
	                                            if (all(equal(_2431, vec2(0.0))))
	                                            {
	                                                _582 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _2436 = _2431.x;
	                                            float _2438 = _2431.y;
	                                            if (abs(_2436) > abs(_2438))
	                                            {
	                                                _583 = _2436;
	                                                _584 = 0.785398185253143310546875 * (_2438 / _2436);
	                                            }
	                                            else
	                                            {
	                                                _583 = _2438;
	                                                _584 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2436 / _2438));
	                                            }
	                                            _582 = vec2(cos(_584), sin(_584)) * _583;
	                                            break;
	                                        } while(false);
	                                        vec3 _2472 = (g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].xyz * _582.x)) + (g_Lights_1._member0[_1729].m_vLuminaireVectors.data[2].xyz * _582.y);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1729].m_vLightPosition.w == 0.0)
	                                            {
	                                                _581 = vec4(normalize(_2472), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2483 = _2472 - _1677;
	                                                float _2484 = length(_2483);
	                                                _581 = vec4(_2483 / vec3(_2484), _2484);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_581.w))
	                                        {
	                                            _579 = true;
	                                        }
	                                        else
	                                        {
	                                            _579 = isnan(_581.w);
	                                        }
	                                        if (!_579)
	                                        {
	                                            _580 = _581.w * _581.w;
	                                        }
	                                        else
	                                        {
	                                            _580 = 1.0;
	                                        }
	                                        _616 = _580 / (max(0.0, dot(g_Lights_1._member0[_1729].m_vLuminaireVectors.data[3].xyz, -_581.xyz)) * g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].w);
	                                        _598 = true;
	                                        _599 = _581;
	                                        break;
	                                    }
	                                    case 3:
	                                    {
	                                        vec3 _2326 = g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].xyz - _1677;
	                                        float _2327 = dot(_2326, _2326);
	                                        float _2328 = sqrt(_2327);
	                                        vec3 _2330 = _2326 / vec3(_2328);
	                                        float _2331 = _2330.z;
	                                        if (_2331 >= 0.0)
	                                        {
	                                            _586 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _586 = -1.0;
	                                        }
	                                        float _2338 = (-1.0) / (_586 + _2331);
	                                        float _2339 = _2330.x;
	                                        float _2340 = _2330.y;
	                                        float _2342 = (_2339 * _2340) * _2338;
	                                        vec3 _2347 = _587;
	                                        _2347.x = 1.0 + (((_586 * _2339) * _2339) * _2338);
	                                        _2347.y = _586 * _2342;
	                                        _2347.z = (-_586) * _2339;
	                                        _587 = _2347;
	                                        vec3 _2354 = _588;
	                                        _2354.x = _2342;
	                                        _2354.y = _586 + ((_2340 * _2340) * _2338);
	                                        _2354.z = -_2340;
	                                        _588 = _2354;
	                                        float _2362 = g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].x;
	                                        float _2366 = sqrt(max(0.0, 1.0 - (_2362 / _2327)));
	                                        float _2367 = _1664.x;
	                                        float _2370 = (1.0 - _2367) + (_2367 * _2366);
	                                        float _2374 = sqrt(max(0.0, 1.0 - (_2370 * _2370)));
	                                        float _2376 = _1664.y * 6.283185482025146484375;
	                                        float _2378 = _2328 * _2328;
	                                        float _2384 = (_2328 * _2370) - sqrt(max(0.0, _2362 - ((_2378 * _2374) * _2374)));
	                                        float _2390 = ((_2378 + _2362) - (_2384 * _2384)) / ((2.0 * _2328) * g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].x);
	                                        float _2394 = sqrt(max(0.0, 1.0 - (_2390 * _2390)));
	                                        vec3 _2406 = g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].xyz + ((mat3(-_2347, -_2354, -_2330) * vec3(cos(_2376) * _2394, sin(_2376) * _2394, _2390)) * g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].x);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1729].m_vLightPosition.w == 0.0)
	                                            {
	                                                _585 = vec4(normalize(_2406), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2417 = _2406 - _1677;
	                                                float _2418 = length(_2417);
	                                                _585 = vec4(_2417 / vec3(_2418), _2418);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _616 = 0.15915493667125701904296875 / (1.0 - _2366);
	                                        _598 = true;
	                                        _599 = _585;
	                                        break;
	                                    }
	                                    case 4:
	                                    case 5:
	                                    {
	                                        vec2 _595 = _1664;
	                                        if (_1664.x < g_Lights_1._member0[_1729].m_vLuminaireVectors.data[4].y)
	                                        {
	                                            vec2 _2217 = _595;
	                                            _2217.x = clamp(_2217.x / g_Lights_1._member0[_1729].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                            _595 = _2217;
	                                            vec3 _2223 = normalize(g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].xyz);
	                                            if (_2217.x >= 0.5)
	                                            {
	                                                vec2 _2234 = _595;
	                                                _2234.x = clamp((2.0 * _2234.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                _595 = _2234;
	                                                _596 = -_2223;
	                                                _597 = g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _2229 = _595;
	                                                _2229.x = clamp(2.0 * _2229.x, 0.0, 0.99999988079071044921875);
	                                                _595 = _2229;
	                                                _596 = _2223;
	                                                _597 = g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].xyz;
	                                            }
	                                            do
	                                            {
	                                                vec2 _2245 = (_595 * 2.0) - vec2(1.0);
	                                                if (all(equal(_2245, vec2(0.0))))
	                                                {
	                                                    _592 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _2250 = _2245.x;
	                                                float _2252 = _2245.y;
	                                                if (abs(_2250) > abs(_2252))
	                                                {
	                                                    _593 = _2250;
	                                                    _594 = 0.785398185253143310546875 * (_2252 / _2250);
	                                                }
	                                                else
	                                                {
	                                                    _593 = _2252;
	                                                    _594 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2250 / _2252));
	                                                }
	                                                _592 = vec2(cos(_594), sin(_594)) * _593;
	                                                break;
	                                            } while(false);
	                                            _597 += ((g_Lights_1._member0[_1729].m_vLuminaireVectors.data[2].xyz * _592.x) + (g_Lights_1._member0[_1729].m_vLuminaireVectors.data[3].xyz * _592.y));
	                                        }
	                                        else
	                                        {
	                                            vec2 _2196 = _595;
	                                            _2196.x = clamp((_2196.x - g_Lights_1._member0[_1729].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_1729].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                            _595 = _2196;
	                                            vec3 _2211 = (g_Lights_1._member0[_1729].m_vLuminaireVectors.data[2].xyz * cos(_2196.x * 6.283185482025146484375)) + (g_Lights_1._member0[_1729].m_vLuminaireVectors.data[3].xyz * sin(_2196.x * 6.283185482025146484375));
	                                            _596 = normalize(_2211);
	                                            _597 = mix(g_Lights_1._member0[_1729].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].xyz, vec3(_2196.y)) + _2211;
	                                        }
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1729].m_vLightPosition.w == 0.0)
	                                            {
	                                                _591 = vec4(normalize(_597), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2288 = _597 - _1677;
	                                                float _2289 = length(_2288);
	                                                _591 = vec4(_2288 / vec3(_2289), _2289);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_591.w))
	                                        {
	                                            _589 = true;
	                                        }
	                                        else
	                                        {
	                                            _589 = isnan(_591.w);
	                                        }
	                                        if (!_589)
	                                        {
	                                            _590 = _591.w * _591.w;
	                                        }
	                                        else
	                                        {
	                                            _590 = 1.0;
	                                        }
	                                        _616 = _590 / (max(0.0, dot(_596, -_591.xyz)) * g_Lights_1._member0[_1729].m_vLuminaireVectors.data[1].w);
	                                        _598 = true;
	                                        _599 = _591;
	                                        break;
	                                    }
	                                    default:
	                                    {
	                                        _616 = 0.0;
	                                        _598 = true;
	                                        _599 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                        break;
	                                    }
	                                }
	                                if (_598)
	                                {
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            bool _2701 = !(dot(_407, _599.xyz) > 0.0);
	                            vec3 _2703 = vec3(_280);
	                            vec3 _2708 = transpose(mat3(_326, _325, _2703)) * _599.xyz;
	                            float16_t _384 = _279;
	                            f16vec3 _383 = _278;
	                            float16_t _382 = _277;
	                            float16_t _381 = _276;
	                            uint _380 = _275;
	                            f16vec4 _379 = _274;
	                            vec3 _463 = _324;
	                            do
	                            {
	                                if (_2701)
	                                {
	                                    f16vec4 _464 = _379;
	                                    if ((_380 & 65535u) == 1u)
	                                    {
	                                        _568 = any(greaterThan(vec3(_464.xyz), vec3(0.0)));
	                                    }
	                                    else
	                                    {
	                                        _568 = false;
	                                    }
	                                    if (_568)
	                                    {
	                                        _572 = vec3(_379.xyz);
	                                    }
	                                    else
	                                    {
	                                        _572 = vec3(1.0);
	                                    }
	                                    _571 = _572 * 0.3183098733425140380859375;
	                                    break;
	                                }
	                                else
	                                {
	                                    vec3 _2728 = vec3(mix(f16vec3(_381), _383, f16vec3(_384)));
	                                    float _2730 = float(_382);
	                                    do
	                                    {
	                                        float _2733 = _2708.z;
	                                        vec3 _2735 = _2708 + _463;
	                                        if (_2733 <= 0.0)
	                                        {
	                                            _570 = true;
	                                        }
	                                        else
	                                        {
	                                            _570 = _463.z <= 0.0;
	                                        }
	                                        if (_570)
	                                        {
	                                            _569 = vec3(0.0);
	                                            break;
	                                        }
	                                        if (all(equal(_2735, vec3(0.0))))
	                                        {
	                                            _569 = vec3(0.0);
	                                            break;
	                                        }
	                                        vec3 _2748 = normalize(_2735);
	                                        float _2749 = _2748.z;
	                                        float _2757 = _2730 * _2730;
	                                        float _2758 = _2757 * _2757;
	                                        float _2762 = (((_2749 * _2758) - _2749) * _2749) + 1.0;
	                                        float _2766 = _2730 * _2730;
	                                        float _2767 = _2766 * _2766;
	                                        _569 = (_2728 + ((vec3(1.0) - _2728) * pow(max(0.0, 1.0 - dot(_2708, _2748)), 5.0))) * (((_2758 / max(9.9999999392252902907785028219223e-09, _2762 * _2762)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_2733 * sqrt(((_463.z - (_2767 * _463.z)) * _463.z) + _2767)) + (_463.z * sqrt(((_2733 - (_2767 * _2733)) * _2733) + _2767))))) * 0.3183098733425140380859375);
	                                        break;
	                                    } while(false);
	                                    _571 = ((vec3(_383) * (1.0 - float(_384))) * 0.3183098733425140380859375) + _569;
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            float _2819 = dot(_2703, _599.xyz);
	                            if (_2701)
	                            {
	                                _567 = -_2819;
	                            }
	                            else
	                            {
	                                _567 = _2819;
	                            }
	                            _615 += (((_611 / vec3(_616)) * (_571 * 3.1415927410125732421875)) * max(0.0, _567));
	                        }
	                        _614 = _1731;
	                        continue;
	                    }
	                    _612++;
	                    _613 = _615;
	                    continue;
	                }
	                if (_620)
	                {
	                    vec2 _558 = imageLoad(g_RandomSamples, ivec3(_397.xy, int(1u + (_396 + uint(_640))))).xy;
	                    vec3 _2843 = (_409 + _408) * 0.5;
	                    float _559 = 0.0;
	                    vec3 _469 = vec3(0.0);
	                    vec3 _468 = vec3(0.0);
	                    vec4 _467 = vec4(0.0);
	                    int _470 = -1;
	                    uvec3 _2851 = min(uvec3(max(fma(_2843, _392, _393), vec3(0.0))), (_394 - uvec3(1u)));
	                    float _560 = 0.0;
	                    uint _561 = 0u;
	                    for (;;)
	                    {
	                        if (!(_561 < _395))
	                        {
	                            break;
	                        }
	                        uint _2867 = _395 * _394.x;
	                        float _562 = _560;
	                        uint _563 = subgroupOr(g_LightBins_1._member0[((((_2867 * _394.y) * _2851.z) + (_2867 * _2851.y)) + (_395 * _2851.x)) + _561]);
	                        for (;;)
	                        {
	                            if (!(_563 != 0u))
	                            {
	                                break;
	                            }
	                            uint _2891 = _563;
	                            uint _2895 = uint(findLSB(_2891)) + (_561 * 32u);
	                            uint _2897 = _2891 & (_2891 - 1u);
	                            if ((uint(g_Lights_1._member0[_2895].m_nPathTraceFlags) & 1u) == 0u)
	                            {
	                                _563 = _2897;
	                                continue;
	                            }
	                            if (!((g_Lights_1._member0[_2895].m_nPathTraceFlags & 8) != 0))
	                            {
	                                _563 = _2897;
	                                continue;
	                            }
	                            do
	                            {
	                                do
	                                {
	                                    vec4 _2924 = g_Lights_1._member0[_2895].m_mToClipSpace * vec4(_2843.xyz, 1.0);
	                                    vec3 _2928 = _2924.xyz / vec3(_2924.w);
	                                    vec4 _2930;
	                                    _2930.x = _2928.x;
	                                    _2930.y = _2928.y;
	                                    _2930.z = _2928.z;
	                                    if (all(greaterThanEqual(_2930.xyz, vec3(-1.0, -1.0, 0.0))))
	                                    {
	                                        _555 = all(lessThanEqual(_2930.xyz, vec3(1.0)));
	                                    }
	                                    else
	                                    {
	                                        _555 = false;
	                                    }
	                                    if (!_555)
	                                    {
	                                        _556 = false;
	                                        break;
	                                    }
	                                    if (!all(lessThanEqual(abs((g_Lights_1._member0[_2895].m_mBarnIlluminationFromWorld * vec4(_2843, 1.0)).xyz), vec3(1.0))))
	                                    {
	                                        _556 = false;
	                                        break;
	                                    }
	                                    _556 = true;
	                                    break;
	                                } while(false);
	                                if (!_556)
	                                {
	                                    _557 = vec3(0.0);
	                                    break;
	                                }
	                                vec4 _2967 = g_Lights_1._member0[_2895].m_mToClipSpace * vec4(_2843.xyz, 1.0);
	                                vec3 _2971 = _2967.xyz / vec3(_2967.w);
	                                vec4 _2973;
	                                _2973.x = _2971.x;
	                                _2973.y = _2971.y;
	                                _2973.z = _2971.z;
	                                if (_1626)
	                                {
	                                    _554 = g_Lights_1._member0[_2895].m_vBounceColor.xyz;
	                                }
	                                else
	                                {
	                                    _554 = g_Lights_1._member0[_2895].m_vColor.xyz;
	                                }
	                                if (true)
	                                {
	                                    if (g_Lights_1._member0[_2895].m_nCookie >= 0)
	                                    {
	                                        if (g_Lights_1._member0[_2895].m_bSphericalCookie != 0)
	                                        {
	                                            vec4 _3033 = vec4(-g_Lights_1._member0[_2895].m_vOrientation.xyz, g_Lights_1._member0[_2895].m_vOrientation.w);
	                                            vec4 _3035 = _3033.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                            vec3 _3038 = _3035.xyz;
	                                            vec3 _3039 = vec4((-normalize(g_Lights_1._member0[_2895].m_vLightPosition.xyz - _2843)).xyz, 0.0).xyz;
	                                            vec4 _3046 = vec4((_3039 * _3035.w) + cross(_3039, _3038), -dot(_3039, _3038));
	                                            vec3 _3047 = _3046.xyz;
	                                            float _3048 = _3033.w;
	                                            vec3 _3050 = _3033.xyz;
	                                            float _3051 = _3046.w;
	                                            vec3 _3059 = vec4(((_3047 * _3048) + (_3050 * _3051)) + cross(_3050, _3047), _264).xyz;
	                                            vec2 _3068 = vec2(atan(_3059.y, -_3059.x) * 0.15915493667125701904296875, acos(_3059.z) * 0.3183098733425140380859375);
	                                            vec2 _3075 = (_3068.xy * g_Lights_1._member0[_2895].m_vCookieParameters.zw) + g_Lights_1._member0[_2895].m_vCookieParameters.xy;
	                                            vec2 _3077 = _3068;
	                                            _3077.x = _3075.x;
	                                            _3077.y = _3075.y;
	                                            _553 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_2895].m_nCookie], g_Sampler), _3077, 0.0).xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _3004 = fma(_2973.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                            vec2 _3011 = (_3004.xy * g_Lights_1._member0[_2895].m_vCookieParameters.zw) + g_Lights_1._member0[_2895].m_vCookieParameters.xy;
	                                            vec2 _3013 = _3004;
	                                            _3013.x = _3011.x;
	                                            _3013.y = _3011.y;
	                                            _553 = textureLod(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_2895].m_nCookie], g_CookieSampler), _3013, 0.0).xyz;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _553 = vec3(1.0);
	                                    }
	                                    _554 *= _553;
	                                }
	                                if (g_Lights_1._member0[_2895].m_nLuminaireType != 0)
	                                {
	                                    _554 = (_554 * g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                }
	                                else
	                                {
	                                    if (!(g_Lights_1._member0[_2895].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _3106 = g_Lights_1._member0[_2895].m_vLightPosition.xyz - _2843;
	                                        _554 *= (vec3(g_Lights_1._member0[_2895].m_vLightPosition.w) / max(vec3(dot(_3106, _3106)), vec3(g_Lights_1._member0[_2895].m_vLightPosition.w)));
	                                    }
	                                }
	                                if (g_Lights_1._member0[_2895].m_vDistanceFade_vSkirt.z > 0.0)
	                                {
	                                    _550 = smoothstep(0.0, 1.0, _2973.xyz.z * g_Lights_1._member0[_2895].m_vDistanceFade_vSkirt.z);
	                                }
	                                else
	                                {
	                                    _550 = 1.0;
	                                }
	                                if (g_Lights_1._member0[_2895].m_vDistanceFade_vSkirt.w > 0.0)
	                                {
	                                    _550 *= smoothstep(0.0, 1.0, (1.0 - _2973.xyz.z) * g_Lights_1._member0[_2895].m_vDistanceFade_vSkirt.w);
	                                }
	                                if (!(g_Lights_1._member0[_2895].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _3160 = g_Lights_1._member0[_2895].m_vLightPosition.xyz - _2843;
	                                    float _3161 = length(_3160);
	                                    vec3 _3163 = _3160 / vec3(_3161);
	                                    float _3172 = _550 * smoothstep(0.0, 1.0, g_Lights_1._member0[_2895].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_2895].m_vDistanceFade_vSkirt.y * _3161));
	                                    if (g_Lights_1._member0[_2895].m_nLuminaireType != 2)
	                                    {
	                                        _552 = g_Lights_1._member0[_2895].m_nLuminaireType != 1;
	                                    }
	                                    else
	                                    {
	                                        _552 = false;
	                                    }
	                                    if (_552)
	                                    {
	                                        float _3191 = 2.0 * g_Lights_1._member0[_2895].m_vOrientation.x;
	                                        float _3195 = 2.0 * g_Lights_1._member0[_2895].m_vOrientation.w;
	                                        vec3 _3209 = vec3((_3191 * g_Lights_1._member0[_2895].m_vOrientation.y) - (_3195 * g_Lights_1._member0[_2895].m_vOrientation.z), (1.0 - (_3191 * g_Lights_1._member0[_2895].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_2895].m_vOrientation.z) * g_Lights_1._member0[_2895].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_2895].m_vOrientation.y) * g_Lights_1._member0[_2895].m_vOrientation.z) + (_3195 * g_Lights_1._member0[_2895].m_vOrientation.x)) * g_Lights_1._member0[_2895].m_vAngleFade.z;
	                                        vec3 _3210 = _3163 - _3209;
	                                        vec3 _3211 = _3163 + _3209;
	                                        do
	                                        {
	                                            vec3 _3214 = _3211 - _3210;
	                                            float _3216 = dot(-_3210, _3214);
	                                            if (_3216 <= 0.0)
	                                            {
	                                                _548 = _3210;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _3221 = dot(_3214, _3214);
	                                                if (_3216 > _3221)
	                                                {
	                                                    _548 = _3211;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    _548 = _3210 + (_3214 * (_3216 / _3221));
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (any(notEqual(_548, vec3(0.0))))
	                                        {
	                                            _549 = normalize(_548);
	                                        }
	                                        else
	                                        {
	                                            _549 = _548;
	                                        }
	                                        float _3245 = 2.0 * g_Lights_1._member0[_2895].m_vOrientation.x;
	                                        float _3248 = 2.0 * g_Lights_1._member0[_2895].m_vOrientation.w;
	                                        _551 = _3172 * clamp(g_Lights_1._member0[_2895].m_vAngleFade.x + (g_Lights_1._member0[_2895].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_2895].m_vOrientation.y) * g_Lights_1._member0[_2895].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_2895].m_vOrientation.z) * g_Lights_1._member0[_2895].m_vOrientation.z), (_3245 * g_Lights_1._member0[_2895].m_vOrientation.y) + (_3248 * g_Lights_1._member0[_2895].m_vOrientation.z), (_3245 * g_Lights_1._member0[_2895].m_vOrientation.z) - (_3248 * g_Lights_1._member0[_2895].m_vOrientation.y)), _549)), 0.0, 1.0);
	                                    }
	                                    else
	                                    {
	                                        _551 = _3172;
	                                    }
	                                }
	                                else
	                                {
	                                    _551 = _550;
	                                }
	                                if (g_Lights_1._member0[_2895].m_nCookie == (-1))
	                                {
	                                    do
	                                    {
	                                        vec2 _3277 = abs(_2973.xyz.xy);
	                                        if (g_Lights_1._member0[_2895].m_vCookieParameters.z == 0.0)
	                                        {
	                                            _546 = smoothstep(1.0, g_Lights_1._member0[_2895].m_vCookieParameters.x, _3277.x) * smoothstep(1.0, g_Lights_1._member0[_2895].m_vCookieParameters.y, _3277.y);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _3282 = _3277.x;
	                                            float _3286 = _3277.y;
	                                            float _3293 = (-0.5) * g_Lights_1._member0[_2895].m_vCookieParameters.z;
	                                            float _3295 = (g_Lights_1._member0[_2895].m_vCookieParameters.x * g_Lights_1._member0[_2895].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_2895].m_vCookieParameters.y * _3282, 2.0 / g_Lights_1._member0[_2895].m_vCookieParameters.z) + pow(g_Lights_1._member0[_2895].m_vCookieParameters.x * _3286, 2.0 / g_Lights_1._member0[_2895].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3293);
	                                            float _3302 = pow(max(pow(_3282, 2.0 / g_Lights_1._member0[_2895].m_vCookieParameters.z) + pow(_3286, 2.0 / g_Lights_1._member0[_2895].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3293);
	                                            if (_3295 < _3302)
	                                            {
	                                                _546 = smoothstep(_3302, _3295, 1.0);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                if (_3302 > 1.0)
	                                                {
	                                                    _547 = 1.0;
	                                                }
	                                                else
	                                                {
	                                                    _547 = 0.0;
	                                                }
	                                                _546 = _547;
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _551 *= _546;
	                                }
	                                _557 = _554 * _551;
	                                break;
	                            } while(false);
	                            float _3325 = dot(_557.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if (_3325 == 0.0)
	                            {
	                                _563 = _2897;
	                                continue;
	                            }
	                            _544 = false;
	                            do
	                            {
	                                switch (g_Lights_1._member0[_2895].m_nLuminaireType)
	                                {
	                                    case 0:
	                                    {
	                                        _564 = 1.0;
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2895].m_vLightPosition.w == 0.0)
	                                            {
	                                                _519 = vec4(normalize(g_Lights_1._member0[_2895].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3851 = g_Lights_1._member0[_2895].m_vLightPosition.xyz - _2843;
	                                                float _3852 = length(_3851);
	                                                _519 = vec4(_3851 / vec3(_3852), _3852);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _544 = true;
	                                        _545 = _519;
	                                        break;
	                                    }
	                                    case 1:
	                                    {
	                                        vec3 _3691 = g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].xyz;
	                                        vec3 _3695 = g_Lights_1._member0[_2895].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].xyz;
	                                        float _3696 = length(_3691);
	                                        float _3697 = length(_3695);
	                                        vec3 _3699 = _3691 / vec3(_3696);
	                                        vec3 _3701 = _3695 / vec3(_3697);
	                                        vec3 _3702 = cross(_3699, _3701);
	                                        vec3 _3703 = g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].xyz - _2843;
	                                        float _3704 = dot(_3703, _3702);
	                                        if (_3704 > 0.0)
	                                        {
	                                            _521 = _3704 * (-1.0);
	                                            _522 = _3702 * (-1.0);
	                                        }
	                                        else
	                                        {
	                                            _521 = _3704;
	                                            _522 = _3702;
	                                        }
	                                        float _3713 = dot(_3703, _3699);
	                                        float _3714 = dot(_3703, _3701);
	                                        float _3715 = _3713 + _3696;
	                                        float _3716 = _3714 + _3697;
	                                        vec3 _3719 = vec3(_3713, _3714, _521);
	                                        vec3 _3720 = vec3(_3713, _3716, _521);
	                                        vec3 _3721 = vec3(_3715, _3714, _521);
	                                        vec3 _3722 = vec3(_3715, _3716, _521);
	                                        vec3 _3724 = normalize(cross(_3719, _3721));
	                                        vec3 _3726 = normalize(cross(_3721, _3722));
	                                        vec3 _3728 = normalize(cross(_3722, _3720));
	                                        vec3 _3730 = normalize(cross(_3720, _3719));
	                                        float _3747 = _3724.z;
	                                        float _3751 = (6.283185482025146484375 - acos(clamp(-dot(_3728, _3730), -1.0, 1.0))) - acos(clamp(-dot(_3730, _3724), -1.0, 1.0));
	                                        float _3753 = (acos(clamp(-dot(_3724, _3726), -1.0, 1.0)) + acos(clamp(-dot(_3726, _3728), -1.0, 1.0))) - _3751;
	                                        if (isnan(_3753))
	                                        {
	                                            _523 = 0.0;
	                                        }
	                                        else
	                                        {
	                                            _523 = _3753;
	                                        }
	                                        float _3761 = (_1664.x * _523) + _3751;
	                                        float _3766 = ((cos(_3761) * _3747) - _3728.z) / sin(_3761);
	                                        if (_3766 > 0.0)
	                                        {
	                                            _524 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _524 = -1.0;
	                                        }
	                                        float _3775 = _524;
	                                        float _3777 = clamp((1.0 / sqrt((_3766 * _3766) + (_3747 * _3747))) * _3775, -1.0, 1.0);
	                                        float _3785 = clamp((-(_3777 * _521)) / sqrt(1.0 - (_3777 * _3777)), _3713, _3715);
	                                        float _3788 = sqrt((_3785 * _3785) + (_521 * _521));
	                                        float _3789 = _3788 * _3788;
	                                        float _3792 = _3714 / sqrt(_3789 + (_3714 * _3714));
	                                        float _3799 = _3792 + (_1664.y * ((_3716 / sqrt(_3789 + (_3716 * _3716))) - _3792));
	                                        float _3800 = _3799 * _3799;
	                                        if (_3800 < 0.99999988079071044921875)
	                                        {
	                                            _524 = (_3799 * _3788) / sqrt(1.0 - _3800);
	                                        }
	                                        else
	                                        {
	                                            _524 = _3716;
	                                        }
	                                        vec3 _3817 = ((_2843 + (_3699 * _3785)) + (_3701 * _524)) + (_522 * _521);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2895].m_vLightPosition.w == 0.0)
	                                            {
	                                                _520 = vec4(normalize(_3817), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3828 = _3817 - _2843;
	                                                float _3829 = length(_3828);
	                                                _520 = vec4(_3828 / vec3(_3829), _3829);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _564 = 1.0 / _523;
	                                        _544 = true;
	                                        _545 = _520;
	                                        break;
	                                    }
	                                    case 2:
	                                    {
	                                        do
	                                        {
	                                            vec2 _3599 = (_1664 * 2.0) - vec2(1.0);
	                                            if (all(equal(_3599, vec2(0.0))))
	                                            {
	                                                _528 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _3604 = _3599.x;
	                                            float _3606 = _3599.y;
	                                            if (abs(_3604) > abs(_3606))
	                                            {
	                                                _529 = _3604;
	                                                _530 = 0.785398185253143310546875 * (_3606 / _3604);
	                                            }
	                                            else
	                                            {
	                                                _529 = _3606;
	                                                _530 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3604 / _3606));
	                                            }
	                                            _528 = vec2(cos(_530), sin(_530)) * _529;
	                                            break;
	                                        } while(false);
	                                        vec3 _3640 = (g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].xyz * _528.x)) + (g_Lights_1._member0[_2895].m_vLuminaireVectors.data[2].xyz * _528.y);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2895].m_vLightPosition.w == 0.0)
	                                            {
	                                                _527 = vec4(normalize(_3640), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3651 = _3640 - _2843;
	                                                float _3652 = length(_3651);
	                                                _527 = vec4(_3651 / vec3(_3652), _3652);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_527.w))
	                                        {
	                                            _525 = true;
	                                        }
	                                        else
	                                        {
	                                            _525 = isnan(_527.w);
	                                        }
	                                        if (!_525)
	                                        {
	                                            _526 = _527.w * _527.w;
	                                        }
	                                        else
	                                        {
	                                            _526 = 1.0;
	                                        }
	                                        _564 = _526 / (max(0.0, dot(g_Lights_1._member0[_2895].m_vLuminaireVectors.data[3].xyz, -_527.xyz)) * g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].w);
	                                        _544 = true;
	                                        _545 = _527;
	                                        break;
	                                    }
	                                    case 3:
	                                    {
	                                        vec3 _3494 = g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].xyz - _2843;
	                                        float _3495 = dot(_3494, _3494);
	                                        float _3496 = sqrt(_3495);
	                                        vec3 _3498 = _3494 / vec3(_3496);
	                                        float _3499 = _3498.z;
	                                        if (_3499 >= 0.0)
	                                        {
	                                            _532 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _532 = -1.0;
	                                        }
	                                        float _3506 = (-1.0) / (_532 + _3499);
	                                        float _3507 = _3498.x;
	                                        float _3508 = _3498.y;
	                                        float _3510 = (_3507 * _3508) * _3506;
	                                        vec3 _3515 = _533;
	                                        _3515.x = 1.0 + (((_532 * _3507) * _3507) * _3506);
	                                        _3515.y = _532 * _3510;
	                                        _3515.z = (-_532) * _3507;
	                                        _533 = _3515;
	                                        vec3 _3522 = _534;
	                                        _3522.x = _3510;
	                                        _3522.y = _532 + ((_3508 * _3508) * _3506);
	                                        _3522.z = -_3508;
	                                        _534 = _3522;
	                                        float _3530 = g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].x;
	                                        float _3534 = sqrt(max(0.0, 1.0 - (_3530 / _3495)));
	                                        float _3535 = _1664.x;
	                                        float _3538 = (1.0 - _3535) + (_3535 * _3534);
	                                        float _3542 = sqrt(max(0.0, 1.0 - (_3538 * _3538)));
	                                        float _3544 = _1664.y * 6.283185482025146484375;
	                                        float _3546 = _3496 * _3496;
	                                        float _3552 = (_3496 * _3538) - sqrt(max(0.0, _3530 - ((_3546 * _3542) * _3542)));
	                                        float _3558 = ((_3546 + _3530) - (_3552 * _3552)) / ((2.0 * _3496) * g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].x);
	                                        float _3562 = sqrt(max(0.0, 1.0 - (_3558 * _3558)));
	                                        vec3 _3574 = g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].xyz + ((mat3(-_3515, -_3522, -_3498) * vec3(cos(_3544) * _3562, sin(_3544) * _3562, _3558)) * g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].x);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2895].m_vLightPosition.w == 0.0)
	                                            {
	                                                _531 = vec4(normalize(_3574), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3585 = _3574 - _2843;
	                                                float _3586 = length(_3585);
	                                                _531 = vec4(_3585 / vec3(_3586), _3586);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _564 = 0.15915493667125701904296875 / (1.0 - _3534);
	                                        _544 = true;
	                                        _545 = _531;
	                                        break;
	                                    }
	                                    case 4:
	                                    case 5:
	                                    {
	                                        vec2 _541 = _1664;
	                                        if (_1664.x < g_Lights_1._member0[_2895].m_vLuminaireVectors.data[4].y)
	                                        {
	                                            vec2 _3385 = _541;
	                                            _3385.x = clamp(_3385.x / g_Lights_1._member0[_2895].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                            _541 = _3385;
	                                            vec3 _3391 = normalize(g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].xyz);
	                                            if (_3385.x >= 0.5)
	                                            {
	                                                vec2 _3402 = _541;
	                                                _3402.x = clamp((2.0 * _3402.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                _541 = _3402;
	                                                _542 = -_3391;
	                                                _543 = g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _3397 = _541;
	                                                _3397.x = clamp(2.0 * _3397.x, 0.0, 0.99999988079071044921875);
	                                                _541 = _3397;
	                                                _542 = _3391;
	                                                _543 = g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].xyz;
	                                            }
	                                            do
	                                            {
	                                                vec2 _3413 = (_541 * 2.0) - vec2(1.0);
	                                                if (all(equal(_3413, vec2(0.0))))
	                                                {
	                                                    _538 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _3418 = _3413.x;
	                                                float _3420 = _3413.y;
	                                                if (abs(_3418) > abs(_3420))
	                                                {
	                                                    _539 = _3418;
	                                                    _540 = 0.785398185253143310546875 * (_3420 / _3418);
	                                                }
	                                                else
	                                                {
	                                                    _539 = _3420;
	                                                    _540 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3418 / _3420));
	                                                }
	                                                _538 = vec2(cos(_540), sin(_540)) * _539;
	                                                break;
	                                            } while(false);
	                                            _543 += ((g_Lights_1._member0[_2895].m_vLuminaireVectors.data[2].xyz * _538.x) + (g_Lights_1._member0[_2895].m_vLuminaireVectors.data[3].xyz * _538.y));
	                                        }
	                                        else
	                                        {
	                                            vec2 _3364 = _541;
	                                            _3364.x = clamp((_3364.x - g_Lights_1._member0[_2895].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_2895].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                            _541 = _3364;
	                                            vec3 _3379 = (g_Lights_1._member0[_2895].m_vLuminaireVectors.data[2].xyz * cos(_3364.x * 6.283185482025146484375)) + (g_Lights_1._member0[_2895].m_vLuminaireVectors.data[3].xyz * sin(_3364.x * 6.283185482025146484375));
	                                            _542 = normalize(_3379);
	                                            _543 = mix(g_Lights_1._member0[_2895].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].xyz, vec3(_3364.y)) + _3379;
	                                        }
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2895].m_vLightPosition.w == 0.0)
	                                            {
	                                                _537 = vec4(normalize(_543), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3456 = _543 - _2843;
	                                                float _3457 = length(_3456);
	                                                _537 = vec4(_3456 / vec3(_3457), _3457);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_537.w))
	                                        {
	                                            _535 = true;
	                                        }
	                                        else
	                                        {
	                                            _535 = isnan(_537.w);
	                                        }
	                                        if (!_535)
	                                        {
	                                            _536 = _537.w * _537.w;
	                                        }
	                                        else
	                                        {
	                                            _536 = 1.0;
	                                        }
	                                        _564 = _536 / (max(0.0, dot(_542, -_537.xyz)) * g_Lights_1._member0[_2895].m_vLuminaireVectors.data[1].w);
	                                        _544 = true;
	                                        _545 = _537;
	                                        break;
	                                    }
	                                    default:
	                                    {
	                                        _564 = 0.0;
	                                        _544 = true;
	                                        _545 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                        break;
	                                    }
	                                }
	                                if (_544)
	                                {
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            float _3872 = dot(vec3(_280), _545.xyz);
	                            if ((!(dot(_407, _545.xyz) > 0.0)) && _619)
	                            {
	                                _518 = -_3872;
	                            }
	                            else
	                            {
	                                _518 = _3872;
	                            }
	                            float _3879 = (_3325 / _564) * max(0.0, _518);
	                            float _565 = _558.x;
	                            do
	                            {
	                                float _3884 = _559;
	                                float _3885 = _3884 + _3879;
	                                _559 = _3885;
	                                if (_3885 == 0.0)
	                                {
	                                    _516 = false;
	                                    break;
	                                }
	                                float _3890 = _3879 / _559;
	                                do
	                                {
	                                    if (_3890 <= 0.0)
	                                    {
	                                        _517 = false;
	                                        break;
	                                    }
	                                    if (_3890 >= 1.0)
	                                    {
	                                        _517 = true;
	                                        break;
	                                    }
	                                    if (_565 < _3890)
	                                    {
	                                        _565 = min(_565 / _3890, 0.99999988079071044921875);
	                                        _517 = true;
	                                        break;
	                                    }
	                                    _565 = min((_565 - _3890) / (1.0 - _3890), 0.99999988079071044921875);
	                                    _517 = false;
	                                    break;
	                                } while(false);
	                                _516 = _517;
	                                break;
	                            } while(false);
	                            vec2 _3915 = _558;
	                            _3915.x = _565;
	                            _558 = _3915;
	                            if (_516)
	                            {
	                                _470 = int(_2895);
	                                _469 = _557 / vec3(_564);
	                                _467 = _545;
	                                _562 = _3879;
	                            }
	                            _563 = _2897;
	                            continue;
	                        }
	                        _560 = _562;
	                        _561++;
	                        continue;
	                    }
	                    if (_470 != (-1))
	                    {
	                        vec3 _3935 = _469;
	                        vec3 _3936 = _3935 * (_559 / _560);
	                        bool _3945 = !(dot(_407, _467.xyz) > 0.0);
	                        vec3 _3948 = vec3(_280);
	                        vec3 _3953 = transpose(mat3(_326, _325, _3948)) * _467.xyz;
	                        float16_t _391 = _279;
	                        f16vec3 _390 = _278;
	                        float16_t _389 = _277;
	                        float16_t _388 = _276;
	                        uint _387 = _275;
	                        f16vec4 _386 = _274;
	                        vec3 _466 = _324;
	                        do
	                        {
	                            if (_3945)
	                            {
	                                f16vec4 _471 = _386;
	                                if ((_387 & 65535u) == 1u)
	                                {
	                                    _511 = any(greaterThan(vec3(_471.xyz), vec3(0.0)));
	                                }
	                                else
	                                {
	                                    _511 = false;
	                                }
	                                if (_511)
	                                {
	                                    _515 = vec3(_386.xyz);
	                                }
	                                else
	                                {
	                                    _515 = vec3(1.0);
	                                }
	                                _514 = _515 * 0.3183098733425140380859375;
	                                break;
	                            }
	                            else
	                            {
	                                vec3 _3972 = vec3(mix(f16vec3(_388), _390, f16vec3(_391)));
	                                float _3974 = float(_389);
	                                do
	                                {
	                                    float _3977 = _3953.z;
	                                    vec3 _3979 = _3953 + _466;
	                                    if (_3977 <= 0.0)
	                                    {
	                                        _513 = true;
	                                    }
	                                    else
	                                    {
	                                        _513 = _466.z <= 0.0;
	                                    }
	                                    if (_513)
	                                    {
	                                        _512 = vec3(0.0);
	                                        break;
	                                    }
	                                    if (all(equal(_3979, vec3(0.0))))
	                                    {
	                                        _512 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec3 _3992 = normalize(_3979);
	                                    float _3993 = _3992.z;
	                                    float _4001 = _3974 * _3974;
	                                    float _4002 = _4001 * _4001;
	                                    float _4006 = (((_3993 * _4002) - _3993) * _3993) + 1.0;
	                                    float _4010 = _3974 * _3974;
	                                    float _4011 = _4010 * _4010;
	                                    _512 = (_3972 + ((vec3(1.0) - _3972) * pow(max(0.0, 1.0 - dot(_3953, _3992)), 5.0))) * (((_4002 / max(9.9999999392252902907785028219223e-09, _4006 * _4006)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_3977 * sqrt(((_466.z - (_4011 * _466.z)) * _466.z) + _4011)) + (_466.z * sqrt(((_3977 - (_4011 * _3977)) * _3977) + _4011))))) * 0.3183098733425140380859375);
	                                    break;
	                                } while(false);
	                                _514 = ((vec3(_390) * (1.0 - float(_391))) * 0.3183098733425140380859375) + _512;
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        float _4065 = dot(_3948, _467.xyz);
	                        if (_3945)
	                        {
	                            _510 = -_4065;
	                        }
	                        else
	                        {
	                            _510 = _4065;
	                        }
	                        _469 = (_3936 * (_514 * 3.1415927410125732421875)) * max(0.0, _510);
	                        if (_3945)
	                        {
	                            f16vec4 _465 = _274;
	                            if ((_275 & 65535u) == 2u)
	                            {
	                                _509 = float(_465.x) > 0.0;
	                            }
	                            else
	                            {
	                                _509 = false;
	                            }
	                            _566 = _509;
	                        }
	                        else
	                        {
	                            _566 = false;
	                        }
	                        if (_566)
	                        {
	                            f16vec4 _385 = _274;
	                            uint _4096 = uint(_274.w);
	                            float _4101 = pow(clamp(-dot(normalize(_407 + _3948), _467.xyz), 0.0, 1.0), 2.0);
	                            f16vec3 _4102 = f16vec3(vec3(0.0));
	                            if (isinf(_467.w))
	                            {
	                                _505 = true;
	                            }
	                            else
	                            {
	                                _505 = isnan(_467.w);
	                            }
	                            if (!_505)
	                            {
	                                _506 = _467.w;
	                            }
	                            else
	                            {
	                                _506 = 1000.0;
	                            }
	                            vec3 _475 = _409 + (_467.xyz * _506);
	                            float _474 = 0.0;
	                            vec3 _473 = -_467.xyz;
	                            if (_4101 > 0.0)
	                            {
	                                _507 = _506;
	                            }
	                            else
	                            {
	                                _507 = 0.0;
	                            }
	                            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _476, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_4102, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4102, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                            traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _475, _474, _473, _507, 0);
	                            if (p.nInstance != (-1))
	                            {
	                                f16vec4 _472 = p.material.vMaterialBits;
	                                if ((p.material.nMaterialTypeAndFlags & 65535u) == 2u)
	                                {
	                                    _504 = float(_472.x) > 0.0;
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
	                                    _507 = _4101;
	                                }
	                                _508 = _506 - p.flHitT;
	                            }
	                            else
	                            {
	                                _507 = _4101;
	                                _508 = _506;
	                            }
	                            float _4164 = _508 * float(_385.x);
	                            _468 = (_3936 * vec3(_278)) * ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4096].m_vTransmissiveLogColor.xyz * (1.0 + (_4164 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4096].m_fTransmissiveSaturation))) * exp(-_4164)) * _507);
	                        }
	                    }
	                    vec4 _622 = _467;
	                    if (_470 != (-1))
	                    {
	                        bool _4192 = any(notEqual(_469, vec3(0.0)));
	                        if (isinf(_622.w))
	                        {
	                            _502 = true;
	                        }
	                        else
	                        {
	                            _502 = isnan(_622.w);
	                        }
	                        if (!_502)
	                        {
	                            _503 = _622.w;
	                        }
	                        else
	                        {
	                            _503 = 56755.83984375;
	                        }
	                        vec4 _4209 = _622;
	                        _4209.w = _503;
	                        _622 = _4209;
	                        do
	                        {
	                            float _4218 = dot(_4209.xyz, g_Lights_1._member0[_470].m_vNearPlane.xyz);
	                            if (_4218 == 0.0)
	                            {
	                                _501 = 0.0;
	                                break;
	                            }
	                            _501 = (g_Lights_1._member0[_470].m_vNearPlane.w - dot(_1625, g_Lights_1._member0[_470].m_vNearPlane.xyz)) * (1.0 / _4218);
	                            break;
	                        } while(false);
	                        if (_501 > 0.0)
	                        {
	                            vec4 _4230 = _622;
	                            _4230.w = min(_4230.w, _501);
	                            _622 = _4230;
	                        }
	                        if (dot(_622.xyz, _407.xyz) < 0.0)
	                        {
	                            _621 = _422;
	                        }
	                        else
	                        {
	                            _621 = _423;
	                        }
	                        vec4 _4243 = _622;
	                        vec3 _4245 = _621 - _1625;
	                        _4243.w = _4243.w + dot(_4243.xyz, _4245);
	                        vec3 _4255 = normalize((_4243.xyz * _4243.w) + _4245);
	                        vec4 _4257 = _4243;
	                        _4257.x = _4255.x;
	                        _4257.y = _4255.y;
	                        _4257.z = _4255.z;
	                        _622 = _4257;
	                        do
	                        {
	                            SceneGlobalInfoGPU_t_natural_logical _4267;
	                            _4267.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	                            _4267.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	                            _4267.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	                            _4267.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	                            _4267.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	                            _4267.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	                            _4267.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	                            _4267.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	                            _4267.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	                            _4267.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	                            if ((_4267.m_vBrdfLUTs.z & 1) != 0)
	                            {
	                                _500 = 32u;
	                                break;
	                            }
	                            if ((_4267.m_vBrdfLUTs.z & 2) != 0)
	                            {
	                                _500 = 16u;
	                                break;
	                            }
	                            _500 = 0u;
	                            break;
	                        } while(false);
	                        vec3 _479 = _621;
	                        float _478 = 0.0;
	                        vec3 _477 = _4257.xyz;
	                        if (_4192)
	                        {
	                            _499 = _4257.w;
	                        }
	                        else
	                        {
	                            _499 = 0.0;
	                        }
	                        p_1 = PayloadShadow_t(1.0);
	                        traceRayEXT(g_AccelStruct, _500, 2u, 1u, 2u, 1u, _479, _478, _477, _499, 1);
	                        if (_4192)
	                        {
	                            _499 = p_1.m_flVisibility;
	                        }
	                        else
	                        {
	                            _499 = 0.0;
	                        }
	                        _621 = (_613 + _468) + (_469 * _499);
	                    }
	                    else
	                    {
	                        _621 = _613;
	                    }
	                }
	                else
	                {
	                    _621 = _613;
	                }
	                _429 = _423;
	                _428 = _422;
	                _427 = _421;
	                _426 = _420;
	                _295 = _288;
	                _294 = _287;
	                _293 = _286;
	                _292 = _285;
	                _291 = _283;
	                _290 = _282;
	                _289 = _281;
	                _352 = _347;
	                _351 = _346;
	                _350 = _345;
	                _349 = _344;
	                _348 = _343;
	                vec3 _4327 = vec3(_286);
	                float _4333 = min(0.89999997615814208984375, max(_4327.x, max(_4327.y, _4327.z)));
	                float _646 = _645.x;
	                do
	                {
	                    if (_4333 <= 0.0)
	                    {
	                        _498 = false;
	                        break;
	                    }
	                    if (_4333 >= 1.0)
	                    {
	                        _498 = true;
	                        break;
	                    }
	                    if (_646 < _4333)
	                    {
	                        _646 = min(_646 / _4333, 0.99999988079071044921875);
	                        _498 = true;
	                        break;
	                    }
	                    _646 = min((_646 - _4333) / (1.0 - _4333), 0.99999988079071044921875);
	                    _498 = false;
	                    break;
	                } while(false);
	                vec2 _4358 = _645;
	                _4358.x = _646;
	                _645 = _4358;
	                if (_498)
	                {
	                    float _406 = _349;
	                    do
	                    {
	                        _647 = 1.0;
	                        do
	                        {
	                            if (_406 <= 0.0)
	                            {
	                                _497 = false;
	                                break;
	                            }
	                            if (_406 >= 1.0)
	                            {
	                                _497 = true;
	                                break;
	                            }
	                            if (_645.x < _406)
	                            {
	                                vec2 _4381 = _645;
	                                _4381.x = min(_4381.x / _406, 0.99999988079071044921875);
	                                _645 = _4381;
	                                _497 = true;
	                                break;
	                            }
	                            vec2 _4386 = _645;
	                            _4386.x = min((_4386.x - _406) / (1.0 - _406), 0.99999988079071044921875);
	                            _645 = _4386;
	                            _497 = false;
	                            break;
	                        } while(false);
	                        if (_497)
	                        {
	                            _647 = _406;
	                            _496 = true;
	                            break;
	                        }
	                        else
	                        {
	                            _647 = 1.0 - _406;
	                            _496 = false;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    if (_496)
	                    {
	                        _429 = _428;
	                    }
	                    f16vec3 _323 = _295;
	                    float16_t _322 = _294;
	                    f16vec3 _321 = _293;
	                    float16_t _320 = _292;
	                    float16_t _319 = _291;
	                    uint _318 = _290;
	                    f16vec4 _317 = _289;
	                    vec3 _405 = _352;
	                    vec3 _404 = _351;
	                    float _403 = _350;
	                    vec3 _402 = _348;
	                    do
	                    {
	                        vec2 _494 = _645;
	                        if (_496)
	                        {
	                            float _4497 = sqrt(_494.y);
	                            float _4499 = 6.283185482025146484375 * _494.x;
	                            vec3 _4507 = vec3(cos(_4499) * _4497, sin(_4499) * _4497, sqrt(max(0.0, 1.0 - _494.y)));
	                            _4507.z = -_4507.z;
	                            _493 = _4507;
	                            break;
	                        }
	                        else
	                        {
	                            float _495 = _494.x;
	                            do
	                            {
	                                if (_403 <= 0.0)
	                                {
	                                    _492 = false;
	                                    break;
	                                }
	                                if (_403 >= 1.0)
	                                {
	                                    _492 = true;
	                                    break;
	                                }
	                                if (_495 < _403)
	                                {
	                                    _495 = min(_495 / _403, 0.99999988079071044921875);
	                                    _492 = true;
	                                    break;
	                                }
	                                _495 = min((_495 - _403) / (1.0 - _403), 0.99999988079071044921875);
	                                _492 = false;
	                                break;
	                            } while(false);
	                            vec2 _4445 = _494;
	                            _4445.x = _495;
	                            _494 = _4445;
	                            if (_492)
	                            {
	                                float _4450 = float(_320);
	                                float _4458 = ((_4450 * _4450) * sqrt(_494.x)) / sqrt(1.0 - _494.x);
	                                float _4461 = 1.0 / (1.0 + (_4458 * _4458));
	                                float _4464 = sqrt(max(0.0, 1.0 - _4461));
	                                float _4467 = 6.283185482025146484375 * _494.y;
	                                vec3 _4472 = vec3(cos(_4467) * _4464, sin(_4467) * _4464, sqrt(_4461));
	                                if (dot(_402, _4472) > 0.0)
	                                {
	                                    _491 = _4472;
	                                }
	                                else
	                                {
	                                    _491 = -_4472;
	                                }
	                                _493 = -reflect(_402, _491);
	                                break;
	                            }
	                            float _4484 = sqrt(_494.y);
	                            float _4486 = 6.283185482025146484375 * _494.x;
	                            _493 = vec3(cos(_4486) * _4484, sin(_4486) * _4484, sqrt(max(0.0, 1.0 - _494.y)));
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    _639 = _493;
	                    vec3 _4514 = normalize(_493 + _402);
	                    float _4515 = _4514.z;
	                    if (_496)
	                    {
	                        _489 = _493.z * (-0.3183098733425140380859375);
	                    }
	                    else
	                    {
	                        if (_403 > 0.0)
	                        {
	                            float _4528 = float(_320);
	                            float _4529 = _4528 * _4528;
	                            float _4530 = _4529 * _4529;
	                            float _4534 = (((_4515 * _4530) - _4515) * _4515) + 1.0;
	                            _488 = 1.0 - _403;
	                            _489 = _403 * (((_4530 / max(9.9999999392252902907785028219223e-09, _4534 * _4534)) * _4515) / (12.56637096405029296875 * max(0.0, dot(_402, _4514))));
	                        }
	                        else
	                        {
	                            _488 = 1.0;
	                            _489 = 0.0;
	                        }
	                        _489 += (_488 * (_493.z * 0.3183098733425140380859375));
	                    }
	                    if (_489 == 0.0)
	                    {
	                        _490 = true;
	                    }
	                    else
	                    {
	                        _490 = isnan(_489);
	                    }
	                    if (_490)
	                    {
	                        _488 = 3.4028234663852885981170418348452e+38;
	                    }
	                    else
	                    {
	                        _488 = _489;
	                    }
	                    float _648 = _488;
	                    do
	                    {
	                        if (_496)
	                        {
	                            f16vec4 _480 = _317;
	                            if ((_318 & 65535u) == 1u)
	                            {
	                                _483 = any(greaterThan(vec3(_480.xyz), vec3(0.0)));
	                            }
	                            else
	                            {
	                                _483 = false;
	                            }
	                            if (_483)
	                            {
	                                _487 = vec3(_317.xyz);
	                            }
	                            else
	                            {
	                                _487 = vec3(1.0);
	                            }
	                            _486 = _487 * 0.3183098733425140380859375;
	                            break;
	                        }
	                        else
	                        {
	                            vec3 _4575 = vec3(mix(f16vec3(_319), _321, f16vec3(_322)));
	                            float _4577 = float(_320);
	                            do
	                            {
	                                vec3 _4582 = _639 + _402;
	                                if (_639.z <= 0.0)
	                                {
	                                    _485 = true;
	                                }
	                                else
	                                {
	                                    _485 = _402.z <= 0.0;
	                                }
	                                if (_485)
	                                {
	                                    _484 = vec3(0.0);
	                                    break;
	                                }
	                                if (all(equal(_4582, vec3(0.0))))
	                                {
	                                    _484 = vec3(0.0);
	                                    break;
	                                }
	                                vec3 _4595 = normalize(_4582);
	                                float _4596 = _4595.z;
	                                float _4604 = _4577 * _4577;
	                                float _4605 = _4604 * _4604;
	                                float _4609 = (((_4596 * _4605) - _4596) * _4596) + 1.0;
	                                float _4613 = _4577 * _4577;
	                                float _4614 = _4613 * _4613;
	                                _484 = (_4575 + ((vec3(1.0) - _4575) * pow(max(0.0, 1.0 - dot(_639, _4595)), 5.0))) * (((_4605 / max(9.9999999392252902907785028219223e-09, _4609 * _4609)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_639.z * sqrt(((_402.z - (_4614 * _402.z)) * _402.z) + _4614)) + (_402.z * sqrt(((_639.z - (_4614 * _639.z)) * _639.z) + _4614))))) * 0.3183098733425140380859375);
	                                break;
	                            } while(false);
	                            _486 = ((vec3(_321) * (1.0 - float(_322))) * 0.3183098733425140380859375) + _484;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _4664 = _639;
	                    vec3 _4670 = mat3(_405, _404, vec3(_323)) * _4664;
	                    _639 = _4670;
	                    float _4673 = dot(vec3(_295), _4670);
	                    if (_496)
	                    {
	                        _482 = -_4673;
	                    }
	                    else
	                    {
	                        _482 = _4673;
	                    }
	                    do
	                    {
	                        if ((_426 & 1024) != 0)
	                        {
	                            _481 = true;
	                            break;
	                        }
	                        _481 = (dot(_427, _639) > 0.0) != _496;
	                        break;
	                    } while(false);
	                    if (_481)
	                    {
	                        _649 = (_643 * (_486 * max(0.0, _482))) / vec3((_4333 * _647) * _648);
	                    }
	                    else
	                    {
	                        _649 = vec3(0.0);
	                    }
	                    _641 = _649;
	                }
	                else
	                {
	                    _641 = vec3(0.0);
	                }
	                _640++;
	                _642 = (_642 + ((_621 * _643) * _644)) + ((vec3(_284) * _643) * _644);
	                continue;
	            }
	            vIrradiance = (_642 * max(0.0, dot(_924, _922))) * 0.3183098733425140380859375;
	        }
	        else
	        {
	            vIrradiance = vec3(0.0);
	        }
	        VertexLightSample_t_natural_logical _4717;
	        _4717.vIrradiance_flSampleCount = g_Samples._member0[nSampleIndex].vIrradiance_flSampleCount;
	        vec4 _4718 = _4717.vIrradiance_flSampleCount;
	        vec3 _4720 = abs(vIrradiance);
	        float _4725 = max(_4720.x, max(_4720.y, _4720.z));
	        vec3 _4736 = mix(_4718.xyz, clamp(vIrradiance / vec3(_4725), vec3(-1.0), vec3(1.0)) * clamp(_4725, -100.0, 100.0), vec3(1.0 / (1.0 + _4718.w)));
	        vec4 _4738 = _4718;
	        _4738.x = _4736.x;
	        _4738.y = _4736.y;
	        _4738.z = _4736.z;
	        _4738.w = _4738.w + 1.0;
	        g_Samples._member0[nSampleIndex].vIrradiance_flSampleCount = _4738;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
