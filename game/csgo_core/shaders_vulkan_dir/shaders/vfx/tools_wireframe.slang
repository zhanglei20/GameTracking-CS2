//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Wireframe for tools";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: gs, ps, vs
}

MODES
{
	Default();
	Depth(S_MODE_DEPTH);
	ToolsUtil();
	CsgoForward();
	ToolsVis();
}

FEATURES
{
	Feature( F_ALPHA_TEST, 0..1, "" );
	Feature( F_TRANSLUCENT, 0..1, "" );
	Feature( F_WIREFRAME, 0..1, "" );
	Feature( F_NO_ZTEST, 0..1, "" );
	Feature( F_NO_CULLING, 0..1, "" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices       : BLENDINDICES0  < Semantic( BlendIndices ); >;                    
	float4 vColor              : COLOR0         < Semantic( Color ); >;                           
	float4 vNormalOs           : NORMAL0        < Semantic( Normal ); >;                          
	float3 vPositionOs         : POSITION0      < Semantic( PosXyz ); >;                          
	float2 vFirstLineVertPosWs : TEXCOORD0      < Semantic( uvw ); >;                              // S_MOBILE=1
	float2 nInstanceIdx        : TEXCOORD13     < Semantic( InstanceTransformUv ); >;             
};

VS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_MOBILE, 0..1 );
	DynamicCombo( D_DEPTH_BIAS, 0..1 );
	DynamicCombo( D_SNAP_TO_SCREEN_PIXELS, 0..1 );
	DynamicCombo( D_THICK_LINES, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_FREEFORM_DEFORMATION, 0..1 );
	DynamicComboRule( Allow1( D_THICK_LINES, D_SNAP_TO_SCREEN_PIXELS ) );
	
	cbuffer FFDTransforms_t < Attribute("FFDTransforms_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	bool g_bIgnoreTintAlpha < Attribute("IgnoreTintAlpha"); UiType(CheckBox); >;
	float g_flDynamicLineThickness < Default(1); Attribute("DynamicLineThickness"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Depth Bias Amount
	float g_DepthBiasAmount < Default(0.005); UiType(Slider); UiGroup("Depth Bias Amount"); >;
	
	// Line Thickness
	float g_LineThickness < Default(1); Range(0, 8); UiType(Slider); UiGroup("Line Thickness"); >;
	
	// Override Color
	float g_OverrideColorFactor < UiType(Slider); UiGroup("Override Color"); >;
	float4 g_vOverrideColor < Default(0); UiType(Color); UiGroup("Override Color"); Expression(SrgbGammaToLinear(this)); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vOverrideColor) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (6512 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1234
	{
	    vec4 _m0[3];
	};
	
	struct _416
	{
	    _1234 _m0;
	};
	
	struct _1360
	{
	    vec4 _m0[4];
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _416 _m0[];
	} g_transformBuffer_1;
	
	struct _731
	{
	    _1360 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _731 PerViewConstantBuffer_t;
	
	struct _1048
	{
	    vec4 g_vOverrideColor;
	    float g_OverrideColorFactor;
	    int g_bIgnoreTintAlpha;
	};
	
	layout(set = 0) uniform _1048 _Globals_;
	
	layout(location = 4) in uvec4 vPositionOs;
	layout(location = 5) in uint vColor;
	layout(location = 0) in vec3 vNormalOs;
	layout(location = 2) in vec3 vBlendIndices;
	layout(location = 1) in vec3 nInstanceIdx;
	layout(location = 3) in vec4 vFirstLineVertPosWs;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) out vec4 output_3;
	layout(location = 4) out vec3 output_4;
	
	void main()
	{
	    uint _21785;
	    if (((g_instanceBuffer_1._m0[vColor]._m5 >> uint(16)) & 15u) == 1u)
	    {
	        _21785 = g_instanceBuffer_1._m0[vColor]._m1 + (2u + vPositionOs.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer_1._m0[vColor]._m1;
	    }
	    mat3x4 _14779 = mat3x4(g_transformBuffer_1._m0[_21785]._m0._m0[0], g_transformBuffer_1._m0[_21785]._m0._m0[1], g_transformBuffer_1._m0[_21785]._m0._m0[2]);
	    vec3 _23070 = vec4(vNormalOs.xyz, 1.0) * _14779;
	    vec4 _21447 = PerViewConstantBuffer_t._m1 * 1.0;
	    mat4 _15571 = mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	    vec4 _23875 = (vec4(_23070.xyz, 1.0) + _21447).xyzw * _15571;
	    vec3 _24030 = vFirstLineVertPosWs.xyz * vec3(0.077399380505084991455078125);
	    vec3 _7676 = pow((vFirstLineVertPosWs.xyz * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21354;
	    if (vFirstLineVertPosWs.x <= 0.040449999272823333740234375)
	    {
	        _21354 = _24030.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (vFirstLineVertPosWs.y <= 0.040449999272823333740234375)
	    {
	        _21355 = _24030.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (vFirstLineVertPosWs.z <= 0.040449999272823333740234375)
	    {
	        _19302 = _24030.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    vec4 _23628 = vec4(_21354, _21355, _19302, vFirstLineVertPosWs.w);
	    vec4 _23812 = vec4(uvec4((g_instanceBuffer_1._m0[vColor]._m0 & 255u), (g_instanceBuffer_1._m0[vColor]._m0 & 65280u) >> uint(8), (g_instanceBuffer_1._m0[vColor]._m0 & 16711680u) >> uint(16), (g_instanceBuffer_1._m0[vColor]._m0 & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec3 _6253 = _23812.xyz;
	    vec3 _17828 = _6253 * vec3(0.077399380505084991455078125);
	    vec3 _7677 = pow((_6253 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21356;
	    if (_23812.x <= 0.040449999272823333740234375)
	    {
	        _21356 = _17828.x;
	    }
	    else
	    {
	        _21356 = _7677.x;
	    }
	    float _21357;
	    if (_23812.y <= 0.040449999272823333740234375)
	    {
	        _21357 = _17828.y;
	    }
	    else
	    {
	        _21357 = _7677.y;
	    }
	    float _19167;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _19167 = _17828.z;
	    }
	    else
	    {
	        _19167 = _7677.z;
	    }
	    _23812.x = _21356;
	    _23812.y = _21357;
	    _23812.z = _19167;
	    vec4 _21709;
	    if (_Globals_.g_bIgnoreTintAlpha != 0)
	    {
	        vec3 _15408 = _23628.xyz * abs(_23812.xyz);
	        vec4 _23714 = _23628;
	        _23714.x = _15408.x;
	        _23714.y = _15408.y;
	        _23714.z = _15408.z;
	        _21709 = _23714;
	    }
	    else
	    {
	        _21709 = _23628 * abs(_23812);
	    }
	    output_0 = normalize(vec4(nInstanceIdx.xyz, 0.0) * _14779);
	    output_1 = mix(_21709, _Globals_.g_vOverrideColor, vec4(_Globals_.g_OverrideColorFactor));
	    output_2 = (vec4((vec4(vBlendIndices, 1.0) * _14779).xyz, 1.0) + _21447).xyzw * _15571;
	    output_3 = _23875;
	    output_4 = _23070;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

GS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_MOBILE, 0..1 );
	DynamicCombo( D_THICK_LINES, 0..1 );
	DynamicCombo( D_DEPTH_BIAS, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Depth Bias Amount
	float g_DepthBiasAmount < Default(0.005); UiType(Slider); UiGroup("Depth Bias Amount"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported shader stage.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (4136 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	// Dynamic combos: D_THICK_LINES
	
	#version 460
	layout(lines) in;
	layout(max_vertices = 4, triangle_strip) out;
	
	struct _1864
	{
	    vec4 _m0[4];
	};
	
	struct _1793
	{
	    _1864 _m0;
	    vec2 _m1;
	    vec4 _m2;
	};
	
	layout(set = 2) uniform _1793 PerViewConstantBuffer_t;
	
	layout(location = 0) in vec3 input_0[2];
	layout(location = 1) in vec3 input_1[2];
	layout(location = 2) in float input_2[2];
	layout(location = 3) in vec4 input_3[2];
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) out vec4 output_3;
	layout(location = 4) out vec3 output_4;
	
	void main()
	{
	    vec4 _21447 = PerViewConstantBuffer_t._m2 * 1.0;
	    mat4 _15571 = mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	    vec4 _24240 = (vec4(input_0[0].xyz, 1.0) + _21447).xyzw * _15571;
	    vec4 _9193 = (vec4(input_0[1].xyz, 1.0) + _21447).xyzw * _15571;
	    vec2 _13645 = _9193.xy;
	    float _20176 = _9193.w;
	    vec2 _7058 = _24240.xy;
	    float _20181 = _24240.w;
	    vec2 _25108 = PerViewConstantBuffer_t._m1.xy * 2.0;
	    float _14436 = _24240.z;
	    vec2 _19809 = (normalize(vec2(1.0, -1.0) * (((_13645 / vec2(_20176)) - (_7058 / vec2(_20181))).xy / _25108).yx).xy * _25108).xy;
	    vec2 _13861 = _7058 + ((_19809 * input_2[0]) * _20181);
	    float _9979 = _13861.x;
	    vec4 _20450 = _24240;
	    _20450.x = _9979;
	    output_0 = input_1[0];
	    output_1 = input_3[0];
	    output_2 = _24240;
	    output_3 = vec4(_9979, _13861.y, _14436, _20181);
	    output_4 = input_0[0];
	    _20450.y = -_13861.y;
	    gl_Position = _20450;
	    EmitVertex();
	    float _14689 = _9193.z;
	    vec2 _13862 = _13645 + ((_19809 * input_2[1]) * _20176);
	    float _9980 = _13862.x;
	    vec4 _20451 = _9193;
	    _20451.x = _9980;
	    output_0 = input_1[1];
	    output_1 = input_3[1];
	    output_2 = _24240;
	    output_3 = vec4(_9980, _13862.y, _14689, _20176);
	    output_4 = input_0[1];
	    _20451.y = -_13862.y;
	    gl_Position = _20451;
	    EmitVertex();
	    vec2 _13863 = _7058 + ((_19809 * ((-1.0) * input_2[0])) * _20181);
	    float _9981 = _13863.x;
	    vec4 _20452 = _24240;
	    _20452.x = _9981;
	    output_0 = input_1[0];
	    output_1 = input_3[0];
	    output_2 = _24240;
	    output_3 = vec4(_9981, _13863.y, _14436, _20181);
	    output_4 = input_0[0];
	    _20452.y = -_13863.y;
	    gl_Position = _20452;
	    EmitVertex();
	    vec2 _13864 = _13645 + ((_19809 * ((-1.0) * input_2[1])) * _20176);
	    float _9982 = _13864.x;
	    vec4 _20453 = _9193;
	    _20453.x = _9982;
	    output_0 = input_1[1];
	    output_1 = input_3[1];
	    output_2 = _24240;
	    output_3 = vec4(_9982, _13864.y, _14689, _20176);
	    output_4 = input_0[1];
	    _20453.y = -_13864.y;
	    gl_Position = _20453;
	    EmitVertex();
	    EndPrimitive();
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_NO_ZTEST, F_NO_ZTEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_TRANSLUCENT ) );
	DynamicCombo( D_NO_ZTEST, 0..1 );
	DynamicCombo( D_NO_CULLING, 0..1 );
	DynamicCombo( D_THICK_LINES, 0..1 );
	DynamicCombo( D_SHADED, 0..1 );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_SHADED ) );
	
	RenderState(CullMode, None);
	RenderState(CullMode, (((None ? Back : F_WIREFRAME) ? Back : F_NO_CULLING) ? Back : None) ? None : Back);
	RenderState(CullMode, (((None ? Back : F_WIREFRAME) ? Back : F_NO_CULLING) ? Back : Back) ? None : Back);
	RenderState(FillMode, F_WIREFRAME ? Wireframe : Solid);
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	float g_flAlphaTestReference < Default(0.3); Range(0.01, 0.99); UiType(Slider); >;
	float g_flPatternType < Attribute("PatternType"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	#if (S_ALPHA_TEST == 1)
		RenderState(CullMode, None);
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1712 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flPatternType : packoffset(c0.w);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c21);
	};
	
	
	static float4 input_0;
	static float4 input_1;
	static float4 input_2;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD1;
	    float4 input_1 : TEXCOORD2;
	    float4 input_2 : TEXCOORD3;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    bool _12885;
	    do
	    {
	        float _19321;
	        if (_Globals_1_g_flPatternType == 1.0f)
	        {
	            _19321 = 16.0f;
	        }
	        else
	        {
	            _19321 = (_Globals_1_g_flPatternType == 2.0f) ? 3.0f : 0.0f;
	        }
	        if (_19321 != 0.0f)
	        {
	            _12885 = fmod(length(float2((input_2.x / input_2.w) / PerViewConstantBuffer_t_1_m0.x, (input_2.y / input_2.w) / PerViewConstantBuffer_t_1_m0.y) - float2((input_1.x / input_1.w) / PerViewConstantBuffer_t_1_m0.x, (input_1.y / input_1.w) / PerViewConstantBuffer_t_1_m0.y)), _19321 * 2.0f) > _19321;
	            break;
	        }
	        _12885 = false;
	        break;
	    } while(false);
	    if (_12885)
	    {
	        discard;
	    }
	    output_0 = input_0;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
