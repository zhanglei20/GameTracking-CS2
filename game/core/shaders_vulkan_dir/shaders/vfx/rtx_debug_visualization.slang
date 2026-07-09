//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Debug visualization for various ray traced properties";
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
	DynamicCombo( D_DEBUG_MODE, 0..12 );
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (15512 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
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
	
	vec4 _128;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    layout(row_major) SceneGlobalInfoGPU_t_natural _member0[];
	} g_SceneGlobalInfo;
	
	layout(push_constant, std430) uniform PushConstants_t_t_natural
	{
	    layout(row_major) mat4 m_mInvViewProj;
	    vec4 m_vCameraOrigin;
	    vec4 m_vRandomOffsets;
	    ivec4 m_nIntParams;
	} PushConstants_t;
	
	layout(set = 6, binding = 158) uniform image2D g_OutputImage;
	layout(set = 6, binding = 161) uniform readonly image3D g_RandomSamples;
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(set = 6, binding = 159) uniform image2D g_VarianceImage;
	
	void main()
	{
	    vec2 _199 = (((vec2(gl_LaunchIDEXT.xy) + PushConstants_t.m_vRandomOffsets.xy) / vec2(gl_LaunchSizeEXT.xy)) * 2.0) - vec2(1.0);
	    _199.y = -_199.y;
	    vec4 _205 = PushConstants_t.m_mInvViewProj * vec4(_199.xy, 0.0, 1.0);
	    vec3 _209 = _205.xyz / vec3(_205.w);
	    vec4 _211;
	    _211.x = _209.x;
	    _211.y = _209.y;
	    _211.z = _209.z;
	    vec3 _220 = normalize(_211.xyz - PushConstants_t.m_vCameraOrigin.xyz);
	    vec4 vCurrentSample;
	    if (PushConstants_t.m_nIntParams.y > 0)
	    {
	        vCurrentSample = imageLoad(g_OutputImage, ivec2(gl_LaunchIDEXT.xy));
	    }
	    else
	    {
	        vCurrentSample = vec4(0.0);
	    }
	    uvec3 _235 = uvec3(imageSize(g_RandomSamples));
	    ivec3 _181;
	    ivec3 _238 = _181;
	    _238.x = int(_235.x);
	    _238.y = int(_235.y);
	    _238.z = int(_235.z);
	    _181 = _238;
	    ivec2 _247 = ivec2(gl_LaunchIDEXT.xy) - _238.xy * (ivec2(gl_LaunchIDEXT.xy) / _238.xy);
	    f16vec3 _254 = f16vec3(vec3(0.0));
	    vec3 _157;
	    p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _157, 3.4028234663852885981170418348452e+38, imageLoad(g_RandomSamples, ivec3(_247.xy, 1)).xy.y, -1, false, MaterialDataMinimal_t(_254, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _254, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	    traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, PushConstants_t.m_vCameraOrigin.xyz, 0.0, _220, 56755.83984375, 0);
	    vec3 _156 = p.vSmoothPositionWs;
	    vec3 _155 = p.vFaceNormalWs;
	    float _154 = p.flHitT;
	    f16vec3 _137 = p.material.vNormalWs;
	    float16_t _136 = p.material.flMetalness;
	    f16vec3 _135 = p.material.vAlbedo;
	    float16_t _134 = p.material.flRoughness;
	    f16vec3 _133 = p.material.vEmissive;
	    float16_t _132 = p.material.flReflectance;
	    uint _131 = p.material.nMaterialTypeAndFlags;
	    f16vec4 _130 = p.material.vMaterialBits;
	    vec3 vNewSample;
	    if (p.nInstance != (-1))
	    {
	        vec3 _153 = PushConstants_t.m_vCameraOrigin.xyz;
	        vec3 _152 = _220;
	        do
	        {
	            vec3 _160 = _156;
	            vec3 _159 = _155;
	            float _158 = _154;
	            f16vec3 _146 = _137;
	            vec3 _162 = (_153 + (_152 * _158)) + (_159 * ((abs(_153) + vec3(abs(_158))) * 9.9999997473787516355514526367188e-05));
	            vec3 _161 = _159;
	            bool _180;
	            if (false)
	            {
	                _180 = any(notEqual(_160, vec3(3.4028234663852885981170418348452e+38)));
	            }
	            else
	            {
	                _180 = false;
	            }
	            vec3 _313 = _160 - _162;
	            float _314 = length(_313);
	            vec3 _165 = _162;
	            float _164 = 0.0;
	            vec3 _163 = vec4(_313 / vec3(_314), _314).xyz;
	            float _179;
	            if (_180)
	            {
	                _179 = _314;
	            }
	            else
	            {
	                _179 = 0.0;
	            }
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _165, _164, _163, _179, 1);
	            if (_180)
	            {
	                _179 = p_1.m_flVisibility;
	            }
	            else
	            {
	                _179 = 0.0;
	            }
	            if (_179 == 1.0)
	            {
	                _162 = _160;
	                _161 = vec3(_146);
	            }
	            vec3 _166;
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _166, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_137, _136, _135, _134, _133, _132, _131, _130));
	            traceRayEXT(g_AccelStruct, 32u, 32u, 0u, 2u, 0u, _162 - ((_161 * 0.5) * 0.5), 0.0, _161, 0.5, 0);
	            f16vec3 _145 = p.material.vNormalWs;
	            float16_t _144 = p.material.flMetalness;
	            f16vec3 _143 = p.material.vAlbedo;
	            float16_t _142 = p.material.flRoughness;
	            f16vec3 _141 = p.material.vEmissive;
	            float16_t _140 = p.material.flReflectance;
	            uint _139 = p.material.nMaterialTypeAndFlags;
	            f16vec4 _138 = p.material.vMaterialBits;
	            if (p.nInstance != (-1))
	            {
	                _137 = _145;
	                _136 = _144;
	                _135 = _143;
	                _134 = _142;
	                _133 = _141;
	                _132 = _140;
	                _131 = _139;
	                _130 = _138;
	                break;
	            }
	            else
	            {
	                break;
	            }
	            break;
	        } while(false);
	        vec3 _151 = PushConstants_t.m_vCameraOrigin.xyz;
	        vec3 _150 = _220;
	        vec3 _149 = _156;
	        vec3 _148 = _155;
	        float _147 = _154;
	        vec3 _167 = (_151 + (_150 * _147)) + (_148 * ((abs(_151) + vec3(abs(_147))) * 9.9999997473787516355514526367188e-05));
	        bool _178;
	        if (true)
	        {
	            _178 = any(notEqual(_149, vec3(3.4028234663852885981170418348452e+38)));
	        }
	        else
	        {
	            _178 = false;
	        }
	        vec3 _410 = _149 - _167;
	        float _411 = length(_410);
	        vec3 _170 = _167;
	        float _169 = 0.0;
	        vec3 _168 = vec4(_410 / vec3(_411), _411).xyz;
	        float _177;
	        if (_178)
	        {
	            _177 = _411;
	        }
	        else
	        {
	            _177 = 0.0;
	        }
	        p_1 = PayloadShadow_t(1.0);
	        traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _170, _169, _168, _177, 1);
	        if (_178)
	        {
	            _177 = p_1.m_flVisibility;
	        }
	        else
	        {
	            _177 = 0.0;
	        }
	        if (_177 == 1.0)
	        {
	            _167 = _149;
	        }
	        vNewSample = vec3(_135);
	    }
	    else
	    {
	        vec2 _172 = imageLoad(g_RandomSamples, ivec3(_247.xy, 2)).xy;
	        bool _173;
	        if (_220.z < 0.0)
	        {
	            float _174 = _172.y;
	            bool _171;
	            do
	            {
	                if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w <= 0.0)
	                {
	                    _171 = false;
	                    break;
	                }
	                if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w >= 1.0)
	                {
	                    _171 = true;
	                    break;
	                }
	                if (_174 < g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w)
	                {
	                    _174 = min(_174 / g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                    _171 = true;
	                    break;
	                }
	                _174 = min((_174 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                _171 = false;
	                break;
	            } while(false);
	            vec2 _474 = _172;
	            _474.y = _174;
	            _172 = _474;
	            _173 = _171;
	        }
	        else
	        {
	            _173 = false;
	        }
	        vec3 _175;
	        vec3 _176;
	        if (_173)
	        {
	            float _482 = sqrt(_172.y);
	            float _484 = 6.283185482025146484375 * _172.x;
	            _175 = vec3(cos(_484) * _482, sin(_484) * _482, sqrt(max(0.0, 1.0 - _172.y)));
	            _176 = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.xyz;
	        }
	        else
	        {
	            _175 = _220;
	            _176 = vec3(0.0);
	        }
	        if (g_SceneGlobalInfo._member0[0].m_vIBLParams.y >= 0)
	        {
	            vec4 _524 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._member0[0].m_vIBLParams.y], g_Sampler), normalize(g_SceneGlobalInfo._member0[0].m_mIBLTransformI * vec4(_175, 0.0)), 0.0);
	            if (dot(_524.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.w)
	            {
	                _176 += (g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.xyz * _524.xyz);
	            }
	        }
	        else
	        {
	            _176 += g_SceneGlobalInfo._member0[0].m_vSkyColor.xyz;
	        }
	        if (false)
	        {
	            _176 *= g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.w;
	        }
	        if (_173)
	        {
	            _176 *= g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.xyz;
	        }
	        vNewSample = _176;
	    }
	    vec4 _567 = vec4(mix(vCurrentSample.xyz, vNewSample, vec3(1.0 / (1.0 + vCurrentSample.w))), 1.0 + vCurrentSample.w);
	    imageStore(g_OutputImage, ivec2(gl_LaunchIDEXT.xy), _567);
	    vec2 _182;
	    if (PushConstants_t.m_nIntParams.y == 0)
	    {
	        _182 = vec2(0.0);
	    }
	    else
	    {
	        _182 = imageLoad(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy)).xy;
	    }
	    float _584 = dot(vNewSample.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _589 = _584 - _182.x;
	    float _591 = _182.x + (_589 / _567.w);
	    imageStore(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy), vec4(vec2(_591, _182.y + (_589 * (_584 - _591))), 0.0, 0.0));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
