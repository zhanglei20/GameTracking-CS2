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
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (58156 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_ray_tracing : require
	
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
	
	vec4 _85;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    layout(row_major) SceneGlobalInfoGPU_t_natural _member0[];
	} g_SceneGlobalInfo;
	
	layout(set = 3, binding = 36, std430) readonly buffer g_Lights
	{
	    layout(row_major) PathTraceBarnLightGPU_t_natural _member0[];
	} g_Lights_1;
	
	layout(set = 6, binding = 158, std430) buffer RWStructuredBuffer
	{
	    uint _member0[];
	} g_LightBins;
	
	void main()
	{
	    SceneGlobalInfoGPU_t_natural_logical _283;
	    _283.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	    _283.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	    _283.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	    _283.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	    _283.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	    _283.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	    _283.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	    _283.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	    _283.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	    _283.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	    SceneGlobalInfoGPU_t_natural_logical _288;
	    _288.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	    _288.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	    _288.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	    _288.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	    _288.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	    _288.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	    _288.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	    _288.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	    _288.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	    _288.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	    uint _294 = uint(max(1, ((_288.m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	    uvec3 _295 = uvec3(_283.m_vLightBinCellCount_nLightCount.xyz);
	    uint _299 = gl_LaunchIDEXT.z / _294;
	    uint nMask = gl_LaunchIDEXT.z - (_299 * _294);
	    uint _302 = _294 * _295.x;
	    SceneGlobalInfoGPU_t_natural_logical _315;
	    _315.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	    _315.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	    _315.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	    _315.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	    _315.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	    _315.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	    _315.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	    _315.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	    _315.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	    _315.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	    SceneGlobalInfoGPU_t_natural_logical _320;
	    _320.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	    _320.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	    _320.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	    _320.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	    _320.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	    _320.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	    _320.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	    _320.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	    _320.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	    _320.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	    SceneGlobalInfoGPU_t_natural_logical _326;
	    _326.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	    _326.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	    _326.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	    _326.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	    _326.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	    _326.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	    _326.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	    _326.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	    _326.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	    _326.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	    vec3 vCellMin = vec3(uvec3(gl_LaunchIDEXT.xy, _299)) / vec3(_326.m_vLightBinCellCount_nLightCount.xyz);
	    SceneGlobalInfoGPU_t_natural_logical _332;
	    _332.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	    _332.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	    _332.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	    _332.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	    _332.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	    _332.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	    _332.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	    _332.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	    _332.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	    _332.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	    vec3 _337 = mix(_315.m_vLocalLightMinBounds.xyz, _320.m_vLocalLightMaxBounds.xyz, vCellMin);
	    vec3 _338 = mix(_315.m_vLocalLightMinBounds.xyz, _320.m_vLocalLightMaxBounds.xyz, vCellMin + (vec3(1.0) / vec3(_332.m_vLightBinCellCount_nLightCount.xyz)));
	    int nStartLight = int(nMask) * 32;
	    SceneGlobalInfoGPU_t_natural_logical _342;
	    _342.m_vSkyColor = g_SceneGlobalInfo._member0[0].m_vSkyColor;
	    _342.m_vSkyAmbientBounce = g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce;
	    _342.m_vSunLightIrradiance = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance;
	    _342.m_vLocalLightMinBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds;
	    _342.m_vLocalLightMaxBounds = g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds;
	    _342.m_vLightBinCellCount_nLightCount = g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount;
	    _342.m_mIBLTransformI = g_SceneGlobalInfo._member0[0].m_mIBLTransformI;
	    _342.m_vIBLCubeMapScale = g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale;
	    _342.m_vIBLParams = g_SceneGlobalInfo._member0[0].m_vIBLParams;
	    _342.m_vBrdfLUTs = g_SceneGlobalInfo._member0[0].m_vBrdfLUTs;
	    int _345 = min((nStartLight + 32), _342.m_vLightBinCellCount_nLightCount.w);
	    int i = nStartLight;
	    int nBits = 0;
	    float _159;
	    vec4 _160;
	    vec4 _161;
	    bool _162;
	    vec3 _163;
	    float _164;
	    vec3 _165;
	    float _166;
	    vec3 _167;
	    float _168;
	    vec3 _169;
	    float _170;
	    vec3 _171;
	    float _172;
	    vec3 _173;
	    float _174;
	    vec3 _175;
	    float _176;
	    vec3 _177;
	    float _178;
	    float _179;
	    vec4 _180;
	    vec4 _181;
	    bool _182;
	    vec3 _183;
	    float _184;
	    vec3 _185;
	    float _186;
	    vec3 _187;
	    float _188;
	    vec3 _189;
	    float _190;
	    vec3 _191;
	    float _192;
	    vec3 _193;
	    float _194;
	    vec3 _195;
	    float _196;
	    vec3 _197;
	    float _198;
	    float _199;
	    vec4 _200;
	    vec4 _201;
	    bool _202;
	    vec3 _203;
	    float _204;
	    vec3 _205;
	    float _206;
	    vec3 _207;
	    float _208;
	    vec3 _209;
	    float _210;
	    vec3 _211;
	    float _212;
	    vec3 _213;
	    float _214;
	    vec3 _215;
	    float _216;
	    vec3 _217;
	    float _218;
	    float _219;
	    vec4 _220;
	    vec4 _221;
	    bool _222;
	    vec3 _223;
	    float _224;
	    vec3 _225;
	    float _226;
	    vec3 _227;
	    float _228;
	    vec3 _229;
	    float _230;
	    vec3 _231;
	    float _232;
	    vec3 _233;
	    float _234;
	    vec3 _235;
	    float _236;
	    vec3 _237;
	    float _238;
	    float _239;
	    vec4 _240;
	    vec4 _241;
	    bool _242;
	    vec3 _243;
	    float _244;
	    vec3 _245;
	    float _246;
	    vec3 _247;
	    float _248;
	    vec3 _249;
	    float _250;
	    vec3 _251;
	    float _252;
	    vec3 _253;
	    float _254;
	    vec3 _255;
	    float _256;
	    vec3 _257;
	    float _258;
	    float _259;
	    vec4 _260;
	    vec4 _261;
	    bool _262;
	    vec3 _263;
	    float _264;
	    vec3 _265;
	    float _266;
	    vec3 _267;
	    float _268;
	    vec3 _269;
	    float _270;
	    vec3 _271;
	    float _272;
	    vec3 _273;
	    float _274;
	    vec3 _275;
	    float _276;
	    vec3 _277;
	    float _278;
	    float _279;
	    bool _280;
	    for (;;)
	    {
	        bool _350_ladder_break = false;
	        do
	        {
	            if (!(i < _345))
	            {
	                _350_ladder_break = true;
	                break;
	            }
	            vec3 _110 = g_Lights_1._member0[i].m_vMinBounds.xyz;
	            vec3 _109 = g_Lights_1._member0[i].m_vMaxBounds.xyz;
	            vec3 _108 = _337;
	            vec3 _107 = _338;
	            do
	            {
	                bvec3 _370 = greaterThan(_110, _107);
	                bvec3 _373 = lessThan(_109, _108);
	                if (any(bvec3(_370.x || _373.x, _370.y || _373.y, _370.z || _373.z)))
	                {
	                    _280 = false;
	                    break;
	                }
	                _280 = true;
	                break;
	            } while(false);
	            if (!_280)
	            {
	                break;
	            }
	            do
	            {
	                if (g_Lights_1._member0[i].m_vLightPosition.w == 0.0)
	                {
	                    _279 = 3.4028234663852885981170418348452e+38;
	                    break;
	                }
	                if (g_Lights_1._member0[i].m_vDistanceFade_vSkirt.y == 0.0)
	                {
	                    _279 = 3.4028234663852885981170418348452e+38;
	                    break;
	                }
	                _279 = (-g_Lights_1._member0[i].m_vDistanceFade_vSkirt.x) / g_Lights_1._member0[i].m_vDistanceFade_vSkirt.y;
	                break;
	            } while(false);
	            if (_279 < 3.4028234663852885981170418348452e+38)
	            {
	                vec3 vDelta = g_Lights_1._member0[i].m_vLightPosition.xyz - clamp(g_Lights_1._member0[i].m_vLightPosition.xyz, _337, _338);
	                if (dot(vDelta, vDelta) > (_279 * _279))
	                {
	                    break;
	                }
	            }
	            vec4 _420 = g_Lights_1._member0[i].m_mFromClipSpace * vec4(vec3(-1.0, -1.0, 0.0), 1.0);
	            vec3 _424 = _420.xyz / vec3(_420.w);
	            vec4 _426;
	            _426.x = _424.x;
	            _426.y = _424.y;
	            _426.z = _424.z;
	            vec3 _106 = _426.xyz;
	            vec4 _436 = g_Lights_1._member0[i].m_mFromClipSpace * vec4(vec3(-1.0, 1.0, 0.0), 1.0);
	            vec3 _440 = _436.xyz / vec3(_436.w);
	            vec4 _442;
	            _442.x = _440.x;
	            _442.y = _440.y;
	            _442.z = _440.z;
	            vec3 _105 = _442.xyz;
	            vec4 _452 = g_Lights_1._member0[i].m_mFromClipSpace * vec4(vec3(1.0, 1.0, 0.0), 1.0);
	            vec3 _456 = _452.xyz / vec3(_452.w);
	            vec4 _458;
	            _458.x = _456.x;
	            _458.y = _456.y;
	            _458.z = _456.z;
	            vec3 _104 = _458.xyz;
	            vec4 _468 = g_Lights_1._member0[i].m_mFromClipSpace * vec4(vec3(1.0, -1.0, 0.0), 1.0);
	            vec3 _472 = _468.xyz / vec3(_468.w);
	            vec4 _474;
	            _474.x = _472.x;
	            _474.y = _472.y;
	            _474.z = _472.z;
	            vec3 _103 = _474.xyz;
	            vec4 _484 = g_Lights_1._member0[i].m_mFromClipSpace * vec4(vec3(-1.0, -1.0, 1.0), 1.0);
	            vec3 _488 = _484.xyz / vec3(_484.w);
	            vec4 _490;
	            _490.x = _488.x;
	            _490.y = _488.y;
	            _490.z = _488.z;
	            vec3 _102 = _490.xyz;
	            vec4 _500 = g_Lights_1._member0[i].m_mFromClipSpace * vec4(vec3(-1.0, 1.0, 1.0), 1.0);
	            vec3 _504 = _500.xyz / vec3(_500.w);
	            vec4 _506;
	            _506.x = _504.x;
	            _506.y = _504.y;
	            _506.z = _504.z;
	            vec3 _101 = _506.xyz;
	            vec4 _516 = g_Lights_1._member0[i].m_mFromClipSpace * vec4(vec3(1.0), 1.0);
	            vec3 _520 = _516.xyz / vec3(_516.w);
	            vec4 _522;
	            _522.x = _520.x;
	            _522.y = _520.y;
	            _522.z = _520.z;
	            vec3 _100 = _522.xyz;
	            vec4 _532 = g_Lights_1._member0[i].m_mFromClipSpace * vec4(vec3(1.0, -1.0, 1.0), 1.0);
	            vec3 _536 = _532.xyz / vec3(_532.w);
	            vec4 _538;
	            _538.x = _536.x;
	            _538.y = _536.y;
	            _538.z = _536.z;
	            vec3 _99 = _538.xyz;
	            vec3 _547 = normalize(cross(_442.xyz - _426.xyz, _458.xyz - _426.xyz));
	            vec4 _549 = vec4(_547, dot(_547, _442.xyz));
	            vec3 _98 = _337;
	            vec3 _97 = _338;
	            if (false)
	            {
	                _278 = _97.x;
	            }
	            else
	            {
	                _278 = _98.x;
	            }
	            vec3 _558 = _277;
	            _558.x = _278;
	            _277 = _558;
	            if (false)
	            {
	                _278 = _97.y;
	            }
	            else
	            {
	                _278 = _98.y;
	            }
	            vec3 _568 = _277;
	            _568.y = _278;
	            _277 = _568;
	            if (false)
	            {
	                _278 = _97.z;
	            }
	            else
	            {
	                _278 = _98.z;
	            }
	            vec3 _578 = _277;
	            _578.z = _278;
	            _277 = _578;
	            if (true)
	            {
	                _276 = _97.x;
	            }
	            else
	            {
	                _276 = _98.x;
	            }
	            vec3 _588 = _275;
	            _588.x = _276;
	            _275 = _588;
	            if (false)
	            {
	                _276 = _97.y;
	            }
	            else
	            {
	                _276 = _98.y;
	            }
	            vec3 _598 = _275;
	            _598.y = _276;
	            _275 = _598;
	            if (false)
	            {
	                _276 = _97.z;
	            }
	            else
	            {
	                _276 = _98.z;
	            }
	            vec3 _608 = _275;
	            _608.z = _276;
	            _275 = _608;
	            if (false)
	            {
	                _274 = _97.x;
	            }
	            else
	            {
	                _274 = _98.x;
	            }
	            vec3 _618 = _273;
	            _618.x = _274;
	            _273 = _618;
	            if (true)
	            {
	                _274 = _97.y;
	            }
	            else
	            {
	                _274 = _98.y;
	            }
	            vec3 _628 = _273;
	            _628.y = _274;
	            _273 = _628;
	            if (false)
	            {
	                _274 = _97.z;
	            }
	            else
	            {
	                _274 = _98.z;
	            }
	            vec3 _638 = _273;
	            _638.z = _274;
	            _273 = _638;
	            if (true)
	            {
	                _272 = _97.x;
	            }
	            else
	            {
	                _272 = _98.x;
	            }
	            vec3 _648 = _271;
	            _648.x = _272;
	            _271 = _648;
	            if (true)
	            {
	                _272 = _97.y;
	            }
	            else
	            {
	                _272 = _98.y;
	            }
	            vec3 _658 = _271;
	            _658.y = _272;
	            _271 = _658;
	            if (false)
	            {
	                _272 = _97.z;
	            }
	            else
	            {
	                _272 = _98.z;
	            }
	            vec3 _668 = _271;
	            _668.z = _272;
	            _271 = _668;
	            if (false)
	            {
	                _270 = _97.x;
	            }
	            else
	            {
	                _270 = _98.x;
	            }
	            vec3 _678 = _269;
	            _678.x = _270;
	            _269 = _678;
	            if (false)
	            {
	                _270 = _97.y;
	            }
	            else
	            {
	                _270 = _98.y;
	            }
	            vec3 _688 = _269;
	            _688.y = _270;
	            _269 = _688;
	            if (true)
	            {
	                _270 = _97.z;
	            }
	            else
	            {
	                _270 = _98.z;
	            }
	            vec3 _698 = _269;
	            _698.z = _270;
	            _269 = _698;
	            if (true)
	            {
	                _268 = _97.x;
	            }
	            else
	            {
	                _268 = _98.x;
	            }
	            vec3 _708 = _267;
	            _708.x = _268;
	            _267 = _708;
	            if (false)
	            {
	                _268 = _97.y;
	            }
	            else
	            {
	                _268 = _98.y;
	            }
	            vec3 _718 = _267;
	            _718.y = _268;
	            _267 = _718;
	            if (true)
	            {
	                _268 = _97.z;
	            }
	            else
	            {
	                _268 = _98.z;
	            }
	            vec3 _728 = _267;
	            _728.z = _268;
	            _267 = _728;
	            if (false)
	            {
	                _266 = _97.x;
	            }
	            else
	            {
	                _266 = _98.x;
	            }
	            vec3 _738 = _265;
	            _738.x = _266;
	            _265 = _738;
	            if (true)
	            {
	                _266 = _97.y;
	            }
	            else
	            {
	                _266 = _98.y;
	            }
	            vec3 _748 = _265;
	            _748.y = _266;
	            _265 = _748;
	            if (true)
	            {
	                _266 = _97.z;
	            }
	            else
	            {
	                _266 = _98.z;
	            }
	            vec3 _758 = _265;
	            _758.z = _266;
	            _265 = _758;
	            if (true)
	            {
	                _264 = _97.x;
	            }
	            else
	            {
	                _264 = _98.x;
	            }
	            vec3 _768 = _263;
	            _768.x = _264;
	            _263 = _768;
	            if (true)
	            {
	                _264 = _97.y;
	            }
	            else
	            {
	                _264 = _98.y;
	            }
	            vec3 _778 = _263;
	            _778.y = _264;
	            _263 = _778;
	            if (true)
	            {
	                _264 = _97.z;
	            }
	            else
	            {
	                _264 = _98.z;
	            }
	            vec3 _788 = _263;
	            _788.z = _264;
	            _263 = _788;
	            vec3 _118 = _578;
	            vec3 _117 = _608;
	            vec3 _116 = _638;
	            vec3 _115 = _668;
	            vec3 _114 = _698;
	            vec3 _113 = _728;
	            vec3 _112 = _758;
	            vec3 _111 = _788;
	            do
	            {
	                vec3 _792 = _549.xyz;
	                float _795 = _549.w;
	                vec4 _797 = _260;
	                _797.x = dot(_792, _118) - _795;
	                _797.y = dot(_792, _117) - _795;
	                _797.z = dot(_792, _116) - _795;
	                _797.w = dot(_792, _115) - _795;
	                _260 = _797;
	                vec4 _814 = _261;
	                _814.x = dot(_792, _114) - _795;
	                _814.y = dot(_792, _113) - _795;
	                _814.z = dot(_792, _112) - _795;
	                _814.w = dot(_792, _111) - _795;
	                _261 = _814;
	                if (all(greaterThan(_797, vec4(0.0))))
	                {
	                    _262 = all(greaterThan(_261, vec4(0.0)));
	                }
	                else
	                {
	                    _262 = false;
	                }
	                if (_262)
	                {
	                    _259 = 1.0;
	                    break;
	                }
	                if (all(lessThan(_260, vec4(0.0))))
	                {
	                    _262 = all(lessThan(_261, vec4(0.0)));
	                }
	                else
	                {
	                    _262 = false;
	                }
	                if (_262)
	                {
	                    _259 = -1.0;
	                    break;
	                }
	                _259 = 0.0;
	                break;
	            } while(false);
	            if (_259 < 0.0)
	            {
	                break;
	            }
	            vec3 _861 = normalize(cross(_100 - _102, _101 - _102));
	            vec4 _863 = vec4(_861, dot(_861, _100));
	            vec3 _96 = _337;
	            vec3 _95 = _338;
	            if (false)
	            {
	                _258 = _95.x;
	            }
	            else
	            {
	                _258 = _96.x;
	            }
	            vec3 _872 = _257;
	            _872.x = _258;
	            _257 = _872;
	            if (false)
	            {
	                _258 = _95.y;
	            }
	            else
	            {
	                _258 = _96.y;
	            }
	            vec3 _882 = _257;
	            _882.y = _258;
	            _257 = _882;
	            if (false)
	            {
	                _258 = _95.z;
	            }
	            else
	            {
	                _258 = _96.z;
	            }
	            vec3 _892 = _257;
	            _892.z = _258;
	            _257 = _892;
	            if (true)
	            {
	                _256 = _95.x;
	            }
	            else
	            {
	                _256 = _96.x;
	            }
	            vec3 _902 = _255;
	            _902.x = _256;
	            _255 = _902;
	            if (false)
	            {
	                _256 = _95.y;
	            }
	            else
	            {
	                _256 = _96.y;
	            }
	            vec3 _912 = _255;
	            _912.y = _256;
	            _255 = _912;
	            if (false)
	            {
	                _256 = _95.z;
	            }
	            else
	            {
	                _256 = _96.z;
	            }
	            vec3 _922 = _255;
	            _922.z = _256;
	            _255 = _922;
	            if (false)
	            {
	                _254 = _95.x;
	            }
	            else
	            {
	                _254 = _96.x;
	            }
	            vec3 _932 = _253;
	            _932.x = _254;
	            _253 = _932;
	            if (true)
	            {
	                _254 = _95.y;
	            }
	            else
	            {
	                _254 = _96.y;
	            }
	            vec3 _942 = _253;
	            _942.y = _254;
	            _253 = _942;
	            if (false)
	            {
	                _254 = _95.z;
	            }
	            else
	            {
	                _254 = _96.z;
	            }
	            vec3 _952 = _253;
	            _952.z = _254;
	            _253 = _952;
	            if (true)
	            {
	                _252 = _95.x;
	            }
	            else
	            {
	                _252 = _96.x;
	            }
	            vec3 _962 = _251;
	            _962.x = _252;
	            _251 = _962;
	            if (true)
	            {
	                _252 = _95.y;
	            }
	            else
	            {
	                _252 = _96.y;
	            }
	            vec3 _972 = _251;
	            _972.y = _252;
	            _251 = _972;
	            if (false)
	            {
	                _252 = _95.z;
	            }
	            else
	            {
	                _252 = _96.z;
	            }
	            vec3 _982 = _251;
	            _982.z = _252;
	            _251 = _982;
	            if (false)
	            {
	                _250 = _95.x;
	            }
	            else
	            {
	                _250 = _96.x;
	            }
	            vec3 _992 = _249;
	            _992.x = _250;
	            _249 = _992;
	            if (false)
	            {
	                _250 = _95.y;
	            }
	            else
	            {
	                _250 = _96.y;
	            }
	            vec3 _1002 = _249;
	            _1002.y = _250;
	            _249 = _1002;
	            if (true)
	            {
	                _250 = _95.z;
	            }
	            else
	            {
	                _250 = _96.z;
	            }
	            vec3 _1012 = _249;
	            _1012.z = _250;
	            _249 = _1012;
	            if (true)
	            {
	                _248 = _95.x;
	            }
	            else
	            {
	                _248 = _96.x;
	            }
	            vec3 _1022 = _247;
	            _1022.x = _248;
	            _247 = _1022;
	            if (false)
	            {
	                _248 = _95.y;
	            }
	            else
	            {
	                _248 = _96.y;
	            }
	            vec3 _1032 = _247;
	            _1032.y = _248;
	            _247 = _1032;
	            if (true)
	            {
	                _248 = _95.z;
	            }
	            else
	            {
	                _248 = _96.z;
	            }
	            vec3 _1042 = _247;
	            _1042.z = _248;
	            _247 = _1042;
	            if (false)
	            {
	                _246 = _95.x;
	            }
	            else
	            {
	                _246 = _96.x;
	            }
	            vec3 _1052 = _245;
	            _1052.x = _246;
	            _245 = _1052;
	            if (true)
	            {
	                _246 = _95.y;
	            }
	            else
	            {
	                _246 = _96.y;
	            }
	            vec3 _1062 = _245;
	            _1062.y = _246;
	            _245 = _1062;
	            if (true)
	            {
	                _246 = _95.z;
	            }
	            else
	            {
	                _246 = _96.z;
	            }
	            vec3 _1072 = _245;
	            _1072.z = _246;
	            _245 = _1072;
	            if (true)
	            {
	                _244 = _95.x;
	            }
	            else
	            {
	                _244 = _96.x;
	            }
	            vec3 _1082 = _243;
	            _1082.x = _244;
	            _243 = _1082;
	            if (true)
	            {
	                _244 = _95.y;
	            }
	            else
	            {
	                _244 = _96.y;
	            }
	            vec3 _1092 = _243;
	            _1092.y = _244;
	            _243 = _1092;
	            if (true)
	            {
	                _244 = _95.z;
	            }
	            else
	            {
	                _244 = _96.z;
	            }
	            vec3 _1102 = _243;
	            _1102.z = _244;
	            _243 = _1102;
	            vec3 _126 = _892;
	            vec3 _125 = _922;
	            vec3 _124 = _952;
	            vec3 _123 = _982;
	            vec3 _122 = _1012;
	            vec3 _121 = _1042;
	            vec3 _120 = _1072;
	            vec3 _119 = _1102;
	            do
	            {
	                vec3 _1106 = _863.xyz;
	                float _1109 = _863.w;
	                vec4 _1111 = _240;
	                _1111.x = dot(_1106, _126) - _1109;
	                _1111.y = dot(_1106, _125) - _1109;
	                _1111.z = dot(_1106, _124) - _1109;
	                _1111.w = dot(_1106, _123) - _1109;
	                _240 = _1111;
	                vec4 _1128 = _241;
	                _1128.x = dot(_1106, _122) - _1109;
	                _1128.y = dot(_1106, _121) - _1109;
	                _1128.z = dot(_1106, _120) - _1109;
	                _1128.w = dot(_1106, _119) - _1109;
	                _241 = _1128;
	                if (all(greaterThan(_1111, vec4(0.0))))
	                {
	                    _242 = all(greaterThan(_241, vec4(0.0)));
	                }
	                else
	                {
	                    _242 = false;
	                }
	                if (_242)
	                {
	                    _239 = 1.0;
	                    break;
	                }
	                if (all(lessThan(_240, vec4(0.0))))
	                {
	                    _242 = all(lessThan(_241, vec4(0.0)));
	                }
	                else
	                {
	                    _242 = false;
	                }
	                if (_242)
	                {
	                    _239 = -1.0;
	                    break;
	                }
	                _239 = 0.0;
	                break;
	            } while(false);
	            if (_239 < 0.0)
	            {
	                break;
	            }
	            vec3 _1175 = normalize(cross(_102 - _106, _101 - _106));
	            vec4 _1177 = vec4(_1175, dot(_1175, _102));
	            vec3 _94 = _337;
	            vec3 _93 = _338;
	            if (false)
	            {
	                _238 = _93.x;
	            }
	            else
	            {
	                _238 = _94.x;
	            }
	            vec3 _1186 = _237;
	            _1186.x = _238;
	            _237 = _1186;
	            if (false)
	            {
	                _238 = _93.y;
	            }
	            else
	            {
	                _238 = _94.y;
	            }
	            vec3 _1196 = _237;
	            _1196.y = _238;
	            _237 = _1196;
	            if (false)
	            {
	                _238 = _93.z;
	            }
	            else
	            {
	                _238 = _94.z;
	            }
	            vec3 _1206 = _237;
	            _1206.z = _238;
	            _237 = _1206;
	            if (true)
	            {
	                _236 = _93.x;
	            }
	            else
	            {
	                _236 = _94.x;
	            }
	            vec3 _1216 = _235;
	            _1216.x = _236;
	            _235 = _1216;
	            if (false)
	            {
	                _236 = _93.y;
	            }
	            else
	            {
	                _236 = _94.y;
	            }
	            vec3 _1226 = _235;
	            _1226.y = _236;
	            _235 = _1226;
	            if (false)
	            {
	                _236 = _93.z;
	            }
	            else
	            {
	                _236 = _94.z;
	            }
	            vec3 _1236 = _235;
	            _1236.z = _236;
	            _235 = _1236;
	            if (false)
	            {
	                _234 = _93.x;
	            }
	            else
	            {
	                _234 = _94.x;
	            }
	            vec3 _1246 = _233;
	            _1246.x = _234;
	            _233 = _1246;
	            if (true)
	            {
	                _234 = _93.y;
	            }
	            else
	            {
	                _234 = _94.y;
	            }
	            vec3 _1256 = _233;
	            _1256.y = _234;
	            _233 = _1256;
	            if (false)
	            {
	                _234 = _93.z;
	            }
	            else
	            {
	                _234 = _94.z;
	            }
	            vec3 _1266 = _233;
	            _1266.z = _234;
	            _233 = _1266;
	            if (true)
	            {
	                _232 = _93.x;
	            }
	            else
	            {
	                _232 = _94.x;
	            }
	            vec3 _1276 = _231;
	            _1276.x = _232;
	            _231 = _1276;
	            if (true)
	            {
	                _232 = _93.y;
	            }
	            else
	            {
	                _232 = _94.y;
	            }
	            vec3 _1286 = _231;
	            _1286.y = _232;
	            _231 = _1286;
	            if (false)
	            {
	                _232 = _93.z;
	            }
	            else
	            {
	                _232 = _94.z;
	            }
	            vec3 _1296 = _231;
	            _1296.z = _232;
	            _231 = _1296;
	            if (false)
	            {
	                _230 = _93.x;
	            }
	            else
	            {
	                _230 = _94.x;
	            }
	            vec3 _1306 = _229;
	            _1306.x = _230;
	            _229 = _1306;
	            if (false)
	            {
	                _230 = _93.y;
	            }
	            else
	            {
	                _230 = _94.y;
	            }
	            vec3 _1316 = _229;
	            _1316.y = _230;
	            _229 = _1316;
	            if (true)
	            {
	                _230 = _93.z;
	            }
	            else
	            {
	                _230 = _94.z;
	            }
	            vec3 _1326 = _229;
	            _1326.z = _230;
	            _229 = _1326;
	            if (true)
	            {
	                _228 = _93.x;
	            }
	            else
	            {
	                _228 = _94.x;
	            }
	            vec3 _1336 = _227;
	            _1336.x = _228;
	            _227 = _1336;
	            if (false)
	            {
	                _228 = _93.y;
	            }
	            else
	            {
	                _228 = _94.y;
	            }
	            vec3 _1346 = _227;
	            _1346.y = _228;
	            _227 = _1346;
	            if (true)
	            {
	                _228 = _93.z;
	            }
	            else
	            {
	                _228 = _94.z;
	            }
	            vec3 _1356 = _227;
	            _1356.z = _228;
	            _227 = _1356;
	            if (false)
	            {
	                _226 = _93.x;
	            }
	            else
	            {
	                _226 = _94.x;
	            }
	            vec3 _1366 = _225;
	            _1366.x = _226;
	            _225 = _1366;
	            if (true)
	            {
	                _226 = _93.y;
	            }
	            else
	            {
	                _226 = _94.y;
	            }
	            vec3 _1376 = _225;
	            _1376.y = _226;
	            _225 = _1376;
	            if (true)
	            {
	                _226 = _93.z;
	            }
	            else
	            {
	                _226 = _94.z;
	            }
	            vec3 _1386 = _225;
	            _1386.z = _226;
	            _225 = _1386;
	            if (true)
	            {
	                _224 = _93.x;
	            }
	            else
	            {
	                _224 = _94.x;
	            }
	            vec3 _1396 = _223;
	            _1396.x = _224;
	            _223 = _1396;
	            if (true)
	            {
	                _224 = _93.y;
	            }
	            else
	            {
	                _224 = _94.y;
	            }
	            vec3 _1406 = _223;
	            _1406.y = _224;
	            _223 = _1406;
	            if (true)
	            {
	                _224 = _93.z;
	            }
	            else
	            {
	                _224 = _94.z;
	            }
	            vec3 _1416 = _223;
	            _1416.z = _224;
	            _223 = _1416;
	            vec3 _134 = _1206;
	            vec3 _133 = _1236;
	            vec3 _132 = _1266;
	            vec3 _131 = _1296;
	            vec3 _130 = _1326;
	            vec3 _129 = _1356;
	            vec3 _128 = _1386;
	            vec3 _127 = _1416;
	            do
	            {
	                vec3 _1420 = _1177.xyz;
	                float _1423 = _1177.w;
	                vec4 _1425 = _220;
	                _1425.x = dot(_1420, _134) - _1423;
	                _1425.y = dot(_1420, _133) - _1423;
	                _1425.z = dot(_1420, _132) - _1423;
	                _1425.w = dot(_1420, _131) - _1423;
	                _220 = _1425;
	                vec4 _1442 = _221;
	                _1442.x = dot(_1420, _130) - _1423;
	                _1442.y = dot(_1420, _129) - _1423;
	                _1442.z = dot(_1420, _128) - _1423;
	                _1442.w = dot(_1420, _127) - _1423;
	                _221 = _1442;
	                if (all(greaterThan(_1425, vec4(0.0))))
	                {
	                    _222 = all(greaterThan(_221, vec4(0.0)));
	                }
	                else
	                {
	                    _222 = false;
	                }
	                if (_222)
	                {
	                    _219 = 1.0;
	                    break;
	                }
	                if (all(lessThan(_220, vec4(0.0))))
	                {
	                    _222 = all(lessThan(_221, vec4(0.0)));
	                }
	                else
	                {
	                    _222 = false;
	                }
	                if (_222)
	                {
	                    _219 = -1.0;
	                    break;
	                }
	                _219 = 0.0;
	                break;
	            } while(false);
	            if (_219 < 0.0)
	            {
	                break;
	            }
	            vec3 _1489 = normalize(cross(_101 - _105, _100 - _105));
	            vec4 _1491 = vec4(_1489, dot(_1489, _101));
	            vec3 _92 = _337;
	            vec3 _91 = _338;
	            if (false)
	            {
	                _218 = _91.x;
	            }
	            else
	            {
	                _218 = _92.x;
	            }
	            vec3 _1500 = _217;
	            _1500.x = _218;
	            _217 = _1500;
	            if (false)
	            {
	                _218 = _91.y;
	            }
	            else
	            {
	                _218 = _92.y;
	            }
	            vec3 _1510 = _217;
	            _1510.y = _218;
	            _217 = _1510;
	            if (false)
	            {
	                _218 = _91.z;
	            }
	            else
	            {
	                _218 = _92.z;
	            }
	            vec3 _1520 = _217;
	            _1520.z = _218;
	            _217 = _1520;
	            if (true)
	            {
	                _216 = _91.x;
	            }
	            else
	            {
	                _216 = _92.x;
	            }
	            vec3 _1530 = _215;
	            _1530.x = _216;
	            _215 = _1530;
	            if (false)
	            {
	                _216 = _91.y;
	            }
	            else
	            {
	                _216 = _92.y;
	            }
	            vec3 _1540 = _215;
	            _1540.y = _216;
	            _215 = _1540;
	            if (false)
	            {
	                _216 = _91.z;
	            }
	            else
	            {
	                _216 = _92.z;
	            }
	            vec3 _1550 = _215;
	            _1550.z = _216;
	            _215 = _1550;
	            if (false)
	            {
	                _214 = _91.x;
	            }
	            else
	            {
	                _214 = _92.x;
	            }
	            vec3 _1560 = _213;
	            _1560.x = _214;
	            _213 = _1560;
	            if (true)
	            {
	                _214 = _91.y;
	            }
	            else
	            {
	                _214 = _92.y;
	            }
	            vec3 _1570 = _213;
	            _1570.y = _214;
	            _213 = _1570;
	            if (false)
	            {
	                _214 = _91.z;
	            }
	            else
	            {
	                _214 = _92.z;
	            }
	            vec3 _1580 = _213;
	            _1580.z = _214;
	            _213 = _1580;
	            if (true)
	            {
	                _212 = _91.x;
	            }
	            else
	            {
	                _212 = _92.x;
	            }
	            vec3 _1590 = _211;
	            _1590.x = _212;
	            _211 = _1590;
	            if (true)
	            {
	                _212 = _91.y;
	            }
	            else
	            {
	                _212 = _92.y;
	            }
	            vec3 _1600 = _211;
	            _1600.y = _212;
	            _211 = _1600;
	            if (false)
	            {
	                _212 = _91.z;
	            }
	            else
	            {
	                _212 = _92.z;
	            }
	            vec3 _1610 = _211;
	            _1610.z = _212;
	            _211 = _1610;
	            if (false)
	            {
	                _210 = _91.x;
	            }
	            else
	            {
	                _210 = _92.x;
	            }
	            vec3 _1620 = _209;
	            _1620.x = _210;
	            _209 = _1620;
	            if (false)
	            {
	                _210 = _91.y;
	            }
	            else
	            {
	                _210 = _92.y;
	            }
	            vec3 _1630 = _209;
	            _1630.y = _210;
	            _209 = _1630;
	            if (true)
	            {
	                _210 = _91.z;
	            }
	            else
	            {
	                _210 = _92.z;
	            }
	            vec3 _1640 = _209;
	            _1640.z = _210;
	            _209 = _1640;
	            if (true)
	            {
	                _208 = _91.x;
	            }
	            else
	            {
	                _208 = _92.x;
	            }
	            vec3 _1650 = _207;
	            _1650.x = _208;
	            _207 = _1650;
	            if (false)
	            {
	                _208 = _91.y;
	            }
	            else
	            {
	                _208 = _92.y;
	            }
	            vec3 _1660 = _207;
	            _1660.y = _208;
	            _207 = _1660;
	            if (true)
	            {
	                _208 = _91.z;
	            }
	            else
	            {
	                _208 = _92.z;
	            }
	            vec3 _1670 = _207;
	            _1670.z = _208;
	            _207 = _1670;
	            if (false)
	            {
	                _206 = _91.x;
	            }
	            else
	            {
	                _206 = _92.x;
	            }
	            vec3 _1680 = _205;
	            _1680.x = _206;
	            _205 = _1680;
	            if (true)
	            {
	                _206 = _91.y;
	            }
	            else
	            {
	                _206 = _92.y;
	            }
	            vec3 _1690 = _205;
	            _1690.y = _206;
	            _205 = _1690;
	            if (true)
	            {
	                _206 = _91.z;
	            }
	            else
	            {
	                _206 = _92.z;
	            }
	            vec3 _1700 = _205;
	            _1700.z = _206;
	            _205 = _1700;
	            if (true)
	            {
	                _204 = _91.x;
	            }
	            else
	            {
	                _204 = _92.x;
	            }
	            vec3 _1710 = _203;
	            _1710.x = _204;
	            _203 = _1710;
	            if (true)
	            {
	                _204 = _91.y;
	            }
	            else
	            {
	                _204 = _92.y;
	            }
	            vec3 _1720 = _203;
	            _1720.y = _204;
	            _203 = _1720;
	            if (true)
	            {
	                _204 = _91.z;
	            }
	            else
	            {
	                _204 = _92.z;
	            }
	            vec3 _1730 = _203;
	            _1730.z = _204;
	            _203 = _1730;
	            vec3 _142 = _1520;
	            vec3 _141 = _1550;
	            vec3 _140 = _1580;
	            vec3 _139 = _1610;
	            vec3 _138 = _1640;
	            vec3 _137 = _1670;
	            vec3 _136 = _1700;
	            vec3 _135 = _1730;
	            do
	            {
	                vec3 _1734 = _1491.xyz;
	                float _1737 = _1491.w;
	                vec4 _1739 = _200;
	                _1739.x = dot(_1734, _142) - _1737;
	                _1739.y = dot(_1734, _141) - _1737;
	                _1739.z = dot(_1734, _140) - _1737;
	                _1739.w = dot(_1734, _139) - _1737;
	                _200 = _1739;
	                vec4 _1756 = _201;
	                _1756.x = dot(_1734, _138) - _1737;
	                _1756.y = dot(_1734, _137) - _1737;
	                _1756.z = dot(_1734, _136) - _1737;
	                _1756.w = dot(_1734, _135) - _1737;
	                _201 = _1756;
	                if (all(greaterThan(_1739, vec4(0.0))))
	                {
	                    _202 = all(greaterThan(_201, vec4(0.0)));
	                }
	                else
	                {
	                    _202 = false;
	                }
	                if (_202)
	                {
	                    _199 = 1.0;
	                    break;
	                }
	                if (all(lessThan(_200, vec4(0.0))))
	                {
	                    _202 = all(lessThan(_201, vec4(0.0)));
	                }
	                else
	                {
	                    _202 = false;
	                }
	                if (_202)
	                {
	                    _199 = -1.0;
	                    break;
	                }
	                _199 = 0.0;
	                break;
	            } while(false);
	            if (_199 < 0.0)
	            {
	                break;
	            }
	            vec3 _1803 = normalize(cross(_100 - _104, _99 - _104));
	            vec4 _1805 = vec4(_1803, dot(_1803, _100));
	            vec3 _90 = _337;
	            vec3 _89 = _338;
	            if (false)
	            {
	                _198 = _89.x;
	            }
	            else
	            {
	                _198 = _90.x;
	            }
	            vec3 _1814 = _197;
	            _1814.x = _198;
	            _197 = _1814;
	            if (false)
	            {
	                _198 = _89.y;
	            }
	            else
	            {
	                _198 = _90.y;
	            }
	            vec3 _1824 = _197;
	            _1824.y = _198;
	            _197 = _1824;
	            if (false)
	            {
	                _198 = _89.z;
	            }
	            else
	            {
	                _198 = _90.z;
	            }
	            vec3 _1834 = _197;
	            _1834.z = _198;
	            _197 = _1834;
	            if (true)
	            {
	                _196 = _89.x;
	            }
	            else
	            {
	                _196 = _90.x;
	            }
	            vec3 _1844 = _195;
	            _1844.x = _196;
	            _195 = _1844;
	            if (false)
	            {
	                _196 = _89.y;
	            }
	            else
	            {
	                _196 = _90.y;
	            }
	            vec3 _1854 = _195;
	            _1854.y = _196;
	            _195 = _1854;
	            if (false)
	            {
	                _196 = _89.z;
	            }
	            else
	            {
	                _196 = _90.z;
	            }
	            vec3 _1864 = _195;
	            _1864.z = _196;
	            _195 = _1864;
	            if (false)
	            {
	                _194 = _89.x;
	            }
	            else
	            {
	                _194 = _90.x;
	            }
	            vec3 _1874 = _193;
	            _1874.x = _194;
	            _193 = _1874;
	            if (true)
	            {
	                _194 = _89.y;
	            }
	            else
	            {
	                _194 = _90.y;
	            }
	            vec3 _1884 = _193;
	            _1884.y = _194;
	            _193 = _1884;
	            if (false)
	            {
	                _194 = _89.z;
	            }
	            else
	            {
	                _194 = _90.z;
	            }
	            vec3 _1894 = _193;
	            _1894.z = _194;
	            _193 = _1894;
	            if (true)
	            {
	                _192 = _89.x;
	            }
	            else
	            {
	                _192 = _90.x;
	            }
	            vec3 _1904 = _191;
	            _1904.x = _192;
	            _191 = _1904;
	            if (true)
	            {
	                _192 = _89.y;
	            }
	            else
	            {
	                _192 = _90.y;
	            }
	            vec3 _1914 = _191;
	            _1914.y = _192;
	            _191 = _1914;
	            if (false)
	            {
	                _192 = _89.z;
	            }
	            else
	            {
	                _192 = _90.z;
	            }
	            vec3 _1924 = _191;
	            _1924.z = _192;
	            _191 = _1924;
	            if (false)
	            {
	                _190 = _89.x;
	            }
	            else
	            {
	                _190 = _90.x;
	            }
	            vec3 _1934 = _189;
	            _1934.x = _190;
	            _189 = _1934;
	            if (false)
	            {
	                _190 = _89.y;
	            }
	            else
	            {
	                _190 = _90.y;
	            }
	            vec3 _1944 = _189;
	            _1944.y = _190;
	            _189 = _1944;
	            if (true)
	            {
	                _190 = _89.z;
	            }
	            else
	            {
	                _190 = _90.z;
	            }
	            vec3 _1954 = _189;
	            _1954.z = _190;
	            _189 = _1954;
	            if (true)
	            {
	                _188 = _89.x;
	            }
	            else
	            {
	                _188 = _90.x;
	            }
	            vec3 _1964 = _187;
	            _1964.x = _188;
	            _187 = _1964;
	            if (false)
	            {
	                _188 = _89.y;
	            }
	            else
	            {
	                _188 = _90.y;
	            }
	            vec3 _1974 = _187;
	            _1974.y = _188;
	            _187 = _1974;
	            if (true)
	            {
	                _188 = _89.z;
	            }
	            else
	            {
	                _188 = _90.z;
	            }
	            vec3 _1984 = _187;
	            _1984.z = _188;
	            _187 = _1984;
	            if (false)
	            {
	                _186 = _89.x;
	            }
	            else
	            {
	                _186 = _90.x;
	            }
	            vec3 _1994 = _185;
	            _1994.x = _186;
	            _185 = _1994;
	            if (true)
	            {
	                _186 = _89.y;
	            }
	            else
	            {
	                _186 = _90.y;
	            }
	            vec3 _2004 = _185;
	            _2004.y = _186;
	            _185 = _2004;
	            if (true)
	            {
	                _186 = _89.z;
	            }
	            else
	            {
	                _186 = _90.z;
	            }
	            vec3 _2014 = _185;
	            _2014.z = _186;
	            _185 = _2014;
	            if (true)
	            {
	                _184 = _89.x;
	            }
	            else
	            {
	                _184 = _90.x;
	            }
	            vec3 _2024 = _183;
	            _2024.x = _184;
	            _183 = _2024;
	            if (true)
	            {
	                _184 = _89.y;
	            }
	            else
	            {
	                _184 = _90.y;
	            }
	            vec3 _2034 = _183;
	            _2034.y = _184;
	            _183 = _2034;
	            if (true)
	            {
	                _184 = _89.z;
	            }
	            else
	            {
	                _184 = _90.z;
	            }
	            vec3 _2044 = _183;
	            _2044.z = _184;
	            _183 = _2044;
	            vec3 _150 = _1834;
	            vec3 _149 = _1864;
	            vec3 _148 = _1894;
	            vec3 _147 = _1924;
	            vec3 _146 = _1954;
	            vec3 _145 = _1984;
	            vec3 _144 = _2014;
	            vec3 _143 = _2044;
	            do
	            {
	                vec3 _2048 = _1805.xyz;
	                float _2051 = _1805.w;
	                vec4 _2053 = _180;
	                _2053.x = dot(_2048, _150) - _2051;
	                _2053.y = dot(_2048, _149) - _2051;
	                _2053.z = dot(_2048, _148) - _2051;
	                _2053.w = dot(_2048, _147) - _2051;
	                _180 = _2053;
	                vec4 _2070 = _181;
	                _2070.x = dot(_2048, _146) - _2051;
	                _2070.y = dot(_2048, _145) - _2051;
	                _2070.z = dot(_2048, _144) - _2051;
	                _2070.w = dot(_2048, _143) - _2051;
	                _181 = _2070;
	                if (all(greaterThan(_2053, vec4(0.0))))
	                {
	                    _182 = all(greaterThan(_181, vec4(0.0)));
	                }
	                else
	                {
	                    _182 = false;
	                }
	                if (_182)
	                {
	                    _179 = 1.0;
	                    break;
	                }
	                if (all(lessThan(_180, vec4(0.0))))
	                {
	                    _182 = all(lessThan(_181, vec4(0.0)));
	                }
	                else
	                {
	                    _182 = false;
	                }
	                if (_182)
	                {
	                    _179 = -1.0;
	                    break;
	                }
	                _179 = 0.0;
	                break;
	            } while(false);
	            if (_179 < 0.0)
	            {
	                break;
	            }
	            vec3 _2117 = normalize(cross(_99 - _103, _102 - _103));
	            vec4 _2119 = vec4(_2117, dot(_2117, _99));
	            vec3 _88 = _337;
	            vec3 _87 = _338;
	            if (false)
	            {
	                _178 = _87.x;
	            }
	            else
	            {
	                _178 = _88.x;
	            }
	            vec3 _2128 = _177;
	            _2128.x = _178;
	            _177 = _2128;
	            if (false)
	            {
	                _178 = _87.y;
	            }
	            else
	            {
	                _178 = _88.y;
	            }
	            vec3 _2138 = _177;
	            _2138.y = _178;
	            _177 = _2138;
	            if (false)
	            {
	                _178 = _87.z;
	            }
	            else
	            {
	                _178 = _88.z;
	            }
	            vec3 _2148 = _177;
	            _2148.z = _178;
	            _177 = _2148;
	            if (true)
	            {
	                _176 = _87.x;
	            }
	            else
	            {
	                _176 = _88.x;
	            }
	            vec3 _2158 = _175;
	            _2158.x = _176;
	            _175 = _2158;
	            if (false)
	            {
	                _176 = _87.y;
	            }
	            else
	            {
	                _176 = _88.y;
	            }
	            vec3 _2168 = _175;
	            _2168.y = _176;
	            _175 = _2168;
	            if (false)
	            {
	                _176 = _87.z;
	            }
	            else
	            {
	                _176 = _88.z;
	            }
	            vec3 _2178 = _175;
	            _2178.z = _176;
	            _175 = _2178;
	            if (false)
	            {
	                _174 = _87.x;
	            }
	            else
	            {
	                _174 = _88.x;
	            }
	            vec3 _2188 = _173;
	            _2188.x = _174;
	            _173 = _2188;
	            if (true)
	            {
	                _174 = _87.y;
	            }
	            else
	            {
	                _174 = _88.y;
	            }
	            vec3 _2198 = _173;
	            _2198.y = _174;
	            _173 = _2198;
	            if (false)
	            {
	                _174 = _87.z;
	            }
	            else
	            {
	                _174 = _88.z;
	            }
	            vec3 _2208 = _173;
	            _2208.z = _174;
	            _173 = _2208;
	            if (true)
	            {
	                _172 = _87.x;
	            }
	            else
	            {
	                _172 = _88.x;
	            }
	            vec3 _2218 = _171;
	            _2218.x = _172;
	            _171 = _2218;
	            if (true)
	            {
	                _172 = _87.y;
	            }
	            else
	            {
	                _172 = _88.y;
	            }
	            vec3 _2228 = _171;
	            _2228.y = _172;
	            _171 = _2228;
	            if (false)
	            {
	                _172 = _87.z;
	            }
	            else
	            {
	                _172 = _88.z;
	            }
	            vec3 _2238 = _171;
	            _2238.z = _172;
	            _171 = _2238;
	            if (false)
	            {
	                _170 = _87.x;
	            }
	            else
	            {
	                _170 = _88.x;
	            }
	            vec3 _2248 = _169;
	            _2248.x = _170;
	            _169 = _2248;
	            if (false)
	            {
	                _170 = _87.y;
	            }
	            else
	            {
	                _170 = _88.y;
	            }
	            vec3 _2258 = _169;
	            _2258.y = _170;
	            _169 = _2258;
	            if (true)
	            {
	                _170 = _87.z;
	            }
	            else
	            {
	                _170 = _88.z;
	            }
	            vec3 _2268 = _169;
	            _2268.z = _170;
	            _169 = _2268;
	            if (true)
	            {
	                _168 = _87.x;
	            }
	            else
	            {
	                _168 = _88.x;
	            }
	            vec3 _2278 = _167;
	            _2278.x = _168;
	            _167 = _2278;
	            if (false)
	            {
	                _168 = _87.y;
	            }
	            else
	            {
	                _168 = _88.y;
	            }
	            vec3 _2288 = _167;
	            _2288.y = _168;
	            _167 = _2288;
	            if (true)
	            {
	                _168 = _87.z;
	            }
	            else
	            {
	                _168 = _88.z;
	            }
	            vec3 _2298 = _167;
	            _2298.z = _168;
	            _167 = _2298;
	            if (false)
	            {
	                _166 = _87.x;
	            }
	            else
	            {
	                _166 = _88.x;
	            }
	            vec3 _2308 = _165;
	            _2308.x = _166;
	            _165 = _2308;
	            if (true)
	            {
	                _166 = _87.y;
	            }
	            else
	            {
	                _166 = _88.y;
	            }
	            vec3 _2318 = _165;
	            _2318.y = _166;
	            _165 = _2318;
	            if (true)
	            {
	                _166 = _87.z;
	            }
	            else
	            {
	                _166 = _88.z;
	            }
	            vec3 _2328 = _165;
	            _2328.z = _166;
	            _165 = _2328;
	            if (true)
	            {
	                _164 = _87.x;
	            }
	            else
	            {
	                _164 = _88.x;
	            }
	            vec3 _2338 = _163;
	            _2338.x = _164;
	            _163 = _2338;
	            if (true)
	            {
	                _164 = _87.y;
	            }
	            else
	            {
	                _164 = _88.y;
	            }
	            vec3 _2348 = _163;
	            _2348.y = _164;
	            _163 = _2348;
	            if (true)
	            {
	                _164 = _87.z;
	            }
	            else
	            {
	                _164 = _88.z;
	            }
	            vec3 _2358 = _163;
	            _2358.z = _164;
	            _163 = _2358;
	            vec3 _158 = _2148;
	            vec3 _157 = _2178;
	            vec3 _156 = _2208;
	            vec3 _155 = _2238;
	            vec3 _154 = _2268;
	            vec3 _153 = _2298;
	            vec3 _152 = _2328;
	            vec3 _151 = _2358;
	            do
	            {
	                vec3 _2362 = _2119.xyz;
	                float _2365 = _2119.w;
	                vec4 _2367 = _160;
	                _2367.x = dot(_2362, _158) - _2365;
	                _2367.y = dot(_2362, _157) - _2365;
	                _2367.z = dot(_2362, _156) - _2365;
	                _2367.w = dot(_2362, _155) - _2365;
	                _160 = _2367;
	                vec4 _2384 = _161;
	                _2384.x = dot(_2362, _154) - _2365;
	                _2384.y = dot(_2362, _153) - _2365;
	                _2384.z = dot(_2362, _152) - _2365;
	                _2384.w = dot(_2362, _151) - _2365;
	                _161 = _2384;
	                if (all(greaterThan(_2367, vec4(0.0))))
	                {
	                    _162 = all(greaterThan(_161, vec4(0.0)));
	                }
	                else
	                {
	                    _162 = false;
	                }
	                if (_162)
	                {
	                    _159 = 1.0;
	                    break;
	                }
	                if (all(lessThan(_160, vec4(0.0))))
	                {
	                    _162 = all(lessThan(_161, vec4(0.0)));
	                }
	                else
	                {
	                    _162 = false;
	                }
	                if (_162)
	                {
	                    _159 = -1.0;
	                    break;
	                }
	                _159 = 0.0;
	                break;
	            } while(false);
	            if (_159 < 0.0)
	            {
	                break;
	            }
	            nBits |= int(1u << uint(i - nStartLight));
	            break;
	        } while(false);
	        if (_350_ladder_break)
	        {
	            break;
	        }
	        i++;
	        continue;
	    }
	    g_LightBins._member0[((((_302 * _295.y) * _299) + (_302 * gl_LaunchIDEXT.y)) + (_294 * gl_LaunchIDEXT.x)) + nMask] = uint(nBits);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
