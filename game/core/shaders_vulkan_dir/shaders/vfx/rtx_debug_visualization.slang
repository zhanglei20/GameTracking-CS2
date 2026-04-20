//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Debug visualization for various ray traced properties";
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
	DynamicCombo( D_DEBUG_MODE, 0..12 );
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (18884 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    f16vec3 vMaterialBits;
	    float16_t _m1;
	    f16vec3 _m2;
	    float16_t _m3;
	    f16vec3 _m4;
	    float16_t _m5;
	    uint _m6;
	    f16vec4 _m7;
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
	
	struct _MatrixStorage_float4x4_ColMajornatural
	{
	    vec4 data[4];
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
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	vec4 _153;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    SceneGlobalInfoGPU_t_natural _m0[];
	} g_SceneGlobalInfo;
	
	layout(push_constant, std430) uniform PushConstants_t_t_natural
	{
	    _MatrixStorage_float4x4_ColMajornatural m_mInvViewProj;
	    vec4 m_vCameraOrigin;
	    vec4 m_vRandomOffsets;
	    ivec4 m_nIntParams;
	} PushConstants_t;
	
	layout(set = 6, binding = 158) uniform image2D g_OutputImage;
	layout(set = 6, binding = 161) uniform readonly image3D g_RandomSamples;
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 6, binding = 159) uniform image2D g_VarianceImage;
	
	void main()
	{
	    vec2 _242 = (((vec2(gl_LaunchIDEXT.xy) + PushConstants_t.m_vRandomOffsets.xy) / vec2(gl_LaunchSizeEXT.xy)) * 2.0) - vec2(1.0);
	    _242.y = -_242.y;
	    vec4 _248 = mat4(vec4(PushConstants_t.m_mInvViewProj.data[0].x, PushConstants_t.m_mInvViewProj.data[1].x, PushConstants_t.m_mInvViewProj.data[2].x, PushConstants_t.m_mInvViewProj.data[3].x), vec4(PushConstants_t.m_mInvViewProj.data[0].y, PushConstants_t.m_mInvViewProj.data[1].y, PushConstants_t.m_mInvViewProj.data[2].y, PushConstants_t.m_mInvViewProj.data[3].y), vec4(PushConstants_t.m_mInvViewProj.data[0].z, PushConstants_t.m_mInvViewProj.data[1].z, PushConstants_t.m_mInvViewProj.data[2].z, PushConstants_t.m_mInvViewProj.data[3].z), vec4(PushConstants_t.m_mInvViewProj.data[0].w, PushConstants_t.m_mInvViewProj.data[1].w, PushConstants_t.m_mInvViewProj.data[2].w, PushConstants_t.m_mInvViewProj.data[3].w)) * vec4(_242.xy, 0.0, 1.0);
	    vec3 _252 = _248.xyz / vec3(_248.w);
	    vec4 _254;
	    _254.x = _252.x;
	    _254.y = _252.y;
	    _254.z = _252.z;
	    vec3 _263 = normalize(_254.xyz - PushConstants_t.m_vCameraOrigin.xyz);
	    vec4 vCurrentSample;
	    if (PushConstants_t.m_nIntParams.y > 0)
	    {
	        vCurrentSample = imageLoad(g_OutputImage, ivec2(gl_LaunchIDEXT.xy));
	    }
	    else
	    {
	        vCurrentSample = vec4(0.0);
	    }
	    uvec3 _278 = uvec3(imageSize(g_RandomSamples));
	    ivec3 _198;
	    ivec3 _281 = _198;
	    _281.x = int(_278.x);
	    _281.y = int(_278.y);
	    _281.z = int(_278.z);
	    _198 = _281;
	    ivec2 _290 = ivec2(gl_LaunchIDEXT.xy) - _281.xy * (ivec2(gl_LaunchIDEXT.xy) / _281.xy);
	    f16vec3 _299 = f16vec3(vec3(0.0));
	    vec3 _174;
	    p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _174, 3.4028234663852885981170418348452e+38, imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_290.xy, 1)))).xy.y, -1, false, MaterialDataMinimal_t(_299, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _299, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	    traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, PushConstants_t.m_vCameraOrigin.xyz, 0.0, _263, 56755.83984375, 0);
	    vec3 _173 = p.material;
	    vec3 _172 = p._m1;
	    float _171 = p._m3;
	    f16vec3 _162 = p._m7.vMaterialBits;
	    float16_t _161 = p._m7._m1;
	    f16vec3 _160 = p._m7._m2;
	    float16_t _159 = p._m7._m3;
	    f16vec3 _158 = p._m7._m4;
	    float16_t _157 = p._m7._m5;
	    uint _156 = p._m7._m6;
	    f16vec4 _155 = p._m7._m7;
	    vec3 vNewSample;
	    if (p._m5 != (-1))
	    {
	        do
	        {
	            vec3 _176 = (PushConstants_t.m_vCameraOrigin.xyz + (_263 * _171)) + (_172 * ((abs(PushConstants_t.m_vCameraOrigin.xyz) + vec3(abs(_171))) * 9.9999997473787516355514526367188e-05));
	            vec3 _175 = _172;
	            bool _188;
	            if (false)
	            {
	                _188 = any(notEqual(_173, vec3(3.4028234663852885981170418348452e+38)));
	            }
	            else
	            {
	                _188 = false;
	            }
	            vec3 _600 = _173 - _176;
	            float _601 = length(_600);
	            vec3 _179 = _176;
	            float _178 = 0.0;
	            vec3 _177 = vec4(_600 / vec3(_601), _601).xyz;
	            float _187;
	            if (_188)
	            {
	                _187 = _601;
	            }
	            else
	            {
	                _187 = 0.0;
	            }
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _179, _178, _177, _187, 1);
	            if (_188)
	            {
	                _187 = p_1.m_flVisibility;
	            }
	            else
	            {
	                _187 = 0.0;
	            }
	            if (_187 == 1.0)
	            {
	                _176 = _173;
	                _175 = vec3(_162);
	            }
	            vec3 _180;
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _180, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_162, _161, _160, _159, _158, _157, _156, _155));
	            traceRayEXT(g_AccelStruct, 32u, 32u, 0u, 2u, 0u, _176 - ((_175 * 0.5) * 0.5), 0.0, _175, 0.5, 0);
	            f16vec3 _170 = p._m7.vMaterialBits;
	            float16_t _169 = p._m7._m1;
	            f16vec3 _168 = p._m7._m2;
	            float16_t _167 = p._m7._m3;
	            f16vec3 _166 = p._m7._m4;
	            float16_t _165 = p._m7._m5;
	            uint _164 = p._m7._m6;
	            f16vec4 _163 = p._m7._m7;
	            if (p._m5 != (-1))
	            {
	                _162 = _170;
	                _161 = _169;
	                _160 = _168;
	                _159 = _167;
	                _158 = _166;
	                _157 = _165;
	                _156 = _164;
	                _155 = _163;
	                break;
	            }
	            else
	            {
	                break;
	            }
	            break;
	        } while(false);
	        vec3 _181 = (PushConstants_t.m_vCameraOrigin.xyz + (_263 * _171)) + (_172 * ((abs(PushConstants_t.m_vCameraOrigin.xyz) + vec3(abs(_171))) * 9.9999997473787516355514526367188e-05));
	        bool _186;
	        if (true)
	        {
	            _186 = any(notEqual(_173, vec3(3.4028234663852885981170418348452e+38)));
	        }
	        else
	        {
	            _186 = false;
	        }
	        vec3 _690 = _173 - _181;
	        float _691 = length(_690);
	        vec3 _184 = _181;
	        float _183 = 0.0;
	        vec3 _182 = vec4(_690 / vec3(_691), _691).xyz;
	        float _185;
	        if (_186)
	        {
	            _185 = _691;
	        }
	        else
	        {
	            _185 = 0.0;
	        }
	        p_1 = PayloadShadow_t(1.0);
	        traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _184, _183, _182, _185, 1);
	        if (_186)
	        {
	            _185 = p_1.m_flVisibility;
	        }
	        else
	        {
	            _185 = 0.0;
	        }
	        if (_185 == 1.0)
	        {
	            _181 = _173;
	        }
	        vNewSample = vec3(_160);
	    }
	    else
	    {
	        vec2 _193 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_290.xy, 2)))).xy;
	        bool _194;
	        if (_263.z < 0.0)
	        {
	            float _195 = _193.y;
	            bool _192;
	            do
	            {
	                if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w <= 0.0)
	                {
	                    _192 = false;
	                    break;
	                }
	                if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w >= 1.0)
	                {
	                    _192 = true;
	                    break;
	                }
	                if (_195 < g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w)
	                {
	                    _195 = min(_195 / g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                    _192 = true;
	                    break;
	                }
	                _195 = min((_195 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                _192 = false;
	                break;
	            } while(false);
	            vec2 _364 = _193;
	            _364.y = _195;
	            _193 = _364;
	            _194 = _192;
	        }
	        else
	        {
	            _194 = false;
	        }
	        vec3 _196;
	        vec3 _197;
	        if (_194)
	        {
	            float _376 = sqrt(_193.y);
	            float _378 = 6.283185482025146484375 * _193.x;
	            _196 = vec3(cos(_378) * _376, sin(_378) * _376, sqrt(max(0.0, 1.0 - _193.y)));
	            _197 = g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.xyz;
	        }
	        else
	        {
	            _196 = _263;
	            _197 = g_SceneGlobalInfo._m0[0].m_vSkyColor.xyz;
	        }
	        if (g_SceneGlobalInfo._m0[0].m_vIBLParams.x >= 0)
	        {
	            vec3 _434 = clamp(normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_196, 0.0)), vec3(-1.0), vec3(1.0));
	            float _435 = _434.y;
	            float _436 = _434.x;
	            float _437 = _435 / _436;
	            float _438 = abs(_437);
	            bool _439 = _438 < 1.0;
	            float _190;
	            if (_439)
	            {
	                _190 = _438;
	            }
	            else
	            {
	                _190 = 1.0 / _438;
	            }
	            float _444 = _190;
	            float _445 = _444 * _444;
	            float _450 = (1.0 + (((-0.3018949925899505615234375) + (0.087292902171611785888671875 * _445)) * _445)) * _444;
	            if (_439)
	            {
	                _190 = _450;
	            }
	            else
	            {
	                _190 = 1.57079601287841796875 - _450;
	            }
	            float _461 = uintBitsToFloat((floatBitsToUint(_190) & 2147483647u) | (floatBitsToUint(_437) & 2147483648u));
	            float _191;
	            if (_436 < 0.0)
	            {
	                _191 = _461 + uintBitsToFloat(1078530011u | (floatBitsToUint(_435) & 2147483648u));
	            }
	            else
	            {
	                _191 = _461;
	            }
	            float _473 = _434.z;
	            float _474 = abs(_473);
	            float _482 = (((-0.15658299624919891357421875) * _474) + 1.57079637050628662109375) * intBitsToFloat(532487669 + (floatBitsToInt(1.0 - _474) >> 1));
	            float _189;
	            if (_473 >= 0.0)
	            {
	                _189 = _482;
	            }
	            else
	            {
	                _189 = 3.1415927410125732421875 - _482;
	            }
	            vec3 _497 = g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * textureLod(sampler2D(g_bindless_Texture2D[g_SceneGlobalInfo._m0[0].m_vIBLParams.x], g_Sampler), vec2(_191 * 0.15915493667125701904296875, _189 * 0.3183098733425140380859375), 0.0).xyz;
	            if (dot(_497.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	            {
	                _197 += _497;
	            }
	        }
	        if (g_SceneGlobalInfo._m0[0].m_vIBLParams.y >= 0)
	        {
	            vec4 _544 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._m0[0].m_vIBLParams.y], g_Sampler), normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_196, 0.0)), 0.0);
	            if (dot(_544.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	            {
	                _197 += (g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * _544.xyz);
	            }
	        }
	        if (false)
	        {
	            _197 *= g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.w;
	        }
	        if (_194)
	        {
	            _197 *= g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.xyz;
	        }
	        vNewSample = _197;
	    }
	    vec4 _725 = vec4(mix(vCurrentSample.xyz, vNewSample, vec3(1.0 / (1.0 + vCurrentSample.w))), 1.0 + vCurrentSample.w);
	    imageStore(g_OutputImage, ivec2(gl_LaunchIDEXT.xy), _725);
	    vec2 _199;
	    if (PushConstants_t.m_nIntParams.y == 0)
	    {
	        _199 = vec2(0.0);
	    }
	    else
	    {
	        _199 = imageLoad(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy)).xy;
	    }
	    float _742 = dot(vNewSample.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _747 = _742 - _199.x;
	    float _749 = _199.x + (_747 / _725.w);
	    imageStore(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy), vec4(vec2(_749, _199.y + (_747 * (_742 - _749))), 0.0, 0.0));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
