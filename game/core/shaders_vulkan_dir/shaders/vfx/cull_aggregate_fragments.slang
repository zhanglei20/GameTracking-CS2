//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Culls aggregate fragments and generates indirect draw args";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: cs
}

MODES
{
	Default();
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

CS
{
	StaticCombo( S_SUBGROUP_WAVE_OPS, 0..1 );
	StaticCombo( S_REVERSE_DEPTH_BUFFER, 0..1 );
	StaticCombo( S_SUPPORTS_DX_11_1, 0, Sys( 13 ) );
	DynamicCombo( D_PASS, 0..3 );
	DynamicCombo( D_OCCLUSION_CULLING, 0..1 );
	DynamicCombo( D_VOLUME_CULLER, 0..1 );
	DynamicCombo( D_VIS_CULLING, 0..1 );
	DynamicCombo( D_SUPPORTS_MESH_SHADER, 0..1 );
	DynamicCombo( D_DEBUG_OUTPUT_STATS, 0..1 );
	DynamicCombo( D_DEBUG_DRAW_MESHLETS, 0..1 );
	
	cbuffer GpuVolumeCullerPlanes_t < Attribute("GpuVolumeCullerPlanes_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_CullRequests < Attribute("CullRequests"); SrgbRead(false); >;
	RWStructuredBuffer g_CullStats < Attribute("FragmentStats"); >;
	RWBuffer<float4> g_DebugMeshletDrawArgs < Attribute("DebugMeshletDrawArgs"); >;
	RWBuffer<float4> g_DrawArgs < Attribute("FragmentDrawArgs"); >;
	StructuredBuffer g_FragmentData < Attribute("FragmentBounds"); SrgbRead(false); >;
	ByteAddressBuffer g_InputIndices < Attribute("InputIndices"); SrgbRead(false); >;
	RWStructuredBuffer g_MSIndirectDispatchArgs < Attribute("MSIndirectDispatchArgs"); >;
	RWStructuredBuffer g_MSIndirectDispatchArgsRecull < Attribute("MSIndirectDispatchArgsRecull"); >;
	StructuredBuffer g_MeshletData < Attribute("MeshletData"); SrgbRead(false); >;
	RWByteAddressBuffer g_OutputIndices < Attribute("OutputIndices"); >;
	RWStructuredBuffer g_RWMeshletBuffer < Source(ExternalDescSet); >;
	RWBuffer<float4> g_RecullDispatchArgs < Attribute("RecullDispatchArgs"); >;
	RWBuffer<float4> g_RecullDrawArgs < Attribute("FragmentRecullDrawArgs"); >;
	Buffer g_RecullRequestCount < Attribute("RecullRequestCount"); SrgbRead(false); >;
	RWBuffer<float4> g_RecullRequestCount < Attribute("RecullRequestCount"); >;
	RWStructuredBuffer g_RecullRequests < Attribute("RecullRequests"); >;
	Buffer g_VisBits < Attribute("VisBits"); SrgbRead(false); >;
	bool g_bBackfaceCulling < Attribute("BackfaceCulling"); UiType(CheckBox); >;
	bool g_bDrawAllMeshlets < Attribute("DebugDrawAllMeshlets"); UiType(CheckBox); >;
	bool g_bOrthographicView < Attribute("OrthographicView"); UiType(CheckBox); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	float4x4 g_mDepthPyramidProjFromWorld < Attribute("DepthPyramidProjFromWorld"); >;
	int g_nCullRequests < Attribute("NumCullRequests"); UiType(Slider); >;
	int g_nDepthPyramidHeight < Attribute("DepthPyramidHeight"); UiType(Slider); >;
	int g_nDepthPyramidMaxMip < Attribute("DepthPyramidMaxMip"); UiType(Slider); >;
	int g_nDepthPyramidWidth < Attribute("DepthPyramidWidth"); UiType(Slider); >;
	int g_nNumAggregates < Attribute("NumAggregates"); UiType(Slider); >;
	int g_nNumFragments < Attribute("NumFragments"); UiType(Slider); >;
	Texture2D g_tDepthPyramid < Attribute("DepthPyramid"); SrgbRead(false); >;
	float3 g_vCullCameraForwardWs < Attribute("CullCameraForwardWs"); UiType(VectorText); >;
	float3 g_vCullCameraPositionWs < Attribute("CullCameraPositionWs"); UiType(VectorText); >;
	float3 g_vDepthPyramidCameraOffset < Attribute("DepthPyramidCameraOffset"); UiType(VectorText); >;
	float2 g_vDepthPyramidSize < Attribute("DepthPyramidSize"); UiType(VectorText); >;
	float4 g_vFrustumPlane0 < Attribute("FrustumPlane0"); UiType(VectorText); >;
	float4 g_vFrustumPlane1 < Attribute("FrustumPlane1"); UiType(VectorText); >;
	float4 g_vFrustumPlane2 < Attribute("FrustumPlane2"); UiType(VectorText); >;
	float4 g_vFrustumPlane3 < Attribute("FrustumPlane3"); UiType(VectorText); >;
	float4 g_vFrustumPlane4 < Attribute("FrustumPlane4"); UiType(VectorText); >;
	float4 g_vFrustumPlane5 < Attribute("FrustumPlane5"); UiType(VectorText); >;
	
	#if (S_SUPPORTS_DX_11_1 == 0)
		Buffer g_RecullRequestCount < Attribute("RecullRequestCount"); SrgbRead(false); >;
		RWBuffer<float4> g_RecullRequestCount < Attribute("RecullRequestCount"); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vCullCameraPositionWs) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (8960 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
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
	layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;
	
	struct _1017
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	};
	
	struct _1107
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	};
	
	struct _1095
	{
	    vec3 _m0;
	    uint _m1;
	    vec3 _m2;
	    uint _m3;
	};
	
	struct _1996
	{
	    vec3 g_vCullCameraForwardWs;
	    vec3 g_vCullCameraPositionWs;
	    vec4 g_vFrustumPlane0;
	    vec4 g_vFrustumPlane1;
	    vec4 g_vFrustumPlane2;
	    vec4 g_vFrustumPlane3;
	    vec4 g_vFrustumPlane4;
	    vec4 g_vFrustumPlane5;
	    uint g_nCullRequests;
	    int g_bBackfaceCulling;
	    int g_bOrthographicView;
	};
	
	layout(set = 0) uniform _1996 _Globals_;
	
	layout(set = 0, binding = 35, std430) readonly buffer g_CullRequests
	{
	    _1017 _m0[];
	} g_CullRequests_1;
	
	layout(set = 0, binding = 34, std430) readonly buffer g_MeshletData
	{
	    _1107 _m0[];
	} g_MeshletData_1;
	
	layout(set = 0, binding = 33, std430) readonly buffer g_FragmentData
	{
	    _1095 _m0[];
	} g_FragmentData_1;
	
	layout(set = 0, binding = 36, std430) readonly buffer g_InputIndices
	{
	    uint _m0[];
	} g_InputIndices_1;
	
	layout(set = 0, binding = 165, std430) buffer undetermined
	{
	    uint _m0[];
	} undetermined_1;
	
	layout(set = 0, binding = 159, r32ui) uniform uimageBuffer _4767;
	
	void main()
	{
	    if (gl_GlobalInvocationID.x < _Globals_.g_nCullRequests)
	    {
	        uint _8600 = g_CullRequests_1._m0[gl_GlobalInvocationID.x]._m0;
	        uint _23745 = g_MeshletData_1._m0[_8600]._m0;
	        uint _4523 = (_23745 >> uint(7)) & 127u;
	        uint _5882 = _4523 + (_4523 & 1u);
	        uint _13328 = g_MeshletData_1._m0[_8600]._m7;
	        uint _5395 = _13328 & 16777215u;
	        vec3 _10538 = mix(g_FragmentData_1._m0[_5395]._m0.xyz, g_FragmentData_1._m0[_5395]._m2.xyz, vec3(float((g_MeshletData_1._m0[_8600]._m4) & 1023u) * 0.000977517105638980865478515625, float((g_MeshletData_1._m0[_8600]._m4 >> uint(10)) & 1023u) * 0.000977517105638980865478515625, float((g_MeshletData_1._m0[_8600]._m4 >> uint(20)) & 1023u) * 0.000977517105638980865478515625));
	        vec3 _23228 = mix(g_FragmentData_1._m0[_5395]._m0.xyz, g_FragmentData_1._m0[_5395]._m2.xyz, vec3(float((g_MeshletData_1._m0[_8600]._m5) & 1023u) * 0.000977517105638980865478515625, float((g_MeshletData_1._m0[_8600]._m5 >> uint(10)) & 1023u) * 0.000977517105638980865478515625, float((g_MeshletData_1._m0[_8600]._m5 >> uint(20)) & 1023u) * 0.000977517105638980865478515625));
	        uint _24909 = g_MeshletData_1._m0[_8600]._m1;
	        uint _13546 = g_FragmentData_1._m0[_5395]._m1;
	        uint _17363 = g_CullRequests_1._m0[gl_GlobalInvocationID.x]._m2;
	        vec4 _20578[6] = vec4[](_Globals_.g_vFrustumPlane0, _Globals_.g_vFrustumPlane1, _Globals_.g_vFrustumPlane2, _Globals_.g_vFrustumPlane3, _Globals_.g_vFrustumPlane4, _Globals_.g_vFrustumPlane5);
	        float _13155;
	        _13155 = 100000000.0;
	        float _6414;
	        int _8899;
	        int _16208 = 0;
	        for (;;)
	        {
	            if (!(_16208 < 6))
	            {
	                break;
	            }
	            _6414 = min(_13155, dot(mix(_10538, _23228, greaterThan(_20578[_16208].xyz, vec3(0.0))), _20578[_16208].xyz) + _20578[_16208].w);
	            _8899 = _16208 + 1;
	            _13155 = _6414;
	            _16208 = _8899;
	            continue;
	        }
	        bool _9364 = (_13155 < 0.0) ? false : true;
	        bool _12885;
	        if (_Globals_.g_bBackfaceCulling != 0)
	        {
	            bool _24742;
	            do
	            {
	                vec3 _10254 = vec3(float(int(((g_MeshletData_1._m0[_8600]._m3) & 255u) << uint(24)) >> 24) * 0.0078740157186985015869140625, float(int(((g_MeshletData_1._m0[_8600]._m3 >> uint(8)) & 255u) << uint(24)) >> 24) * 0.0078740157186985015869140625, float(int(((g_MeshletData_1._m0[_8600]._m3 >> uint(16)) & 255u) << uint(24)) >> 24) * 0.0078740157186985015869140625);
	                float _15712 = float(int(((g_MeshletData_1._m0[_8600]._m3 >> uint(24)) & 255u) << uint(24)) >> 24) * 0.0078740157186985015869140625;
	                if (_Globals_.g_bOrthographicView != 0)
	                {
	                    _24742 = dot(_Globals_.g_vCullCameraForwardWs.xyz, _10254) > _15712;
	                    break;
	                }
	                else
	                {
	                    vec3 _16593 = ((_10538 + _23228) * 0.5) - _Globals_.g_vCullCameraPositionWs.xyz;
	                    _24742 = dot(_16593, _10254) > ((_15712 * length(_16593)) + (length(_23228 - _10538) * 0.5));
	                    break;
	                }
	                break; // unreachable workaround
	            } while(false);
	            _12885 = _24742 ? false : _9364;
	        }
	        else
	        {
	            _12885 = _9364;
	        }
	        if (_12885)
	        {
	            uint _18763 = imageAtomicAdd(_4767, int(g_CullRequests_1._m0[gl_GlobalInvocationID.x]._m1 * 5u), _5882 * 3u);
	            uint _14025 = _5882 * 6u;
	            uint _16134 = _14025 / 128u;
	            uint _10045 = (_14025 % 128u) / 16u;
	            uint _11906 = (_14025 % 16u) / 4u;
	            uint _13136;
	            uint _16324;
	            _13136 = (_18763 + _17363) * 2u;
	            _16324 = (_24909 + _13546) * 2u;
	            uint _14167;
	            uint _16273;
	            uint _21149;
	            uint _17017 = 0u;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_17017 < _16134))
	                {
	                    break;
	                }
	                uint _23262;
	                uint _13039 = 0u;
	                SPIRV_CROSS_UNROLL
	                for (;;)
	                {
	                    if (!(_13039 < 8u))
	                    {
	                        break;
	                    }
	                    uint _9984 = _13039 * 16u;
	                    uint _23357 = _16324 + _9984;
	                    uint _6234 = g_InputIndices_1._m0[(_23357 + 4u) / 4u];
	                    uint _6235 = g_InputIndices_1._m0[(_23357 + 8u) / 4u];
	                    uint _6236 = g_InputIndices_1._m0[(_23357 + 12u) / 4u];
	                    uint _20861 = _13136 + _9984;
	                    undetermined_1._m0[_20861 / 4u] = g_InputIndices_1._m0[_23357 / 4u];
	                    undetermined_1._m0[(_20861 + 4u) / 4u] = _6234;
	                    undetermined_1._m0[(_20861 + 8u) / 4u] = _6235;
	                    undetermined_1._m0[(_20861 + 12u) / 4u] = _6236;
	                    _23262 = _13039 + 1u;
	                    _13039 = _23262;
	                    continue;
	                }
	                _21149 = _16324 + 128u;
	                _16273 = _13136 + 128u;
	                _14167 = _17017 + 1u;
	                _13136 = _16273;
	                _16324 = _21149;
	                _17017 = _14167;
	                continue;
	            }
	            uint _13137;
	            uint _16325;
	            _13137 = _16324;
	            _16325 = _13136;
	            uint _8018;
	            uint _14168;
	            uint _22844;
	            uint _17018 = 0u;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_17018 < _10045))
	                {
	                    break;
	                }
	                uint _6238 = g_InputIndices_1._m0[(_13137 + 4u) / 4u];
	                uint _6239 = g_InputIndices_1._m0[(_13137 + 8u) / 4u];
	                uint _22955 = g_InputIndices_1._m0[(_13137 + 12u) / 4u];
	                undetermined_1._m0[_16325 / 4u] = g_InputIndices_1._m0[_13137 / 4u];
	                undetermined_1._m0[(_16325 + 4u) / 4u] = _6238;
	                undetermined_1._m0[(_16325 + 8u) / 4u] = _6239;
	                undetermined_1._m0[(_16325 + 12u) / 4u] = _22955;
	                _22844 = _13137 + 16u;
	                _8018 = _16325 + 16u;
	                _14168 = _17018 + 1u;
	                _13137 = _22844;
	                _16325 = _8018;
	                _17018 = _14168;
	                continue;
	            }
	            uint _8019;
	            uint _14169;
	            uint _22845;
	            uint _13138 = _16325;
	            uint _16326 = _13137;
	            uint _17019 = 0u;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_17019 < _11906))
	                {
	                    break;
	                }
	                undetermined_1._m0[_13138 / 4u] = g_InputIndices_1._m0[uint(int(_16326)) / 4u];
	                _22845 = _16326 + 4u;
	                _8019 = _13138 + 4u;
	                _14169 = _17019 + 1u;
	                _13138 = _8019;
	                _16326 = _22845;
	                _17019 = _14169;
	                continue;
	            }
	        }
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	
}
