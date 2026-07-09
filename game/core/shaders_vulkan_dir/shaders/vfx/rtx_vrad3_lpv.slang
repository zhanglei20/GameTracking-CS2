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
	StaticCombo( S_EXECUTION_REORDERING, 0..1 );
	DynamicCombo( D_LPV_PASS, 0..1 );
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (10644 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	layout(set = 6, binding = 159, std430) buffer RWStructuredBuffer
	{
	    uint _member0[];
	} g_SolidMask;
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
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
	    layout(row_major) mat4x3 m_mLpvLocalToWorld;
	} g_PushConstants;
	
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	
	void main()
	{
	    do
	    {
	        int nIdx = int((gl_LaunchSizeEXT.x * ((gl_LaunchIDEXT.z * gl_LaunchSizeEXT.y) + gl_LaunchIDEXT.y)) + gl_LaunchIDEXT.x);
	        vec3 _174 = g_PushConstants.m_mLpvLocalToWorld * vec4((((g_PushConstants.m_vLpvMaxBounds.xyz - g_PushConstants.m_vLpvMinBounds.xyz) / vec3(gl_LaunchSizeEXT)) * (vec3(ivec3(gl_LaunchIDEXT)) + g_PushConstants.m_vOffset.xyz)) + g_PushConstants.m_vLpvMinBounds.xyz, 1.0);
	        uint nFlags;
	        if (g_PushConstants.m_nEstimate > 0)
	        {
	            nFlags = g_SolidMask._member0[nIdx];
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
	        vec3 _128;
	        float _135;
	        bool _136;
	        bool _137;
	        float _138;
	        SPIRV_CROSS_UNROLL
	        for (;;)
	        {
	            if (!(i < 32))
	            {
	                break;
	            }
	            uint _200 = uint(i);
	            uint _205 = (_200 << 16u) | (_200 >> 16u);
	            uint _210 = ((_205 & 1431655765u) << 1u) | ((_205 & 2863311530u) >> 1u);
	            uint _215 = ((_210 & 858993459u) << 2u) | ((_210 & 3435973836u) >> 2u);
	            uint _220 = ((_215 & 252645135u) << 4u) | ((_215 & 4042322160u) >> 4u);
	            vec2 _228 = vec2(float(_200) * 0.03125, float(((_220 & 16711935u) << 8u) | ((_220 & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
	            float _229 = _228.y;
	            float _234 = 2.0 * sqrt(max(0.0, _229 - (_229 * _229)));
	            float _236 = 6.283185482025146484375 * _228.x;
	            vec3 _243 = vec3(cos(_236) * _234, sin(_236) * _234, 1.0 - (2.0 * _229));
	            vec3 _127 = _174.xyz;
	            float _126 = 0.0;
	            vec3 _125 = _243;
	            if (bValidSample)
	            {
	                _138 = 56755.83984375;
	            }
	            else
	            {
	                _138 = 0.0;
	            }
	            f16vec3 _250 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _128, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_250, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _250, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 0u, 16u, 0u, 2u, 0u, _127, _126, _125, _138, 0);
	            vec3 _124 = _127;
	            vec3 _123 = _125;
	            vec3 _122 = p.vSmoothPositionWs;
	            vec3 _121 = p.vFaceNormalWs;
	            float _120 = p.flHitT;
	            int _119 = p.nInstance;
	            f16vec3 _118 = p.material.vNormalWs;
	            do
	            {
	                if (!(_119 != (-1)))
	                {
	                    _137 = false;
	                    break;
	                }
	                vec3 _130 = (_124 + (_123 * _120)) + (_121 * ((abs(_124) + vec3(abs(_120))) * 9.9999997473787516355514526367188e-05));
	                vec3 _129 = _121;
	                if (bValidSample)
	                {
	                    _136 = any(notEqual(_122, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _136 = false;
	                }
	                vec3 _302 = _122 - _130;
	                float _303 = length(_302);
	                vec3 _133 = _130;
	                float _132 = 0.0;
	                vec3 _131 = vec4(_302 / vec3(_303), _303).xyz;
	                if (_136)
	                {
	                    _135 = _303;
	                }
	                else
	                {
	                    _135 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _133, _132, _131, _135, 1);
	                if (_136)
	                {
	                    _135 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _135 = 0.0;
	                }
	                if (_135 == 1.0)
	                {
	                    _130 = _122;
	                    _129 = vec3(_118);
	                }
	                uint _330 = uint(_119);
	                PackedRtxInstanceData_t_natural_logical _333;
	                _333.nSrgbColor = g_instanceBuffer._member0[_330].nSrgbColor;
	                _333.nTriangleGeometry = g_instanceBuffer._member0[_330].nTriangleGeometry;
	                _333.nMaterialData = g_instanceBuffer._member0[_330].nMaterialData;
	                _333.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[_330].nMaterialFlags_nInstanceFlags;
	                _333.fEmissiveBoost = g_instanceBuffer._member0[_330].fEmissiveBoost;
	                _333.nInstanceFlags = g_instanceBuffer._member0[_330].nInstanceFlags;
	                _333._pad1 = g_instanceBuffer._member0[_330]._pad1;
	                _333._pad2 = g_instanceBuffer._member0[_330]._pad2;
	                uint _134 = _333.nMaterialFlags_nInstanceFlags;
	                if ((int((_134 >> uint(16)) & 65535u) & 1) != 0)
	                {
	                    _137 = false;
	                    break;
	                }
	                if ((int(_134 & 65535u) & 2048) != 0)
	                {
	                    _137 = false;
	                    break;
	                }
	                _137 = dot(_243, _129) > 0.0;
	                break;
	            } while(false);
	            if (_137)
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
	        g_SolidMask._member0[nIdx] = nFlags;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
