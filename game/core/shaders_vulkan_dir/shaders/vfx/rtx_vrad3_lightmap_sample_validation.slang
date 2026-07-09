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
	// SPIR-V source (21784 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct LightmapSample_t_natural_logical
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
	
	layout(set = 6, binding = 158, std430) buffer RWStructuredBuffer
	{
	    LightmapSample_t_natural _member0[];
	} g_LightmapSamples;
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer;
	
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	
	void main()
	{
	    uint nSample = (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x) + gl_LaunchIDEXT.x;
	    LightmapSample_t_natural_logical _204;
	    _204.m_vPositionWs = g_LightmapSamples._member0[nSample].m_vPositionWs;
	    _204.m_vShadingNormalWs_vTransmissiveR = g_LightmapSamples._member0[nSample].m_vShadingNormalWs_vTransmissiveR;
	    _204.m_vInterpolatedNormalWs_vTransmissiveG = g_LightmapSamples._member0[nSample].m_vInterpolatedNormalWs_vTransmissiveG;
	    _204.m_vFaceNormalWs_vTransmissiveB = g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB;
	    _204.m_vTangentWs = g_LightmapSamples._member0[nSample].m_vTangentWs;
	    _204.m_vLightmapUv = g_LightmapSamples._member0[nSample].m_vLightmapUv;
	    _204.m_nInstanceFlags = g_LightmapSamples._member0[nSample].m_nInstanceFlags;
	    _204.m_nSampleFlags = g_LightmapSamples._member0[nSample].m_nSampleFlags;
	    vec4 _144 = _204.m_vPositionWs;
	    vec4 _143 = _204.m_vShadingNormalWs_vTransmissiveR;
	    vec4 _142 = _204.m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 _141 = _204.m_vFaceNormalWs_vTransmissiveB;
	    vec4 _140 = _204.m_vTangentWs;
	    vec2 _139 = _204.m_vLightmapUv;
	    int _138 = _204.m_nInstanceFlags;
	    uint _137 = _204.m_nSampleFlags;
	    vec4 _152 = _204.m_vPositionWs;
	    vec4 _151 = _204.m_vShadingNormalWs_vTransmissiveR;
	    vec4 _150 = _204.m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 _149 = _204.m_vFaceNormalWs_vTransmissiveB;
	    vec4 _148 = _204.m_vTangentWs;
	    vec2 _147 = _204.m_vLightmapUv;
	    int _146 = _204.m_nInstanceFlags;
	    uint _145 = _204.m_nSampleFlags;
	    float _193;
	    if (_204.m_vFaceNormalWs_vTransmissiveB.z >= 0.0)
	    {
	        _193 = 1.0;
	    }
	    else
	    {
	        _193 = -1.0;
	    }
	    float _220 = (-1.0) / (_193 + _204.m_vFaceNormalWs_vTransmissiveB.z);
	    float _224 = (_204.m_vFaceNormalWs_vTransmissiveB.x * _204.m_vFaceNormalWs_vTransmissiveB.y) * _220;
	    vec3 vTangent1Ws;
	    vec3 _229 = vTangent1Ws;
	    _229.x = 1.0 + (((_193 * _204.m_vFaceNormalWs_vTransmissiveB.x) * _204.m_vFaceNormalWs_vTransmissiveB.x) * _220);
	    _229.y = _193 * _224;
	    _229.z = (-_193) * _204.m_vFaceNormalWs_vTransmissiveB.x;
	    vTangent1Ws = _229;
	    vec3 vTangent2Ws;
	    vec3 _236 = vTangent2Ws;
	    _236.x = _224;
	    _236.y = _193 + ((_204.m_vFaceNormalWs_vTransmissiveB.y * _204.m_vFaceNormalWs_vTransmissiveB.y) * _220);
	    _236.z = -_204.m_vFaceNormalWs_vTransmissiveB.y;
	    vTangent2Ws = _236;
	    vec4 _244 = _152;
	    bool bValidSample_2 = _244.w != 0.0;
	    float _194;
	    if (bValidSample_2)
	    {
	        _194 = 12.0;
	    }
	    else
	    {
	        _194 = 0.0;
	    }
	    float _192 = _194;
	    vec4 _160 = _144;
	    vec4 _159 = _143;
	    vec4 _158 = _142;
	    vec4 _157 = _141;
	    vec4 _156 = _140;
	    vec2 _155 = _139;
	    int _154 = _138;
	    uint _153 = _137;
	    vec3 _260 = _141.xyz * 0.0078125;
	    vec3 _261 = _144.xyz - _260;
	    do
	    {
	        f16vec3 _265 = f16vec3(vec3(0.0));
	        vec3 _162;
	        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _162, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_265, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _265, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	        traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _261, 0.0, _141.xyz, _192, 0);
	        if (!(p.nInstance != (-1)))
	        {
	            break;
	        }
	        vec3 _188;
	        if (p.bFlippedNormal)
	        {
	            _188 = -p.vFaceNormalWs;
	        }
	        else
	        {
	            _188 = p.vFaceNormalWs;
	        }
	        if (!(dot(_141.xyz, _188) > 0.0))
	        {
	            break;
	        }
	        float _189;
	        if (p.bFlippedNormal)
	        {
	            _189 = -1.0;
	        }
	        else
	        {
	            _189 = 1.0;
	        }
	        vec3 _306 = (_261 + (_141.xyz * p.flHitT)) + (p.vFaceNormalWs * ((abs(_261) + vec3(abs(p.flHitT))) * 9.9999997473787516355514526367188e-05));
	        float _310 = length(_306 - _144.xyz);
	        if (_310 < _192)
	        {
	            vec4 _316 = _160;
	            _316.x = _306.x;
	            _316.y = _306.y;
	            _316.z = _306.z;
	            _160 = _316;
	            vec3 _326 = vec3(p.material.vNormalWs) * _189;
	            vec4 _328 = _159;
	            _328.x = _326.x;
	            _328.y = _326.y;
	            _328.z = _326.z;
	            _159 = _328;
	            vec3 _336 = p.vInterpolatedNormalWs.xyz * _189;
	            vec4 _338 = _158;
	            _338.x = _336.x;
	            _338.y = _336.y;
	            _338.z = _336.z;
	            _158 = _338;
	            vec3 _344 = p.vFaceNormalWs * _189;
	            vec4 _346 = _157;
	            _346.x = _344.x;
	            _346.y = _344.y;
	            _346.z = _344.z;
	            _157 = _346;
	            uint _190;
	            if (p.nInstance >= 0)
	            {
	                uint _357 = uint(p.nInstance);
	                PackedRtxInstanceData_t_natural_logical _360;
	                _360.nSrgbColor = g_instanceBuffer._member0[_357].nSrgbColor;
	                _360.nTriangleGeometry = g_instanceBuffer._member0[_357].nTriangleGeometry;
	                _360.nMaterialData = g_instanceBuffer._member0[_357].nMaterialData;
	                _360.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[_357].nMaterialFlags_nInstanceFlags;
	                _360.fEmissiveBoost = g_instanceBuffer._member0[_357].fEmissiveBoost;
	                _360.nInstanceFlags = g_instanceBuffer._member0[_357].nInstanceFlags;
	                _360._pad1 = g_instanceBuffer._member0[_357]._pad1;
	                _360._pad2 = g_instanceBuffer._member0[_357]._pad2;
	                uint _163 = _360.nMaterialFlags_nInstanceFlags;
	                _190 = _163 & 65535u;
	            }
	            else
	            {
	                _190 = 0u;
	            }
	            _154 = int(_190);
	            _192 = _310;
	            f16vec4 _161 = p.material.vMaterialBits;
	            bool _187;
	            if ((p.material.nMaterialTypeAndFlags & 65535u) == 1u)
	            {
	                _187 = any(greaterThan(vec3(_161.xyz), vec3(0.0)));
	            }
	            else
	            {
	                _187 = false;
	            }
	            vec3 _191;
	            if (_187)
	            {
	                _191 = vec3(p.material.vMaterialBits.xyz) / max(vec3(p.material.vAlbedo), vec3(0.100000001490116119384765625));
	            }
	            else
	            {
	                _191 = vec3(0.0);
	            }
	            vec4 _394 = _159;
	            _394.w = _191.x;
	            _159 = _394;
	            vec4 _397 = _158;
	            _397.w = _191.y;
	            _158 = _397;
	            vec4 _400 = _157;
	            _400.w = _191.z;
	            _157 = _400;
	        }
	        break;
	    } while(false);
	    vec3 _402 = _144.xyz + _260;
	    vec3 _403 = -_141.xyz;
	    do
	    {
	        f16vec3 _407 = f16vec3(vec3(0.0));
	        vec3 _165;
	        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _165, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_407, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _407, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	        traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _402, 0.0, _403, _192, 0);
	        if (!(p.nInstance != (-1)))
	        {
	            break;
	        }
	        vec3 _183;
	        if (p.bFlippedNormal)
	        {
	            _183 = -p.vFaceNormalWs;
	        }
	        else
	        {
	            _183 = p.vFaceNormalWs;
	        }
	        if (!(dot(_141.xyz, _183) > 0.0))
	        {
	            break;
	        }
	        float _184;
	        if (p.bFlippedNormal)
	        {
	            _184 = -1.0;
	        }
	        else
	        {
	            _184 = 1.0;
	        }
	        vec3 _448 = (_402 + (_403 * p.flHitT)) + (p.vFaceNormalWs * ((abs(_402) + vec3(abs(p.flHitT))) * 9.9999997473787516355514526367188e-05));
	        float _452 = length(_448 - _144.xyz);
	        if (_452 < _192)
	        {
	            vec4 _458 = _160;
	            _458.x = _448.x;
	            _458.y = _448.y;
	            _458.z = _448.z;
	            _160 = _458;
	            vec3 _468 = vec3(p.material.vNormalWs) * _184;
	            vec4 _470 = _159;
	            _470.x = _468.x;
	            _470.y = _468.y;
	            _470.z = _468.z;
	            _159 = _470;
	            vec3 _478 = p.vInterpolatedNormalWs.xyz * _184;
	            vec4 _480 = _158;
	            _480.x = _478.x;
	            _480.y = _478.y;
	            _480.z = _478.z;
	            _158 = _480;
	            vec3 _486 = p.vFaceNormalWs * _184;
	            vec4 _488 = _157;
	            _488.x = _486.x;
	            _488.y = _486.y;
	            _488.z = _486.z;
	            _157 = _488;
	            uint _185;
	            if (p.nInstance >= 0)
	            {
	                uint _499 = uint(p.nInstance);
	                PackedRtxInstanceData_t_natural_logical _502;
	                _502.nSrgbColor = g_instanceBuffer._member0[_499].nSrgbColor;
	                _502.nTriangleGeometry = g_instanceBuffer._member0[_499].nTriangleGeometry;
	                _502.nMaterialData = g_instanceBuffer._member0[_499].nMaterialData;
	                _502.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[_499].nMaterialFlags_nInstanceFlags;
	                _502.fEmissiveBoost = g_instanceBuffer._member0[_499].fEmissiveBoost;
	                _502.nInstanceFlags = g_instanceBuffer._member0[_499].nInstanceFlags;
	                _502._pad1 = g_instanceBuffer._member0[_499]._pad1;
	                _502._pad2 = g_instanceBuffer._member0[_499]._pad2;
	                uint _166 = _502.nMaterialFlags_nInstanceFlags;
	                _185 = _166 & 65535u;
	            }
	            else
	            {
	                _185 = 0u;
	            }
	            _154 = int(_185);
	            _192 = _452;
	            f16vec4 _164 = p.material.vMaterialBits;
	            bool _182;
	            if ((p.material.nMaterialTypeAndFlags & 65535u) == 1u)
	            {
	                _182 = any(greaterThan(vec3(_164.xyz), vec3(0.0)));
	            }
	            else
	            {
	                _182 = false;
	            }
	            vec3 _186;
	            if (_182)
	            {
	                _186 = vec3(p.material.vMaterialBits.xyz) / max(vec3(p.material.vAlbedo), vec3(0.100000001490116119384765625));
	            }
	            else
	            {
	                _186 = vec3(0.0);
	            }
	            vec4 _536 = _159;
	            _536.w = _186.x;
	            _159 = _536;
	            vec4 _539 = _158;
	            _539.w = _186.y;
	            _158 = _539;
	            vec4 _542 = _157;
	            _542.w = _186.z;
	            _157 = _542;
	        }
	        break;
	    } while(false);
	    _152 = _160;
	    _151 = _159;
	    _150 = _158;
	    _149 = _157;
	    _148 = _156;
	    _147 = _155;
	    _146 = _154;
	    _145 = _153;
	    do
	    {
	        vec3 _168 = _152.xyz;
	        vec3 _167 = _149.xyz;
	        f16vec3 _558 = f16vec3(vec3(0.0));
	        vec3 _169;
	        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _169, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_558, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _558, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	        traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _152.xyz, 0.0, _149.xyz, 1.0, 0);
	        if (!(p.nInstance != (-1)))
	        {
	            break;
	        }
	        vec3 _584 = (_168 + (_167 * p.flHitT)) + (_149.xyz * ((abs(_168) + vec3(abs(p.flHitT))) * 9.9999997473787516355514526367188e-05));
	        vec4 _586 = _152;
	        _586.x = _584.x;
	        _586.y = _584.y;
	        _586.z = _584.z;
	        _152 = _586;
	        break;
	    } while(false);
	    bool bValidSample = bValidSample_2;
	    int i = 0;
	    int nBackfacesSeen = 0;
	    bool bValidSample_1;
	    vec3 _170;
	    vec3 _178;
	    float _179;
	    bool _180;
	    bool _181;
	    for (;;)
	    {
	        bool _596_ladder_break = false;
	        do
	        {
	            if (!(i < 8))
	            {
	                _596_ladder_break = true;
	                break;
	            }
	            if (!bValidSample)
	            {
	                _596_ladder_break = true;
	                break;
	            }
	            if ((nBackfacesSeen + (8 - i)) <= 2)
	            {
	                _596_ladder_break = true;
	                break;
	            }
	            uint _613 = uint(i);
	            uint _618 = (_613 << 16u) | (_613 >> 16u);
	            uint _623 = ((_618 & 1431655765u) << 1u) | ((_618 & 2863311530u) >> 1u);
	            uint _628 = ((_623 & 858993459u) << 2u) | ((_623 & 3435973836u) >> 2u);
	            uint _633 = ((_628 & 252645135u) << 4u) | ((_628 & 4042322160u) >> 4u);
	            vec2 _641 = vec2(float(_613) * 0.125, float(((_633 & 16711935u) << 8u) | ((_633 & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
	            float _642 = _641.y;
	            float _643 = sqrt(_642);
	            float _645 = 6.283185482025146484375 * _641.x;
	            vec3 _659 = mat3(vTangent1Ws, vTangent2Ws, _149.xyz) * vec3(cos(_645) * _643, sin(_645) * _643, sqrt(max(0.0, 1.0 - _642)));
	            vec3 _136 = _152.xyz;
	            vec3 _135 = _659;
	            f16vec3 _662 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _170, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_662, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _662, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 0u, 16u, 0u, 2u, 0u, _152.xyz, 0.0, _659, 56755.83984375, 0);
	            Payload_t payload = p;
	            float flRng = payload.flOpacityRng;
	            vec3 _134 = _152.xyz;
	            vec3 _133 = _659;
	            vec3 _132 = payload.vSmoothPositionWs;
	            vec3 _131 = payload.vFaceNormalWs;
	            float _130 = payload.flHitT;
	            int _129 = payload.nInstance;
	            f16vec3 _128 = payload.material.vNormalWs;
	            do
	            {
	                if (!(_129 != (-1)))
	                {
	                    _181 = false;
	                    break;
	                }
	                vec3 _172 = (_134 + (_133 * _130)) + (_131 * ((abs(_134) + vec3(abs(_130))) * 9.9999997473787516355514526367188e-05));
	                vec3 _171 = _131;
	                if (bValidSample)
	                {
	                    _180 = any(notEqual(_132, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _180 = false;
	                }
	                vec3 _712 = _132 - _172;
	                float _713 = length(_712);
	                vec3 _175 = _172;
	                float _174 = 0.0;
	                vec3 _173 = vec4(_712 / vec3(_713), _713).xyz;
	                if (_180)
	                {
	                    _179 = _713;
	                }
	                else
	                {
	                    _179 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _175, _174, _173, _179, 1);
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
	                    _172 = _132;
	                    _171 = vec3(_128);
	                }
	                uint _740 = uint(_129);
	                PackedRtxInstanceData_t_natural_logical _743;
	                _743.nSrgbColor = g_instanceBuffer._member0[_740].nSrgbColor;
	                _743.nTriangleGeometry = g_instanceBuffer._member0[_740].nTriangleGeometry;
	                _743.nMaterialData = g_instanceBuffer._member0[_740].nMaterialData;
	                _743.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[_740].nMaterialFlags_nInstanceFlags;
	                _743.fEmissiveBoost = g_instanceBuffer._member0[_740].fEmissiveBoost;
	                _743.nInstanceFlags = g_instanceBuffer._member0[_740].nInstanceFlags;
	                _743._pad1 = g_instanceBuffer._member0[_740]._pad1;
	                _743._pad2 = g_instanceBuffer._member0[_740]._pad2;
	                uint _176 = _743.nMaterialFlags_nInstanceFlags;
	                if ((int((_176 >> uint(16)) & 65535u) & 1) != 0)
	                {
	                    _181 = false;
	                    break;
	                }
	                if ((int(_176 & 65535u) & 2048) != 0)
	                {
	                    _181 = false;
	                    break;
	                }
	                _181 = dot(_659, _171) > 0.0;
	                break;
	            } while(false);
	            if (!_181)
	            {
	                break;
	            }
	            if (payload.nInstance != (-1))
	            {
	                uint _773 = uint(payload.nInstance);
	                PackedRtxInstanceData_t_natural_logical _776;
	                _776.nSrgbColor = g_instanceBuffer._member0[_773].nSrgbColor;
	                _776.nTriangleGeometry = g_instanceBuffer._member0[_773].nTriangleGeometry;
	                _776.nMaterialData = g_instanceBuffer._member0[_773].nMaterialData;
	                _776.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[_773].nMaterialFlags_nInstanceFlags;
	                _776.fEmissiveBoost = g_instanceBuffer._member0[_773].fEmissiveBoost;
	                _776.nInstanceFlags = g_instanceBuffer._member0[_773].nInstanceFlags;
	                _776._pad1 = g_instanceBuffer._member0[_773]._pad1;
	                _776._pad2 = g_instanceBuffer._member0[_773]._pad2;
	                uint _177 = _776.nMaterialFlags_nInstanceFlags;
	                if (!((int(_177 & 65535u) & 6) != 0))
	                {
	                    break;
	                }
	            }
	            f16vec3 _793 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _178, 3.4028234663852885981170418348452e+38, flRng, -1, false, MaterialDataMinimal_t(_793, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _793, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 16u, 16u, 0u, 2u, 0u, _136, payload.flHitT * 0.99989998340606689453125, _135, payload.flHitT * 1.00010001659393310546875, 0);
	            flRng = p.flOpacityRng;
	            if (p.nInstance != (-1))
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
	        if (_596_ladder_break)
	        {
	            break;
	        }
	        i++;
	        continue;
	    }
	    if (!bValidSample)
	    {
	        _152 = vec4(0.0);
	        _151 = vec4(0.0);
	        _150 = vec4(0.0);
	        _149 = vec4(0.0);
	        _148 = vec4(0.0);
	        _146 = 0;
	        _145 = 0u;
	    }
	    g_LightmapSamples._member0[nSample].m_vPositionWs = _152;
	    g_LightmapSamples._member0[nSample].m_vShadingNormalWs_vTransmissiveR = _151;
	    g_LightmapSamples._member0[nSample].m_vInterpolatedNormalWs_vTransmissiveG = _150;
	    g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB = _149;
	    g_LightmapSamples._member0[nSample].m_vTangentWs = _148;
	    g_LightmapSamples._member0[nSample].m_vLightmapUv = _147;
	    g_LightmapSamples._member0[nSample].m_nInstanceFlags = _146;
	    g_LightmapSamples._member0[nSample].m_nSampleFlags = _145;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
