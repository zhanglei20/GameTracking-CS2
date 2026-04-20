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
	// SPIR-V source (16572 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	vec4 _134;
	
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
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 6, binding = 159) uniform image2D g_VarianceImage;
	
	void main()
	{
	    vec2 _220 = (((vec2(gl_LaunchIDEXT.xy) + PathTracePushConstants.m_vRandomOffsets.xy) / vec2(gl_LaunchSizeEXT.xy)) * 2.0) - vec2(1.0);
	    _220.y = -_220.y;
	    vec4 _226 = mat4(vec4(PathTracePushConstants.m_mInvViewProj.data[0].x, PathTracePushConstants.m_mInvViewProj.data[1].x, PathTracePushConstants.m_mInvViewProj.data[2].x, PathTracePushConstants.m_mInvViewProj.data[3].x), vec4(PathTracePushConstants.m_mInvViewProj.data[0].y, PathTracePushConstants.m_mInvViewProj.data[1].y, PathTracePushConstants.m_mInvViewProj.data[2].y, PathTracePushConstants.m_mInvViewProj.data[3].y), vec4(PathTracePushConstants.m_mInvViewProj.data[0].z, PathTracePushConstants.m_mInvViewProj.data[1].z, PathTracePushConstants.m_mInvViewProj.data[2].z, PathTracePushConstants.m_mInvViewProj.data[3].z), vec4(PathTracePushConstants.m_mInvViewProj.data[0].w, PathTracePushConstants.m_mInvViewProj.data[1].w, PathTracePushConstants.m_mInvViewProj.data[2].w, PathTracePushConstants.m_mInvViewProj.data[3].w)) * vec4(_220.xy, 0.0, 1.0);
	    vec3 _230 = _226.xyz / vec3(_226.w);
	    vec4 _232;
	    _232.x = _230.x;
	    _232.y = _230.y;
	    _232.z = _230.z;
	    vec3 _241 = normalize(_232.xyz - PathTracePushConstants.m_vCameraOrigin.xyz);
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
	    uvec3 _258 = uvec3(imageSize(g_RandomSamples));
	    ivec3 _176;
	    ivec3 _261 = _176;
	    _261.x = int(_258.x);
	    _261.y = int(_258.y);
	    _261.z = int(_258.z);
	    _176 = _261;
	    ivec2 _270 = ivec2(gl_LaunchIDEXT.xy) - _261.xy * (ivec2(gl_LaunchIDEXT.xy) / _261.xy);
	    f16vec3 _279 = f16vec3(vec3(0.0));
	    vec3 _155;
	    p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _155, 3.4028234663852885981170418348452e+38, imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_270.xy, 1)))).xy.y, -1, false, MaterialDataMinimal_t(_279, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _279, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	    traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, PathTracePushConstants.m_vCameraOrigin.xyz, 0.0, _241, 56755.83984375, 0);
	    vec3 _154 = p.material;
	    vec3 _153 = p._m1;
	    float _152 = p._m3;
	    f16vec3 _143 = p._m7.vMaterialBits;
	    float16_t _142 = p._m7._m1;
	    f16vec3 _141 = p._m7._m2;
	    float16_t _140 = p._m7._m3;
	    f16vec3 _139 = p._m7._m4;
	    float16_t _138 = p._m7._m5;
	    uint _137 = p._m7._m6;
	    f16vec4 _136 = p._m7._m7;
	    vec3 vNewSample;
	    if (p._m5 != (-1))
	    {
	        do
	        {
	            vec3 _157 = (PathTracePushConstants.m_vCameraOrigin.xyz + (_241 * _152)) + (_153 * ((abs(PathTracePushConstants.m_vCameraOrigin.xyz) + vec3(abs(_152))) * 9.9999997473787516355514526367188e-05));
	            vec3 _156 = _153;
	            bool _169;
	            if (false)
	            {
	                _169 = any(notEqual(_154, vec3(3.4028234663852885981170418348452e+38)));
	            }
	            else
	            {
	                _169 = false;
	            }
	            vec3 _477 = _154 - _157;
	            float _478 = length(_477);
	            vec3 _160 = _157;
	            float _159 = 0.0;
	            vec3 _158 = vec4(_477 / vec3(_478), _478).xyz;
	            float _168;
	            if (_169)
	            {
	                _168 = _478;
	            }
	            else
	            {
	                _168 = 0.0;
	            }
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _160, _159, _158, _168, 1);
	            if (_169)
	            {
	                _168 = p_1.m_flVisibility;
	            }
	            else
	            {
	                _168 = 0.0;
	            }
	            if (_168 == 1.0)
	            {
	                _157 = _154;
	                _156 = vec3(_143);
	            }
	            vec3 _161;
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _161, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_143, _142, _141, _140, _139, _138, _137, _136));
	            traceRayEXT(g_AccelStruct, 32u, 32u, 0u, 2u, 0u, _157 - ((_156 * 0.5) * 0.5), 0.0, _156, 0.5, 0);
	            f16vec3 _151 = p._m7.vMaterialBits;
	            float16_t _150 = p._m7._m1;
	            f16vec3 _149 = p._m7._m2;
	            float16_t _148 = p._m7._m3;
	            f16vec3 _147 = p._m7._m4;
	            float16_t _146 = p._m7._m5;
	            uint _145 = p._m7._m6;
	            f16vec4 _144 = p._m7._m7;
	            if (p._m5 != (-1))
	            {
	                _143 = _151;
	                _142 = _150;
	                _141 = _149;
	                _140 = _148;
	                _139 = _147;
	                _138 = _146;
	                _137 = _145;
	                _136 = _144;
	                break;
	            }
	            else
	            {
	                break;
	            }
	            break;
	        } while(false);
	        vec3 _162 = (PathTracePushConstants.m_vCameraOrigin.xyz + (_241 * _152)) + (_153 * ((abs(PathTracePushConstants.m_vCameraOrigin.xyz) + vec3(abs(_152))) * 9.9999997473787516355514526367188e-05));
	        bool _167;
	        if (true)
	        {
	            _167 = any(notEqual(_154, vec3(3.4028234663852885981170418348452e+38)));
	        }
	        else
	        {
	            _167 = false;
	        }
	        vec3 _567 = _154 - _162;
	        float _568 = length(_567);
	        vec3 _165 = _162;
	        float _164 = 0.0;
	        vec3 _163 = vec4(_567 / vec3(_568), _568).xyz;
	        float _166;
	        if (_167)
	        {
	            _166 = _568;
	        }
	        else
	        {
	            _166 = 0.0;
	        }
	        p_1 = PayloadShadow_t(1.0);
	        traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _165, _164, _163, _166, 1);
	        if (_167)
	        {
	            _166 = p_1.m_flVisibility;
	        }
	        else
	        {
	            _166 = 0.0;
	        }
	        if (_166 == 1.0)
	        {
	            _162 = _154;
	        }
	        if (int(PathTracePushConstants.m_nBounceToShow) < 1)
	        {
	            vNewSample = vec3(_139);
	        }
	        else
	        {
	            vNewSample = vec3(0.0);
	        }
	    }
	    else
	    {
	        vec2 _171 = imageLoad(g_RandomSamples, ivec3(uvec3(ivec3(_270.xy, 2)))).xy;
	        bool _172;
	        if (_241.z < 0.0)
	        {
	            float _173 = _171.y;
	            bool _170;
	            do
	            {
	                if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w <= 0.0)
	                {
	                    _170 = false;
	                    break;
	                }
	                if (g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w >= 1.0)
	                {
	                    _170 = true;
	                    break;
	                }
	                if (_173 < g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w)
	                {
	                    _173 = min(_173 / g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                    _170 = true;
	                    break;
	                }
	                _173 = min((_173 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                _170 = false;
	                break;
	            } while(false);
	            vec2 _344 = _171;
	            _344.y = _173;
	            _171 = _344;
	            _172 = _170;
	        }
	        else
	        {
	            _172 = false;
	        }
	        vec3 _174;
	        vec3 _175;
	        if (_172)
	        {
	            float _352 = sqrt(_171.y);
	            float _354 = 6.283185482025146484375 * _171.x;
	            _174 = vec3(cos(_354) * _352, sin(_354) * _352, sqrt(max(0.0, 1.0 - _171.y)));
	            _175 = g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.xyz;
	        }
	        else
	        {
	            _174 = _241;
	            _175 = vec3(0.0);
	        }
	        if (g_SceneGlobalInfo._m0[0].m_vIBLParams.y >= 0)
	        {
	            vec4 _421 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._m0[0].m_vIBLParams.y], g_Sampler), normalize(mat4x3(vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].x, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].x), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].y, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].y), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].z, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].z), vec3(g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[0].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[1].w, g_SceneGlobalInfo._m0[0].m_mIBLTransformI.data[2].w)) * vec4(_174, 0.0)), 0.0);
	            if (dot(_421.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._m0[0].m_vSunLightIrradiance.w)
	            {
	                _175 += (g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.xyz * _421.xyz);
	            }
	        }
	        else
	        {
	            _175 += g_SceneGlobalInfo._m0[0].m_vSkyColor.xyz;
	        }
	        if (false)
	        {
	            _175 *= g_SceneGlobalInfo._m0[0].m_vIBLCubeMapScale.w;
	        }
	        if (_172)
	        {
	            _175 *= g_SceneGlobalInfo._m0[0].m_vSkyAmbientBounce.xyz;
	        }
	        vNewSample = _175;
	    }
	    vec4 _606 = vec4(mix(vCurrentSample.xyz, vNewSample, vec3(1.0 / (1.0 + vCurrentSample.w))), 1.0 + vCurrentSample.w);
	    imageStore(g_OutputImage, ivec2(gl_LaunchIDEXT.xy), _606);
	    vec2 _177;
	    if (nSampleCount == 0)
	    {
	        _177 = vec2(0.0);
	    }
	    else
	    {
	        _177 = imageLoad(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy)).xy;
	    }
	    float _623 = dot(vNewSample.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _628 = _623 - _177.x;
	    float _630 = _177.x + (_628 / _606.w);
	    imageStore(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy), vec4(vec2(_630, _177.y + (_628 * (_623 - _630))), 0.0, 0.0));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
