//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Simple shader to use as a starting point for writing new shaders";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
	// Programs: gs, ps, vs
}

MODES
{
	Default();
	Depth(S_MODE_DEPTH);
	VrForward(S_VERY_SIMPLE_LIGHTING);
	DotaForward(S_VERY_SIMPLE_LIGHTING);
	CsgoForward(S_VERY_SIMPLE_LIGHTING);
	Forward();
	ToolsWireframe(S_MODE_TOOLS_WIREFRAME);
	ToolsVis(S_VERY_SIMPLE_LIGHTING);
	ToolsUtil(S_VERY_SIMPLE_LIGHTING);
}

FEATURES
{
	Feature( F_VERTEX_COLORS, 0..1, "" );
	Feature( F_DISABLE_DEPTHTEST, 0..1, "" );
	Feature( F_TRIANGLE_EDGES, 0..1, "" );
	Feature( F_WIREFRAME, 0..1, "" );
	Feature( F_TRANSLUCENT, 0..1, "" );
	FeatureRule( Allow1( F_TRIANGLE_EDGES, F_WIREFRAME ), "Triangle edges and wireframe a mutually exclusive." );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vColor       : COLOR0     < Semantic( Color ); >;                                       // S_VERTEX_COLORS=1
	float3 vPositionOs  : POSITION0  < Semantic( PosXyz ); >;                                     
	float2 nInstanceIdx : TEXCOORD13 < Semantic( InstanceTransformUv ); >;                        
};

