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
	// SPIR-V source (29288 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct BuiltInTriangleIntersectionAttributes
	{
	    vec2 barycentrics;
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
	
	uint _199;
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData
	{
	    float _member0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    int _member0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_Geometries
	{
	    GeometryInfo_t_natural _member0[];
	} g_Geometries_1;
	
	layout(set = 3, binding = 33, std430) readonly buffer g_Indices
	{
	    uint _member0[];
	} g_Indices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices
	{
	    float _member0[];
	} g_Vertices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices_2
	{
	    uint _member0[];
	} g_Vertices_3[];
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes attrs;
	layout(location = 0) rayPayloadInEXT Payload_t payload;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	
	void main()
	{
	    PackedRtxInstanceData_t_natural_logical _260;
	    _260.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _260.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _260.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _260.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _260.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _260.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _260._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _260._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    uint _218 = _260.nMaterialData;
	    vec3 _221 = vec3(g_MaterialData_1._member0[_218 / 4u], g_MaterialData_1._member0[(_218 + 4u) / 4u], g_MaterialData_1._member0[(_218 + 8u) / 4u]);
	    int _220 = g_MaterialData_3._member0[(_218 + 16u) / 4u];
	    int _219 = g_MaterialData_3._member0[(_218 + 24u) / 4u];
	    uvec3 _253;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _333 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _253 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_333 / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_333 + 4u) / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_333 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _306 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _307 = _306 & 4294967292u;
	            uint _308 = _307 / 4u;
	            uint _312 = (_307 + 4u) / 4u;
	            uint _317 = (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_308] & 4294901760u) >> uint(16);
	            uint _318 = g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_312] & 65535u;
	            uvec3 _254;
	            if (_306 == _307)
	            {
	                _254 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_308] & 65535u, _317, _318);
	            }
	            else
	            {
	                _254 = uvec3(_317, _318, (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_312] & 4294901760u) >> uint(16));
	            }
	            _253 = _254;
	            break;
	        }
	        break;
	    } while(false);
	    uint _59 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _363 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _253) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    uint _364 = _363.x;
	    vec3 _217 = vec3(g_Vertices_1[_59]._member0[_364 / 4u], g_Vertices_1[_59]._member0[(_364 + 4u) / 4u], g_Vertices_1[_59]._member0[(_364 + 8u) / 4u]);
	    uint _377 = _363.y;
	    vec3 _216 = vec3(g_Vertices_1[_59]._member0[_377 / 4u], g_Vertices_1[_59]._member0[(_377 + 4u) / 4u], g_Vertices_1[_59]._member0[(_377 + 8u) / 4u]);
	    uint _390 = _363.z;
	    vec3 _215 = vec3(g_Vertices_1[_59]._member0[_390 / 4u], g_Vertices_1[_59]._member0[(_390 + 4u) / 4u], g_Vertices_1[_59]._member0[(_390 + 8u) / 4u]);
	    vec3 _212;
	    vec3 _213;
	    vec3 _214;
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	    {
	        ivec4 _246 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _61 = uint(_246[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	        uint _418 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	        ivec4 _244 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _245 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _434 = (uvec3(uint(_244[_418])) * _253) + uvec3(uint(_245[_418]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	        {
	            uint _675 = _434.x;
	            _214 = vec3(g_Vertices_1[_61]._member0[_675 / 4u], g_Vertices_1[_61]._member0[(_675 + 4u) / 4u], g_Vertices_1[_61]._member0[(_675 + 8u) / 4u]);
	            uint _688 = _434.y;
	            _213 = vec3(g_Vertices_1[_61]._member0[_688 / 4u], g_Vertices_1[_61]._member0[(_688 + 4u) / 4u], g_Vertices_1[_61]._member0[(_688 + 8u) / 4u]);
	            uint _701 = _434.z;
	            _212 = vec3(g_Vertices_1[_61]._member0[_701 / 4u], g_Vertices_1[_61]._member0[(_701 + 4u) / 4u], g_Vertices_1[_61]._member0[(_701 + 8u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	            {
	                uint _551 = _434.x;
	                uvec2 _558 = uvec2(g_Vertices_3[_61]._member0[_551 / 4u], _199);
	                uint _559 = _434.y;
	                uvec2 _205 = uvec2(g_Vertices_3[_61]._member0[_559 / 4u], g_Vertices_3[_61]._member0[(_559 + 4u) / 4u]);
	                uint _568 = _434.z;
	                uvec2 _204 = uvec2(g_Vertices_3[_61]._member0[_568 / 4u], g_Vertices_3[_61]._member0[(_568 + 4u) / 4u]);
	                uint _577 = _558.x;
	                vec2 _586 = ((vec2(float(_577 & 65535u), float((_577 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                float _587 = _586.x;
	                float _592 = (1.0 - abs(_587)) - abs(_586.y);
	                vec3 _593 = vec3(_587, _586.y, _592);
	                float _595 = saturate(-_592);
	                vec2 _601 = _586 + mix(vec2(_595), vec2(-_595), greaterThanEqual(_586, vec2(0.0)));
	                _593.x = _601.x;
	                _593.y = _601.y;
	                vec3 _247 = normalize(_593);
	                _214 = _247;
	                vec2 _619 = ((vec2(float(_205.x & 65535u), float((_205.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                float _620 = _619.x;
	                float _625 = (1.0 - abs(_620)) - abs(_619.y);
	                vec3 _626 = vec3(_620, _619.y, _625);
	                float _628 = saturate(-_625);
	                vec2 _634 = _619 + mix(vec2(_628), vec2(-_628), greaterThanEqual(_619, vec2(0.0)));
	                _626.x = _634.x;
	                _626.y = _634.y;
	                vec3 _248 = normalize(_626);
	                _213 = _248;
	                vec2 _652 = ((vec2(float(_204.x & 65535u), float((_204.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                float _653 = _652.x;
	                float _658 = (1.0 - abs(_653)) - abs(_652.y);
	                vec3 _659 = vec3(_653, _652.y, _658);
	                float _661 = saturate(-_658);
	                vec2 _667 = _652 + mix(vec2(_661), vec2(-_661), greaterThanEqual(_652, vec2(0.0)));
	                _659.x = _667.x;
	                _659.y = _667.y;
	                vec3 _249 = normalize(_659);
	                _212 = _249;
	            }
	            else
	            {
	                uint _444 = _434.x / 4u;
	                float _453 = (float((g_Vertices_3[_61]._member0[_444] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _456 = (float((g_Vertices_3[_61]._member0[_444] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _460 = (1.0 - abs(_453)) - abs(_456);
	                vec3 _461 = vec3(_453, _456, _460);
	                float _463 = saturate(-_460);
	                vec2 _464 = vec2(_453, _456);
	                vec2 _470 = _464 + mix(vec2(_463), vec2(-_463), greaterThanEqual(_464, vec2(0.0)));
	                _461.x = _470.x;
	                _461.y = _470.y;
	                vec3 _250 = normalize(_461);
	                _214 = _250;
	                uint _480 = _434.y / 4u;
	                float _489 = (float((g_Vertices_3[_61]._member0[_480] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _492 = (float((g_Vertices_3[_61]._member0[_480] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _496 = (1.0 - abs(_489)) - abs(_492);
	                vec3 _497 = vec3(_489, _492, _496);
	                float _499 = saturate(-_496);
	                vec2 _500 = vec2(_489, _492);
	                vec2 _506 = _500 + mix(vec2(_499), vec2(-_499), greaterThanEqual(_500, vec2(0.0)));
	                _497.x = _506.x;
	                _497.y = _506.y;
	                vec3 _251 = normalize(_497);
	                _213 = _251;
	                uint _516 = _434.z / 4u;
	                float _525 = (float((g_Vertices_3[_61]._member0[_516] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _528 = (float((g_Vertices_3[_61]._member0[_516] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _532 = (1.0 - abs(_525)) - abs(_528);
	                vec3 _533 = vec3(_525, _528, _532);
	                float _535 = saturate(-_532);
	                vec2 _536 = vec2(_525, _528);
	                vec2 _542 = _536 + mix(vec2(_535), vec2(-_535), greaterThanEqual(_536, vec2(0.0)));
	                _533.x = _542.x;
	                _533.y = _542.y;
	                vec3 _252 = normalize(_533);
	                _212 = _252;
	            }
	        }
	    }
	    else
	    {
	        _214 = vec3(0.0);
	        _213 = vec3(0.0);
	        _212 = vec3(0.0);
	    }
	    vec2 _211 = vec2(0.0);
	    vec2 _210 = vec2(0.0);
	    vec2 _209 = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _243 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _65 = uint(_243[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _730 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _241 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _242 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _746 = (uvec3(uint(_241[_730])) * _253) + uvec3(uint(_242[_730]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _878 = _746.x;
	            _211 = vec2(g_Vertices_1[_65]._member0[_878 / 4u], g_Vertices_1[_65]._member0[(_878 + 4u) / 4u]);
	            uint _887 = _746.y;
	            _210 = vec2(g_Vertices_1[_65]._member0[_887 / 4u], g_Vertices_1[_65]._member0[(_887 + 4u) / 4u]);
	            uint _896 = _746.z;
	            _209 = vec2(g_Vertices_1[_65]._member0[_896 / 4u], g_Vertices_1[_65]._member0[(_896 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _849 = _746.x / 4u;
	                _211 = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_65]._member0[_849], g_Vertices_3[_65]._member0[_849] >> uint(16)) & uvec2(65535u))));
	                uint _859 = _746.y / 4u;
	                _210 = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_65]._member0[_859], g_Vertices_3[_65]._member0[_859] >> uint(16)) & uvec2(65535u))));
	                uint _869 = _746.z / 4u;
	                _209 = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_65]._member0[_869], g_Vertices_3[_65]._member0[_869] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _759 = _746.x / 4u;
	                    uint _762 = g_Vertices_3[_65]._member0[_759] & 65535u;
	                    int _240;
	                    if (_762 > 32767u)
	                    {
	                        _240 = int(4294901760u | _762);
	                    }
	                    else
	                    {
	                        _240 = int(_762);
	                    }
	                    uint _775 = (g_Vertices_3[_65]._member0[_759] & 4294901760u) >> uint(16);
	                    int _239;
	                    if (_775 > 32767u)
	                    {
	                        _239 = int(4294901760u | _775);
	                    }
	                    else
	                    {
	                        _239 = int(_775);
	                    }
	                    _211 = vec2(max(float(_240) * 3.0518509447574615478515625e-05, -1.0), max(float(_239) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _789 = _746.y / 4u;
	                    uint _792 = g_Vertices_3[_65]._member0[_789] & 65535u;
	                    int _238;
	                    if (_792 > 32767u)
	                    {
	                        _238 = int(4294901760u | _792);
	                    }
	                    else
	                    {
	                        _238 = int(_792);
	                    }
	                    uint _805 = (g_Vertices_3[_65]._member0[_789] & 4294901760u) >> uint(16);
	                    int _237;
	                    if (_805 > 32767u)
	                    {
	                        _237 = int(4294901760u | _805);
	                    }
	                    else
	                    {
	                        _237 = int(_805);
	                    }
	                    _210 = vec2(max(float(_238) * 3.0518509447574615478515625e-05, -1.0), max(float(_237) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _819 = _746.z / 4u;
	                    uint _822 = g_Vertices_3[_65]._member0[_819] & 65535u;
	                    int _236;
	                    if (_822 > 32767u)
	                    {
	                        _236 = int(4294901760u | _822);
	                    }
	                    else
	                    {
	                        _236 = int(_822);
	                    }
	                    uint _835 = (g_Vertices_3[_65]._member0[_819] & 4294901760u) >> uint(16);
	                    int _235;
	                    if (_835 > 32767u)
	                    {
	                        _235 = int(4294901760u | _835);
	                    }
	                    else
	                    {
	                        _235 = int(_835);
	                    }
	                    _209 = vec2(max(float(_236) * 3.0518509447574615478515625e-05, -1.0), max(float(_235) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    PackedRtxInstanceData_t_natural_logical _922;
	    _922.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _922.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _922.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _922.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _922.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _922.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _922._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _922._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _933 = vec4(uvec4(_922.nSrgbColor & 255u, (_922.nSrgbColor & 65280u) >> uint(8), (_922.nSrgbColor & 16711680u) >> uint(16), (_922.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _234 = _933;
	    vec3 _934 = _933.xyz;
	    vec3 _935 = _934 * vec3(0.077399380505084991455078125);
	    vec3 _938 = pow((_934 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _231;
	    if (_933.x <= 0.040449999272823333740234375)
	    {
	        _231 = _935.x;
	    }
	    else
	    {
	        _231 = _938.x;
	    }
	    float _232;
	    if (_933.y <= 0.040449999272823333740234375)
	    {
	        _232 = _935.y;
	    }
	    else
	    {
	        _232 = _938.y;
	    }
	    float _233;
	    if (_933.z <= 0.040449999272823333740234375)
	    {
	        _233 = _935.z;
	    }
	    else
	    {
	        _233 = _938.z;
	    }
	    vec3 _963 = vec3(_231, _232, _233);
	    vec4 _965 = _234;
	    _965.x = _963.x;
	    _965.y = _963.y;
	    _965.z = _963.z;
	    _234 = _965;
	    f16vec3 _972 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_972, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _972, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.flHitT = gl_RayTmaxEXT;
	    vec3 _208 = _214;
	    vec3 _207 = _213;
	    vec3 _206 = _212;
	    vec3 _230;
	    do
	    {
	        vec3 _996 = ((_208 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_207 * attrs.barycentrics.x)) + (_206 * attrs.barycentrics.y);
	        if (all(equal(_996, vec3(0.0))))
	        {
	            _230 = vec3(0.0);
	            break;
	        }
	        mat3x4 _1002 = transpose(gl_WorldToObjectEXT);
	        mat3 _229;
	        mat3 _1005 = _229;
	        _1005[0] = _1002[0].xyz;
	        _1005[1] = _1002[1].xyz;
	        _1005[2] = _1002[2].xyz;
	        _229 = _1005;
	        _230 = normalize(_1005 * _996);
	        break;
	    } while(false);
	    f16vec3 _1016 = f16vec3(_230);
	    payload.material.vNormalWs = _1016;
	    payload.vInterpolatedNormalWs = vec3(_1016);
	    mat3x4 _1027 = transpose(gl_WorldToObjectEXT);
	    mat3 _228;
	    mat3 _1030 = _228;
	    _1030[0] = _1027[0].xyz;
	    _1030[1] = _1027[1].xyz;
	    _1030[2] = _1027[2].xyz;
	    _228 = _1030;
	    payload.vFaceNormalWs = normalize(_1030 * cross(_216 - _217, _215 - _217));
	    if ((_219 & 1) != 0)
	    {
	        if (gl_HitKindEXT == 255u)
	        {
	            payload.vFaceNormalWs = -payload.vFaceNormalWs;
	            payload.vInterpolatedNormalWs = -payload.vInterpolatedNormalWs;
	            payload.material.vNormalWs = -payload.material.vNormalWs;
	            payload.bFlippedNormal = true;
	        }
	    }
	    vec3 _1068 = normalize(cross(_216 - _217, _215 - _217));
	    vec3 _255[3] = vec3[](_217, _216, _215);
	    vec3 _256[3] = vec3[](_214, _213, _212);
	    vec3 _1084 = ((_255[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_255[1] * attrs.barycentrics.x)) + (_255[2] * attrs.barycentrics.y);
	    vec3 _222[3];
	    _222[0] = _1084 - (_256[0] * dot(_1084 - _255[0], _256[0]));
	    _222[1] = _1084 - (_256[1] * dot(_1084 - _255[1], _256[1]));
	    _222[2] = _1084 - (_256[2] * dot(_1084 - _255[2], _256[2]));
	    vec3 _1124 = ((_222[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_222[1] * attrs.barycentrics.x)) + (_222[2] * attrs.barycentrics.y);
	    vec3 _223[3];
	    _223[0] = cross(_255[0] - _255[1], _1068);
	    _223[1] = cross(_255[1] - _255[2], _1068);
	    _223[2] = cross(_255[2] - _255[0], _1068);
	    float _224 = dot(_1124 - _1084, _1068);
	    vec3 _225 = _1124;
	    int _226 = 0;
	    for (;;)
	    {
	        bool _1140_ladder_break = false;
	        do
	        {
	            if (!(_226 < 3))
	            {
	                _1140_ladder_break = true;
	                break;
	            }
	            if (_224 > 0.00999999977648258209228515625)
	            {
	                _1140_ladder_break = true;
	                break;
	            }
	            if (dot(_223[_226], _223[_226]) == 0.0)
	            {
	                break;
	            }
	            _223[_226] = normalize(_223[_226]);
	            int _227 = 0;
	            for (;;)
	            {
	                if (!(_227 < 3))
	                {
	                    break;
	                }
	                vec3 _1178 = _256[_227] - (_223[_226] * dot(_223[_226], _256[_227]));
	                _222[_227] = _1084 - (_1178 * dot(_1084 - _255[_227], _1178));
	                _227++;
	                continue;
	            }
	            vec3 _1202 = ((_222[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_222[1] * attrs.barycentrics.x)) + (_222[2] * attrs.barycentrics.y);
	            _224 = dot(_1202 - _1084, _1068);
	            _225 = _1202;
	            break;
	        } while(false);
	        if (_1140_ladder_break)
	        {
	            break;
	        }
	        _226++;
	        continue;
	    }
	    if (!(_224 > 0.00999999977648258209228515625))
	    {
	        _225 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _225;
	    if (any(notEqual(_225, vec3(3.4028234663852885981170418348452e+38))))
	    {
	        payload.vSmoothPositionWs = gl_ObjectToWorldEXT * vec4(payload.vSmoothPositionWs.xyz, 1.0);
	    }
	    payload.material.vAlbedo = f16vec3(_221);
	    if (_220 >= 0)
	    {
	        payload.material.vAlbedo = f16vec3(textureLod(sampler2D(g_bindless_Texture2D[uint(_220)], g_Sampler), ((_211 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_210 * attrs.barycentrics.x)) + (_209 * attrs.barycentrics.y), 0.0).xyz);
	    }
	    payload.material.vAlbedo *= f16vec3(_965.xyz);
	    payload.nInstance = int(uint(gl_InstanceID));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
