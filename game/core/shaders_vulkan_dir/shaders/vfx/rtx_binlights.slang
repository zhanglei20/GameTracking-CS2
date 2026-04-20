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
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (50508 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_ray_tracing : require
	
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
	
	vec4 _90;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    SceneGlobalInfoGPU_t_natural _m0[];
	} g_SceneGlobalInfo;
	
	layout(set = 6, binding = 158, std430) buffer RWStructuredBuffer
	{
	    uint _m0[];
	} g_LightBins;
	
	layout(set = 3, binding = 36, std430) readonly buffer g_Lights
	{
	    PathTraceBarnLightGPU_t_natural _m0[];
	} g_Lights_1;
	
	void main()
	{
	    do
	    {
	        uint _235 = uint(max(1, ((g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	        uvec3 _236 = uvec3(g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.xyz);
	        uint _240 = uint(int(_235));
	        uint _241 = gl_LaunchIDEXT.z / _240;
	        uint nMask = gl_LaunchIDEXT.z - (_241 * _240);
	        uint _244 = _235 * _236.x;
	        vec3 vCellMin = vec3(uvec3(gl_LaunchIDEXT.xy, _241)) / vec3(g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.xyz);
	        vec3 _275 = mix(g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz, g_SceneGlobalInfo._m0[0].m_vLocalLightMaxBounds.xyz, vCellMin);
	        vec3 _276 = mix(g_SceneGlobalInfo._m0[0].m_vLocalLightMinBounds.xyz, g_SceneGlobalInfo._m0[0].m_vLocalLightMaxBounds.xyz, vCellMin + (vec3(1.0) / vec3(g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.xyz)));
	        int nStartLight = int(nMask) * 32;
	        int _282 = min((nStartLight + 32), g_SceneGlobalInfo._m0[0].m_vLightBinCellCount_nLightCount.w);
	        int i = nStartLight;
	        int nBits = 0;
	        float _100;
	        vec4 _101;
	        vec4 _102;
	        bool _103;
	        vec3 _104;
	        float _105;
	        vec3 _106;
	        float _107;
	        vec3 _108;
	        float _109;
	        vec3 _110;
	        float _111;
	        vec3 _112;
	        float _113;
	        vec3 _114;
	        float _115;
	        vec3 _116;
	        float _117;
	        vec3 _118;
	        float _119;
	        float _120;
	        vec4 _121;
	        vec4 _122;
	        bool _123;
	        vec3 _124;
	        float _125;
	        vec3 _126;
	        float _127;
	        vec3 _128;
	        float _129;
	        vec3 _130;
	        float _131;
	        vec3 _132;
	        float _133;
	        vec3 _134;
	        float _135;
	        vec3 _136;
	        float _137;
	        vec3 _138;
	        float _139;
	        float _140;
	        vec4 _141;
	        vec4 _142;
	        bool _143;
	        vec3 _144;
	        float _145;
	        vec3 _146;
	        float _147;
	        vec3 _148;
	        float _149;
	        vec3 _150;
	        float _151;
	        vec3 _152;
	        float _153;
	        vec3 _154;
	        float _155;
	        vec3 _156;
	        float _157;
	        vec3 _158;
	        float _159;
	        float _160;
	        vec4 _161;
	        vec4 _162;
	        bool _163;
	        vec3 _164;
	        float _165;
	        vec3 _166;
	        float _167;
	        vec3 _168;
	        float _169;
	        vec3 _170;
	        float _171;
	        vec3 _172;
	        float _173;
	        vec3 _174;
	        float _175;
	        vec3 _176;
	        float _177;
	        vec3 _178;
	        float _179;
	        float _180;
	        vec4 _181;
	        vec4 _182;
	        bool _183;
	        vec3 _184;
	        float _185;
	        vec3 _186;
	        float _187;
	        vec3 _188;
	        float _189;
	        vec3 _190;
	        float _191;
	        vec3 _192;
	        float _193;
	        vec3 _194;
	        float _195;
	        vec3 _196;
	        float _197;
	        vec3 _198;
	        float _199;
	        float _200;
	        vec4 _201;
	        vec4 _202;
	        bool _203;
	        vec3 _204;
	        float _205;
	        vec3 _206;
	        float _207;
	        vec3 _208;
	        float _209;
	        vec3 _210;
	        float _211;
	        vec3 _212;
	        float _213;
	        vec3 _214;
	        float _215;
	        vec3 _216;
	        float _217;
	        vec3 _218;
	        float _219;
	        float _220;
	        bool _221;
	        for (;;)
	        {
	            bool _287_ladder_break = false;
	            do
	            {
	                if (!(i < _282))
	                {
	                    _287_ladder_break = true;
	                    break;
	                }
	                mat4 _327 = mat4(vec4(g_Lights_1._m0[i].m_mFromClipSpace.data[0].x, g_Lights_1._m0[i].m_mFromClipSpace.data[1].x, g_Lights_1._m0[i].m_mFromClipSpace.data[2].x, g_Lights_1._m0[i].m_mFromClipSpace.data[3].x), vec4(g_Lights_1._m0[i].m_mFromClipSpace.data[0].y, g_Lights_1._m0[i].m_mFromClipSpace.data[1].y, g_Lights_1._m0[i].m_mFromClipSpace.data[2].y, g_Lights_1._m0[i].m_mFromClipSpace.data[3].y), vec4(g_Lights_1._m0[i].m_mFromClipSpace.data[0].z, g_Lights_1._m0[i].m_mFromClipSpace.data[1].z, g_Lights_1._m0[i].m_mFromClipSpace.data[2].z, g_Lights_1._m0[i].m_mFromClipSpace.data[3].z), vec4(g_Lights_1._m0[i].m_mFromClipSpace.data[0].w, g_Lights_1._m0[i].m_mFromClipSpace.data[1].w, g_Lights_1._m0[i].m_mFromClipSpace.data[2].w, g_Lights_1._m0[i].m_mFromClipSpace.data[3].w));
	                do
	                {
	                    bvec3 _340 = greaterThan(g_Lights_1._m0[i].m_vMinBounds.xyz, _276);
	                    bvec3 _341 = lessThan(g_Lights_1._m0[i].m_vMaxBounds.xyz, _275);
	                    if (any(bvec3(_340.x || _341.x, _340.y || _341.y, _340.z || _341.z)))
	                    {
	                        _221 = false;
	                        break;
	                    }
	                    _221 = true;
	                    break;
	                } while(false);
	                if (!_221)
	                {
	                    break;
	                }
	                do
	                {
	                    if (g_Lights_1._m0[i].m_vLightPosition.w == 0.0)
	                    {
	                        _220 = 3.4028234663852885981170418348452e+38;
	                        break;
	                    }
	                    if (g_Lights_1._m0[i].m_vDistanceFade_vSkirt.y == 0.0)
	                    {
	                        _220 = 3.4028234663852885981170418348452e+38;
	                        break;
	                    }
	                    _220 = (-g_Lights_1._m0[i].m_vDistanceFade_vSkirt.x) / g_Lights_1._m0[i].m_vDistanceFade_vSkirt.y;
	                    break;
	                } while(false);
	                if (_220 < 3.4028234663852885981170418348452e+38)
	                {
	                    vec3 vDelta = g_Lights_1._m0[i].m_vLightPosition.xyz - clamp(g_Lights_1._m0[i].m_vLightPosition.xyz, _275, _276);
	                    if (dot(vDelta, vDelta) > (_220 * _220))
	                    {
	                        break;
	                    }
	                }
	                vec4 _377 = _327 * vec4(vec3(-1.0, -1.0, 0.0), 1.0);
	                vec3 _381 = _377.xyz / vec3(_377.w);
	                vec4 _383;
	                _383.x = _381.x;
	                _383.y = _381.y;
	                _383.z = _381.z;
	                vec3 _99 = _383.xyz;
	                vec4 _390 = _327 * vec4(vec3(-1.0, 1.0, 0.0), 1.0);
	                vec3 _394 = _390.xyz / vec3(_390.w);
	                vec4 _396;
	                _396.x = _394.x;
	                _396.y = _394.y;
	                _396.z = _394.z;
	                vec3 _98 = _396.xyz;
	                vec4 _403 = _327 * vec4(vec3(1.0, 1.0, 0.0), 1.0);
	                vec3 _407 = _403.xyz / vec3(_403.w);
	                vec4 _409;
	                _409.x = _407.x;
	                _409.y = _407.y;
	                _409.z = _407.z;
	                vec3 _97 = _409.xyz;
	                vec4 _416 = _327 * vec4(vec3(1.0, -1.0, 0.0), 1.0);
	                vec3 _420 = _416.xyz / vec3(_416.w);
	                vec4 _422;
	                _422.x = _420.x;
	                _422.y = _420.y;
	                _422.z = _420.z;
	                vec3 _96 = _422.xyz;
	                vec4 _429 = _327 * vec4(vec3(-1.0, -1.0, 1.0), 1.0);
	                vec3 _433 = _429.xyz / vec3(_429.w);
	                vec4 _435;
	                _435.x = _433.x;
	                _435.y = _433.y;
	                _435.z = _433.z;
	                vec3 _95 = _435.xyz;
	                vec4 _442 = _327 * vec4(vec3(-1.0, 1.0, 1.0), 1.0);
	                vec3 _446 = _442.xyz / vec3(_442.w);
	                vec4 _448;
	                _448.x = _446.x;
	                _448.y = _446.y;
	                _448.z = _446.z;
	                vec3 _94 = _448.xyz;
	                vec4 _455 = _327 * vec4(vec3(1.0), 1.0);
	                vec3 _459 = _455.xyz / vec3(_455.w);
	                vec4 _461;
	                _461.x = _459.x;
	                _461.y = _459.y;
	                _461.z = _459.z;
	                vec3 _93 = _461.xyz;
	                vec4 _468 = _327 * vec4(vec3(1.0, -1.0, 1.0), 1.0);
	                vec3 _472 = _468.xyz / vec3(_468.w);
	                vec4 _474;
	                _474.x = _472.x;
	                _474.y = _472.y;
	                _474.z = _472.z;
	                vec3 _92 = _474.xyz;
	                vec3 _483 = normalize(cross(_396.xyz - _383.xyz, _409.xyz - _383.xyz));
	                vec4 _485 = vec4(_483, dot(_483, _396.xyz));
	                if (false)
	                {
	                    _219 = _276.x;
	                }
	                else
	                {
	                    _219 = _275.x;
	                }
	                vec3 _492 = _218;
	                _492.x = _219;
	                _218 = _492;
	                if (false)
	                {
	                    _219 = _276.y;
	                }
	                else
	                {
	                    _219 = _275.y;
	                }
	                vec3 _500 = _218;
	                _500.y = _219;
	                _218 = _500;
	                if (false)
	                {
	                    _219 = _276.z;
	                }
	                else
	                {
	                    _219 = _275.z;
	                }
	                vec3 _508 = _218;
	                _508.z = _219;
	                _218 = _508;
	                if (true)
	                {
	                    _217 = _276.x;
	                }
	                else
	                {
	                    _217 = _275.x;
	                }
	                vec3 _516 = _216;
	                _516.x = _217;
	                _216 = _516;
	                if (false)
	                {
	                    _217 = _276.y;
	                }
	                else
	                {
	                    _217 = _275.y;
	                }
	                vec3 _524 = _216;
	                _524.y = _217;
	                _216 = _524;
	                if (false)
	                {
	                    _217 = _276.z;
	                }
	                else
	                {
	                    _217 = _275.z;
	                }
	                vec3 _532 = _216;
	                _532.z = _217;
	                _216 = _532;
	                if (false)
	                {
	                    _215 = _276.x;
	                }
	                else
	                {
	                    _215 = _275.x;
	                }
	                vec3 _540 = _214;
	                _540.x = _215;
	                _214 = _540;
	                if (true)
	                {
	                    _215 = _276.y;
	                }
	                else
	                {
	                    _215 = _275.y;
	                }
	                vec3 _548 = _214;
	                _548.y = _215;
	                _214 = _548;
	                if (false)
	                {
	                    _215 = _276.z;
	                }
	                else
	                {
	                    _215 = _275.z;
	                }
	                vec3 _556 = _214;
	                _556.z = _215;
	                _214 = _556;
	                if (true)
	                {
	                    _213 = _276.x;
	                }
	                else
	                {
	                    _213 = _275.x;
	                }
	                vec3 _564 = _212;
	                _564.x = _213;
	                _212 = _564;
	                if (true)
	                {
	                    _213 = _276.y;
	                }
	                else
	                {
	                    _213 = _275.y;
	                }
	                vec3 _572 = _212;
	                _572.y = _213;
	                _212 = _572;
	                if (false)
	                {
	                    _213 = _276.z;
	                }
	                else
	                {
	                    _213 = _275.z;
	                }
	                vec3 _580 = _212;
	                _580.z = _213;
	                _212 = _580;
	                if (false)
	                {
	                    _211 = _276.x;
	                }
	                else
	                {
	                    _211 = _275.x;
	                }
	                vec3 _588 = _210;
	                _588.x = _211;
	                _210 = _588;
	                if (false)
	                {
	                    _211 = _276.y;
	                }
	                else
	                {
	                    _211 = _275.y;
	                }
	                vec3 _596 = _210;
	                _596.y = _211;
	                _210 = _596;
	                if (true)
	                {
	                    _211 = _276.z;
	                }
	                else
	                {
	                    _211 = _275.z;
	                }
	                vec3 _604 = _210;
	                _604.z = _211;
	                _210 = _604;
	                if (true)
	                {
	                    _209 = _276.x;
	                }
	                else
	                {
	                    _209 = _275.x;
	                }
	                vec3 _612 = _208;
	                _612.x = _209;
	                _208 = _612;
	                if (false)
	                {
	                    _209 = _276.y;
	                }
	                else
	                {
	                    _209 = _275.y;
	                }
	                vec3 _620 = _208;
	                _620.y = _209;
	                _208 = _620;
	                if (true)
	                {
	                    _209 = _276.z;
	                }
	                else
	                {
	                    _209 = _275.z;
	                }
	                vec3 _628 = _208;
	                _628.z = _209;
	                _208 = _628;
	                if (false)
	                {
	                    _207 = _276.x;
	                }
	                else
	                {
	                    _207 = _275.x;
	                }
	                vec3 _636 = _206;
	                _636.x = _207;
	                _206 = _636;
	                if (true)
	                {
	                    _207 = _276.y;
	                }
	                else
	                {
	                    _207 = _275.y;
	                }
	                vec3 _644 = _206;
	                _644.y = _207;
	                _206 = _644;
	                if (true)
	                {
	                    _207 = _276.z;
	                }
	                else
	                {
	                    _207 = _275.z;
	                }
	                vec3 _652 = _206;
	                _652.z = _207;
	                _206 = _652;
	                if (true)
	                {
	                    _205 = _276.x;
	                }
	                else
	                {
	                    _205 = _275.x;
	                }
	                vec3 _660 = _204;
	                _660.x = _205;
	                _204 = _660;
	                if (true)
	                {
	                    _205 = _276.y;
	                }
	                else
	                {
	                    _205 = _275.y;
	                }
	                vec3 _668 = _204;
	                _668.y = _205;
	                _204 = _668;
	                if (true)
	                {
	                    _205 = _276.z;
	                }
	                else
	                {
	                    _205 = _275.z;
	                }
	                vec3 _676 = _204;
	                _676.z = _205;
	                _204 = _676;
	                do
	                {
	                    vec3 _680 = _485.xyz;
	                    float _682 = _485.w;
	                    vec4 _684 = _201;
	                    _684.x = dot(_680, _508) - _682;
	                    _684.y = dot(_680, _532) - _682;
	                    _684.z = dot(_680, _556) - _682;
	                    _684.w = dot(_680, _580) - _682;
	                    _201 = _684;
	                    vec4 _697 = _202;
	                    _697.x = dot(_680, _604) - _682;
	                    _697.y = dot(_680, _628) - _682;
	                    _697.z = dot(_680, _652) - _682;
	                    _697.w = dot(_680, _676) - _682;
	                    _202 = _697;
	                    if (all(greaterThan(_684, vec4(0.0))))
	                    {
	                        _203 = all(greaterThan(_202, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _203 = false;
	                    }
	                    if (_203)
	                    {
	                        _200 = 1.0;
	                        break;
	                    }
	                    if (all(lessThan(_201, vec4(0.0))))
	                    {
	                        _203 = all(lessThan(_202, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _203 = false;
	                    }
	                    if (_203)
	                    {
	                        _200 = -1.0;
	                        break;
	                    }
	                    _200 = 0.0;
	                    break;
	                } while(false);
	                if (_200 < 0.0)
	                {
	                    break;
	                }
	                vec3 _741 = normalize(cross(_93 - _95, _94 - _95));
	                vec4 _743 = vec4(_741, dot(_741, _93));
	                if (false)
	                {
	                    _199 = _276.x;
	                }
	                else
	                {
	                    _199 = _275.x;
	                }
	                vec3 _750 = _198;
	                _750.x = _199;
	                _198 = _750;
	                if (false)
	                {
	                    _199 = _276.y;
	                }
	                else
	                {
	                    _199 = _275.y;
	                }
	                vec3 _758 = _198;
	                _758.y = _199;
	                _198 = _758;
	                if (false)
	                {
	                    _199 = _276.z;
	                }
	                else
	                {
	                    _199 = _275.z;
	                }
	                vec3 _766 = _198;
	                _766.z = _199;
	                _198 = _766;
	                if (true)
	                {
	                    _197 = _276.x;
	                }
	                else
	                {
	                    _197 = _275.x;
	                }
	                vec3 _774 = _196;
	                _774.x = _197;
	                _196 = _774;
	                if (false)
	                {
	                    _197 = _276.y;
	                }
	                else
	                {
	                    _197 = _275.y;
	                }
	                vec3 _782 = _196;
	                _782.y = _197;
	                _196 = _782;
	                if (false)
	                {
	                    _197 = _276.z;
	                }
	                else
	                {
	                    _197 = _275.z;
	                }
	                vec3 _790 = _196;
	                _790.z = _197;
	                _196 = _790;
	                if (false)
	                {
	                    _195 = _276.x;
	                }
	                else
	                {
	                    _195 = _275.x;
	                }
	                vec3 _798 = _194;
	                _798.x = _195;
	                _194 = _798;
	                if (true)
	                {
	                    _195 = _276.y;
	                }
	                else
	                {
	                    _195 = _275.y;
	                }
	                vec3 _806 = _194;
	                _806.y = _195;
	                _194 = _806;
	                if (false)
	                {
	                    _195 = _276.z;
	                }
	                else
	                {
	                    _195 = _275.z;
	                }
	                vec3 _814 = _194;
	                _814.z = _195;
	                _194 = _814;
	                if (true)
	                {
	                    _193 = _276.x;
	                }
	                else
	                {
	                    _193 = _275.x;
	                }
	                vec3 _822 = _192;
	                _822.x = _193;
	                _192 = _822;
	                if (true)
	                {
	                    _193 = _276.y;
	                }
	                else
	                {
	                    _193 = _275.y;
	                }
	                vec3 _830 = _192;
	                _830.y = _193;
	                _192 = _830;
	                if (false)
	                {
	                    _193 = _276.z;
	                }
	                else
	                {
	                    _193 = _275.z;
	                }
	                vec3 _838 = _192;
	                _838.z = _193;
	                _192 = _838;
	                if (false)
	                {
	                    _191 = _276.x;
	                }
	                else
	                {
	                    _191 = _275.x;
	                }
	                vec3 _846 = _190;
	                _846.x = _191;
	                _190 = _846;
	                if (false)
	                {
	                    _191 = _276.y;
	                }
	                else
	                {
	                    _191 = _275.y;
	                }
	                vec3 _854 = _190;
	                _854.y = _191;
	                _190 = _854;
	                if (true)
	                {
	                    _191 = _276.z;
	                }
	                else
	                {
	                    _191 = _275.z;
	                }
	                vec3 _862 = _190;
	                _862.z = _191;
	                _190 = _862;
	                if (true)
	                {
	                    _189 = _276.x;
	                }
	                else
	                {
	                    _189 = _275.x;
	                }
	                vec3 _870 = _188;
	                _870.x = _189;
	                _188 = _870;
	                if (false)
	                {
	                    _189 = _276.y;
	                }
	                else
	                {
	                    _189 = _275.y;
	                }
	                vec3 _878 = _188;
	                _878.y = _189;
	                _188 = _878;
	                if (true)
	                {
	                    _189 = _276.z;
	                }
	                else
	                {
	                    _189 = _275.z;
	                }
	                vec3 _886 = _188;
	                _886.z = _189;
	                _188 = _886;
	                if (false)
	                {
	                    _187 = _276.x;
	                }
	                else
	                {
	                    _187 = _275.x;
	                }
	                vec3 _894 = _186;
	                _894.x = _187;
	                _186 = _894;
	                if (true)
	                {
	                    _187 = _276.y;
	                }
	                else
	                {
	                    _187 = _275.y;
	                }
	                vec3 _902 = _186;
	                _902.y = _187;
	                _186 = _902;
	                if (true)
	                {
	                    _187 = _276.z;
	                }
	                else
	                {
	                    _187 = _275.z;
	                }
	                vec3 _910 = _186;
	                _910.z = _187;
	                _186 = _910;
	                if (true)
	                {
	                    _185 = _276.x;
	                }
	                else
	                {
	                    _185 = _275.x;
	                }
	                vec3 _918 = _184;
	                _918.x = _185;
	                _184 = _918;
	                if (true)
	                {
	                    _185 = _276.y;
	                }
	                else
	                {
	                    _185 = _275.y;
	                }
	                vec3 _926 = _184;
	                _926.y = _185;
	                _184 = _926;
	                if (true)
	                {
	                    _185 = _276.z;
	                }
	                else
	                {
	                    _185 = _275.z;
	                }
	                vec3 _934 = _184;
	                _934.z = _185;
	                _184 = _934;
	                do
	                {
	                    vec3 _938 = _743.xyz;
	                    float _940 = _743.w;
	                    vec4 _942 = _181;
	                    _942.x = dot(_938, _766) - _940;
	                    _942.y = dot(_938, _790) - _940;
	                    _942.z = dot(_938, _814) - _940;
	                    _942.w = dot(_938, _838) - _940;
	                    _181 = _942;
	                    vec4 _955 = _182;
	                    _955.x = dot(_938, _862) - _940;
	                    _955.y = dot(_938, _886) - _940;
	                    _955.z = dot(_938, _910) - _940;
	                    _955.w = dot(_938, _934) - _940;
	                    _182 = _955;
	                    if (all(greaterThan(_942, vec4(0.0))))
	                    {
	                        _183 = all(greaterThan(_182, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _183 = false;
	                    }
	                    if (_183)
	                    {
	                        _180 = 1.0;
	                        break;
	                    }
	                    if (all(lessThan(_181, vec4(0.0))))
	                    {
	                        _183 = all(lessThan(_182, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _183 = false;
	                    }
	                    if (_183)
	                    {
	                        _180 = -1.0;
	                        break;
	                    }
	                    _180 = 0.0;
	                    break;
	                } while(false);
	                if (_180 < 0.0)
	                {
	                    break;
	                }
	                vec3 _999 = normalize(cross(_95 - _99, _94 - _99));
	                vec4 _1001 = vec4(_999, dot(_999, _95));
	                if (false)
	                {
	                    _179 = _276.x;
	                }
	                else
	                {
	                    _179 = _275.x;
	                }
	                vec3 _1008 = _178;
	                _1008.x = _179;
	                _178 = _1008;
	                if (false)
	                {
	                    _179 = _276.y;
	                }
	                else
	                {
	                    _179 = _275.y;
	                }
	                vec3 _1016 = _178;
	                _1016.y = _179;
	                _178 = _1016;
	                if (false)
	                {
	                    _179 = _276.z;
	                }
	                else
	                {
	                    _179 = _275.z;
	                }
	                vec3 _1024 = _178;
	                _1024.z = _179;
	                _178 = _1024;
	                if (true)
	                {
	                    _177 = _276.x;
	                }
	                else
	                {
	                    _177 = _275.x;
	                }
	                vec3 _1032 = _176;
	                _1032.x = _177;
	                _176 = _1032;
	                if (false)
	                {
	                    _177 = _276.y;
	                }
	                else
	                {
	                    _177 = _275.y;
	                }
	                vec3 _1040 = _176;
	                _1040.y = _177;
	                _176 = _1040;
	                if (false)
	                {
	                    _177 = _276.z;
	                }
	                else
	                {
	                    _177 = _275.z;
	                }
	                vec3 _1048 = _176;
	                _1048.z = _177;
	                _176 = _1048;
	                if (false)
	                {
	                    _175 = _276.x;
	                }
	                else
	                {
	                    _175 = _275.x;
	                }
	                vec3 _1056 = _174;
	                _1056.x = _175;
	                _174 = _1056;
	                if (true)
	                {
	                    _175 = _276.y;
	                }
	                else
	                {
	                    _175 = _275.y;
	                }
	                vec3 _1064 = _174;
	                _1064.y = _175;
	                _174 = _1064;
	                if (false)
	                {
	                    _175 = _276.z;
	                }
	                else
	                {
	                    _175 = _275.z;
	                }
	                vec3 _1072 = _174;
	                _1072.z = _175;
	                _174 = _1072;
	                if (true)
	                {
	                    _173 = _276.x;
	                }
	                else
	                {
	                    _173 = _275.x;
	                }
	                vec3 _1080 = _172;
	                _1080.x = _173;
	                _172 = _1080;
	                if (true)
	                {
	                    _173 = _276.y;
	                }
	                else
	                {
	                    _173 = _275.y;
	                }
	                vec3 _1088 = _172;
	                _1088.y = _173;
	                _172 = _1088;
	                if (false)
	                {
	                    _173 = _276.z;
	                }
	                else
	                {
	                    _173 = _275.z;
	                }
	                vec3 _1096 = _172;
	                _1096.z = _173;
	                _172 = _1096;
	                if (false)
	                {
	                    _171 = _276.x;
	                }
	                else
	                {
	                    _171 = _275.x;
	                }
	                vec3 _1104 = _170;
	                _1104.x = _171;
	                _170 = _1104;
	                if (false)
	                {
	                    _171 = _276.y;
	                }
	                else
	                {
	                    _171 = _275.y;
	                }
	                vec3 _1112 = _170;
	                _1112.y = _171;
	                _170 = _1112;
	                if (true)
	                {
	                    _171 = _276.z;
	                }
	                else
	                {
	                    _171 = _275.z;
	                }
	                vec3 _1120 = _170;
	                _1120.z = _171;
	                _170 = _1120;
	                if (true)
	                {
	                    _169 = _276.x;
	                }
	                else
	                {
	                    _169 = _275.x;
	                }
	                vec3 _1128 = _168;
	                _1128.x = _169;
	                _168 = _1128;
	                if (false)
	                {
	                    _169 = _276.y;
	                }
	                else
	                {
	                    _169 = _275.y;
	                }
	                vec3 _1136 = _168;
	                _1136.y = _169;
	                _168 = _1136;
	                if (true)
	                {
	                    _169 = _276.z;
	                }
	                else
	                {
	                    _169 = _275.z;
	                }
	                vec3 _1144 = _168;
	                _1144.z = _169;
	                _168 = _1144;
	                if (false)
	                {
	                    _167 = _276.x;
	                }
	                else
	                {
	                    _167 = _275.x;
	                }
	                vec3 _1152 = _166;
	                _1152.x = _167;
	                _166 = _1152;
	                if (true)
	                {
	                    _167 = _276.y;
	                }
	                else
	                {
	                    _167 = _275.y;
	                }
	                vec3 _1160 = _166;
	                _1160.y = _167;
	                _166 = _1160;
	                if (true)
	                {
	                    _167 = _276.z;
	                }
	                else
	                {
	                    _167 = _275.z;
	                }
	                vec3 _1168 = _166;
	                _1168.z = _167;
	                _166 = _1168;
	                if (true)
	                {
	                    _165 = _276.x;
	                }
	                else
	                {
	                    _165 = _275.x;
	                }
	                vec3 _1176 = _164;
	                _1176.x = _165;
	                _164 = _1176;
	                if (true)
	                {
	                    _165 = _276.y;
	                }
	                else
	                {
	                    _165 = _275.y;
	                }
	                vec3 _1184 = _164;
	                _1184.y = _165;
	                _164 = _1184;
	                if (true)
	                {
	                    _165 = _276.z;
	                }
	                else
	                {
	                    _165 = _275.z;
	                }
	                vec3 _1192 = _164;
	                _1192.z = _165;
	                _164 = _1192;
	                do
	                {
	                    vec3 _1196 = _1001.xyz;
	                    float _1198 = _1001.w;
	                    vec4 _1200 = _161;
	                    _1200.x = dot(_1196, _1024) - _1198;
	                    _1200.y = dot(_1196, _1048) - _1198;
	                    _1200.z = dot(_1196, _1072) - _1198;
	                    _1200.w = dot(_1196, _1096) - _1198;
	                    _161 = _1200;
	                    vec4 _1213 = _162;
	                    _1213.x = dot(_1196, _1120) - _1198;
	                    _1213.y = dot(_1196, _1144) - _1198;
	                    _1213.z = dot(_1196, _1168) - _1198;
	                    _1213.w = dot(_1196, _1192) - _1198;
	                    _162 = _1213;
	                    if (all(greaterThan(_1200, vec4(0.0))))
	                    {
	                        _163 = all(greaterThan(_162, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _163 = false;
	                    }
	                    if (_163)
	                    {
	                        _160 = 1.0;
	                        break;
	                    }
	                    if (all(lessThan(_161, vec4(0.0))))
	                    {
	                        _163 = all(lessThan(_162, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _163 = false;
	                    }
	                    if (_163)
	                    {
	                        _160 = -1.0;
	                        break;
	                    }
	                    _160 = 0.0;
	                    break;
	                } while(false);
	                if (_160 < 0.0)
	                {
	                    break;
	                }
	                vec3 _1257 = normalize(cross(_94 - _98, _93 - _98));
	                vec4 _1259 = vec4(_1257, dot(_1257, _94));
	                if (false)
	                {
	                    _159 = _276.x;
	                }
	                else
	                {
	                    _159 = _275.x;
	                }
	                vec3 _1266 = _158;
	                _1266.x = _159;
	                _158 = _1266;
	                if (false)
	                {
	                    _159 = _276.y;
	                }
	                else
	                {
	                    _159 = _275.y;
	                }
	                vec3 _1274 = _158;
	                _1274.y = _159;
	                _158 = _1274;
	                if (false)
	                {
	                    _159 = _276.z;
	                }
	                else
	                {
	                    _159 = _275.z;
	                }
	                vec3 _1282 = _158;
	                _1282.z = _159;
	                _158 = _1282;
	                if (true)
	                {
	                    _157 = _276.x;
	                }
	                else
	                {
	                    _157 = _275.x;
	                }
	                vec3 _1290 = _156;
	                _1290.x = _157;
	                _156 = _1290;
	                if (false)
	                {
	                    _157 = _276.y;
	                }
	                else
	                {
	                    _157 = _275.y;
	                }
	                vec3 _1298 = _156;
	                _1298.y = _157;
	                _156 = _1298;
	                if (false)
	                {
	                    _157 = _276.z;
	                }
	                else
	                {
	                    _157 = _275.z;
	                }
	                vec3 _1306 = _156;
	                _1306.z = _157;
	                _156 = _1306;
	                if (false)
	                {
	                    _155 = _276.x;
	                }
	                else
	                {
	                    _155 = _275.x;
	                }
	                vec3 _1314 = _154;
	                _1314.x = _155;
	                _154 = _1314;
	                if (true)
	                {
	                    _155 = _276.y;
	                }
	                else
	                {
	                    _155 = _275.y;
	                }
	                vec3 _1322 = _154;
	                _1322.y = _155;
	                _154 = _1322;
	                if (false)
	                {
	                    _155 = _276.z;
	                }
	                else
	                {
	                    _155 = _275.z;
	                }
	                vec3 _1330 = _154;
	                _1330.z = _155;
	                _154 = _1330;
	                if (true)
	                {
	                    _153 = _276.x;
	                }
	                else
	                {
	                    _153 = _275.x;
	                }
	                vec3 _1338 = _152;
	                _1338.x = _153;
	                _152 = _1338;
	                if (true)
	                {
	                    _153 = _276.y;
	                }
	                else
	                {
	                    _153 = _275.y;
	                }
	                vec3 _1346 = _152;
	                _1346.y = _153;
	                _152 = _1346;
	                if (false)
	                {
	                    _153 = _276.z;
	                }
	                else
	                {
	                    _153 = _275.z;
	                }
	                vec3 _1354 = _152;
	                _1354.z = _153;
	                _152 = _1354;
	                if (false)
	                {
	                    _151 = _276.x;
	                }
	                else
	                {
	                    _151 = _275.x;
	                }
	                vec3 _1362 = _150;
	                _1362.x = _151;
	                _150 = _1362;
	                if (false)
	                {
	                    _151 = _276.y;
	                }
	                else
	                {
	                    _151 = _275.y;
	                }
	                vec3 _1370 = _150;
	                _1370.y = _151;
	                _150 = _1370;
	                if (true)
	                {
	                    _151 = _276.z;
	                }
	                else
	                {
	                    _151 = _275.z;
	                }
	                vec3 _1378 = _150;
	                _1378.z = _151;
	                _150 = _1378;
	                if (true)
	                {
	                    _149 = _276.x;
	                }
	                else
	                {
	                    _149 = _275.x;
	                }
	                vec3 _1386 = _148;
	                _1386.x = _149;
	                _148 = _1386;
	                if (false)
	                {
	                    _149 = _276.y;
	                }
	                else
	                {
	                    _149 = _275.y;
	                }
	                vec3 _1394 = _148;
	                _1394.y = _149;
	                _148 = _1394;
	                if (true)
	                {
	                    _149 = _276.z;
	                }
	                else
	                {
	                    _149 = _275.z;
	                }
	                vec3 _1402 = _148;
	                _1402.z = _149;
	                _148 = _1402;
	                if (false)
	                {
	                    _147 = _276.x;
	                }
	                else
	                {
	                    _147 = _275.x;
	                }
	                vec3 _1410 = _146;
	                _1410.x = _147;
	                _146 = _1410;
	                if (true)
	                {
	                    _147 = _276.y;
	                }
	                else
	                {
	                    _147 = _275.y;
	                }
	                vec3 _1418 = _146;
	                _1418.y = _147;
	                _146 = _1418;
	                if (true)
	                {
	                    _147 = _276.z;
	                }
	                else
	                {
	                    _147 = _275.z;
	                }
	                vec3 _1426 = _146;
	                _1426.z = _147;
	                _146 = _1426;
	                if (true)
	                {
	                    _145 = _276.x;
	                }
	                else
	                {
	                    _145 = _275.x;
	                }
	                vec3 _1434 = _144;
	                _1434.x = _145;
	                _144 = _1434;
	                if (true)
	                {
	                    _145 = _276.y;
	                }
	                else
	                {
	                    _145 = _275.y;
	                }
	                vec3 _1442 = _144;
	                _1442.y = _145;
	                _144 = _1442;
	                if (true)
	                {
	                    _145 = _276.z;
	                }
	                else
	                {
	                    _145 = _275.z;
	                }
	                vec3 _1450 = _144;
	                _1450.z = _145;
	                _144 = _1450;
	                do
	                {
	                    vec3 _1454 = _1259.xyz;
	                    float _1456 = _1259.w;
	                    vec4 _1458 = _141;
	                    _1458.x = dot(_1454, _1282) - _1456;
	                    _1458.y = dot(_1454, _1306) - _1456;
	                    _1458.z = dot(_1454, _1330) - _1456;
	                    _1458.w = dot(_1454, _1354) - _1456;
	                    _141 = _1458;
	                    vec4 _1471 = _142;
	                    _1471.x = dot(_1454, _1378) - _1456;
	                    _1471.y = dot(_1454, _1402) - _1456;
	                    _1471.z = dot(_1454, _1426) - _1456;
	                    _1471.w = dot(_1454, _1450) - _1456;
	                    _142 = _1471;
	                    if (all(greaterThan(_1458, vec4(0.0))))
	                    {
	                        _143 = all(greaterThan(_142, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _143 = false;
	                    }
	                    if (_143)
	                    {
	                        _140 = 1.0;
	                        break;
	                    }
	                    if (all(lessThan(_141, vec4(0.0))))
	                    {
	                        _143 = all(lessThan(_142, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _143 = false;
	                    }
	                    if (_143)
	                    {
	                        _140 = -1.0;
	                        break;
	                    }
	                    _140 = 0.0;
	                    break;
	                } while(false);
	                if (_140 < 0.0)
	                {
	                    break;
	                }
	                vec3 _1515 = normalize(cross(_93 - _97, _92 - _97));
	                vec4 _1517 = vec4(_1515, dot(_1515, _93));
	                if (false)
	                {
	                    _139 = _276.x;
	                }
	                else
	                {
	                    _139 = _275.x;
	                }
	                vec3 _1524 = _138;
	                _1524.x = _139;
	                _138 = _1524;
	                if (false)
	                {
	                    _139 = _276.y;
	                }
	                else
	                {
	                    _139 = _275.y;
	                }
	                vec3 _1532 = _138;
	                _1532.y = _139;
	                _138 = _1532;
	                if (false)
	                {
	                    _139 = _276.z;
	                }
	                else
	                {
	                    _139 = _275.z;
	                }
	                vec3 _1540 = _138;
	                _1540.z = _139;
	                _138 = _1540;
	                if (true)
	                {
	                    _137 = _276.x;
	                }
	                else
	                {
	                    _137 = _275.x;
	                }
	                vec3 _1548 = _136;
	                _1548.x = _137;
	                _136 = _1548;
	                if (false)
	                {
	                    _137 = _276.y;
	                }
	                else
	                {
	                    _137 = _275.y;
	                }
	                vec3 _1556 = _136;
	                _1556.y = _137;
	                _136 = _1556;
	                if (false)
	                {
	                    _137 = _276.z;
	                }
	                else
	                {
	                    _137 = _275.z;
	                }
	                vec3 _1564 = _136;
	                _1564.z = _137;
	                _136 = _1564;
	                if (false)
	                {
	                    _135 = _276.x;
	                }
	                else
	                {
	                    _135 = _275.x;
	                }
	                vec3 _1572 = _134;
	                _1572.x = _135;
	                _134 = _1572;
	                if (true)
	                {
	                    _135 = _276.y;
	                }
	                else
	                {
	                    _135 = _275.y;
	                }
	                vec3 _1580 = _134;
	                _1580.y = _135;
	                _134 = _1580;
	                if (false)
	                {
	                    _135 = _276.z;
	                }
	                else
	                {
	                    _135 = _275.z;
	                }
	                vec3 _1588 = _134;
	                _1588.z = _135;
	                _134 = _1588;
	                if (true)
	                {
	                    _133 = _276.x;
	                }
	                else
	                {
	                    _133 = _275.x;
	                }
	                vec3 _1596 = _132;
	                _1596.x = _133;
	                _132 = _1596;
	                if (true)
	                {
	                    _133 = _276.y;
	                }
	                else
	                {
	                    _133 = _275.y;
	                }
	                vec3 _1604 = _132;
	                _1604.y = _133;
	                _132 = _1604;
	                if (false)
	                {
	                    _133 = _276.z;
	                }
	                else
	                {
	                    _133 = _275.z;
	                }
	                vec3 _1612 = _132;
	                _1612.z = _133;
	                _132 = _1612;
	                if (false)
	                {
	                    _131 = _276.x;
	                }
	                else
	                {
	                    _131 = _275.x;
	                }
	                vec3 _1620 = _130;
	                _1620.x = _131;
	                _130 = _1620;
	                if (false)
	                {
	                    _131 = _276.y;
	                }
	                else
	                {
	                    _131 = _275.y;
	                }
	                vec3 _1628 = _130;
	                _1628.y = _131;
	                _130 = _1628;
	                if (true)
	                {
	                    _131 = _276.z;
	                }
	                else
	                {
	                    _131 = _275.z;
	                }
	                vec3 _1636 = _130;
	                _1636.z = _131;
	                _130 = _1636;
	                if (true)
	                {
	                    _129 = _276.x;
	                }
	                else
	                {
	                    _129 = _275.x;
	                }
	                vec3 _1644 = _128;
	                _1644.x = _129;
	                _128 = _1644;
	                if (false)
	                {
	                    _129 = _276.y;
	                }
	                else
	                {
	                    _129 = _275.y;
	                }
	                vec3 _1652 = _128;
	                _1652.y = _129;
	                _128 = _1652;
	                if (true)
	                {
	                    _129 = _276.z;
	                }
	                else
	                {
	                    _129 = _275.z;
	                }
	                vec3 _1660 = _128;
	                _1660.z = _129;
	                _128 = _1660;
	                if (false)
	                {
	                    _127 = _276.x;
	                }
	                else
	                {
	                    _127 = _275.x;
	                }
	                vec3 _1668 = _126;
	                _1668.x = _127;
	                _126 = _1668;
	                if (true)
	                {
	                    _127 = _276.y;
	                }
	                else
	                {
	                    _127 = _275.y;
	                }
	                vec3 _1676 = _126;
	                _1676.y = _127;
	                _126 = _1676;
	                if (true)
	                {
	                    _127 = _276.z;
	                }
	                else
	                {
	                    _127 = _275.z;
	                }
	                vec3 _1684 = _126;
	                _1684.z = _127;
	                _126 = _1684;
	                if (true)
	                {
	                    _125 = _276.x;
	                }
	                else
	                {
	                    _125 = _275.x;
	                }
	                vec3 _1692 = _124;
	                _1692.x = _125;
	                _124 = _1692;
	                if (true)
	                {
	                    _125 = _276.y;
	                }
	                else
	                {
	                    _125 = _275.y;
	                }
	                vec3 _1700 = _124;
	                _1700.y = _125;
	                _124 = _1700;
	                if (true)
	                {
	                    _125 = _276.z;
	                }
	                else
	                {
	                    _125 = _275.z;
	                }
	                vec3 _1708 = _124;
	                _1708.z = _125;
	                _124 = _1708;
	                do
	                {
	                    vec3 _1712 = _1517.xyz;
	                    float _1714 = _1517.w;
	                    vec4 _1716 = _121;
	                    _1716.x = dot(_1712, _1540) - _1714;
	                    _1716.y = dot(_1712, _1564) - _1714;
	                    _1716.z = dot(_1712, _1588) - _1714;
	                    _1716.w = dot(_1712, _1612) - _1714;
	                    _121 = _1716;
	                    vec4 _1729 = _122;
	                    _1729.x = dot(_1712, _1636) - _1714;
	                    _1729.y = dot(_1712, _1660) - _1714;
	                    _1729.z = dot(_1712, _1684) - _1714;
	                    _1729.w = dot(_1712, _1708) - _1714;
	                    _122 = _1729;
	                    if (all(greaterThan(_1716, vec4(0.0))))
	                    {
	                        _123 = all(greaterThan(_122, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _123 = false;
	                    }
	                    if (_123)
	                    {
	                        _120 = 1.0;
	                        break;
	                    }
	                    if (all(lessThan(_121, vec4(0.0))))
	                    {
	                        _123 = all(lessThan(_122, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _123 = false;
	                    }
	                    if (_123)
	                    {
	                        _120 = -1.0;
	                        break;
	                    }
	                    _120 = 0.0;
	                    break;
	                } while(false);
	                if (_120 < 0.0)
	                {
	                    break;
	                }
	                vec3 _1773 = normalize(cross(_92 - _96, _95 - _96));
	                vec4 _1775 = vec4(_1773, dot(_1773, _92));
	                if (false)
	                {
	                    _119 = _276.x;
	                }
	                else
	                {
	                    _119 = _275.x;
	                }
	                vec3 _1782 = _118;
	                _1782.x = _119;
	                _118 = _1782;
	                if (false)
	                {
	                    _119 = _276.y;
	                }
	                else
	                {
	                    _119 = _275.y;
	                }
	                vec3 _1790 = _118;
	                _1790.y = _119;
	                _118 = _1790;
	                if (false)
	                {
	                    _119 = _276.z;
	                }
	                else
	                {
	                    _119 = _275.z;
	                }
	                vec3 _1798 = _118;
	                _1798.z = _119;
	                _118 = _1798;
	                if (true)
	                {
	                    _117 = _276.x;
	                }
	                else
	                {
	                    _117 = _275.x;
	                }
	                vec3 _1806 = _116;
	                _1806.x = _117;
	                _116 = _1806;
	                if (false)
	                {
	                    _117 = _276.y;
	                }
	                else
	                {
	                    _117 = _275.y;
	                }
	                vec3 _1814 = _116;
	                _1814.y = _117;
	                _116 = _1814;
	                if (false)
	                {
	                    _117 = _276.z;
	                }
	                else
	                {
	                    _117 = _275.z;
	                }
	                vec3 _1822 = _116;
	                _1822.z = _117;
	                _116 = _1822;
	                if (false)
	                {
	                    _115 = _276.x;
	                }
	                else
	                {
	                    _115 = _275.x;
	                }
	                vec3 _1830 = _114;
	                _1830.x = _115;
	                _114 = _1830;
	                if (true)
	                {
	                    _115 = _276.y;
	                }
	                else
	                {
	                    _115 = _275.y;
	                }
	                vec3 _1838 = _114;
	                _1838.y = _115;
	                _114 = _1838;
	                if (false)
	                {
	                    _115 = _276.z;
	                }
	                else
	                {
	                    _115 = _275.z;
	                }
	                vec3 _1846 = _114;
	                _1846.z = _115;
	                _114 = _1846;
	                if (true)
	                {
	                    _113 = _276.x;
	                }
	                else
	                {
	                    _113 = _275.x;
	                }
	                vec3 _1854 = _112;
	                _1854.x = _113;
	                _112 = _1854;
	                if (true)
	                {
	                    _113 = _276.y;
	                }
	                else
	                {
	                    _113 = _275.y;
	                }
	                vec3 _1862 = _112;
	                _1862.y = _113;
	                _112 = _1862;
	                if (false)
	                {
	                    _113 = _276.z;
	                }
	                else
	                {
	                    _113 = _275.z;
	                }
	                vec3 _1870 = _112;
	                _1870.z = _113;
	                _112 = _1870;
	                if (false)
	                {
	                    _111 = _276.x;
	                }
	                else
	                {
	                    _111 = _275.x;
	                }
	                vec3 _1878 = _110;
	                _1878.x = _111;
	                _110 = _1878;
	                if (false)
	                {
	                    _111 = _276.y;
	                }
	                else
	                {
	                    _111 = _275.y;
	                }
	                vec3 _1886 = _110;
	                _1886.y = _111;
	                _110 = _1886;
	                if (true)
	                {
	                    _111 = _276.z;
	                }
	                else
	                {
	                    _111 = _275.z;
	                }
	                vec3 _1894 = _110;
	                _1894.z = _111;
	                _110 = _1894;
	                if (true)
	                {
	                    _109 = _276.x;
	                }
	                else
	                {
	                    _109 = _275.x;
	                }
	                vec3 _1902 = _108;
	                _1902.x = _109;
	                _108 = _1902;
	                if (false)
	                {
	                    _109 = _276.y;
	                }
	                else
	                {
	                    _109 = _275.y;
	                }
	                vec3 _1910 = _108;
	                _1910.y = _109;
	                _108 = _1910;
	                if (true)
	                {
	                    _109 = _276.z;
	                }
	                else
	                {
	                    _109 = _275.z;
	                }
	                vec3 _1918 = _108;
	                _1918.z = _109;
	                _108 = _1918;
	                if (false)
	                {
	                    _107 = _276.x;
	                }
	                else
	                {
	                    _107 = _275.x;
	                }
	                vec3 _1926 = _106;
	                _1926.x = _107;
	                _106 = _1926;
	                if (true)
	                {
	                    _107 = _276.y;
	                }
	                else
	                {
	                    _107 = _275.y;
	                }
	                vec3 _1934 = _106;
	                _1934.y = _107;
	                _106 = _1934;
	                if (true)
	                {
	                    _107 = _276.z;
	                }
	                else
	                {
	                    _107 = _275.z;
	                }
	                vec3 _1942 = _106;
	                _1942.z = _107;
	                _106 = _1942;
	                if (true)
	                {
	                    _105 = _276.x;
	                }
	                else
	                {
	                    _105 = _275.x;
	                }
	                vec3 _1950 = _104;
	                _1950.x = _105;
	                _104 = _1950;
	                if (true)
	                {
	                    _105 = _276.y;
	                }
	                else
	                {
	                    _105 = _275.y;
	                }
	                vec3 _1958 = _104;
	                _1958.y = _105;
	                _104 = _1958;
	                if (true)
	                {
	                    _105 = _276.z;
	                }
	                else
	                {
	                    _105 = _275.z;
	                }
	                vec3 _1966 = _104;
	                _1966.z = _105;
	                _104 = _1966;
	                do
	                {
	                    vec3 _1970 = _1775.xyz;
	                    float _1972 = _1775.w;
	                    vec4 _1974 = _101;
	                    _1974.x = dot(_1970, _1798) - _1972;
	                    _1974.y = dot(_1970, _1822) - _1972;
	                    _1974.z = dot(_1970, _1846) - _1972;
	                    _1974.w = dot(_1970, _1870) - _1972;
	                    _101 = _1974;
	                    vec4 _1987 = _102;
	                    _1987.x = dot(_1970, _1894) - _1972;
	                    _1987.y = dot(_1970, _1918) - _1972;
	                    _1987.z = dot(_1970, _1942) - _1972;
	                    _1987.w = dot(_1970, _1966) - _1972;
	                    _102 = _1987;
	                    if (all(greaterThan(_1974, vec4(0.0))))
	                    {
	                        _103 = all(greaterThan(_102, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _103 = false;
	                    }
	                    if (_103)
	                    {
	                        _100 = 1.0;
	                        break;
	                    }
	                    if (all(lessThan(_101, vec4(0.0))))
	                    {
	                        _103 = all(lessThan(_102, vec4(0.0)));
	                    }
	                    else
	                    {
	                        _103 = false;
	                    }
	                    if (_103)
	                    {
	                        _100 = -1.0;
	                        break;
	                    }
	                    _100 = 0.0;
	                    break;
	                } while(false);
	                if (_100 < 0.0)
	                {
	                    break;
	                }
	                nBits |= int(1u << uint(i - nStartLight));
	                break;
	            } while(false);
	            if (_287_ladder_break)
	            {
	                break;
	            }
	            i++;
	            continue;
	        }
	        g_LightBins._m0[((((_244 * _236.y) * _241) + (_244 * gl_LaunchIDEXT.y)) + (_235 * gl_LaunchIDEXT.x)) + nMask] = uint(nBits);
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
