//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Environment shader with blended layers";
	DevShader = false;
	Version = 9;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_60
	// Programs: ps, psrs, rtx, vs
}

MODES
{
	CsgoForward();
	RayTrace();
	Depth(S_MODE_DEPTH);
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_BLEND_BY_FACING_DIRECTION_2, 0..1, "Layer 2" );
	Feature( F_ENABLE_LAYER_3, 0..1, "Layer 3" );
	Feature( F_BLEND_BY_FACING_DIRECTION_3, 0..1, "Layer 3" );
	Feature( F_BLEND_EFFECTS_2, 0..1, "Layer 2" );
	Feature( F_BORDER_ROUGHNESS_2, 0..1, "Layer 2" );
	Feature( F_BORDER_BLEND_MODE_2, 0..3 (0="Multiply", 1="Replace", 2="Mod2x", 3="Colorize"), "Layer 2" );
	Feature( F_BLEND_EFFECTS_3, 0..1, "Layer 3" );
	Feature( F_BORDER_ROUGHNESS_3, 0..1, "Layer 3" );
	Feature( F_BORDER_BLEND_MODE_3, 0..3 (0="Multiply", 1="Replace", 2="Mod2x", 3="Colorize"), "Layer 3" );
	Feature( F_DETAIL_NORMAL, 0..1, "Detail" );
	Feature( F_WETNESS, 0..1, "Wetness" );
	Feature( F_USE_NEW_BLENDING, 0..1, "Blending" );
	Feature( F_SHARED_COLOR_OVERLAY, 0..1, "Color Effects" );
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_DEPTH_BIAS, 0..1, "Z-Buffering" );
	Feature( F_OCCLUSION_CULLING_BOUNDS_SCALE, 0..1, "Z-Buffering" );
	Feature( F_ENABLE_VISUALIZATIONS, 0..1, "Visualizations" );
	Feature( F_VISUALIZATION_MODE, 0..3 (0="Show Blending", 1="Show Final Heights", 2="Show Vertex Painting", 3="Show Detail Prop Masks"), "Visualizations" );
	Feature( F_BLEND_EFFECTS, 0..0, "F_BLEND_EFFECTS_2" );
	Feature( F_BORDER_ROUGHNESS, 0..0, "F_BORDER_ROUGHNESS_2" );
	Feature( F_BORDER_BLEND_MODE, 0..0, "F_BORDER_BLEND_MODE_2" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Requires( F_BLEND_BY_FACING_DIRECTION_3, F_ENABLE_LAYER_3 ), "Blend by Facing Direction 3 requires Enable Layer 3" );
	FeatureRule( Requires( F_BORDER_ROUGHNESS_2, F_BLEND_EFFECTS_2 ), "Border Roughness requires Blend Effects" );
	FeatureRule( Requires( F_BORDER_BLEND_MODE_2, F_BLEND_EFFECTS_2 ), "Border Roughness requires Blend Effects" );
	FeatureRule( Requires( F_BLEND_EFFECTS_3, F_ENABLE_LAYER_3 ), "Blend Effects for Layer 3 requries Enable Layer 3" );
	FeatureRule( Requires( F_BORDER_ROUGHNESS_3, F_BLEND_EFFECTS_3 ), "Border Roughness 3 requires Blend Effects 3" );
	FeatureRule( Requires( F_BORDER_BLEND_MODE_3, F_BLEND_EFFECTS_3 ), "Border Roughness 3 requires Blend Effects 3" );
	FeatureRule( Allow1( F_DISABLE_Z_BUFFERING, F_DEPTH_BIAS ), "Z Bias and Disable Z Buffering are not compatible" );
	FeatureRule( Requires( F_VISUALIZATION_MODE, F_ENABLE_VISUALIZATIONS ), "Enable Visualization Mode" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;      // S_MODE_DEPTH=0, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;        
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;               
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;            // S_MODE_DEPTH=0, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST=1
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_MODE_DEPTH=0, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST=1
	float4 vColorBlendValues          : TEXCOORD4      < Semantic( VertexPaintBlendParams ); >;    // S_MODE_DEPTH=0, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST=1
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_SHARED_COLOR_OVERLAY, F_SHARED_COLOR_OVERLAY );
	StaticCombo( S_ENABLE_LAYER_3, F_ENABLE_LAYER_3 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_MODE_DEPTH ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	bool g_bTexCoord2ScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoord2UByModelScaleAxis!=0) || (g_nScaleTexCoord2VByModelScaleAxis!=0)); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoordUByModelScaleAxis!=0) || (g_nScaleTexCoordVByModelScaleAxis!=0)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	float4 g_vDetailTexCoordXform0_1 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale1.x,-v2*g_vDetailTexCoordScale1.y,0,((g_vDetailTexCoordCenter1.x+g_vDetailTexCoordOffset1.x)+(v2*g_vDetailTexCoordCenter1.y))-(v1*g_vDetailTexCoordCenter1.x))); >;
	float4 g_vDetailTexCoordXform0_2 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation2*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale2.x,-v2*g_vDetailTexCoordScale2.y,0,((g_vDetailTexCoordCenter2.x+g_vDetailTexCoordOffset2.x)+(v2*g_vDetailTexCoordCenter2.y))-(v1*g_vDetailTexCoordCenter2.x))); >;
	float4 g_vDetailTexCoordXform0_3 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation3*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale3.x,-v2*g_vDetailTexCoordScale3.y,0,((g_vDetailTexCoordCenter3.x+g_vDetailTexCoordOffset3.x)+(v2*g_vDetailTexCoordCenter3.y))-(v1*g_vDetailTexCoordCenter3.x))); >;
	float4 g_vDetailTexCoordXform1_1 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale1.x,v1*g_vDetailTexCoordScale1.y,0,(g_vDetailTexCoordCenter1.y+g_vDetailTexCoordOffset1.y)-((v2*g_vDetailTexCoordCenter1.x)+(v1*g_vDetailTexCoordCenter1.y)))); >;
	float4 g_vDetailTexCoordXform1_2 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation2*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale2.x,v1*g_vDetailTexCoordScale2.y,0,(g_vDetailTexCoordCenter2.y+g_vDetailTexCoordOffset2.y)-((v2*g_vDetailTexCoordCenter2.x)+(v1*g_vDetailTexCoordCenter2.y)))); >;
	float4 g_vDetailTexCoordXform1_3 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation3*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale3.x,v1*g_vDetailTexCoordScale3.y,0,(g_vDetailTexCoordCenter3.y+g_vDetailTexCoordOffset3.y)-((v2*g_vDetailTexCoordCenter3.x)+(v1*g_vDetailTexCoordCenter3.y)))); >;
	float4 g_vOverlayTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flOverlayTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vOverlayTexCoordScale.x,-v2*g_vOverlayTexCoordScale.y,0,((g_vOverlayTexCoordCenter.x+g_vOverlayTexCoordOffset.x)+(v2*g_vOverlayTexCoordCenter.y))-(v1*g_vOverlayTexCoordCenter.x))); >;
	float4 g_vOverlayTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flOverlayTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vOverlayTexCoordScale.x,v1*g_vOverlayTexCoordScale.y,0,(g_vOverlayTexCoordCenter.y+g_vOverlayTexCoordOffset.y)-((v2*g_vOverlayTexCoordCenter.x)+(v1*g_vOverlayTexCoordCenter.y)))); >;
	float4 g_vTexCoord2ScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoord2UByModelScaleAxis==1) || 0,(g_nScaleTexCoord2UByModelScaleAxis==2) || 0,(g_nScaleTexCoord2UByModelScaleAxis==3) || 0,(g_nScaleTexCoord2UByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoord2ScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoord2VByModelScaleAxis==1) || 0,(g_nScaleTexCoord2VByModelScaleAxis==2) || 0,(g_nScaleTexCoord2VByModelScaleAxis==3) || 0,(g_nScaleTexCoord2VByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoordScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoordUByModelScaleAxis==1) || 0,(g_nScaleTexCoordUByModelScaleAxis==2) || 0,(g_nScaleTexCoordUByModelScaleAxis==3) || 0,(g_nScaleTexCoordUByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoordScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoordVByModelScaleAxis==1) || 0,(g_nScaleTexCoordVByModelScaleAxis==2) || 0,(g_nScaleTexCoordVByModelScaleAxis==3) || 0,(g_nScaleTexCoordVByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoordXform0_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale1.x,-v2*g_vTexCoordScale1.y,0,((g_vTexCoordCenter1.x+g_vTexCoordOffset1.x)+(v2*g_vTexCoordCenter1.y))-(v1*g_vTexCoordCenter1.x))); >;
	float4 g_vTexCoordXform0_2 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation2*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale2.x,-v2*g_vTexCoordScale2.y,0,((g_vTexCoordCenter2.x+g_vTexCoordOffset2.x)+(v2*g_vTexCoordCenter2.y))-(v1*g_vTexCoordCenter2.x))); >;
	float4 g_vTexCoordXform0_3 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation3*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale3.x,-v2*g_vTexCoordScale3.y,0,((g_vTexCoordCenter3.x+g_vTexCoordOffset3.x)+(v2*g_vTexCoordCenter3.y))-(v1*g_vTexCoordCenter3.x))); >;
	float4 g_vTexCoordXform1_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale1.x,v1*g_vTexCoordScale1.y,0,(g_vTexCoordCenter1.y+g_vTexCoordOffset1.y)-((v2*g_vTexCoordCenter1.x)+(v1*g_vTexCoordCenter1.y)))); >;
	float4 g_vTexCoordXform1_2 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation2*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale2.x,v1*g_vTexCoordScale2.y,0,(g_vTexCoordCenter2.y+g_vTexCoordOffset2.y)-((v2*g_vTexCoordCenter2.x)+(v1*g_vTexCoordCenter2.y)))); >;
	float4 g_vTexCoordXform1_3 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation3*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale3.x,v1*g_vTexCoordScale3.y,0,(g_vTexCoordCenter3.y+g_vTexCoordOffset3.y)-((v2*g_vTexCoordCenter3.x)+(v1*g_vTexCoordCenter3.y)))); >;
	
	// Material1
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	float2 g_vTexCoordCenter2 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	int g_nDetailUVSet1 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float2 g_vTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float g_flTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/3"); UiVisibility(1); >;
	float2 g_vTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vTexCoordOffset2 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vDetailTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/9"); UiVisibility(1); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	
	// Material2
	int g_nUVSet2 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/1"); >;
	int g_nDetailUVSet2 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/2"); >;
	float2 g_vDetailTexCoordCenter2 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material2/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material2/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material2/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset2 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material2/Detail Texture Transform/9"); UiVisibility(1); >;
	
	// Material3
	int g_nUVSet3 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter3 < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Material3/Texture Transform,35/1"); UiVisibility(1); >;
	int g_nDetailUVSet3 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Texture Transform,35/2"); >;
	float g_flTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Texture Transform,35/3"); UiVisibility(1); >;
	float2 g_vTexCoordOffset3 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material3/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vDetailTexCoordCenter3 < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Material3/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset3 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material3/Detail Texture Transform/9"); UiVisibility(1); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	int g_nColorOverlayUVSet < Default(2); Range4(1, 1, 1, 1, 2, 2, 2, 2); UiOptions("1=UV1,2=UV2"); UiType(Enum); UiGroup("Color/Overlay/40"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	int g_nScaleTexCoord2UByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.u * model.x,2=UV2.u * model.y,3=UV2.u * model.z"); UiType(Enum); UiGroup("Color/100"); UiVisibility(1); >;
	int g_nScaleTexCoord2VByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.v * model.x,2=UV2.v * model.y,3=UV2.v * model.z"); UiType(Enum); UiGroup("Color/110"); UiVisibility(1); >;
	float2 g_vOverlayTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/Overlay/200"); >;
	float2 g_vOverlayTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/Overlay/210"); >;
	float g_flOverlayTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/Overlay/220"); >;
	float2 g_vOverlayTexCoordOffset < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Color/Overlay/230"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vTexCoordXform0_1) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (8572 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _2578
	{
	    vec4 _m0[3];
	};
	
	struct _93
	{
	    _2578 _m0;
	};
	
	struct _1079
	{
	    vec4 _m0[4];
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _93 _m0[];
	} g_transformBuffer_1;
	
	struct _169
	{
	    _1079 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _169 PerViewConstantBuffer_t;
	
	struct _1596
	{
	    int g_nUVSet1;
	    vec4 g_vTexCoordXform0_1;
	    vec4 g_vTexCoordXform1_1;
	    int g_nUVSet2;
	    vec4 g_vTexCoordXform0_2;
	    vec4 g_vTexCoordXform1_2;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	};
	
	layout(set = 0) uniform _1596 _Globals_;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec2 vTexCoord2;
	layout(location = 3) in vec3 vNormalOs;
	layout(location = 4) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 5) in uvec4 vBlendIndices;
	layout(location = 6) in uint nInstanceIdx;
	layout(location = 7) in vec4 vColorBlendValues;
	layout(location = 8) in vec4 vBlendColorTint;
	layout(location = 0) out vec4 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec3 output_3;
	layout(location = 4) out vec4 output_4;
	layout(location = 5) centroid out vec4 output_5;
	layout(location = 6) centroid out vec3 output_6;
	layout(location = 7) out vec4 output_7;
	layout(location = 8) flat out uint output_8;
	
	void main()
	{
	    uint _13771 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5 >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1;
	    }
	    mat3x4 _17839 = mat3x4(g_transformBuffer_1._m0[_21785]._m0._m0[0], g_transformBuffer_1._m0[_21785]._m0._m0[1], g_transformBuffer_1._m0[_21785]._m0._m0[2]);
	    vec3 _21709;
	    if (_13771 > 0u)
	    {
	        _21709 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0._m0[0].z);
	    }
	    else
	    {
	        _21709 = vec3(1.0);
	    }
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
	    float _14124;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _14124 = _17828.z;
	    }
	    else
	    {
	        _14124 = _7676.z;
	    }
	    vec4 _10296 = vec4(_21354, _21355, _14124, _23812.w);
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * _17839);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * _17839;
	    vec4 _23875 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	    vec4 _9337 = vTexCoord.xyxy;
	    _9337.z = vTexCoord2.x;
	    _9337.w = vTexCoord2.y;
	    vec4 _21710;
	    if (_Globals_.g_nUVSet1 > 0)
	    {
	        vec4 _11399 = vec4(mix(_9337.xy, _9337.zw, bvec2(_Globals_.g_nUVSet1 == 2)), vTexCoord2);
	        vec2 _9573 = _11399.xy;
	        vec4 _16823 = _11399;
	        _16823.x = dot(_9573, _Globals_.g_vTexCoordXform0_1.xy) + _Globals_.g_vTexCoordXform0_1.w;
	        _16823.y = dot(_9573, _Globals_.g_vTexCoordXform1_1.xy) + _Globals_.g_vTexCoordXform1_1.w;
	        _21710 = _16823;
	    }
	    else
	    {
	        _21710 = _9337;
	    }
	    vec4 _18606;
	    if (_Globals_.g_nUVSet2 > 0)
	    {
	        vec2 _17583 = mix(_9337.xy, _9337.zw, bvec2(_Globals_.g_nUVSet2 == 2));
	        vec4 _7849 = _21710;
	        _7849.z = _17583.x;
	        _7849.w = _17583.y;
	        vec4 _16824 = _7849;
	        _16824.z = dot(_7849.zw, _Globals_.g_vTexCoordXform0_2.xy) + _Globals_.g_vTexCoordXform0_2.w;
	        _16824.w = dot(_7849.zw, _Globals_.g_vTexCoordXform1_2.xy) + _Globals_.g_vTexCoordXform1_2.w;
	        _18606 = _16824;
	    }
	    else
	    {
	        _18606 = _21710;
	    }
	    _10296.x = _Globals_.g_vColorTint.x;
	    _10296.y = _Globals_.g_vColorTint.y;
	    _10296.z = _Globals_.g_vColorTint.z;
	    vec3 _14119 = _10296.xyz * mix(vec3(1.0), vColorBlendValues.xyz, vec3(vColorBlendValues.w));
	    vec4 _23714 = _10296;
	    _23714.x = _14119.x;
	    _23714.y = _14119.y;
	    _23714.z = _14119.z;
	    output_0 = vBlendColorTint;
	    output_1 = vec4(_21354, _21355, _14124, _Globals_.g_flModelTintAmount * (1.0 - min(_21354, min(_21355, _14124))));
	    output_2 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_3 = _11179;
	    output_4 = _18606;
	    output_5 = _23714;
	    output_6 = _11179;
	    output_7 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _17839), vTangentUOs_flTangentVSign.w);
	    output_8 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5) & 65535u;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	IntAttribute(TexCoord2ScaleByModelU, g_nScaleTexCoord2UByModelScaleAxis-1);
	IntAttribute(TexCoord2ScaleByModelV, g_nScaleTexCoord2VByModelScaleAxis-1);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUIPickColor, true);
	BoolAttribute(VertexpaintUIPuddles, (F_WETNESS==1) || 0);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
	#endif
	#if (S_ENABLE_LAYER_3 == 0)
		BoolAttribute(HasTexcoordTransform, ((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, true);
		BoolAttribute(VertexPaintUI3Layer, false);
	#endif
}

PS
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_SHARED_COLOR_OVERLAY, F_SHARED_COLOR_OVERLAY );
	StaticCombo( S_ENABLE_LAYER_3, F_ENABLE_LAYER_3 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_USE_NEW_BLENDING, F_USE_NEW_BLENDING );
	StaticCombo( S_ENABLE_VISUALIZATIONS, F_ENABLE_VISUALIZATIONS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_BLEND_EFFECTS_2, F_BLEND_EFFECTS_2 );
	StaticCombo( S_BLEND_EFFECTS_3, F_BLEND_EFFECTS_3 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_BLEND_EFFECTS_2 ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_BLEND_EFFECTS_3 ) );
	StaticComboRule( Requires( S_BLEND_EFFECTS_3, S_ENABLE_LAYER_3 ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_ALPHA_TEST_PREPASS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_SPECULAR_CUBE_MAP_STATIC ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	DynamicComboRule( Requires( D_ALPHA_TEST_PREPASS, S_ALPHA_TEST ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightProbeVolumeConstantBuffer_t < Attribute("PerViewLightProbeVolumeConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((g_nUVSet1==0) || (g_nUVSet2==0)) || 0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)) || 0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nDetailUVSet1==0)) || (g_nDetailUVSet2==0)) || 0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)) || (g_nDetailUVSet1==0)) || (g_nDetailUVSet2==0)) || (g_nDetailUVSet3==0)) || 0); >;
	bool bBlendByFacingDirection2 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_2); >;
	bool bBlendByFacingDirection3 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_3); >;
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); SrgbRead(false); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); SrgbRead(false); >;
	bool g_bAdjustBaseColor1 < UiType(CheckBox); Expression(g_nColorCorrectionMode1==1); >;
	bool g_bAdjustBaseColor2 < UiType(CheckBox); Expression(g_nColorCorrectionMode2==1); >;
	bool g_bAdjustBaseColor3 < UiType(CheckBox); Expression(g_nColorCorrectionMode3==1); >;
	bool g_bBorderBlendColorize2 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_2==3); >;
	bool g_bBorderBlendColorize3 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_3==3); >;
	bool g_bBorderBlendMod2x2 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_2==2); >;
	bool g_bBorderBlendMod2x3 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_3==2); >;
	bool g_bBorderBlendMultiply2 < UiType(CheckBox); Expression(!F_BORDER_BLEND_MODE_2); >;
	bool g_bBorderBlendMultiply3 < UiType(CheckBox); Expression(!F_BORDER_BLEND_MODE_3); >;
	bool g_bBorderBlendReplace2 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_2==1); >;
	bool g_bBorderBlendReplace3 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_3==1); >;
	bool g_bBorderRoughness2 < UiType(CheckBox); Expression(F_BORDER_ROUGHNESS_2); >;
	bool g_bBorderRoughness3 < UiType(CheckBox); Expression(F_BORDER_ROUGHNESS_3); >;
	bool g_bColorOverlayLayer1 < UiType(CheckBox); Expression((g_nColorOverlayMode==0) || (g_nColorOverlayMode==1)); >;
	bool g_bColorOverlayLayer2 < UiType(CheckBox); Expression((g_nColorOverlayMode==0) || (g_nColorOverlayMode==2)); >;
	bool g_bColorOverlayLayer3 < UiType(CheckBox); Expression((g_nColorOverlayMode==0) || (g_nColorOverlayMode==3)); >;
	bool g_bColorOverlayMaskLayer1 < UiType(CheckBox); Expression((g_nColorOverlayTintMask==0) || (g_nColorOverlayTintMask==1)); >;
	bool g_bColorOverlayMaskLayer2 < UiType(CheckBox); Expression((g_nColorOverlayTintMask==0) || (g_nColorOverlayTintMask==2)); >;
	bool g_bColorOverlayMaskLayer3 < UiType(CheckBox); Expression((g_nColorOverlayTintMask==0) || (g_nColorOverlayTintMask==3)); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bMaskVertexColor1 < UiType(CheckBox); Expression(g_nVertexColorMode1==0); >;
	bool g_bMaskVertexColor2 < UiType(CheckBox); Expression(g_nVertexColorMode2==0); >;
	bool g_bMaskVertexColor3 < UiType(CheckBox); Expression(g_nVertexColorMode3==0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	bool g_bVertexColorEnabled1 < UiType(CheckBox); Expression(g_nVertexColorMode1!=2); >;
	bool g_bVertexColorEnabled2 < UiType(CheckBox); Expression(g_nVertexColorMode2!=2); >;
	bool g_bVertexColorEnabled3 < UiType(CheckBox); Expression(g_nVertexColorMode3!=2); >;
	bool g_bWetness < UiType(CheckBox); Expression((F_WETNESS==1) || 0); >;
	Texture2DArray g_bindless_Texture2DArray_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	Texture2D g_bindless_Texture2D_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	Texture3D g_bindless_Texture3D_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	TextureCubeArray g_bindless_TextureCubeArray < Source(ExternalDescSet); SrgbRead(false); >;
	TextureCubeArray g_bindless_TextureCubeArray_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	TextureCube g_bindless_TextureCube_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint2,1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint3,1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	int g_nVisualization < UiType(Slider); Expression(F_VISUALIZATION_MODE); >;
	float3 g_vBiplanarTexCoordScale < UiType(VectorText); Expression((1/64)*float3(-1,1,-1)); >;
	float4 g_vDetailNormalXform_1 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vDetailNormalXform_2 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation2*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vDetailNormalXform_3 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation3*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vNormalXform_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalXform_2 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation2*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalXform_3 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation3*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Material1
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Material1,0/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask1, Linear, 8, "", "_mask", "Material1/Tint Mask,15/0", Default4(1, 1, 1, 0));
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	int g_nDetailUVSet1 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float2 g_vTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float g_flTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/3"); UiVisibility(1); >;
	float g_fTintMaskBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Tint Mask/5"); >;
	float2 g_vDetailTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Detail Texture Transform/8"); UiVisibility(1); >;
	CreateInputTexture2D(TextureHeight1, Linear, 8, "", "_height", "Material1/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast1 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material1/Tint Mask/10"); >;
	float3 g_vTextureColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/11"); >;
	float g_fTextureRoughnessBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/12"); >;
	float g_fTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Lighting/13"); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	bool g_bMetalness1 < Default(1); UiType(CheckBox); UiGroup("Material1/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Lighting,20/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/20"); >;
	float g_flDetailPropMaskBias1 < Range(0, 10); UiType(Slider); UiGroup("Material1/Detail Props,90/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float3 g_vAmbientOcclusionLevels1 < Default2(0, 0.5); Range(-1, 1); Attribute("0=Option 1,1=Option 2,2=Option 3"); UiType(VectorText); UiGroup("Material1/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Material1/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/30"); >;
	float g_flHeightMapZeroPoint1 < Default(0.5); UiType(Slider); UiGroup("Material1/Height/30"); >;
	CreateInputTexture2D(TextureNormalDetail1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	float g_fDetailTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Detail/45"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	int g_nVertexColorMode1 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material1/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength1 < Default(1); UiType(Slider); UiGroup("Material1/Lighting/61"); >;
	bool g_bSnowLayer1 < UiType(CheckBox); UiGroup("Material1/Snow,100"); >;
	
	// Material2
	CreateInputTexture2D(TextureColor2, Srgb, 8, "", "_color", "Material2/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask2, Linear, 8, "", "_mask", "Material2/Tint Mask,15/0", Default4(1, 1, 1, 0));
	float g_flColorReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/0"); >;
	int g_nUVSet2 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/1"); >;
	int g_nDetailUVSet2 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/2"); >;
	float g_fTintMaskBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Tint Mask/5"); >;
	float2 g_vDetailTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material2/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material2/Detail Texture Transform/8"); UiVisibility(1); >;
	CreateInputTexture2D(TextureHeight2, Linear, 8, "", "_height", "Material2/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness2, Linear, 8, "Inverse", "_rough", "Material2/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast2 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material2/Tint Mask/10"); >;
	float g_flColorOverlay2 < UiType(Slider); UiGroup("Material2/Selective Blending/10"); >;
	float g_flDetailPropMaskSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Detail Props,90/10"); >;
	float3 g_vFacingDirection2 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material2/Facing Direction/10"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float3 g_vTextureColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2,0/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Lighting/12"); >;
	float g_fTextureNormalContrast2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Lighting/13"); >;
	bool g_bMetalness2 < Default(1); UiType(CheckBox); UiGroup("Material2/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/20"); >;
	float g_flDetailPropMaskBias2 < Range(0, 10); UiType(Slider); UiGroup("Material2/Detail Props,90/20"); >;
	float g_flFacingDirectionMaskSpread2 < Default(0.5); UiType(Slider); UiGroup("Material2/Facing Direction/20"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flHeightMapScale2 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flNormalReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/20"); >;
	float3 g_vAmbientOcclusionLevels2 < Default2(0, 0.5); Range(-1, 1); UiType(VectorText); UiGroup("Material2/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness2, Linear, 8, "", "_metal", "Material2/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/30"); >;
	float g_flHeightMapZeroPoint2 < Default(0.5); UiType(Slider); UiGroup("Material2/Height/30"); >;
	float g_flNormalCombine2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Selective Blending/30"); >;
	float g_vFacingDirectionMaskNormalMapStrength2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Facing Direction/30"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	CreateInputTexture2D(TextureNormalDetail2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Color Correction/40"); >;
	float g_flBlendSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Height,30/40"); >;
	float g_flRoughnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/40"); >;
	float g_vFacingDirectionMaskSoftness2 < Default(0.1); UiType(Slider); UiGroup("Material2/Facing Direction/40"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flUnderlyingHeightMapInfluence2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height,30/41"); >;
	float g_fDetailTextureNormalContrast2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Detail/45"); >;
	float g_flRoughnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/45"); >;
	int g_nColorCorrectionMode2 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material2/Color Correction/45"); >;
	float g_flMetalnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/50"); >;
	float g_flMetalnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/55"); >;
	bool g_bModelTint2 < Default(1); UiType(CheckBox); UiGroup("Material2/Color Correction/60"); >;
	float g_flAOReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/60"); >;
	int g_nVertexColorMode2 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material2/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength2 < Default(1); UiType(Slider); UiGroup("Material2/Lighting/62"); >;
	float g_flAOCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/70"); >;
	float g_flMaskWithHeight2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Height/70"); >;
	bool g_bSnowLayer2 < UiType(CheckBox); UiGroup("Material2/Snow,100"); >;
	
	// Material3
	CreateInputTexture2D(TextureColor3, Srgb, 8, "", "_color", "Material3/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask3, Linear, 8, "", "_mask", "Material3/Tint Mask,15/0", Default4(1, 1, 1, 0));
	float g_flColorReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/0"); >;
	int g_nUVSet3 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/1"); >;
	int g_nDetailUVSet3 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Texture Transform,35/2"); >;
	float g_flTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Texture Transform,35/3"); UiVisibility(1); >;
	float g_fTintMaskBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Tint Mask/5"); >;
	float2 g_vDetailTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Detail Texture Transform/8"); UiVisibility(1); >;
	CreateInputTexture2D(TextureHeight3, Linear, 8, "", "_height", "Material3/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness3, Linear, 8, "Inverse", "_rough", "Material3/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast3 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material3/Tint Mask/10"); >;
	float g_flColorOverlay3 < UiType(Slider); UiGroup("Material3/Selective Blending/10"); >;
	float g_flDetailPropMaskSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Detail Props,90/10"); >;
	float3 g_vFacingDirection3 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material3/Facing Direction/10"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float3 g_vTextureColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3,2/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Lighting/12"); >;
	float g_fTextureNormalContrast3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Lighting/13"); >;
	bool g_bMetalness3 < Default(1); UiType(CheckBox); UiGroup("Material3/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/20"); >;
	float g_flDetailPropMaskBias3 < Range(0, 10); UiType(Slider); UiGroup("Material3/Detail Props,90/20"); >;
	float g_flFacingDirectionMaskSpread3 < Default(0.5); UiType(Slider); UiGroup("Material3/Facing Direction/20"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flHeightMapScale3 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flNormalReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/20"); >;
	float3 g_vAmbientOcclusionLevels3 < Default2(0, 0.5); Range(-1, 1); UiType(VectorText); UiGroup("Material3/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness3, Linear, 8, "", "_metal", "Material3/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/30"); >;
	float g_flHeightMapZeroPoint3 < Default(0.5); UiType(Slider); UiGroup("Material3/Height/30"); >;
	float g_flNormalCombine3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Selective Blending/30"); >;
	float g_vFacingDirectionMaskNormalMapStrength3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Facing Direction/30"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	CreateInputTexture2D(TextureNormalDetail3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Color Correction/40"); >;
	float g_flBlendSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Height,30/40"); >;
	float g_flRoughnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/40"); >;
	float g_vFacingDirectionMaskSoftness3 < Default(0.1); UiType(Slider); UiGroup("Material3/Facing Direction/40"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flUnderlyingHeightMapInfluence3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height,30/41"); >;
	float g_fDetailTextureNormalContrast3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Detail/45"); >;
	float g_flRoughnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/45"); >;
	int g_nColorCorrectionMode3 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material3/Color Correction/45"); >;
	float g_flMetalnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/50"); >;
	float g_flMetalnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/55"); >;
	float g_flAOReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/60"); >;
	int g_nVertexColorMode3 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material3/Color Correction/60"); >;
	bool g_bModelTint3 < Default(1); UiType(CheckBox); UiGroup("Material3/Color Correction/61"); >;
	float g_flWetnessDarkeningStrength3 < Default(1); UiType(Slider); UiGroup("Material3/Lighting/63"); >;
	float g_flAOCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/70"); >;
	float g_flMaskWithHeight3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Height/70"); >;
	bool g_bSnowLayer3 < UiType(CheckBox); UiGroup("Material3/Snow,100"); >;
	
	// Color
	CreateInputTexture2D(TextureSharedColorOverlay, Linear, 8, "", "_color", "Color/Overlay/0", Default4(1, 1, 1, 0));
	int g_nColorOverlayMode < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=All Layers,1=Layer1,2=Layer2,3=Layer3"); UiType(Enum); UiGroup("Color/Overlay/50"); >;
	int g_nColorOverlayTintMask < Range4(0, 0, 0, 0, 4, 4, 4, 4); UiOptions("0=Mask All,1=Mask Layer1,2=Mask Layer2,3=Mask Layer3,4=Unmasked"); UiType(Enum); UiGroup("Color/Overlay/55"); >;
	float3 g_vColorOverlayLayerStrengths < Default3(1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/60"); >;
	float3 g_vColorOverlayTintMaskStrengths < Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/65"); >;
	float g_flOverlayDarknessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/100"); >;
	int g_nScaleTexCoord2UByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.u * model.x,2=UV2.u * model.y,3=UV2.u * model.z"); UiType(Enum); UiGroup("Color/100"); UiVisibility(1); >;
	float g_flOverlayBrightnessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/110"); >;
	int g_nScaleTexCoord2VByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.v * model.x,2=UV2.v * model.y,3=UV2.v * model.z"); UiType(Enum); UiGroup("Color/110"); UiVisibility(1); >;
	float g_flBlendSoftnessDistanceModifierStrength < Default(1); UiType(Slider); UiGroup("Color/120"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Blend Effects
	float g_flBorderSpread2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects,8/Border Layer 2,0/10"); >;
	float g_flBorderSpread3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Border Layer 3,10/10"); >;
	float g_flBorderSoftness2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Border Layer 2/20"); >;
	float g_flBorderSoftness3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Border Layer 3/20"); >;
	float g_flBorderOffset2 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Border Layer 2/30"); >;
	float g_flBorderOffset3 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Border Layer 3/30"); >;
	float g_fBorderRoughness2 < Default(0.5); UiType(Slider); UiGroup("Blend Effects/Border Layer 2/35"); UiVisibility(F_BORDER_ROUGHNESS_2); >;
	float g_fBorderRoughness3 < Default(0.5); UiType(Slider); UiGroup("Blend Effects/Border Layer 3/35"); UiVisibility(F_BORDER_ROUGHNESS_3); >;
	float3 g_vBorderTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Effects/Border Layer 2/40"); Expression(SrgbGammaToLinear(this)); >;
	float3 g_vBorderTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Effects/Border Layer 3/40"); Expression(SrgbGammaToLinear(this)); >;
	bool g_bBorderTintMask3 < UiType(CheckBox); UiGroup("Blend Effects/Border Layer 3/41"); >;
	float2 g_vBorderLayerAmount2 < Default(1); UiType(VectorText); UiGroup("Blend Effects/Border Layer 2/41"); >;
	float2 g_vBorderLayerAmount3 < Default(1); UiType(VectorText); UiGroup("Blend Effects/Border Layer 3/41"); >;
	bool g_bBorderTintMask2 < UiType(CheckBox); UiGroup("Blend Effects/Border Layer 2/42"); >;
	float g_flBevelSpread2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2,5/50"); >;
	float g_flBevelSpread3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3,15/50"); >;
	float g_flBevelSoftness2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2/60"); >;
	float g_flBevelSoftness3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3/60"); >;
	float g_flBevelOffset2 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2/65"); >;
	float g_flBevelOffset3 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3/65"); >;
	float g_flBevelStrength2 < Range(-1, 1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2/70"); Expression(this*.01); >;
	float g_flBevelStrength3 < Range(-1, 1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3/70"); Expression(this*.01); >;
	float g_flBevelCurve2 < Range(-1, 1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2/80"); >;
	float g_flBevelCurve3 < Range(-1, 1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3/80"); >;
	float2 g_vBevelLayerAmount2 < Default2(1, 1); UiType(VectorText); UiGroup("Blend Effects/Bevel Layer 2/90"); >;
	float2 g_vBevelLayerAmount3 < Default2(1, 1); UiType(VectorText); UiGroup("Blend Effects/Bevel Layer 3/90"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Wetness
	bool g_bWetnessUseHeightmapAdjustments < UiType(CheckBox); UiGroup("Wetness/2"); UiVisibility(F_WETNESS || 0); >;
	bool g_bPuddlesOnVerticalSurfaces < UiType(CheckBox); UiGroup("Wetness,9/3"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleStrength < Default(1); UiType(Slider); UiGroup("Wetness/5"); UiVisibility(F_WETNESS || 0); >;
	float3 g_vPuddleSedimentColor < Default3(0.62, 0.56, 0.5); UiType(Color); UiGroup("Wetness/10"); Expression(SrgbGammaToLinear(this)); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleSedimentHeight < Default(0.9); Range(0, 2); UiType(Slider); UiGroup("Wetness/15"); Expression((this*2)-1); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleSedimentOpacity < Default(0.25); UiType(Slider); UiGroup("Wetness/16"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleRoughness < Default(0.02); UiType(Slider); UiGroup("Wetness/17"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleBlendSoftness < Default(0.08); UiType(Slider); UiGroup("Wetness/18"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeStrength < Default(0.5); UiType(Slider); UiGroup("Wetness/20"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeSpread < Default(0.2); UiType(Slider); UiGroup("Wetness/25"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetnessStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/30"); UiVisibility(F_WETNESS || 0); >;
	float g_fRainStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/35"); UiVisibility(F_WETNESS || 0); >;
	float g_fRippleStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/40"); UiVisibility(F_WETNESS || 0); >;
	
	// Occlusion Culling
	float g_flOcclusionCullingBoundsScale < Default(1); Range(1, 100); UiType(Slider); UiGroup("Occlusion Culling"); UiVisibility(F_OCCLUSION_CULLING_BOUNDS_SCALE); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 1)
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 5 (name: g_vBiplanarTexCoordScale) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (84948 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	#extension GL_KHR_shader_subgroup_arithmetic : require
	
	struct anon_g_mTextureColorAdjust1
	{
	    vec4 _m0[4];
	};
	
	const vec3 _330[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _2154[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
	struct _84
	{
	    vec4 _m0[3];
	};
	
	struct _295
	{
	    vec4 _m0[4];
	};
	
	struct _85
	{
	    vec4 _m0[3];
	};
	
	struct _2714
	{
	    anon_g_mTextureColorAdjust1 _m0[4];
	};
	
	struct _2945
	{
	    anon_g_mTextureColorAdjust1 _m0;
	    anon_g_mTextureColorAdjust1 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    vec3 _m6;
	    uint _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    float _m11;
	    float _m12;
	    uint _m13;
	    int _m14;
	    _85 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	    anon_g_mTextureColorAdjust1 _m23;
	};
	
	float _4;
	vec3 _5;
	vec3 _6;
	vec2 _7;
	vec4 _14;
	
	struct _3002
	{
	    uint g_sTrilinearWrap;
	    uint g_sTrilinearClamp;
	    uint g_sPointClamp;
	    uint g_sUserConfig;
	    uint g_tColor1;
	    vec3 g_vBiplanarTexCoordScale;
	    int g_bSnowLayer1;
	    int g_nUVSet1;
	    vec2 g_vTexCoordScale1;
	    vec4 g_vNormalXform_1;
	    float g_flWetnessDarkeningStrength1;
	    float g_flBlendSoftness2;
	    int g_bSnowLayer2;
	    int g_nUVSet2;
	    vec2 g_vTexCoordScale2;
	    vec4 g_vNormalXform_2;
	    float g_flWetnessDarkeningStrength2;
	    uint g_tNormal1;
	    uint g_tHeight1;
	    float g_fTintMaskContrast1;
	    float g_fTintMaskBrightness1;
	    vec3 g_vAmbientOcclusionLevels1;
	    int g_bAdjustBaseColor1;
	    float g_flHeightMapScale1;
	    float g_flHeightMapZeroPoint1;
	    int g_bVertexColorEnabled1;
	    int g_bMaskVertexColor1;
	    float g_fTextureRoughnessContrast1;
	    float g_fTextureRoughnessBrightness1;
	    float g_fTextureNormalContrast1;
	    int g_bMetalness1;
	    int g_bModelTint1;
	    anon_g_mTextureColorAdjust1 g_mTextureColorAdjust1;
	    anon_g_mTextureColorAdjust1 g_mTextureAdjust1;
	    float g_flBlendSoftnessDistanceModifierStrength;
	    float g_flColorReplace2;
	    float g_flColorOverlay2;
	    float g_flNormalReplace2;
	    float g_flNormalCombine2;
	    float g_flRoughnessReplace2;
	    float g_flRoughnessCombine2;
	    float g_flMetalnessReplace2;
	    float g_flMetalnessCombine2;
	    float g_flAOReplace2;
	    float g_flAOCombine2;
	    float g_fTextureRoughnessContrast2;
	    float g_fTextureRoughnessBrightness2;
	    float g_fTextureNormalContrast2;
	    int g_bMetalness2;
	    float g_fTintMaskContrast2;
	    float g_fTintMaskBrightness2;
	    uint g_tColor2;
	    uint g_tNormal2;
	    uint g_tHeight2;
	    vec3 g_vAmbientOcclusionLevels2;
	    int g_bAdjustBaseColor2;
	    anon_g_mTextureColorAdjust1 g_mTextureColorAdjust2;
	    anon_g_mTextureColorAdjust1 g_mTextureAdjust2;
	    float g_flHeightMapScale2;
	    float g_flHeightMapZeroPoint2;
	    float g_flMaskWithHeight2;
	    vec3 g_vFacingDirection2;
	    float g_flFacingDirectionMaskSpread2;
	    float g_vFacingDirectionMaskNormalMapStrength2;
	    float g_vFacingDirectionMaskSoftness2;
	    int g_bVertexColorEnabled2;
	    int g_bMaskVertexColor2;
	    int g_bModelTint2;
	    int g_bPuddlesOnVerticalSurfaces;
	    int g_bWetnessUseHeightmapAdjustments;
	    float g_fPuddleStrength;
	    vec3 g_vPuddleSedimentColor;
	    float g_fPuddleSedimentHeight;
	    float g_fPuddleSedimentOpacity;
	    float g_fPuddleRoughness;
	    float g_fPuddleBlendSoftness;
	    float g_fWetEdgeStrength;
	    float g_fWetEdgeSpread;
	    float g_fWetnessStrength;
	    float g_fRainStrength;
	    float g_fRippleStrength;
	    uint g_sCookieSampler;
	    uint g_tShadowDepthBufferCmpSampler;
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    int bBlendByFacingDirection2;
	    int g_bWetness;
	    int bBiplanarUsedAny;
	};
	
	layout(set = 1) uniform _3002 _Globals_;
	
	struct _2063
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	    float _m8;
	    float _m9;
	    float _m10;
	    float _m11;
	    float _m12;
	    anon_g_mTextureColorAdjust1 _m13;
	    vec2 _m14;
	    float _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    anon_g_mTextureColorAdjust1 _m22;
	    vec4 _m23;
	    vec4 _m24;
	    vec4 _m25;
	};
	
	layout(set = 1) uniform _2063 PerViewConstantBufferCsgo_t;
	
	struct _1263
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    vec3 _m4;
	};
	
	layout(set = 1) uniform _1263 PerViewConstantBuffer_t;
	
	struct _1224
	{
	    _84 _m0;
	    _295 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    uvec4 _m5;
	    uvec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    int _m11;
	    float _m12;
	    vec4 _m13;
	    float _m14;
	    float _m15;
	    float _m16;
	    float _m17;
	    _2714 _m18;
	    _295 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _1224 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    _2945 _m0[];
	} g_BarnLights_1;
	
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler undetermined[2048];
	layout(set = 4, binding = 29) uniform samplerShadow undetermined_1[2048];
	layout(set = 4, binding = 46) uniform texture3D g_bindless_Texture3D_float4[65536];
	layout(set = 4, binding = 46) uniform textureCubeArray g_bindless_TextureCubeArray_float4[65536];
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube_float4[65536];
	
	layout(location = 0) in vec4 input_0;
	layout(location = 1) in vec4 input_1;
	layout(location = 2) in vec3 input_2;
	layout(location = 3) in vec3 input_3;
	layout(location = 4) in vec4 input_4;
	layout(location = 5) centroid in vec4 input_5;
	layout(location = 6) centroid in vec3 input_6;
	layout(location = 7) in vec4 input_7;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    _11408.w = 1.0 / _11408.w;
	    float _10136 = clamp((input_0.x * 1.10000002384185791015625) - 0.0500000007450580596923828125, 0.0, 1.0);
	    float _20519 = clamp((input_0.y * 1.10000002384185791015625) - 0.0500000007450580596923828125, 0.0, 1.0);
	    vec3 _18843 = normalize(vec3(clamp((1.0 - _10136) - _20519, 0.0, 1.0), _10136, _20519));
	    vec3 _21709;
	    if (dot(input_3.xyz, input_3.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_6.xyz;
	    }
	    else
	    {
	        _21709 = input_3.xyz;
	    }
	    bool _14874 = _Globals_.g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec3 _10251;
	    if (_12885)
	    {
	        _10251 = _21709 * (gl_FrontFacing ? 1.0 : (-1.0));
	    }
	    else
	    {
	        _10251 = _21709;
	    }
	    vec3 _24347 = normalize(_10251);
	    vec3 _10061 = input_2 + PerViewConstantBufferCsgo_t._m25.xyz;
	    vec2 _6616;
	    ivec2 _13136;
	    vec2 _13694;
	    ivec2 _16305;
	    vec2 _17114;
	    vec2 _17115;
	    vec2 _17116;
	    vec2 _17117;
	    vec2 _17118;
	    if (_Globals_.bBiplanarUsedAny != 0)
	    {
	        vec3 _10577 = abs(_24347);
	        vec3 _16100 = _10577;
	        float _17349 = _10577.x;
	        float _8043 = _10577.y;
	        bool _12886;
	        if (_17349 > _8043)
	        {
	            _12886 = _17349 > _10577.z;
	        }
	        else
	        {
	            _12886 = false;
	        }
	        ivec3 _23727;
	        if (_12886)
	        {
	            _23727 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            _23727 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_8043 > _10577.z));
	        }
	        bool _12887;
	        if (_17349 < _8043)
	        {
	            _12887 = _17349 < _10577.z;
	        }
	        else
	        {
	            _12887 = false;
	        }
	        ivec3 _11775;
	        if (_12887)
	        {
	            _11775 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            _11775 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_8043 < _10577.z));
	        }
	        ivec3 _19442 = (ivec3(3) - _11775) - _23727;
	        ivec2 _19321;
	        if (_23727.x == 1)
	        {
	            _19321 = _23727.zy;
	        }
	        else
	        {
	            _19321 = _23727.yz;
	        }
	        int _9992 = _19442.x;
	        ivec2 _19322;
	        if (_9992 == 1)
	        {
	            _19322 = _19442.zy;
	        }
	        else
	        {
	            _19322 = _19442.yz;
	        }
	        vec3 _18781 = _10061 * _Globals_.g_vBiplanarTexCoordScale.xyz;
	        vec3 _16418 = _18781;
	        vec3 _16419 = dFdxFine(_18781);
	        vec3 _16446 = dFdyFine(_18781);
	        _13136 = _19321;
	        _16305 = _19322;
	        _17114 = vec2(_16100[_23727.x], _16100[_9992]) / vec2(_16100[_23727.x] + _16100[_9992]);
	        _17115 = vec2(_16446[_19322.x], _16446[_19322.y]);
	        _17116 = vec2(_16419[_19322.x], _16419[_19322.y]);
	        _17117 = vec2(_16418[_19322.x], _16418[_19322.y]);
	        _17118 = vec2(_16446[_19321.x], _16446[_19321.y]);
	        _13694 = vec2(_16419[_19321.x], _16419[_19321.y]);
	        _6616 = vec2(_16418[_19321.x], _16418[_19321.y]);
	    }
	    else
	    {
	        _13136 = ivec2(0);
	        _16305 = ivec2(0);
	        _17114 = vec2(0.0);
	        _17115 = vec2(0.0);
	        _17116 = vec2(0.0);
	        _17117 = vec2(0.0);
	        _17118 = vec2(0.0);
	        _13694 = vec2(0.0);
	        _6616 = vec2(0.0);
	    }
	    bool _17559 = _Globals_.g_nUVSet1 > 1;
	    vec2 _21710;
	    if (_17559)
	    {
	        _21710 = input_4.xy;
	    }
	    else
	    {
	        _21710 = vec2(0.0);
	    }
	    bool _17560 = _Globals_.g_nUVSet2 > 1;
	    vec2 _22864;
	    if (_17560)
	    {
	        _22864 = input_4.zw;
	    }
	    else
	    {
	        _22864 = _21710;
	    }
	    vec3 _22993 = _10061 - PerViewConstantBuffer_t._m4.xyz;
	    bool _12888;
	    if (_14874)
	    {
	        _12888 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12888 = false;
	    }
	    bool _18545;
	    if (_12888)
	    {
	        _18545 = (gl_FrontFacing ? 1.0 : (-1.0)) < 0.0;
	    }
	    else
	    {
	        _18545 = false;
	    }
	    vec3 _7147 = dFdxFine(_22993);
	    vec3 _20949 = dFdyFine(_22993);
	    float _12157 = 1.0 / length(input_3);
	    vec3 _11587 = input_3 * _12157;
	    vec3 _9521 = input_7.xyz * _12157;
	    vec3 _15323 = (cross(input_3, input_7.xyz) * ((input_7.w > 0.0) ? 1.0 : (-1.0))) * _12157;
	    vec3 _8889;
	    if (_18545)
	    {
	        _8889 = _11587 * (-1.0);
	    }
	    else
	    {
	        _8889 = _11587;
	    }
	    vec3 _10020;
	    vec3 _22186;
	    if (_17560 ? true : _17559)
	    {
	        vec2 _20627 = dFdxFine(_22864);
	        vec2 _18145 = dFdyFine(_22864);
	        float _17522 = _18145.y;
	        float _15279 = dot(_20627, vec2(_17522, -_18145.x));
	        float _17298 = (_15279 < 0.0) ? (-1.0) : 1.0;
	        vec2 _24530 = vec2(_17522, -_20627.y) * _17298;
	        vec3 _7463 = ((_7147 - (_8889 * dot(_7147, _8889))) * _24530.x) + ((_20949 - (_8889 * dot(_20949, _8889))) * _24530.y);
	        vec3 _9082;
	        if (abs(_15279) > 0.0)
	        {
	            _9082 = normalize(_7463);
	        }
	        else
	        {
	            _9082 = _7463;
	        }
	        _10020 = _9082;
	        _22186 = cross(_8889, _9082) * (_17298 * float((dot(_20949, cross(_8889, _7147)) < 0.0) ? (-1) : 1));
	    }
	    else
	    {
	        _10020 = _5;
	        _22186 = _5;
	    }
	    vec3 _18905;
	    _18905.x = input_4.x;
	    _18905.y = input_4.y;
	    bool _23685 = _Globals_.g_nUVSet1 == 0;
	    vec4 _21711;
	    if (_23685)
	    {
	        _21711 = vec4(0.0);
	    }
	    else
	    {
	        _21711 = vec4(dFdx(_18905.xy), dFdy(_18905.xy));
	    }
	    vec2 _13137;
	    vec2 _13998;
	    vec2 _16306;
	    vec2 _17119;
	    vec2 _17120;
	    vec2 _17121;
	    vec2 _17122;
	    vec4 _23299;
	    if (_23685)
	    {
	        vec2 _19978 = _6616 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _21750 = _13694 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _22329 = _17118 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _22330 = _17117 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _21037 = _17116 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _13654 = _17115 * _Globals_.g_vTexCoordScale1.xy;
	        vec4 _11487 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _19978.xy, _21750.xy, _22329.xy);
	        vec4 _19697 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _22330.xy, _21037.xy, _13654.xy);
	        vec2 _10640 = (_17114 * 3.0) + vec2(_11487.x, _19697.x);
	        vec2 _20211 = max(_10640 - vec2(max(_10640.x, _10640.y) - 0.0500000007450580596923828125), vec2(0.0));
	        vec2 _18088 = _20211 / vec2(_20211.x + _20211.y);
	        _13137 = _19978;
	        _16306 = _22330;
	        _17119 = _21750;
	        _17120 = _22329;
	        _17121 = _21037;
	        _17122 = _13654;
	        _13998 = _18088;
	        _23299 = (_11487 * _18088.x) + (_19697 * _18088.y);
	    }
	    else
	    {
	        _13137 = _6616;
	        _16306 = _17117;
	        _17119 = _13694;
	        _17120 = _17118;
	        _17121 = _17116;
	        _17122 = _17115;
	        _13998 = _17114;
	        _23299 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _18905.xy).xyzw;
	    }
	    bool _14876 = _Globals_.g_bWetnessUseHeightmapAdjustments != 0;
	    float _21712;
	    if (_14876)
	    {
	        _21712 = max(0.0, ((_23299.x + 0.5) - _Globals_.g_flHeightMapZeroPoint1) * _Globals_.g_flHeightMapScale1);
	    }
	    else
	    {
	        _21712 = _23299.x;
	    }
	    vec2 _6383 = textureQueryLod(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _18905.xy);
	    float _16356 = _6383.x;
	    float _19275 = fwidth(_23299.x * _Globals_.g_flHeightMapScale1);
	    float _16609 = ((((_16356 * _16356) * (0.012500000186264514923095703125 + _19275)) * 0.0199999995529651641845703125) * _Globals_.g_flBlendSoftnessDistanceModifierStrength) * _18843.x;
	    float _16883 = max(min(input_0.w + _Globals_.g_flBlendSoftness2, 1.0), 9.9999997473787516355514526367188e-05) + _16609;
	    float _20768 = _Globals_.g_flHeightMapZeroPoint1 + (_16609 * 0.5);
	    float _6379 = _Globals_.g_flHeightMapScale1 + _16883;
	    float _20609 = (_23299.x - _20768) * _6379;
	    vec3 _6618;
	    vec3 _13139;
	    float _13695;
	    vec4 _16307;
	    if (_23685)
	    {
	        vec2 _21820 = (_13137 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _17053 = (_17119 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _8904 = (_17120 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec4 _23805 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _21820, _17053, _8904) * _13998.x;
	        vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _21820, _17053, _8904);
	        float _18178 = _12167.z * _13998.x;
	        float _15456 = _12167.x;
	        float _24534 = _12167.y;
	        float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	        float _11177 = _15456 - _24534;
	        vec3 _12920 = (normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _13998.x) * _Globals_.g_fTextureNormalContrast1;
	        vec3 _24466 = (_330[_13136.x] * _12920.x) + (_2154[_13136.y] * _12920.y);
	        vec4 _13138;
	        vec3 _13753;
	        float _14101;
	        if (_13998.y > 0.0)
	        {
	            vec2 _17048 = (_16306 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _10018 = (_17121 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _8905 = (_17122 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _17048, _10018, _8905);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _12921 = (normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _13998.y) * _Globals_.g_fTextureNormalContrast1;
	            _13138 = _23805 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _17048, _10018, _8905) * _13998.y);
	            _14101 = _18178 + (_12168.z * _13998.y);
	            _13753 = _24466 + ((_330[_16305.x] * _12921.x) + (_2154[_16305.y] * _12921.y));
	        }
	        else
	        {
	            _13138 = _23805;
	            _14101 = _18178;
	            _13753 = _24466;
	        }
	        _13139 = normalize(_13753 + _24347);
	        _16307 = _13138;
	        _13695 = _14101;
	        _6618 = vec3(0.0);
	    }
	    else
	    {
	        vec4 _11179 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _18905.xy, _21711.xy, _21711.zw);
	        float _6493 = _11179.x;
	        float _14881 = _11179.y;
	        float _16783 = (_6493 + _14881) - 1.00392162799835205078125;
	        float _11176 = _6493 - _14881;
	        vec3 _16359 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	        vec2 _21650 = _16359.xy * _Globals_.g_fTextureNormalContrast1;
	        vec3 _8673 = _16359;
	        _8673.x = _21650.x;
	        _8673.y = _21650.y;
	        _13139 = vec3(0.0);
	        _16307 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _18905.xy, _21711.xy, _21711.zw).xyzw;
	        _13695 = _11179.z;
	        _6618 = _8673;
	    }
	    vec3 _11659;
	    if (_23685)
	    {
	        _11659 = _13139;
	    }
	    else
	    {
	        float _7796 = dot(_6618.xy, _Globals_.g_vNormalXform_1.xy);
	        float _19701 = dot(_6618.xy, _Globals_.g_vNormalXform_1.zw);
	        vec3 _19582 = _6618;
	        _19582.x = _7796;
	        _19582.y = _19701;
	        bvec3 _20662 = bvec3(_17559);
	        vec3 _10844 = abs(_19582.xyz);
	        vec2 _16475 = (-vec2(_7796, (-1.0) * _19701)) / vec2(max(_10844.z, 0.0078125 * max(_10844.x, _10844.y)));
	        _11659 = normalize(_8889 - ((mix(_9521, _10020, _20662) * _16475.x) + (mix(_15323, _22186, _20662) * _16475.y)));
	    }
	    float _7812 = clamp(((_Globals_.g_fTextureRoughnessContrast1 * (_13695 - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness1, 0.0, 1.0);
	    vec4 _22411 = vec4(_16307.xyz, 1.0);
	    vec4 _22163 = mix(_16307, vec4((_22411 * mat4(vec4(_Globals_.g_mTextureAdjust1._m0[0].x, _Globals_.g_mTextureAdjust1._m0[1].x, _Globals_.g_mTextureAdjust1._m0[2].x, _Globals_.g_mTextureAdjust1._m0[3].x), vec4(_Globals_.g_mTextureAdjust1._m0[0].y, _Globals_.g_mTextureAdjust1._m0[1].y, _Globals_.g_mTextureAdjust1._m0[2].y, _Globals_.g_mTextureAdjust1._m0[3].y), vec4(_Globals_.g_mTextureAdjust1._m0[0].z, _Globals_.g_mTextureAdjust1._m0[1].z, _Globals_.g_mTextureAdjust1._m0[2].z, _Globals_.g_mTextureAdjust1._m0[3].z), vec4(_Globals_.g_mTextureAdjust1._m0[0].w, _Globals_.g_mTextureAdjust1._m0[1].w, _Globals_.g_mTextureAdjust1._m0[2].w, _Globals_.g_mTextureAdjust1._m0[3].w))).xyz, _16307.w), bvec4(_Globals_.g_bAdjustBaseColor1 != 0));
	    float _10048 = clamp(mix(_Globals_.g_vAmbientOcclusionLevels1.x, _Globals_.g_vAmbientOcclusionLevels1.z, pow(_22163.w, _Globals_.g_vAmbientOcclusionLevels1.y)), 0.0, 1.0);
	    float _9068 = _23299.w * float(_Globals_.g_bMetalness1 != 0);
	    float _24803 = clamp(((_Globals_.g_fTintMaskContrast1 * (_23299.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness1, 0.0, 1.0);
	    vec3 _25172 = mix(_22163.xyz, vec4((_22411 * mat4(vec4(_Globals_.g_mTextureColorAdjust1._m0[0].x, _Globals_.g_mTextureColorAdjust1._m0[1].x, _Globals_.g_mTextureColorAdjust1._m0[2].x, _Globals_.g_mTextureColorAdjust1._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].y, _Globals_.g_mTextureColorAdjust1._m0[1].y, _Globals_.g_mTextureColorAdjust1._m0[2].y, _Globals_.g_mTextureColorAdjust1._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].z, _Globals_.g_mTextureColorAdjust1._m0[1].z, _Globals_.g_mTextureColorAdjust1._m0[2].z, _Globals_.g_mTextureColorAdjust1._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].w, _Globals_.g_mTextureColorAdjust1._m0[1].w, _Globals_.g_mTextureColorAdjust1._m0[2].w, _Globals_.g_mTextureColorAdjust1._m0[3].w))).xyz, _4).xyz, vec3(_24803));
	    vec4 _12345 = vec4(_25172, _10048);
	    float _24323 = dot(_12345.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(input_1.xyz, vec3(0.001000000047497451305389404296875)));
	    float _21159 = dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _24175 = max(input_1.x, max(input_1.y, input_1.z));
	    vec3 _23405 = vec4(clamp(mix(_12345.xyz, (_9577 * min(_24323 / _21159, (3.0 * _24323) * _24175)).xyz, vec3((input_1.w * _24803) * float(_Globals_.g_bModelTint1 != 0))), vec3(0.0), vec3(1.0)).xyz, _10048).xyz;
	    vec2 _22927;
	    _22927.x = _7812;
	    float _7406 = float(_Globals_.g_bSnowLayer1 != 0);
	    vec3 _18906;
	    _18906.x = input_4.z;
	    _18906.y = input_4.w;
	    bool _23686 = _Globals_.g_nUVSet2 == 0;
	    vec4 _21713;
	    if (_23686)
	    {
	        _21713 = vec4(0.0);
	    }
	    else
	    {
	        _21713 = vec4(dFdx(_18906.xy), dFdy(_18906.xy));
	    }
	    vec2 _13140;
	    vec2 _13999;
	    vec2 _16308;
	    vec2 _17123;
	    vec2 _17124;
	    vec2 _17125;
	    vec2 _17126;
	    vec4 _23300;
	    if (_23686)
	    {
	        vec2 _19980 = _13137 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _21753 = _17119 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _22333 = _17120 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _22335 = _16306 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _21304 = _17121 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _11575 = _17122 * _Globals_.g_vTexCoordScale2.xy;
	        vec4 _11488 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _19980.xy, _21753.xy, _22333.xy);
	        vec4 _19698 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _22335.xy, _21304.xy, _11575.xy);
	        vec2 _10641 = (_13998 * 3.0) + vec2(_11488.x, _19698.x);
	        vec2 _20212 = max(_10641 - vec2(max(_10641.x, _10641.y) - 0.0500000007450580596923828125), vec2(0.0));
	        vec2 _18089 = _20212 / vec2(_20212.x + _20212.y);
	        _13140 = _19980;
	        _16308 = _22335;
	        _17123 = _21753;
	        _17124 = _22333;
	        _17125 = _21304;
	        _17126 = _11575;
	        _13999 = _18089;
	        _23300 = (_11488 * _18089.x) + (_19698 * _18089.y);
	    }
	    else
	    {
	        _13140 = _13137;
	        _16308 = _16306;
	        _17123 = _17119;
	        _17124 = _17120;
	        _17125 = _17121;
	        _17126 = _17122;
	        _13999 = _13998;
	        _23300 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _18906.xy).xyzw;
	    }
	    float _19287;
	    if (_14876)
	    {
	        _19287 = max(0.0, ((_23300.x + 0.5) - _Globals_.g_flHeightMapZeroPoint2) * _Globals_.g_flHeightMapScale2);
	    }
	    else
	    {
	        _19287 = _23300.x;
	    }
	    vec2 _6384 = textureQueryLod(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _18906.xy);
	    float _16357 = _6384.x;
	    float _19276 = fwidth(_23300.x * _Globals_.g_flHeightMapScale2);
	    float _17651 = _16609 + (((((_16357 * _16357) * (0.012500000186264514923095703125 + _19276)) * 0.0199999995529651641845703125) * _Globals_.g_flBlendSoftnessDistanceModifierStrength) * _18843.y);
	    float _24336 = _16883 + _17651;
	    float _20769 = _Globals_.g_flHeightMapZeroPoint2 + (_17651 * 0.5);
	    float _6380 = _Globals_.g_flHeightMapScale2 + _24336;
	    float _11621;
	    if (_Globals_.bBlendByFacingDirection2 != 0)
	    {
	        _11621 = _10136 * clamp((((dot(_Globals_.g_vFacingDirection2.xyz, mix(_24347.xyz, _11659.xyz, vec3(_Globals_.g_vFacingDirectionMaskNormalMapStrength2)).xyz) - 1.0) + (_Globals_.g_flFacingDirectionMaskSpread2 * 2.0)) / (_Globals_.g_vFacingDirectionMaskSoftness2 * 2.0)) + 0.5, 0.0, 1.0);
	    }
	    else
	    {
	        _11621 = _10136;
	    }
	    float _6994 = ((_23300.x - _20769) * (_6380 - (_24336 * 2.0))) + mix((((-_20768) * _6379) - ((1.0 - _20769) * _6380)) - _24336, ((1.0 - _20768) * _6379) - ((-_20769) * _6380), _11621);
	    vec3 _16290;
	    _16290.x = _20609;
	    _16290.y = _6994;
	    vec2 _9007 = max((_16290.xy - vec2(max(_20609, _6994))) + vec2(_24336), vec2(0.0));
	    float _6253 = clamp(((_9007 / vec2((_9007.x + 9.9999997473787516355514526367188e-05) + _9007.y)).y * mix(0.5, _6994, _Globals_.g_flMaskWithHeight2)) * 2.0, 0.0, 1.0);
	    bool _19615 = _6253 > 0.0500000007450580596923828125;
	    float _13143;
	    vec4 _16310;
	    float _16863;
	    vec3 _17127;
	    float _17152;
	    if (_19615)
	    {
	        vec3 _6621;
	        vec3 _13142;
	        float _13698;
	        vec4 _16309;
	        if (_23686)
	        {
	            vec2 _21822 = (_13140 * _Globals_.g_vTexCoordScale2.xy).xy;
	            vec2 _17055 = (_17123 * _Globals_.g_vTexCoordScale2.xy).xy;
	            vec2 _8909 = (_17124 * _Globals_.g_vTexCoordScale2.xy).xy;
	            vec4 _23806 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], undetermined[_Globals_.g_sUserConfig]), _21822, _17055, _8909) * _13999.x;
	            vec4 _12169 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], undetermined[_Globals_.g_sUserConfig]), _21822, _17055, _8909);
	            float _18179 = _12169.z * _13999.x;
	            float _15457 = _12169.x;
	            float _24535 = _12169.y;
	            float _16787 = (_15457 + _24535) - 1.00392162799835205078125;
	            float _11182 = _15457 - _24535;
	            vec3 _12922 = (normalize(vec3(vec2(_16787, _11182), (1.0 - abs(_16787)) - abs(_11182))).xyz * _13999.x) * _Globals_.g_fTextureNormalContrast2;
	            vec3 _24467 = (_330[_13136.x] * _12922.x) + (_2154[_13136.y] * _12922.y);
	            vec4 _13141;
	            vec3 _13754;
	            float _14102;
	            if (_13999.y > 0.0)
	            {
	                vec2 _17050 = (_16308 * _Globals_.g_vTexCoordScale2.xy).xy;
	                vec2 _10021 = (_17125 * _Globals_.g_vTexCoordScale2.xy).xy;
	                vec2 _8910 = (_17126 * _Globals_.g_vTexCoordScale2.xy).xy;
	                vec4 _12170 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], undetermined[_Globals_.g_sUserConfig]), _17050, _10021, _8910);
	                float _13492 = _12170.x;
	                float _21309 = _12170.y;
	                float _16788 = (_13492 + _21309) - 1.00392162799835205078125;
	                float _11183 = _13492 - _21309;
	                vec3 _12923 = (normalize(vec3(vec2(_16788, _11183), (1.0 - abs(_16788)) - abs(_11183))).xyz * _13999.y) * _Globals_.g_fTextureNormalContrast2;
	                _13141 = _23806 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], undetermined[_Globals_.g_sUserConfig]), _17050, _10021, _8910) * _13999.y);
	                _14102 = _18179 + (_12170.z * _13999.y);
	                _13754 = _24467 + ((_330[_16305.x] * _12923.x) + (_2154[_16305.y] * _12923.y));
	            }
	            else
	            {
	                _13141 = _23806;
	                _14102 = _18179;
	                _13754 = _24467;
	            }
	            _13142 = normalize(_13754 + _24347);
	            _16309 = _13141;
	            _13698 = _14102;
	            _6621 = vec3(0.0);
	        }
	        else
	        {
	            vec4 _11180 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], undetermined[_Globals_.g_sUserConfig]), _18906.xy, _21713.xy, _21713.zw);
	            float _6494 = _11180.x;
	            float _14882 = _11180.y;
	            float _16786 = (_6494 + _14882) - 1.00392162799835205078125;
	            float _11181 = _6494 - _14882;
	            vec3 _16364 = normalize(vec3(vec2(_16786, _11181), (1.0 - abs(_16786)) - abs(_11181)));
	            vec2 _21651 = _16364.xy * _Globals_.g_fTextureNormalContrast2;
	            vec3 _8674 = _16364;
	            _8674.x = _21651.x;
	            _8674.y = _21651.y;
	            _13142 = vec3(0.0);
	            _16309 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], undetermined[_Globals_.g_sUserConfig]), _18906.xy, _21713.xy, _21713.zw).xyzw;
	            _13698 = _11180.z;
	            _6621 = _8674;
	        }
	        vec3 _11660;
	        if (_23686)
	        {
	            _11660 = _13142;
	        }
	        else
	        {
	            float _7797 = dot(_6621.xy, _Globals_.g_vNormalXform_2.xy);
	            float _19702 = dot(_6621.xy, _Globals_.g_vNormalXform_2.zw);
	            vec3 _19583 = _6621;
	            _19583.x = _7797;
	            _19583.y = _19702;
	            bvec3 _20663 = bvec3(_17560);
	            vec3 _10845 = abs(_19583.xyz);
	            vec2 _16476 = (-vec2(_7797, (-1.0) * _19702)) / vec2(max(_10845.z, 0.0078125 * max(_10845.x, _10845.y)));
	            _11660 = normalize(_8889 - ((mix(_9521, _10020, _20663) * _16476.x) + (mix(_15323, _22186, _20663) * _16476.y)));
	        }
	        vec4 _21847 = vec4(_16309.xyz, 1.0);
	        vec4 _22164 = mix(_16309, vec4((_21847 * mat4(vec4(_Globals_.g_mTextureAdjust2._m0[0].x, _Globals_.g_mTextureAdjust2._m0[1].x, _Globals_.g_mTextureAdjust2._m0[2].x, _Globals_.g_mTextureAdjust2._m0[3].x), vec4(_Globals_.g_mTextureAdjust2._m0[0].y, _Globals_.g_mTextureAdjust2._m0[1].y, _Globals_.g_mTextureAdjust2._m0[2].y, _Globals_.g_mTextureAdjust2._m0[3].y), vec4(_Globals_.g_mTextureAdjust2._m0[0].z, _Globals_.g_mTextureAdjust2._m0[1].z, _Globals_.g_mTextureAdjust2._m0[2].z, _Globals_.g_mTextureAdjust2._m0[3].z), vec4(_Globals_.g_mTextureAdjust2._m0[0].w, _Globals_.g_mTextureAdjust2._m0[1].w, _Globals_.g_mTextureAdjust2._m0[2].w, _Globals_.g_mTextureAdjust2._m0[3].w))).xyz, _16309.w), bvec4(_Globals_.g_bAdjustBaseColor2 != 0));
	        float _10049 = clamp(mix(_Globals_.g_vAmbientOcclusionLevels2.x, _Globals_.g_vAmbientOcclusionLevels2.z, pow(_22164.w, _Globals_.g_vAmbientOcclusionLevels2.y)), 0.0, 1.0);
	        float _24804 = clamp(((_Globals_.g_fTintMaskContrast2 * (_23300.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness2, 0.0, 1.0);
	        vec3 _25173 = mix(_22164.xyz, vec4((_21847 * mat4(vec4(_Globals_.g_mTextureColorAdjust2._m0[0].x, _Globals_.g_mTextureColorAdjust2._m0[1].x, _Globals_.g_mTextureColorAdjust2._m0[2].x, _Globals_.g_mTextureColorAdjust2._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust2._m0[0].y, _Globals_.g_mTextureColorAdjust2._m0[1].y, _Globals_.g_mTextureColorAdjust2._m0[2].y, _Globals_.g_mTextureColorAdjust2._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust2._m0[0].z, _Globals_.g_mTextureColorAdjust2._m0[1].z, _Globals_.g_mTextureColorAdjust2._m0[2].z, _Globals_.g_mTextureColorAdjust2._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust2._m0[0].w, _Globals_.g_mTextureColorAdjust2._m0[1].w, _Globals_.g_mTextureColorAdjust2._m0[2].w, _Globals_.g_mTextureColorAdjust2._m0[3].w))).xyz, _4).xyz, vec3(_24804));
	        vec4 _23104 = vec4(_25173, _10049);
	        float _16721 = dot(_23104.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        _13143 = _24804;
	        _16310 = vec4(clamp(mix(_23104.xyz, (_9577 * min(_16721 / _21159, (3.0 * _16721) * _24175)).xyz, vec3((input_1.w * _24804) * float(_Globals_.g_bModelTint2 != 0))), vec3(0.0), vec3(1.0)).xyz, _10049);
	        _17127 = _11660;
	        _17152 = _23300.w * float(_Globals_.g_bMetalness2 != 0);
	        _16863 = clamp(((_Globals_.g_fTextureRoughnessContrast2 * (_13698 - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness2, 0.0, 1.0);
	    }
	    else
	    {
	        _13143 = _23300.y;
	        _16310 = vec4(0.0);
	        _17127 = vec3(0.0);
	        _17152 = _23300.w;
	        _16863 = 0.0;
	    }
	    float _13144;
	    vec3 _13381;
	    vec2 _14948;
	    float _16311;
	    float _17129;
	    vec3 _17130;
	    float _17131;
	    if (_19615)
	    {
	        vec3 _18442 = _16310.xyz * 12.9200000762939453125;
	        vec3 _7485 = (pow(_16310.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	        float _21354;
	        if (_16310.x <= 0.003130800090730190277099609375)
	        {
	            _21354 = _18442.x;
	        }
	        else
	        {
	            _21354 = _7485.x;
	        }
	        float _21355;
	        if (_16310.y <= 0.003130800090730190277099609375)
	        {
	            _21355 = _18442.y;
	        }
	        else
	        {
	            _21355 = _7485.y;
	        }
	        float _20653;
	        if (_16310.z <= 0.003130800090730190277099609375)
	        {
	            _20653 = _18442.z;
	        }
	        else
	        {
	            _20653 = _7485.z;
	        }
	        vec2 _11604;
	        _11604.x = mix(_7812 * (1.0 + ((((_16863 - _7812) * 2.0) * _6253) * _Globals_.g_flRoughnessCombine2)), _16863, _6253 * _Globals_.g_flRoughnessReplace2);
	        _13144 = mix(_9068 * mix(1.0, _17152 * 2.0, _6253 * _Globals_.g_flMetalnessCombine2), _17152, _6253 * _Globals_.g_flMetalnessReplace2);
	        _16311 = mix(_7406, float(_Globals_.g_bSnowLayer2 != 0), _6253);
	        _17129 = mix(_10048 * mix(1.0, _16310.w, _6253 * _Globals_.g_flAOCombine2), _16310.w, _6253 * _Globals_.g_flAOReplace2);
	        _17130 = mix(mix(_11659.xyz, normalize(mix(_24347, (_11659.xyz + _17127.xyz) * vec3(0.5), vec3(2.0))), vec3(_6253 * _Globals_.g_flNormalCombine2)), _17127.xyz, vec3((_6253 * clamp((_6994 + _20769) - _20609, 0.0, 1.0)) * _Globals_.g_flNormalReplace2));
	        _17131 = mix(_21712, _19287, _6253);
	        _14948 = _11604;
	        _13381 = mix(_23405 * mix(vec3(1.0), vec3(_21354, _21355, _20653) * 2.0, vec3(_6253 * _Globals_.g_flColorOverlay2)), _16310.xyz, vec3(_6253 * _Globals_.g_flColorReplace2));
	    }
	    else
	    {
	        _13144 = _9068;
	        _16311 = _7406;
	        _17129 = _10048;
	        _17130 = _11659.xyz;
	        _17131 = _21712;
	        _14948 = _22927;
	        _13381 = _23405;
	    }
	    float _13984 = saturate(1.0 - _6253);
	    vec3 _14081 = _13381 * mix(vec3(1.0), input_5.xyz, vec3(clamp(clamp(((float(!(_Globals_.g_bMaskVertexColor1 != 0)) * _13984) + (float(!(_Globals_.g_bMaskVertexColor2 != 0)) * _6253)) + ((_24803 * _13984) + (_13143 * _6253)), 0.0, 1.0) * ((float(_Globals_.g_bVertexColorEnabled1 != 0) * _13984) + (float(_Globals_.g_bVertexColorEnabled2 != 0) * _6253)), 0.0, 1.0)));
	    vec2 _23398 = vec2(_14948.x);
	    bool _12889;
	    if (_Globals_.g_bWetness != 0)
	    {
	        _12889 = (_Globals_.g_fPuddleStrength + _Globals_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _12889 = false;
	    }
	    float _12727;
	    vec3 _13147;
	    vec2 _16312;
	    float _17133;
	    vec3 _17134;
	    float _17135;
	    vec3 _18774;
	    if (_12889)
	    {
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14498 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_0.z, saturate(PerViewConstantBufferCsgo_t._m11)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m12 - 0.5) * 2.0));
	        float _18408 = saturate(_23204 - 0.75) * 2.0;
	        float _8285 = _23204 + (_18408 * _18408);
	        float _16777 = _8285 - _Globals_.g_fWetEdgeSpread;
	        float _11964 = saturate(_8285 * 20.0);
	        vec4 _9716;
	        float _24878;
	        if (_Globals_.g_bPuddlesOnVerticalSurfaces != 0)
	        {
	            vec4 _9186 = vec4(0.0, 0.0, 1.0, 0.0);
	            _9186.x = _24347.x;
	            _9186.y = _24347.y;
	            _9186.z = _21302;
	            _9716 = _9186;
	            _24878 = max(0.0, _16777);
	        }
	        else
	        {
	            _9716 = vec4(0.0, 0.0, 1.0, 0.0);
	            _24878 = max(0.0, (_8285 * _14498) - _Globals_.g_fWetEdgeSpread);
	        }
	        float _16799 = max(0.001000000047497451305389404296875, _Globals_.g_fPuddleBlendSoftness);
	        float _14611 = smoothstep(_24878 + _16799, _24878 - (input_0.w + (_16799 * 2.0)), _17131) * _11964;
	        float _19808 = max((smoothstep(_23204, _16777 - (0.20000000298023223876953125 * _8285), _17131) * _Globals_.g_fWetEdgeStrength) * _11964, _14611) * _Globals_.g_fPuddleStrength;
	        float _17924 = (_23204 - 1.0) - _17131;
	        float _10334 = (saturate(_17924 + _Globals_.g_fPuddleSedimentHeight) * _Globals_.g_fPuddleSedimentOpacity) * _14611;
	        float _13706 = clamp(((clamp((((_8285 * 2.0) - (mix(0.5, _19372.w, saturate(_14498 * 20.0)) * 0.5)) - (_17131 * 0.5)) + 0.25, 0.0, 1.0) * _Globals_.g_fWetnessStrength) * _11964) + _14611, 0.0, 1.0);
	        float _13146;
	        float _13151;
	        vec4 _23607;
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m9;
	            vec3 _6622;
	            vec4 _12890;
	            float _13145;
	            if (_12497 > 0.0)
	            {
	                vec3 _18756 = normalize(vec3(-1.0, 0.20000000298023223876953125, 0.0));
	                float _9927 = PerViewConstantBufferCsgo_t._m10 * 6.283185482025146484375;
	                float _22373 = sin(_9927);
	                float _20617 = cos(_9927);
	                vec2 _23932 = _18756.xy * mat2(vec2(_20617, -_22373), vec2(_22373, _20617));
	                vec3 _22900 = _18756;
	                _22900.x = _23932.x;
	                _22900.y = _23932.y;
	                vec3 _21326 = -cross(_22900, _24347);
	                vec3 _13887 = _10061.xyz;
	                float _9965 = dot(_13887, _21326);
	                float _12056 = 1.0 - input_0.z;
	                vec2 _20274 = ((vec2(dot(_13887, _22900)) + (vec2(0.100000001490116119384765625, -0.100000001490116119384765625) * _9965)) + (vec2(8.0, 5.0) * _10061.z)) + vec2((_12056 * _12056) * (-80.0));
	                vec2 _15991 = vec2(_20274.x, _9965) * vec2(0.0199999995529651641845703125, 0.010999999940395355224609375);
	                vec4 _15054 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                float _18070 = clamp(length(fwidth(_15991)) * 10.0, 0.0, 1.0);
	                vec2 _18922 = (_15054.xy * 2.0) - vec2(1.0);
	                vec2 _10456 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_0.z) * mix(1.0, 0.300000011920928955078125, _18070);
	                vec2 _13712 = _21326.xy;
	                vec4 _19601 = vec4(0.0);
	                _19601.x = dot(_22900.xy, _10456);
	                _19601.y = dot(_13712, _10456);
	                vec2 _16048 = (vec2(_20274.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _15055 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_16048 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                float _9251 = clamp(length(fwidth(_16048)) * 10.0, 0.0, 1.0);
	                vec2 _9825 = ((((_15055.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_0.z) * mix(1.0, 0.300000011920928955078125, _9251);
	                _9825.y = _9825.y * 0.5;
	                vec2 _13330 = _19601.xy + vec2(dot(_22900.xy, _9825), dot(_13712, _9825));
	                vec4 _20488 = _19601;
	                _20488.x = _13330.x;
	                _20488.y = _13330.y;
	                _20488.w = input_0.z * (_15054.z + _15055.z);
	                vec3 _20489;
	                _20489.x = _10061.x;
	                _20489.y = _10061.y;
	                _13145 = _12497 * (0.039999999105930328369140625 * (_18070 + _9251));
	                _12890 = _9716 + ((_20488 * _14498) * _12497);
	                _6622 = _20489;
	            }
	            else
	            {
	                _13145 = 0.0;
	                _12890 = _9716;
	                _6622 = _10061;
	            }
	            float _8914 = (_Globals_.g_fRainStrength * PerViewConstantBufferCsgo_t._m8) * PerViewConstantBufferCsgo_t._m8;
	            float _9982;
	            vec4 _21594;
	            if (_8914 > 0.0)
	            {
	                vec2 _10473 = _6622.xy * 0.119999997317790985107421875;
	                vec3 _20506 = vec3(PerViewConstantBuffer_t._m0 * 6.5) + vec3(0.0, 0.3167000114917755126953125, 0.633400022983551025390625);
	                vec3 _13155;
	                _13155 = vec3(0.0);
	                int _18440;
	                vec3 _25251;
	                int _16208 = 0;
	                SPIRV_CROSS_UNROLL
	                for (;;)
	                {
	                    if (!(_16208 < 3))
	                    {
	                        break;
	                    }
	                    vec3 _23854 = vec3(0.97130000591278076171875, 0.751800000667572021484375, 0.362399995326995849609375);
	                    vec3 _16408 = vec3(0.23770000040531158447265625, 0.65939998626708984375, 0.931999981403350830078125);
	                    mat2 _21666 = mat2(vec2(_23854[_16208], -_16408[_16208]), vec2(_16408[_16208], _23854[_16208]));
	                    vec3 _16409 = vec3(0.60000002384185791015625, 0.666100025177001953125, 0.73220002651214599609375);
	                    float _23410 = _20506[_16208];
	                    vec2 _10212 = ((_21666 * _10473) * _16409[_16208]) + vec2(_23410 * 0.0199999995529651641845703125);
	                    vec2 _7848 = _21666 * ((fract(_10212) * 2.0) - vec2(1.0));
	                    float _8329 = length(_7848);
	                    float _20173 = clamp(1.0 - (_8329 * mix(3.0, 1.0, _14611)), 0.0, 1.0);
	                    float _20215 = clamp(1.0 - (_8329 * 6.0), 0.0, 1.0);
	                    float _7135 = floor(fract(_10212.x * 0.100000001490116119384765625) * 10.0);
	                    float _23598 = _20506[_16208];
	                    float _18429 = _23598 + ((_7135 + (floor(fract(_10212.y * 0.100000001490116119384765625) * 10.0) * (0.20000000298023223876953125 + _7135))) * 8.0);
	                    _20506[_16208] = _18429;
	                    float _18120 = _8914 * _8914;
	                    _25251 = vec3(_13155.xy + (((-(((((_7848 / vec2(_8329)) * cos(mix(1.0, (_20173 * 40.0) + (PerViewConstantBuffer_t._m0 * 65.0), _14611))) * _20173) * _20173) * mix(2.0, 0.25, clamp(fwidth(_20173) * 20.0, 0.0, 1.0)))) * ((clamp((sin(((_20173 * mix(1.0, 4.0, _14611)) + _18429) * _8914) - (1.0 - ((0.20000000298023223876953125 * _18120) * mix(0.25, 1.0, _14611)))) * 2.0, 0.0, 1.0) * _20173) / _18120)) * mix(16.0, 2.0, _14611)), _13155.z + (((clamp((sin((((_20215 + _18429) + 4.0) + (sin(_17131 * 60.0) * 0.25)) * _8914) - (1.0 - (_18120 * 0.02000000141561031341552734375))) * 2.0, 0.0, 1.0) * _20215) / _18120) * 28.0));
	                    _18440 = _16208 + 1;
	                    _13155 = _25251;
	                    _16208 = _18440;
	                    continue;
	                }
	                vec3 _9348 = _13155 * _14498;
	                vec2 _15752 = _12890.xy + _9348.xy;
	                vec4 _20490 = _12890;
	                _20490.x = _15752.x;
	                _20490.y = _15752.y;
	                _9982 = _9348.z;
	                _21594 = _20490;
	            }
	            else
	            {
	                _9982 = 0.0;
	                _21594 = _12890;
	            }
	            vec3 _10508 = normalize(_21594.xyz);
	            vec4 _16886 = _21594;
	            _16886.x = _10508.x;
	            _16886.y = _10508.y;
	            _16886.z = _10508.z;
	            _13146 = _9982;
	            _13151 = _13145;
	            _23607 = _16886;
	        }
	        else
	        {
	            _13146 = 0.0;
	            _13151 = 0.0;
	            _23607 = _9716;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _13713 = normalize(mix(_17130.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9039 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m12 * 2.0)), _19808);
	        vec3 _18806 = mix(_14081, pow(_14081, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_14081, vec3(0.25)) * (_9039 * _14948.x)) * 8.0, vec3(0.0), vec3(1.0)) * mix(_Globals_.g_flWetnessDarkeningStrength1, _Globals_.g_flWetnessDarkeningStrength2, _6253 * _Globals_.g_flColorReplace2));
	        _13147 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _17129, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, vec3(_10334 * _19808)), vec3(1.0 + _13146), vec3(_13146 * 0.100000001490116119384765625));
	        _16312 = clamp(mix(_23398.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9039)) + vec2(_13151 + (length(fwidth(_13713.xyz)) * 0.5)), vec2(0.0), vec2(1.0));
	        _17133 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9039);
	        _17134 = _13713;
	        _17135 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _12727 = mix(_17129, 1.0, _19808);
	        _18774 = mix(_17130, _23607.xyz, vec3(_19808 * _10334));
	    }
	    else
	    {
	        _13147 = _14081;
	        _16312 = _23398;
	        _17133 = _Globals_.g_flReflectance;
	        _17134 = vec3(1.0);
	        _17135 = 0.0;
	        _12727 = _17129;
	        _18774 = _17130;
	    }
	    float _10796 = max(_12727, 0.0);
	    vec3 _9453 = mix(vec3(_17133).xyz, _13147.xyz, vec3(_13144));
	    vec3 _17892 = mix(_17134, _18774, bvec3(all(equal(_17134, vec3(1.0)))));
	    vec3 _10562 = _24347.xyz;
	    vec3 _11099 = dFdx(_10562);
	    vec3 _9175 = dFdy(_10562);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _21816 = max(_16312.xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    vec3 _15598 = -_24347;
	    vec4 _23875 = vec4(_18774.xyz, 1.0);
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21715;
	    if (_24464.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m15) * PerViewConstantBufferCsgo_t._m14.xy) + (PerViewConstantBufferCsgo_t._m14.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], undetermined[_Globals_.g_sCookieSampler]), _11087).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12020 = _18418.z;
	        bool _12285 = abs(_12020) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m14.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12020 : _18579;
	        float _15372 = _18418.x;
	        bool _12287 = abs(_15372) < _20965;
	        vec2 _23169;
	        if (_12287)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m14.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m2.x * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.y * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.z * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.w * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(clamp(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0), vec4(0.0), vec4(1.0)));
	        _21715 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m3], undetermined[_Globals_.g_sPointClamp]), (_11087 + mix(_23169, PerViewConstantBufferCsgo_t._m14.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21715 = 1.0;
	    }
	    float _21716;
	    if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13148;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	            {
	                _13148 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_2.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].w));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m13[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24805 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - clamp((abs(_24805) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14), vec2(0.0), vec2(1.0));
	                vec2 _20561 = (_24805 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                vec3 _20491 = _19470;
	                _20491.x = _20561.x;
	                _20491.y = _20561.y;
	                _13148 = saturate(_22193.x * _22193.y);
	                _14975 = _20491;
	                _10191 = _13039;
	                break;
	            }
	            _23989 = _13039 + 1;
	            _13039 = _23989;
	            continue;
	        }
	        float _18423;
	        if (_10191 >= 0)
	        {
	            float _18270 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	            float _12501;
	            if (_13148 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_2.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].w));
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15335].xy;
	                    vec3 _20492;
	                    _20492.x = _20562.x;
	                    _20492.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20492.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12501 = mix(_7934, _18270, _13148);
	            }
	            else
	            {
	                _12501 = _18270;
	            }
	            _18423 = _12501;
	        }
	        else
	        {
	            _18423 = 1.0;
	        }
	        float _13279 = mix(_18423, 1.0, clamp((distance(_10061.xyz, PerViewConstantBuffer_t._m4) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16, 0.0, 1.0));
	        float _12502;
	        if (_24464.y)
	        {
	            _12502 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], undetermined[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21716 = _12502;
	    }
	    else
	    {
	        _21716 = 1.0;
	    }
	    vec3 _9717;
	    vec3 _24879;
	    if ((dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _18774.xyz) * _21716) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _18774.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_18774.xyz, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18223;
	        if (_17135 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m9.xyz);
	            float _8124 = saturate(_17135);
	            _18223 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * clamp((_8780 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_18774.xyz, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m9.xyz), 1.0, _8124), 0.0, 1.0)), vec3(_8124));
	        }
	        else
	        {
	            _18223 = _17874;
	        }
	        vec2 _17301 = max(_21816, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, _15460.xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _21716).xyz;
	        _9717 = ((_9453.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
	        _24879 = PerViewLightingConstantBufferGpu_t._m4.xyz + (_18223.xyz * _16808);
	    }
	    else
	    {
	        _9717 = vec3(0.0);
	        _24879 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20059 = _24465.x;
	    vec4 _19363;
	    if (_20059)
	    {
	        vec4 _24262 = vec4(_10061.xyz, 1.0).xyzw * mat4(vec4(PerViewConstantBufferCsgo_t._m13._m0[0].x, PerViewConstantBufferCsgo_t._m13._m0[1].x, PerViewConstantBufferCsgo_t._m13._m0[2].x, PerViewConstantBufferCsgo_t._m13._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m13._m0[0].y, PerViewConstantBufferCsgo_t._m13._m0[1].y, PerViewConstantBufferCsgo_t._m13._m0[2].y, PerViewConstantBufferCsgo_t._m13._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m13._m0[0].z, PerViewConstantBufferCsgo_t._m13._m0[1].z, PerViewConstantBufferCsgo_t._m13._m0[2].z, PerViewConstantBufferCsgo_t._m13._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m13._m0[0].w, PerViewConstantBufferCsgo_t._m13._m0[1].w, PerViewConstantBufferCsgo_t._m13._m0[2].w, PerViewConstantBufferCsgo_t._m13._m0[3].w));
	        float _20176 = _24262.w;
	        vec2 _11414 = _24262.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _11408;
	    }
	    uvec2 _12083 = uvec2(_19363.xy - PerViewConstantBuffer_t._m1.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13152;
	    vec3 _16324;
	    _13152 = _9717;
	    _16324 = _24879;
	    uint _21567;
	    vec3 _13153;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13153 = _13152;
	        _16325 = _16324;
	        uint _20344;
	        vec3 _13212;
	        vec3 _15670;
	        uint _17018 = _14475;
	        for (;;)
	        {
	            if (!(_17018 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(uint(findLSB(_17018)) + (_17017 * 32u));
	            _20344 = _17018 & (_17018 - 1u);
	            do
	            {
	                vec4 _15817 = mat4(vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].x, g_BarnLights_1._m0[_12608]._m0._m0[1].x, g_BarnLights_1._m0[_12608]._m0._m0[2].x, g_BarnLights_1._m0[_12608]._m0._m0[3].x), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].y, g_BarnLights_1._m0[_12608]._m0._m0[1].y, g_BarnLights_1._m0[_12608]._m0._m0[2].y, g_BarnLights_1._m0[_12608]._m0._m0[3].y), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].z, g_BarnLights_1._m0[_12608]._m0._m0[1].z, g_BarnLights_1._m0[_12608]._m0._m0[2].z, g_BarnLights_1._m0[_12608]._m0._m0[3].z), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].w, g_BarnLights_1._m0[_12608]._m0._m0[1].w, g_BarnLights_1._m0[_12608]._m0._m0[2].w, g_BarnLights_1._m0[_12608]._m0._m0[3].w)) * vec4(input_2.xyz, 1.0);
	                vec3 _10521 = _15817.xyz / vec3(_15817.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                vec3 _21642 = _22905.xyz;
	                bool _7424;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7424 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7424 = false;
	                }
	                bool _12891;
	                if (!_7424)
	                {
	                    _12891 = true;
	                }
	                else
	                {
	                    _12891 = !all(lessThanEqual(abs((mat4x3(vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].x, g_BarnLights_1._m0[_12608]._m15._m0[1].x, g_BarnLights_1._m0[_12608]._m15._m0[2].x), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].y, g_BarnLights_1._m0[_12608]._m15._m0[1].y, g_BarnLights_1._m0[_12608]._m15._m0[2].y), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].z, g_BarnLights_1._m0[_12608]._m15._m0[1].z, g_BarnLights_1._m0[_12608]._m15._m0[2].z), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].w, g_BarnLights_1._m0[_12608]._m15._m0[1].w, g_BarnLights_1._m0[_12608]._m15._m0[2].w)) * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12891)
	                {
	                    _13212 = _13153;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23572 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = min(1.0, _21775 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * min(1.0, (1.0 - _21775) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11185;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10022 = g_BarnLights_1._m0[_12608]._m2.xyz - input_2.xyz;
	                    float _18345 = dot(_10022, _10022);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10022 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10022 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _12302 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11185 = _10022 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * clamp(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647), 0.0, 1.0)) * clamp(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))), 0.0, 1.0);
	                }
	                else
	                {
	                    _11185 = g_BarnLights_1._m0[_12608]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12608]._m4.xyz * 1.0).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights_1._m0[_12608]._m8.z > 0.0)
	                {
	                    _24419 = !_20059;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                vec3 _21548;
	                if (g_BarnLights_1._m0[_12608]._m4.w == 0.0)
	                {
	                    float _10342;
	                    do
	                    {
	                        vec2 _22154 = abs(_22905.xy);
	                        if (g_BarnLights_1._m0[_12608]._m9.z == 0.0)
	                        {
	                            _10342 = smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.x, _22154.x) * smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11474 = _22154.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15018 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11474, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11474, _15266) + pow(_15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            if (_11981 < _16524)
	                            {
	                                _10342 = smoothstep(_16524, _11981, 1.0);
	                                break;
	                            }
	                            else
	                            {
	                                _10342 = float(_16524 > 1.0);
	                                break;
	                            }
	                            break; // unreachable workaround
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _21548 = _17828.xyz * _10342;
	                }
	                else
	                {
	                    vec3 _12503;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19009 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19009.xyz;
	                        vec3 _23629 = vec4((-_11185).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19009.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23594 = _17795.xyz;
	                        vec3 _12171 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23594 * _15156)) + cross(_23594, _20479);
	                        vec3 _14082 = vec3(vec2(atan(_12171.y, -_12171.x) * 0.15915493667125701904296875, acos(_12171.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14082.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20494 = _14082;
	                        _20494.x = _20564.x;
	                        _20494.y = _20564.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sTrilinearWrap]), _20494.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20493 = _13791;
	                        _20493.x = _20563.x;
	                        _20493.y = _20563.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sCookieSampler]), _20493.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13153;
	                    _15670 = _16325;
	                    break;
	                }
	                vec3 _21549;
	                if (_24419)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19629 = _23714;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13153;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _21549 = _20482;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15461 = mix(_17892, _18774.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_18774.xyz, _11185.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18232;
	                if (_17135 > 0.0)
	                {
	                    float _8781 = dot(_15461, _11185.xyz);
	                    float _8125 = saturate(_17135);
	                    _18232 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * clamp((_8781 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_18774.xyz, _15461, vec3(10.0)), _11185.xyz), 1.0, _8125), 0.0, 1.0)), vec3(_8125));
	                }
	                else
	                {
	                    _18232 = _17875;
	                }
	                vec2 _17302 = max(_21816, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12283 = normalize(_11185.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	                float _12387 = dot(_12283, _15461.xyz);
	                float _19211 = max(0.0, dot(_11185.xyz, _12283));
	                float _9851 = _17302.x;
	                float _25215 = _9851 * _9851;
	                float _19097 = _25215 * _25215;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13212 = _13153.xyz + (((_9453.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
	                _15670 = _16325.xyz + (_18232.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13153 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13152 = _13153;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21816.xy, vec2(0.5));
	    vec3 _7507 = _17892.xyz;
	    vec3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec4 _15343 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15343.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17138).xyz, _7507)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _9666 = _8745 * vec3(_21715 * _10796).xyz;
	    vec3 _13436 = vec3(_10796 * _21715).xyz;
	    vec3 _20579;
	    if (_16311 > 0.0)
	    {
	        _20579 = mix(_9666, pow(_9666, vec3(1.0499999523162841796875, 0.949999988079071044921875, 0.800000011920928955078125)), vec3(_16311));
	    }
	    else
	    {
	        _20579 = _9666;
	    }
	    vec3 _22686 = (_16324.xyz + _20579.xyz) * (_13147.xyz * (1.0 - _13144)).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, input_5.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15753 = _11203.xyz + (_13152.xyz * _13436).xyz;
	    vec4 _20496 = _11203;
	    _20496.x = _15753.x;
	    _20496.y = _15753.y;
	    _20496.z = _15753.z;
	    vec3 _15734 = _20496.xyz + ((((mix(_11427.xxx, _11427.yyy, _9453) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m6], undetermined[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _13436).xyz;
	    vec4 _13889 = _20496;
	    _13889.x = _15734.x;
	    _13889.y = _15734.y;
	    _13889.z = _15734.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22956 = _10061.xyz - PerViewConstantBuffer_t._m4.xyz;
	        vec3 _9057 = _22956.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12892;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m19.x)
	            {
	                _12892 = (_10061.z * PerViewConstantBufferCsgo_t._m19.z) < PerViewConstantBufferCsgo_t._m19.y;
	            }
	            else
	            {
	                _12892 = false;
	            }
	            if (_12892)
	            {
	                vec2 _9342 = clamp(PerViewConstantBufferCsgo_t._m16.xy + (PerViewConstantBufferCsgo_t._m16.zw * vec2(length(_21493), _10061.z)), vec2(0.0), vec2(1.0));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m17.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m17.y)) * PerViewConstantBufferCsgo_t._m18.w;
	                _19340 = mix(_13889.xyz, vec4(PerViewConstantBufferCsgo_t._m18.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13889.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _13889;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12893;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m23.x)
	            {
	                _12893 = (PerViewConstantBufferCsgo_t._m23.z * _10061.z) < PerViewConstantBufferCsgo_t._m23.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            if (_12893)
	            {
	                float _14602 = clamp(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m20.y) + PerViewConstantBufferCsgo_t._m20.x), PerViewConstantBufferCsgo_t._m20.w), 0.0, 1.0) * clamp(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m21.y) + PerViewConstantBufferCsgo_t._m21.x), PerViewConstantBufferCsgo_t._m21.z), 0.0, 1.0);
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m23.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m2], undetermined[_Globals_.g_sTrilinearClamp]), normalize((mat4(vec4(PerViewConstantBufferCsgo_t._m22._m0[0].x, PerViewConstantBufferCsgo_t._m22._m0[1].x, PerViewConstantBufferCsgo_t._m22._m0[2].x, PerViewConstantBufferCsgo_t._m22._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m22._m0[0].y, PerViewConstantBufferCsgo_t._m22._m0[1].y, PerViewConstantBufferCsgo_t._m22._m0[2].y, PerViewConstantBufferCsgo_t._m22._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m22._m0[0].z, PerViewConstantBufferCsgo_t._m22._m0[1].z, PerViewConstantBufferCsgo_t._m22._m0[2].z, PerViewConstantBufferCsgo_t._m22._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m22._m0[0].w, PerViewConstantBufferCsgo_t._m22._m0[1].w, PerViewConstantBufferCsgo_t._m22._m0[2].w, PerViewConstantBufferCsgo_t._m22._m0[3].w)) * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m21.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m20.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m24.x).xyz, _8892).xyz, vec3(_8892));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _6805 = _23944;
	    }
	    else
	    {
	        _6805 = _13889;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	IntAttribute(TexCoord2ScaleByModelU, g_nScaleTexCoord2UByModelScaleAxis-1);
	IntAttribute(TexCoord2ScaleByModelV, g_nScaleTexCoord2VByModelScaleAxis-1);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	FloatAttribute(_dummyMakeVisiblePropMaskBias1, g_flDetailPropMaskBias1);
	FloatAttribute(_dummyMakeVisiblePropMaskBias2, g_flDetailPropMaskBias2);
	FloatAttribute(_dummyMakeVisiblePropMaskSoftness2, g_flDetailPropMaskSoftness2);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	FloatAttribute(OcclusionCullingBoundsScale, F_OCCLUSION_CULLING_BOUNDS_SCALE ? g_flOcclusionCullingBoundsScale : (F_DEPTH_BIAS ? 1.3 : 1));
	StringAttribute(MaterialLayerRefType, csgo_environment);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor1);
	TextureAttribute(RepresentativeTexture, g_tColor1);
	
	#if (S_BLEND_EFFECTS_3 == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_ENABLE_LAYER_3 == 0)
		BoolAttribute(HasTexcoordTransform, ((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || 0);
		IntAttribute(MaterialLayerCount, 2);
	#endif
	#if (S_BLEND_EFFECTS_3 == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_ALPHA_TEST == 0)
		IntAttribute(DepthPassBatchID, F_RENDER_BACKFACES ? 0 : 1);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_MODE_DEPTH == 1)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, F_DEPTH_BIAS ? -64 : 0);
	RenderState(DepthBiasClamp, F_DEPTH_BIAS ? -.0005 : 0);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthFunc, Equal);
	RenderState(DepthWriteEnable, False);
	RenderState(DepthWriteEnable, (F_DISABLE_Z_BUFFERING ? True : F_DEPTH_BIAS) ? False : True);
	RenderState(SlopeScaleDepthBias, F_DEPTH_BIAS ? -2 : 0);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	#if (S_MODE_DEPTH == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_MODE_DEPTH == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, (F_DISABLE_Z_BUFFERING ? True : F_DEPTH_BIAS) ? False : True);
	#endif
	
	BoolAttribute(BindlessResources, true);
	
}

