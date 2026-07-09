//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Sampled path tracer, to be used for baked lighting or general path tracing";
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
	// SPIR-V source (15900 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	vec4 _129;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    layout(row_major) SceneGlobalInfoGPU_t_natural _member0[];
	} g_SceneGlobalInfo;
	
	layout(push_constant, std430) uniform PathTracePushConstants_t_natural
	{
	    layout(row_major) mat4 m_mInvViewProj;
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
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(set = 6, binding = 159) uniform image2D g_VarianceImage;
	
	void main()
	{
	    vec2 _200 = (((vec2(gl_LaunchIDEXT.xy) + PathTracePushConstants.m_vRandomOffsets.xy) / vec2(gl_LaunchSizeEXT.xy)) * 2.0) - vec2(1.0);
	    _200.y = -_200.y;
	    vec4 _206 = PathTracePushConstants.m_mInvViewProj * vec4(_200.xy, 0.0, 1.0);
	    vec3 _210 = _206.xyz / vec3(_206.w);
	    vec4 _212;
	    _212.x = _210.x;
	    _212.y = _210.y;
	    _212.z = _210.z;
	    vec3 _221 = normalize(_212.xyz - PathTracePushConstants.m_vCameraOrigin.xyz);
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
	    uvec3 _238 = uvec3(imageSize(g_RandomSamples));
	    ivec3 _182;
	    ivec3 _241 = _182;
	    _241.x = int(_238.x);
	    _241.y = int(_238.y);
	    _241.z = int(_238.z);
	    _182 = _241;
	    ivec2 _250 = ivec2(gl_LaunchIDEXT.xy) - _241.xy * (ivec2(gl_LaunchIDEXT.xy) / _241.xy);
	    f16vec3 _257 = f16vec3(vec3(0.0));
	    vec3 _158;
	    p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _158, 3.4028234663852885981170418348452e+38, imageLoad(g_RandomSamples, ivec3(_250.xy, 1)).xy.y, -1, false, MaterialDataMinimal_t(_257, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _257, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	    traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, PathTracePushConstants.m_vCameraOrigin.xyz, 0.0, _221, 56755.83984375, 0);
	    vec3 _157 = p.vSmoothPositionWs;
	    vec3 _156 = p.vFaceNormalWs;
	    float _155 = p.flHitT;
	    f16vec3 _138 = p.material.vNormalWs;
	    float16_t _137 = p.material.flMetalness;
	    f16vec3 _136 = p.material.vAlbedo;
	    float16_t _135 = p.material.flRoughness;
	    f16vec3 _134 = p.material.vEmissive;
	    float16_t _133 = p.material.flReflectance;
	    uint _132 = p.material.nMaterialTypeAndFlags;
	    f16vec4 _131 = p.material.vMaterialBits;
	    vec3 vNewSample;
	    if (p.nInstance != (-1))
	    {
	        vec3 _154 = PathTracePushConstants.m_vCameraOrigin.xyz;
	        vec3 _153 = _221;
	        do
	        {
	            vec3 _161 = _157;
	            vec3 _160 = _156;
	            float _159 = _155;
	            f16vec3 _147 = _138;
	            vec3 _163 = (_154 + (_153 * _159)) + (_160 * ((abs(_154) + vec3(abs(_159))) * 9.9999997473787516355514526367188e-05));
	            vec3 _162 = _160;
	            bool _181;
	            if (false)
	            {
	                _181 = any(notEqual(_161, vec3(3.4028234663852885981170418348452e+38)));
	            }
	            else
	            {
	                _181 = false;
	            }
	            vec3 _316 = _161 - _163;
	            float _317 = length(_316);
	            vec3 _166 = _163;
	            float _165 = 0.0;
	            vec3 _164 = vec4(_316 / vec3(_317), _317).xyz;
	            float _180;
	            if (_181)
	            {
	                _180 = _317;
	            }
	            else
	            {
	                _180 = 0.0;
	            }
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _166, _165, _164, _180, 1);
	            if (_181)
	            {
	                _180 = p_1.m_flVisibility;
	            }
	            else
	            {
	                _180 = 0.0;
	            }
	            if (_180 == 1.0)
	            {
	                _163 = _161;
	                _162 = vec3(_147);
	            }
	            vec3 _167;
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _167, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_138, _137, _136, _135, _134, _133, _132, _131));
	            traceRayEXT(g_AccelStruct, 32u, 32u, 0u, 2u, 0u, _163 - ((_162 * 0.5) * 0.5), 0.0, _162, 0.5, 0);
	            f16vec3 _146 = p.material.vNormalWs;
	            float16_t _145 = p.material.flMetalness;
	            f16vec3 _144 = p.material.vAlbedo;
	            float16_t _143 = p.material.flRoughness;
	            f16vec3 _142 = p.material.vEmissive;
	            float16_t _141 = p.material.flReflectance;
	            uint _140 = p.material.nMaterialTypeAndFlags;
	            f16vec4 _139 = p.material.vMaterialBits;
	            if (p.nInstance != (-1))
	            {
	                _138 = _146;
	                _137 = _145;
	                _136 = _144;
	                _135 = _143;
	                _134 = _142;
	                _133 = _141;
	                _132 = _140;
	                _131 = _139;
	                break;
	            }
	            else
	            {
	                break;
	            }
	            break;
	        } while(false);
	        vec3 _152 = PathTracePushConstants.m_vCameraOrigin.xyz;
	        vec3 _151 = _221;
	        vec3 _150 = _157;
	        vec3 _149 = _156;
	        float _148 = _155;
	        vec3 _168 = (_152 + (_151 * _148)) + (_149 * ((abs(_152) + vec3(abs(_148))) * 9.9999997473787516355514526367188e-05));
	        bool _179;
	        if (true)
	        {
	            _179 = any(notEqual(_150, vec3(3.4028234663852885981170418348452e+38)));
	        }
	        else
	        {
	            _179 = false;
	        }
	        vec3 _413 = _150 - _168;
	        float _414 = length(_413);
	        vec3 _171 = _168;
	        float _170 = 0.0;
	        vec3 _169 = vec4(_413 / vec3(_414), _414).xyz;
	        float _178;
	        if (_179)
	        {
	            _178 = _414;
	        }
	        else
	        {
	            _178 = 0.0;
	        }
	        p_1 = PayloadShadow_t(1.0);
	        traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _171, _170, _169, _178, 1);
	        if (_179)
	        {
	            _178 = p_1.m_flVisibility;
	        }
	        else
	        {
	            _178 = 0.0;
	        }
	        if (_178 == 1.0)
	        {
	            _168 = _150;
	        }
	        if (int(PathTracePushConstants.m_nBounceToShow) < 1)
	        {
	            vNewSample = vec3(_134);
	        }
	        else
	        {
	            vNewSample = vec3(0.0);
	        }
	    }
	    else
	    {
	        vec2 _173 = imageLoad(g_RandomSamples, ivec3(_250.xy, 2)).xy;
	        bool _174;
	        if (_221.z < 0.0)
	        {
	            float _175 = _173.y;
	            bool _172;
	            do
	            {
	                if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w <= 0.0)
	                {
	                    _172 = false;
	                    break;
	                }
	                if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w >= 1.0)
	                {
	                    _172 = true;
	                    break;
	                }
	                if (_175 < g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w)
	                {
	                    _175 = min(_175 / g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                    _172 = true;
	                    break;
	                }
	                _175 = min((_175 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                _172 = false;
	                break;
	            } while(false);
	            vec2 _481 = _173;
	            _481.y = _175;
	            _173 = _481;
	            _174 = _172;
	        }
	        else
	        {
	            _174 = false;
	        }
	        vec3 _176;
	        vec3 _177;
	        if (_174)
	        {
	            float _489 = sqrt(_173.y);
	            float _491 = 6.283185482025146484375 * _173.x;
	            _176 = vec3(cos(_491) * _489, sin(_491) * _489, sqrt(max(0.0, 1.0 - _173.y)));
	            _177 = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.xyz;
	        }
	        else
	        {
	            _176 = _221;
	            _177 = vec3(0.0);
	        }
	        if (g_SceneGlobalInfo._member0[0].m_vIBLParams.y >= 0)
	        {
	            vec4 _531 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._member0[0].m_vIBLParams.y], g_Sampler), normalize(g_SceneGlobalInfo._member0[0].m_mIBLTransformI * vec4(_176, 0.0)), 0.0);
	            if (dot(_531.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.w)
	            {
	                _177 += (g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.xyz * _531.xyz);
	            }
	        }
	        else
	        {
	            _177 += g_SceneGlobalInfo._member0[0].m_vSkyColor.xyz;
	        }
	        if (false)
	        {
	            _177 *= g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.w;
	        }
	        if (_174)
	        {
	            _177 *= g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.xyz;
	        }
	        vNewSample = _177;
	    }
	    vec4 _574 = vec4(mix(vCurrentSample.xyz, vNewSample, vec3(1.0 / (1.0 + vCurrentSample.w))), 1.0 + vCurrentSample.w);
	    imageStore(g_OutputImage, ivec2(gl_LaunchIDEXT.xy), _574);
	    vec2 _183;
	    if (nSampleCount == 0)
	    {
	        _183 = vec2(0.0);
	    }
	    else
	    {
	        _183 = imageLoad(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy)).xy;
	    }
	    float _591 = dot(vNewSample.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _596 = _591 - _183.x;
	    float _598 = _183.x + (_596 / _574.w);
	    imageStore(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy), vec4(vec2(_598, _183.y + (_596 * (_591 - _598))), 0.0, 0.0));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
