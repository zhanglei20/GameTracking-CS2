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
	// SPIR-V source (19628 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct LightmapSample_t_natural
	{
	    vec4 m_vPositionWs;
	    vec4 m_vShadingNormalWs_vTransmissiveR;
	    vec4 m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 m_vFaceNormalWs_vTransmissiveB;
	    vec4 m_vTangentWs;
	    vec2 m_vLightmapUv;
	    int m_nInstanceFlags;
	    uint m_nSampleFlags;
	};
	
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
	
	layout(set = 6, binding = 158, std430) buffer RWStructuredBuffer
	{
	    LightmapSample_t_natural _m0[];
	} g_LightmapSamples;
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _m0[];
	} g_instanceBuffer;
	
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	
	void main()
	{
	    uint nSample = (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x) + gl_LaunchIDEXT.x;
	    vec4 _132 = g_LightmapSamples._m0[nSample].m_vPositionWs;
	    vec4 _131 = g_LightmapSamples._m0[nSample].m_vShadingNormalWs_vTransmissiveR;
	    vec4 _130 = g_LightmapSamples._m0[nSample].m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 _129 = g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB;
	    vec4 _128 = g_LightmapSamples._m0[nSample].m_vTangentWs;
	    vec2 _127 = g_LightmapSamples._m0[nSample].m_vLightmapUv;
	    int _126 = g_LightmapSamples._m0[nSample].m_nInstanceFlags;
	    uint _125 = g_LightmapSamples._m0[nSample].m_nSampleFlags;
	    float _167;
	    if (g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.z >= 0.0)
	    {
	        _167 = 1.0;
	    }
	    else
	    {
	        _167 = -1.0;
	    }
	    float _200 = (-1.0) / (_167 + g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.z);
	    float _204 = (g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.x * g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.y) * _200;
	    vec3 vTangent1Ws;
	    vec3 _209 = vTangent1Ws;
	    _209.x = 1.0 + (((_167 * g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.x) * g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.x) * _200);
	    _209.y = _167 * _204;
	    _209.z = (-_167) * g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.x;
	    vTangent1Ws = _209;
	    vec3 vTangent2Ws;
	    vec3 _216 = vTangent2Ws;
	    _216.x = _204;
	    _216.y = _167 + ((g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.y * g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.y) * _200);
	    _216.z = -g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.y;
	    vTangent2Ws = _216;
	    vec4 _224 = _132;
	    bool bValidSample_2 = _224.w != 0.0;
	    float _168;
	    if (bValidSample_2)
	    {
	        _168 = 12.0;
	    }
	    else
	    {
	        _168 = 0.0;
	    }
	    float _166 = _168;
	    vec4 _140 = g_LightmapSamples._m0[nSample].m_vPositionWs;
	    vec4 _139 = g_LightmapSamples._m0[nSample].m_vShadingNormalWs_vTransmissiveR;
	    vec4 _138 = g_LightmapSamples._m0[nSample].m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 _137 = g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB;
	    vec4 _136 = g_LightmapSamples._m0[nSample].m_vTangentWs;
	    vec2 _135 = g_LightmapSamples._m0[nSample].m_vLightmapUv;
	    int _134 = g_LightmapSamples._m0[nSample].m_nInstanceFlags;
	    uint _133 = g_LightmapSamples._m0[nSample].m_nSampleFlags;
	    vec3 _232 = g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.xyz * 0.0078125;
	    vec3 _233 = g_LightmapSamples._m0[nSample].m_vPositionWs.xyz - _232;
	    do
	    {
	        f16vec3 _237 = f16vec3(vec3(0.0));
	        vec3 _141;
	        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _141, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_237, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _237, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	        traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _233, 0.0, g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.xyz, _166, 0);
	        if (!(p._m5 != (-1)))
	        {
	            break;
	        }
	        vec3 _162;
	        if (p._m6)
	        {
	            _162 = -p._m1;
	        }
	        else
	        {
	            _162 = p._m1;
	        }
	        if (!(dot(g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.xyz, _162) > 0.0))
	        {
	            break;
	        }
	        float _163;
	        if (p._m6)
	        {
	            _163 = -1.0;
	        }
	        else
	        {
	            _163 = 1.0;
	        }
	        vec3 _277 = (_233 + (g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.xyz * p._m3)) + (p._m1 * ((abs(_233) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	        float _280 = length(_277 - g_LightmapSamples._m0[nSample].m_vPositionWs.xyz);
	        if (_280 < _166)
	        {
	            vec4 _286 = _140;
	            _286.x = _277.x;
	            _286.y = _277.y;
	            _286.z = _277.z;
	            _140 = _286;
	            vec3 _296 = vec3(p._m7.vMaterialBits) * _163;
	            vec4 _298 = _139;
	            _298.x = _296.x;
	            _298.y = _296.y;
	            _298.z = _296.z;
	            _139 = _298;
	            vec3 _306 = p._m2.xyz * _163;
	            vec4 _308 = _138;
	            _308.x = _306.x;
	            _308.y = _306.y;
	            _308.z = _306.z;
	            _138 = _308;
	            vec3 _314 = p._m1 * _163;
	            vec4 _316 = _137;
	            _316.x = _314.x;
	            _316.y = _314.y;
	            _316.z = _314.z;
	            _137 = _316;
	            uint _164;
	            if (p._m5 >= 0)
	            {
	                _164 = (g_instanceBuffer._m0[uint(p._m5)].nMaterialFlags_nInstanceFlags) & 65535u;
	            }
	            else
	            {
	                _164 = 0u;
	            }
	            _134 = int(_164);
	            _166 = _280;
	            bool _161;
	            if ((p._m7._m6 & 65535u) == 1u)
	            {
	                _161 = any(greaterThan(vec3(p._m7._m7.xyz), vec3(0.0)));
	            }
	            else
	            {
	                _161 = false;
	            }
	            vec3 _165;
	            if (_161)
	            {
	                _165 = vec3(p._m7._m7.xyz) / max(vec3(p._m7._m2), vec3(0.100000001490116119384765625));
	            }
	            else
	            {
	                _165 = vec3(0.0);
	            }
	            vec4 _362 = _139;
	            _362.w = _165.x;
	            _139 = _362;
	            vec4 _365 = _138;
	            _365.w = _165.y;
	            _138 = _365;
	            vec4 _368 = _137;
	            _368.w = _165.z;
	            _137 = _368;
	        }
	        break;
	    } while(false);
	    vec3 _370 = g_LightmapSamples._m0[nSample].m_vPositionWs.xyz + _232;
	    vec3 _371 = -g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.xyz;
	    do
	    {
	        f16vec3 _375 = f16vec3(vec3(0.0));
	        vec3 _142;
	        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _142, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_375, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _375, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	        traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _370, 0.0, _371, _166, 0);
	        if (!(p._m5 != (-1)))
	        {
	            break;
	        }
	        vec3 _157;
	        if (p._m6)
	        {
	            _157 = -p._m1;
	        }
	        else
	        {
	            _157 = p._m1;
	        }
	        if (!(dot(g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB.xyz, _157) > 0.0))
	        {
	            break;
	        }
	        float _158;
	        if (p._m6)
	        {
	            _158 = -1.0;
	        }
	        else
	        {
	            _158 = 1.0;
	        }
	        vec3 _415 = (_370 + (_371 * p._m3)) + (p._m1 * ((abs(_370) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	        float _418 = length(_415 - g_LightmapSamples._m0[nSample].m_vPositionWs.xyz);
	        if (_418 < _166)
	        {
	            vec4 _424 = _140;
	            _424.x = _415.x;
	            _424.y = _415.y;
	            _424.z = _415.z;
	            _140 = _424;
	            vec3 _434 = vec3(p._m7.vMaterialBits) * _158;
	            vec4 _436 = _139;
	            _436.x = _434.x;
	            _436.y = _434.y;
	            _436.z = _434.z;
	            _139 = _436;
	            vec3 _444 = p._m2.xyz * _158;
	            vec4 _446 = _138;
	            _446.x = _444.x;
	            _446.y = _444.y;
	            _446.z = _444.z;
	            _138 = _446;
	            vec3 _452 = p._m1 * _158;
	            vec4 _454 = _137;
	            _454.x = _452.x;
	            _454.y = _452.y;
	            _454.z = _452.z;
	            _137 = _454;
	            uint _159;
	            if (p._m5 >= 0)
	            {
	                _159 = (g_instanceBuffer._m0[uint(p._m5)].nMaterialFlags_nInstanceFlags) & 65535u;
	            }
	            else
	            {
	                _159 = 0u;
	            }
	            _134 = int(_159);
	            _166 = _418;
	            bool _156;
	            if ((p._m7._m6 & 65535u) == 1u)
	            {
	                _156 = any(greaterThan(vec3(p._m7._m7.xyz), vec3(0.0)));
	            }
	            else
	            {
	                _156 = false;
	            }
	            vec3 _160;
	            if (_156)
	            {
	                _160 = vec3(p._m7._m7.xyz) / max(vec3(p._m7._m2), vec3(0.100000001490116119384765625));
	            }
	            else
	            {
	                _160 = vec3(0.0);
	            }
	            vec4 _500 = _139;
	            _500.w = _160.x;
	            _139 = _500;
	            vec4 _503 = _138;
	            _503.w = _160.y;
	            _138 = _503;
	            vec4 _506 = _137;
	            _506.w = _160.z;
	            _137 = _506;
	        }
	        break;
	    } while(false);
	    _132 = _140;
	    _131 = _139;
	    _130 = _138;
	    _129 = _137;
	    _128 = _136;
	    _127 = _135;
	    _126 = _134;
	    _125 = _133;
	    do
	    {
	        vec3 _144 = _132.xyz;
	        vec3 _143 = _129.xyz;
	        f16vec3 _522 = f16vec3(vec3(0.0));
	        vec3 _145;
	        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _145, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_522, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _522, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	        traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _132.xyz, 0.0, _129.xyz, 1.0, 0);
	        if (!(p._m5 != (-1)))
	        {
	            break;
	        }
	        vec3 _548 = (_144 + (_143 * p._m3)) + (_129.xyz * ((abs(_144) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	        vec4 _550 = _132;
	        _550.x = _548.x;
	        _550.y = _548.y;
	        _550.z = _548.z;
	        _132 = _550;
	        break;
	    } while(false);
	    bool bValidSample = bValidSample_2;
	    int i = 0;
	    int nBackfacesSeen = 0;
	    bool bValidSample_1;
	    vec3 _146;
	    vec3 _152;
	    float _153;
	    bool _154;
	    bool _155;
	    for (;;)
	    {
	        bool _560_ladder_break = false;
	        do
	        {
	            if (!(i < 8))
	            {
	                _560_ladder_break = true;
	                break;
	            }
	            if (!bValidSample)
	            {
	                _560_ladder_break = true;
	                break;
	            }
	            if ((nBackfacesSeen + (8 - i)) <= 2)
	            {
	                _560_ladder_break = true;
	                break;
	            }
	            uint _577 = uint(i);
	            uint _582 = (_577 << 16u) | (_577 >> 16u);
	            uint _587 = ((_582 & 1431655765u) << 1u) | ((_582 & 2863311530u) >> 1u);
	            uint _592 = ((_587 & 858993459u) << 2u) | ((_587 & 3435973836u) >> 2u);
	            uint _597 = ((_592 & 252645135u) << 4u) | ((_592 & 4042322160u) >> 4u);
	            vec2 _605 = vec2(float(_577) * 0.125, float(((_597 & 16711935u) << 8u) | ((_597 & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
	            float _606 = _605.y;
	            float _607 = sqrt(_606);
	            float _609 = 6.283185482025146484375 * _605.x;
	            vec3 _623 = mat3(vTangent1Ws, vTangent2Ws, _129.xyz) * vec3(cos(_609) * _607, sin(_609) * _607, sqrt(max(0.0, 1.0 - _606)));
	            vec3 _124 = _132.xyz;
	            vec3 _123 = _623;
	            f16vec3 _626 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _146, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_626, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _626, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 0u, 16u, 0u, 2u, 0u, _132.xyz, 0.0, _623, 56755.83984375, 0);
	            Payload_t payload = p;
	            float flRng = payload._m4;
	            do
	            {
	                if (!(payload._m5 != (-1)))
	                {
	                    _155 = false;
	                    break;
	                }
	                vec3 _148 = (_132.xyz + (_623 * payload._m3)) + (payload._m1 * ((abs(_132.xyz) + vec3(abs(payload._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _147 = payload._m1;
	                if (bValidSample)
	                {
	                    _154 = any(notEqual(payload.material, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _154 = false;
	                }
	                vec3 _669 = payload.material - _148;
	                float _670 = length(_669);
	                vec3 _151 = _148;
	                float _150 = 0.0;
	                vec3 _149 = vec4(_669 / vec3(_670), _670).xyz;
	                if (_154)
	                {
	                    _153 = _670;
	                }
	                else
	                {
	                    _153 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _151, _150, _149, _153, 1);
	                if (_154)
	                {
	                    _153 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _153 = 0.0;
	                }
	                if (_153 == 1.0)
	                {
	                    _148 = payload.material;
	                    _147 = vec3(payload._m7.vMaterialBits);
	                }
	                uint _697 = uint(payload._m5);
	                if ((int((g_instanceBuffer._m0[_697].nMaterialFlags_nInstanceFlags >> uint(16)) & 65535u) & 1) != 0)
	                {
	                    _155 = false;
	                    break;
	                }
	                if ((int((g_instanceBuffer._m0[_697].nMaterialFlags_nInstanceFlags) & 65535u) & 2048) != 0)
	                {
	                    _155 = false;
	                    break;
	                }
	                _155 = dot(_623, _147) > 0.0;
	                break;
	            } while(false);
	            if (!_155)
	            {
	                break;
	            }
	            f16vec3 _728 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _152, 3.4028234663852885981170418348452e+38, flRng, -1, false, MaterialDataMinimal_t(_728, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _728, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 16u, 16u, 0u, 2u, 0u, _124, payload._m3 * 0.99989998340606689453125, _123, payload._m3 * 1.00010001659393310546875, 0);
	            flRng = p._m4;
	            if (p._m5 != (-1))
	            {
	                break;
	            }
	            int nBackfacesSeen_1 = nBackfacesSeen + 1;
	            if (nBackfacesSeen_1 > 2)
	            {
	                bValidSample_1 = false;
	            }
	            else
	            {
	                bValidSample_1 = bValidSample;
	            }
	            bValidSample = bValidSample_1;
	            nBackfacesSeen = nBackfacesSeen_1;
	            break;
	        } while(false);
	        if (_560_ladder_break)
	        {
	            break;
	        }
	        i++;
	        continue;
	    }
	    if (!bValidSample)
	    {
	        _132 = vec4(0.0);
	        _131 = vec4(0.0);
	        _130 = vec4(0.0);
	        _129 = vec4(0.0);
	        _128 = vec4(0.0);
	        _126 = 0;
	        _125 = 0u;
	    }
	    g_LightmapSamples._m0[nSample].m_vPositionWs = _132;
	    g_LightmapSamples._m0[nSample].m_vShadingNormalWs_vTransmissiveR = _131;
	    g_LightmapSamples._m0[nSample].m_vInterpolatedNormalWs_vTransmissiveG = _130;
	    g_LightmapSamples._m0[nSample].m_vFaceNormalWs_vTransmissiveB = _129;
	    g_LightmapSamples._m0[nSample].m_vTangentWs = _128;
	    g_LightmapSamples._m0[nSample].m_vLightmapUv = _127;
	    g_LightmapSamples._m0[nSample].m_nInstanceFlags = _126;
	    g_LightmapSamples._m0[nSample].m_nSampleFlags = _125;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