RTX
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_SHARED_COLOR_OVERLAY, F_SHARED_COLOR_OVERLAY );
	StaticCombo( S_ENABLE_LAYER_3, F_ENABLE_LAYER_3 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_USE_NEW_BLENDING, F_USE_NEW_BLENDING );
	StaticCombo( S_ENABLE_VISUALIZATIONS, F_ENABLE_VISUALIZATIONS );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_MODE_DEPTH ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_DETAIL_NORMAL ) );
	StaticComboRule( Allow0( S_MODE_DEPTH ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((g_nUVSet1==0) || (g_nUVSet2==0)) || 0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)) || 0); >;
	bool bBlendByFacingDirection2 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_2); >;
	bool bBlendByFacingDirection3 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_3); >;
	bool g_bAdjustBaseColor1 < UiType(CheckBox); Expression(g_nColorCorrectionMode1==1); >;
	bool g_bAdjustBaseColor2 < UiType(CheckBox); Expression(g_nColorCorrectionMode2==1); >;
	bool g_bAdjustBaseColor3 < UiType(CheckBox); Expression(g_nColorCorrectionMode3==1); >;
	bool g_bColorOverlayLayer1 < UiType(CheckBox); Expression((g_nColorOverlayMode==0) || (g_nColorOverlayMode==1)); >;
	bool g_bColorOverlayLayer2 < UiType(CheckBox); Expression((g_nColorOverlayMode==0) || (g_nColorOverlayMode==2)); >;
	bool g_bColorOverlayLayer3 < UiType(CheckBox); Expression((g_nColorOverlayMode==0) || (g_nColorOverlayMode==3)); >;
	bool g_bColorOverlayMaskLayer1 < UiType(CheckBox); Expression((g_nColorOverlayTintMask==0) || (g_nColorOverlayTintMask==1)); >;
	bool g_bColorOverlayMaskLayer2 < UiType(CheckBox); Expression((g_nColorOverlayTintMask==0) || (g_nColorOverlayTintMask==2)); >;
	bool g_bColorOverlayMaskLayer3 < UiType(CheckBox); Expression((g_nColorOverlayTintMask==0) || (g_nColorOverlayTintMask==3)); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bMaskVertexColor1 < UiType(CheckBox); Expression(g_nVertexColorMode1==0); >;
	bool g_bMaskVertexColor2 < UiType(CheckBox); Expression(g_nVertexColorMode2==0); >;
	bool g_bMaskVertexColor3 < UiType(CheckBox); Expression(g_nVertexColorMode3==0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	bool g_bVertexColorEnabled1 < UiType(CheckBox); Expression(g_nVertexColorMode1!=2); >;
	bool g_bVertexColorEnabled2 < UiType(CheckBox); Expression(g_nVertexColorMode2!=2); >;
	bool g_bVertexColorEnabled3 < UiType(CheckBox); Expression(g_nVertexColorMode3!=2); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint2,1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint3,1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	int g_nVisualization < UiType(Slider); Expression(F_VISUALIZATION_MODE); >;
	float4 g_vNormalXform_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalXform_2 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation2*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalXform_3 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation3*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vOverlayTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flOverlayTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vOverlayTexCoordScale.x,-v2*g_vOverlayTexCoordScale.y,0,((g_vOverlayTexCoordCenter.x+g_vOverlayTexCoordOffset.x)+(v2*g_vOverlayTexCoordCenter.y))-(v1*g_vOverlayTexCoordCenter.x))); >;
	float4 g_vOverlayTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flOverlayTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vOverlayTexCoordScale.x,v1*g_vOverlayTexCoordScale.y,0,(g_vOverlayTexCoordCenter.y+g_vOverlayTexCoordOffset.y)-((v2*g_vOverlayTexCoordCenter.x)+(v1*g_vOverlayTexCoordCenter.y)))); >;
	float4 g_vTexCoordXform0_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale1.x,-v2*g_vTexCoordScale1.y,0,((g_vTexCoordCenter1.x+g_vTexCoordOffset1.x)+(v2*g_vTexCoordCenter1.y))-(v1*g_vTexCoordCenter1.x))); >;
	float4 g_vTexCoordXform0_2 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation2*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale2.x,-v2*g_vTexCoordScale2.y,0,((g_vTexCoordCenter2.x+g_vTexCoordOffset2.x)+(v2*g_vTexCoordCenter2.y))-(v1*g_vTexCoordCenter2.x))); >;
	float4 g_vTexCoordXform0_3 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation3*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale3.x,-v2*g_vTexCoordScale3.y,0,((g_vTexCoordCenter3.x+g_vTexCoordOffset3.x)+(v2*g_vTexCoordCenter3.y))-(v1*g_vTexCoordCenter3.x))); >;
	float4 g_vTexCoordXform1_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale1.x,v1*g_vTexCoordScale1.y,0,(g_vTexCoordCenter1.y+g_vTexCoordOffset1.y)-((v2*g_vTexCoordCenter1.x)+(v1*g_vTexCoordCenter1.y)))); >;
	float4 g_vTexCoordXform1_2 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation2*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale2.x,v1*g_vTexCoordScale2.y,0,(g_vTexCoordCenter2.y+g_vTexCoordOffset2.y)-((v2*g_vTexCoordCenter2.x)+(v1*g_vTexCoordCenter2.y)))); >;
	float4 g_vTexCoordXform1_3 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation3*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale3.x,v1*g_vTexCoordScale3.y,0,(g_vTexCoordCenter3.y+g_vTexCoordOffset3.y)-((v2*g_vTexCoordCenter3.x)+(v1*g_vTexCoordCenter3.y)))); >;
	
	// Material1
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Material1,0/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask1, Linear, 8, "", "_mask", "Material1/Tint Mask,15/0", Default4(1, 1, 1, 0));
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	float2 g_vTexCoordCenter2 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float2 g_vTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float g_flTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/3"); UiVisibility(1); >;
	float2 g_vTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vTexCoordOffset2 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float g_fTintMaskBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Tint Mask/5"); >;
	CreateInputTexture2D(TextureHeight1, Linear, 8, "", "_height", "Material1/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast1 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material1/Tint Mask/10"); >;
	float3 g_vTextureColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/11"); >;
	float g_fTextureRoughnessBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/12"); >;
	float g_fTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Lighting/13"); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	bool g_bMetalness1 < Default(1); UiType(CheckBox); UiGroup("Material1/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Lighting,20/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/20"); >;
	float g_flDetailPropMaskBias1 < Range(0, 10); UiType(Slider); UiGroup("Material1/Detail Props,90/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float3 g_vAmbientOcclusionLevels1 < Default2(0, 0.5); Range(-1, 1); Attribute("0=Option 1,1=Option 2,2=Option 3"); UiType(VectorText); UiGroup("Material1/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Material1/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/30"); >;
	float g_flHeightMapZeroPoint1 < Default(0.5); UiType(Slider); UiGroup("Material1/Height/30"); >;
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	int g_nVertexColorMode1 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material1/Color Correction/60"); >;
	
	// Material2
	CreateInputTexture2D(TextureColor2, Srgb, 8, "", "_color", "Material2/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask2, Linear, 8, "", "_mask", "Material2/Tint Mask,15/0", Default4(1, 1, 1, 0));
	float g_flColorReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/0"); >;
	int g_nUVSet2 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/1"); >;
	float g_fTintMaskBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Tint Mask/5"); >;
	CreateInputTexture2D(TextureHeight2, Linear, 8, "", "_height", "Material2/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness2, Linear, 8, "Inverse", "_rough", "Material2/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast2 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material2/Tint Mask/10"); >;
	float g_flColorOverlay2 < UiType(Slider); UiGroup("Material2/Selective Blending/10"); >;
	float g_flDetailPropMaskSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Detail Props,90/10"); >;
	float3 g_vFacingDirection2 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material2/Facing Direction/10"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float3 g_vTextureColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2,0/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Lighting/12"); >;
	float g_fTextureNormalContrast2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Lighting/13"); >;
	bool g_bMetalness2 < Default(1); UiType(CheckBox); UiGroup("Material2/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/20"); >;
	float g_flDetailPropMaskBias2 < Range(0, 10); UiType(Slider); UiGroup("Material2/Detail Props,90/20"); >;
	float g_flFacingDirectionMaskSpread2 < Default(0.5); UiType(Slider); UiGroup("Material2/Facing Direction/20"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flHeightMapScale2 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flNormalReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/20"); >;
	CreateInputTexture2D(TextureMetalness2, Linear, 8, "", "_metal", "Material2/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/30"); >;
	float g_flHeightMapZeroPoint2 < Default(0.5); UiType(Slider); UiGroup("Material2/Height/30"); >;
	float g_flNormalCombine2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Selective Blending/30"); >;
	float g_vFacingDirectionMaskNormalMapStrength2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Facing Direction/30"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_fTextureColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Color Correction/40"); >;
	float g_flBlendSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Height,30/40"); >;
	float g_flRoughnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/40"); >;
	float g_vFacingDirectionMaskSoftness2 < Default(0.1); UiType(Slider); UiGroup("Material2/Facing Direction/40"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flUnderlyingHeightMapInfluence2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height,30/41"); >;
	float g_flRoughnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/45"); >;
	int g_nColorCorrectionMode2 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material2/Color Correction/45"); >;
	float g_flMetalnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/50"); >;
	float g_flMetalnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/55"); >;
	bool g_bModelTint2 < Default(1); UiType(CheckBox); UiGroup("Material2/Color Correction/60"); >;
	int g_nVertexColorMode2 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material2/Color Correction/60"); >;
	float g_flMaskWithHeight2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Height/70"); >;
	
	// Material3
	CreateInputTexture2D(TextureColor3, Srgb, 8, "", "_color", "Material3/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask3, Linear, 8, "", "_mask", "Material3/Tint Mask,15/0", Default4(1, 1, 1, 0));
	float g_flColorReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/0"); >;
	int g_nUVSet3 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter3 < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Material3/Texture Transform,35/1"); UiVisibility(1); >;
	float2 g_vTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Texture Transform,35/2"); >;
	float g_flTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Texture Transform,35/3"); UiVisibility(1); >;
	float2 g_vTexCoordOffset3 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material3/Texture Transform,35/4"); UiVisibility(1); >;
	float g_fTintMaskBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Tint Mask/5"); >;
	CreateInputTexture2D(TextureHeight3, Linear, 8, "", "_height", "Material3/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness3, Linear, 8, "Inverse", "_rough", "Material3/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast3 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material3/Tint Mask/10"); >;
	float g_flColorOverlay3 < UiType(Slider); UiGroup("Material3/Selective Blending/10"); >;
	float g_flDetailPropMaskSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Detail Props,90/10"); >;
	float3 g_vFacingDirection3 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material3/Facing Direction/10"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float3 g_vTextureColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3,2/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Lighting/12"); >;
	float g_fTextureNormalContrast3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Lighting/13"); >;
	bool g_bMetalness3 < Default(1); UiType(CheckBox); UiGroup("Material3/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/20"); >;
	float g_flDetailPropMaskBias3 < Range(0, 10); UiType(Slider); UiGroup("Material3/Detail Props,90/20"); >;
	float g_flFacingDirectionMaskSpread3 < Default(0.5); UiType(Slider); UiGroup("Material3/Facing Direction/20"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flHeightMapScale3 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flNormalReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/20"); >;
	CreateInputTexture2D(TextureMetalness3, Linear, 8, "", "_metal", "Material3/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/30"); >;
	float g_flHeightMapZeroPoint3 < Default(0.5); UiType(Slider); UiGroup("Material3/Height/30"); >;
	float g_flNormalCombine3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Selective Blending/30"); >;
	float g_vFacingDirectionMaskNormalMapStrength3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Facing Direction/30"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_fTextureColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Color Correction/40"); >;
	float g_flBlendSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Height,30/40"); >;
	float g_flRoughnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/40"); >;
	float g_vFacingDirectionMaskSoftness3 < Default(0.1); UiType(Slider); UiGroup("Material3/Facing Direction/40"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flUnderlyingHeightMapInfluence3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height,30/41"); >;
	float g_flRoughnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/45"); >;
	int g_nColorCorrectionMode3 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material3/Color Correction/45"); >;
	float g_flMetalnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/50"); >;
	float g_flMetalnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/55"); >;
	int g_nVertexColorMode3 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material3/Color Correction/60"); >;
	bool g_bModelTint3 < Default(1); UiType(CheckBox); UiGroup("Material3/Color Correction/61"); >;
	float g_flMaskWithHeight3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Height/70"); >;
	
	// Color
	CreateInputTexture2D(TextureSharedColorOverlay, Linear, 8, "", "_color", "Color/Overlay/0", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	int g_nColorOverlayUVSet < Default(2); Range4(1, 1, 1, 1, 2, 2, 2, 2); UiOptions("1=UV1,2=UV2"); UiType(Enum); UiGroup("Color/Overlay/40"); >;
	int g_nColorOverlayMode < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=All Layers,1=Layer1,2=Layer2,3=Layer3"); UiType(Enum); UiGroup("Color/Overlay/50"); >;
	int g_nColorOverlayTintMask < Range4(0, 0, 0, 0, 4, 4, 4, 4); UiOptions("0=Mask All,1=Mask Layer1,2=Mask Layer2,3=Mask Layer3,4=Unmasked"); UiType(Enum); UiGroup("Color/Overlay/55"); >;
	float3 g_vColorOverlayLayerStrengths < Default3(1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/60"); >;
	float3 g_vColorOverlayTintMaskStrengths < Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/65"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	float g_flOverlayDarknessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/100"); >;
	int g_nScaleTexCoord2UByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.u * model.x,2=UV2.u * model.y,3=UV2.u * model.z"); UiType(Enum); UiGroup("Color/100"); UiVisibility(1); >;
	float g_flOverlayBrightnessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/110"); >;
	int g_nScaleTexCoord2VByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.v * model.x,2=UV2.v * model.y,3=UV2.v * model.z"); UiType(Enum); UiGroup("Color/110"); UiVisibility(1); >;
	float2 g_vOverlayTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/Overlay/200"); >;
	float2 g_vOverlayTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/Overlay/210"); >;
	float g_flOverlayTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/Overlay/220"); >;
	float2 g_vOverlayTexCoordOffset < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Color/Overlay/230"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ENABLE_LAYER_3 == 1)
		bool bBiplanarUsedAny < UiType(CheckBox); Expression((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)) || 0); >;
	#endif
	#if (S_ALPHA_TEST == 1)
	#endif
	#if (S_USE_NEW_BLENDING == 1)
		float g_flHeightMapScale1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Height/20"); >;
		float g_flHeightMapScale2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height/20"); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (152084 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#if defined(GL_AMD_gpu_shader_half_float)
	#extension GL_AMD_gpu_shader_half_float : require
	#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
	#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
	#else
	#error No extension available for FP16.
	#endif
	#extension GL_EXT_shader_16bit_storage : require
	#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
	#extension GL_EXT_ray_tracing : require
	#extension GL_EXT_nonuniform_qualifier : require
	
	struct VS_INPUT
	{
	    vec3 vColorBlendValues;
	    vec2 _m1;
	    vec2 _m2;
	    vec3 _m3;
	    vec4 _m4;
	    uvec4 _m5;
	    uint _m6;
	    vec4 _m7;
	    vec4 _m8;
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
	
	struct _RTX_MATERIAL_DATA_
	{
	    vec3 _g_fl_AutoPad28_;
	    float _m1;
	    bool _m2;
	    int _m3;
	    vec2 _m4;
	    vec2 _m5;
	    float _m6;
	    float _m7;
	    vec2 _m8;
	    float _m9;
	    float _m10;
	    vec4 _m11;
	    vec4 _m12;
	    vec4 _m13;
	    float _m14;
	    int _m15;
	    vec2 _m16;
	    vec2 _m17;
	    float _m18;
	    float _m19;
	    vec2 _m20;
	    float _m21;
	    float _m22;
	    vec4 _m23;
	    vec4 _m24;
	    vec4 _m25;
	    float _m26;
	    float _m27;
	    bool _m28;
	    int _m29;
	    vec2 _m30;
	    vec2 _m31;
	    float _m32;
	    float _m33;
	    vec2 _m34;
	    vec4 _m35;
	    vec4 _m36;
	    vec4 _m37;
	    float _m38;
	    int _m39;
	    vec2 _m40;
	    vec2 _m41;
	    float _m42;
	    float _m43;
	    vec2 _m44;
	    float _m45;
	    float _m46;
	    vec4 _m47;
	    vec4 _m48;
	    vec4 _m49;
	    float _m50;
	    float _m51;
	    uint _m52;
	    uint _m53;
	    uint _m54;
	    float _m55;
	    float _m56;
	    float _m57;
	    vec3 _m58;
	    float _m59;
	    vec3 _m60;
	    float _m61;
	    float _m62;
	    float _m63;
	    int _m64;
	    bool _m65;
	    float _m66;
	    float _m67;
	    int _m68;
	    bool _m69;
	    bool _m70;
	    float _m71;
	    float _m72;
	    float _m73;
	    bool _m74;
	    bool _m75;
	    float _m76;
	    float _m77;
	    mat4 _m78;
	    mat4 _m79;
	    float _m80;
	    float _m81;
	    float _m82;
	    float _m83;
	    float _m84;
	    float _m85;
	    float _m86;
	    float _m87;
	    float _m88;
	    float _m89;
	    float _m90;
	    float _m91;
	    float _m92;
	    float _m93;
	    bool _m94;
	    float _m95;
	    float _m96;
	    uint _m97;
	    uint _m98;
	    uint _m99;
	    vec3 _m100;
	    float _m101;
	    vec3 _m102;
	    float _m103;
	    float _m104;
	    float _m105;
	    int _m106;
	    bool _m107;
	    mat4 _m108;
	    mat4 _m109;
	    float _m110;
	    float _m111;
	    float _m112;
	    float _m113;
	    vec3 _m114;
	    float _m115;
	    float _m116;
	    float _m117;
	    int _m118;
	    bool _m119;
	    bool _m120;
	    bool _m121;
	    uint _m122;
	    float _m123;
	    bool _m124;
	    bool _m125;
	    float _m126;
	    float _m127;
	    vec3 _m128;
	    float _m129;
	    float _m130;
	    float _m131;
	    float _m132;
	    float _m133;
	    float _m134;
	    float _m135;
	    float _m136;
	    float _m137;
	    int _m138;
	    int _m139;
	    bool _m140;
	    float _m141;
	    vec4 _m142;
	    vec4 _m143;
	    vec2 _m144;
	    float _m145;
	    float _m146;
	    vec2 _m147;
	    float _m148;
	    float _m149;
	    vec4 _m150;
	    float _m151;
	    float _m152;
	    float _m153;
	    float _m154;
	    vec4 _m155;
	    vec2 _m156;
	    vec2 _m157;
	    float _m158;
	    float _m159;
	    vec2 _m160;
	    vec4 _m161;
	    vec4 _m162;
	    vec2 _m163;
	    int _m164;
	    int _m165;
	    bool _m166;
	    float _m167;
	    float _m168;
	    float _m169;
	    vec4 _m170;
	    vec4 _m171;
	    vec3 _m172;
	    float _m173;
	    bool _m174;
	    uint _m175;
	    uint _m176;
	    uint _m177;
	    uint _m178;
	    uint _m179;
	    int _m180;
	    int _m181;
	    uint _m182;
	    uint _m183;
	    uint _m184;
	    bool _m185;
	    bool _m186;
	    bool _m187;
	    float _m188;
	    uint _m189;
	    float _m190;
	    float _m191;
	    bool _m192;
	    bool _m193;
	    bool _m194;
	    bool _m195;
	    bool _m196;
	    bool _m197;
	    bool _m198;
	    bool _m199;
	    bool _m200;
	    bool _m201;
	    bool _m202;
	    bool _m203;
	    bool _m204;
	    bool _m205;
	    bool _m206;
	    float _m207;
	    float _m208;
	    float _m209;
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
	
	const vec3 _608[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _612[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
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
	
	vec4 _671;
	float _672;
	vec3 _673;
	
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
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _m0[];
	} g_MaterialData_5;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_6
	{
	    uint _m0[];
	} g_MaterialData_7;
	
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
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes _22;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t _21;
	
	void main()
	{
	    _RTX_MATERIAL_DATA_ _2540 = _RTX_MATERIAL_DATA_(vec3(g_MaterialData_1._m0[g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 4u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 8u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 12u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 16u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 20u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 24u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 28u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 32u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 36u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 40u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 44u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 48u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 52u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 56u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 60u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 64u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 68u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 72u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 76u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 80u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 84u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 88u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 92u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 96u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 100u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 104u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 108u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 112u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 116u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 124u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 132u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 140u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 152u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 156u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 160u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 164u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 168u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 172u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 176u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 180u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 184u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 188u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 192u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 196u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 200u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 204u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 212u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 216u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 220u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 224u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 228u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 232u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 236u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 240u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 244u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 248u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 252u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 256u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 260u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 264u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 268u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 272u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 276u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 280u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 284u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 288u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 292u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 296u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 300u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 304u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 324u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 328u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 332u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 336u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 340u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 344u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 348u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 352u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 356u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 360u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 364u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 368u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 372u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 376u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 380u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 384u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 388u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 392u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 396u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 400u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 404u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 408u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 412u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 416u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 420u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 424u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 428u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 432u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 436u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 440u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 444u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 448u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 452u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 456u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 460u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 464u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 468u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 472u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 476u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 480u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 484u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 488u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 492u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 496u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 500u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 504u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 508u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 512u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 516u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 520u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 524u) / 4u], mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 528u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 544u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 560u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 576u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 532u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 548u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 564u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 580u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 536u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 552u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 568u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 584u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 540u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 556u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 572u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 588u) / 4u])), mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 592u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 608u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 624u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 640u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 596u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 612u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 628u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 644u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 600u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 616u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 632u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 648u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 604u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 620u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 636u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 652u) / 4u])), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 656u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 660u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 664u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 668u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 672u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 676u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 680u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 684u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 688u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 692u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 696u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 700u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 704u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 708u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 712u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 716u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 720u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 724u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 728u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 732u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 736u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 740u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 744u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 748u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 752u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 756u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 760u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 764u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 768u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 772u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 776u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 780u) / 4u] != 0, mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 784u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 800u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 816u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 832u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 788u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 804u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 820u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 836u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 792u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 808u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 824u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 840u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 796u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 812u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 828u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 844u) / 4u])), mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 848u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 864u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 880u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 896u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 852u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 868u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 884u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 900u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 856u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 872u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 888u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 904u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 860u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 876u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 892u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 908u) / 4u])), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 912u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 916u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 920u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 924u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 928u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 932u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 936u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 940u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 944u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 948u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 952u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 956u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 960u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 964u) / 4u] != 0, g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 968u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 972u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 976u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 980u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 984u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 988u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 992u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 996u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1000u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1004u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1008u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1012u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1016u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1020u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1024u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1028u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1032u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1036u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1040u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1044u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1048u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1052u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1056u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1060u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1064u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1068u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1072u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1076u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1080u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1084u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1088u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1092u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1096u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1100u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1104u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1108u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1112u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1116u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1124u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1132u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1140u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1148u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1152u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1156u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1160u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1164u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1168u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1172u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1176u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1180u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1184u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1188u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1192u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1196u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1200u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1204u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1212u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1216u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1220u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1224u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1228u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1232u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1236u) / 4u]), g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1240u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1244u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1248u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1252u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1256u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1260u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1264u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1268u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1272u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1276u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1280u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1284u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1288u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1292u) / 4u]), vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1296u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1300u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1304u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1308u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1312u) / 4u] != 0, g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1316u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1320u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1324u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1328u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1332u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1336u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1340u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1344u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1348u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1352u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1356u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1360u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1364u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1368u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1372u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1376u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1380u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1384u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1388u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1392u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1396u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1400u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1404u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1408u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1412u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1416u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1420u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1424u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1428u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1432u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1436u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1440u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1444u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1448u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1452u) / 4u]);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _2540;
	    uvec3 _972;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _2601 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _972 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2601 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_2601 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_2601 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _2576 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _2577 = _2576 & 4294967292u;
	            uint _2578 = _2577 / 4u;
	            uint _2582 = (_2577 + 4u) / 4u;
	            uint _2587 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2578] & 4294901760u) >> uint(16);
	            uint _2588 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2582] & 65535u;
	            uvec3 _973;
	            if (_2576 == _2577)
	            {
	                _973 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2578] & 65535u, _2587, _2588);
	            }
	            else
	            {
	                _973 = uvec3(_2587, _2588, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2582] & 4294901760u) >> uint(16));
	            }
	            _972 = _973;
	            break;
	        }
	        break;
	    } while(false);
	    uint _2616 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _2624 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _972) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _966[3];
	    uint _2626 = _2624.x;
	    _966[0] = vec3(g_Vertices_1[_2616]._m0[_2626 / 4u], g_Vertices_1[_2616]._m0[(_2626 + 4u) / 4u], g_Vertices_1[_2616]._m0[(_2626 + 8u) / 4u]);
	    uint _2640 = _2624.y;
	    _966[1] = vec3(g_Vertices_1[_2616]._m0[_2640 / 4u], g_Vertices_1[_2616]._m0[(_2640 + 4u) / 4u], g_Vertices_1[_2616]._m0[(_2640 + 8u) / 4u]);
	    uint _2654 = _2624.z;
	    _966[2] = vec3(g_Vertices_1[_2616]._m0[_2654 / 4u], g_Vertices_1[_2616]._m0[(_2654 + 4u) / 4u], g_Vertices_1[_2616]._m0[(_2654 + 8u) / 4u]);
	    int _967 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_967 < 3))
	        {
	            break;
	        }
	        vsInput[_967].vColorBlendValues = _966[_967];
	        _967++;
	        continue;
	    }
	    vec2 _968[3];
	    _968[0] = vec2(0.0);
	    _968[1] = vec2(0.0);
	    _968[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _965 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2697 = uint(_965[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _2699 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _963 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _964 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2710 = (uvec3(uint(_963[_2699])) * _972) + uvec3(uint(_964[_2699]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _2845 = _2710.x;
	            _968[0] = vec2(g_Vertices_1[_2697]._m0[_2845 / 4u], g_Vertices_1[_2697]._m0[(_2845 + 4u) / 4u]);
	            uint _2854 = _2710.y;
	            _968[1] = vec2(g_Vertices_1[_2697]._m0[_2854 / 4u], g_Vertices_1[_2697]._m0[(_2854 + 4u) / 4u]);
	            uint _2863 = _2710.z;
	            _968[2] = vec2(g_Vertices_1[_2697]._m0[_2863 / 4u], g_Vertices_1[_2697]._m0[(_2863 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _2816 = _2710.x / 4u;
	                _968[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2697]._m0[_2816], g_Vertices_3[_2697]._m0[_2816] >> uint(16)) & uvec2(65535u))));
	                uint _2826 = _2710.y / 4u;
	                _968[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2697]._m0[_2826], g_Vertices_3[_2697]._m0[_2826] >> uint(16)) & uvec2(65535u))));
	                uint _2836 = _2710.z / 4u;
	                _968[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2697]._m0[_2836], g_Vertices_3[_2697]._m0[_2836] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _2723 = _2710.x / 4u;
	                    uint _2727 = (g_Vertices_3[_2697]._m0[_2723] & 65535u);
	                    int _962;
	                    if (_2727 > 32767u)
	                    {
	                        _962 = int(4294901760u | _2727);
	                    }
	                    else
	                    {
	                        _962 = int(_2727);
	                    }
	                    uint _2740 = (g_Vertices_3[_2697]._m0[_2723] & 4294901760u) >> uint(16);
	                    int _961;
	                    if (_2740 > 32767u)
	                    {
	                        _961 = int(4294901760u | _2740);
	                    }
	                    else
	                    {
	                        _961 = int(_2740);
	                    }
	                    _968[0] = vec2(max(float(_962) * 3.0518509447574615478515625e-05, -1.0), max(float(_961) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2754 = _2710.y / 4u;
	                    uint _2758 = (g_Vertices_3[_2697]._m0[_2754] & 65535u);
	                    int _960;
	                    if (_2758 > 32767u)
	                    {
	                        _960 = int(4294901760u | _2758);
	                    }
	                    else
	                    {
	                        _960 = int(_2758);
	                    }
	                    uint _2771 = (g_Vertices_3[_2697]._m0[_2754] & 4294901760u) >> uint(16);
	                    int _959;
	                    if (_2771 > 32767u)
	                    {
	                        _959 = int(4294901760u | _2771);
	                    }
	                    else
	                    {
	                        _959 = int(_2771);
	                    }
	                    _968[1] = vec2(max(float(_960) * 3.0518509447574615478515625e-05, -1.0), max(float(_959) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2785 = _2710.z / 4u;
	                    uint _2789 = (g_Vertices_3[_2697]._m0[_2785] & 65535u);
	                    int _958;
	                    if (_2789 > 32767u)
	                    {
	                        _958 = int(4294901760u | _2789);
	                    }
	                    else
	                    {
	                        _958 = int(_2789);
	                    }
	                    uint _2802 = (g_Vertices_3[_2697]._m0[_2785] & 4294901760u) >> uint(16);
	                    int _957;
	                    if (_2802 > 32767u)
	                    {
	                        _957 = int(4294901760u | _2802);
	                    }
	                    else
	                    {
	                        _957 = int(_2802);
	                    }
	                    _968[2] = vec2(max(float(_958) * 3.0518509447574615478515625e-05, -1.0), max(float(_957) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _967 = 0;
	    for (;;)
	    {
	        if (!(_967 < 3))
	        {
	            break;
	        }
	        vsInput[_967]._m1 = _968[_967];
	        _967++;
	        continue;
	    }
	    _968[0] = vec2(0.0);
	    _968[1] = vec2(0.0);
	    _968[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _956 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2902 = uint(_956[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _2904 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _954 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _955 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2915 = (uvec3(uint(_954[_2904])) * _972) + uvec3(uint(_955[_2904]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _3050 = _2915.x;
	            _968[0] = vec2(g_Vertices_1[_2902]._m0[_3050 / 4u], g_Vertices_1[_2902]._m0[(_3050 + 4u) / 4u]);
	            uint _3059 = _2915.y;
	            _968[1] = vec2(g_Vertices_1[_2902]._m0[_3059 / 4u], g_Vertices_1[_2902]._m0[(_3059 + 4u) / 4u]);
	            uint _3068 = _2915.z;
	            _968[2] = vec2(g_Vertices_1[_2902]._m0[_3068 / 4u], g_Vertices_1[_2902]._m0[(_3068 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _3021 = _2915.x / 4u;
	                _968[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2902]._m0[_3021], g_Vertices_3[_2902]._m0[_3021] >> uint(16)) & uvec2(65535u))));
	                uint _3031 = _2915.y / 4u;
	                _968[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2902]._m0[_3031], g_Vertices_3[_2902]._m0[_3031] >> uint(16)) & uvec2(65535u))));
	                uint _3041 = _2915.z / 4u;
	                _968[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2902]._m0[_3041], g_Vertices_3[_2902]._m0[_3041] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _2928 = _2915.x / 4u;
	                    uint _2932 = (g_Vertices_3[_2902]._m0[_2928] & 65535u);
	                    int _953;
	                    if (_2932 > 32767u)
	                    {
	                        _953 = int(4294901760u | _2932);
	                    }
	                    else
	                    {
	                        _953 = int(_2932);
	                    }
	                    uint _2945 = (g_Vertices_3[_2902]._m0[_2928] & 4294901760u) >> uint(16);
	                    int _952;
	                    if (_2945 > 32767u)
	                    {
	                        _952 = int(4294901760u | _2945);
	                    }
	                    else
	                    {
	                        _952 = int(_2945);
	                    }
	                    _968[0] = vec2(max(float(_953) * 3.0518509447574615478515625e-05, -1.0), max(float(_952) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2959 = _2915.y / 4u;
	                    uint _2963 = (g_Vertices_3[_2902]._m0[_2959] & 65535u);
	                    int _951;
	                    if (_2963 > 32767u)
	                    {
	                        _951 = int(4294901760u | _2963);
	                    }
	                    else
	                    {
	                        _951 = int(_2963);
	                    }
	                    uint _2976 = (g_Vertices_3[_2902]._m0[_2959] & 4294901760u) >> uint(16);
	                    int _950;
	                    if (_2976 > 32767u)
	                    {
	                        _950 = int(4294901760u | _2976);
	                    }
	                    else
	                    {
	                        _950 = int(_2976);
	                    }
	                    _968[1] = vec2(max(float(_951) * 3.0518509447574615478515625e-05, -1.0), max(float(_950) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2990 = _2915.z / 4u;
	                    uint _2994 = (g_Vertices_3[_2902]._m0[_2990] & 65535u);
	                    int _949;
	                    if (_2994 > 32767u)
	                    {
	                        _949 = int(4294901760u | _2994);
	                    }
	                    else
	                    {
	                        _949 = int(_2994);
	                    }
	                    uint _3007 = (g_Vertices_3[_2902]._m0[_2990] & 4294901760u) >> uint(16);
	                    int _948;
	                    if (_3007 > 32767u)
	                    {
	                        _948 = int(4294901760u | _3007);
	                    }
	                    else
	                    {
	                        _948 = int(_3007);
	                    }
	                    _968[2] = vec2(max(float(_949) * 3.0518509447574615478515625e-05, -1.0), max(float(_948) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _967 = 0;
	    for (;;)
	    {
	        if (!(_967 < 3))
	        {
	            break;
	        }
	        vsInput[_967]._m2 = _968[_967];
	        _967++;
	        continue;
	    }
	    vec3 _969[3];
	    vec4 _970[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _934 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _3110 = uint(_934[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _3112 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _932 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _933 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _3123 = (uvec3(uint(_932[_3112])) * _972) + uvec3(uint(_933[_3112]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _3654 = _3123.x;
	                _969[0] = vec3(g_Vertices_1[_3110]._m0[_3654 / 4u], g_Vertices_1[_3110]._m0[(_3654 + 4u) / 4u], g_Vertices_1[_3110]._m0[(_3654 + 8u) / 4u]);
	                uint _3668 = _3123.y;
	                _969[1] = vec3(g_Vertices_1[_3110]._m0[_3668 / 4u], g_Vertices_1[_3110]._m0[(_3668 + 4u) / 4u], g_Vertices_1[_3110]._m0[(_3668 + 8u) / 4u]);
	                uint _3682 = _3123.z;
	                _969[2] = vec3(g_Vertices_1[_3110]._m0[_3682 / 4u], g_Vertices_1[_3110]._m0[(_3682 + 4u) / 4u], g_Vertices_1[_3110]._m0[(_3682 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _3387 = _3123.x;
	                    uvec2 _3395 = uvec2(g_Vertices_3[_3110]._m0[_3387 / 4u], g_Vertices_3[_3110]._m0[(_3387 + 4u) / 4u]);
	                    uint _3396 = _3123.y;
	                    uvec2 _695 = uvec2(g_Vertices_3[_3110]._m0[_3396 / 4u], g_Vertices_3[_3110]._m0[(_3396 + 4u) / 4u]);
	                    uint _3405 = _3123.z;
	                    uvec2 _694 = uvec2(g_Vertices_3[_3110]._m0[_3405 / 4u], g_Vertices_3[_3110]._m0[(_3405 + 4u) / 4u]);
	                    uint _3417 = _3395.x;
	                    uint _3426 = _3395.y;
	                    vec2 _3436 = ((vec2(float((_3417) & 65535u), float((_3417 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3437 = _3436.x;
	                    float _3442 = (1.0 - abs(_3437)) - abs(_3436.y);
	                    vec3 _3443 = vec3(_3437, _3436.y, _3442);
	                    float _3445 = saturate(-_3442);
	                    vec2 _3451 = _3436 + mix(vec2(_3445), vec2(-_3445), greaterThanEqual(_3436, vec2(0.0)));
	                    _3443.x = _3451.x;
	                    _3443.y = _3451.y;
	                    vec3 _942 = normalize(_3443);
	                    vec2 _3458 = ((vec2(float((_3426 >> uint(1)) & 32767u), float((_3426 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3459 = _3458.x;
	                    float _3464 = (1.0 - abs(_3459)) - abs(_3458.y);
	                    vec3 _3465 = vec3(_3459, _3458.y, _3464);
	                    float _3467 = saturate(-_3464);
	                    vec2 _3473 = _3458 + mix(vec2(_3467), vec2(-_3467), greaterThanEqual(_3458, vec2(0.0)));
	                    _3465.x = _3473.x;
	                    _3465.y = _3473.y;
	                    vec3 _941 = normalize(_3465);
	                    float _922;
	                    if ((_3426 & 1u) != 0u)
	                    {
	                        _922 = 1.0;
	                    }
	                    else
	                    {
	                        _922 = -1.0;
	                    }
	                    _969[0] = _942;
	                    _970[0].w = _922;
	                    _970[0].x = _941.x;
	                    _970[0].y = _941.y;
	                    _970[0].z = _941.z;
	                    vec2 _3516 = ((vec2(float((_695.x) & 65535u), float((_695.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3517 = _3516.x;
	                    float _3522 = (1.0 - abs(_3517)) - abs(_3516.y);
	                    vec3 _3523 = vec3(_3517, _3516.y, _3522);
	                    float _3525 = saturate(-_3522);
	                    vec2 _3531 = _3516 + mix(vec2(_3525), vec2(-_3525), greaterThanEqual(_3516, vec2(0.0)));
	                    _3523.x = _3531.x;
	                    _3523.y = _3531.y;
	                    vec3 _944 = normalize(_3523);
	                    vec2 _3538 = ((vec2(float((_695.y >> uint(1)) & 32767u), float((_695.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3539 = _3538.x;
	                    float _3544 = (1.0 - abs(_3539)) - abs(_3538.y);
	                    vec3 _3545 = vec3(_3539, _3538.y, _3544);
	                    float _3547 = saturate(-_3544);
	                    vec2 _3553 = _3538 + mix(vec2(_3547), vec2(-_3547), greaterThanEqual(_3538, vec2(0.0)));
	                    _3545.x = _3553.x;
	                    _3545.y = _3553.y;
	                    vec3 _943 = normalize(_3545);
	                    float _921;
	                    if ((_695.y & 1u) != 0u)
	                    {
	                        _921 = 1.0;
	                    }
	                    else
	                    {
	                        _921 = -1.0;
	                    }
	                    _969[1] = _944;
	                    _970[1].w = _921;
	                    _970[1].x = _943.x;
	                    _970[1].y = _943.y;
	                    _970[1].z = _943.z;
	                    vec2 _3596 = ((vec2(float((_694.x) & 65535u), float((_694.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3597 = _3596.x;
	                    float _3602 = (1.0 - abs(_3597)) - abs(_3596.y);
	                    vec3 _3603 = vec3(_3597, _3596.y, _3602);
	                    float _3605 = saturate(-_3602);
	                    vec2 _3611 = _3596 + mix(vec2(_3605), vec2(-_3605), greaterThanEqual(_3596, vec2(0.0)));
	                    _3603.x = _3611.x;
	                    _3603.y = _3611.y;
	                    vec3 _946 = normalize(_3603);
	                    vec2 _3618 = ((vec2(float((_694.y >> uint(1)) & 32767u), float((_694.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3619 = _3618.x;
	                    float _3624 = (1.0 - abs(_3619)) - abs(_3618.y);
	                    vec3 _3625 = vec3(_3619, _3618.y, _3624);
	                    float _3627 = saturate(-_3624);
	                    vec2 _3633 = _3618 + mix(vec2(_3627), vec2(-_3627), greaterThanEqual(_3618, vec2(0.0)));
	                    _3625.x = _3633.x;
	                    _3625.y = _3633.y;
	                    vec3 _945 = normalize(_3625);
	                    float _920;
	                    if ((_694.y & 1u) != 0u)
	                    {
	                        _920 = 1.0;
	                    }
	                    else
	                    {
	                        _920 = -1.0;
	                    }
	                    _969[2] = _946;
	                    _970[2].w = _920;
	                    _970[2].x = _945.x;
	                    _970[2].y = _945.y;
	                    _970[2].z = _945.z;
	                    break;
	                }
	                else
	                {
	                    uint _3133 = _3123.x / 4u;
	                    vec4 _936 = _970[0];
	                    float _3148 = (float((g_Vertices_3[_3110]._m0[_3133] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3151 = (float((g_Vertices_3[_3110]._m0[_3133] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3155 = (1.0 - abs(_3148)) - abs(_3151);
	                    vec3 _3156 = vec3(_3148, _3151, _3155);
	                    float _3158 = saturate(-_3155);
	                    vec2 _3159 = vec2(_3148, _3151);
	                    vec2 _3165 = _3159 + mix(vec2(_3158), vec2(-_3158), greaterThanEqual(_3159, vec2(0.0)));
	                    _3156.x = _3165.x;
	                    _3156.y = _3165.y;
	                    vec3 _3170 = normalize(_3156);
	                    vec3 _935 = _3170;
	                    float _3171 = _3170.z;
	                    float _929;
	                    if (_3171 >= 0.0)
	                    {
	                        _929 = 1.0;
	                    }
	                    else
	                    {
	                        _929 = -1.0;
	                    }
	                    float _3178 = (-1.0) / (_929 + _3171);
	                    float _3179 = _3170.x;
	                    vec3 _930;
	                    vec3 _3187 = _930;
	                    _3187.x = 1.0 + (((_929 * _3179) * _3179) * _3178);
	                    _3187.y = _929 * ((_3179 * _3170.y) * _3178);
	                    _3187.z = (-_929) * _3179;
	                    _930 = _3187;
	                    float _3195 = float((g_Vertices_3[_3110]._m0[_3133] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3201 = (_3187 * cos(_3195)) + (cross(_3170, _3187) * sin(_3195));
	                    vec4 _3203 = _936;
	                    _3203.x = _3201.x;
	                    _3203.y = _3201.y;
	                    _3203.z = _3201.z;
	                    _936 = _3203;
	                    float _931;
	                    if ((g_Vertices_3[_3110]._m0[_3133] & 1u) == 0u)
	                    {
	                        _931 = -1.0;
	                    }
	                    else
	                    {
	                        _931 = 1.0;
	                    }
	                    vec4 _3214 = _936;
	                    _3214.w = _931;
	                    _936 = _3214;
	                    _969[0] = _935;
	                    _970[0] = _3214;
	                    uint _3218 = _3123.y / 4u;
	                    vec4 _938 = _970[1];
	                    float _3233 = (float((g_Vertices_3[_3110]._m0[_3218] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3236 = (float((g_Vertices_3[_3110]._m0[_3218] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3240 = (1.0 - abs(_3233)) - abs(_3236);
	                    vec3 _3241 = vec3(_3233, _3236, _3240);
	                    float _3243 = saturate(-_3240);
	                    vec2 _3244 = vec2(_3233, _3236);
	                    vec2 _3250 = _3244 + mix(vec2(_3243), vec2(-_3243), greaterThanEqual(_3244, vec2(0.0)));
	                    _3241.x = _3250.x;
	                    _3241.y = _3250.y;
	                    vec3 _3255 = normalize(_3241);
	                    vec3 _937 = _3255;
	                    float _3256 = _3255.z;
	                    float _926;
	                    if (_3256 >= 0.0)
	                    {
	                        _926 = 1.0;
	                    }
	                    else
	                    {
	                        _926 = -1.0;
	                    }
	                    float _3263 = (-1.0) / (_926 + _3256);
	                    float _3264 = _3255.x;
	                    vec3 _927;
	                    vec3 _3272 = _927;
	                    _3272.x = 1.0 + (((_926 * _3264) * _3264) * _3263);
	                    _3272.y = _926 * ((_3264 * _3255.y) * _3263);
	                    _3272.z = (-_926) * _3264;
	                    _927 = _3272;
	                    float _3280 = float((g_Vertices_3[_3110]._m0[_3218] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3286 = (_3272 * cos(_3280)) + (cross(_3255, _3272) * sin(_3280));
	                    vec4 _3288 = _938;
	                    _3288.x = _3286.x;
	                    _3288.y = _3286.y;
	                    _3288.z = _3286.z;
	                    _938 = _3288;
	                    float _928;
	                    if ((g_Vertices_3[_3110]._m0[_3218] & 1u) == 0u)
	                    {
	                        _928 = -1.0;
	                    }
	                    else
	                    {
	                        _928 = 1.0;
	                    }
	                    vec4 _3299 = _938;
	                    _3299.w = _928;
	                    _938 = _3299;
	                    _969[1] = _937;
	                    _970[1] = _3299;
	                    uint _3303 = _3123.z / 4u;
	                    vec4 _940 = _970[2];
	                    float _3318 = (float((g_Vertices_3[_3110]._m0[_3303] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3321 = (float((g_Vertices_3[_3110]._m0[_3303] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3325 = (1.0 - abs(_3318)) - abs(_3321);
	                    vec3 _3326 = vec3(_3318, _3321, _3325);
	                    float _3328 = saturate(-_3325);
	                    vec2 _3329 = vec2(_3318, _3321);
	                    vec2 _3335 = _3329 + mix(vec2(_3328), vec2(-_3328), greaterThanEqual(_3329, vec2(0.0)));
	                    _3326.x = _3335.x;
	                    _3326.y = _3335.y;
	                    vec3 _3340 = normalize(_3326);
	                    vec3 _939 = _3340;
	                    float _3341 = _3340.z;
	                    float _923;
	                    if (_3341 >= 0.0)
	                    {
	                        _923 = 1.0;
	                    }
	                    else
	                    {
	                        _923 = -1.0;
	                    }
	                    float _3348 = (-1.0) / (_923 + _3341);
	                    float _3349 = _3340.x;
	                    vec3 _924;
	                    vec3 _3357 = _924;
	                    _3357.x = 1.0 + (((_923 * _3349) * _3349) * _3348);
	                    _3357.y = _923 * ((_3349 * _3340.y) * _3348);
	                    _3357.z = (-_923) * _3349;
	                    _924 = _3357;
	                    float _3365 = float((g_Vertices_3[_3110]._m0[_3303] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3371 = (_3357 * cos(_3365)) + (cross(_3340, _3357) * sin(_3365));
	                    vec4 _3373 = _940;
	                    _3373.x = _3371.x;
	                    _3373.y = _3371.y;
	                    _3373.z = _3371.z;
	                    _940 = _3373;
	                    float _925;
	                    if ((g_Vertices_3[_3110]._m0[_3303] & 1u) == 0u)
	                    {
	                        _925 = -1.0;
	                    }
	                    else
	                    {
	                        _925 = 1.0;
	                    }
	                    vec4 _3384 = _940;
	                    _3384.w = _925;
	                    _940 = _3384;
	                    _969[2] = _939;
	                    _970[2] = _3384;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _969[0] = vec3(0.0);
	            _969[1] = vec3(0.0);
	            _969[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _947 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _3707 = uint(_947[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _3709 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _918 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _919 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _3720 = (uvec3(uint(_918[_3709])) * _972) + uvec3(uint(_919[_3709]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _3722 = _3720.x;
	            _970[0] = vec4(g_Vertices_1[_3707]._m0[_3722 / 4u], g_Vertices_1[_3707]._m0[(_3722 + 4u) / 4u], g_Vertices_1[_3707]._m0[(_3722 + 8u) / 4u], g_Vertices_1[_3707]._m0[(_3722 + 12u) / 4u]);
	            uint _3740 = _3720.y;
	            _970[1] = vec4(g_Vertices_1[_3707]._m0[_3740 / 4u], g_Vertices_1[_3707]._m0[(_3740 + 4u) / 4u], g_Vertices_1[_3707]._m0[(_3740 + 8u) / 4u], g_Vertices_1[_3707]._m0[(_3740 + 12u) / 4u]);
	            uint _3758 = _3720.z;
	            _970[2] = vec4(g_Vertices_1[_3707]._m0[_3758 / 4u], g_Vertices_1[_3707]._m0[(_3758 + 4u) / 4u], g_Vertices_1[_3707]._m0[(_3758 + 8u) / 4u], g_Vertices_1[_3707]._m0[(_3758 + 12u) / 4u]);
	        }
	        else
	        {
	            _970[0] = vec4(0.0);
	            _970[1] = vec4(0.0);
	            _970[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _967 = 0;
	    for (;;)
	    {
	        if (!(_967 < 3))
	        {
	            break;
	        }
	        vsInput[_967]._m3 = _969[_967];
	        vsInput[_967]._m4 = _970[_967];
	        _967++;
	        continue;
	    }
	    vec4 _971[3];
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _917 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _3809 = uint(_917[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _3811 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _915 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _916 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3822 = (uvec3(uint(_915[_3811])) * _972) + uvec3(uint(_916[_3811]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _3876 = _3822.x;
	            _971[0] = vec4(g_Vertices_1[_3809]._m0[_3876 / 4u], g_Vertices_1[_3809]._m0[(_3876 + 4u) / 4u], g_Vertices_1[_3809]._m0[(_3876 + 8u) / 4u], g_Vertices_1[_3809]._m0[(_3876 + 12u) / 4u]);
	            uint _3894 = _3822.y;
	            _971[1] = vec4(g_Vertices_1[_3809]._m0[_3894 / 4u], g_Vertices_1[_3809]._m0[(_3894 + 4u) / 4u], g_Vertices_1[_3809]._m0[(_3894 + 8u) / 4u], g_Vertices_1[_3809]._m0[(_3894 + 12u) / 4u]);
	            uint _3912 = _3822.z;
	            _971[2] = vec4(g_Vertices_1[_3809]._m0[_3912 / 4u], g_Vertices_1[_3809]._m0[(_3912 + 4u) / 4u], g_Vertices_1[_3809]._m0[(_3912 + 8u) / 4u], g_Vertices_1[_3809]._m0[(_3912 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _3829 = _3822.x / 4u;
	            _971[0] = vec4(uvec4((g_Vertices_3[_3809]._m0[_3829] & 255u), (g_Vertices_3[_3809]._m0[_3829] & 65280u) >> uint(8), (g_Vertices_3[_3809]._m0[_3829] & 16711680u) >> uint(16), (g_Vertices_3[_3809]._m0[_3829] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _3845 = _3822.y / 4u;
	            _971[1] = vec4(uvec4((g_Vertices_3[_3809]._m0[_3845] & 255u), (g_Vertices_3[_3809]._m0[_3845] & 65280u) >> uint(8), (g_Vertices_3[_3809]._m0[_3845] & 16711680u) >> uint(16), (g_Vertices_3[_3809]._m0[_3845] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _3861 = _3822.z / 4u;
	            _971[2] = vec4(uvec4((g_Vertices_3[_3809]._m0[_3861] & 255u), (g_Vertices_3[_3809]._m0[_3861] & 65280u) >> uint(8), (g_Vertices_3[_3809]._m0[_3861] & 16711680u) >> uint(16), (g_Vertices_3[_3809]._m0[_3861] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _971[0] = vec4(0.0);
	        _971[1] = vec4(0.0);
	        _971[2] = vec4(0.0);
	    }
	    _967 = 0;
	    for (;;)
	    {
	        if (!(_967 < 3))
	        {
	            break;
	        }
	        vsInput[_967]._m7 = _971[_967];
	        _967++;
	        continue;
	    }
	    vec4 _974[3];
	    _974[0] = vec4(0.0);
	    _974[1] = vec4(0.0);
	    _974[2] = vec4(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _914 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _3963 = uint(_914[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _3965 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _912 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _913 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3976 = (uvec3(uint(_912[_3965])) * _972) + uvec3(uint(_913[_3965]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _4029 = _3976.x;
	            _974[0] = vec4(g_Vertices_1[_3963]._m0[_4029 / 4u], g_Vertices_1[_3963]._m0[(_4029 + 4u) / 4u], g_Vertices_1[_3963]._m0[(_4029 + 8u) / 4u], g_Vertices_1[_3963]._m0[(_4029 + 12u) / 4u]);
	            uint _4046 = _3976.y;
	            _974[1] = vec4(g_Vertices_1[_3963]._m0[_4046 / 4u], g_Vertices_1[_3963]._m0[(_4046 + 4u) / 4u], g_Vertices_1[_3963]._m0[(_4046 + 8u) / 4u], g_Vertices_1[_3963]._m0[(_4046 + 12u) / 4u]);
	            uint _4063 = _3976.z;
	            _974[2] = vec4(g_Vertices_1[_3963]._m0[_4063 / 4u], g_Vertices_1[_3963]._m0[(_4063 + 4u) / 4u], g_Vertices_1[_3963]._m0[(_4063 + 8u) / 4u], g_Vertices_1[_3963]._m0[(_4063 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _3985 = _3976.x / 4u;
	                _974[0] = vec4(uvec4((g_Vertices_3[_3963]._m0[_3985] & 255u), (g_Vertices_3[_3963]._m0[_3985] & 65280u) >> uint(8), (g_Vertices_3[_3963]._m0[_3985] & 16711680u) >> uint(16), (g_Vertices_3[_3963]._m0[_3985] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _4000 = _3976.y / 4u;
	                _974[1] = vec4(uvec4((g_Vertices_3[_3963]._m0[_4000] & 255u), (g_Vertices_3[_3963]._m0[_4000] & 65280u) >> uint(8), (g_Vertices_3[_3963]._m0[_4000] & 16711680u) >> uint(16), (g_Vertices_3[_3963]._m0[_4000] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _4015 = _3976.z / 4u;
	                _974[2] = vec4(uvec4((g_Vertices_3[_3963]._m0[_4015] & 255u), (g_Vertices_3[_3963]._m0[_4015] & 65280u) >> uint(8), (g_Vertices_3[_3963]._m0[_4015] & 16711680u) >> uint(16), (g_Vertices_3[_3963]._m0[_4015] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _975 = 0;
	    for (;;)
	    {
	        if (!(_975 < 3))
	        {
	            break;
	        }
	        vsInput[_975]._m8 = _974[_975];
	        _975++;
	        continue;
	    }
	    vec3 _909 = vsInput[0]._m3;
	    vec4 _910;
	    vec4 _4104 = _910;
	    _4104.x = vsInput[0]._m4.x;
	    _4104.y = vsInput[0]._m4.y;
	    _4104.z = vsInput[0]._m4.z;
	    _4104.w = vsInput[0]._m4.w;
	    _910 = _4104;
	    vec4 _4129 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _908 = _4129;
	    vec3 _4130 = _4129.xyz;
	    vec3 _4131 = _4130 * vec3(0.077399380505084991455078125);
	    vec3 _4134 = pow((_4130 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _905;
	    if (_4129.x <= 0.040449999272823333740234375)
	    {
	        _905 = _4131.x;
	    }
	    else
	    {
	        _905 = _4134.x;
	    }
	    float _906;
	    if (_4129.y <= 0.040449999272823333740234375)
	    {
	        _906 = _4131.y;
	    }
	    else
	    {
	        _906 = _4134.y;
	    }
	    float _907;
	    if (_4129.z <= 0.040449999272823333740234375)
	    {
	        _907 = _4131.z;
	    }
	    else
	    {
	        _907 = _4134.z;
	    }
	    vec3 _4159 = vec3(_905, _906, _907);
	    vec4 _4161 = _908;
	    _4161.x = _4159.x;
	    _4161.y = _4159.y;
	    _4161.z = _4159.z;
	    _908 = _4161;
	    vec4 _713;
	    vec4 _4168 = _713;
	    _4168.x = _4161.x;
	    _4168.y = _4161.y;
	    _4168.z = _4161.z;
	    _4168.w = _4161.w;
	    _713 = _4168;
	    mat3x4 _4179 = transpose(gl_WorldToObjectEXT);
	    mat3 _904;
	    mat3 _4182 = _904;
	    _4182[0] = _4179[0].xyz;
	    _4182[1] = _4179[1].xyz;
	    _4182[2] = _4179[2].xyz;
	    _904 = _4182;
	    vec3 _4191 = normalize(_4182 * _909.xyz);
	    vec3 _714;
	    vec3 _4193 = _714;
	    _4193.x = _4191.x;
	    _4193.y = _4191.y;
	    _4193.z = _4191.z;
	    _714 = _4193;
	    mat3x4 _4205 = transpose(gl_WorldToObjectEXT);
	    mat3 _903;
	    mat3 _4208 = _903;
	    _4208[0] = _4205[0].xyz;
	    _4208[1] = _4205[1].xyz;
	    _4208[2] = _4205[2].xyz;
	    _903 = _4208;
	    vec3 _4217 = normalize(_4208 * _910.xyz);
	    vec4 _712;
	    vec4 _4219 = _712;
	    _4219.x = _4217.x;
	    _4219.y = _4217.y;
	    _4219.z = _4217.z;
	    _4219.w = _910.w;
	    _712 = _4219;
	    vec4 _4228 = vsInput[0]._m1.xyxy;
	    _4228.z = vsInput[0]._m2.x;
	    _4228.w = vsInput[0]._m2.y;
	    vec4 _715;
	    vec4 _716;
	    vec4 _711 = _716;
	    vec4 _710 = _715;
	    vec3 _709 = vec4(vsInput[0].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _708 = _4193;
	    vec4 _707 = _4228;
	    vec4 _706 = _4168;
	    vec4 _705 = _4219;
	    vec2 _911;
	    if (_g_rtx_material_data_._m3 > 0)
	    {
	        if (_g_rtx_material_data_._m3 == 2)
	        {
	            _911 = _4228.zw;
	        }
	        else
	        {
	            _911 = _4228.xy;
	        }
	        vec4 _4251 = _707;
	        _4251.x = _911.x;
	        _4251.y = _911.y;
	        vec4 _4270 = _4251;
	        _4270.x = dot(_4251.xy, _g_rtx_material_data_._m11.xy) + _g_rtx_material_data_._m11.w;
	        _4270.y = dot(_4251.xy, _g_rtx_material_data_._m12.xy) + _g_rtx_material_data_._m12.w;
	        _707 = _4270;
	    }
	    if (_g_rtx_material_data_._m29 > 0)
	    {
	        if (_g_rtx_material_data_._m29 == 2)
	        {
	            _911 = _4228.zw;
	        }
	        else
	        {
	            _911 = _4228.xy;
	        }
	        vec4 _4286 = _707;
	        _4286.z = _911.x;
	        _4286.w = _911.y;
	        vec4 _4305 = _4286;
	        _4305.z = dot(_4286.zw, _g_rtx_material_data_._m35.xy) + _g_rtx_material_data_._m35.w;
	        _4305.w = dot(_4286.zw, _g_rtx_material_data_._m36.xy) + _g_rtx_material_data_._m36.w;
	        _707 = _4305;
	    }
	    vec4 _4308 = _706;
	    vec4 _4310 = _710;
	    _4310.x = _4308.x;
	    _4310.y = _4308.y;
	    _4310.z = _4308.z;
	    _4310.w = _g_rtx_material_data_._m173 * (1.0 - min(_4310.x, min(_4310.y, _4310.z)));
	    _710 = _4310;
	    _4308.x = _g_rtx_material_data_._m172.x;
	    _4308.y = _g_rtx_material_data_._m172.y;
	    _4308.z = _g_rtx_material_data_._m172.z;
	    vec3 _4339 = _4308.xyz * mix(vec3(1.0), vsInput[0]._m7.xyz, vec3(vsInput[0]._m7.w));
	    vec4 _4341 = _4308;
	    _4341.x = _4339.x;
	    _4341.y = _4339.y;
	    _4341.z = _4339.z;
	    _706 = _4341;
	    vec4 _4348 = _711;
	    _4348.x = vsInput[0]._m8.x;
	    _4348.y = vsInput[0]._m8.y;
	    _4348.z = vsInput[0]._m8.z;
	    _4348.w = vsInput[0]._m8.w;
	    _711 = _4348;
	    vec4 _693 = _4348;
	    vec4 _692 = _4310;
	    vec3 _691 = _709;
	    vec3 _690 = _708;
	    vec4 _689 = _707;
	    vec4 _688 = _4341;
	    vec4 _687 = _705;
	    vec3 _900 = vsInput[1]._m3;
	    vec4 _901;
	    vec4 _4365 = _901;
	    _4365.x = vsInput[1]._m4.x;
	    _4365.y = vsInput[1]._m4.y;
	    _4365.z = vsInput[1]._m4.z;
	    _4365.w = vsInput[1]._m4.w;
	    _901 = _4365;
	    vec4 _4390 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _899 = _4390;
	    vec3 _4391 = _4390.xyz;
	    vec3 _4392 = _4391 * vec3(0.077399380505084991455078125);
	    vec3 _4395 = pow((_4391 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _896;
	    if (_4390.x <= 0.040449999272823333740234375)
	    {
	        _896 = _4392.x;
	    }
	    else
	    {
	        _896 = _4395.x;
	    }
	    float _897;
	    if (_4390.y <= 0.040449999272823333740234375)
	    {
	        _897 = _4392.y;
	    }
	    else
	    {
	        _897 = _4395.y;
	    }
	    float _898;
	    if (_4390.z <= 0.040449999272823333740234375)
	    {
	        _898 = _4392.z;
	    }
	    else
	    {
	        _898 = _4395.z;
	    }
	    vec3 _4420 = vec3(_896, _897, _898);
	    vec4 _4422 = _899;
	    _4422.x = _4420.x;
	    _4422.y = _4420.y;
	    _4422.z = _4420.z;
	    _899 = _4422;
	    vec4 _725;
	    vec4 _4429 = _725;
	    _4429.x = _4422.x;
	    _4429.y = _4422.y;
	    _4429.z = _4422.z;
	    _4429.w = _4422.w;
	    _725 = _4429;
	    mat3x4 _4440 = transpose(gl_WorldToObjectEXT);
	    mat3 _895;
	    mat3 _4443 = _895;
	    _4443[0] = _4440[0].xyz;
	    _4443[1] = _4440[1].xyz;
	    _4443[2] = _4440[2].xyz;
	    _895 = _4443;
	    vec3 _4452 = normalize(_4443 * _900.xyz);
	    vec3 _726;
	    vec3 _4454 = _726;
	    _4454.x = _4452.x;
	    _4454.y = _4452.y;
	    _4454.z = _4452.z;
	    _726 = _4454;
	    mat3x4 _4466 = transpose(gl_WorldToObjectEXT);
	    mat3 _894;
	    mat3 _4469 = _894;
	    _4469[0] = _4466[0].xyz;
	    _4469[1] = _4466[1].xyz;
	    _4469[2] = _4466[2].xyz;
	    _894 = _4469;
	    vec3 _4478 = normalize(_4469 * _901.xyz);
	    vec4 _724;
	    vec4 _4480 = _724;
	    _4480.x = _4478.x;
	    _4480.y = _4478.y;
	    _4480.z = _4478.z;
	    _4480.w = _901.w;
	    _724 = _4480;
	    vec4 _4489 = vsInput[1]._m1.xyxy;
	    _4489.z = vsInput[1]._m2.x;
	    _4489.w = vsInput[1]._m2.y;
	    vec4 _727;
	    vec4 _728;
	    vec4 _723 = _728;
	    vec4 _722 = _727;
	    vec3 _721 = vec4(vsInput[1].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _720 = _4454;
	    vec4 _719 = _4489;
	    vec4 _718 = _4429;
	    vec4 _717 = _4480;
	    vec2 _902;
	    if (_g_rtx_material_data_._m3 > 0)
	    {
	        if (_g_rtx_material_data_._m3 == 2)
	        {
	            _902 = _4489.zw;
	        }
	        else
	        {
	            _902 = _4489.xy;
	        }
	        vec4 _4512 = _719;
	        _4512.x = _902.x;
	        _4512.y = _902.y;
	        vec4 _4531 = _4512;
	        _4531.x = dot(_4512.xy, _g_rtx_material_data_._m11.xy) + _g_rtx_material_data_._m11.w;
	        _4531.y = dot(_4512.xy, _g_rtx_material_data_._m12.xy) + _g_rtx_material_data_._m12.w;
	        _719 = _4531;
	    }
	    if (_g_rtx_material_data_._m29 > 0)
	    {
	        if (_g_rtx_material_data_._m29 == 2)
	        {
	            _902 = _4489.zw;
	        }
	        else
	        {
	            _902 = _4489.xy;
	        }
	        vec4 _4547 = _719;
	        _4547.z = _902.x;
	        _4547.w = _902.y;
	        vec4 _4566 = _4547;
	        _4566.z = dot(_4547.zw, _g_rtx_material_data_._m35.xy) + _g_rtx_material_data_._m35.w;
	        _4566.w = dot(_4547.zw, _g_rtx_material_data_._m36.xy) + _g_rtx_material_data_._m36.w;
	        _719 = _4566;
	    }
	    vec4 _4569 = _718;
	    vec4 _4571 = _722;
	    _4571.x = _4569.x;
	    _4571.y = _4569.y;
	    _4571.z = _4569.z;
	    _4571.w = _g_rtx_material_data_._m173 * (1.0 - min(_4571.x, min(_4571.y, _4571.z)));
	    _722 = _4571;
	    _4569.x = _g_rtx_material_data_._m172.x;
	    _4569.y = _g_rtx_material_data_._m172.y;
	    _4569.z = _g_rtx_material_data_._m172.z;
	    vec3 _4600 = _4569.xyz * mix(vec3(1.0), vsInput[1]._m7.xyz, vec3(vsInput[1]._m7.w));
	    vec4 _4602 = _4569;
	    _4602.x = _4600.x;
	    _4602.y = _4600.y;
	    _4602.z = _4600.z;
	    _718 = _4602;
	    vec4 _4609 = _723;
	    _4609.x = vsInput[1]._m8.x;
	    _4609.y = vsInput[1]._m8.y;
	    _4609.z = vsInput[1]._m8.z;
	    _4609.w = vsInput[1]._m8.w;
	    _723 = _4609;
	    vec4 _686 = _4609;
	    vec4 _685 = _4571;
	    vec3 _684 = _721;
	    vec3 _683 = _720;
	    vec4 _682 = _719;
	    vec4 _681 = _4602;
	    vec4 _680 = _717;
	    vec3 _891 = vsInput[2]._m3;
	    vec4 _892;
	    vec4 _4626 = _892;
	    _4626.x = vsInput[2]._m4.x;
	    _4626.y = vsInput[2]._m4.y;
	    _4626.z = vsInput[2]._m4.z;
	    _4626.w = vsInput[2]._m4.w;
	    _892 = _4626;
	    vec4 _4651 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _890 = _4651;
	    vec3 _4652 = _4651.xyz;
	    vec3 _4653 = _4652 * vec3(0.077399380505084991455078125);
	    vec3 _4656 = pow((_4652 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _887;
	    if (_4651.x <= 0.040449999272823333740234375)
	    {
	        _887 = _4653.x;
	    }
	    else
	    {
	        _887 = _4656.x;
	    }
	    float _888;
	    if (_4651.y <= 0.040449999272823333740234375)
	    {
	        _888 = _4653.y;
	    }
	    else
	    {
	        _888 = _4656.y;
	    }
	    float _889;
	    if (_4651.z <= 0.040449999272823333740234375)
	    {
	        _889 = _4653.z;
	    }
	    else
	    {
	        _889 = _4656.z;
	    }
	    vec3 _4681 = vec3(_887, _888, _889);
	    vec4 _4683 = _890;
	    _4683.x = _4681.x;
	    _4683.y = _4681.y;
	    _4683.z = _4681.z;
	    _890 = _4683;
	    vec4 _737;
	    vec4 _4690 = _737;
	    _4690.x = _4683.x;
	    _4690.y = _4683.y;
	    _4690.z = _4683.z;
	    _4690.w = _4683.w;
	    _737 = _4690;
	    mat3x4 _4701 = transpose(gl_WorldToObjectEXT);
	    mat3 _886;
	    mat3 _4704 = _886;
	    _4704[0] = _4701[0].xyz;
	    _4704[1] = _4701[1].xyz;
	    _4704[2] = _4701[2].xyz;
	    _886 = _4704;
	    vec3 _4713 = normalize(_4704 * _891.xyz);
	    vec3 _738;
	    vec3 _4715 = _738;
	    _4715.x = _4713.x;
	    _4715.y = _4713.y;
	    _4715.z = _4713.z;
	    _738 = _4715;
	    mat3x4 _4727 = transpose(gl_WorldToObjectEXT);
	    mat3 _885;
	    mat3 _4730 = _885;
	    _4730[0] = _4727[0].xyz;
	    _4730[1] = _4727[1].xyz;
	    _4730[2] = _4727[2].xyz;
	    _885 = _4730;
	    vec3 _4739 = normalize(_4730 * _892.xyz);
	    vec4 _736;
	    vec4 _4741 = _736;
	    _4741.x = _4739.x;
	    _4741.y = _4739.y;
	    _4741.z = _4739.z;
	    _4741.w = _892.w;
	    _736 = _4741;
	    vec4 _4750 = vsInput[2]._m1.xyxy;
	    _4750.z = vsInput[2]._m2.x;
	    _4750.w = vsInput[2]._m2.y;
	    vec4 _739;
	    vec4 _740;
	    vec4 _735 = _740;
	    vec4 _734 = _739;
	    vec3 _733 = vec4(vsInput[2].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _732 = _4715;
	    vec4 _731 = _4750;
	    vec4 _730 = _4690;
	    vec4 _729 = _4741;
	    vec2 _893;
	    if (_g_rtx_material_data_._m3 > 0)
	    {
	        if (_g_rtx_material_data_._m3 == 2)
	        {
	            _893 = _4750.zw;
	        }
	        else
	        {
	            _893 = _4750.xy;
	        }
	        vec4 _4773 = _731;
	        _4773.x = _893.x;
	        _4773.y = _893.y;
	        vec4 _4792 = _4773;
	        _4792.x = dot(_4773.xy, _g_rtx_material_data_._m11.xy) + _g_rtx_material_data_._m11.w;
	        _4792.y = dot(_4773.xy, _g_rtx_material_data_._m12.xy) + _g_rtx_material_data_._m12.w;
	        _731 = _4792;
	    }
	    if (_g_rtx_material_data_._m29 > 0)
	    {
	        if (_g_rtx_material_data_._m29 == 2)
	        {
	            _893 = _4750.zw;
	        }
	        else
	        {
	            _893 = _4750.xy;
	        }
	        vec4 _4808 = _731;
	        _4808.z = _893.x;
	        _4808.w = _893.y;
	        vec4 _4827 = _4808;
	        _4827.z = dot(_4808.zw, _g_rtx_material_data_._m35.xy) + _g_rtx_material_data_._m35.w;
	        _4827.w = dot(_4808.zw, _g_rtx_material_data_._m36.xy) + _g_rtx_material_data_._m36.w;
	        _731 = _4827;
	    }
	    vec4 _4830 = _730;
	    vec4 _4832 = _734;
	    _4832.x = _4830.x;
	    _4832.y = _4830.y;
	    _4832.z = _4830.z;
	    _4832.w = _g_rtx_material_data_._m173 * (1.0 - min(_4832.x, min(_4832.y, _4832.z)));
	    _734 = _4832;
	    _4830.x = _g_rtx_material_data_._m172.x;
	    _4830.y = _g_rtx_material_data_._m172.y;
	    _4830.z = _g_rtx_material_data_._m172.z;
	    vec3 _4861 = _4830.xyz * mix(vec3(1.0), vsInput[2]._m7.xyz, vec3(vsInput[2]._m7.w));
	    vec4 _4863 = _4830;
	    _4863.x = _4861.x;
	    _4863.y = _4861.y;
	    _4863.z = _4861.z;
	    _730 = _4863;
	    vec4 _4870 = _735;
	    _4870.x = vsInput[2]._m8.x;
	    _4870.y = vsInput[2]._m8.y;
	    _4870.z = vsInput[2]._m8.z;
	    _4870.w = vsInput[2]._m8.w;
	    _735 = _4870;
	    vec3 _679 = _733;
	    vec3 _678 = _732;
	    vec3 _4905 = ((_690 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_683 * _22.barycentrics.x)) + (_732 * _22.barycentrics.y);
	    bool _4911 = gl_HitKindEXT == 254u;
	    vec3 _741;
	    vec4 _4948 = ((_693 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_686 * _22.barycentrics.x)) + (_4870 * _22.barycentrics.y);
	    vec4 _704 = _4948;
	    vec4 _703 = ((_692 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_685 * _22.barycentrics.x)) + (_4832 * _22.barycentrics.y);
	    vec3 _702 = _4905;
	    vec4 _701 = ((_689 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_682 * _22.barycentrics.x)) + (_731 * _22.barycentrics.y);
	    vec4 _700 = ((_688 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_681 * _22.barycentrics.x)) + (_4863 * _22.barycentrics.y);
	    vec4 _699 = ((_687 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_680 * _22.barycentrics.x)) + (_729 * _22.barycentrics.y);
	    bool _698 = _4911;
	    float _872 = clamp((_4948.x * 1.10000002384185791015625) - 0.0500000007450580596923828125, 0.0, 1.0);
	    vec3 _795 = vec3(0.5);
	    vec2 _794 = vec2(0.5);
	    float _793 = 0.0;
	    vec3 _792 = vec3(0.0);
	    float _791 = 0.039999999105930328369140625;
	    vec3 _790 = vec3(0.0);
	    float _789 = 0.0;
	    vec3 _788 = vec3(0.0);
	    vec3 _786 = vec3(1.0);
	    bool _785 = false;
	    vec3 _4962 = _4905.xyz;
	    vec3 _787 = _4962;
	    if (dot(_4962, _4962) >= 1.0099999904632568359375)
	    {
	        _787 = _741.xyz;
	    }
	    _791 = _g_rtx_material_data_._m188;
	    _786 = normalize(cross(_684 - _691, _733 - _691));
	    bool _870;
	    if (_g_rtx_material_data_._m187)
	    {
	        _870 = !_g_rtx_material_data_._m186;
	    }
	    else
	    {
	        _870 = false;
	    }
	    if (_870)
	    {
	        float _871;
	        if (_4911)
	        {
	            _871 = 1.0;
	        }
	        else
	        {
	            _871 = -1.0;
	        }
	        _787 *= _871;
	        if (_4911)
	        {
	            _871 = 1.0;
	        }
	        else
	        {
	            _871 = -1.0;
	        }
	        _786 *= _871;
	        _785 = !_4911;
	    }
	    vec3 _4993 = _787;
	    vec3 _4994 = normalize(_4993);
	    _787 = _4994;
	    vec3 _784 = _4994;
	    vec3 _783 = _795;
	    vec2 _782 = _794;
	    float _781 = _793;
	    vec3 _780 = _792;
	    float _779 = _791;
	    vec3 _778 = _790;
	    float _777 = _789;
	    vec3 _776 = _788;
	    vec3 _775 = _4994;
	    vec3 _774 = _786;
	    bool _773 = _785;
	    vec2 _772 = vec2(0.0);
	    vec2 _771 = vec2(0.0);
	    vec2 _770 = vec2(0.0);
	    vec2 _769 = vec2(0.0);
	    vec2 _768 = vec2(0.0);
	    vec2 _767 = vec2(0.0);
	    vec2 _766 = vec2(0.0);
	    ivec2 _765 = ivec2(0);
	    ivec2 _764 = ivec2(0);
	    if (_g_rtx_material_data_._m206)
	    {
	        vec3 _5011 = abs(_775);
	        vec3 _865 = _5011;
	        float _5012 = _5011.x;
	        float _5013 = _5011.y;
	        bool _866;
	        if (_5012 > _5013)
	        {
	            _866 = _5012 > _5011.z;
	        }
	        else
	        {
	            _866 = false;
	        }
	        ivec3 _867;
	        if (_866)
	        {
	            _867 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5013 > _5011.z)
	            {
	                _867 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _867 = ivec3(2, 0, 1);
	            }
	        }
	        if (_5012 < _5013)
	        {
	            _866 = _5012 < _5011.z;
	        }
	        else
	        {
	            _866 = false;
	        }
	        ivec3 _868;
	        if (_866)
	        {
	            _868 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5013 < _5011.z)
	            {
	                _868 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _868 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _5047 = (ivec3(3) - _868) - _867;
	        ivec2 _869;
	        if (_867.x == 1)
	        {
	            _869 = _867.zy;
	        }
	        else
	        {
	            _869 = _867.yz;
	        }
	        ivec2 _5059 = _765;
	        _5059.x = _869.x;
	        _5059.y = _869.y;
	        _765 = _5059;
	        int _5063 = _5047.x;
	        if (_5063 == 1)
	        {
	            _869 = _5047.zy;
	        }
	        else
	        {
	            _869 = _5047.yz;
	        }
	        ivec2 _5072 = _764;
	        _5072.x = _869.x;
	        _5072.y = _869.y;
	        _764 = _5072;
	        _766 = vec2(_865[_867.x], _865[_5063]) / vec2(_865[_867.x] + _865[_5063]);
	        vec3 _856 = _776 * _g_rtx_material_data_._g_fl_AutoPad28_.xyz;
	        _772 = vec2(_856[_765.x], _856[_765.y]);
	        vec3 _857 = vec3(0.0);
	        vec3 _858 = vec3(0.0);
	        _770 = vec2(_857[_765.x], _858[_765.y]);
	        vec3 _859 = vec3(0.0);
	        vec3 _860 = vec3(0.0);
	        _769 = vec2(_859[_765.x], _860[_765.y]);
	        _771 = vec2(_856[_5072.x], _856[_5072.y]);
	        vec3 _861 = vec3(0.0);
	        vec3 _862 = vec3(0.0);
	        _768 = vec2(_861[_5072.x], _862[_5072.y]);
	        vec3 _863 = vec3(0.0);
	        vec3 _864 = vec3(0.0);
	        _767 = vec2(_863[_5072.x], _864[_5072.y]);
	    }
	    bool _873;
	    if (_g_rtx_material_data_._m29 > 1)
	    {
	        _873 = true;
	    }
	    else
	    {
	        _873 = _g_rtx_material_data_._m3 > 1;
	    }
	    bool _854;
	    if (_g_rtx_material_data_._m187)
	    {
	        _854 = !_g_rtx_material_data_._m186;
	    }
	    else
	    {
	        _854 = false;
	    }
	    if (_854)
	    {
	        float _855;
	        if (_698)
	        {
	            _855 = 1.0;
	        }
	        else
	        {
	            _855 = -1.0;
	        }
	        _854 = _855 < 0.0;
	    }
	    else
	    {
	        _854 = false;
	    }
	    vec3 _799 = vec3(0.0);
	    vec3 _798 = vec3(0.0);
	    float _852;
	    if (_699.w > 0.0)
	    {
	        _852 = 1.0;
	    }
	    else
	    {
	        _852 = -1.0;
	    }
	    float _5173 = 1.0 / length(_702);
	    vec3 _800 = _702 * _5173;
	    vec3 _697 = _699.xyz * _5173;
	    vec3 _696 = (cross(_702, _699.xyz) * _852) * _5173;
	    if (_854)
	    {
	        _800 *= (-1.0);
	    }
	    vec3 _797 = _799 - (_800 * dot(_799, _800));
	    vec3 _796 = _798 - (_800 * dot(_798, _800));
	    int _853;
	    if (dot(_798, cross(_800, _799)) < 0.0)
	    {
	        _853 = -1;
	    }
	    else
	    {
	        _853 = 1;
	    }
	    vec3 _827 = _800;
	    vec3 _826 = _797;
	    vec3 _825 = _796;
	    float _824 = float(_853);
	    vec3 _762;
	    vec3 _763;
	    if (_873)
	    {
	        float _851;
	        if (false)
	        {
	            _851 = -1.0;
	        }
	        else
	        {
	            _851 = 1.0;
	        }
	        vec2 _5210 = vec2(0.0, -0.0) * _851;
	        vec3 _801 = (_826 * _5210.x) + (_825 * _5210.y);
	        float _5218 = abs(0.0);
	        if (_5218 > 0.0)
	        {
	            _801 = normalize(_801);
	        }
	        _763 = _801;
	        _762 = cross(_827, _801) * (_851 * _824);
	    }
	    float _874 = 0.0;
	    float _875 = max(min(_704.w + _g_rtx_material_data_._m26, 1.0), 9.9999997473787516355514526367188e-05);
	    vec3 _876 = vec3(0.0);
	    float _877 = _g_rtx_material_data_._m67;
	    float _878 = _g_rtx_material_data_._m66;
	    vec2 _879 = vec2(0.0);
	    vec4 _761 = vec4(0.0);
	    vec3 _760 = vec3(0.0);
	    vec3 _759 = vec3(0.0);
	    vec4 _756 = vec4(0.0);
	    float _755 = 0.0;
	    float _754 = 0.0;
	    float _753 = 0.0;
	    float _752 = 0.0;
	    vec3 _5244 = vec3(0.0);
	    _5244.x = _701.x;
	    _5244.y = _701.y;
	    vec3 _758 = _5244;
	    vec2 _757 = _g_rtx_material_data_._m4.xy;
	    vec4 _850;
	    if (_g_rtx_material_data_._m3 == 0)
	    {
	        vec2 _5263 = _772;
	        vec2 _5264 = _5263 * _757;
	        _772 = _5264;
	        vec2 _5265 = _770;
	        vec2 _5266 = _5265 * _757;
	        _770 = _5266;
	        vec2 _5267 = _769;
	        vec2 _5268 = _5267 * _757;
	        _769 = _5268;
	        vec2 _5269 = _771;
	        vec2 _5270 = _5269 * _757;
	        _771 = _5270;
	        vec2 _5271 = _768;
	        vec2 _5272 = _5271 * _757;
	        _768 = _5272;
	        vec2 _5273 = _767;
	        vec2 _5274 = _5273 * _757;
	        _767 = _5274;
	        vec4 _5283 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m53], g_bindless_Sampler[_g_rtx_material_data_._m182]), _5264.xy, _5266.xy, _5268.xy);
	        vec4 _5291 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m53], g_bindless_Sampler[_g_rtx_material_data_._m182]), _5270.xy, _5272.xy, _5274.xy);
	        vec2 _5292 = _766;
	        vec2 _5297 = (_5292 * 3.0) + vec2(_5283.x, _5291.x);
	        vec2 _5304 = max(_5297 - vec2(max(_5297.x, _5297.y) - 0.0500000007450580596923828125), vec2(0.0));
	        vec2 _5309 = _5304 / vec2(_5304.x + _5304.y);
	        _766 = _5309;
	        _850 = (_5283 * _5309.x) + (_5291 * _5309.y);
	    }
	    else
	    {
	        _850 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m53], g_bindless_Sampler[_g_rtx_material_data_._m182]), _758.xy, 0.0).xyzw;
	    }
	    _755 = _850.x;
	    _753 = _850.y;
	    _754 = _850.w;
	    float _5322 = _877;
	    float _5323 = _5322 + (_874 * 0.5);
	    _877 = _5323;
	    float _5325 = _878;
	    float _5326 = _5325 + _875;
	    _878 = _5326;
	    vec2 _5329 = _879;
	    _5329.x = (-_5323) * _5326;
	    _5329.y = (1.0 - _5323) * _5326;
	    _879 = _5329;
	    if (false)
	    {
	        _878 -= (_875 * 2.0);
	    }
	    _755 = (_755 - _877) * _878;
	    vec2 _810 = _772;
	    vec2 _809 = _771;
	    vec2 _808 = _770;
	    vec2 _807 = _769;
	    vec2 _806 = _768;
	    vec2 _805 = _767;
	    vec2 _804 = _766;
	    ivec2 _803 = _765;
	    ivec2 _802 = _764;
	    if (_g_rtx_material_data_._m3 == 0)
	    {
	        vec2 _5412 = _810;
	        vec2 _5413 = _5412 * _757;
	        _810 = _5413;
	        vec2 _5414 = _808;
	        vec2 _5415 = _5414 * _757;
	        _808 = _5415;
	        vec2 _5416 = _807;
	        vec2 _5417 = _5416 * _757;
	        _807 = _5417;
	        _809 *= _757;
	        _806 *= _757;
	        _805 *= _757;
	        _761 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m184], g_bindless_Sampler[_g_rtx_material_data_._m182]), _5413.xy, _5415.xy, _5417.xy) * _804.x;
	        vec4 _5443 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m52], g_bindless_Sampler[_g_rtx_material_data_._m182]), _5413.xy, _5415.xy, _5417.xy);
	        _752 = _5443.z * _804.x;
	        float _5447 = _5443.x;
	        float _5448 = _5443.y;
	        float _5450 = (_5447 + _5448) - 1.00392162799835205078125;
	        float _5451 = _5447 - _5448;
	        vec3 _5462 = (normalize(vec3(vec2(_5450, _5451), (1.0 - abs(_5450)) - abs(_5451))).xyz * _804.x) * _g_rtx_material_data_._m73;
	        vec4 _5464;
	        _5464.x = _5462.x;
	        _5464.y = _5462.y;
	        vec4 _5468 = _5464;
	        _5468.z = _5462.z;
	        _759 = (_608[_803.x] * _5464.x) + (_612[_803.y] * _5464.y);
	        if (_804.y > 0.0)
	        {
	            _761 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m184], g_bindless_Sampler[_g_rtx_material_data_._m182]), _809.xy, _806.xy, _805.xy) * _804.y);
	            vec4 _5509 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m52], g_bindless_Sampler[_g_rtx_material_data_._m182]), _809.xy, _806.xy, _805.xy);
	            _752 += (_5509.z * _804.y);
	            float _5515 = _5509.x;
	            float _5516 = _5509.y;
	            float _5518 = (_5515 + _5516) - 1.00392162799835205078125;
	            float _5519 = _5515 - _5516;
	            vec3 _5530 = (normalize(vec3(vec2(_5518, _5519), (1.0 - abs(_5518)) - abs(_5519))).xyz * _804.y) * _g_rtx_material_data_._m73;
	            vec4 _5532;
	            _5532.x = _5530.x;
	            _5532.y = _5530.y;
	            vec4 _5536 = _5532;
	            _5536.z = _5530.z;
	            _759 += ((_608[_802.x] * _5532.x) + (_612[_802.y] * _5532.y));
	        }
	        _759 = normalize(_759 + _775);
	    }
	    else
	    {
	        _761 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m184], g_bindless_Sampler[_g_rtx_material_data_._m182]), _758.xy, _756.xy, _756.zw).xyzw;
	        vec4 _5384 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m52], g_bindless_Sampler[_g_rtx_material_data_._m182]), _758.xy, _756.xy, _756.zw);
	        vec3 _5385 = _5384.xyz;
	        _752 = _5384.z;
	        float _5387 = _5385.x;
	        float _5388 = _5385.y;
	        float _5390 = (_5387 + _5388) - 1.00392162799835205078125;
	        float _5391 = _5387 - _5388;
	        vec3 _5398 = normalize(vec3(vec2(_5390, _5391), (1.0 - abs(_5390)) - abs(_5391)));
	        vec3 _5400 = _5385;
	        _5400.x = _5398.x;
	        _5400.y = _5398.y;
	        _5400.z = _5398.z;
	        vec2 _5406 = _5400.xy * _g_rtx_material_data_._m73;
	        vec3 _5408 = _5400;
	        _5408.x = _5406.x;
	        _5408.y = _5406.y;
	        _760 = _5408;
	    }
	    if (!(_g_rtx_material_data_._m3 == 0))
	    {
	        vec3 _5564 = _760;
	        vec3 _5571 = _5564;
	        _5571.x = dot(_5564.xy, _g_rtx_material_data_._m13.xy);
	        _5571.y = dot(_5564.xy, _g_rtx_material_data_._m13.zw);
	        _760 = _5571;
	        vec3 _811;
	        vec3 _812;
	        if (_g_rtx_material_data_._m3 > 1)
	        {
	            _812 = _763;
	            _811 = _762;
	        }
	        else
	        {
	            _812 = _697;
	            _811 = _696;
	        }
	        vec3 _5579 = abs(_760.xyz);
	        vec2 _5592 = (-vec2(_760.x, (-1.0) * _760.y)) / vec2(max(_5579.z, 0.0078125 * max(_5579.x, _5579.y)));
	        _759 = normalize(_827 - ((_812 * _5592.x) + (_811 * _5592.y)));
	    }
	    _752 = clamp(((_g_rtx_material_data_._m71 * (_752 - 0.5)) + 0.5) * _g_rtx_material_data_._m72, 0.0, 1.0);
	    vec4 _845;
	    if (_g_rtx_material_data_._m65)
	    {
	        _845 = vec4((vec4(_761.xyz, 1.0) * _g_rtx_material_data_._m79).xyz, _761.w);
	    }
	    else
	    {
	        _845 = _761;
	    }
	    vec4 _5635 = _845;
	    _5635.w = clamp(mix(_g_rtx_material_data_._m58.x, _g_rtx_material_data_._m58.z, pow(_5635.w, _g_rtx_material_data_._m58.y)), 0.0, 1.0);
	    float _5645 = _754;
	    float _5646 = _5645 * float(_g_rtx_material_data_._m74);
	    _754 = _5646;
	    float _5647 = _753;
	    float _5652 = clamp(((_g_rtx_material_data_._m56 * (_5647 - 0.5)) + 0.5) * _g_rtx_material_data_._m57, 0.0, 1.0);
	    _753 = _5652;
	    vec3 _5656 = mix(_5635.xyz, vec4((vec4(_761.xyz, 1.0) * _g_rtx_material_data_._m78).xyz, _672).xyz, vec3(_5652));
	    vec4 _5658 = _5635;
	    _5658.x = _5656.x;
	    _5658.y = _5656.y;
	    _5658.z = _5656.z;
	    float _5669 = dot(_5658.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _5672 = normalize(max(_703.xyz, vec3(0.001000000047497451305389404296875)));
	    vec4 _5691 = vec4(clamp(mix(_5658.xyz, (_5672 * min(_5669 / dot(_5672.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _5669) * max(_703.x, max(_703.y, _703.z)))).xyz, vec3((_703.w * _5652) * float(_g_rtx_material_data_._m75))), vec3(0.0), vec3(1.0)).xyz, _5658.w);
	    _761 = _5691;
	    _784 = _759.xyz;
	    _783 = _5691.xyz;
	    vec2 _5697 = _782;
	    _5697.x = _752;
	    _782 = _5697;
	    _781 = _5646;
	    _777 = _755;
	    float _880 = _g_rtx_material_data_._m111;
	    float _881 = _g_rtx_material_data_._m110;
	    vec2 _882 = vec2(0.0);
	    float _883 = 0.0;
	    float _884 = 1.0;
	    vec4 _751 = vec4(0.0);
	    vec3 _750 = vec3(0.0);
	    vec3 _749 = vec3(0.0);
	    vec3 _748 = vec3(0.0);
	    vec2 _747 = vec2(0.0);
	    vec4 _746 = vec4(0.0);
	    float _745 = 0.0;
	    float _744 = 0.0;
	    float _743 = 0.0;
	    float _742 = 0.0;
	    vec3 _5708 = _748;
	    _5708.x = _701.z;
	    _5708.y = _701.w;
	    _748 = _5708;
	    _747 = _g_rtx_material_data_._m30.xy;
	    vec4 _844;
	    if (_g_rtx_material_data_._m29 == 0)
	    {
	        vec2 _5728 = _772;
	        vec2 _5729 = _5728 * _747;
	        _772 = _5729;
	        vec2 _5730 = _770;
	        vec2 _5731 = _5730 * _747;
	        _770 = _5731;
	        vec2 _5732 = _769;
	        vec2 _5733 = _5732 * _747;
	        _769 = _5733;
	        vec2 _5734 = _771;
	        vec2 _5735 = _5734 * _747;
	        _771 = _5735;
	        vec2 _5736 = _768;
	        vec2 _5737 = _5736 * _747;
	        _768 = _5737;
	        vec2 _5738 = _767;
	        vec2 _5739 = _5738 * _747;
	        _767 = _5739;
	        vec4 _5748 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m99], g_bindless_Sampler[_g_rtx_material_data_._m182]), _5729.xy, _5731.xy, _5733.xy);
	        vec4 _5756 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m99], g_bindless_Sampler[_g_rtx_material_data_._m182]), _5735.xy, _5737.xy, _5739.xy);
	        vec2 _5757 = _766;
	        vec2 _5762 = (_5757 * 3.0) + vec2(_5748.x, _5756.x);
	        vec2 _5769 = max(_5762 - vec2(max(_5762.x, _5762.y) - 0.0500000007450580596923828125), vec2(0.0));
	        vec2 _5774 = _5769 / vec2(_5769.x + _5769.y);
	        _766 = _5774;
	        _844 = (_5748 * _5774.x) + (_5756 * _5774.y);
	    }
	    else
	    {
	        _844 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m99], g_bindless_Sampler[_g_rtx_material_data_._m182]), _748.xy, 0.0).xyzw;
	    }
	    _745 = _844.x;
	    _743 = _844.y;
	    _744 = _844.w;
	    float _5787 = _880;
	    float _5788 = _5787 + (_874 * 0.5);
	    _880 = _5788;
	    float _5790 = _881;
	    float _5791 = _5790 + _875;
	    _881 = _5791;
	    vec2 _5794 = _882;
	    _5794.x = (-_5788) * _5791;
	    _5794.y = (1.0 - _5788) * _5791;
	    _882 = _5794;
	    if (true)
	    {
	        _881 -= (_875 * 2.0);
	    }
	    _745 = (_745 - _880) * _881;
	    if (_g_rtx_material_data_._m202)
	    {
	        _872 *= clamp((((dot(_g_rtx_material_data_._m114.xyz, mix(_775.xyz, _784, vec3(_g_rtx_material_data_._m116)).xyz) - 1.0) + (_g_rtx_material_data_._m115 * 2.0)) / (_g_rtx_material_data_._m117 * 2.0)) + 0.5, 0.0, 1.0);
	    }
	    float _5852 = _745 + mix((_879.x - _882.y) - _875, _879.y - _882.x, _872);
	    _884 = clamp((_5852 + _880) - _777, 0.0, 1.0);
	    float _5856 = max(_777, _5852);
	    if (true)
	    {
	        vec3 _5886 = _876;
	        _5886.x = _777;
	        _5886.y = _5852;
	        _876 = _5886;
	        vec2 _5894 = max((_5886.xy - vec2(_5856)) + vec2(_875), vec2(0.0));
	        _5894.x = _5894.x + 9.9999997473787516355514526367188e-05;
	        _883 = (_5894 / vec2(_5894.x + _5894.y)).y;
	    }
	    else
	    {
	        if (false)
	        {
	            vec3 _5862 = _876;
	            _5862.z = _5852;
	            _876 = _5862;
	            vec3 _5869 = max((_5862.xyz - vec3(_5856)) + vec3(_875), vec3(0.0));
	            _5869.x = _5869.x + 9.9999997473787516355514526367188e-05;
	            vec3 _5884;
	            _5884.z = (_5869.xyz / vec3((_5869.x + _5869.y) + _5869.z)).z;
	            _883 = _5884.z;
	        }
	    }
	    float _5904 = _883;
	    float _5908 = clamp((_5904 * mix(0.5, _5852, _g_rtx_material_data_._m112)) * 2.0, 0.0, 1.0);
	    _883 = _5908;
	    bool _5909 = _5908 > 0.0500000007450580596923828125;
	    if (_5909)
	    {
	        vec2 _821 = _772;
	        vec2 _820 = _771;
	        vec2 _819 = _770;
	        vec2 _818 = _769;
	        vec2 _817 = _768;
	        vec2 _816 = _767;
	        vec2 _815 = _766;
	        ivec2 _814 = _765;
	        ivec2 _813 = _764;
	        if (_g_rtx_material_data_._m29 == 0)
	        {
	            vec2 _5978 = _821;
	            vec2 _5979 = _5978 * _747;
	            _821 = _5979;
	            vec2 _5980 = _819;
	            vec2 _5981 = _5980 * _747;
	            _819 = _5981;
	            vec2 _5982 = _818;
	            vec2 _5983 = _5982 * _747;
	            _818 = _5983;
	            _820 *= _747;
	            _817 *= _747;
	            _816 *= _747;
	            _751 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m97], g_bindless_Sampler[_g_rtx_material_data_._m182]), _5979.xy, _5981.xy, _5983.xy) * _815.x;
	            vec4 _6009 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m98], g_bindless_Sampler[_g_rtx_material_data_._m182]), _5979.xy, _5981.xy, _5983.xy);
	            _742 = _6009.z * _815.x;
	            float _6013 = _6009.x;
	            float _6014 = _6009.y;
	            float _6016 = (_6013 + _6014) - 1.00392162799835205078125;
	            float _6017 = _6013 - _6014;
	            vec3 _6028 = (normalize(vec3(vec2(_6016, _6017), (1.0 - abs(_6016)) - abs(_6017))).xyz * _815.x) * _g_rtx_material_data_._m93;
	            vec4 _6030;
	            _6030.x = _6028.x;
	            _6030.y = _6028.y;
	            vec4 _6034 = _6030;
	            _6034.z = _6028.z;
	            _749 = (_608[_814.x] * _6030.x) + (_612[_814.y] * _6030.y);
	            if (_815.y > 0.0)
	            {
	                _751 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m97], g_bindless_Sampler[_g_rtx_material_data_._m182]), _820.xy, _817.xy, _816.xy) * _815.y);
	                vec4 _6075 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m98], g_bindless_Sampler[_g_rtx_material_data_._m182]), _820.xy, _817.xy, _816.xy);
	                _742 += (_6075.z * _815.y);
	                float _6081 = _6075.x;
	                float _6082 = _6075.y;
	                float _6084 = (_6081 + _6082) - 1.00392162799835205078125;
	                float _6085 = _6081 - _6082;
	                vec3 _6096 = (normalize(vec3(vec2(_6084, _6085), (1.0 - abs(_6084)) - abs(_6085))).xyz * _815.y) * _g_rtx_material_data_._m93;
	                vec4 _6098;
	                _6098.x = _6096.x;
	                _6098.y = _6096.y;
	                vec4 _6102 = _6098;
	                _6102.z = _6096.z;
	                _749 += ((_608[_813.x] * _6098.x) + (_612[_813.y] * _6098.y));
	            }
	            _749 = normalize(_749 + _775);
	        }
	        else
	        {
	            _751 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m97], g_bindless_Sampler[_g_rtx_material_data_._m182]), _748.xy, _746.xy, _746.zw).xyzw;
	            vec4 _5950 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m98], g_bindless_Sampler[_g_rtx_material_data_._m182]), _748.xy, _746.xy, _746.zw);
	            vec3 _5951 = _5950.xyz;
	            _742 = _5950.z;
	            float _5953 = _5951.x;
	            float _5954 = _5951.y;
	            float _5956 = (_5953 + _5954) - 1.00392162799835205078125;
	            float _5957 = _5953 - _5954;
	            vec3 _5964 = normalize(vec3(vec2(_5956, _5957), (1.0 - abs(_5956)) - abs(_5957)));
	            vec3 _5966 = _5951;
	            _5966.x = _5964.x;
	            _5966.y = _5964.y;
	            _5966.z = _5964.z;
	            vec2 _5972 = _5966.xy * _g_rtx_material_data_._m93;
	            vec3 _5974 = _5966;
	            _5974.x = _5972.x;
	            _5974.y = _5972.y;
	            _750 = _5974;
	        }
	        if (!(_g_rtx_material_data_._m29 == 0))
	        {
	            vec3 _6130 = _750;
	            vec3 _6137 = _6130;
	            _6137.x = dot(_6130.xy, _g_rtx_material_data_._m37.xy);
	            _6137.y = dot(_6130.xy, _g_rtx_material_data_._m37.zw);
	            _750 = _6137;
	            vec3 _822;
	            vec3 _823;
	            if (_g_rtx_material_data_._m29 > 1)
	            {
	                _823 = _763;
	                _822 = _762;
	            }
	            else
	            {
	                _823 = _697;
	                _822 = _696;
	            }
	            vec3 _6145 = abs(_750.xyz);
	            vec2 _6158 = (-vec2(_750.x, (-1.0) * _750.y)) / vec2(max(_6145.z, 0.0078125 * max(_6145.x, _6145.y)));
	            _749 = normalize(_827 - ((_823 * _6158.x) + (_822 * _6158.y)));
	        }
	        _742 = clamp(((_g_rtx_material_data_._m91 * (_742 - 0.5)) + 0.5) * _g_rtx_material_data_._m92, 0.0, 1.0);
	        vec4 _839;
	        if (_g_rtx_material_data_._m107)
	        {
	            _839 = vec4((vec4(_751.xyz, 1.0) * _g_rtx_material_data_._m109).xyz, _751.w);
	        }
	        else
	        {
	            _839 = _751;
	        }
	        vec4 _6201 = _839;
	        _6201.w = clamp(mix(_g_rtx_material_data_._m100.x, _g_rtx_material_data_._m100.z, pow(_6201.w, _g_rtx_material_data_._m100.y)), 0.0, 1.0);
	        _744 *= float(_g_rtx_material_data_._m94);
	        float _6213 = _743;
	        float _6218 = clamp(((_g_rtx_material_data_._m95 * (_6213 - 0.5)) + 0.5) * _g_rtx_material_data_._m96, 0.0, 1.0);
	        _743 = _6218;
	        vec3 _6222 = mix(_6201.xyz, vec4((vec4(_751.xyz, 1.0) * _g_rtx_material_data_._m108).xyz, _672).xyz, vec3(_6218));
	        vec4 _6224 = _6201;
	        _6224.x = _6222.x;
	        _6224.y = _6222.y;
	        _6224.z = _6222.z;
	        float _6235 = dot(_6224.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        vec3 _6238 = normalize(max(_703.xyz, vec3(0.001000000047497451305389404296875)));
	        _751 = vec4(clamp(mix(_6224.xyz, (_6238 * min(_6235 / dot(_6238.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _6235) * max(_703.x, max(_703.y, _703.z)))).xyz, vec3((_703.w * _6218) * float(_g_rtx_material_data_._m121))), vec3(0.0), vec3(1.0)).xyz, _6224.w);
	    }
	    if (_5909)
	    {
	        _784 = mix(mix(_784, normalize(mix(_775, (_784 + _749.xyz) * vec3(0.5), vec3(2.0))), vec3(_883 * _g_rtx_material_data_._m84)), _749.xyz, vec3((_883 * _884) * _g_rtx_material_data_._m83));
	        vec3 _6292 = _751.xyz * 12.9200000762939453125;
	        vec3 _6295 = (pow(_751.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	        float _836;
	        if (_751.x <= 0.003130800090730190277099609375)
	        {
	            _836 = _6292.x;
	        }
	        else
	        {
	            _836 = _6295.x;
	        }
	        float _837;
	        if (_751.y <= 0.003130800090730190277099609375)
	        {
	            _837 = _6292.y;
	        }
	        else
	        {
	            _837 = _6295.y;
	        }
	        float _838;
	        if (_751.z <= 0.003130800090730190277099609375)
	        {
	            _838 = _6292.z;
	        }
	        else
	        {
	            _838 = _6295.z;
	        }
	        _783 = mix(_783 * mix(vec3(1.0), vec3(_836, _837, _838) * 2.0, vec3(_883 * _g_rtx_material_data_._m82)), _751.xyz, vec3(_883 * _g_rtx_material_data_._m81));
	        vec2 _6330 = _782;
	        _6330.x = _6330.x * (1.0 + ((((_742 - _6330.x) * 2.0) * _883) * _g_rtx_material_data_._m86));
	        _6330.x = mix(_6330.x, _742, _883 * _g_rtx_material_data_._m85);
	        _782 = _6330;
	        _781 = mix(_781 * mix(1.0, _744 * 2.0, _883 * _g_rtx_material_data_._m88), _744, _883 * _g_rtx_material_data_._m87);
	        _777 = mix(_777, _745, _883);
	    }
	    float _6356 = saturate(1.0 - _883);
	    vec3 _6387 = _783;
	    vec3 _6388 = _6387 * mix(vec3(1.0), _700.xyz, vec3(clamp(clamp(((float(!_g_rtx_material_data_._m70) * _6356) + (float(!_g_rtx_material_data_._m120) * _883)) + ((_753 * _6356) + (_743 * _883)), 0.0, 1.0) * ((float(_g_rtx_material_data_._m69) * _6356) + (float(_g_rtx_material_data_._m119) * _883)), 0.0, 1.0)));
	    _783 = _6388;
	    vec2 _6389 = _782;
	    vec2 _6391 = _6389;
	    _6391.x = _6389.x;
	    _6391.y = _6389.x;
	    _782 = _6391;
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _774;
	    _21._m2 = _775;
	    vec3 _828[3] = vec3[](_690, _683, _678);
	    vec3 _829[3] = vec3[](_691, _684, _679);
	    vec3 _6427 = ((_691 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_684 * _22.barycentrics.x)) + (_679 * _22.barycentrics.y);
	    vec3 _830[3];
	    _830[0] = _6427 - (_690 * dot(_6427 - _691, _690));
	    _830[1] = _6427 - (_683 * dot(_6427 - _684, _683));
	    _830[2] = _6427 - (_678 * dot(_6427 - _679, _678));
	    vec3 _6455 = ((_830[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_830[1] * _22.barycentrics.x)) + (_830[2] * _22.barycentrics.y);
	    vec3 _831[3];
	    _831[0] = cross(_691 - _684, _21._m1);
	    _831[1] = cross(_684 - _679, _21._m1);
	    _831[2] = cross(_679 - _691, _21._m1);
	    float _832 = dot(_6455 - _6427, _21._m1);
	    vec3 _833 = _6455;
	    int _834 = 0;
	    for (;;)
	    {
	        bool _6471_ladder_break = false;
	        do
	        {
	            if (!(_834 < 3))
	            {
	                _6471_ladder_break = true;
	                break;
	            }
	            if (_832 > 0.00999999977648258209228515625)
	            {
	                _6471_ladder_break = true;
	                break;
	            }
	            if (dot(_831[_834], _831[_834]) == 0.0)
	            {
	                break;
	            }
	            _831[_834] = normalize(_831[_834]);
	            int _835 = 0;
	            for (;;)
	            {
	                if (!(_835 < 3))
	                {
	                    break;
	                }
	                vec3 _6509 = _828[_835] - (_831[_834] * dot(_831[_834], _828[_835]));
	                _830[_835] = _6427 - (_6509 * dot(_6427 - _829[_835], _6509));
	                _835++;
	                continue;
	            }
	            vec3 _6533 = ((_830[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_830[1] * _22.barycentrics.x)) + (_830[2] * _22.barycentrics.y);
	            _832 = dot(_6533 - _6427, _21._m1);
	            _833 = _6533;
	            break;
	        } while(false);
	        if (_6471_ladder_break)
	        {
	            break;
	        }
	        _834++;
	        continue;
	    }
	    if (!(_832 > 0.00999999977648258209228515625))
	    {
	        _833 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _833;
	    _21._m6 = _773;
	    f16vec3 _6546 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_6546, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _6546, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(_784);
	    _21._m7._m2 = f16vec3(_6388);
	    _21._m7._m4 = f16vec3(_780);
	    _21._m7._m5 = float16_t(_779);
	    _21._m7._m1 = float16_t(_781);
	    _21._m7._m3 = float16_t(dot(_6391, vec2(0.5)));
	    if (any(greaterThan(_778, vec3(0.0))))
	    {
	        f16vec4 _6575 = _21._m7._m7;
	        f16vec3 _6578 = f16vec3(_778);
	        _6575.x = _6578.x;
	        _6575.y = _6578.y;
	        _6575.z = _6578.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _6575);
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	IntAttribute(TexCoord2ScaleByModelU, g_nScaleTexCoord2UByModelScaleAxis-1);
	IntAttribute(TexCoord2ScaleByModelV, g_nScaleTexCoord2VByModelScaleAxis-1);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUIPickColor, true);
	BoolAttribute(VertexpaintUIPuddles, (F_WETNESS==1) || 0);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	FloatAttribute(_dummyMakeVisiblePropMaskBias1, g_flDetailPropMaskBias1);
	FloatAttribute(_dummyMakeVisiblePropMaskBias2, g_flDetailPropMaskBias2);
	FloatAttribute(_dummyMakeVisiblePropMaskSoftness2, g_flDetailPropMaskSoftness2);
	
	#if (S_ENABLE_LAYER_3 == 0)
		BoolAttribute(HasTexcoordTransform, ((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, true);
		BoolAttribute(VertexPaintUI3Layer, false);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
	#endif
	#if (S_SHADER_QUALITY == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_DETAIL_NORMAL == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
}
