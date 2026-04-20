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
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
}

COMMON
{
	#include "system.fxc"
}

RTX
{
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (27728 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
	#extension GL_EXT_shader_16bit_storage : require
	#if defined(GL_AMD_gpu_shader_half_float)
	#extension GL_AMD_gpu_shader_half_float : require
	#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
	#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
	#else
	#error No extension available for FP16.
	#endif
	#extension GL_EXT_ray_tracing : require
	#extension GL_EXT_nonuniform_qualifier : require
	
	struct BuiltInTriangleIntersectionAttributes
	{
	    vec2 barycentrics;
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
	
	struct _Array_natural_vector_int_4_8
	{
	    ivec4 data[8];
	};
	
	struct GeometryInfo_t_natural
	{
	    ivec4 m_nVertexAndIndexBuffers;
	    ivec4 m_nBufferBindOffsetBytes;
	    ivec4 m_nBufferStrideInBytes;
	    ivec4 m_vNormalFieldInfo;
	    ivec4 m_vTangentFieldInfo;
	    _Array_natural_vector_int_4_8 m_vTexCoordFieldInfo;
	    _Array_natural_vector_int_4_8 m_vColorFieldInfo;
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
	
	uint _193;
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _m0[];
	} g_instanceBuffer;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData
	{
	    float _m0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    int _m0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_Geometries
	{
	    GeometryInfo_t_natural _m0[];
	} g_Geometries_1;
	
	layout(set = 3, binding = 33, std430) readonly buffer g_Indices
	{
	    uint _m0[];
	} g_Indices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices
	{
	    float _m0[];
	} g_Vertices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices_2
	{
	    uint _m0[];
	} g_Vertices_3[];
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes _20;
	layout(location = 0) rayPayloadInEXT Payload_t _19;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	
	void main()
	{
	    vec3 _211 = vec3(g_MaterialData_1._m0[g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 4u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 8u) / 4u]);
	    int _210 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 16u) / 4u];
	    int _209 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 24u) / 4u];
	    uvec3 _245;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _321 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _245 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_321 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_321 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_321 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _296 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _297 = _296 & 4294967292u;
	            uint _298 = _297 / 4u;
	            uint _302 = (_297 + 4u) / 4u;
	            uint _307 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_298] & 4294901760u) >> uint(16);
	            uint _308 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_302] & 65535u;
	            uvec3 _246;
	            if (_296 == _297)
	            {
	                _246 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_298] & 65535u, _307, _308);
	            }
	            else
	            {
	                _246 = uvec3(_307, _308, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_302] & 4294901760u) >> uint(16));
	            }
	            _245 = _246;
	            break;
	        }
	        break;
	    } while(false);
	    uint _336 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _344 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _245) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    uint _345 = _344.x;
	    vec3 _208 = vec3(g_Vertices_1[_336]._m0[_345 / 4u], g_Vertices_1[_336]._m0[(_345 + 4u) / 4u], g_Vertices_1[_336]._m0[(_345 + 8u) / 4u]);
	    uint _358 = _344.y;
	    vec3 _207 = vec3(g_Vertices_1[_336]._m0[_358 / 4u], g_Vertices_1[_336]._m0[(_358 + 4u) / 4u], g_Vertices_1[_336]._m0[(_358 + 8u) / 4u]);
	    uint _371 = _344.z;
	    vec3 _206 = vec3(g_Vertices_1[_336]._m0[_371 / 4u], g_Vertices_1[_336]._m0[(_371 + 4u) / 4u], g_Vertices_1[_336]._m0[(_371 + 8u) / 4u]);
	    vec3 _203;
	    vec3 _204;
	    vec3 _205;
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	    {
	        ivec4 _238 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _395 = uint(_238[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	        uint _397 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	        ivec4 _236 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _237 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _408 = (uvec3(uint(_236[_397])) * _245) + uvec3(uint(_237[_397]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	        {
	            uint _652 = _408.x;
	            _205 = vec3(g_Vertices_1[_395]._m0[_652 / 4u], g_Vertices_1[_395]._m0[(_652 + 4u) / 4u], g_Vertices_1[_395]._m0[(_652 + 8u) / 4u]);
	            uint _665 = _408.y;
	            _204 = vec3(g_Vertices_1[_395]._m0[_665 / 4u], g_Vertices_1[_395]._m0[(_665 + 4u) / 4u], g_Vertices_1[_395]._m0[(_665 + 8u) / 4u]);
	            uint _678 = _408.z;
	            _203 = vec3(g_Vertices_1[_395]._m0[_678 / 4u], g_Vertices_1[_395]._m0[(_678 + 4u) / 4u], g_Vertices_1[_395]._m0[(_678 + 8u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	            {
	                uint _525 = _408.x;
	                uvec2 _532 = uvec2(g_Vertices_3[_395]._m0[_525 / 4u], _193);
	                uint _533 = _408.y;
	                uvec2 _199 = uvec2(g_Vertices_3[_395]._m0[_533 / 4u], g_Vertices_3[_395]._m0[(_533 + 4u) / 4u]);
	                uint _542 = _408.z;
	                uvec2 _198 = uvec2(g_Vertices_3[_395]._m0[_542 / 4u], g_Vertices_3[_395]._m0[(_542 + 4u) / 4u]);
	                uint _551 = _532.x;
	                vec2 _561 = ((vec2(float((_551) & 65535u), float((_551 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                float _562 = _561.x;
	                float _567 = (1.0 - abs(_562)) - abs(_561.y);
	                vec3 _568 = vec3(_562, _561.y, _567);
	                float _570 = saturate(-_567);
	                vec2 _576 = _561 + mix(vec2(_570), vec2(-_570), greaterThanEqual(_561, vec2(0.0)));
	                _568.x = _576.x;
	                _568.y = _576.y;
	                vec3 _242 = normalize(_568);
	                _205 = _242;
	                vec2 _595 = ((vec2(float((_199.x) & 65535u), float((_199.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                float _596 = _595.x;
	                float _601 = (1.0 - abs(_596)) - abs(_595.y);
	                vec3 _602 = vec3(_596, _595.y, _601);
	                float _604 = saturate(-_601);
	                vec2 _610 = _595 + mix(vec2(_604), vec2(-_604), greaterThanEqual(_595, vec2(0.0)));
	                _602.x = _610.x;
	                _602.y = _610.y;
	                vec3 _243 = normalize(_602);
	                _204 = _243;
	                vec2 _629 = ((vec2(float((_198.x) & 65535u), float((_198.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                float _630 = _629.x;
	                float _635 = (1.0 - abs(_630)) - abs(_629.y);
	                vec3 _636 = vec3(_630, _629.y, _635);
	                float _638 = saturate(-_635);
	                vec2 _644 = _629 + mix(vec2(_638), vec2(-_638), greaterThanEqual(_629, vec2(0.0)));
	                _636.x = _644.x;
	                _636.y = _644.y;
	                vec3 _244 = normalize(_636);
	                _203 = _244;
	            }
	            else
	            {
	                uint _418 = _408.x / 4u;
	                float _427 = (float((g_Vertices_3[_395]._m0[_418] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _430 = (float((g_Vertices_3[_395]._m0[_418] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _434 = (1.0 - abs(_427)) - abs(_430);
	                vec3 _435 = vec3(_427, _430, _434);
	                float _437 = saturate(-_434);
	                vec2 _438 = vec2(_427, _430);
	                vec2 _444 = _438 + mix(vec2(_437), vec2(-_437), greaterThanEqual(_438, vec2(0.0)));
	                _435.x = _444.x;
	                _435.y = _444.y;
	                vec3 _239 = normalize(_435);
	                _205 = _239;
	                uint _454 = _408.y / 4u;
	                float _463 = (float((g_Vertices_3[_395]._m0[_454] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _466 = (float((g_Vertices_3[_395]._m0[_454] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _470 = (1.0 - abs(_463)) - abs(_466);
	                vec3 _471 = vec3(_463, _466, _470);
	                float _473 = saturate(-_470);
	                vec2 _474 = vec2(_463, _466);
	                vec2 _480 = _474 + mix(vec2(_473), vec2(-_473), greaterThanEqual(_474, vec2(0.0)));
	                _471.x = _480.x;
	                _471.y = _480.y;
	                vec3 _240 = normalize(_471);
	                _204 = _240;
	                uint _490 = _408.z / 4u;
	                float _499 = (float((g_Vertices_3[_395]._m0[_490] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _502 = (float((g_Vertices_3[_395]._m0[_490] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _506 = (1.0 - abs(_499)) - abs(_502);
	                vec3 _507 = vec3(_499, _502, _506);
	                float _509 = saturate(-_506);
	                vec2 _510 = vec2(_499, _502);
	                vec2 _516 = _510 + mix(vec2(_509), vec2(-_509), greaterThanEqual(_510, vec2(0.0)));
	                _507.x = _516.x;
	                _507.y = _516.y;
	                vec3 _241 = normalize(_507);
	                _203 = _241;
	            }
	        }
	    }
	    else
	    {
	        _205 = vec3(0.0);
	        _204 = vec3(0.0);
	        _203 = vec3(0.0);
	    }
	    vec2 _202 = vec2(0.0);
	    vec2 _201 = vec2(0.0);
	    vec2 _200 = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _235 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _703 = uint(_235[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _705 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _233 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _234 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _716 = (uvec3(uint(_233[_705])) * _245) + uvec3(uint(_234[_705]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _851 = _716.x;
	            _202 = vec2(g_Vertices_1[_703]._m0[_851 / 4u], g_Vertices_1[_703]._m0[(_851 + 4u) / 4u]);
	            uint _860 = _716.y;
	            _201 = vec2(g_Vertices_1[_703]._m0[_860 / 4u], g_Vertices_1[_703]._m0[(_860 + 4u) / 4u]);
	            uint _869 = _716.z;
	            _200 = vec2(g_Vertices_1[_703]._m0[_869 / 4u], g_Vertices_1[_703]._m0[(_869 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _822 = _716.x / 4u;
	                _202 = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_703]._m0[_822], g_Vertices_3[_703]._m0[_822] >> uint(16)) & uvec2(65535u))));
	                uint _832 = _716.y / 4u;
	                _201 = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_703]._m0[_832], g_Vertices_3[_703]._m0[_832] >> uint(16)) & uvec2(65535u))));
	                uint _842 = _716.z / 4u;
	                _200 = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_703]._m0[_842], g_Vertices_3[_703]._m0[_842] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _729 = _716.x / 4u;
	                    uint _733 = (g_Vertices_3[_703]._m0[_729] & 65535u);
	                    int _232;
	                    if (_733 > 32767u)
	                    {
	                        _232 = int(4294901760u | _733);
	                    }
	                    else
	                    {
	                        _232 = int(_733);
	                    }
	                    uint _746 = (g_Vertices_3[_703]._m0[_729] & 4294901760u) >> uint(16);
	                    int _231;
	                    if (_746 > 32767u)
	                    {
	                        _231 = int(4294901760u | _746);
	                    }
	                    else
	                    {
	                        _231 = int(_746);
	                    }
	                    _202 = vec2(max(float(_232) * 3.0518509447574615478515625e-05, -1.0), max(float(_231) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _760 = _716.y / 4u;
	                    uint _764 = (g_Vertices_3[_703]._m0[_760] & 65535u);
	                    int _230;
	                    if (_764 > 32767u)
	                    {
	                        _230 = int(4294901760u | _764);
	                    }
	                    else
	                    {
	                        _230 = int(_764);
	                    }
	                    uint _777 = (g_Vertices_3[_703]._m0[_760] & 4294901760u) >> uint(16);
	                    int _229;
	                    if (_777 > 32767u)
	                    {
	                        _229 = int(4294901760u | _777);
	                    }
	                    else
	                    {
	                        _229 = int(_777);
	                    }
	                    _201 = vec2(max(float(_230) * 3.0518509447574615478515625e-05, -1.0), max(float(_229) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _791 = _716.z / 4u;
	                    uint _795 = (g_Vertices_3[_703]._m0[_791] & 65535u);
	                    int _228;
	                    if (_795 > 32767u)
	                    {
	                        _228 = int(4294901760u | _795);
	                    }
	                    else
	                    {
	                        _228 = int(_795);
	                    }
	                    uint _808 = (g_Vertices_3[_703]._m0[_791] & 4294901760u) >> uint(16);
	                    int _227;
	                    if (_808 > 32767u)
	                    {
	                        _227 = int(4294901760u | _808);
	                    }
	                    else
	                    {
	                        _227 = int(_808);
	                    }
	                    _200 = vec2(max(float(_228) * 3.0518509447574615478515625e-05, -1.0), max(float(_227) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    vec4 _905 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _226 = _905;
	    vec3 _906 = _905.xyz;
	    vec3 _907 = _906 * vec3(0.077399380505084991455078125);
	    vec3 _910 = pow((_906 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _223;
	    if (_905.x <= 0.040449999272823333740234375)
	    {
	        _223 = _907.x;
	    }
	    else
	    {
	        _223 = _910.x;
	    }
	    float _224;
	    if (_905.y <= 0.040449999272823333740234375)
	    {
	        _224 = _907.y;
	    }
	    else
	    {
	        _224 = _910.y;
	    }
	    float _225;
	    if (_905.z <= 0.040449999272823333740234375)
	    {
	        _225 = _907.z;
	    }
	    else
	    {
	        _225 = _910.z;
	    }
	    vec3 _935 = vec3(_223, _224, _225);
	    vec4 _937 = _226;
	    _937.x = _935.x;
	    _937.y = _935.y;
	    _937.z = _935.z;
	    _226 = _937;
	    f16vec3 _944 = f16vec3(vec3(0.0));
	    _19._m7 = MaterialDataMinimal_t(_944, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _944, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _19._m3 = gl_RayTmaxEXT;
	    vec3 _222;
	    do
	    {
	        vec3 _964 = ((_205 * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_204 * _20.barycentrics.x)) + (_203 * _20.barycentrics.y);
	        if (all(equal(_964, vec3(0.0))))
	        {
	            _222 = vec3(0.0);
	            break;
	        }
	        mat3x4 _970 = transpose(gl_WorldToObjectEXT);
	        mat3 _221;
	        mat3 _973 = _221;
	        _973[0] = _970[0].xyz;
	        _973[1] = _970[1].xyz;
	        _973[2] = _970[2].xyz;
	        _221 = _973;
	        _222 = normalize(_973 * _964);
	        break;
	    } while(false);
	    f16vec3 _984 = f16vec3(_222);
	    _19._m7.vMaterialBits = _984;
	    _19._m2 = vec3(_984);
	    mat3x4 _995 = transpose(gl_WorldToObjectEXT);
	    mat3 _220;
	    mat3 _998 = _220;
	    _998[0] = _995[0].xyz;
	    _998[1] = _995[1].xyz;
	    _998[2] = _995[2].xyz;
	    _220 = _998;
	    _19._m1 = normalize(_998 * cross(_207 - _208, _206 - _208));
	    if ((_209 & 1) != 0)
	    {
	        if (gl_HitKindEXT == 255u)
	        {
	            _19._m1 = -_19._m1;
	            _19._m2 = -_19._m2;
	            _19._m7.vMaterialBits = -_19._m7.vMaterialBits;
	            _19._m6 = true;
	        }
	    }
	    vec3 _1036 = normalize(cross(_207 - _208, _206 - _208));
	    vec3 _212[3] = vec3[](_205, _204, _203);
	    vec3 _213[3] = vec3[](_208, _207, _206);
	    vec3 _1045 = ((_208 * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_207 * _20.barycentrics.x)) + (_206 * _20.barycentrics.y);
	    vec3 _214[3];
	    _214[0] = _1045 - (_205 * dot(_1045 - _208, _205));
	    _214[1] = _1045 - (_204 * dot(_1045 - _207, _204));
	    _214[2] = _1045 - (_203 * dot(_1045 - _206, _203));
	    vec3 _1073 = ((_214[0] * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_214[1] * _20.barycentrics.x)) + (_214[2] * _20.barycentrics.y);
	    vec3 _215[3];
	    _215[0] = cross(_208 - _207, _1036);
	    _215[1] = cross(_207 - _206, _1036);
	    _215[2] = cross(_206 - _208, _1036);
	    float _216 = dot(_1073 - _1045, _1036);
	    vec3 _217 = _1073;
	    int _218 = 0;
	    for (;;)
	    {
	        bool _1089_ladder_break = false;
	        do
	        {
	            if (!(_218 < 3))
	            {
	                _1089_ladder_break = true;
	                break;
	            }
	            if (_216 > 0.00999999977648258209228515625)
	            {
	                _1089_ladder_break = true;
	                break;
	            }
	            if (dot(_215[_218], _215[_218]) == 0.0)
	            {
	                break;
	            }
	            _215[_218] = normalize(_215[_218]);
	            int _219 = 0;
	            for (;;)
	            {
	                if (!(_219 < 3))
	                {
	                    break;
	                }
	                vec3 _1127 = _212[_219] - (_215[_218] * dot(_215[_218], _212[_219]));
	                _214[_219] = _1045 - (_1127 * dot(_1045 - _213[_219], _1127));
	                _219++;
	                continue;
	            }
	            vec3 _1151 = ((_214[0] * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_214[1] * _20.barycentrics.x)) + (_214[2] * _20.barycentrics.y);
	            _216 = dot(_1151 - _1045, _1036);
	            _217 = _1151;
	            break;
	        } while(false);
	        if (_1089_ladder_break)
	        {
	            break;
	        }
	        _218++;
	        continue;
	    }
	    if (!(_216 > 0.00999999977648258209228515625))
	    {
	        _217 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _19.material = _217;
	    if (any(notEqual(_217, vec3(3.4028234663852885981170418348452e+38))))
	    {
	        _19.material = gl_ObjectToWorldEXT * vec4(_19.material.xyz, 1.0);
	    }
	    _19._m7._m2 = f16vec3(_211);
	    if (_210 >= 0)
	    {
	        _19._m7._m2 = f16vec3(textureLod(sampler2D(g_bindless_Texture2D[uint(_210)], g_Sampler), ((_202 * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_201 * _20.barycentrics.x)) + (_200 * _20.barycentrics.y), 0.0).xyz);
	    }
	    _19._m7._m2 *= f16vec3(_937.xyz);
	    _19._m5 = int(uint(gl_InstanceID));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