VS
{
	StaticCombo( S_VERTEX_COLORS, F_VERTEX_COLORS );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicComboRule( Allow0( D_BLEND_WEIGHT_COUNT ) );
	
	// Color
	float g_flAlpha < Default(1); UiType(Slider); UiGroup("Color"); >;
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color"); >;
	
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// WireframeEmit
	float3 g_vWireframeEmit < UiType(Color); UiGroup("WireframeEmit"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vWireframeEmit) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3440 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
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
	
	struct _940
	{
	    vec4 _m0[3];
	};
	
	struct _2839
	{
	    _940 _m0;
	};
	
	layout(set = 0, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	struct _1075
	{
	    vec3 g_vColorTint;
	    vec3 g_vWireframeEmit;
	    float g_flAlpha;
	};
	
	layout(set = 0) uniform _1075 _Globals_;
	
	layout(set = 0, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _2839 _m0[];
	} g_transformBuffer_1;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in uint nInstanceIdx;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec3 output_2;
	
	void main()
	{
	    vec4 _23812 = vec4(uvec4((g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 255u), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 65280u) >> uint(8), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 16711680u) >> uint(16), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec3 _6253 = _23812.xyz;
	    vec3 _17828 = _6253 * vec3(0.077399380505084991455078125);
	    vec3 _7676 = pow((_6253 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _19302 = _17828.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    float _25150 = _23812.w;
	    output_0 = vec4(vPositionOs.xyz, 1.0) * mat3x4(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0._m0[0], g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0._m0[1], g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0._m0[2]);
	    output_1 = vec4(vec4(_21354, _21355, _19302, _25150).xyz * _Globals_.g_vColorTint.xyz, _25150 * _Globals_.g_flAlpha);
	    output_2 = _Globals_.g_vWireframeEmit;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

GS
{
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported shader stage.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2872 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	layout(triangles) in;
	layout(max_vertices = 3, triangle_strip) out;
	
	struct _1134
	{
	    vec3 _m0;
	    vec4 _m1;
	    vec3 _m2;
	};
	
	struct _239
	{
	    vec4 _m0[4];
	};
	
	struct _1500
	{
	    _239 _m0;
	    vec4 _m1;
	};
	
	layout(set = 2) uniform _1500 PerViewConstantBuffer_t;
	
	layout(location = 0) in vec3 input_0[3];
	layout(location = 1) in vec4 input_1[3];
	layout(location = 2) in vec3 input_2[3];
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) out vec3 output_3;
	
	void main()
	{
	    _1134 _19582[3] = _1134[](_1134(input_0[0], input_1[0], input_2[0]), _1134(input_0[1], input_1[1], input_2[1]), _1134(input_0[2], input_1[2], input_2[2]));
	    vec3 _15751 = normalize(cross(input_0[1] - input_0[0], input_0[2] - input_0[0]));
	    int _7155;
	    int _13039 = 0;
	    SPIRV_CROSS_UNROLL
	    for (;;)
	    {
	        if (!(_13039 < 3))
	        {
	            break;
	        }
	        vec4 _23913 = (vec4(_19582[_13039]._m0.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	        output_0 = _15751;
	        output_1 = _19582[_13039]._m0;
	        output_2 = _19582[_13039]._m1;
	        output_3 = _19582[_13039]._m2;
	        _23913.y = -_23913.y;
	        gl_Position = _23913;
	        EmitVertex();
	        _7155 = _13039 + 1;
	        _13039 = _7155;
	        continue;
	    }
	    EndPrimitive();
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_TOOLS_ENABLED, 0, Sys( 1 ) );
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_VERY_SIMPLE_LIGHTING, 0..1 );
	StaticCombo( S_WIREFRAME, F_WIREFRAME );
	StaticCombo( S_TRIANGLE_EDGES, F_TRIANGLE_EDGES );
	StaticCombo( S_DISABLE_DEPTHTEST, F_DISABLE_DEPTHTEST );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_MODE_TOOLS_WIREFRAME, S_VERY_SIMPLE_LIGHTING ) );
	StaticComboRule( Allow0( S_TOOLS_ENABLED ) );
	StaticComboRule( Allow1( S_TRIANGLE_EDGES, S_WIREFRAME ) );
	
	RenderState(BlendEnable, F_TRANSLUCENT ? True : False);
	RenderState(ColorWriteEnable0, 7);
	RenderState(DepthFunc, F_DISABLE_DEPTHTEST ? Always : LessEqual);
	RenderState(DepthWriteEnable, F_TRANSLUCENT ? False : True);
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer RoughnessLightingGlobalsCB_t < Attribute("RoughnessLightingGlobalsCB_t"); >;
	cbuffer SunLightShaderParamsCB < Attribute("SunLightShaderParamsCB"); >;
	
	// IsSelected
	float g_flIsSelected < Attribute("IsSelected"); UiType(Slider); UiGroup("IsSelected"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (4000 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 _3;
	
	cbuffer RoughnessLightingGlobalsCB_t : register(b3, space1)
	{
	    float4 RoughnessLightingGlobalsCB_t_1_m0 : packoffset(c0);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float PerViewConstantBuffer_t_1_m0 : packoffset(c18);
	    float3 PerViewConstantBuffer_t_1_m1 : packoffset(c26);
	    float3 PerViewConstantBuffer_t_1_m2 : packoffset(c31);
	    float PerViewConstantBuffer_t_1_m3 : packoffset(c31.w);
	    float PerViewConstantBuffer_t_1_m4 : packoffset(c32);
	    float PerViewConstantBuffer_t_1_m5 : packoffset(c32.y);
	    float PerViewConstantBuffer_t_1_m6 : packoffset(c32.z);
	};
	
	cbuffer SunLightShaderParamsCB : register(b4, space1)
	{
	    float4 SunLightShaderParamsCB_1_m0 : packoffset(c0);
	    float3 SunLightShaderParamsCB_1_m1 : packoffset(c1);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flIsSelected : packoffset(c0);
	};
	
	
	static float4 gl_FragCoord;
	static float4 input_0;
	static float3 input_1;
	static float3 input_2;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_1 : TEXCOORD0;
	    float3 input_2 : TEXCOORD1;
	    float4 input_0 : TEXCOORD2;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float3 _14744 = normalize(input_1.xyz).xyz;
	    float3 _23378 = clamp(_14744, 0.0f.xxx, 1.0f.xxx);
	    float3 _23904 = clamp(-_14744, 0.0f.xxx, 1.0f.xxx);
	    float3 _21122 = ((RoughnessLightingGlobalsCB_t_1_m0.xyz * (dot(float3(0.60000002384185791015625f, 0.4000000059604644775390625f, 1.0f), _23378 * _23378) + dot(float3(0.60000002384185791015625f, 0.4000000059604644775390625f, 0.20000000298023223876953125f), _23904 * _23904))).xyz + ((SunLightShaderParamsCB_1_m0.xyz * (pow(clamp(dot(_14744, SunLightShaderParamsCB_1_m1.xyz), 0.0f, 1.0f), 0.60000002384185791015625f) * 0.800000011920928955078125f)) * 1.0f)).xyz * input_0.xyz;
	    float4 _23714;
	    _23714.x = _21122.x;
	    _23714.y = _21122.y;
	    _23714.z = _21122.z;
	    float3 _19800 = lerp(_23714.xyz, PerViewConstantBuffer_t_1_m2.xyz, clamp(min(PerViewConstantBuffer_t_1_m5, pow(clamp((distance(input_2.xyz, PerViewConstantBuffer_t_1_m1.xyz) * PerViewConstantBuffer_t_1_m4) + PerViewConstantBuffer_t_1_m3, 0.0f, 1.0f), PerViewConstantBuffer_t_1_m6)), 0.0f, 1.0f).xxx);
	    float4 _17842;
	    _17842.x = _19800.x;
	    _17842.y = _19800.y;
	    _17842.z = _19800.z;
	    float4 _17971 = float4(_17842.xyz * PerViewConstantBuffer_t_1_m0, input_0.w);
	    float4 _6805;
	    do
	    {
	        if (_Globals_1_g_flIsSelected > 0.03125f)
	        {
	            if (fmod((gl_FragCoord.x - 0.5f) + float(int(fmod(gl_FragCoord.y - 0.5f, 2.0f))), 2.0f) < 1.0f)
	            {
	                float _18383 = _Globals_1_g_flIsSelected * 0.5f;
	                _6805 = (float4(1.0f, 1.0f, 0.75f, 1.0f) * _18383) + (_17971 * (1.0f - _18383));
	                break;
	            }
	        }
	        _6805 = _17971;
	        break;
	    } while(false);
	    output_0 = _6805;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(translucent, F_TRANSLUCENT || 0);
	
}
