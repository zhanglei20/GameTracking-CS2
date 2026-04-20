//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Culls instances of instanced meshes";
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
	DynamicCombo( D_OCCLUSION_CULLING, 0..1 );
	DynamicCombo( D_VOLUME_CULLER, 0..1 );
	DynamicCombo( D_PASS, 0..2 );
	DynamicCombo( D_HAS_ROOT_VIEW, 0..1 );
	DynamicCombo( D_LODS, 0..1 );
	DynamicCombo( D_VIS_CULLING, 0..1 );
	DynamicCombo( D_VISUALIZE_SCENEOBJECTS, 0..1 );
	DynamicCombo( D_CULL_NON_MOVING_OBJECTS, 0..1 );
	DynamicCombo( D_SUPPORTS_MESH_SHADER, 0..1 );
	DynamicCombo( D_DEBUG_DRAW_MESHLETS, 0..1 );
	DynamicCombo( D_DEBUG_OUTPUT_STATS, 0..1 );
	DynamicComboRule( Allow1( D_LODS, D_SUPPORTS_MESH_SHADER ) );
	DynamicComboRule( Requires( D_PASS, D_SUPPORTS_MESH_SHADER ) );
	DynamicComboRule( Requires( D_SUPPORTS_MESH_SHADER, S_SUBGROUP_WAVE_OPS ) );
	DynamicComboRule( Requires( D_DEBUG_DRAW_MESHLETS, D_SUPPORTS_MESH_SHADER ) );
	
	cbuffer GpuVolumeCullerPlanes_t < Attribute("GpuVolumeCullerPlanes_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_CullRequests < Attribute("CullRequests"); SrgbRead(false); >;
	RWStructuredBuffer g_CullRequests < Attribute("CullRequests"); >;
	RWStructuredBuffer g_CullStats < Attribute("CullStats"); >;
	ByteAddressBuffer g_InstanceData < Attribute("InstanceData"); SrgbRead(false); >;
	RWBuffer<float4> g_InstancedDrawArgs < Attribute("IndirectDrawBuffer"); >;
	RWStructuredBuffer g_MSIndirectDispatchArgs < Attribute("MSIndirectDispatchArgs"); >;
	RWStructuredBuffer g_MSIndirectDispatchArgsDebug < Attribute("MSIndirectDispatchArgsDebug"); >;
	RWStructuredBuffer g_MSIndirectDispatchArgsRecull < Attribute("MSIndirectDispatchArgsRecull"); >;
	StructuredBuffer g_MeshData < Attribute("MeshData"); SrgbRead(false); >;
	StructuredBuffer g_MeshletData < Attribute("MeshletData"); SrgbRead(false); >;
	RWStructuredBuffer g_RWInstanceBuffer < Attribute("InstanceBuffer"); >;
	RWStructuredBuffer g_RWMeshletBuffer < Source(ExternalDescSet); >;
	RWStructuredBuffer g_RWTransformBuffer < Attribute("TransformBuffer"); >;
	Buffer g_VisBits < Attribute("VisBits"); SrgbRead(false); >;
	StructuredBuffer g_VisNodes < Attribute("VisNodes"); SrgbRead(false); >;
	bool g_bCullViewOrthographic < Attribute("CullViewIsOrthographic"); UiType(CheckBox); >;
	bool g_bEnableDensityCulling < Attribute("g_bEnableDensityCulling"); UiType(CheckBox); >;
	bool g_bEnableFrustumCulling < Attribute("g_bEnableFrustumCulling"); UiType(CheckBox); >;
	bool g_bEnableSizeCulling < Attribute("g_bEnableSizeCulling"); UiType(CheckBox); >;
	bool g_bRootViewOrthographic < Attribute("RootViewIsOrthographic"); UiType(CheckBox); >;
	float g_fCullViewSizeThreshold < Attribute("CullViewSizeThreshold"); UiType(Slider); >;
	float g_fCullViewTanHalfFov < Attribute("CullViewTanHalfFov"); UiType(Slider); >;
	float g_fRootViewOrthoInvWidth < Attribute("RootViewOrthoInvWidth"); UiType(Slider); >;
	float g_fRootViewSizeThreshold < Attribute("RootViewSizeThreshold"); UiType(Slider); >;
	float g_fRootViewTanHalfFov < Attribute("RootViewTanHalfFov"); UiType(Slider); >;
	float g_fScreenSizeScaleForLOD < Attribute("ScreenSizeScaleForLOD"); UiType(Slider); >;
	float g_fScreenWidthForLOD < Attribute("ScreenWidthForLOD"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	float4x4 g_mDepthPyramidProjFromWorld < Attribute("DepthPyramidProjFromWorld"); >;
	int g_nCullRequests < Attribute("NumCullRequests"); UiType(Slider); >;
	int g_nDebugVisualizeDispatchIndex < Attribute("DebugVisualizeDispatchIndex"); UiType(Slider); >;
	int g_nDepthPyramidHeight < Attribute("DepthPyramidHeight"); UiType(Slider); >;
	int g_nDepthPyramidMaxMip < Attribute("DepthPyramidMaxMip"); UiType(Slider); >;
	int g_nDepthPyramidWidth < Attribute("DepthPyramidWidth"); UiType(Slider); >;
	int g_nFirstCullRequest < Attribute("FirstCullRequest"); UiType(Slider); >;
	int g_nRootLODLevel < Attribute("RootLODLevel"); UiType(Slider); >;
	int g_nTreeTraversalSeed < Attribute("VisTreeTraversalSeed"); UiType(Slider); >;
	int g_nVisInternalTreeExtent < Attribute("VisInternalTreeExtent"); UiType(Slider); >;
	int g_nVisualizeSceneObjectsMode < Attribute("VisualizeSceneObjectsMode"); UiType(Slider); >;
	StructuredBuffer g_prevFrameTransformBuffer < Attribute("PrevFrameTransformBuffer"); SrgbRead(false); >;
	Texture2D g_tDepthPyramid < Attribute("DepthPyramid"); SrgbRead(false); >;
	float3 g_vCullViewOrigin < Attribute("CullViewOrigin"); UiType(VectorText); >;
	float3 g_vDepthPyramidCameraOffset < Attribute("DepthPyramidCameraOffset"); UiType(VectorText); >;
	float2 g_vDepthPyramidSize < Attribute("DepthPyramidSize"); UiType(VectorText); >;
	float4 g_vFrustumPlane0 < Attribute("FrustumPlane0"); UiType(VectorText); >;
	float4 g_vFrustumPlane1 < Attribute("FrustumPlane1"); UiType(VectorText); >;
	float4 g_vFrustumPlane2 < Attribute("FrustumPlane2"); UiType(VectorText); >;
	float4 g_vFrustumPlane3 < Attribute("FrustumPlane3"); UiType(VectorText); >;
	float4 g_vFrustumPlane4 < Attribute("FrustumPlane4"); UiType(VectorText); >;
	float4 g_vFrustumPlane5 < Attribute("FrustumPlane5"); UiType(VectorText); >;
	float3 g_vRootViewOrigin < Attribute("RootViewOrigin"); UiType(VectorText); >;
	float4 g_vVisLocalOrigin_Scale < Attribute("VisLocalOrigin_Scale"); UiType(VectorText); >;
	
	#if (S_SUBGROUP_WAVE_OPS == 0)
		StructuredBuffer g_CullRequests < Attribute("CullRequests"); SrgbRead(false); >;
	#endif
	#if (S_SUBGROUP_WAVE_OPS == 1)
		StructuredBuffer g_CullRequests < Attribute("CullRequests"); SrgbRead(false); >;
		RWStructuredBuffer g_CullRequests < Attribute("CullRequests"); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vFrustumPlane0) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (14036 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	layout(local_size_x = 192, local_size_y = 1, local_size_z = 1) in;
	
	struct _2541
	{
	    uint _m0[8];
	};
	
	struct _2356
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    int _m5;
	    uint _m6;
	    uint _m7;
	    _2541 _m8;
	};
	
	struct _491
	{
	    vec4 _m0[2];
	};
	
	struct _2206
	{
	    uvec4 _m0[2];
	};
	
	struct _2443
	{
	    _2541 _m0[8];
	};
	
	struct _1200
	{
	    vec3 _m0;
	    uint _m1;
	    vec3 _m2;
	    uint _m3;
	    _491 _m4;
	    _2206 _m5;
	    float _m6;
	    float _m7;
	    float _m8;
	    float _m9;
	    float _m10;
	    uint _m11;
	    uint _m12;
	    float _m13;
	    uvec4 _m14;
	    _2443 _m15;
	};
	
	struct _617
	{
	    vec4 _m0[3];
	};
	
	struct _2193
	{
	    _617 _m0;
	};
	
	struct _1125
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    float _m7;
	};
	
	struct _2251
	{
	    vec4 g_vFrustumPlane0;
	    vec4 g_vFrustumPlane1;
	    vec4 g_vFrustumPlane2;
	    vec4 g_vFrustumPlane3;
	    vec4 g_vFrustumPlane4;
	    vec4 g_vFrustumPlane5;
	    uint g_nCullRequests;
	    uint g_nFirstCullRequest;
	    int g_bEnableFrustumCulling;
	    int g_bEnableSizeCulling;
	    int g_bEnableDensityCulling;
	    float g_fRootViewOrthoInvWidth;
	    int g_bCullViewOrthographic;
	    vec3 g_vCullViewOrigin;
	    float g_fCullViewTanHalfFov;
	    float g_fCullViewSizeThreshold;
	};
	
	layout(set = 0) uniform _2251 _Globals_;
	
	layout(set = 0, binding = 36, std430) readonly buffer g_CullRequests
	{
	    _2356 _m0[];
	} g_CullRequests_1;
	
	layout(set = 0, binding = 35, std430) readonly buffer g_MeshData
	{
	    _1200 _m0[];
	} g_MeshData_1;
	
	layout(set = 4, binding = 167, std430) buffer undetermined
	{
	    _2193 _m0[];
	} undetermined_1;
	
	layout(set = 0, binding = 37, std430) readonly buffer g_InstanceData
	{
	    uint _m0[];
	} g_InstanceData_1;
	
	layout(set = 4, binding = 163, std430) buffer undetermined_2
	{
	    _1125 _m0[];
	} undetermined_3;
	
	layout(set = 0, binding = 159, r32ui) uniform uimageBuffer _5506;
	
	void main()
	{
	    if (gl_WorkGroupID.x < _Globals_.g_nCullRequests)
	    {
	        uint _13724 = gl_WorkGroupID.x + _Globals_.g_nFirstCullRequest;
	        uint _24369 = g_CullRequests_1._m0[_13724]._m2;
	        uint _24445 = g_CullRequests_1._m0[_13724]._m3;
	        uint _6493 = g_CullRequests_1._m0[_13724]._m0;
	        bool _3779 = (_6493 & 2147483648u) != 0u;
	        uint _7126 = g_CullRequests_1._m0[_13724]._m1;
	        uint _13546 = g_CullRequests_1._m0[_13724]._m4;
	        uint _5325 = _13546 + gl_LocalInvocationID.x;
	        uint _11578;
	        if (g_CullRequests_1._m0[_13724]._m5 == (-1))
	        {
	            _11578 = 4294967295u;
	        }
	        else
	        {
	            _11578 = uint(g_CullRequests_1._m0[_13724]._m5) + gl_LocalInvocationID.x;
	        }
	        uint _13076 = g_MeshData_1._m0[_24369]._m3;
	        int _10074;
	        float _11730;
	        if (gl_LocalInvocationID.x < (_6493 & 1073741823u))
	        {
	            float _10932;
	            mat3x4 _15345;
	            if (_3779)
	            {
	                uint _23357 = _24445 + (gl_LocalInvocationID.x * 24u);
	                vec4 _22004 = uintBitsToFloat(uvec4(g_InstanceData_1._m0[_23357 / 4u], g_InstanceData_1._m0[(_23357 + 4u) / 4u], g_InstanceData_1._m0[(_23357 + 8u) / 4u], g_InstanceData_1._m0[(_23357 + 12u) / 4u]));
	                uint _23043 = uint(int(_23357 + 16u)) / 4u;
	                float _5062 = _22004.w;
	                float _9551 = (float((g_InstanceData_1._m0[_23043]) & 2047u) * 0.00097703956998884677886962890625) - 1.0;
	                float _9552 = (float((g_InstanceData_1._m0[_23043] >> uint(11)) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _8154 = (float((g_InstanceData_1._m0[_23043] >> uint(21)) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                float _23665 = _9551 * _9551;
	                float _7156 = _9552 * _9552;
	                float _9141 = _8154 * _8154;
	                float _13552 = sqrt(1.0 - min(0.999998986721038818359375, (_23665 + _7156) + _9141)) * (((g_InstanceData_1._m0[_23043] & 2147483648u) != 0u) ? (-1.0) : 1.0);
	                float _20691 = 2.0 * _7156;
	                float _10559 = 2.0 * _9141;
	                float _10213 = 2.0 * _9551;
	                float _20716 = _10213 * _9552;
	                float _22675 = (2.0 * _8154) * _13552;
	                float _10214 = _10213 * _8154;
	                float _20640 = 2.0 * _9552;
	                float _22014 = _20640 * _13552;
	                float _23221 = 1.0 - (2.0 * _23665);
	                float _8562 = _20640 * _8154;
	                float _20055 = _10213 * _13552;
	                _10932 = _5062;
	                _15345 = mat3x4(vec4(vec3((1.0 - _20691) - _10559, _20716 - _22675, _10214 + _22014) * _5062, _22004.x), vec4(vec3(_20716 + _22675, _23221 - _10559, _8562 - _20055) * _5062, _22004.y), vec4(vec3(_10214 - _22014, _8562 + _20055, _23221 - _20691) * _5062, _22004.z));
	            }
	            else
	            {
	                _10932 = sqrt(max(dot(undetermined_1._m0[_5325]._m0._m0[0].xyz, undetermined_1._m0[_5325]._m0._m0[0].xyz), max(dot(undetermined_1._m0[_5325]._m0._m0[1].xyz, undetermined_1._m0[_5325]._m0._m0[1].xyz), dot(undetermined_1._m0[_5325]._m0._m0[2].xyz, undetermined_1._m0[_5325]._m0._m0[2].xyz))));
	                _15345 = mat3x4(undetermined_1._m0[_5325]._m0._m0[0], undetermined_1._m0[_5325]._m0._m0[1], undetermined_1._m0[_5325]._m0._m0[2]);
	            }
	            vec3 _6370 = (g_MeshData_1._m0[_24369]._m0 + g_MeshData_1._m0[_24369]._m2) * 0.5;
	            vec3 _17098 = g_MeshData_1._m0[_24369]._m2 - _6370;
	            vec3 _11242 = (vec4(_6370, 1.0) * _15345).xyz;
	            float _8996 = _17098.x;
	            float _15046 = _17098.y;
	            float _17230 = _17098.z;
	            vec3 _16697 = vec3((abs(_8996 * _15345[0].x) + abs(_15046 * _15345[0].y)) + abs(_17230 * _15345[0].z), (abs(_8996 * _15345[1].x) + abs(_15046 * _15345[1].y)) + abs(_17230 * _15345[1].z), (abs(_8996 * _15345[2].x) + abs(_15046 * _15345[2].y)) + abs(_17230 * _15345[2].z));
	            vec3 _11144 = _11242 - _16697;
	            vec3 _8008 = _11242 + _16697;
	            bool _12885;
	            if (_Globals_.g_bEnableFrustumCulling != 0)
	            {
	                vec4 _20198[6] = vec4[](_Globals_.g_vFrustumPlane0, _Globals_.g_vFrustumPlane1, _Globals_.g_vFrustumPlane2, _Globals_.g_vFrustumPlane3, _Globals_.g_vFrustumPlane4, _Globals_.g_vFrustumPlane5);
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
	                    _6414 = min(_13155, dot(mix(_11144, _8008, greaterThan(_20198[_16208].xyz, vec3(0.0))), _20198[_16208].xyz) + _20198[_16208].w);
	                    _8899 = _16208 + 1;
	                    _13155 = _6414;
	                    _16208 = _8899;
	                    continue;
	                }
	                _12885 = _13155 < 0.0;
	            }
	            else
	            {
	                _12885 = false;
	            }
	            float _13175;
	            int _16055;
	            if (_12885)
	            {
	                _13175 = 1.0;
	                _16055 = -1;
	            }
	            else
	            {
	                bool _10458;
	                float _11692;
	                do
	                {
	                    vec3 _11387 = (_11144 + _8008) * 0.5;
	                    float _20801 = _10932 * g_MeshData_1._m0[_24369]._m7;
	                    bool _12886;
	                    if (_Globals_.g_bEnableSizeCulling != 0)
	                    {
	                        bool _12501;
	                        do
	                        {
	                            float _20091;
	                            do
	                            {
	                                if (_Globals_.g_bCullViewOrthographic != 0)
	                                {
	                                    _20091 = (2.0 * _20801) * _Globals_.g_fRootViewOrthoInvWidth;
	                                    break;
	                                }
	                                else
	                                {
	                                    float _23997 = length(_11387 - _Globals_.g_vCullViewOrigin);
	                                    if (_23997 <= _20801)
	                                    {
	                                        _20091 = 1.0;
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        _20091 = clamp(_20801 / (_23997 * _Globals_.g_fCullViewTanHalfFov), 0.0, 1.0);
	                                        break;
	                                    }
	                                    break; // unreachable workaround
	                                }
	                                break; // unreachable workaround
	                            } while(false);
	                            if (_20091 < (_Globals_.g_fCullViewSizeThreshold * g_MeshData_1._m0[_24369]._m6))
	                            {
	                                _12501 = true;
	                                break;
	                            }
	                            _12501 = false;
	                            break;
	                        } while(false);
	                        _12886 = _12501;
	                    }
	                    else
	                    {
	                        _12886 = false;
	                    }
	                    if (_12886)
	                    {
	                        _11692 = 1.0;
	                        _10458 = true;
	                        break;
	                    }
	                    float _13174;
	                    bool _16054;
	                    if (_Globals_.g_bEnableDensityCulling != 0)
	                    {
	                        float _13212;
	                        bool _15670;
	                        do
	                        {
	                            if (g_MeshData_1._m0[_24369]._m8 > 0.0)
	                            {
	                                float _17253;
	                                do
	                                {
	                                    if (_Globals_.g_bCullViewOrthographic != 0)
	                                    {
	                                        _17253 = (2.0 * _20801) * _Globals_.g_fRootViewOrthoInvWidth;
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        float _23998 = length(_11387 - _Globals_.g_vCullViewOrigin);
	                                        if (_23998 <= _20801)
	                                        {
	                                            _17253 = 1.0;
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            _17253 = clamp(_20801 / (_23998 * _Globals_.g_fCullViewTanHalfFov), 0.0, 1.0);
	                                            break;
	                                        }
	                                        break; // unreachable workaround
	                                    }
	                                    break; // unreachable workaround
	                                } while(false);
	                                uint _12240 = gl_LocalInvocationID.x + (g_CullRequests_1._m0[_13724]._m7 & 65535u);
	                                uint _7414 = _12240 + 374761393u;
	                                uint _17451 = 668265263u * ((_7414 << uint(17)) | (_7414 >> uint(15)));
	                                uint _17202 = 2246822519u * (_17451 ^ (_17451 >> uint(15)));
	                                uint _17204 = 3266489917u * (_17202 ^ (_17202 >> uint(13)));
	                                float _17267 = _17253 + (((float(_17204 ^ (_17204 >> uint(16))) * 2.3283064365386962890625e-10) * (float(_12240) / float(g_CullRequests_1._m0[_13724]._m7 >> uint(16)))) * g_MeshData_1._m0[_24369]._m10);
	                                _13212 = min(1.0, (clamp((_17267 - g_MeshData_1._m0[_24369]._m8) / (g_MeshData_1._m0[_24369]._m9 - g_MeshData_1._m0[_24369]._m8), 0.0, 1.0) * (-1.0)) + 1.0);
	                                _15670 = _17267 < g_MeshData_1._m0[_24369]._m9;
	                                break;
	                            }
	                            _13212 = 1.0;
	                            _15670 = false;
	                            break;
	                        } while(false);
	                        _13174 = _13212;
	                        _16054 = _15670;
	                    }
	                    else
	                    {
	                        _13174 = 1.0;
	                        _16054 = false;
	                    }
	                    if (_16054)
	                    {
	                        _11692 = _13174;
	                        _10458 = true;
	                        break;
	                    }
	                    _11692 = _13174;
	                    _10458 = false;
	                    break;
	                } while(false);
	                _13175 = _11692;
	                _16055 = _10458 ? (-1) : 0;
	            }
	            bool _12887;
	            if (_3779)
	            {
	                _12887 = _16055 != (-1);
	            }
	            else
	            {
	                _12887 = false;
	            }
	            if (_12887)
	            {
	                undetermined_1._m0[_5325]._m0 = _617(vec4[](_15345[0], _15345[1], _15345[2]));
	            }
	            _11730 = _13175;
	            _10074 = _16055;
	        }
	        else
	        {
	            _11730 = 1.0;
	            _10074 = -1;
	        }
	        if (_10074 != (-1))
	        {
	            uint _21138 = g_MeshData_1._m0[_24369]._m12;
	            uint _9307 = (_21138 >> uint(_10074 * 4)) & 15u;
	            uint _8835 = _7126 + (uint(_10074) * (_13076 >> uint(16)));
	            uint _3737 = imageAtomicAdd(_5506, int((_8835 * 5u) + 1u), 1u);
	            uint _5186;
	            uint _13039 = 1u;
	            for (;;)
	            {
	                if (!(_13039 < _9307))
	                {
	                    break;
	                }
	                uint _17760 = imageAtomicAdd(_5506, int(((_8835 + _13039) * 5u) + 1u), 1u);
	                _5186 = _13039 + 1u;
	                _13039 = _5186;
	                continue;
	            }
	            uint _20652 = g_CullRequests_1._m0[_13724]._m6;
	            uint _3056 = _20652 + _3737;
	            uint _12699;
	            if (_3779)
	            {
	                _12699 = (_24445 + (gl_LocalInvocationID.x * 24u)) + 20u;
	            }
	            else
	            {
	                _12699 = _24445 + (gl_LocalInvocationID.x * 4u);
	            }
	            undetermined_3._m0[_3056]._m0 = g_InstanceData_1._m0[uint(int(_12699)) / 4u];
	            undetermined_3._m0[_3056]._m1 = _5325;
	            undetermined_3._m0[_3056]._m2 = uint(int(_11578));
	            undetermined_3._m0[_3056]._m3 = 4294967295u;
	            undetermined_3._m0[_3056]._m4 = 4294967295u;
	            undetermined_3._m0[_3056]._m5 = 0u;
	            undetermined_3._m0[_3056]._m6 = 0u;
	            undetermined_3._m0[_3056]._m7 = _11730;
	        }
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	
}
