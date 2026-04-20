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
	// SPIR-V source (16184 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	vec4 _133;
	
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
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 6, binding = 159) uniform image2D g_VarianceImage;
	
	void main()
	{
	    vec2 _219 = (((vec2(gl_LaunchIDEXT.xy) + PushConstants_t.m_vRandomOffsets.xy) / vec2(gl_LaunchSizeEXT.xy)) * 2.0) - vec2(1.0);
	    _219.y = -_219.y;
	    vec4 _225 = mat4(vec4(PushConstants_t.m_mInvViewProj.data[0].x, PushConstants_t.m_mInvViewProj.data[1].x, PushConstants_t.m_mInvViewProj.data[2].x, PushConstants_t.m_mInvViewProj.data[3].x), vec4(PushConstants_t.m_mInvViewProj.data[0].y, PushConstants_t.m_mInvViewProj.data[1].y, PushConstants_t.m_mInvViewProj.data[2].y, PushConstants_t.m_mInvViewProj.data[3].y), vec4(PushConstants_t.m_mInvViewProj.data[0].z, PushConstants_t.m_mInvViewProj.data[1].z, PushConstants_t.m_mInvViewProj.data[2].z, PushConstants_t.m_mInvViewProj.data[3].z), vec4(PushConstants_t.m_mInvViewProj.data[0].w, PushConstants_t.m_mInvViewProj.data[1].w, PushConstants_t.m_mInvViewProj.data[2].w, PushConstants_t.m_mInvViewProj.data[3].w)) * vec4(_219.xy, 0.0, 1.0);
	    vec3 _229 = _225.xyz / vec3(_225.w);
	    vec4 _231;
	    _231.x = _229.x;
	    _231.y = _229.y;
	    _231.z = _229.z;
	    vec3 _240 = normalize(_231.xyz - PushConstants_t.m_vCameraOrigin.xyz);
	    vec4 vCurrentSample;
	    if (PushConstants_t.m_nIntParams.y > 0)
	    {
	        vCurrentSample = imageLoad(g_OutputImage, ivec2(gl_LaunchIDEXT.xy));
	    }
	    else
	    {
	        vCurrentSample = vec4(0.0);
	    }
	    uvec3 _255 = uvec3(imageSize(g_RandomSamples));
	    ivec3 _175;
	    ivec3 _258 = _175;
	    _258.x = int(_255.x);
	    _258.y = int(_255.y);
	    _258.z = int(_255.z);
	    _175 = _258;
	    ivec2 _267 = ivec2(gl_LaunchIDEXT.xy) - _258.xy * (ivec2(gl_LaunchIDEXT.xy) / _258.xy);
	    f16vec3 _276 = f16vec3(vec3(0.0));
	    vec3 _154;
	    p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _154, 3.4028234663852885981170418348452e+38, imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_267.xy, 1)))).xy.y, -1, false, MaterialDataMinimal_t(_276, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _276, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	    traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, PushConstants_t.m_vCameraOrigin.xyz, 0.0, _240, 56755.83984375, 0);
	    vec3 _153 = p.material;
	    vec3 _152 = p._m1;
	    float _151 = p._m3;
	    f16vec3 _142 = p._m7.vMaterialBits;
	    float16_t _141 = p._m7._m1;
	    f16vec3 _140 = p._m7._m2;
	    float16_t _139 = p._m7._m3;
	    f16vec3 _138 = p._m7._m4;
	    float16_t _137 = p._m7._m5;
	    uint _136 = p._m7._m6;
	    f16vec4 _135 = p._m7._m7;
	    vec3 vNewSample;
	    if (p._m5 != (-1))
	    {
	        do
	        {
	            vec3 _156 = (PushConstants_t.m_vCameraOrigin.xyz + (_240 * _151)) + (_152 * ((abs(PushConstants_t.m_vCameraOrigin.xyz) + vec3(abs(_151))) * 9.9999997473787516355514526367188e-05));
	            vec3 _155 = _152;
	            bool _168;
	            if (false)
	            {
	                _168 = any(notEqual(_153, vec3(3.4028234663852885981170418348452e+38)));
	            }
	            else
	            {
	                _168 = false;
	            }
	            vec3 _474 = _153 - _156;
	            float _475 = length(_474);
	            vec3 _159 = _156;
	            float _158 = 0.0;
	            vec3 _157 = vec4(_474 / vec3(_475), _475).xyz;
	            float _167;
	            if (_168)
	            {
	                _167 = _475;
	            }
	            else
	            {
	                _167 = 0.0;
	            }
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _159, _158, _157, _167, 1);
	            if (_168)
	            {
	                _167 = p_1.m_flVisibility;
	            }
	            else
	            {
	                _167 = 0.0;
	            }
	            if (_167 == 1.0)
	            {
	                _156 = _153;
	                _155 = vec3(_142);
	            }
	            vec3 _160;
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _160, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_142, _141, _140, _139, _138, _137, _136, _135));
	            traceRayEXT(g_AccelStruct, 32u, 32u, 0u, 2u, 0u, _156 - ((_155 * 0.5) * 0.5), 0.0, _155, 0.5, 0);
	            f16vec3 _150 = p._m7.vMaterialBits;
	            float16_t _149 = p._m7._m1;
	            f16vec3 _148 = p._m7._m2;
	            float16_t _147 = p._m7._m3;
	            f16vec3 _146 = p._m7._m4;
	            float16_t _145 = p._m7._m5;
	            uint _144 = p._m7._m6;
	            f16vec4 _143 = p._m7._m7;
	            if (p._m5 != (-1))
	            {
	                _142 = _150;
	                _141 = _149;
	                _140 = _148;
	                _139 = _147;
	                _138 = _146;
	                _137 = _145;
	                _136 = _144;
	                _135 = _143;
	                break;
	            }
	            else
	            {
	                break;
	            }
	            break;
	        } while(false);
	        vec3 _161 = (PushConstants_t.m_vCameraOrigin.xyz + (_240 * _151)) + (_152 * ((abs(PushConstants_t.m_vCameraOrigin.xyz) + vec3(abs(_151))) * 9.9999997473787516355514526367188e-05));
	        bool _166;
	        if (true)
	        {
	            _166 = any(notEqual(_153, vec3(3.4028234663852885981170418348452e+38)));
	        }
	        else
	        {
	            _166 = false;
	        }
	        vec3 _564 = _153 - _161;
	        float _565 = length(_564);
	        vec3 _164 = _161;
	        float _163 = 0.0;
	        vec3 _162 = vec4(_564 / vec3(_565), _565).xyz;
	        float _165;
	        if (_166)
	        {
	            _165 = _565;
	        }
	        else
	        {
	            _165 = 0.0;
	        }
	        p_1 = PayloadShadow_t(1.0);
	        traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _164, _163, _162, _165, 1);
	        if (_166)
	        {
	            _165 = p_1.m_flVisibility;
	        }
	        else
	        {
	            _165 = 0.0;
	        }
	        if (_165 == 1.0)
	        {
	            _161 = _153;
	        }
	        vNewSample = vec3(_140);
	    }
	    else
	    {
	        vec2 _170 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_267.xy, 2)))).xy;
	        bool _171;
	        if (_240.z < 0.0)
	        {
	            float _172 = _170.y;
	            bool _169;
	            do
	            {
	                if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w <= 0.0)
	                {
	                    _169 = false;
	                    break;
	                }
	                if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w >= 1.0)
	                {
	                    _169 = true;
	                    break;
	                }
	                if (_172 < g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w)
	                {
	                    _172 = min(_172 / g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                    _169 = true;
	                    break;
	                }
	                _172 = min((_172 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                _169 = false;
	                break;
	            } while(false);
	            vec2 _341 = _170;
	            _341.y = _172;
	            _170 = _341;
	            _171 = _169;
	        }
	        else
	        {
	            _171 = false;
	        }
	        vec3 _173;
	        vec3 _174;
	        if (_171)
	        {
	            float _349 = sqrt(_170.y);
	            float _351 = 6.283185482025146484375 * _170.x;
	            _173 = vec3(cos(_351) * _349, sin(_351) * _349, sqrt(max(0.0, 1.0 - _170.y)));
	            _174 = g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.xyz;
	        }
	        else
	        {
	            _173 = _240;
	            _174 = vec3(0.0);
	        }
	        if (g_SceneGlobalInfo._m0[0].m_vIBLParams.y >= 0)
	        {
	            vec4 _418 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._m0[0].m_vIBLParams.y], g_Sampler), normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_173, 0.0)), 0.0);
	            if (dot(_418.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	            {
	                _174 += (g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * _418.xyz);
	            }
	        }
	        else
	        {
	            _174 += g_SceneGlobalInfo._m0[0].m_vSkyColor.xyz;
	        }
	        if (false)
	        {
	            _174 *= g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.w;
	        }
	        if (_171)
	        {
	            _174 *= g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.xyz;
	        }
	        vNewSample = _174;
	    }
	    vec4 _599 = vec4(mix(vCurrentSample.xyz, vNewSample, vec3(1.0 / (1.0 + vCurrentSample.w))), 1.0 + vCurrentSample.w);
	    imageStore(g_OutputImage, ivec2(gl_LaunchIDEXT.xy), _599);
	    vec2 _176;
	    if (PushConstants_t.m_nIntParams.y == 0)
	    {
	        _176 = vec2(0.0);
	    }
	    else
	    {
	        _176 = imageLoad(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy)).xy;
	    }
	    float _616 = dot(vNewSample.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _621 = _616 - _176.x;
	    float _623 = _176.x + (_621 / _599.w);
	    imageStore(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy), vec4(vec2(_623, _176.y + (_621 * (_616 - _623))), 0.0, 0.0));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
