//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Standard shader for all non-blend surfaces";
	DevShader = false;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_41
	// Programs: ps, vs
}

MODES
{
	Forward();
}

FEATURES
{
	Feature( F_DISABLE_TEXTURE_MIRRORING, 0..1, "Disable Texture Mirroring" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vPositionOs  : POSITION0  < Semantic( PosXy ); >;                                      
	uint4  nPackedFrame : NORMAL0    < Semantic( CompressedTangentFrame ); >;                     
	float4 vNormalOs    : NORMAL0    < Semantic( Normal ); >;                                     
	float3 vPositionOs  : POSITION0  < Semantic( PosXyz ); >;                                     
	float2 vTexCoord    : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                             
	float2 nInstanceIdx : TEXCOORD13 < Semantic( InstanceTransformUv ); >;                        
};

VS
{
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_BAKE_GRASS, 0..2 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3424 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1738
	{
	    float4 _m0[3];
	};
	
	struct _1424
	{
	    _1738 _m0;
	};
	
	struct _1864
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer _Globals_ : register(b0, space0)
	{
	    _1864 _Globals_1_m0 : packoffset(c0);
	    float4 _Globals_1_m1 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float2 vTexCoord;
	static float3 vNormalOs;
	static uint nInstanceIdx;
	static float3 output_0;
	static float2 output_1;
	static float3 output_2;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD2;
	    uint nInstanceIdx : TEXCOORD5;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float2 output_1 : TEXCOORD1;
	    float3 output_2 : TEXCOORD2;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _1738 _25207;
	    [unroll]
	    for (int _1ident = 0; _1ident < 3; _1ident++)
	    {
	        _25207._m0[_1ident] = asfloat(g_transformBuffer.Load4(_1ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	    }
	    float3x4 _13745 = float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]);
	    float3 _19648;
	    if (((g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u) > 0u)
	    {
	        _19648 = _25207._m0[0].z.xxx;
	    }
	    else
	    {
	        _19648 = 1.0f.xxx;
	    }
	    float3 _12151 = mul(_13745, float4(vPositionOs.xyz * _19648.xyz, 1.0f));
	    float4 _23552 = mul(float4x4(float4(_Globals_1_m0._m0[0].x, _Globals_1_m0._m0[1].x, _Globals_1_m0._m0[2].x, _Globals_1_m0._m0[3].x), float4(_Globals_1_m0._m0[0].y, _Globals_1_m0._m0[1].y, _Globals_1_m0._m0[2].y, _Globals_1_m0._m0[3].y), float4(_Globals_1_m0._m0[0].z, _Globals_1_m0._m0[1].z, _Globals_1_m0._m0[2].z, _Globals_1_m0._m0[3].z), float4(_Globals_1_m0._m0[0].w, _Globals_1_m0._m0[1].w, _Globals_1_m0._m0[2].w, _Globals_1_m0._m0[3].w)), (float4(_12151.xyz, 1.0f) + (_Globals_1_m1 * 1.0f)).xyzw);
	    output_0 = normalize(mul(_13745, float4(vNormalOs.xyz, 0.0f)));
	    output_1 = vTexCoord;
	    output_2 = _12151;
	    _23552.y = -_23552.y;
	    gl_Position = _23552;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vNormalOs = stage_input.vNormalOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_DISABLE_TEXTURE_MIRRORING, F_DISABLE_TEXTURE_MIRRORING );
	DynamicCombo( D_BAKE_GRASS, 0..2 );
	
	// Color
	CreateInputTexture2D(CSGOTintMask, Linear, 8, "", "", "Color", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	
	Texture2D g_tCSGOTintMask < Channel(RGBA, None(CSGOTintMask), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent", Default4(1, 1, 1, 0));
	
	// GrassSize
	float g_flGrassWidth < Default(35); Range(1, 256); UiType(Slider); UiGroup("GrassSize/10"); >;
	float g_flGrassHeightMin < Default(35); Range(1, 256); UiType(Slider); UiGroup("GrassSize/20"); >;
	float g_flGrassHeightMax < Default(55); Range(1, 256); UiType(Slider); UiGroup("GrassSize/30"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1016 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float3 _Globals_1_g_vColorTint : packoffset(c0);
	};
	
	Texture2D<float4> g_tColor : register(t30, space1);
	SamplerState Filter_MinMagMipPoint : register(s14, space1);
	
	static float2 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float2 input_0 : TEXCOORD1;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _3401 = g_tColor.Sample(Filter_MinMagMipPoint, input_0.xy);
	    output_0 = float4(_3401.xyz * _Globals_1_g_vColorTint.xyz, _3401.w);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(translucent, true);
	TextureAttribute(RepresentativeTexture, g_tColor);
	FloatAttribute(GrassWidth, g_flGrassWidth);
	FloatAttribute(GrassHeightMin, g_flGrassHeightMin);
	FloatAttribute(GrassHeightMax, g_flGrassHeightMax);
	
	#if (S_DISABLE_TEXTURE_MIRRORING == 1)
		BoolAttribute(GrassNoMirroring, true);
	#endif
}
