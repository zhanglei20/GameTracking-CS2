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
	StaticCombo( S_EXECUTION_REORDERING, 0..1 );
	DynamicCombo( D_LPV_PASS, 0..1 );
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (10448 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	#extension GL_KHR_shader_subgroup_vote : require
	#if defined(GL_EXT_control_flow_attributes)
	#extension GL_EXT_control_flow_attributes : require
	#define SPIRV_CROSS_FLATTEN [[flatten]]
	#define SPIRV_CROSS_BRANCH [[dont_flatten]]
	#define SPIRV_CROSS_UNROLL [[unroll]]
	#define SPIRV_CROSS_LOOP [[dont_unroll]]
	#else
	#define SPIRV_CROSS_FLATTEN
	#define SPIRV_CROSS_BRANCH
	#define SPIRV_CROSS_UNROLL
	#define SPIRV_CROSS_LOOP
	#endif
	
	struct _MatrixStorage_float4x3_ColMajornatural
	{
	    vec4 data[3];
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
	
	layout(set = 6, binding = 159, std430) buffer RWStructuredBuffer
	{
	    uint _m0[];
	} g_SolidMask;
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _m0[];
	} g_instanceBuffer;
	
	layout(push_constant, std430) uniform LpvPushConstants_t_natural
	{
	    int m_nEstimate;
	    int m_nDimensionCount;
	    int m_nFilterRadius;
	    int m_nFog;
	    uvec4 m_vPackedCellStartAndCount;
	    vec4 m_vOffset;
	    vec4 m_vLpvMinBounds;
	    vec4 m_vLpvMaxBounds;
	    _MatrixStorage_float4x3_ColMajornatural m_mLpvLocalToWorld;
	} g_PushConstants;
	
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	
	void main()
	{
	    do
	    {
	        ivec3 _134 = ivec3(gl_LaunchIDEXT);
	        uvec3 _145 = uvec3(_134);
	        int nIdx = int((gl_LaunchSizeEXT.x * ((_145.z * gl_LaunchSizeEXT.y) + _145.y)) + _145.x);
	        vec3 _188 = mat4x3(vec3(g_PushConstants.m_mLpvLocalToWorld.data[0].x, g_PushConstants.m_mLpvLocalToWorld.data[1].x, g_PushConstants.m_mLpvLocalToWorld.data[2].x), vec3(g_PushConstants.m_mLpvLocalToWorld.data[0].y, g_PushConstants.m_mLpvLocalToWorld.data[1].y, g_PushConstants.m_mLpvLocalToWorld.data[2].y), vec3(g_PushConstants.m_mLpvLocalToWorld.data[0].z, g_PushConstants.m_mLpvLocalToWorld.data[1].z, g_PushConstants.m_mLpvLocalToWorld.data[2].z), vec3(g_PushConstants.m_mLpvLocalToWorld.data[0].w, g_PushConstants.m_mLpvLocalToWorld.data[1].w, g_PushConstants.m_mLpvLocalToWorld.data[2].w)) * vec4((((g_PushConstants.m_vLpvMaxBounds.xyz - g_PushConstants.m_vLpvMinBounds.xyz) / vec3(gl_LaunchSizeEXT)) * (vec3(_134) + g_PushConstants.m_vOffset.xyz)) + g_PushConstants.m_vLpvMinBounds.xyz, 1.0);
	        uint nFlags;
	        if (g_PushConstants.m_nEstimate > 0)
	        {
	            nFlags = g_SolidMask._m0[nIdx];
	        }
	        else
	        {
	            nFlags = 0u;
	        }
	        bool bValidSample_2 = (nFlags & 1u) == 0u;
	        if (subgroupAll(!bValidSample_2))
	        {
	            break;
	        }
	        bool bValidSample = bValidSample_2;
	        int i = 0;
	        int nBackfacesSeen = 0;
	        bool bValidSample_1;
	        vec3 _121;
	        float _127;
	        bool _128;
	        bool _129;
	        float _130;
	        SPIRV_CROSS_UNROLL
	        for (;;)
	        {
	            if (!(i < 32))
	            {
	                break;
	            }
	            uint _214 = uint(i);
	            uint _219 = (_214 << 16u) | (_214 >> 16u);
	            uint _224 = ((_219 & 1431655765u) << 1u) | ((_219 & 2863311530u) >> 1u);
	            uint _229 = ((_224 & 858993459u) << 2u) | ((_224 & 3435973836u) >> 2u);
	            uint _234 = ((_229 & 252645135u) << 4u) | ((_229 & 4042322160u) >> 4u);
	            vec2 _242 = vec2(float(_214) * 0.03125, float(((_234 & 16711935u) << 8u) | ((_234 & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
	            float _243 = _242.y;
	            float _248 = 2.0 * sqrt(max(0.0, _243 - (_243 * _243)));
	            float _250 = 6.283185482025146484375 * _242.x;
	            vec3 _257 = vec3(cos(_250) * _248, sin(_250) * _248, 1.0 - (2.0 * _243));
	            vec3 _120 = _188.xyz;
	            float _119 = 0.0;
	            vec3 _118 = _257;
	            if (bValidSample)
	            {
	                _130 = 56755.83984375;
	            }
	            else
	            {
	                _130 = 0.0;
	            }
	            f16vec3 _264 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _121, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_264, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _264, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 0u, 16u, 0u, 2u, 0u, _120, _119, _118, _130, 0);
	            do
	            {
	                if (!(p._m5 != (-1)))
	                {
	                    _129 = false;
	                    break;
	                }
	                vec3 _123 = (_120 + (_118 * p._m3)) + (p._m1 * ((abs(_120) + vec3(abs(p._m3))) * 9.9999997473787516355514526367188e-05));
	                vec3 _122 = p._m1;
	                if (bValidSample)
	                {
	                    _128 = any(notEqual(p.material, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _128 = false;
	                }
	                vec3 _310 = p.material - _123;
	                float _311 = length(_310);
	                vec3 _126 = _123;
	                float _125 = 0.0;
	                vec3 _124 = vec4(_310 / vec3(_311), _311).xyz;
	                if (_128)
	                {
	                    _127 = _311;
	                }
	                else
	                {
	                    _127 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _126, _125, _124, _127, 1);
	                if (_128)
	                {
	                    _127 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _127 = 0.0;
	                }
	                if (_127 == 1.0)
	                {
	                    _123 = p.material;
	                    _122 = vec3(p._m7.vMaterialBits);
	                }
	                uint _338 = uint(p._m5);
	                if ((int((g_instanceBuffer._m0[_338].nMaterialFlags_nInstanceFlags >> uint(16)) & 65535u) & 1) != 0)
	                {
	                    _129 = false;
	                    break;
	                }
	                if ((int((g_instanceBuffer._m0[_338].nMaterialFlags_nInstanceFlags) & 65535u) & 2048) != 0)
	                {
	                    _129 = false;
	                    break;
	                }
	                _129 = dot(_257, _122) > 0.0;
	                break;
	            } while(false);
	            if (_129)
	            {
	                int nBackfacesSeen_1 = nBackfacesSeen + 1;
	                if (float(nBackfacesSeen_1) > 12.80000019073486328125)
	                {
	                    bValidSample_1 = false;
	                }
	                else
	                {
	                    bValidSample_1 = bValidSample;
	                }
	                bValidSample = bValidSample_1;
	                nBackfacesSeen = nBackfacesSeen_1;
	            }
	            i++;
	            continue;
	        }
	        if (!bValidSample)
	        {
	            nFlags |= 1u;
	        }
	        g_SolidMask._m0[nIdx] = nFlags;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
