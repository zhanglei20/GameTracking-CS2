//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Sampled path tracer, to be used for baked lighting or general path tracing";
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
	DynamicCombo( D_DIRECT_LIGHT, 0..1 );
	DynamicCombo( D_INDIRECT_LIGHT, 0..1 );
	DynamicCombo( D_LIGHTING_ONLY, 0..1 );
	DynamicCombo( D_MATERIAL_MODE, 0..2 );
	DynamicCombo( D_MULTISCATTERING, 0..1 );
	DynamicCombo( D_SHADER_CLOCK, 0..1 );
	DynamicComboRule( Requires( D_MULTISCATTERING, D_MATERIAL_MODE=0 ) );
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (19272 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	vec4 _154;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    SceneGlobalInfoGPU_t_natural _m0[];
	} g_SceneGlobalInfo;
	
	layout(push_constant, std430) uniform PathTracePushConstants_t_natural
	{
	    _MatrixStorage_float4x4_ColMajornatural m_mInvViewProj;
	    vec4 m_vCameraOrigin;
	    vec4 m_vRandomOffsets;
	    uint m_nSamplerDimensionCount;
	    uint m_nSampleCount;
	    uint m_nSamplesPerFrame;
	    uint m_nBounceToShow;
	} PathTracePushConstants;
	
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
	    vec2 _243 = (((vec2(gl_LaunchIDEXT.xy) + PathTracePushConstants.m_vRandomOffsets.xy) / vec2(gl_LaunchSizeEXT.xy)) * 2.0) - vec2(1.0);
	    _243.y = -_243.y;
	    vec4 _249 = mat4(vec4(PathTracePushConstants.m_mInvViewProj.data[0].x, PathTracePushConstants.m_mInvViewProj.data[1].x, PathTracePushConstants.m_mInvViewProj.data[2].x, PathTracePushConstants.m_mInvViewProj.data[3].x), vec4(PathTracePushConstants.m_mInvViewProj.data[0].y, PathTracePushConstants.m_mInvViewProj.data[1].y, PathTracePushConstants.m_mInvViewProj.data[2].y, PathTracePushConstants.m_mInvViewProj.data[3].y), vec4(PathTracePushConstants.m_mInvViewProj.data[0].z, PathTracePushConstants.m_mInvViewProj.data[1].z, PathTracePushConstants.m_mInvViewProj.data[2].z, PathTracePushConstants.m_mInvViewProj.data[3].z), vec4(PathTracePushConstants.m_mInvViewProj.data[0].w, PathTracePushConstants.m_mInvViewProj.data[1].w, PathTracePushConstants.m_mInvViewProj.data[2].w, PathTracePushConstants.m_mInvViewProj.data[3].w)) * vec4(_243.xy, 0.0, 1.0);
	    vec3 _253 = _249.xyz / vec3(_249.w);
	    vec4 _255;
	    _255.x = _253.x;
	    _255.y = _253.y;
	    _255.z = _253.z;
	    vec3 _264 = normalize(_255.xyz - PathTracePushConstants.m_vCameraOrigin.xyz);
	    int nSampleCount = int(PathTracePushConstants.m_nSampleCount);
	    vec4 vCurrentSample;
	    if (nSampleCount > 0)
	    {
	        vCurrentSample = imageLoad(g_OutputImage, ivec2(gl_LaunchIDEXT.xy));
	    }
	    else
	    {
	        vCurrentSample = vec4(0.0);
	    }
	    uvec3 _281 = uvec3(imageSize(g_RandomSamples));
	    ivec3 _199;
	    ivec3 _284 = _199;
	    _284.x = int(_281.x);
	    _284.y = int(_281.y);
	    _284.z = int(_281.z);
	    _199 = _284;
	    ivec2 _293 = ivec2(gl_LaunchIDEXT.xy) - _284.xy * (ivec2(gl_LaunchIDEXT.xy) / _284.xy);
	    f16vec3 _302 = f16vec3(vec3(0.0));
	    vec3 _175;
	    p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _175, 3.4028234663852885981170418348452e+38, imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_293.xy, 1)))).xy.y, -1, false, MaterialDataMinimal_t(_302, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _302, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	    traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, PathTracePushConstants.m_vCameraOrigin.xyz, 0.0, _264, 56755.83984375, 0);
	    vec3 _174 = p.material;
	    vec3 _173 = p._m1;
	    float _172 = p._m3;
	    f16vec3 _163 = p._m7.vMaterialBits;
	    float16_t _162 = p._m7._m1;
	    f16vec3 _161 = p._m7._m2;
	    float16_t _160 = p._m7._m3;
	    f16vec3 _159 = p._m7._m4;
	    float16_t _158 = p._m7._m5;
	    uint _157 = p._m7._m6;
	    f16vec4 _156 = p._m7._m7;
	    vec3 vNewSample;
	    if (p._m5 != (-1))
	    {
	        do
	        {
	            vec3 _177 = (PathTracePushConstants.m_vCameraOrigin.xyz + (_264 * _172)) + (_173 * ((abs(PathTracePushConstants.m_vCameraOrigin.xyz) + vec3(abs(_172))) * 9.9999997473787516355514526367188e-05));
	            vec3 _176 = _173;
	            bool _189;
	            if (false)
	            {
	                _189 = any(notEqual(_174, vec3(3.4028234663852885981170418348452e+38)));
	            }
	            else
	            {
	                _189 = false;
	            }
	            vec3 _603 = _174 - _177;
	            float _604 = length(_603);
	            vec3 _180 = _177;
	            float _179 = 0.0;
	            vec3 _178 = vec4(_603 / vec3(_604), _604).xyz;
	            float _188;
	            if (_189)
	            {
	                _188 = _604;
	            }
	            else
	            {
	                _188 = 0.0;
	            }
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _180, _179, _178, _188, 1);
	            if (_189)
	            {
	                _188 = p_1.m_flVisibility;
	            }
	            else
	            {
	                _188 = 0.0;
	            }
	            if (_188 == 1.0)
	            {
	                _177 = _174;
	                _176 = vec3(_163);
	            }
	            vec3 _181;
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _181, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_163, _162, _161, _160, _159, _158, _157, _156));
	            traceRayEXT(g_AccelStruct, 32u, 32u, 0u, 2u, 0u, _177 - ((_176 * 0.5) * 0.5), 0.0, _176, 0.5, 0);
	            f16vec3 _171 = p._m7.vMaterialBits;
	            float16_t _170 = p._m7._m1;
	            f16vec3 _169 = p._m7._m2;
	            float16_t _168 = p._m7._m3;
	            f16vec3 _167 = p._m7._m4;
	            float16_t _166 = p._m7._m5;
	            uint _165 = p._m7._m6;
	            f16vec4 _164 = p._m7._m7;
	            if (p._m5 != (-1))
	            {
	                _163 = _171;
	                _162 = _170;
	                _161 = _169;
	                _160 = _168;
	                _159 = _167;
	                _158 = _166;
	                _157 = _165;
	                _156 = _164;
	                break;
	            }
	            else
	            {
	                break;
	            }
	            break;
	        } while(false);
	        vec3 _182 = (PathTracePushConstants.m_vCameraOrigin.xyz + (_264 * _172)) + (_173 * ((abs(PathTracePushConstants.m_vCameraOrigin.xyz) + vec3(abs(_172))) * 9.9999997473787516355514526367188e-05));
	        bool _187;
	        if (true)
	        {
	            _187 = any(notEqual(_174, vec3(3.4028234663852885981170418348452e+38)));
	        }
	        else
	        {
	            _187 = false;
	        }
	        vec3 _693 = _174 - _182;
	        float _694 = length(_693);
	        vec3 _185 = _182;
	        float _184 = 0.0;
	        vec3 _183 = vec4(_693 / vec3(_694), _694).xyz;
	        float _186;
	        if (_187)
	        {
	            _186 = _694;
	        }
	        else
	        {
	            _186 = 0.0;
	        }
	        p_1 = PayloadShadow_t(1.0);
	        traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _185, _184, _183, _186, 1);
	        if (_187)
	        {
	            _186 = p_1.m_flVisibility;
	        }
	        else
	        {
	            _186 = 0.0;
	        }
	        if (_186 == 1.0)
	        {
	            _182 = _174;
	        }
	        if (int(PathTracePushConstants.m_nBounceToShow) < 1)
	        {
	            vNewSample = vec3(_159);
	        }
	        else
	        {
	            vNewSample = vec3(0.0);
	        }
	    }
	    else
	    {
	        vec2 _194 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_293.xy, 2)))).xy;
	        bool _195;
	        if (_264.z < 0.0)
	        {
	            float _196 = _194.y;
	            bool _193;
	            do
	            {
	                if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w <= 0.0)
	                {
	                    _193 = false;
	                    break;
	                }
	                if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w >= 1.0)
	                {
	                    _193 = true;
	                    break;
	                }
	                if (_196 < g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w)
	                {
	                    _196 = min(_196 / g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                    _193 = true;
	                    break;
	                }
	                _196 = min((_196 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                _193 = false;
	                break;
	            } while(false);
	            vec2 _367 = _194;
	            _367.y = _196;
	            _194 = _367;
	            _195 = _193;
	        }
	        else
	        {
	            _195 = false;
	        }
	        vec3 _197;
	        vec3 _198;
	        if (_195)
	        {
	            float _379 = sqrt(_194.y);
	            float _381 = 6.283185482025146484375 * _194.x;
	            _197 = vec3(cos(_381) * _379, sin(_381) * _379, sqrt(max(0.0, 1.0 - _194.y)));
	            _198 = g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.xyz;
	        }
	        else
	        {
	            _197 = _264;
	            _198 = g_SceneGlobalInfo._m0[0].m_vSkyColor.xyz;
	        }
	        if (g_SceneGlobalInfo._m0[0].m_vIBLParams.x >= 0)
	        {
	            vec3 _437 = clamp(normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_197, 0.0)), vec3(-1.0), vec3(1.0));
	            float _438 = _437.y;
	            float _439 = _437.x;
	            float _440 = _438 / _439;
	            float _441 = abs(_440);
	            bool _442 = _441 < 1.0;
	            float _191;
	            if (_442)
	            {
	                _191 = _441;
	            }
	            else
	            {
	                _191 = 1.0 / _441;
	            }
	            float _447 = _191;
	            float _448 = _447 * _447;
	            float _453 = (1.0 + (((-0.3018949925899505615234375) + (0.087292902171611785888671875 * _448)) * _448)) * _447;
	            if (_442)
	            {
	                _191 = _453;
	            }
	            else
	            {
	                _191 = 1.57079601287841796875 - _453;
	            }
	            float _464 = uintBitsToFloat((floatBitsToUint(_191) & 2147483647u) | (floatBitsToUint(_440) & 2147483648u));
	            float _192;
	            if (_439 < 0.0)
	            {
	                _192 = _464 + uintBitsToFloat(1078530011u | (floatBitsToUint(_438) & 2147483648u));
	            }
	            else
	            {
	                _192 = _464;
	            }
	            float _476 = _437.z;
	            float _477 = abs(_476);
	            float _485 = (((-0.15658299624919891357421875) * _477) + 1.57079637050628662109375) * intBitsToFloat(532487669 + (floatBitsToInt(1.0 - _477) >> 1));
	            float _190;
	            if (_476 >= 0.0)
	            {
	                _190 = _485;
	            }
	            else
	            {
	                _190 = 3.1415927410125732421875 - _485;
	            }
	            vec3 _500 = g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * textureLod(sampler2D(g_bindless_Texture2D[g_SceneGlobalInfo._m0[0].m_vIBLParams.x], g_Sampler), vec2(_192 * 0.15915493667125701904296875, _190 * 0.3183098733425140380859375), 0.0).xyz;
	            if (dot(_500.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	            {
	                _198 += _500;
	            }
	        }
	        if (g_SceneGlobalInfo._m0[0].m_vIBLParams.y >= 0)
	        {
	            vec4 _547 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._m0[0].m_vIBLParams.y], g_Sampler), normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_197, 0.0)), 0.0);
	            if (dot(_547.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	            {
	                _198 += (g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * _547.xyz);
	            }
	        }
	        if (false)
	        {
	            _198 *= g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.w;
	        }
	        if (_195)
	        {
	            _198 *= g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.xyz;
	        }
	        vNewSample = _198;
	    }
	    vec4 _732 = vec4(mix(vCurrentSample.xyz, vNewSample, vec3(1.0 / (1.0 + vCurrentSample.w))), 1.0 + vCurrentSample.w);
	    imageStore(g_OutputImage, ivec2(gl_LaunchIDEXT.xy), _732);
	    vec2 _200;
	    if (nSampleCount == 0)
	    {
	        _200 = vec2(0.0);
	    }
	    else
	    {
	        _200 = imageLoad(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy)).xy;
	    }
	    float _749 = dot(vNewSample.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _754 = _749 - _200.x;
	    float _756 = _200.x + (_754 / _732.w);
	    imageStore(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy), vec4(vec2(_756, _200.y + (_754 * (_749 - _756))), 0.0, 0.0));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
