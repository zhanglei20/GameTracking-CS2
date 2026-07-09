//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Environment shader with blended layers";
	DevShader = false;
	Version = 9;
	
	// VcsVersion: 71
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
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	bool g_bTexCoord2ScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoord2UByModelScaleAxis!=0) || (g_nScaleTexCoord2VByModelScaleAxis!=0)); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoordUByModelScaleAxis!=0) || (g_nScaleTexCoordVByModelScaleAxis!=0)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
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
	int g_nColorOverlayUVSet < Default(2); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Color/Overlay/40"); >;
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
	// SPIR-V source (7772 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1119
	{
	    mat3x4 _m0;
	};
	
	struct _1126
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
	
	struct _1120
	{
	    mat3x4 _m0;
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1126 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1120 _m0[];
	} g_transformBuffer_1;
	
	struct _1224
	{
	    mat4 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _1224 PerViewConstantBuffer_t;
	
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
	    _1125 _20228;
	    _20228._m0 = g_instanceBuffer_1._m0[nInstanceIdx]._m0;
	    _20228._m1 = g_instanceBuffer_1._m0[nInstanceIdx]._m1;
	    _20228._m2 = g_instanceBuffer_1._m0[nInstanceIdx]._m2;
	    _20228._m3 = g_instanceBuffer_1._m0[nInstanceIdx]._m3;
	    _20228._m4 = g_instanceBuffer_1._m0[nInstanceIdx]._m4;
	    _20228._m5 = g_instanceBuffer_1._m0[nInstanceIdx]._m5;
	    _20228._m6 = g_instanceBuffer_1._m0[nInstanceIdx]._m6;
	    _20228._m7 = g_instanceBuffer_1._m0[nInstanceIdx]._m7;
	    uint _16987 = (_20228._m5 >> uint(16)) & 15u;
	    uint _21709;
	    if (_16987 == 1u)
	    {
	        _21709 = _20228._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21709 = _20228._m1;
	    }
	    _1119 _21957;
	    _21957._m0 = g_transformBuffer_1._m0[_21709]._m0;
	    vec3 _19321;
	    if (_16987 > 0u)
	    {
	        _1119 _20229;
	        _20229._m0 = g_transformBuffer_1._m0[_20228._m1]._m0;
	        _19321 = vec3(_20229._m0[0].z);
	    }
	    else
	    {
	        _19321 = vec3(1.0);
	    }
	    vec4 _23812 = vec4(uvec4(_20228._m0 & 255u, (_20228._m0 & 65280u) >> uint(8), (_20228._m0 & 16711680u) >> uint(16), (_20228._m0 & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
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
	    float _17978;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _17978 = _17828.z;
	    }
	    else
	    {
	        _17978 = _7676.z;
	    }
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * _21957._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _19321.xyz, 1.0) * _21957._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
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
	    vec4 _11323 = vec4(_Globals_.g_vColorTint, _23812.w * _20228._m7);
	    vec3 _14119 = _11323.xyz * mix(vec3(1.0), vColorBlendValues.xyz, vec3(vColorBlendValues.w));
	    vec4 _23714 = _11323;
	    _23714.x = _14119.x;
	    _23714.y = _14119.y;
	    _23714.z = _14119.z;
	    output_0 = vBlendColorTint;
	    output_1 = vec4(_21354, _21355, _17978, _Globals_.g_flModelTintAmount * (1.0 - min(_21354, min(_21355, _17978))));
	    output_2 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_3 = _11179;
	    output_4 = _18606;
	    output_5 = _23714;
	    output_6 = _11179;
	    output_7 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _21957._m0), vTangentUOs_flTangentVSign.w);
	    output_8 = _20228._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
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
	BoolAttribute(SupportsMaterialLayerSampling, true);
	
	#if (S_SHARED_COLOR_OVERLAY == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || ((g_nUVSet3>0) && (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0)))) || ((g_nColorOverlayUVSet>0) && (((g_vOverlayTexCoordScale.x!=1) || (g_vOverlayTexCoordScale.y!=1)) || (g_flOverlayTexCoordRotation!=0)))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
	#endif
	#if (S_ENABLE_LAYER_3 == 0)
		BoolAttribute(VertexPaintUI2Layer, true);
		BoolAttribute(VertexPaintUI3Layer, false);
	#endif
	#if (S_SHARED_COLOR_OVERLAY == 0)
		BoolAttribute(HasTexcoordTransform, ((((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || ((g_nUVSet3>0) && (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0)))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
	#endif
	
	// Variant Attributes
	BoolAttribute(HasTexcoordTransform, (((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || 0);
	BoolAttribute(HasTexcoordTransform, ((((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || ((g_nColorOverlayUVSet>0) && (((g_vOverlayTexCoordScale.x!=1) || (g_vOverlayTexCoordScale.y!=1)) || (g_flOverlayTexCoordRotation!=0)))) || 0);
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
	StaticCombo( S_BLEND_EFFECTS_2, F_BLEND_EFFECTS_2 );
	StaticCombo( S_BLEND_EFFECTS_3, F_BLEND_EFFECTS_3 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
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
	bool bBiplanarUsedAny < UiType(CheckBox); Expression((g_nUVSet1==0) || (g_nUVSet2==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nColorOverlayUVSet==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)) || (g_nColorOverlayUVSet==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nDetailUVSet1==0)) || (g_nDetailUVSet2==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nDetailUVSet1==0)) || (g_nDetailUVSet2==0)) || (g_nColorOverlayUVSet==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression((((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)) || (g_nDetailUVSet1==0)) || (g_nDetailUVSet2==0)) || (g_nDetailUVSet3==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)) || (g_nDetailUVSet1==0)) || (g_nDetailUVSet2==0)) || (g_nDetailUVSet3==0)) || (g_nColorOverlayUVSet==0)); >;
	bool bBlendByFacingDirection2 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_2); >;
	bool bBlendByFacingDirection3 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_3); >;
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); >;
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
	Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor2 < Channel(RGB, ArtistDefined(TextureColor2), Srgb); Channel(A, Box(TextureAmbientOcclusion2), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor3 < Channel(RGB, ArtistDefined(TextureColor3), Srgb); Channel(A, Box(TextureAmbientOcclusion3), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight2 < Channel(R, Box(TextureHeight2), Linear); Channel(G, Box(TextureTintMask2), Linear); Channel(A, Box(TextureMetalness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight3 < Channel(R, Box(TextureHeight3), Linear); Channel(G, Box(TextureTintMask3), Linear); Channel(A, Box(TextureMetalness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal1 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal1, TextureRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal2 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal2, TextureRoughness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal3 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal3, TextureRoughness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormalDetail2 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail2), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormalDetail3 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail3), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tSharedColorOverlay < Channel(RGB, ArtistDefined(TextureSharedColorOverlay), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
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
	CreateInputTexture2D(TextureTranslucency1, Linear, 8, "", "_trans", "Material1/Translucent,15/0", Default4(1, 1, 1, 0));
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
	float g_flDetailPropPuddleReduction1 < UiType(Slider); UiGroup("Material1/Detail Props,90/30"); >;
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
	float g_flDetailPropPuddleReduction2 < UiType(Slider); UiGroup("Material2/Detail Props,90/30"); >;
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
	float g_flDetailPropPuddleReduction3 < UiType(Slider); UiGroup("Material3/Detail Props,90/30"); >;
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
	int g_nColorOverlayUVSet < Default(2); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Color/Overlay/40"); >;
	int g_nColorOverlayMode < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=All Layers,1=Layer1,2=Layer2,3=Layer3"); UiType(Enum); UiGroup("Color/Overlay/50"); >;
	int g_nColorOverlayTintMask < Range4(0, 0, 0, 0, 4, 4, 4, 4); UiOptions("0=Mask All,1=Mask Layer1,2=Mask Layer2,3=Mask Layer3,4=Unmasked"); UiType(Enum); UiGroup("Color/Overlay/55"); >;
	float3 g_vColorOverlayLayerStrengths < Default3(1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/60"); >;
	float3 g_vColorOverlayTintMaskStrengths < Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/65"); >;
	float g_flOverlayDarknessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/100"); >;
	int g_nScaleTexCoord2UByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.u * model.x,2=UV2.u * model.y,3=UV2.u * model.z"); UiType(Enum); UiGroup("Color/100"); UiVisibility(1); >;
	float g_flOverlayBrightnessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/110"); >;
	int g_nScaleTexCoord2VByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.v * model.x,2=UV2.v * model.y,3=UV2.v * model.z"); UiType(Enum); UiGroup("Color/110"); UiVisibility(1); >;
	float g_flBlendSoftnessDistanceModifierStrength < Default(1); UiType(Slider); UiGroup("Color/120"); >;
	float2 g_vOverlayTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/Overlay/210"); >;
	float g_flOverlayTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/Overlay/220"); >;
	
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
	float g_flWetnessUnderlyingHeightMapInfluence < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/3"); UiVisibility(F_WETNESS || 0); >;
	float g_flHorizontalSurfaceTolerance < Default(32); Range(0, 100); UiType(Slider); UiGroup("Wetness/4"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleStrength < Default(1); UiType(Slider); UiGroup("Wetness/5"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleHeight < Default(0.5); UiType(Slider); UiGroup("Wetness/6"); UiVisibility(F_WETNESS || 0); >;
	float3 g_vPuddleSedimentColor < Default3(0.62, 0.56, 0.5); UiType(Color); UiGroup("Wetness/10"); Expression(SrgbGammaToLinear(this)); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleSedimentHeight < Default(0.9); Range(0, 2); UiType(Slider); UiGroup("Wetness/15"); Expression((this*2)-1); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleSedimentOpacity < Default(0.25); UiType(Slider); UiGroup("Wetness/16"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleRoughness < Default(0.02); UiType(Slider); UiGroup("Wetness/17"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleBlendSoftness < Default(0.08); UiType(Slider); UiGroup("Wetness/18"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeStrength < Default(0.5); UiType(Slider); UiGroup("Wetness/20"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeSpread < Default(0.2); UiType(Slider); UiGroup("Wetness/25"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeSoftness < Default(0.2); UiType(Slider); UiGroup("Wetness/26"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetnessStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/30"); UiVisibility(F_WETNESS || 0); >;
	float g_fRainStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/35"); UiVisibility(F_WETNESS || 0); >;
	float g_fRippleStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/40"); UiVisibility(F_WETNESS || 0); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Occlusion Culling
	float g_flOcclusionCullingBoundsScale < Default(1); Range(1, 100); UiType(Slider); UiGroup("Occlusion Culling"); UiVisibility(F_OCCLUSION_CULLING_BOUNDS_SCALE); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_MODE_DEPTH == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_SHADER_QUALITY == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_BLEND_EFFECTS_2 == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_BLEND_EFFECTS_3 == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 5 (name: g_vBiplanarTexCoordScale) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (81228 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	const vec3 _1834[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _647[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
	struct _1021
	{
	    vec4 _m0[3];
	};
	
	struct _1189
	{
	    vec4 _m0[4];
	};
	
	struct _638
	{
	    mat4 _m0[4];
	};
	
	struct _200
	{
	    mat4 _m0;
	    mat4 _m1;
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
	    mat4x3 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	    mat4 _m23;
	};
	
	float _4;
	vec3 _5;
	vec3 _6;
	vec4 _7;
	float _10;
	vec2 _14;
	
	struct _558
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
	    mat4 _m13;
	    vec2 _m14;
	    float _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    mat4 _m22;
	    vec4 _m23;
	    vec4 _m24;
	    vec4 _m25;
	};
	
	layout(set = 1) uniform _558 PerViewConstantBufferCsgo_t;
	
	struct _1263
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    vec3 _m4;
	};
	
	layout(set = 1) uniform _1263 PerViewConstantBuffer_t;
	
	struct _225
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
	    mat4 g_mTextureColorAdjust1;
	    mat4 g_mTextureAdjust1;
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
	    mat4 g_mTextureColorAdjust2;
	    mat4 g_mTextureAdjust2;
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
	
	layout(set = 1) uniform _225 _Globals_;
	
	struct _1124
	{
	    _1021 _m0;
	    _1189 _m1;
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
	    _638 _m18;
	    _1189 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _1124 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(set = 4, binding = 29) uniform samplerShadow g_bindless_Sampler_1[2048];
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
	        _12885 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec3 _10251;
	    SPIRV_CROSS_BRANCH
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
	        vec2 _19651 = clamp((vec2(_16100[_23727.x], _16100[_9992]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        vec3 _18781 = _10061 * _Globals_.g_vBiplanarTexCoordScale.xyz;
	        vec3 _16418 = _18781;
	        vec3 _16419 = dFdxFine(_18781);
	        vec3 _16446 = dFdyFine(_18781);
	        _13136 = _19321;
	        _16305 = _19322;
	        _17114 = vec2(_16418[_19321.x], _16418[_19321.y]);
	        _17115 = vec2(_16418[_19322.x], _16418[_19322.y]);
	        _17116 = vec2(_16419[_19321.x], _16419[_19321.y]);
	        _17117 = vec2(_16446[_19321.x], _16446[_19321.y]);
	        _17118 = vec2(_16419[_19322.x], _16419[_19322.y]);
	        _13694 = vec2(_16446[_19322.x], _16446[_19322.y]);
	        _6616 = _19651 / vec2(_19651.x + _19651.y);
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
	        _12888 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12888 = false;
	    }
	    bool _18545;
	    if (_12888)
	    {
	        _18545 = !gl_FrontFacing;
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
	    vec4 _9716;
	    vec3 _24878;
	    if (_23685)
	    {
	        _9716 = vec4(0.0);
	        _24878 = _18905;
	    }
	    else
	    {
	        vec4 _8625 = vec4(dFdx(_18905.xy), dFdy(_18905.xy));
	        vec2 _20312 = _18905.xy + vec2(length(_8625) * 1.0000000133514319600180897396058e-10);
	        vec3 _20488;
	        _20488.x = _20312.x;
	        _20488.y = _20312.y;
	        _9716 = _8625;
	        _24878 = _20488;
	    }
	    vec4 _19323;
	    if (_23685)
	    {
	        _19323 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17114 * _Globals_.g_vTexCoordScale1.xy).xy, (_17116 * _Globals_.g_vTexCoordScale1.xy).xy, (_17117 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17115 * _Globals_.g_vTexCoordScale1.xy).xy, (_17118 * _Globals_.g_vTexCoordScale1.xy).xy, (_13694 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.y);
	    }
	    else
	    {
	        _19323 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy).xyzw;
	    }
	    vec2 _6383 = textureQueryLod(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy);
	    float _16356 = _6383.x;
	    float _19275 = fwidth(_19323.x * _Globals_.g_flHeightMapScale1);
	    float _15317 = ((((_16356 * _16356) * (0.012500000186264514923095703125 + _19275)) * 0.0199999995529651641845703125) * _Globals_.g_flBlendSoftnessDistanceModifierStrength) * _18843.x;
	    float _8284 = max(min(input_0.w + _Globals_.g_flBlendSoftness2, 1.0), 9.9999997473787516355514526367188e-05) + _15317;
	    bool _14876 = _Globals_.g_bWetnessUseHeightmapAdjustments != 0;
	    float _11237;
	    SPIRV_CROSS_BRANCH
	    if (_14876)
	    {
	        _11237 = max(0.0, ((_19323.x + 0.5) - _Globals_.g_flHeightMapZeroPoint1) * _Globals_.g_flHeightMapScale1);
	    }
	    else
	    {
	        _11237 = _19323.x;
	    }
	    float _17767 = _Globals_.g_flHeightMapZeroPoint1 + (_15317 * 0.5);
	    float _6379 = _Globals_.g_flHeightMapScale1 + _8284;
	    float _20609 = (_19323.x - _17767) * _6379;
	    float _13138;
	    vec3 _13189;
	    vec4 _22995;
	    if (_23685)
	    {
	        vec2 _21820 = (_17114 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _17053 = (_17116 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _8904 = (_17117 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec4 _23806 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _21820, _17053, _8904) * _6616.x;
	        vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _21820, _17053, _8904);
	        float _18178 = _12167.z * _6616.x;
	        float _15456 = _12167.x;
	        float _24534 = _12167.y;
	        float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	        float _11177 = _15456 - _24534;
	        vec3 _21631 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _6616.x;
	        vec3 _24466 = (_1834[_13136.x] * _21631.x) + (_647[_13136.y] * _21631.y);
	        float _13137;
	        vec3 _13753;
	        vec4 _14101;
	        if (_6616.y > 0.0)
	        {
	            vec2 _17048 = (_17115 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _10018 = (_17118 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _8905 = (_13694 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _17048, _10018, _8905);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _21632 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _6616.y;
	            _13137 = _18178 + (_12168.z * _6616.y);
	            _14101 = _23806 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _17048, _10018, _8905) * _6616.y);
	            _13753 = _24466 + ((_1834[_16305.x] * _21632.x) + (_647[_16305.y] * _21632.y));
	        }
	        else
	        {
	            _13137 = _18178;
	            _14101 = _23806;
	            _13753 = _24466;
	        }
	        _13138 = _13137;
	        _13189 = normalize(_13753 + _24347);
	        _22995 = _14101;
	    }
	    else
	    {
	        vec4 _11179 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw);
	        float _6493 = _11179.x;
	        float _14881 = _11179.y;
	        float _16783 = (_6493 + _14881) - 1.00392162799835205078125;
	        float _11176 = _6493 - _14881;
	        vec3 _15162 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	        vec2 _20890 = _15162.xy;
	        float _7796 = dot(_20890, _Globals_.g_vNormalXform_1.xy);
	        float _19701 = dot(_20890, _Globals_.g_vNormalXform_1.zw);
	        vec3 _19582 = _15162;
	        _19582.x = _7796;
	        _19582.y = _19701;
	        bvec3 _20662 = bvec3(_17559);
	        vec3 _10844 = abs(_19582.xyz);
	        vec2 _16475 = (-vec2(_7796, (-1.0) * _19701)) / vec2(max(_10844.z, 0.0078125 * max(_10844.x, _10844.y)));
	        _13138 = _11179.z;
	        _13189 = normalize(_8889 - ((mix(_9521, _10020, _20662) * _16475.x) + (mix(_15323, _22186, _20662) * _16475.y)));
	        _22995 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw).xyzw;
	    }
	    float _7812 = clamp(((_Globals_.g_fTextureRoughnessContrast1 * (_13138 - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness1, 0.0, 1.0);
	    vec4 _23230 = vec4(_22995.xyz, 1.0);
	    float _10048 = clamp(mix(_Globals_.g_vAmbientOcclusionLevels1.x, _Globals_.g_vAmbientOcclusionLevels1.z, pow(_22995.w, _Globals_.g_vAmbientOcclusionLevels1.y)), 0.0, 1.0);
	    float _9068 = _19323.w * float(_Globals_.g_bMetalness1 != 0);
	    float _24803 = clamp(((_Globals_.g_fTintMaskContrast1 * (_19323.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness1, 0.0, 1.0);
	    vec3 _25191 = mix(mix(_22995, vec4((_23230 * _Globals_.g_mTextureAdjust1).xyz, _22995.w), bvec4(_Globals_.g_bAdjustBaseColor1 != 0)).xyz, vec4((_23230 * _Globals_.g_mTextureColorAdjust1).xyz, _4).xyz, vec3(_24803));
	    vec4 _17842;
	    _17842.x = _25191.x;
	    _17842.y = _25191.y;
	    _17842.z = _25191.z;
	    float _24323 = dot(_17842.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(input_1.xyz, vec3(0.001000000047497451305389404296875)));
	    float _21159 = dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _24175 = max(input_1.x, max(input_1.y, input_1.z));
	    vec3 _24174 = normalize(mix(_24347, _13189, vec3(_Globals_.g_fTextureNormalContrast1))).xyz;
	    vec3 _23405 = vec4(clamp(mix(_17842.xyz, (_9577 * min(_24323 / _21159, (3.0 * _24323) * _24175)).xyz, vec3((input_1.w * _24803) * float(_Globals_.g_bModelTint1 != 0))), vec3(0.0), vec3(1.0)).xyz, _10).xyz;
	    vec2 _22927;
	    _22927.x = _7812;
	    float _7406 = float(_Globals_.g_bSnowLayer1 != 0);
	    bool _12889;
	    if (_Globals_.g_flColorOverlay2 == 0.0)
	    {
	        _12889 = _Globals_.g_flColorReplace2 == 0.0;
	    }
	    else
	    {
	        _12889 = false;
	    }
	    bool _12890;
	    if (_12889)
	    {
	        _12890 = _Globals_.g_flAOCombine2 == 0.0;
	    }
	    else
	    {
	        _12890 = false;
	    }
	    bool _21711;
	    if (_12890)
	    {
	        _21711 = _Globals_.g_flAOReplace2 == 0.0;
	    }
	    else
	    {
	        _21711 = false;
	    }
	    bool _12891;
	    if (_Globals_.g_flNormalCombine2 == 0.0)
	    {
	        _12891 = _Globals_.g_flNormalReplace2 == 0.0;
	    }
	    else
	    {
	        _12891 = false;
	    }
	    bool _12892;
	    if (_12891)
	    {
	        _12892 = _Globals_.g_flRoughnessCombine2 == 0.0;
	    }
	    else
	    {
	        _12892 = false;
	    }
	    bool _21712;
	    if (_12892)
	    {
	        _21712 = _Globals_.g_flRoughnessReplace2 == 0.0;
	    }
	    else
	    {
	        _21712 = false;
	    }
	    vec3 _18906;
	    _18906.x = input_4.z;
	    _18906.y = input_4.w;
	    bool _23686 = _Globals_.g_nUVSet2 == 0;
	    vec4 _9717;
	    vec3 _24879;
	    if (_23686)
	    {
	        _9717 = vec4(0.0);
	        _24879 = _18906;
	    }
	    else
	    {
	        vec4 _8626 = vec4(dFdx(_18906.xy), dFdy(_18906.xy));
	        vec2 _20313 = _18906.xy + vec2(length(_8626) * 1.0000000133514319600180897396058e-10);
	        vec3 _20489;
	        _20489.x = _20313.x;
	        _20489.y = _20313.y;
	        _9717 = _8626;
	        _24879 = _20489;
	    }
	    vec4 _19324;
	    if (_23686)
	    {
	        _19324 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17114 * _Globals_.g_vTexCoordScale2.xy).xy, (_17116 * _Globals_.g_vTexCoordScale2.xy).xy, (_17117 * _Globals_.g_vTexCoordScale2.xy).xy) * _6616.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17115 * _Globals_.g_vTexCoordScale2.xy).xy, (_17118 * _Globals_.g_vTexCoordScale2.xy).xy, (_13694 * _Globals_.g_vTexCoordScale2.xy).xy) * _6616.y);
	    }
	    else
	    {
	        _19324 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24879.xy).xyzw;
	    }
	    vec2 _6384 = textureQueryLod(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24879.xy);
	    float _16357 = _6384.x;
	    float _19276 = fwidth(_19324.x * _Globals_.g_flHeightMapScale2);
	    float _19817 = _15317 + (((((_16357 * _16357) * (0.012500000186264514923095703125 + _19276)) * 0.0199999995529651641845703125) * _Globals_.g_flBlendSoftnessDistanceModifierStrength) * _18843.y);
	    float _6913 = _8284 + _19817;
	    float _11243;
	    SPIRV_CROSS_BRANCH
	    if (_14876)
	    {
	        _11243 = max(0.0, ((_19324.x + 0.5) - _Globals_.g_flHeightMapZeroPoint2) * _Globals_.g_flHeightMapScale2);
	    }
	    else
	    {
	        _11243 = _19324.x;
	    }
	    float _17768 = _Globals_.g_flHeightMapZeroPoint2 + (_19817 * 0.5);
	    float _6380 = _Globals_.g_flHeightMapScale2 + _6913;
	    float _12197 = _6380 - (_6913 * 2.0);
	    float _11621;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.bBlendByFacingDirection2 != 0)
	    {
	        _11621 = _10136 * clamp((((dot(_Globals_.g_vFacingDirection2.xyz, mix(_24347.xyz, _24174, vec3(_Globals_.g_vFacingDirectionMaskNormalMapStrength2)).xyz) - 1.0) + (_Globals_.g_flFacingDirectionMaskSpread2 * 2.0)) / (_Globals_.g_vFacingDirectionMaskSoftness2 * 2.0)) + 0.5, 0.0, 1.0);
	    }
	    else
	    {
	        _11621 = _10136;
	    }
	    float _6994 = ((_19324.x - _17768) * ((_12197 == 0.0) ? 9.9999997473787516355514526367188e-05 : _12197)) + mix((((-_17767) * _6379) - ((1.0 - _17768) * _6380)) - _6913, ((1.0 - _17767) * _6379) - ((-_17768) * _6380), _11621);
	    vec3 _16290;
	    _16290.x = _20609;
	    _16290.y = _6994;
	    vec2 _9007 = max((_16290.xy - vec2(max(_20609, _6994))) + vec2(_6913), vec2(0.0));
	    float _6253 = clamp(((_9007 / vec2((_9007.x + 9.9999997473787516355514526367188e-05) + _9007.y)).y * mix(0.5, _19324.x, _Globals_.g_flMaskWithHeight2)) * 2.0, 0.0, 1.0);
	    bool _19615 = _6253 > 0.0500000007450580596923828125;
	    float _13141;
	    vec4 _16306;
	    float _16863;
	    vec3 _17119;
	    float _17120;
	    float _17152;
	    SPIRV_CROSS_BRANCH
	    if (_19615)
	    {
	        float _13140;
	        vec3 _13190;
	        vec4 _22996;
	        if (_23686)
	        {
	            vec2 _19981 = _17114 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _21754 = _17116 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _22336 = _17117 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _22337 = _17115 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _22994 = _17118 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _18440 = _13694 * _Globals_.g_vTexCoordScale2.xy;
	            bool _23211 = !_21711;
	            vec4 _7425;
	            if (_23211)
	            {
	                _7425 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _19981.xy, _21754.xy, _22336.xy) * _6616.x;
	            }
	            else
	            {
	                _7425 = vec4(0.0);
	            }
	            bool _24030 = !_21712;
	            vec3 _10024;
	            float _24485;
	            if (_24030)
	            {
	                vec4 _11182 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _19981.xy, _21754.xy, _22336.xy);
	                float _15457 = _11182.x;
	                float _24535 = _11182.y;
	                float _16787 = (_15457 + _24535) - 1.00392162799835205078125;
	                float _11183 = _15457 - _24535;
	                vec3 _21633 = normalize(vec3(vec2(_16787, _11183), (1.0 - abs(_16787)) - abs(_11183))).xyz * _6616.x;
	                _10024 = (_1834[_13136.x] * _21633.x) + (_647[_13136.y] * _21633.y);
	                _24485 = _11182.z * _6616.x;
	            }
	            else
	            {
	                _10024 = _24347;
	                _24485 = 0.0;
	            }
	            float _13139;
	            vec3 _13754;
	            vec4 _14102;
	            if (_6616.y > 0.0)
	            {
	                vec4 _12893;
	                if (_23211)
	                {
	                    _12893 = _7425 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _22337.xy, _22994.xy, _18440.xy) * _6616.y);
	                }
	                else
	                {
	                    _12893 = _7425;
	                }
	                float _13213;
	                vec3 _15671;
	                if (_24030)
	                {
	                    vec4 _12169 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _22337.xy, _22994.xy, _18440.xy);
	                    float _13492 = _12169.x;
	                    float _21309 = _12169.y;
	                    float _16788 = (_13492 + _21309) - 1.00392162799835205078125;
	                    float _11184 = _13492 - _21309;
	                    vec3 _21634 = normalize(vec3(vec2(_16788, _11184), (1.0 - abs(_16788)) - abs(_11184))).xyz * _6616.y;
	                    _13213 = _24485 + (_12169.z * _6616.y);
	                    _15671 = _10024 + ((_1834[_16305.x] * _21634.x) + (_647[_16305.y] * _21634.y));
	                }
	                else
	                {
	                    _13213 = _24485;
	                    _15671 = _10024;
	                }
	                _13139 = _13213;
	                _14102 = _12893;
	                _13754 = _15671;
	            }
	            else
	            {
	                _13139 = _24485;
	                _14102 = _7425;
	                _13754 = _10024;
	            }
	            _13140 = _13139;
	            _13190 = normalize(_13754 + _24347);
	            _22996 = _14102;
	        }
	        else
	        {
	            vec4 _7424;
	            if (!_21711)
	            {
	                _7424 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24879.xy, _9717.xy, _9717.zw).xyzw;
	            }
	            else
	            {
	                _7424 = vec4(0.0);
	            }
	            float _13212;
	            vec3 _15670;
	            if (!_21712)
	            {
	                vec4 _11180 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24879.xy, _9717.xy, _9717.zw);
	                float _6494 = _11180.x;
	                float _14882 = _11180.y;
	                float _16786 = (_6494 + _14882) - 1.00392162799835205078125;
	                float _11181 = _6494 - _14882;
	                vec3 _15163 = normalize(vec3(vec2(_16786, _11181), (1.0 - abs(_16786)) - abs(_11181)));
	                vec2 _20891 = _15163.xy;
	                float _7797 = dot(_20891, _Globals_.g_vNormalXform_2.xy);
	                float _19702 = dot(_20891, _Globals_.g_vNormalXform_2.zw);
	                vec3 _19583 = _15163;
	                _19583.x = _7797;
	                _19583.y = _19702;
	                bvec3 _20663 = bvec3(_17560);
	                vec3 _10845 = abs(_19583.xyz);
	                vec2 _16476 = (-vec2(_7797, (-1.0) * _19702)) / vec2(max(_10845.z, 0.0078125 * max(_10845.x, _10845.y)));
	                _13212 = _11180.z;
	                _15670 = normalize(_8889 - ((mix(_9521, _10020, _20663) * _16476.x) + (mix(_15323, _22186, _20663) * _16476.y)));
	            }
	            else
	            {
	                _13212 = 0.0;
	                _15670 = vec3(0.0);
	            }
	            _13140 = _13212;
	            _13190 = _15670;
	            _22996 = _7424;
	        }
	        vec3 _9718;
	        float _24880;
	        if (!_21712)
	        {
	            _9718 = normalize(mix(_24347, _13190, vec3(_Globals_.g_fTextureNormalContrast2)));
	            _24880 = clamp(((_Globals_.g_fTextureRoughnessContrast2 * (_13140 - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness2, 0.0, 1.0);
	        }
	        else
	        {
	            _9718 = _13190;
	            _24880 = _13140;
	        }
	        vec4 _21847 = vec4(_22996.xyz, 1.0);
	        float _24804 = clamp(((_Globals_.g_fTintMaskContrast2 * (_19324.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness2, 0.0, 1.0);
	        vec3 _25192 = mix(mix(_22996, vec4((_21847 * _Globals_.g_mTextureAdjust2).xyz, _22996.w), bvec4(_Globals_.g_bAdjustBaseColor2 != 0)).xyz, vec4((_21847 * _Globals_.g_mTextureColorAdjust2).xyz, _4).xyz, vec3(_24804));
	        vec4 _17843;
	        _17843.x = _25192.x;
	        _17843.y = _25192.y;
	        _17843.z = _25192.z;
	        float _16721 = dot(_17843.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        _13141 = _24804;
	        _16306 = vec4(clamp(mix(_17843.xyz, (_9577 * min(_16721 / _21159, (3.0 * _16721) * _24175)).xyz, vec3((input_1.w * _24804) * float(_Globals_.g_bModelTint2 != 0))), vec3(0.0), vec3(1.0)).xyz, _10);
	        _17119 = _9718;
	        _17120 = clamp(mix(_Globals_.g_vAmbientOcclusionLevels2.x, _Globals_.g_vAmbientOcclusionLevels2.z, pow(_22996.w, _Globals_.g_vAmbientOcclusionLevels2.y)), 0.0, 1.0);
	        _17152 = _19324.w * float(_Globals_.g_bMetalness2 != 0);
	        _16863 = _24880;
	    }
	    else
	    {
	        _13141 = _19324.y;
	        _16306 = vec4(0.0);
	        _17119 = vec3(0.0);
	        _17120 = 0.0;
	        _17152 = _19324.w;
	        _16863 = 0.0;
	    }
	    float _13142;
	    vec3 _13381;
	    vec2 _14948;
	    float _16307;
	    float _17121;
	    vec3 _17124;
	    float _17125;
	    SPIRV_CROSS_BRANCH
	    if (_19615)
	    {
	        vec3 _10593;
	        float _11673;
	        if (!_21711)
	        {
	            vec3 _18442 = _16306.xyz * 12.9200000762939453125;
	            vec3 _7485 = (pow(_16306.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	            float _21354;
	            if (_16306.x <= 0.003130800090730190277099609375)
	            {
	                _21354 = _18442.x;
	            }
	            else
	            {
	                _21354 = _7485.x;
	            }
	            float _21355;
	            if (_16306.y <= 0.003130800090730190277099609375)
	            {
	                _21355 = _18442.y;
	            }
	            else
	            {
	                _21355 = _7485.y;
	            }
	            float _20653;
	            if (_16306.z <= 0.003130800090730190277099609375)
	            {
	                _20653 = _18442.z;
	            }
	            else
	            {
	                _20653 = _7485.z;
	            }
	            _11673 = mix(_10048 * mix(1.0, _17120, _6253 * _Globals_.g_flAOCombine2), _17120, _6253 * _Globals_.g_flAOReplace2);
	            _10593 = mix(_23405 * mix(vec3(1.0), vec3(_21354, _21355, _20653) * 2.0, vec3(_6253 * _Globals_.g_flColorOverlay2)), _16306.xyz, vec3(_6253 * _Globals_.g_flColorReplace2));
	        }
	        else
	        {
	            _11673 = _10048;
	            _10593 = _23405;
	        }
	        vec3 _11008;
	        vec2 _14482;
	        if (!_21712)
	        {
	            vec2 _12792;
	            _12792.x = mix(_7812 * (1.0 + ((((_16863 - _7812) * 2.0) * _6253) * _Globals_.g_flRoughnessCombine2)), _16863, _6253 * _Globals_.g_flRoughnessReplace2);
	            _11008 = mix(mix(_24174, normalize(mix(_24347, (_24174 + _17119.xyz) * vec3(0.5), vec3(2.0))), vec3(_6253 * _Globals_.g_flNormalCombine2)), _17119.xyz, vec3((_6253 * clamp((_6994 + _17768) - _20609, 0.0, 1.0)) * _Globals_.g_flNormalReplace2));
	            _14482 = _12792;
	        }
	        else
	        {
	            _11008 = _24174;
	            _14482 = _22927;
	        }
	        _13142 = mix(_9068 * mix(1.0, _17152 * 2.0, _6253 * _Globals_.g_flMetalnessCombine2), _17152, _6253 * _Globals_.g_flMetalnessReplace2);
	        _16307 = mix(_7406, float(_Globals_.g_bSnowLayer2 != 0), _6253);
	        _17121 = _11673;
	        _17124 = _11008;
	        _17125 = mix(_11237, _11243, _6253);
	        _14948 = _14482;
	        _13381 = _10593;
	    }
	    else
	    {
	        _13142 = _9068;
	        _16307 = _7406;
	        _17121 = _10048;
	        _17124 = _24174;
	        _17125 = _11237;
	        _14948 = _22927;
	        _13381 = _23405;
	    }
	    float _13984 = saturate(1.0 - _6253);
	    vec3 _14081 = _13381 * mix(vec3(1.0), input_5.xyz, vec3(clamp(clamp(((float(_Globals_.g_bMaskVertexColor1 == 0) * _13984) + (float(_Globals_.g_bMaskVertexColor2 == 0) * _6253)) + ((_24803 * _13984) + (_13141 * _6253)), 0.0, 1.0) * ((float(_Globals_.g_bVertexColorEnabled1 != 0) * _13984) + (float(_Globals_.g_bVertexColorEnabled2 != 0) * _6253)), 0.0, 1.0)));
	    vec2 _23398 = vec2(_14948.x);
	    bool _12896;
	    if (_Globals_.g_bWetness != 0)
	    {
	        _12896 = (_Globals_.g_fPuddleStrength + _Globals_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _12896 = false;
	    }
	    bool _12897;
	    if (_12896)
	    {
	        _12897 = input_0.z > 0.0;
	    }
	    else
	    {
	        _12897 = false;
	    }
	    float _12727;
	    vec3 _13145;
	    vec2 _16308;
	    float _17127;
	    vec3 _17128;
	    float _17129;
	    vec3 _18774;
	    SPIRV_CROSS_BRANCH
	    if (_12897)
	    {
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14498 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_0.z, saturate(PerViewConstantBufferCsgo_t._m11)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m12 - 0.5) * 2.0));
	        float _20426 = saturate(_23204 - 0.75);
	        float _8286 = _23204 + (4.0 * (_20426 * _20426));
	        float _16777 = _8286 - _Globals_.g_fWetEdgeSpread;
	        float _11964 = saturate(_8286 * 20.0);
	        vec4 _9719;
	        float _24883;
	        SPIRV_CROSS_BRANCH
	        if (_Globals_.g_bPuddlesOnVerticalSurfaces != 0)
	        {
	            vec4 _9186 = vec4(0.0, 0.0, 1.0, 0.0);
	            _9186.x = _24347.x;
	            _9186.y = _24347.y;
	            _9186.z = _21302;
	            _9719 = _9186;
	            _24883 = max(0.0, _16777);
	        }
	        else
	        {
	            _9719 = vec4(0.0, 0.0, 1.0, 0.0);
	            _24883 = max(0.0, (_8286 * _14498) - _Globals_.g_fWetEdgeSpread);
	        }
	        float _16799 = max(0.001000000047497451305389404296875, _Globals_.g_fPuddleBlendSoftness);
	        float _14611 = smoothstep(_24883 + _16799, _24883 - (input_0.w + (_16799 * 2.0)), _17125) * _11964;
	        float _19808 = max((smoothstep(_23204, _16777 - (0.20000000298023223876953125 * _8286), _17125) * _Globals_.g_fWetEdgeStrength) * _11964, _14611) * _Globals_.g_fPuddleStrength;
	        float _17924 = (_23204 - 1.0) - _17125;
	        float _10334 = (saturate(_17924 + _Globals_.g_fPuddleSedimentHeight) * _Globals_.g_fPuddleSedimentOpacity) * _14611;
	        float _13706 = clamp(((clamp((((_8286 * 2.0) - (mix(0.5, _19372.w, saturate(_14498 * 20.0)) * 0.5)) - (_17125 * 0.5)) + 0.25, 0.0, 1.0) * _Globals_.g_fWetnessStrength) * _11964) + _14611, 0.0, 1.0);
	        float _13144;
	        float _13151;
	        vec4 _23607;
	        SPIRV_CROSS_BRANCH
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m9;
	            vec3 _6617;
	            vec4 _12898;
	            float _13143;
	            SPIRV_CROSS_BRANCH
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
	                vec4 _20877 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                vec2 _18922 = (_20877.xy * 2.0) - vec2(1.0);
	                float _22216 = clamp(length(fwidth(_15991)) * 10.0, 0.0, 1.0);
	                vec2 _15297 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_0.z) * mix(1.0, 0.300000011920928955078125, _22216);
	                vec2 _13712 = _21326.xy;
	                vec4 _19601 = vec4(0.0);
	                _19601.x = dot(_22900.xy, _15297);
	                _19601.y = dot(_13712, _15297);
	                vec2 _16046 = (vec2(_20274.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _20878 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_16046 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                vec2 _17104 = (((_20878.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_0.z;
	                _17104.y = _17104.y * 0.5;
	                float _9251 = clamp(length(fwidth(_16046)) * 10.0, 0.0, 1.0);
	                vec2 _13561 = _17104 * mix(1.0, 0.300000011920928955078125, _9251);
	                vec2 _13330 = _19601.xy + vec2(dot(_22900.xy, _13561), dot(_13712, _13561));
	                vec4 _20490 = _19601;
	                _20490.x = _13330.x;
	                _20490.y = _13330.y;
	                _20490.w = input_0.z * (_20877.z + _20878.z);
	                vec3 _20491;
	                _20491.x = _10061.x;
	                _20491.y = _10061.y;
	                _13143 = _12497 * (0.039999999105930328369140625 * (_22216 + _9251));
	                _12898 = _9719 + ((_20490 * _14498) * _12497);
	                _6617 = _20491;
	            }
	            else
	            {
	                _13143 = 0.0;
	                _12898 = _9719;
	                _6617 = _10061;
	            }
	            float _8914 = (_Globals_.g_fRainStrength * PerViewConstantBufferCsgo_t._m8) * PerViewConstantBufferCsgo_t._m8;
	            float _9982;
	            vec4 _21594;
	            SPIRV_CROSS_BRANCH
	            if (_8914 > 0.0)
	            {
	                vec2 _10473 = _6617.xy * 0.119999997317790985107421875;
	                vec3 _20506 = vec3(PerViewConstantBuffer_t._m0 * 6.5) + vec3(0.0, 0.3167000114917755126953125, 0.633400022983551025390625);
	                vec3 _13155;
	                _13155 = vec3(0.0);
	                int _18441;
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
	                    float _20213 = clamp(1.0 - (_8329 * 6.0), 0.0, 1.0);
	                    float _7135 = floor(fract(_10212.x * 0.100000001490116119384765625) * 10.0);
	                    float _23598 = _20506[_16208];
	                    float _18429 = _23598 + ((_7135 + (floor(fract(_10212.y * 0.100000001490116119384765625) * 10.0) * (0.20000000298023223876953125 + _7135))) * 8.0);
	                    _20506[_16208] = _18429;
	                    float _18120 = _8914 * _8914;
	                    _25251 = vec3(_13155.xy + (((-(((((_7848 / vec2(_8329)) * cos(mix(1.0, (_20173 * 40.0) + (PerViewConstantBuffer_t._m0 * 65.0), _14611))) * _20173) * _20173) * mix(2.0, 0.25, clamp(fwidth(_20173) * 20.0, 0.0, 1.0)))) * ((clamp((sin(((_20173 * mix(1.0, 4.0, _14611)) + _18429) * _8914) - (1.0 - ((0.20000000298023223876953125 * _18120) * mix(0.25, 1.0, _14611)))) * 2.0, 0.0, 1.0) * _20173) / _18120)) * mix(16.0, 2.0, _14611)), _13155.z + (((clamp((sin((((_20213 + _18429) + 4.0) + (sin(_17125 * 60.0) * 0.25)) * _8914) - (1.0 - (_18120 * 0.02000000141561031341552734375))) * 2.0, 0.0, 1.0) * _20213) / _18120) * 28.0));
	                    _18441 = _16208 + 1;
	                    _13155 = _25251;
	                    _16208 = _18441;
	                    continue;
	                }
	                vec3 _9348 = _13155 * _14498;
	                vec2 _15752 = _12898.xy + _9348.xy;
	                vec4 _20492 = _12898;
	                _20492.x = _15752.x;
	                _20492.y = _15752.y;
	                _9982 = _9348.z;
	                _21594 = _20492;
	            }
	            else
	            {
	                _9982 = 0.0;
	                _21594 = _12898;
	            }
	            vec3 _10508 = normalize(_21594.xyz);
	            vec4 _16886 = _21594;
	            _16886.x = _10508.x;
	            _16886.y = _10508.y;
	            _16886.z = _10508.z;
	            _13144 = _9982;
	            _13151 = _13143;
	            _23607 = _16886;
	        }
	        else
	        {
	            _13144 = 0.0;
	            _13151 = 0.0;
	            _23607 = _9719;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _23311 = vec3(_19808 * _10334);
	        vec3 _13713 = normalize(mix(_17124.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m12 * 2.0)), _19808);
	        vec3 _18806 = mix(_14081, pow(_14081, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_14081, vec3(0.25)) * (_9038 * _14948.x)) * 8.0, vec3(0.0), vec3(1.0)) * mix(_Globals_.g_flWetnessDarkeningStrength1, _Globals_.g_flWetnessDarkeningStrength2, _6253 * _Globals_.g_flColorReplace2));
	        _13145 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _17121, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, _23311), vec3(1.0 + _13144), vec3(_13144 * 0.100000001490116119384765625));
	        _16308 = clamp(mix(_23398.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13713.xyz)) * 0.5)), vec2(0.0), vec2(1.0));
	        _17127 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17128 = _13713;
	        _17129 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _12727 = mix(_17121, 1.0, _19808);
	        _18774 = mix(_17124, _23607.xyz, _23311);
	    }
	    else
	    {
	        _13145 = _14081;
	        _16308 = _23398;
	        _17127 = _Globals_.g_flReflectance;
	        _17128 = vec3(1.0);
	        _17129 = 0.0;
	        _12727 = _17121;
	        _18774 = _17124;
	    }
	    vec3 _9451 = mix(vec3(_17127).xyz, _13145.xyz, vec3(_13142));
	    vec3 _17892 = mix(_17128, _18774, bvec3(all(equal(_17128, vec3(1.0)))));
	    vec3 _10562 = _24347.xyz;
	    vec3 _11099 = dFdx(_10562);
	    vec3 _9175 = dFdy(_10562);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _21819 = max(_16308.xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    vec3 _15598 = -_24347;
	    vec4 _23875 = vec4(_18774.xyz, 1.0);
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21714;
	    if (_24464.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m15) * PerViewConstantBufferCsgo_t._m14.xy) + (PerViewConstantBufferCsgo_t._m14.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _11087).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12022 = _18418.z;
	        bool _12285 = abs(_12022) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m14.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12022 : _18579;
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
	        _21714 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m3], g_bindless_Sampler[_Globals_.g_sPointClamp]), (_11087 + mix(_23169, PerViewConstantBufferCsgo_t._m14.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21714 = 1.0;
	    }
	    float _21715;
	    SPIRV_CROSS_BRANCH
	    if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13146;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	            {
	                _13146 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_2.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_13039];
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m13[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24805 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - clamp((abs(_24805) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14), vec2(0.0), vec2(1.0));
	                vec2 _20561 = (_24805 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                vec3 _20493 = _19470;
	                _20493.x = _20561.x;
	                _20493.y = _20561.y;
	                _13146 = saturate(_22193.x * _22193.y);
	                _14975 = _20493;
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
	            float _18270 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	            float _12501;
	            SPIRV_CROSS_BRANCH
	            if (_13146 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_2.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15335].xy;
	                    vec3 _20494;
	                    _20494.x = _20562.x;
	                    _20494.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20494.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12501 = mix(_7934, _18270, _13146);
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
	            _12502 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21715 = _12502;
	    }
	    else
	    {
	        _21715 = 1.0;
	    }
	    vec3 _9720;
	    vec3 _24884;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _18774.xyz) * _21715) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _18774.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_18774.xyz, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18223;
	        if (_17129 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m9.xyz);
	            float _8124 = saturate(_17129);
	            _18223 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * clamp((_8780 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_18774.xyz, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m9.xyz), 1.0, _8124), 0.0, 1.0)), vec3(_8124));
	        }
	        else
	        {
	            _18223 = _17874;
	        }
	        vec2 _17301 = max(_21819, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, _15460.xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _21715).xyz;
	        _9720 = ((_9451.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
	        _24884 = PerViewLightingConstantBufferGpu_t._m4.xyz + (_18223.xyz * _16808);
	    }
	    else
	    {
	        _9720 = vec3(0.0);
	        _24884 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20059 = _24465.x;
	    vec4 _19363;
	    if (_20059)
	    {
	        vec4 _18621 = vec4(_10061.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m13;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
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
	    vec3 _13147;
	    vec3 _16324;
	    _13147 = _9720;
	    _16324 = _24884;
	    uint _21567;
	    vec3 _13148;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13148 = _13147;
	        _16325 = _16324;
	        uint _20344;
	        vec3 _13214;
	        vec3 _15676;
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
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_2.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                vec3 _21642 = _22905.xyz;
	                bool _7426;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7426 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7426 = false;
	                }
	                bool _12899;
	                if (!_7426)
	                {
	                    _12899 = true;
	                }
	                else
	                {
	                    _12899 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12899)
	                {
	                    _13214 = _13148;
	                    _15676 = _16325;
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
	                vec3 _11186;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10027 = g_BarnLights_1._m0[_12608]._m2.xyz - input_2.xyz;
	                    float _18345 = dot(_10027, _10027);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10027 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10027 + _16268) - _12302;
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
	                    _11186 = _10027 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * clamp(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647), 0.0, 1.0)) * clamp(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))), 0.0, 1.0);
	                }
	                else
	                {
	                    _11186 = g_BarnLights_1._m0[_12608]._m2.xyz;
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
	                SPIRV_CROSS_BRANCH
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
	                        vec3 _23629 = vec4((-_11186).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19009.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        vec3 _14082 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14082.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20497 = _14082;
	                        _20497.x = _20564.x;
	                        _20497.y = _20564.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), _20497.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20496 = _13791;
	                        _20496.x = _20563.x;
	                        _20496.y = _20563.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _20496.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13214 = _13148;
	                    _15676 = _16325;
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
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _13214 = _13148;
	                        _15676 = _16325;
	                        break;
	                    }
	                    _21549 = _20482;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15461 = mix(_17892, _18774.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_18774.xyz, _11186.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18225;
	                if (_17129 > 0.0)
	                {
	                    float _8781 = dot(_15461, _11186.xyz);
	                    float _8125 = saturate(_17129);
	                    _18225 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * clamp((_8781 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_18774.xyz, _15461, vec3(10.0)), _11186.xyz), 1.0, _8125), 0.0, 1.0)), vec3(_8125));
	                }
	                else
	                {
	                    _18225 = _17875;
	                }
	                vec2 _17302 = max(_21819, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11186.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, _15461.xyz);
	                float _19211 = max(0.0, dot(_11186.xyz, _12282));
	                float _9851 = _17302.x;
	                float _25212 = _9851 * _9851;
	                float _19097 = _25212 * _25212;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13214 = _13148.xyz + (((_9451.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
	                _15676 = _16325.xyz + (_18225.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13148 = _13214;
	            _16325 = _15676;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13147 = _13148;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21819.xy, vec2(0.5));
	    vec3 _7507 = _17892.xyz;
	    vec3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec4 _15344 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15344.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17138).xyz, _7507)))) * _21215) + _15344.y)) + _15344.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _20418 = vec3(_21714 * max(_12727, 0.0)).xyz;
	    vec3 _20015 = _8745 * _20418;
	    vec3 _20579;
	    if (_16307 > 0.0)
	    {
	        _20579 = mix(_20015, pow(_20015, vec3(1.0499999523162841796875, 0.949999988079071044921875, 0.800000011920928955078125)), vec3(_16307));
	    }
	    else
	    {
	        _20579 = _20015;
	    }
	    vec3 _22686 = (_16324.xyz + _20579.xyz) * (_13145.xyz * (1.0 - _13142)).xyz;
	    float _12932 = _22686.x;
	    vec4 _11204 = vec4(_12932, _22686.yz, input_5.w);
	    _11204.x = _12932;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    vec3 _15754 = _11204.xyz + (_13147.xyz * _20418).xyz;
	    vec4 _20498 = _11204;
	    _20498.x = _15754.x;
	    _20498.y = _15754.y;
	    _20498.z = _15754.z;
	    vec3 _15734 = _20498.xyz + ((((mix(_11427.xxx, _11427.yyy, _9451) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m6], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _20418).xyz;
	    vec4 _13889 = _20498;
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
	            bool _12900;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m19.x)
	            {
	                _12900 = (_10061.z * PerViewConstantBufferCsgo_t._m19.z) < PerViewConstantBufferCsgo_t._m19.y;
	            }
	            else
	            {
	                _12900 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12900)
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
	            bool _12901;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m23.x)
	            {
	                _12901 = (PerViewConstantBufferCsgo_t._m23.z * _10061.z) < PerViewConstantBufferCsgo_t._m23.y;
	            }
	            else
	            {
	                _12901 = false;
	            }
	            if (_12901)
	            {
	                float _14602 = clamp(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m20.y) + PerViewConstantBufferCsgo_t._m20.x), PerViewConstantBufferCsgo_t._m20.w), 0.0, 1.0) * clamp(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m21.y) + PerViewConstantBufferCsgo_t._m21.x), PerViewConstantBufferCsgo_t._m21.z), 0.0, 1.0);
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m23.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m2], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), normalize((PerViewConstantBufferCsgo_t._m22 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m21.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m20.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m24.x).xyz, _8892).xyz, vec3(_8892));
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
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction1, g_flDetailPropPuddleReduction1);
	FloatAttribute(_dummyMakeVisiblePropMaskBias2, g_flDetailPropMaskBias2);
	FloatAttribute(_dummyMakeVisiblePropMaskSoftness2, g_flDetailPropMaskSoftness2);
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction2, g_flDetailPropPuddleReduction2);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	FloatAttribute(OcclusionCullingBoundsScale, F_OCCLUSION_CULLING_BOUNDS_SCALE ? g_flOcclusionCullingBoundsScale : (F_DEPTH_BIAS ? 1.3 : 1));
	StringAttribute(MaterialLayerRefType, csgo_environment);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor1);
	TextureAttribute(RepresentativeTexture, g_tColor1);
	
	#if (S_SHARED_COLOR_OVERLAY == 0)
		BoolAttribute(HasTexcoordTransform, ((((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || ((g_nUVSet3>0) && (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0)))) || 0);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	#if (S_ENABLE_LAYER_3 == 0)
		IntAttribute(MaterialLayerCount, 2);
	#endif
	#if (S_BLEND_EFFECTS_3 == 1)
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
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
	#if (S_BLEND_EFFECTS_3 == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	#if (S_SHARED_COLOR_OVERLAY == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || ((g_nUVSet3>0) && (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0)))) || ((g_nColorOverlayUVSet>0) && (((g_vOverlayTexCoordScale.x!=1) || (g_vOverlayTexCoordScale.y!=1)) || (g_flOverlayTexCoordRotation!=0)))) || 0);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	
	// Variant Attributes
	BoolAttribute(HasTexcoordTransform, (((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || 0);
	BoolAttribute(HasTexcoordTransform, ((((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || ((g_nColorOverlayUVSet>0) && (((g_vOverlayTexCoordScale.x!=1) || (g_vOverlayTexCoordScale.y!=1)) || (g_flOverlayTexCoordRotation!=0)))) || 0);
	
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
	StaticCombo( S_BLEND_EFFECTS_2, F_BLEND_EFFECTS_2 );
	StaticCombo( S_BLEND_EFFECTS_3, F_BLEND_EFFECTS_3 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_MODE_DEPTH ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_DETAIL_NORMAL ) );
	StaticComboRule( Allow0( S_MODE_DEPTH ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Requires( S_BLEND_EFFECTS_3, S_ENABLE_LAYER_3 ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool bBiplanarUsedAny < UiType(CheckBox); Expression((g_nUVSet1==0) || (g_nUVSet2==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nColorOverlayUVSet==0)); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression((((g_nUVSet1==0) || (g_nUVSet2==0)) || (g_nUVSet3==0)) || (g_nColorOverlayUVSet==0)); >;
	bool bBlendByFacingDirection2 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_2); >;
	bool bBlendByFacingDirection3 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_3); >;
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
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bMaskVertexColor1 < UiType(CheckBox); Expression(g_nVertexColorMode1==0); >;
	bool g_bMaskVertexColor2 < UiType(CheckBox); Expression(g_nVertexColorMode2==0); >;
	bool g_bMaskVertexColor3 < UiType(CheckBox); Expression(g_nVertexColorMode3==0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	bool g_bVertexColorEnabled1 < UiType(CheckBox); Expression(g_nVertexColorMode1!=2); >;
	bool g_bVertexColorEnabled2 < UiType(CheckBox); Expression(g_nVertexColorMode2!=2); >;
	bool g_bVertexColorEnabled3 < UiType(CheckBox); Expression(g_nVertexColorMode3!=2); >;
	bool g_bWetness < UiType(CheckBox); Expression((F_WETNESS==1) || 0); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint2,1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint3,1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	int g_nVisualization < UiType(Slider); Expression(F_VISUALIZATION_MODE); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor2 < Channel(RGB, ArtistDefined(TextureColor2), Srgb); Channel(A, Box(TextureAmbientOcclusion2), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor3 < Channel(RGB, ArtistDefined(TextureColor3), Srgb); Channel(A, Box(TextureAmbientOcclusion3), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight2 < Channel(R, Box(TextureHeight2), Linear); Channel(G, Box(TextureTintMask2), Linear); Channel(A, Box(TextureMetalness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight3 < Channel(R, Box(TextureHeight3), Linear); Channel(G, Box(TextureTintMask3), Linear); Channel(A, Box(TextureMetalness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal1 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal1, TextureRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal2 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal2, TextureRoughness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal3 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal3, TextureRoughness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSharedColorOverlay < Channel(RGB, ArtistDefined(TextureSharedColorOverlay), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
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
	CreateInputTexture2D(TextureTranslucency1, Linear, 8, "", "_trans", "Material1/Translucent,15/0", Default4(1, 1, 1, 0));
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
	float g_flDetailPropPuddleReduction1 < UiType(Slider); UiGroup("Material1/Detail Props,90/30"); >;
	float g_flHeightMapZeroPoint1 < Default(0.5); UiType(Slider); UiGroup("Material1/Height/30"); >;
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	int g_nVertexColorMode1 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material1/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength1 < Default(1); UiType(Slider); UiGroup("Material1/Lighting/61"); >;
	
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
	float3 g_vAmbientOcclusionLevels2 < Default2(0, 0.5); Range(-1, 1); UiType(VectorText); UiGroup("Material2/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness2, Linear, 8, "", "_metal", "Material2/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/30"); >;
	float g_flDetailPropPuddleReduction2 < UiType(Slider); UiGroup("Material2/Detail Props,90/30"); >;
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
	float g_flAOReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/60"); >;
	int g_nVertexColorMode2 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material2/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength2 < Default(1); UiType(Slider); UiGroup("Material2/Lighting/62"); >;
	float g_flAOCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/70"); >;
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
	float3 g_vAmbientOcclusionLevels3 < Default2(0, 0.5); Range(-1, 1); UiType(VectorText); UiGroup("Material3/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness3, Linear, 8, "", "_metal", "Material3/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/30"); >;
	float g_flDetailPropPuddleReduction3 < UiType(Slider); UiGroup("Material3/Detail Props,90/30"); >;
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
	float g_flAOReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/60"); >;
	int g_nVertexColorMode3 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material3/Color Correction/60"); >;
	bool g_bModelTint3 < Default(1); UiType(CheckBox); UiGroup("Material3/Color Correction/61"); >;
	float g_flWetnessDarkeningStrength3 < Default(1); UiType(Slider); UiGroup("Material3/Lighting/63"); >;
	float g_flAOCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/70"); >;
	float g_flMaskWithHeight3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Height/70"); >;
	
	// Color
	CreateInputTexture2D(TextureSharedColorOverlay, Linear, 8, "", "_color", "Color/Overlay/0", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	int g_nColorOverlayUVSet < Default(2); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Color/Overlay/40"); >;
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
	
	// Wetness
	bool g_bWetnessUseHeightmapAdjustments < UiType(CheckBox); UiGroup("Wetness/2"); UiVisibility(F_WETNESS || 0); >;
	bool g_bPuddlesOnVerticalSurfaces < UiType(CheckBox); UiGroup("Wetness,9/3"); UiVisibility(F_WETNESS || 0); >;
	float g_flWetnessUnderlyingHeightMapInfluence < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/3"); UiVisibility(F_WETNESS || 0); >;
	float g_flHorizontalSurfaceTolerance < Default(32); Range(0, 100); UiType(Slider); UiGroup("Wetness/4"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleStrength < Default(1); UiType(Slider); UiGroup("Wetness/5"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleHeight < Default(0.5); UiType(Slider); UiGroup("Wetness/6"); UiVisibility(F_WETNESS || 0); >;
	float3 g_vPuddleSedimentColor < Default3(0.62, 0.56, 0.5); UiType(Color); UiGroup("Wetness/10"); Expression(SrgbGammaToLinear(this)); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleSedimentHeight < Default(0.9); Range(0, 2); UiType(Slider); UiGroup("Wetness/15"); Expression((this*2)-1); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleSedimentOpacity < Default(0.25); UiType(Slider); UiGroup("Wetness/16"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleRoughness < Default(0.02); UiType(Slider); UiGroup("Wetness/17"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleBlendSoftness < Default(0.08); UiType(Slider); UiGroup("Wetness/18"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeStrength < Default(0.5); UiType(Slider); UiGroup("Wetness/20"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeSpread < Default(0.2); UiType(Slider); UiGroup("Wetness/25"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeSoftness < Default(0.2); UiType(Slider); UiGroup("Wetness/26"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetnessStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/30"); UiVisibility(F_WETNESS || 0); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
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
	// SPIR-V source (164328 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct VS_INPUT
	{
	    vec3 vPositionOs;
	    vec2 vTexCoord;
	    vec2 vTexCoord2;
	    vec3 vNormalOs;
	    vec4 vTangentUOs_flTangentVSign;
	    uvec4 vBlendIndices;
	    uint nInstanceIdx;
	    vec4 vBlendColorTint;
	    vec4 vColorBlendValues;
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
	
	struct _RTX_MATERIAL_DATA_
	{
	    vec3 g_vBiplanarTexCoordScale;
	    float g_flDetailPropMaskBias1;
	    float g_flDetailPropPuddleReduction1;
	    bool g_bSnowLayer1;
	    int g_nUVSet1;
	    float _g_fl_AutoPad0_;
	    vec2 g_vTexCoordScale1;
	    vec2 g_vTexCoordCenter1;
	    float g_flTexCoordRotation1;
	    float _g_fl_AutoPad1_;
	    vec2 g_vTexCoordOffset1;
	    vec4 g_vTexCoordXform0_1;
	    vec4 g_vTexCoordXform1_1;
	    vec4 g_vNormalXform_1;
	    float g_flWetnessDarkeningStrength1;
	    int g_nDetailUVSet1;
	    vec2 g_vDetailTexCoordScale1;
	    vec2 g_vDetailTexCoordCenter1;
	    float g_flDetailTexCoordRotation1;
	    float _g_fl_AutoPad2_;
	    vec2 g_vDetailTexCoordOffset1;
	    float _g_fl_AutoPad3_;
	    float _g_fl_AutoPad4_;
	    vec4 g_vDetailTexCoordXform0_1;
	    vec4 g_vDetailTexCoordXform1_1;
	    vec4 g_vDetailNormalXform_1;
	    int g_nDupeOfLayer2;
	    float g_flBlendSoftness2;
	    float g_flUnderlyingHeightMapInfluence2;
	    bool g_bSnowLayer2;
	    int g_nUVSet2;
	    float _g_fl_AutoPad5_;
	    vec2 g_vTexCoordScale2;
	    vec2 g_vTexCoordCenter2;
	    float g_flTexCoordRotation2;
	    float _g_fl_AutoPad6_;
	    vec2 g_vTexCoordOffset2;
	    float _g_fl_AutoPad7_;
	    float _g_fl_AutoPad8_;
	    vec4 g_vTexCoordXform0_2;
	    vec4 g_vTexCoordXform1_2;
	    vec4 g_vNormalXform_2;
	    float g_flWetnessDarkeningStrength2;
	    int g_nDetailUVSet2;
	    vec2 g_vDetailTexCoordScale2;
	    vec2 g_vDetailTexCoordCenter2;
	    float g_flDetailTexCoordRotation2;
	    float _g_fl_AutoPad9_;
	    vec2 g_vDetailTexCoordOffset2;
	    float _g_fl_AutoPad10_;
	    float _g_fl_AutoPad11_;
	    vec4 g_vDetailTexCoordXform0_2;
	    vec4 g_vDetailTexCoordXform1_2;
	    vec4 g_vDetailNormalXform_2;
	    float g_flDetailPropMaskSoftness2;
	    float g_flDetailPropMaskBias2;
	    float g_flDetailPropPuddleReduction2;
	    uint g_tNormal1;
	    uint g_tHeight1;
	    uint g_tNormalDetail1;
	    float g_fDetailTextureNormalContrast1;
	    float g_fTintMaskContrast1;
	    float g_fTintMaskBrightness1;
	    float _g_fl_AutoPad12_;
	    float _g_fl_AutoPad13_;
	    float _g_fl_AutoPad14_;
	    vec3 g_vAmbientOcclusionLevels1;
	    float _g_fl_AutoPad15_;
	    vec3 g_vTextureColorTint1;
	    float g_fTextureColorContrast1;
	    float g_fTextureColorSaturation1;
	    float g_fTextureColorBrightness1;
	    int g_nColorCorrectionMode1;
	    bool g_bAdjustBaseColor1;
	    float g_flHeightMapScale1;
	    float g_flHeightMapZeroPoint1;
	    int g_nVertexColorMode1;
	    bool g_bVertexColorEnabled1;
	    bool g_bMaskVertexColor1;
	    float g_fTextureRoughnessContrast1;
	    float g_fTextureRoughnessBrightness1;
	    float g_fTextureNormalContrast1;
	    bool g_bMetalness1;
	    bool g_bModelTint1;
	    float _g_fl_AutoPad16_;
	    float _g_fl_AutoPad17_;
	    mat4 g_mTextureColorAdjust1;
	    mat4 g_mTextureAdjust1;
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
	    bool g_bMetalness2;
	    float g_fTintMaskContrast2;
	    float g_fTintMaskBrightness2;
	    uint g_tColor2;
	    uint g_tNormal2;
	    uint g_tHeight2;
	    vec3 g_vAmbientOcclusionLevels2;
	    float _g_fl_AutoPad18_;
	    vec3 g_vTextureColorTint2;
	    float g_fTextureColorContrast2;
	    float g_fTextureColorSaturation2;
	    float g_fTextureColorBrightness2;
	    int g_nColorCorrectionMode2;
	    bool g_bAdjustBaseColor2;
	    mat4 g_mTextureColorAdjust2;
	    mat4 g_mTextureAdjust2;
	    float g_flHeightMapScale2;
	    float g_flHeightMapZeroPoint2;
	    float g_flMaskWithHeight2;
	    float _g_fl_AutoPad19_;
	    vec3 g_vFacingDirection2;
	    float g_flFacingDirectionMaskSpread2;
	    float g_vFacingDirectionMaskNormalMapStrength2;
	    float g_vFacingDirectionMaskSoftness2;
	    int g_nVertexColorMode2;
	    bool g_bVertexColorEnabled2;
	    bool g_bMaskVertexColor2;
	    bool g_bModelTint2;
	    uint g_tNormalDetail2;
	    float g_fDetailTextureNormalContrast2;
	    bool g_bPuddlesOnVerticalSurfaces;
	    bool g_bWetnessUseHeightmapAdjustments;
	    float g_flWetnessUnderlyingHeightMapInfluence;
	    float g_flHorizontalSurfaceTolerance;
	    float g_fPuddleStrength;
	    float g_fPuddleHeight;
	    float _g_fl_AutoPad20_;
	    float _g_fl_AutoPad21_;
	    vec3 g_vPuddleSedimentColor;
	    float g_fPuddleSedimentHeight;
	    float g_fPuddleSedimentOpacity;
	    float g_fPuddleRoughness;
	    float g_fPuddleBlendSoftness;
	    float g_fWetEdgeStrength;
	    float g_fWetEdgeSpread;
	    float g_fWetEdgeSoftness;
	    float g_fWetnessStrength;
	    float g_fRainStrength;
	    float g_fRippleStrength;
	    int g_nScaleTexCoord2UByModelScaleAxis;
	    int g_nScaleTexCoord2VByModelScaleAxis;
	    bool g_bTexCoord2ScaleByModel;
	    vec4 g_vTexCoord2ScaleByModelU;
	    vec4 g_vTexCoord2ScaleByModelV;
	    vec2 g_vDetailTexCoordScale;
	    float g_flDetailTexCoordRotation;
	    float _g_fl_AutoPad22_;
	    vec2 g_vDetailTexCoordOffset;
	    float _g_fl_AutoPad23_;
	    float _g_fl_AutoPad24_;
	    vec4 g_vDetailTexCoordXform;
	    float g_flDetailNormalStrength;
	    float _g_fl_AutoPad25_;
	    float _g_fl_AutoPad26_;
	    float _g_fl_AutoPad27_;
	    vec4 g_vDetailNormalStrengthOffsetScale;
	    vec2 g_vTexCoordCenter;
	    vec2 g_vTexCoordScale;
	    float g_flTexCoordRotation;
	    float _g_fl_AutoPad28_;
	    vec2 g_vTexCoordOffset;
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    int g_nScaleTexCoordUByModelScaleAxis;
	    int g_nScaleTexCoordVByModelScaleAxis;
	    bool g_bTexCoordScaleByModel;
	    float _g_fl_AutoPad29_;
	    float _g_fl_AutoPad30_;
	    float _g_fl_AutoPad31_;
	    vec4 g_vTexCoordScaleByModelU;
	    vec4 g_vTexCoordScaleByModelV;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    bool g_bUseSecondaryUvForDetailTexture;
	    uint g_sAniso;
	    uint g_sBilinearClamp;
	    uint g_sTrilinearWrap;
	    uint g_sTrilinearClamp;
	    uint g_sPointClamp;
	    int g_nTextureAddressModeU;
	    int g_nTextureAddressModeV;
	    uint g_sUserConfig;
	    uint g_sUserConfigAllowGlobalMipBias;
	    uint g_tColor1;
	    bool g_bFogEnabled;
	    bool g_bDontFlipBackfaceNormals;
	    bool g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    uint g_tAmbientOcclusion;
	    float g_flMetalness;
	    float g_flRetroReflectivity;
	    bool g_bBorderRoughness2;
	    bool g_bBorderBlendMultiply2;
	    bool g_bBorderBlendReplace2;
	    bool g_bBorderBlendMod2x2;
	    bool g_bBorderBlendColorize2;
	    bool g_bBorderRoughness3;
	    bool g_bBorderBlendMultiply3;
	    bool g_bBorderBlendReplace3;
	    bool g_bBorderBlendMod2x3;
	    bool g_bBorderBlendColorize3;
	    bool bBlendByFacingDirection2;
	    bool bBlendByFacingDirection3;
	    bool g_bWetness;
	    bool bBiplanarUsedAny;
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
	
	const vec3 _609[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _613[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
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
	
	vec4 _697;
	float _698;
	vec3 _699;
	
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
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _member0[];
	} g_MaterialData_5;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_6
	{
	    uint _member0[];
	} g_MaterialData_7;
	
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
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t payload;
	
	void main()
	{
	    PackedRtxInstanceData_t_natural_logical _1075;
	    _1075.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1075.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1075.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1075.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1075.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1075.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1075._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1075._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    uint _743 = _1075.nMaterialData;
	    _RTX_MATERIAL_DATA_ _2668 = _RTX_MATERIAL_DATA_(vec3(g_MaterialData_1._member0[_743 / 4u], g_MaterialData_1._member0[(_743 + 4u) / 4u], g_MaterialData_1._member0[(_743 + 8u) / 4u]), g_MaterialData_1._member0[(_743 + 12u) / 4u], g_MaterialData_1._member0[(_743 + 16u) / 4u], g_MaterialData_3._member0[(_743 + 20u) / 4u] != 0, g_MaterialData_5._member0[(_743 + 24u) / 4u], g_MaterialData_1._member0[(_743 + 28u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 32u) / 4u], g_MaterialData_1._member0[(_743 + 36u) / 4u]), vec2(g_MaterialData_1._member0[(_743 + 40u) / 4u], g_MaterialData_1._member0[(_743 + 44u) / 4u]), g_MaterialData_1._member0[(_743 + 48u) / 4u], g_MaterialData_1._member0[(_743 + 52u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 56u) / 4u], g_MaterialData_1._member0[(_743 + 60u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 64u) / 4u], g_MaterialData_1._member0[(_743 + 68u) / 4u], g_MaterialData_1._member0[(_743 + 72u) / 4u], g_MaterialData_1._member0[(_743 + 76u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 80u) / 4u], g_MaterialData_1._member0[(_743 + 84u) / 4u], g_MaterialData_1._member0[(_743 + 88u) / 4u], g_MaterialData_1._member0[(_743 + 92u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 96u) / 4u], g_MaterialData_1._member0[(_743 + 100u) / 4u], g_MaterialData_1._member0[(_743 + 104u) / 4u], g_MaterialData_1._member0[(_743 + 108u) / 4u]), g_MaterialData_1._member0[(_743 + 112u) / 4u], g_MaterialData_5._member0[(_743 + 116u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 120u) / 4u], g_MaterialData_1._member0[(_743 + 124u) / 4u]), vec2(g_MaterialData_1._member0[(_743 + 128u) / 4u], g_MaterialData_1._member0[(_743 + 132u) / 4u]), g_MaterialData_1._member0[(_743 + 136u) / 4u], g_MaterialData_1._member0[(_743 + 140u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 144u) / 4u], g_MaterialData_1._member0[(_743 + 148u) / 4u]), g_MaterialData_1._member0[(_743 + 152u) / 4u], g_MaterialData_1._member0[(_743 + 156u) / 4u], vec4(g_MaterialData_1._member0[(_743 + 160u) / 4u], g_MaterialData_1._member0[(_743 + 164u) / 4u], g_MaterialData_1._member0[(_743 + 168u) / 4u], g_MaterialData_1._member0[(_743 + 172u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 176u) / 4u], g_MaterialData_1._member0[(_743 + 180u) / 4u], g_MaterialData_1._member0[(_743 + 184u) / 4u], g_MaterialData_1._member0[(_743 + 188u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 192u) / 4u], g_MaterialData_1._member0[(_743 + 196u) / 4u], g_MaterialData_1._member0[(_743 + 200u) / 4u], g_MaterialData_1._member0[(_743 + 204u) / 4u]), g_MaterialData_5._member0[(_743 + 208u) / 4u], g_MaterialData_1._member0[(_743 + 212u) / 4u], g_MaterialData_1._member0[(_743 + 216u) / 4u], g_MaterialData_3._member0[(_743 + 220u) / 4u] != 0, g_MaterialData_5._member0[(_743 + 224u) / 4u], g_MaterialData_1._member0[(_743 + 228u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 232u) / 4u], g_MaterialData_1._member0[(_743 + 236u) / 4u]), vec2(g_MaterialData_1._member0[(_743 + 240u) / 4u], g_MaterialData_1._member0[(_743 + 244u) / 4u]), g_MaterialData_1._member0[(_743 + 248u) / 4u], g_MaterialData_1._member0[(_743 + 252u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 256u) / 4u], g_MaterialData_1._member0[(_743 + 260u) / 4u]), g_MaterialData_1._member0[(_743 + 264u) / 4u], g_MaterialData_1._member0[(_743 + 268u) / 4u], vec4(g_MaterialData_1._member0[(_743 + 272u) / 4u], g_MaterialData_1._member0[(_743 + 276u) / 4u], g_MaterialData_1._member0[(_743 + 280u) / 4u], g_MaterialData_1._member0[(_743 + 284u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 288u) / 4u], g_MaterialData_1._member0[(_743 + 292u) / 4u], g_MaterialData_1._member0[(_743 + 296u) / 4u], g_MaterialData_1._member0[(_743 + 300u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 304u) / 4u], g_MaterialData_1._member0[(_743 + 308u) / 4u], g_MaterialData_1._member0[(_743 + 312u) / 4u], g_MaterialData_1._member0[(_743 + 316u) / 4u]), g_MaterialData_1._member0[(_743 + 320u) / 4u], g_MaterialData_5._member0[(_743 + 324u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 328u) / 4u], g_MaterialData_1._member0[(_743 + 332u) / 4u]), vec2(g_MaterialData_1._member0[(_743 + 336u) / 4u], g_MaterialData_1._member0[(_743 + 340u) / 4u]), g_MaterialData_1._member0[(_743 + 344u) / 4u], g_MaterialData_1._member0[(_743 + 348u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 352u) / 4u], g_MaterialData_1._member0[(_743 + 356u) / 4u]), g_MaterialData_1._member0[(_743 + 360u) / 4u], g_MaterialData_1._member0[(_743 + 364u) / 4u], vec4(g_MaterialData_1._member0[(_743 + 368u) / 4u], g_MaterialData_1._member0[(_743 + 372u) / 4u], g_MaterialData_1._member0[(_743 + 376u) / 4u], g_MaterialData_1._member0[(_743 + 380u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 384u) / 4u], g_MaterialData_1._member0[(_743 + 388u) / 4u], g_MaterialData_1._member0[(_743 + 392u) / 4u], g_MaterialData_1._member0[(_743 + 396u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 400u) / 4u], g_MaterialData_1._member0[(_743 + 404u) / 4u], g_MaterialData_1._member0[(_743 + 408u) / 4u], g_MaterialData_1._member0[(_743 + 412u) / 4u]), g_MaterialData_1._member0[(_743 + 416u) / 4u], g_MaterialData_1._member0[(_743 + 420u) / 4u], g_MaterialData_1._member0[(_743 + 424u) / 4u], g_MaterialData_7._member0[(_743 + 428u) / 4u], g_MaterialData_7._member0[(_743 + 432u) / 4u], g_MaterialData_7._member0[(_743 + 436u) / 4u], g_MaterialData_1._member0[(_743 + 440u) / 4u], g_MaterialData_1._member0[(_743 + 444u) / 4u], g_MaterialData_1._member0[(_743 + 448u) / 4u], g_MaterialData_1._member0[(_743 + 452u) / 4u], g_MaterialData_1._member0[(_743 + 456u) / 4u], g_MaterialData_1._member0[(_743 + 460u) / 4u], vec3(g_MaterialData_1._member0[(_743 + 464u) / 4u], g_MaterialData_1._member0[(_743 + 468u) / 4u], g_MaterialData_1._member0[(_743 + 472u) / 4u]), g_MaterialData_1._member0[(_743 + 476u) / 4u], vec3(g_MaterialData_1._member0[(_743 + 480u) / 4u], g_MaterialData_1._member0[(_743 + 484u) / 4u], g_MaterialData_1._member0[(_743 + 488u) / 4u]), g_MaterialData_1._member0[(_743 + 492u) / 4u], g_MaterialData_1._member0[(_743 + 496u) / 4u], g_MaterialData_1._member0[(_743 + 500u) / 4u], g_MaterialData_5._member0[(_743 + 504u) / 4u], g_MaterialData_3._member0[(_743 + 508u) / 4u] != 0, g_MaterialData_1._member0[(_743 + 512u) / 4u], g_MaterialData_1._member0[(_743 + 516u) / 4u], g_MaterialData_5._member0[(_743 + 520u) / 4u], g_MaterialData_3._member0[(_743 + 524u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 528u) / 4u] != 0, g_MaterialData_1._member0[(_743 + 532u) / 4u], g_MaterialData_1._member0[(_743 + 536u) / 4u], g_MaterialData_1._member0[(_743 + 540u) / 4u], g_MaterialData_3._member0[(_743 + 544u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 548u) / 4u] != 0, g_MaterialData_1._member0[(_743 + 552u) / 4u], g_MaterialData_1._member0[(_743 + 556u) / 4u], mat4(vec4(g_MaterialData_1._member0[(_743 + 560u) / 4u], g_MaterialData_1._member0[(_743 + 576u) / 4u], g_MaterialData_1._member0[(_743 + 592u) / 4u], g_MaterialData_1._member0[(_743 + 608u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 564u) / 4u], g_MaterialData_1._member0[(_743 + 580u) / 4u], g_MaterialData_1._member0[(_743 + 596u) / 4u], g_MaterialData_1._member0[(_743 + 612u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 568u) / 4u], g_MaterialData_1._member0[(_743 + 584u) / 4u], g_MaterialData_1._member0[(_743 + 600u) / 4u], g_MaterialData_1._member0[(_743 + 616u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 572u) / 4u], g_MaterialData_1._member0[(_743 + 588u) / 4u], g_MaterialData_1._member0[(_743 + 604u) / 4u], g_MaterialData_1._member0[(_743 + 620u) / 4u])), mat4(vec4(g_MaterialData_1._member0[(_743 + 624u) / 4u], g_MaterialData_1._member0[(_743 + 640u) / 4u], g_MaterialData_1._member0[(_743 + 656u) / 4u], g_MaterialData_1._member0[(_743 + 672u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 628u) / 4u], g_MaterialData_1._member0[(_743 + 644u) / 4u], g_MaterialData_1._member0[(_743 + 660u) / 4u], g_MaterialData_1._member0[(_743 + 676u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 632u) / 4u], g_MaterialData_1._member0[(_743 + 648u) / 4u], g_MaterialData_1._member0[(_743 + 664u) / 4u], g_MaterialData_1._member0[(_743 + 680u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 636u) / 4u], g_MaterialData_1._member0[(_743 + 652u) / 4u], g_MaterialData_1._member0[(_743 + 668u) / 4u], g_MaterialData_1._member0[(_743 + 684u) / 4u])), g_MaterialData_1._member0[(_743 + 688u) / 4u], g_MaterialData_1._member0[(_743 + 692u) / 4u], g_MaterialData_1._member0[(_743 + 696u) / 4u], g_MaterialData_1._member0[(_743 + 700u) / 4u], g_MaterialData_1._member0[(_743 + 704u) / 4u], g_MaterialData_1._member0[(_743 + 708u) / 4u], g_MaterialData_1._member0[(_743 + 712u) / 4u], g_MaterialData_1._member0[(_743 + 716u) / 4u], g_MaterialData_1._member0[(_743 + 720u) / 4u], g_MaterialData_1._member0[(_743 + 724u) / 4u], g_MaterialData_1._member0[(_743 + 728u) / 4u], g_MaterialData_1._member0[(_743 + 732u) / 4u], g_MaterialData_1._member0[(_743 + 736u) / 4u], g_MaterialData_1._member0[(_743 + 740u) / 4u], g_MaterialData_3._member0[(_743 + 744u) / 4u] != 0, g_MaterialData_1._member0[(_743 + 748u) / 4u], g_MaterialData_1._member0[(_743 + 752u) / 4u], g_MaterialData_7._member0[(_743 + 756u) / 4u], g_MaterialData_7._member0[(_743 + 760u) / 4u], g_MaterialData_7._member0[(_743 + 764u) / 4u], vec3(g_MaterialData_1._member0[(_743 + 768u) / 4u], g_MaterialData_1._member0[(_743 + 772u) / 4u], g_MaterialData_1._member0[(_743 + 776u) / 4u]), g_MaterialData_1._member0[(_743 + 780u) / 4u], vec3(g_MaterialData_1._member0[(_743 + 784u) / 4u], g_MaterialData_1._member0[(_743 + 788u) / 4u], g_MaterialData_1._member0[(_743 + 792u) / 4u]), g_MaterialData_1._member0[(_743 + 796u) / 4u], g_MaterialData_1._member0[(_743 + 800u) / 4u], g_MaterialData_1._member0[(_743 + 804u) / 4u], g_MaterialData_5._member0[(_743 + 808u) / 4u], g_MaterialData_3._member0[(_743 + 812u) / 4u] != 0, mat4(vec4(g_MaterialData_1._member0[(_743 + 816u) / 4u], g_MaterialData_1._member0[(_743 + 832u) / 4u], g_MaterialData_1._member0[(_743 + 848u) / 4u], g_MaterialData_1._member0[(_743 + 864u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 820u) / 4u], g_MaterialData_1._member0[(_743 + 836u) / 4u], g_MaterialData_1._member0[(_743 + 852u) / 4u], g_MaterialData_1._member0[(_743 + 868u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 824u) / 4u], g_MaterialData_1._member0[(_743 + 840u) / 4u], g_MaterialData_1._member0[(_743 + 856u) / 4u], g_MaterialData_1._member0[(_743 + 872u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 828u) / 4u], g_MaterialData_1._member0[(_743 + 844u) / 4u], g_MaterialData_1._member0[(_743 + 860u) / 4u], g_MaterialData_1._member0[(_743 + 876u) / 4u])), mat4(vec4(g_MaterialData_1._member0[(_743 + 880u) / 4u], g_MaterialData_1._member0[(_743 + 896u) / 4u], g_MaterialData_1._member0[(_743 + 912u) / 4u], g_MaterialData_1._member0[(_743 + 928u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 884u) / 4u], g_MaterialData_1._member0[(_743 + 900u) / 4u], g_MaterialData_1._member0[(_743 + 916u) / 4u], g_MaterialData_1._member0[(_743 + 932u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 888u) / 4u], g_MaterialData_1._member0[(_743 + 904u) / 4u], g_MaterialData_1._member0[(_743 + 920u) / 4u], g_MaterialData_1._member0[(_743 + 936u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 892u) / 4u], g_MaterialData_1._member0[(_743 + 908u) / 4u], g_MaterialData_1._member0[(_743 + 924u) / 4u], g_MaterialData_1._member0[(_743 + 940u) / 4u])), g_MaterialData_1._member0[(_743 + 944u) / 4u], g_MaterialData_1._member0[(_743 + 948u) / 4u], g_MaterialData_1._member0[(_743 + 952u) / 4u], g_MaterialData_1._member0[(_743 + 956u) / 4u], vec3(g_MaterialData_1._member0[(_743 + 960u) / 4u], g_MaterialData_1._member0[(_743 + 964u) / 4u], g_MaterialData_1._member0[(_743 + 968u) / 4u]), g_MaterialData_1._member0[(_743 + 972u) / 4u], g_MaterialData_1._member0[(_743 + 976u) / 4u], g_MaterialData_1._member0[(_743 + 980u) / 4u], g_MaterialData_5._member0[(_743 + 984u) / 4u], g_MaterialData_3._member0[(_743 + 988u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 992u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 996u) / 4u] != 0, g_MaterialData_7._member0[(_743 + 1000u) / 4u], g_MaterialData_1._member0[(_743 + 1004u) / 4u], g_MaterialData_3._member0[(_743 + 1008u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1012u) / 4u] != 0, g_MaterialData_1._member0[(_743 + 1016u) / 4u], g_MaterialData_1._member0[(_743 + 1020u) / 4u], g_MaterialData_1._member0[(_743 + 1024u) / 4u], g_MaterialData_1._member0[(_743 + 1028u) / 4u], g_MaterialData_1._member0[(_743 + 1032u) / 4u], g_MaterialData_1._member0[(_743 + 1036u) / 4u], vec3(g_MaterialData_1._member0[(_743 + 1040u) / 4u], g_MaterialData_1._member0[(_743 + 1044u) / 4u], g_MaterialData_1._member0[(_743 + 1048u) / 4u]), g_MaterialData_1._member0[(_743 + 1052u) / 4u], g_MaterialData_1._member0[(_743 + 1056u) / 4u], g_MaterialData_1._member0[(_743 + 1060u) / 4u], g_MaterialData_1._member0[(_743 + 1064u) / 4u], g_MaterialData_1._member0[(_743 + 1068u) / 4u], g_MaterialData_1._member0[(_743 + 1072u) / 4u], g_MaterialData_1._member0[(_743 + 1076u) / 4u], g_MaterialData_1._member0[(_743 + 1080u) / 4u], g_MaterialData_1._member0[(_743 + 1084u) / 4u], g_MaterialData_1._member0[(_743 + 1088u) / 4u], g_MaterialData_5._member0[(_743 + 1092u) / 4u], g_MaterialData_5._member0[(_743 + 1096u) / 4u], g_MaterialData_3._member0[(_743 + 1100u) / 4u] != 0, vec4(g_MaterialData_1._member0[(_743 + 1104u) / 4u], g_MaterialData_1._member0[(_743 + 1108u) / 4u], g_MaterialData_1._member0[(_743 + 1112u) / 4u], g_MaterialData_1._member0[(_743 + 1116u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 1120u) / 4u], g_MaterialData_1._member0[(_743 + 1124u) / 4u], g_MaterialData_1._member0[(_743 + 1128u) / 4u], g_MaterialData_1._member0[(_743 + 1132u) / 4u]), vec2(g_MaterialData_1._member0[(_743 + 1136u) / 4u], g_MaterialData_1._member0[(_743 + 1140u) / 4u]), g_MaterialData_1._member0[(_743 + 1144u) / 4u], g_MaterialData_1._member0[(_743 + 1148u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 1152u) / 4u], g_MaterialData_1._member0[(_743 + 1156u) / 4u]), g_MaterialData_1._member0[(_743 + 1160u) / 4u], g_MaterialData_1._member0[(_743 + 1164u) / 4u], vec4(g_MaterialData_1._member0[(_743 + 1168u) / 4u], g_MaterialData_1._member0[(_743 + 1172u) / 4u], g_MaterialData_1._member0[(_743 + 1176u) / 4u], g_MaterialData_1._member0[(_743 + 1180u) / 4u]), g_MaterialData_1._member0[(_743 + 1184u) / 4u], g_MaterialData_1._member0[(_743 + 1188u) / 4u], g_MaterialData_1._member0[(_743 + 1192u) / 4u], g_MaterialData_1._member0[(_743 + 1196u) / 4u], vec4(g_MaterialData_1._member0[(_743 + 1200u) / 4u], g_MaterialData_1._member0[(_743 + 1204u) / 4u], g_MaterialData_1._member0[(_743 + 1208u) / 4u], g_MaterialData_1._member0[(_743 + 1212u) / 4u]), vec2(g_MaterialData_1._member0[(_743 + 1216u) / 4u], g_MaterialData_1._member0[(_743 + 1220u) / 4u]), vec2(g_MaterialData_1._member0[(_743 + 1224u) / 4u], g_MaterialData_1._member0[(_743 + 1228u) / 4u]), g_MaterialData_1._member0[(_743 + 1232u) / 4u], g_MaterialData_1._member0[(_743 + 1236u) / 4u], vec2(g_MaterialData_1._member0[(_743 + 1240u) / 4u], g_MaterialData_1._member0[(_743 + 1244u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 1248u) / 4u], g_MaterialData_1._member0[(_743 + 1252u) / 4u], g_MaterialData_1._member0[(_743 + 1256u) / 4u], g_MaterialData_1._member0[(_743 + 1260u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 1264u) / 4u], g_MaterialData_1._member0[(_743 + 1268u) / 4u], g_MaterialData_1._member0[(_743 + 1272u) / 4u], g_MaterialData_1._member0[(_743 + 1276u) / 4u]), vec2(g_MaterialData_1._member0[(_743 + 1280u) / 4u], g_MaterialData_1._member0[(_743 + 1284u) / 4u]), g_MaterialData_5._member0[(_743 + 1288u) / 4u], g_MaterialData_5._member0[(_743 + 1292u) / 4u], g_MaterialData_3._member0[(_743 + 1296u) / 4u] != 0, g_MaterialData_1._member0[(_743 + 1300u) / 4u], g_MaterialData_1._member0[(_743 + 1304u) / 4u], g_MaterialData_1._member0[(_743 + 1308u) / 4u], vec4(g_MaterialData_1._member0[(_743 + 1312u) / 4u], g_MaterialData_1._member0[(_743 + 1316u) / 4u], g_MaterialData_1._member0[(_743 + 1320u) / 4u], g_MaterialData_1._member0[(_743 + 1324u) / 4u]), vec4(g_MaterialData_1._member0[(_743 + 1328u) / 4u], g_MaterialData_1._member0[(_743 + 1332u) / 4u], g_MaterialData_1._member0[(_743 + 1336u) / 4u], g_MaterialData_1._member0[(_743 + 1340u) / 4u]), vec3(g_MaterialData_1._member0[(_743 + 1344u) / 4u], g_MaterialData_1._member0[(_743 + 1348u) / 4u], g_MaterialData_1._member0[(_743 + 1352u) / 4u]), g_MaterialData_1._member0[(_743 + 1356u) / 4u], g_MaterialData_3._member0[(_743 + 1360u) / 4u] != 0, g_MaterialData_7._member0[(_743 + 1364u) / 4u], g_MaterialData_7._member0[(_743 + 1368u) / 4u], g_MaterialData_7._member0[(_743 + 1372u) / 4u], g_MaterialData_7._member0[(_743 + 1376u) / 4u], g_MaterialData_7._member0[(_743 + 1380u) / 4u], g_MaterialData_5._member0[(_743 + 1384u) / 4u], g_MaterialData_5._member0[(_743 + 1388u) / 4u], g_MaterialData_7._member0[(_743 + 1392u) / 4u], g_MaterialData_7._member0[(_743 + 1396u) / 4u], g_MaterialData_7._member0[(_743 + 1400u) / 4u], g_MaterialData_3._member0[(_743 + 1404u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1408u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1412u) / 4u] != 0, g_MaterialData_1._member0[(_743 + 1416u) / 4u], g_MaterialData_7._member0[(_743 + 1420u) / 4u], g_MaterialData_1._member0[(_743 + 1424u) / 4u], g_MaterialData_1._member0[(_743 + 1428u) / 4u], g_MaterialData_3._member0[(_743 + 1432u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1436u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1440u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1444u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1448u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1452u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1456u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1460u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1464u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1468u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1472u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1476u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1480u) / 4u] != 0, g_MaterialData_3._member0[(_743 + 1484u) / 4u] != 0);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _2668;
	    uvec3 _1068;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _2716 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _1068 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_2716 / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_2716 + 4u) / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_2716 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _2689 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _2690 = _2689 & 4294967292u;
	            uint _2691 = _2690 / 4u;
	            uint _2695 = (_2690 + 4u) / 4u;
	            uint _2700 = (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_2691] & 4294901760u) >> uint(16);
	            uint _2701 = g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_2695] & 65535u;
	            uvec3 _1069;
	            if (_2689 == _2690)
	            {
	                _1069 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_2691] & 65535u, _2700, _2701);
	            }
	            else
	            {
	                _1069 = uvec3(_2700, _2701, (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_2695] & 4294901760u) >> uint(16));
	            }
	            _1068 = _1069;
	            break;
	        }
	        break;
	    } while(false);
	    uint _61 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _2747 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _1068) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _1062[3];
	    uint _2749 = _2747.x;
	    _1062[0] = vec3(g_Vertices_1[_61]._member0[_2749 / 4u], g_Vertices_1[_61]._member0[(_2749 + 4u) / 4u], g_Vertices_1[_61]._member0[(_2749 + 8u) / 4u]);
	    uint _2763 = _2747.y;
	    _1062[1] = vec3(g_Vertices_1[_61]._member0[_2763 / 4u], g_Vertices_1[_61]._member0[(_2763 + 4u) / 4u], g_Vertices_1[_61]._member0[(_2763 + 8u) / 4u]);
	    uint _2777 = _2747.z;
	    _1062[2] = vec3(g_Vertices_1[_61]._member0[_2777 / 4u], g_Vertices_1[_61]._member0[(_2777 + 4u) / 4u], g_Vertices_1[_61]._member0[(_2777 + 8u) / 4u]);
	    int _1063 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_1063 < 3))
	        {
	            break;
	        }
	        vsInput[_1063].vPositionOs = _1062[_1063];
	        _1063++;
	        continue;
	    }
	    vec2 _1064[3];
	    _1064[0] = vec2(0.0);
	    _1064[1] = vec2(0.0);
	    _1064[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _1061 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _63 = uint(_1061[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _2828 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _1059 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1060 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2844 = (uvec3(uint(_1059[_2828])) * _1068) + uvec3(uint(_1060[_2828]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _2976 = _2844.x;
	            _1064[0] = vec2(g_Vertices_1[_63]._member0[_2976 / 4u], g_Vertices_1[_63]._member0[(_2976 + 4u) / 4u]);
	            uint _2985 = _2844.y;
	            _1064[1] = vec2(g_Vertices_1[_63]._member0[_2985 / 4u], g_Vertices_1[_63]._member0[(_2985 + 4u) / 4u]);
	            uint _2994 = _2844.z;
	            _1064[2] = vec2(g_Vertices_1[_63]._member0[_2994 / 4u], g_Vertices_1[_63]._member0[(_2994 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _2947 = _2844.x / 4u;
	                _1064[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_63]._member0[_2947], g_Vertices_3[_63]._member0[_2947] >> uint(16)) & uvec2(65535u))));
	                uint _2957 = _2844.y / 4u;
	                _1064[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_63]._member0[_2957], g_Vertices_3[_63]._member0[_2957] >> uint(16)) & uvec2(65535u))));
	                uint _2967 = _2844.z / 4u;
	                _1064[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_63]._member0[_2967], g_Vertices_3[_63]._member0[_2967] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _2857 = _2844.x / 4u;
	                    uint _2860 = g_Vertices_3[_63]._member0[_2857] & 65535u;
	                    int _1058;
	                    if (_2860 > 32767u)
	                    {
	                        _1058 = int(4294901760u | _2860);
	                    }
	                    else
	                    {
	                        _1058 = int(_2860);
	                    }
	                    uint _2873 = (g_Vertices_3[_63]._member0[_2857] & 4294901760u) >> uint(16);
	                    int _1057;
	                    if (_2873 > 32767u)
	                    {
	                        _1057 = int(4294901760u | _2873);
	                    }
	                    else
	                    {
	                        _1057 = int(_2873);
	                    }
	                    _1064[0] = vec2(max(float(_1058) * 3.0518509447574615478515625e-05, -1.0), max(float(_1057) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2887 = _2844.y / 4u;
	                    uint _2890 = g_Vertices_3[_63]._member0[_2887] & 65535u;
	                    int _1056;
	                    if (_2890 > 32767u)
	                    {
	                        _1056 = int(4294901760u | _2890);
	                    }
	                    else
	                    {
	                        _1056 = int(_2890);
	                    }
	                    uint _2903 = (g_Vertices_3[_63]._member0[_2887] & 4294901760u) >> uint(16);
	                    int _1055;
	                    if (_2903 > 32767u)
	                    {
	                        _1055 = int(4294901760u | _2903);
	                    }
	                    else
	                    {
	                        _1055 = int(_2903);
	                    }
	                    _1064[1] = vec2(max(float(_1056) * 3.0518509447574615478515625e-05, -1.0), max(float(_1055) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2917 = _2844.z / 4u;
	                    uint _2920 = g_Vertices_3[_63]._member0[_2917] & 65535u;
	                    int _1054;
	                    if (_2920 > 32767u)
	                    {
	                        _1054 = int(4294901760u | _2920);
	                    }
	                    else
	                    {
	                        _1054 = int(_2920);
	                    }
	                    uint _2933 = (g_Vertices_3[_63]._member0[_2917] & 4294901760u) >> uint(16);
	                    int _1053;
	                    if (_2933 > 32767u)
	                    {
	                        _1053 = int(4294901760u | _2933);
	                    }
	                    else
	                    {
	                        _1053 = int(_2933);
	                    }
	                    _1064[2] = vec2(max(float(_1054) * 3.0518509447574615478515625e-05, -1.0), max(float(_1053) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _1063 = 0;
	    for (;;)
	    {
	        if (!(_1063 < 3))
	        {
	            break;
	        }
	        vsInput[_1063].vTexCoord = _1064[_1063];
	        _1063++;
	        continue;
	    }
	    _1064[0] = vec2(0.0);
	    _1064[1] = vec2(0.0);
	    _1064[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _1052 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _67 = uint(_1052[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _3039 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _1050 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1051 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3055 = (uvec3(uint(_1050[_3039])) * _1068) + uvec3(uint(_1051[_3039]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _3187 = _3055.x;
	            _1064[0] = vec2(g_Vertices_1[_67]._member0[_3187 / 4u], g_Vertices_1[_67]._member0[(_3187 + 4u) / 4u]);
	            uint _3196 = _3055.y;
	            _1064[1] = vec2(g_Vertices_1[_67]._member0[_3196 / 4u], g_Vertices_1[_67]._member0[(_3196 + 4u) / 4u]);
	            uint _3205 = _3055.z;
	            _1064[2] = vec2(g_Vertices_1[_67]._member0[_3205 / 4u], g_Vertices_1[_67]._member0[(_3205 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _3158 = _3055.x / 4u;
	                _1064[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_67]._member0[_3158], g_Vertices_3[_67]._member0[_3158] >> uint(16)) & uvec2(65535u))));
	                uint _3168 = _3055.y / 4u;
	                _1064[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_67]._member0[_3168], g_Vertices_3[_67]._member0[_3168] >> uint(16)) & uvec2(65535u))));
	                uint _3178 = _3055.z / 4u;
	                _1064[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_67]._member0[_3178], g_Vertices_3[_67]._member0[_3178] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _3068 = _3055.x / 4u;
	                    uint _3071 = g_Vertices_3[_67]._member0[_3068] & 65535u;
	                    int _1049;
	                    if (_3071 > 32767u)
	                    {
	                        _1049 = int(4294901760u | _3071);
	                    }
	                    else
	                    {
	                        _1049 = int(_3071);
	                    }
	                    uint _3084 = (g_Vertices_3[_67]._member0[_3068] & 4294901760u) >> uint(16);
	                    int _1048;
	                    if (_3084 > 32767u)
	                    {
	                        _1048 = int(4294901760u | _3084);
	                    }
	                    else
	                    {
	                        _1048 = int(_3084);
	                    }
	                    _1064[0] = vec2(max(float(_1049) * 3.0518509447574615478515625e-05, -1.0), max(float(_1048) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _3098 = _3055.y / 4u;
	                    uint _3101 = g_Vertices_3[_67]._member0[_3098] & 65535u;
	                    int _1047;
	                    if (_3101 > 32767u)
	                    {
	                        _1047 = int(4294901760u | _3101);
	                    }
	                    else
	                    {
	                        _1047 = int(_3101);
	                    }
	                    uint _3114 = (g_Vertices_3[_67]._member0[_3098] & 4294901760u) >> uint(16);
	                    int _1046;
	                    if (_3114 > 32767u)
	                    {
	                        _1046 = int(4294901760u | _3114);
	                    }
	                    else
	                    {
	                        _1046 = int(_3114);
	                    }
	                    _1064[1] = vec2(max(float(_1047) * 3.0518509447574615478515625e-05, -1.0), max(float(_1046) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _3128 = _3055.z / 4u;
	                    uint _3131 = g_Vertices_3[_67]._member0[_3128] & 65535u;
	                    int _1045;
	                    if (_3131 > 32767u)
	                    {
	                        _1045 = int(4294901760u | _3131);
	                    }
	                    else
	                    {
	                        _1045 = int(_3131);
	                    }
	                    uint _3144 = (g_Vertices_3[_67]._member0[_3128] & 4294901760u) >> uint(16);
	                    int _1044;
	                    if (_3144 > 32767u)
	                    {
	                        _1044 = int(4294901760u | _3144);
	                    }
	                    else
	                    {
	                        _1044 = int(_3144);
	                    }
	                    _1064[2] = vec2(max(float(_1045) * 3.0518509447574615478515625e-05, -1.0), max(float(_1044) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _1063 = 0;
	    for (;;)
	    {
	        if (!(_1063 < 3))
	        {
	            break;
	        }
	        vsInput[_1063].vTexCoord2 = _1064[_1063];
	        _1063++;
	        continue;
	    }
	    vec3 _1065[3];
	    vec4 _1066[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _1030 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _71 = uint(_1030[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _3255 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _1028 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _1029 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _3271 = (uvec3(uint(_1028[_3255])) * _1068) + uvec3(uint(_1029[_3255]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _3799 = _3271.x;
	                _1065[0] = vec3(g_Vertices_1[_71]._member0[_3799 / 4u], g_Vertices_1[_71]._member0[(_3799 + 4u) / 4u], g_Vertices_1[_71]._member0[(_3799 + 8u) / 4u]);
	                uint _3813 = _3271.y;
	                _1065[1] = vec3(g_Vertices_1[_71]._member0[_3813 / 4u], g_Vertices_1[_71]._member0[(_3813 + 4u) / 4u], g_Vertices_1[_71]._member0[(_3813 + 8u) / 4u]);
	                uint _3827 = _3271.z;
	                _1065[2] = vec3(g_Vertices_1[_71]._member0[_3827 / 4u], g_Vertices_1[_71]._member0[(_3827 + 4u) / 4u], g_Vertices_1[_71]._member0[(_3827 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _3535 = _3271.x;
	                    uvec2 _3543 = uvec2(g_Vertices_3[_71]._member0[_3535 / 4u], g_Vertices_3[_71]._member0[(_3535 + 4u) / 4u]);
	                    uint _3544 = _3271.y;
	                    uvec2 _721 = uvec2(g_Vertices_3[_71]._member0[_3544 / 4u], g_Vertices_3[_71]._member0[(_3544 + 4u) / 4u]);
	                    uint _3553 = _3271.z;
	                    uvec2 _720 = uvec2(g_Vertices_3[_71]._member0[_3553 / 4u], g_Vertices_3[_71]._member0[(_3553 + 4u) / 4u]);
	                    uint _3565 = _3543.x;
	                    uint _3573 = _3543.y;
	                    vec2 _3583 = ((vec2(float(_3565 & 65535u), float((_3565 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3584 = _3583.x;
	                    float _3589 = (1.0 - abs(_3584)) - abs(_3583.y);
	                    vec3 _3590 = vec3(_3584, _3583.y, _3589);
	                    float _3592 = saturate(-_3589);
	                    vec2 _3598 = _3583 + mix(vec2(_3592), vec2(-_3592), greaterThanEqual(_3583, vec2(0.0)));
	                    _3590.x = _3598.x;
	                    _3590.y = _3598.y;
	                    vec3 _1032 = normalize(_3590);
	                    vec2 _3605 = ((vec2(float((_3573 >> uint(1)) & 32767u), float((_3573 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3606 = _3605.x;
	                    float _3611 = (1.0 - abs(_3606)) - abs(_3605.y);
	                    vec3 _3612 = vec3(_3606, _3605.y, _3611);
	                    float _3614 = saturate(-_3611);
	                    vec2 _3620 = _3605 + mix(vec2(_3614), vec2(-_3614), greaterThanEqual(_3605, vec2(0.0)));
	                    _3612.x = _3620.x;
	                    _3612.y = _3620.y;
	                    vec3 _1031 = normalize(_3612);
	                    float _1018;
	                    if ((_3573 & 1u) != 0u)
	                    {
	                        _1018 = 1.0;
	                    }
	                    else
	                    {
	                        _1018 = -1.0;
	                    }
	                    _1065[0] = _1032;
	                    _1066[0].w = _1018;
	                    _1066[0].x = _1031.x;
	                    _1066[0].y = _1031.y;
	                    _1066[0].z = _1031.z;
	                    vec2 _3662 = ((vec2(float(_721.x & 65535u), float((_721.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3663 = _3662.x;
	                    float _3668 = (1.0 - abs(_3663)) - abs(_3662.y);
	                    vec3 _3669 = vec3(_3663, _3662.y, _3668);
	                    float _3671 = saturate(-_3668);
	                    vec2 _3677 = _3662 + mix(vec2(_3671), vec2(-_3671), greaterThanEqual(_3662, vec2(0.0)));
	                    _3669.x = _3677.x;
	                    _3669.y = _3677.y;
	                    vec3 _1034 = normalize(_3669);
	                    vec2 _3684 = ((vec2(float((_721.y >> uint(1)) & 32767u), float((_721.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3685 = _3684.x;
	                    float _3690 = (1.0 - abs(_3685)) - abs(_3684.y);
	                    vec3 _3691 = vec3(_3685, _3684.y, _3690);
	                    float _3693 = saturate(-_3690);
	                    vec2 _3699 = _3684 + mix(vec2(_3693), vec2(-_3693), greaterThanEqual(_3684, vec2(0.0)));
	                    _3691.x = _3699.x;
	                    _3691.y = _3699.y;
	                    vec3 _1033 = normalize(_3691);
	                    float _1017;
	                    if ((_721.y & 1u) != 0u)
	                    {
	                        _1017 = 1.0;
	                    }
	                    else
	                    {
	                        _1017 = -1.0;
	                    }
	                    _1065[1] = _1034;
	                    _1066[1].w = _1017;
	                    _1066[1].x = _1033.x;
	                    _1066[1].y = _1033.y;
	                    _1066[1].z = _1033.z;
	                    vec2 _3741 = ((vec2(float(_720.x & 65535u), float((_720.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3742 = _3741.x;
	                    float _3747 = (1.0 - abs(_3742)) - abs(_3741.y);
	                    vec3 _3748 = vec3(_3742, _3741.y, _3747);
	                    float _3750 = saturate(-_3747);
	                    vec2 _3756 = _3741 + mix(vec2(_3750), vec2(-_3750), greaterThanEqual(_3741, vec2(0.0)));
	                    _3748.x = _3756.x;
	                    _3748.y = _3756.y;
	                    vec3 _1036 = normalize(_3748);
	                    vec2 _3763 = ((vec2(float((_720.y >> uint(1)) & 32767u), float((_720.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3764 = _3763.x;
	                    float _3769 = (1.0 - abs(_3764)) - abs(_3763.y);
	                    vec3 _3770 = vec3(_3764, _3763.y, _3769);
	                    float _3772 = saturate(-_3769);
	                    vec2 _3778 = _3763 + mix(vec2(_3772), vec2(-_3772), greaterThanEqual(_3763, vec2(0.0)));
	                    _3770.x = _3778.x;
	                    _3770.y = _3778.y;
	                    vec3 _1035 = normalize(_3770);
	                    float _1016;
	                    if ((_720.y & 1u) != 0u)
	                    {
	                        _1016 = 1.0;
	                    }
	                    else
	                    {
	                        _1016 = -1.0;
	                    }
	                    _1065[2] = _1036;
	                    _1066[2].w = _1016;
	                    _1066[2].x = _1035.x;
	                    _1066[2].y = _1035.y;
	                    _1066[2].z = _1035.z;
	                    break;
	                }
	                else
	                {
	                    uint _3281 = _3271.x / 4u;
	                    vec4 _1038 = _1066[0];
	                    float _3296 = (float((g_Vertices_3[_71]._member0[_3281] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3299 = (float((g_Vertices_3[_71]._member0[_3281] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3303 = (1.0 - abs(_3296)) - abs(_3299);
	                    vec3 _3304 = vec3(_3296, _3299, _3303);
	                    float _3306 = saturate(-_3303);
	                    vec2 _3307 = vec2(_3296, _3299);
	                    vec2 _3313 = _3307 + mix(vec2(_3306), vec2(-_3306), greaterThanEqual(_3307, vec2(0.0)));
	                    _3304.x = _3313.x;
	                    _3304.y = _3313.y;
	                    vec3 _3318 = normalize(_3304);
	                    vec3 _1037 = _3318;
	                    float _3319 = _3318.z;
	                    float _1025;
	                    if (_3319 >= 0.0)
	                    {
	                        _1025 = 1.0;
	                    }
	                    else
	                    {
	                        _1025 = -1.0;
	                    }
	                    float _3326 = (-1.0) / (_1025 + _3319);
	                    float _3327 = _3318.x;
	                    vec3 _1026;
	                    vec3 _3335 = _1026;
	                    _3335.x = 1.0 + (((_1025 * _3327) * _3327) * _3326);
	                    _3335.y = _1025 * ((_3327 * _3318.y) * _3326);
	                    _3335.z = (-_1025) * _3327;
	                    _1026 = _3335;
	                    float _3343 = float((g_Vertices_3[_71]._member0[_3281] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3349 = (_3335 * cos(_3343)) + (cross(_3318, _3335) * sin(_3343));
	                    vec4 _3351 = _1038;
	                    _3351.x = _3349.x;
	                    _3351.y = _3349.y;
	                    _3351.z = _3349.z;
	                    _1038 = _3351;
	                    float _1027;
	                    if ((g_Vertices_3[_71]._member0[_3281] & 1u) == 0u)
	                    {
	                        _1027 = -1.0;
	                    }
	                    else
	                    {
	                        _1027 = 1.0;
	                    }
	                    vec4 _3362 = _1038;
	                    _3362.w = _1027;
	                    _1038 = _3362;
	                    _1065[0] = _1037;
	                    _1066[0] = _3362;
	                    uint _3366 = _3271.y / 4u;
	                    vec4 _1040 = _1066[1];
	                    float _3381 = (float((g_Vertices_3[_71]._member0[_3366] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3384 = (float((g_Vertices_3[_71]._member0[_3366] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3388 = (1.0 - abs(_3381)) - abs(_3384);
	                    vec3 _3389 = vec3(_3381, _3384, _3388);
	                    float _3391 = saturate(-_3388);
	                    vec2 _3392 = vec2(_3381, _3384);
	                    vec2 _3398 = _3392 + mix(vec2(_3391), vec2(-_3391), greaterThanEqual(_3392, vec2(0.0)));
	                    _3389.x = _3398.x;
	                    _3389.y = _3398.y;
	                    vec3 _3403 = normalize(_3389);
	                    vec3 _1039 = _3403;
	                    float _3404 = _3403.z;
	                    float _1022;
	                    if (_3404 >= 0.0)
	                    {
	                        _1022 = 1.0;
	                    }
	                    else
	                    {
	                        _1022 = -1.0;
	                    }
	                    float _3411 = (-1.0) / (_1022 + _3404);
	                    float _3412 = _3403.x;
	                    vec3 _1023;
	                    vec3 _3420 = _1023;
	                    _3420.x = 1.0 + (((_1022 * _3412) * _3412) * _3411);
	                    _3420.y = _1022 * ((_3412 * _3403.y) * _3411);
	                    _3420.z = (-_1022) * _3412;
	                    _1023 = _3420;
	                    float _3428 = float((g_Vertices_3[_71]._member0[_3366] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3434 = (_3420 * cos(_3428)) + (cross(_3403, _3420) * sin(_3428));
	                    vec4 _3436 = _1040;
	                    _3436.x = _3434.x;
	                    _3436.y = _3434.y;
	                    _3436.z = _3434.z;
	                    _1040 = _3436;
	                    float _1024;
	                    if ((g_Vertices_3[_71]._member0[_3366] & 1u) == 0u)
	                    {
	                        _1024 = -1.0;
	                    }
	                    else
	                    {
	                        _1024 = 1.0;
	                    }
	                    vec4 _3447 = _1040;
	                    _3447.w = _1024;
	                    _1040 = _3447;
	                    _1065[1] = _1039;
	                    _1066[1] = _3447;
	                    uint _3451 = _3271.z / 4u;
	                    vec4 _1042 = _1066[2];
	                    float _3466 = (float((g_Vertices_3[_71]._member0[_3451] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3469 = (float((g_Vertices_3[_71]._member0[_3451] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3473 = (1.0 - abs(_3466)) - abs(_3469);
	                    vec3 _3474 = vec3(_3466, _3469, _3473);
	                    float _3476 = saturate(-_3473);
	                    vec2 _3477 = vec2(_3466, _3469);
	                    vec2 _3483 = _3477 + mix(vec2(_3476), vec2(-_3476), greaterThanEqual(_3477, vec2(0.0)));
	                    _3474.x = _3483.x;
	                    _3474.y = _3483.y;
	                    vec3 _3488 = normalize(_3474);
	                    vec3 _1041 = _3488;
	                    float _3489 = _3488.z;
	                    float _1019;
	                    if (_3489 >= 0.0)
	                    {
	                        _1019 = 1.0;
	                    }
	                    else
	                    {
	                        _1019 = -1.0;
	                    }
	                    float _3496 = (-1.0) / (_1019 + _3489);
	                    float _3497 = _3488.x;
	                    vec3 _1020;
	                    vec3 _3505 = _1020;
	                    _3505.x = 1.0 + (((_1019 * _3497) * _3497) * _3496);
	                    _3505.y = _1019 * ((_3497 * _3488.y) * _3496);
	                    _3505.z = (-_1019) * _3497;
	                    _1020 = _3505;
	                    float _3513 = float((g_Vertices_3[_71]._member0[_3451] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3519 = (_3505 * cos(_3513)) + (cross(_3488, _3505) * sin(_3513));
	                    vec4 _3521 = _1042;
	                    _3521.x = _3519.x;
	                    _3521.y = _3519.y;
	                    _3521.z = _3519.z;
	                    _1042 = _3521;
	                    float _1021;
	                    if ((g_Vertices_3[_71]._member0[_3451] & 1u) == 0u)
	                    {
	                        _1021 = -1.0;
	                    }
	                    else
	                    {
	                        _1021 = 1.0;
	                    }
	                    vec4 _3532 = _1042;
	                    _3532.w = _1021;
	                    _1042 = _3532;
	                    _1065[2] = _1041;
	                    _1066[2] = _3532;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _1065[0] = vec3(0.0);
	            _1065[1] = vec3(0.0);
	            _1065[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _1043 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _75 = uint(_1043[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _3855 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _1014 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _1015 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _3871 = (uvec3(uint(_1014[_3855])) * _1068) + uvec3(uint(_1015[_3855]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _3873 = _3871.x;
	            _1066[0] = vec4(g_Vertices_1[_75]._member0[_3873 / 4u], g_Vertices_1[_75]._member0[(_3873 + 4u) / 4u], g_Vertices_1[_75]._member0[(_3873 + 8u) / 4u], g_Vertices_1[_75]._member0[(_3873 + 12u) / 4u]);
	            uint _3891 = _3871.y;
	            _1066[1] = vec4(g_Vertices_1[_75]._member0[_3891 / 4u], g_Vertices_1[_75]._member0[(_3891 + 4u) / 4u], g_Vertices_1[_75]._member0[(_3891 + 8u) / 4u], g_Vertices_1[_75]._member0[(_3891 + 12u) / 4u]);
	            uint _3909 = _3871.z;
	            _1066[2] = vec4(g_Vertices_1[_75]._member0[_3909 / 4u], g_Vertices_1[_75]._member0[(_3909 + 4u) / 4u], g_Vertices_1[_75]._member0[(_3909 + 8u) / 4u], g_Vertices_1[_75]._member0[(_3909 + 12u) / 4u]);
	        }
	        else
	        {
	            _1066[0] = vec4(0.0);
	            _1066[1] = vec4(0.0);
	            _1066[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _1063 = 0;
	    for (;;)
	    {
	        if (!(_1063 < 3))
	        {
	            break;
	        }
	        vsInput[_1063].vNormalOs = _1065[_1063];
	        vsInput[_1063].vTangentUOs_flTangentVSign = _1066[_1063];
	        _1063++;
	        continue;
	    }
	    vec4 _1067[3];
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _1013 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _77 = uint(_1013[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _3968 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _1011 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1012 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3984 = (uvec3(uint(_1011[_3968])) * _1068) + uvec3(uint(_1012[_3968]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _4035 = _3984.x;
	            _1067[0] = vec4(g_Vertices_1[_77]._member0[_4035 / 4u], g_Vertices_1[_77]._member0[(_4035 + 4u) / 4u], g_Vertices_1[_77]._member0[(_4035 + 8u) / 4u], g_Vertices_1[_77]._member0[(_4035 + 12u) / 4u]);
	            uint _4053 = _3984.y;
	            _1067[1] = vec4(g_Vertices_1[_77]._member0[_4053 / 4u], g_Vertices_1[_77]._member0[(_4053 + 4u) / 4u], g_Vertices_1[_77]._member0[(_4053 + 8u) / 4u], g_Vertices_1[_77]._member0[(_4053 + 12u) / 4u]);
	            uint _4071 = _3984.z;
	            _1067[2] = vec4(g_Vertices_1[_77]._member0[_4071 / 4u], g_Vertices_1[_77]._member0[(_4071 + 4u) / 4u], g_Vertices_1[_77]._member0[(_4071 + 8u) / 4u], g_Vertices_1[_77]._member0[(_4071 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _3991 = _3984.x / 4u;
	            _1067[0] = vec4(uvec4(g_Vertices_3[_77]._member0[_3991] & 255u, (g_Vertices_3[_77]._member0[_3991] & 65280u) >> uint(8), (g_Vertices_3[_77]._member0[_3991] & 16711680u) >> uint(16), (g_Vertices_3[_77]._member0[_3991] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _4006 = _3984.y / 4u;
	            _1067[1] = vec4(uvec4(g_Vertices_3[_77]._member0[_4006] & 255u, (g_Vertices_3[_77]._member0[_4006] & 65280u) >> uint(8), (g_Vertices_3[_77]._member0[_4006] & 16711680u) >> uint(16), (g_Vertices_3[_77]._member0[_4006] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _4021 = _3984.z / 4u;
	            _1067[2] = vec4(uvec4(g_Vertices_3[_77]._member0[_4021] & 255u, (g_Vertices_3[_77]._member0[_4021] & 65280u) >> uint(8), (g_Vertices_3[_77]._member0[_4021] & 16711680u) >> uint(16), (g_Vertices_3[_77]._member0[_4021] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _1067[0] = vec4(0.0);
	        _1067[1] = vec4(0.0);
	        _1067[2] = vec4(0.0);
	    }
	    _1063 = 0;
	    for (;;)
	    {
	        if (!(_1063 < 3))
	        {
	            break;
	        }
	        vsInput[_1063].vBlendColorTint = _1067[_1063];
	        _1063++;
	        continue;
	    }
	    vec4 _1070[3];
	    _1070[0] = vec4(0.0);
	    _1070[1] = vec4(0.0);
	    _1070[2] = vec4(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _1010 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _80 = uint(_1010[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _4126 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _1008 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1009 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _4142 = (uvec3(uint(_1008[_4126])) * _1068) + uvec3(uint(_1009[_4126]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _4192 = _4142.x;
	            _1070[0] = vec4(g_Vertices_1[_80]._member0[_4192 / 4u], g_Vertices_1[_80]._member0[(_4192 + 4u) / 4u], g_Vertices_1[_80]._member0[(_4192 + 8u) / 4u], g_Vertices_1[_80]._member0[(_4192 + 12u) / 4u]);
	            uint _4209 = _4142.y;
	            _1070[1] = vec4(g_Vertices_1[_80]._member0[_4209 / 4u], g_Vertices_1[_80]._member0[(_4209 + 4u) / 4u], g_Vertices_1[_80]._member0[(_4209 + 8u) / 4u], g_Vertices_1[_80]._member0[(_4209 + 12u) / 4u]);
	            uint _4226 = _4142.z;
	            _1070[2] = vec4(g_Vertices_1[_80]._member0[_4226 / 4u], g_Vertices_1[_80]._member0[(_4226 + 4u) / 4u], g_Vertices_1[_80]._member0[(_4226 + 8u) / 4u], g_Vertices_1[_80]._member0[(_4226 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _4151 = _4142.x / 4u;
	                _1070[0] = vec4(uvec4(g_Vertices_3[_80]._member0[_4151] & 255u, (g_Vertices_3[_80]._member0[_4151] & 65280u) >> uint(8), (g_Vertices_3[_80]._member0[_4151] & 16711680u) >> uint(16), (g_Vertices_3[_80]._member0[_4151] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _4165 = _4142.y / 4u;
	                _1070[1] = vec4(uvec4(g_Vertices_3[_80]._member0[_4165] & 255u, (g_Vertices_3[_80]._member0[_4165] & 65280u) >> uint(8), (g_Vertices_3[_80]._member0[_4165] & 16711680u) >> uint(16), (g_Vertices_3[_80]._member0[_4165] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _4179 = _4142.z / 4u;
	                _1070[2] = vec4(uvec4(g_Vertices_3[_80]._member0[_4179] & 255u, (g_Vertices_3[_80]._member0[_4179] & 65280u) >> uint(8), (g_Vertices_3[_80]._member0[_4179] & 16711680u) >> uint(16), (g_Vertices_3[_80]._member0[_4179] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _1071 = 0;
	    for (;;)
	    {
	        if (!(_1071 < 3))
	        {
	            break;
	        }
	        vsInput[_1071].vColorBlendValues = _1070[_1071];
	        _1071++;
	        continue;
	    }
	    vec2 _742 = vsInput[0].vTexCoord;
	    vec2 _741 = vsInput[0].vTexCoord2;
	    vec4 _740 = vsInput[0].vBlendColorTint;
	    vec4 _739 = vsInput[0].vColorBlendValues;
	    vec3 _1005 = vsInput[0].vNormalOs;
	    vec4 _1006;
	    vec4 _4272 = _1006;
	    _4272.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _4272.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _4272.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _4272.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _1006 = _4272;
	    PackedRtxInstanceData_t_natural_logical _4285;
	    _4285.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _4285.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _4285.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _4285.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _4285.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _4285.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _4285._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _4285._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _4296 = vec4(uvec4(_4285.nSrgbColor & 255u, (_4285.nSrgbColor & 65280u) >> uint(8), (_4285.nSrgbColor & 16711680u) >> uint(16), (_4285.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _1004 = _4296;
	    vec3 _4297 = _4296.xyz;
	    vec3 _4298 = _4297 * vec3(0.077399380505084991455078125);
	    vec3 _4301 = pow((_4297 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _1001;
	    if (_4296.x <= 0.040449999272823333740234375)
	    {
	        _1001 = _4298.x;
	    }
	    else
	    {
	        _1001 = _4301.x;
	    }
	    float _1002;
	    if (_4296.y <= 0.040449999272823333740234375)
	    {
	        _1002 = _4298.y;
	    }
	    else
	    {
	        _1002 = _4301.y;
	    }
	    float _1003;
	    if (_4296.z <= 0.040449999272823333740234375)
	    {
	        _1003 = _4298.z;
	    }
	    else
	    {
	        _1003 = _4301.z;
	    }
	    vec3 _4326 = vec3(_1001, _1002, _1003);
	    vec4 _4328 = _1004;
	    _4328.x = _4326.x;
	    _4328.y = _4326.y;
	    _4328.z = _4326.z;
	    _1004 = _4328;
	    vec4 _752;
	    vec4 _4335 = _752;
	    _4335.x = _4328.x;
	    _4335.y = _4328.y;
	    _4335.z = _4328.z;
	    _4335.w = _4328.w;
	    _752 = _4335;
	    mat3x4 _4346 = transpose(gl_WorldToObjectEXT);
	    mat3 _1000;
	    mat3 _4349 = _1000;
	    _4349[0] = _4346[0].xyz;
	    _4349[1] = _4346[1].xyz;
	    _4349[2] = _4346[2].xyz;
	    _1000 = _4349;
	    vec3 _4358 = normalize(_4349 * _1005.xyz);
	    vec3 _753;
	    vec3 _4360 = _753;
	    _4360.x = _4358.x;
	    _4360.y = _4358.y;
	    _4360.z = _4358.z;
	    _753 = _4360;
	    mat3x4 _4372 = transpose(gl_WorldToObjectEXT);
	    mat3 _999;
	    mat3 _4375 = _999;
	    _4375[0] = _4372[0].xyz;
	    _4375[1] = _4372[1].xyz;
	    _4375[2] = _4372[2].xyz;
	    _999 = _4375;
	    vec3 _4384 = normalize(_4375 * _1006.xyz);
	    vec4 _751;
	    vec4 _4386 = _751;
	    _4386.x = _4384.x;
	    _4386.y = _4384.y;
	    _4386.z = _4384.z;
	    _4386.w = _1006.w;
	    _751 = _4386;
	    vec4 _4395 = _742.xyxy;
	    _4395.z = _741.x;
	    _4395.w = _741.y;
	    vec4 _754;
	    vec4 _755;
	    vec4 _750 = _755;
	    vec4 _749 = _754;
	    vec3 _748 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _747 = _4360;
	    vec4 _746 = _4395;
	    vec4 _745 = _4335;
	    vec4 _744 = _4386;
	    vec2 _1007;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _1007 = _4395.zw;
	        }
	        else
	        {
	            _1007 = _4395.xy;
	        }
	        vec4 _4418 = _746;
	        _4418.x = _1007.x;
	        _4418.y = _1007.y;
	        vec4 _4437 = _4418;
	        _4437.x = dot(_4418.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _4437.y = dot(_4418.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _746 = _4437;
	    }
	    if (_g_rtx_material_data_.g_nUVSet2 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet2 == 2)
	        {
	            _1007 = _4395.zw;
	        }
	        else
	        {
	            _1007 = _4395.xy;
	        }
	        vec4 _4453 = _746;
	        _4453.z = _1007.x;
	        _4453.w = _1007.y;
	        vec4 _4472 = _4453;
	        _4472.z = dot(_4453.zw, _g_rtx_material_data_.g_vTexCoordXform0_2.xy) + _g_rtx_material_data_.g_vTexCoordXform0_2.w;
	        _4472.w = dot(_4453.zw, _g_rtx_material_data_.g_vTexCoordXform1_2.xy) + _g_rtx_material_data_.g_vTexCoordXform1_2.w;
	        _746 = _4472;
	    }
	    vec4 _4475 = _745;
	    vec4 _4477 = _749;
	    _4477.x = _4475.x;
	    _4477.y = _4475.y;
	    _4477.z = _4475.z;
	    _4477.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_4477.x, min(_4477.y, _4477.z)));
	    _749 = _4477;
	    _4475.x = _g_rtx_material_data_.g_vColorTint.x;
	    _4475.y = _g_rtx_material_data_.g_vColorTint.y;
	    _4475.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _4506 = _4475.xyz * mix(vec3(1.0), _740.xyz, vec3(_740.w));
	    vec4 _4508 = _4475;
	    _4508.x = _4506.x;
	    _4508.y = _4506.y;
	    _4508.z = _4506.z;
	    _745 = _4508;
	    vec4 _4515 = _750;
	    _4515.x = _739.x;
	    _4515.y = _739.y;
	    _4515.z = _739.z;
	    _4515.w = _739.w;
	    _750 = _4515;
	    vec4 _719 = _4515;
	    vec4 _718 = _4477;
	    vec3 _717 = _748;
	    vec3 _716 = _747;
	    vec4 _715 = _746;
	    vec4 _714 = _4508;
	    vec4 _713 = _744;
	    vec2 _738 = vsInput[1].vTexCoord;
	    vec2 _737 = vsInput[1].vTexCoord2;
	    vec4 _736 = vsInput[1].vBlendColorTint;
	    vec4 _735 = vsInput[1].vColorBlendValues;
	    vec3 _996 = vsInput[1].vNormalOs;
	    vec4 _997;
	    vec4 _4537 = _997;
	    _4537.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _4537.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _4537.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _4537.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _997 = _4537;
	    PackedRtxInstanceData_t_natural_logical _4550;
	    _4550.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _4550.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _4550.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _4550.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _4550.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _4550.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _4550._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _4550._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _4561 = vec4(uvec4(_4550.nSrgbColor & 255u, (_4550.nSrgbColor & 65280u) >> uint(8), (_4550.nSrgbColor & 16711680u) >> uint(16), (_4550.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _995 = _4561;
	    vec3 _4562 = _4561.xyz;
	    vec3 _4563 = _4562 * vec3(0.077399380505084991455078125);
	    vec3 _4566 = pow((_4562 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _992;
	    if (_4561.x <= 0.040449999272823333740234375)
	    {
	        _992 = _4563.x;
	    }
	    else
	    {
	        _992 = _4566.x;
	    }
	    float _993;
	    if (_4561.y <= 0.040449999272823333740234375)
	    {
	        _993 = _4563.y;
	    }
	    else
	    {
	        _993 = _4566.y;
	    }
	    float _994;
	    if (_4561.z <= 0.040449999272823333740234375)
	    {
	        _994 = _4563.z;
	    }
	    else
	    {
	        _994 = _4566.z;
	    }
	    vec3 _4591 = vec3(_992, _993, _994);
	    vec4 _4593 = _995;
	    _4593.x = _4591.x;
	    _4593.y = _4591.y;
	    _4593.z = _4591.z;
	    _995 = _4593;
	    vec4 _764;
	    vec4 _4600 = _764;
	    _4600.x = _4593.x;
	    _4600.y = _4593.y;
	    _4600.z = _4593.z;
	    _4600.w = _4593.w;
	    _764 = _4600;
	    mat3x4 _4611 = transpose(gl_WorldToObjectEXT);
	    mat3 _991;
	    mat3 _4614 = _991;
	    _4614[0] = _4611[0].xyz;
	    _4614[1] = _4611[1].xyz;
	    _4614[2] = _4611[2].xyz;
	    _991 = _4614;
	    vec3 _4623 = normalize(_4614 * _996.xyz);
	    vec3 _765;
	    vec3 _4625 = _765;
	    _4625.x = _4623.x;
	    _4625.y = _4623.y;
	    _4625.z = _4623.z;
	    _765 = _4625;
	    mat3x4 _4637 = transpose(gl_WorldToObjectEXT);
	    mat3 _990;
	    mat3 _4640 = _990;
	    _4640[0] = _4637[0].xyz;
	    _4640[1] = _4637[1].xyz;
	    _4640[2] = _4637[2].xyz;
	    _990 = _4640;
	    vec3 _4649 = normalize(_4640 * _997.xyz);
	    vec4 _763;
	    vec4 _4651 = _763;
	    _4651.x = _4649.x;
	    _4651.y = _4649.y;
	    _4651.z = _4649.z;
	    _4651.w = _997.w;
	    _763 = _4651;
	    vec4 _4660 = _738.xyxy;
	    _4660.z = _737.x;
	    _4660.w = _737.y;
	    vec4 _766;
	    vec4 _767;
	    vec4 _762 = _767;
	    vec4 _761 = _766;
	    vec3 _760 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _759 = _4625;
	    vec4 _758 = _4660;
	    vec4 _757 = _4600;
	    vec4 _756 = _4651;
	    vec2 _998;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _998 = _4660.zw;
	        }
	        else
	        {
	            _998 = _4660.xy;
	        }
	        vec4 _4683 = _758;
	        _4683.x = _998.x;
	        _4683.y = _998.y;
	        vec4 _4702 = _4683;
	        _4702.x = dot(_4683.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _4702.y = dot(_4683.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _758 = _4702;
	    }
	    if (_g_rtx_material_data_.g_nUVSet2 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet2 == 2)
	        {
	            _998 = _4660.zw;
	        }
	        else
	        {
	            _998 = _4660.xy;
	        }
	        vec4 _4718 = _758;
	        _4718.z = _998.x;
	        _4718.w = _998.y;
	        vec4 _4737 = _4718;
	        _4737.z = dot(_4718.zw, _g_rtx_material_data_.g_vTexCoordXform0_2.xy) + _g_rtx_material_data_.g_vTexCoordXform0_2.w;
	        _4737.w = dot(_4718.zw, _g_rtx_material_data_.g_vTexCoordXform1_2.xy) + _g_rtx_material_data_.g_vTexCoordXform1_2.w;
	        _758 = _4737;
	    }
	    vec4 _4740 = _757;
	    vec4 _4742 = _761;
	    _4742.x = _4740.x;
	    _4742.y = _4740.y;
	    _4742.z = _4740.z;
	    _4742.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_4742.x, min(_4742.y, _4742.z)));
	    _761 = _4742;
	    _4740.x = _g_rtx_material_data_.g_vColorTint.x;
	    _4740.y = _g_rtx_material_data_.g_vColorTint.y;
	    _4740.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _4771 = _4740.xyz * mix(vec3(1.0), _736.xyz, vec3(_736.w));
	    vec4 _4773 = _4740;
	    _4773.x = _4771.x;
	    _4773.y = _4771.y;
	    _4773.z = _4771.z;
	    _757 = _4773;
	    vec4 _4780 = _762;
	    _4780.x = _735.x;
	    _4780.y = _735.y;
	    _4780.z = _735.z;
	    _4780.w = _735.w;
	    _762 = _4780;
	    vec4 _712 = _4780;
	    vec4 _711 = _4742;
	    vec3 _710 = _760;
	    vec3 _709 = _759;
	    vec4 _708 = _758;
	    vec4 _707 = _4773;
	    vec4 _706 = _756;
	    vec2 _734 = vsInput[2].vTexCoord;
	    vec2 _733 = vsInput[2].vTexCoord2;
	    vec4 _732 = vsInput[2].vBlendColorTint;
	    vec4 _731 = vsInput[2].vColorBlendValues;
	    vec3 _987 = vsInput[2].vNormalOs;
	    vec4 _988;
	    vec4 _4802 = _988;
	    _4802.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _4802.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _4802.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _4802.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _988 = _4802;
	    PackedRtxInstanceData_t_natural_logical _4815;
	    _4815.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _4815.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _4815.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _4815.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _4815.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _4815.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _4815._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _4815._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _4826 = vec4(uvec4(_4815.nSrgbColor & 255u, (_4815.nSrgbColor & 65280u) >> uint(8), (_4815.nSrgbColor & 16711680u) >> uint(16), (_4815.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _986 = _4826;
	    vec3 _4827 = _4826.xyz;
	    vec3 _4828 = _4827 * vec3(0.077399380505084991455078125);
	    vec3 _4831 = pow((_4827 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _983;
	    if (_4826.x <= 0.040449999272823333740234375)
	    {
	        _983 = _4828.x;
	    }
	    else
	    {
	        _983 = _4831.x;
	    }
	    float _984;
	    if (_4826.y <= 0.040449999272823333740234375)
	    {
	        _984 = _4828.y;
	    }
	    else
	    {
	        _984 = _4831.y;
	    }
	    float _985;
	    if (_4826.z <= 0.040449999272823333740234375)
	    {
	        _985 = _4828.z;
	    }
	    else
	    {
	        _985 = _4831.z;
	    }
	    vec3 _4856 = vec3(_983, _984, _985);
	    vec4 _4858 = _986;
	    _4858.x = _4856.x;
	    _4858.y = _4856.y;
	    _4858.z = _4856.z;
	    _986 = _4858;
	    vec4 _776;
	    vec4 _4865 = _776;
	    _4865.x = _4858.x;
	    _4865.y = _4858.y;
	    _4865.z = _4858.z;
	    _4865.w = _4858.w;
	    _776 = _4865;
	    mat3x4 _4876 = transpose(gl_WorldToObjectEXT);
	    mat3 _982;
	    mat3 _4879 = _982;
	    _4879[0] = _4876[0].xyz;
	    _4879[1] = _4876[1].xyz;
	    _4879[2] = _4876[2].xyz;
	    _982 = _4879;
	    vec3 _4888 = normalize(_4879 * _987.xyz);
	    vec3 _777;
	    vec3 _4890 = _777;
	    _4890.x = _4888.x;
	    _4890.y = _4888.y;
	    _4890.z = _4888.z;
	    _777 = _4890;
	    mat3x4 _4902 = transpose(gl_WorldToObjectEXT);
	    mat3 _981;
	    mat3 _4905 = _981;
	    _4905[0] = _4902[0].xyz;
	    _4905[1] = _4902[1].xyz;
	    _4905[2] = _4902[2].xyz;
	    _981 = _4905;
	    vec3 _4914 = normalize(_4905 * _988.xyz);
	    vec4 _775;
	    vec4 _4916 = _775;
	    _4916.x = _4914.x;
	    _4916.y = _4914.y;
	    _4916.z = _4914.z;
	    _4916.w = _988.w;
	    _775 = _4916;
	    vec4 _4925 = _734.xyxy;
	    _4925.z = _733.x;
	    _4925.w = _733.y;
	    vec4 _778;
	    vec4 _779;
	    vec4 _774 = _779;
	    vec4 _773 = _778;
	    vec3 _772 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _771 = _4890;
	    vec4 _770 = _4925;
	    vec4 _769 = _4865;
	    vec4 _768 = _4916;
	    vec2 _989;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _989 = _4925.zw;
	        }
	        else
	        {
	            _989 = _4925.xy;
	        }
	        vec4 _4948 = _770;
	        _4948.x = _989.x;
	        _4948.y = _989.y;
	        vec4 _4967 = _4948;
	        _4967.x = dot(_4948.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _4967.y = dot(_4948.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _770 = _4967;
	    }
	    if (_g_rtx_material_data_.g_nUVSet2 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet2 == 2)
	        {
	            _989 = _4925.zw;
	        }
	        else
	        {
	            _989 = _4925.xy;
	        }
	        vec4 _4983 = _770;
	        _4983.z = _989.x;
	        _4983.w = _989.y;
	        vec4 _5002 = _4983;
	        _5002.z = dot(_4983.zw, _g_rtx_material_data_.g_vTexCoordXform0_2.xy) + _g_rtx_material_data_.g_vTexCoordXform0_2.w;
	        _5002.w = dot(_4983.zw, _g_rtx_material_data_.g_vTexCoordXform1_2.xy) + _g_rtx_material_data_.g_vTexCoordXform1_2.w;
	        _770 = _5002;
	    }
	    vec4 _5005 = _769;
	    vec4 _5007 = _773;
	    _5007.x = _5005.x;
	    _5007.y = _5005.y;
	    _5007.z = _5005.z;
	    _5007.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_5007.x, min(_5007.y, _5007.z)));
	    _773 = _5007;
	    _5005.x = _g_rtx_material_data_.g_vColorTint.x;
	    _5005.y = _g_rtx_material_data_.g_vColorTint.y;
	    _5005.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _5036 = _5005.xyz * mix(vec3(1.0), _732.xyz, vec3(_732.w));
	    vec4 _5038 = _5005;
	    _5038.x = _5036.x;
	    _5038.y = _5036.y;
	    _5038.z = _5036.z;
	    _769 = _5038;
	    vec4 _5045 = _774;
	    _5045.x = _731.x;
	    _5045.y = _731.y;
	    _5045.z = _731.z;
	    _5045.w = _731.w;
	    _774 = _5045;
	    vec3 _705 = _772;
	    vec3 _704 = _771;
	    vec3 _5081 = ((_716 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_709 * attrs.barycentrics.x)) + (_771 * attrs.barycentrics.y);
	    bool _5087 = gl_HitKindEXT == 254u;
	    vec3 _780;
	    vec4 _5124 = ((_719 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_712 * attrs.barycentrics.x)) + (_5045 * attrs.barycentrics.y);
	    vec4 _730 = _5124;
	    vec4 _729 = ((_718 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_711 * attrs.barycentrics.x)) + (_5007 * attrs.barycentrics.y);
	    vec3 _728 = _5081;
	    vec4 _727 = ((_715 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_708 * attrs.barycentrics.x)) + (_770 * attrs.barycentrics.y);
	    vec4 _726 = ((_714 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_707 * attrs.barycentrics.x)) + (_5038 * attrs.barycentrics.y);
	    vec4 _725 = ((_713 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_706 * attrs.barycentrics.x)) + (_768 * attrs.barycentrics.y);
	    bool _724 = _5087;
	    float _965 = clamp((_5124.x * 1.10000002384185791015625) - 0.0500000007450580596923828125, 0.0, 1.0);
	    vec3 _844 = _780;
	    vec3 _843 = normalize(cross(_710 - _717, _772 - _717));
	    bool _842 = _5087;
	    vec3 _869 = vec3(0.5);
	    vec2 _868 = vec2(0.5);
	    float _867 = 0.0;
	    float _866 = 1.0;
	    vec3 _865 = vec3(0.0);
	    float _864 = 0.039999999105930328369140625;
	    vec3 _863 = vec3(0.0);
	    float _862 = 0.0;
	    vec3 _861 = vec3(0.0);
	    vec3 _859 = vec3(1.0);
	    bool _858 = false;
	    vec3 _5138 = _5081.xyz;
	    vec3 _860 = _5138;
	    if (dot(_5138, _5138) >= 1.0099999904632568359375)
	    {
	        _860 = _844.xyz;
	    }
	    _864 = _g_rtx_material_data_.g_flReflectance;
	    _859 = _843;
	    bool _963;
	    if (_g_rtx_material_data_.g_bRenderBackfaceNormals)
	    {
	        _963 = !_g_rtx_material_data_.g_bDontFlipBackfaceNormals;
	    }
	    else
	    {
	        _963 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_963)
	    {
	        float _964;
	        if (_842)
	        {
	            _964 = 1.0;
	        }
	        else
	        {
	            _964 = -1.0;
	        }
	        _860 *= _964;
	        if (_842)
	        {
	            _964 = 1.0;
	        }
	        else
	        {
	            _964 = -1.0;
	        }
	        _859 *= _964;
	        _858 = !_842;
	    }
	    vec3 _5172 = _860;
	    vec3 _5173 = normalize(_5172);
	    _860 = _5173;
	    vec3 _857 = _5173;
	    vec3 _856 = _869;
	    vec2 _855 = _868;
	    float _854 = _867;
	    float _853 = _866;
	    vec3 _852 = _865;
	    float _851 = _864;
	    vec3 _850 = _863;
	    float _849 = _862;
	    vec3 _848 = _861;
	    vec3 _847 = _5173;
	    vec3 _846 = _859;
	    bool _845 = _858;
	    vec2 _841 = vec2(0.0);
	    vec2 _840 = vec2(0.0);
	    vec2 _839 = vec2(0.0);
	    vec2 _838 = vec2(0.0);
	    vec2 _837 = vec2(0.0);
	    vec2 _836 = vec2(0.0);
	    vec2 _835 = vec2(0.0);
	    ivec2 _834 = ivec2(0);
	    ivec2 _833 = ivec2(0);
	    if (_g_rtx_material_data_.bBiplanarUsedAny)
	    {
	        vec3 _5191 = abs(_847);
	        vec3 _958 = _5191;
	        float _5192 = _5191.x;
	        float _5193 = _5191.y;
	        bool _959;
	        if (_5192 > _5193)
	        {
	            _959 = _5192 > _5191.z;
	        }
	        else
	        {
	            _959 = false;
	        }
	        ivec3 _960;
	        if (_959)
	        {
	            _960 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5193 > _5191.z)
	            {
	                _960 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _960 = ivec3(2, 0, 1);
	            }
	        }
	        if (_5192 < _5193)
	        {
	            _959 = _5192 < _5191.z;
	        }
	        else
	        {
	            _959 = false;
	        }
	        ivec3 _961;
	        if (_959)
	        {
	            _961 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5193 < _5191.z)
	            {
	                _961 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _961 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _5227 = (ivec3(3) - _961) - _960;
	        ivec2 _962;
	        if (_960.x == 1)
	        {
	            _962 = _960.zy;
	        }
	        else
	        {
	            _962 = _960.yz;
	        }
	        ivec2 _5239 = _834;
	        _5239.x = _962.x;
	        _5239.y = _962.y;
	        _834 = _5239;
	        int _5243 = _5227.x;
	        if (_5243 == 1)
	        {
	            _962 = _5227.zy;
	        }
	        else
	        {
	            _962 = _5227.yz;
	        }
	        ivec2 _5252 = _833;
	        _5252.x = _962.x;
	        _5252.y = _962.y;
	        _833 = _5252;
	        vec2 _5263 = clamp((vec2(_958[_960.x], _958[_5243]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        _835 = _5263 / vec2(_5263.x + _5263.y);
	        vec3 _949 = _848 * _g_rtx_material_data_.g_vBiplanarTexCoordScale.xyz;
	        _841 = vec2(_949[_834.x], _949[_834.y]);
	        vec3 _950 = vec3(0.0);
	        vec3 _951 = vec3(0.0);
	        _839 = vec2(_950[_834.x], _951[_834.y]);
	        vec3 _952 = vec3(0.0);
	        vec3 _953 = vec3(0.0);
	        _838 = vec2(_952[_834.x], _953[_834.y]);
	        _840 = vec2(_949[_5252.x], _949[_5252.y]);
	        vec3 _954 = vec3(0.0);
	        vec3 _955 = vec3(0.0);
	        _837 = vec2(_954[_5252.x], _955[_5252.y]);
	        vec3 _956 = vec3(0.0);
	        vec3 _957 = vec3(0.0);
	        _836 = vec2(_956[_5252.x], _957[_5252.y]);
	    }
	    bool _966;
	    if (_g_rtx_material_data_.g_nUVSet2 > 1)
	    {
	        _966 = true;
	    }
	    else
	    {
	        _966 = _g_rtx_material_data_.g_nUVSet1 > 1;
	    }
	    bool _832 = _724;
	    bool _947;
	    if (_g_rtx_material_data_.g_bRenderBackfaceNormals)
	    {
	        _947 = !_g_rtx_material_data_.g_bDontFlipBackfaceNormals;
	    }
	    else
	    {
	        _947 = false;
	    }
	    if (_947)
	    {
	        float _948;
	        if (_832)
	        {
	            _948 = 1.0;
	        }
	        else
	        {
	            _948 = -1.0;
	        }
	        _947 = _948 < 0.0;
	    }
	    else
	    {
	        _947 = false;
	    }
	    vec3 _873 = vec3(0.0);
	    vec3 _872 = vec3(0.0);
	    float _945;
	    if (_725.w > 0.0)
	    {
	        _945 = 1.0;
	    }
	    else
	    {
	        _945 = -1.0;
	    }
	    float _5359 = 1.0 / length(_728);
	    vec3 _874 = _728 * _5359;
	    vec3 _723 = _725.xyz * _5359;
	    vec3 _722 = (cross(_728, _725.xyz) * _945) * _5359;
	    if (_947)
	    {
	        _874 *= (-1.0);
	    }
	    vec3 _871 = _873 - (_874 * dot(_873, _874));
	    vec3 _870 = _872 - (_874 * dot(_872, _874));
	    int _946;
	    if (dot(_872, cross(_874, _873)) < 0.0)
	    {
	        _946 = -1;
	    }
	    else
	    {
	        _946 = 1;
	    }
	    vec3 _915 = _874;
	    vec3 _914 = _871;
	    vec3 _913 = _870;
	    float _912 = float(_946);
	    vec3 _830;
	    vec3 _831;
	    if (_966)
	    {
	        float _944;
	        if (false)
	        {
	            _944 = -1.0;
	        }
	        else
	        {
	            _944 = 1.0;
	        }
	        vec2 _5396 = vec2(0.0, -0.0) * _944;
	        vec3 _875 = (_914 * _5396.x) + (_913 * _5396.y);
	        float _5404 = abs(0.0);
	        if (_5404 > 0.0)
	        {
	            _875 = normalize(_875);
	        }
	        _831 = _875;
	        _830 = cross(_915, _875) * (_944 * _912);
	    }
	    float _967 = 0.0;
	    float _969 = max(min(_730.w + _g_rtx_material_data_.g_flBlendSoftness2, 1.0), 9.9999997473787516355514526367188e-05);
	    vec3 _970 = vec3(0.0);
	    float _971 = _g_rtx_material_data_.g_flHeightMapZeroPoint1;
	    float _972 = _g_rtx_material_data_.g_flHeightMapScale1;
	    vec2 _973 = vec2(0.0);
	    vec4 _829 = vec4(0.0);
	    vec3 _828 = vec3(0.0);
	    vec4 _825 = vec4(0.0);
	    float _824 = 0.0;
	    float _823 = 0.0;
	    float _822 = 0.0;
	    float _821 = 0.0;
	    float _820 = 0.0;
	    float _819 = 0.0;
	    float _818 = 0.0;
	    vec3 _5430 = vec3(0.0);
	    _5430.x = _727.x;
	    _5430.y = _727.y;
	    vec3 _827 = _5430;
	    vec2 _826 = _g_rtx_material_data_.g_vTexCoordScale1.xy;
	    vec2 _882 = _841;
	    vec2 _881 = _840;
	    vec2 _880 = _839;
	    vec2 _879 = _838;
	    vec2 _878 = _837;
	    vec2 _877 = _836;
	    vec2 _876 = _835;
	    vec4 _943;
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        vec2 _5457 = _882;
	        vec2 _5458 = _5457 * _826;
	        _882 = _5458;
	        vec2 _5459 = _880;
	        vec2 _5460 = _5459 * _826;
	        _880 = _5460;
	        vec2 _5461 = _879;
	        vec2 _5462 = _5461 * _826;
	        _879 = _5462;
	        vec2 _5463 = _881;
	        vec2 _5464 = _5463 * _826;
	        _881 = _5464;
	        vec2 _5465 = _878;
	        vec2 _5466 = _5465 * _826;
	        _878 = _5466;
	        vec2 _5467 = _877;
	        vec2 _5468 = _5467 * _826;
	        _877 = _5468;
	        _943 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _5458.xy, _5460.xy, _5462.xy) * _876.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _5464.xy, _5466.xy, _5468.xy) * _876.y);
	    }
	    else
	    {
	        _943 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _827.xy, 0.0).xyzw;
	    }
	    _821 = _943.x;
	    _819 = _943.y;
	    _820 = _943.w;
	    _822 = _943.x;
	    SPIRV_CROSS_BRANCH
	    if (_g_rtx_material_data_.g_bWetnessUseHeightmapAdjustments)
	    {
	        _822 = max(0.0, ((_822 + 0.5) - _971) * _972);
	    }
	    float _5511 = _971;
	    float _5512 = _5511 + (_967 * 0.5);
	    _971 = _5512;
	    float _5514 = _972;
	    float _5515 = _5514 + _969;
	    _972 = _5515;
	    vec2 _5518 = _973;
	    _5518.x = (-_5512) * _5515;
	    _5518.y = (1.0 - _5512) * _5515;
	    _973 = _5518;
	    if (false)
	    {
	        float _5527 = _972;
	        float _5528 = _5527 - (_969 * 2.0);
	        _972 = _5528;
	        if (_5528 == 0.0)
	        {
	            _972 = 9.9999997473787516355514526367188e-05;
	        }
	    }
	    _823 = (_821 - _971) * _972;
	    vec3 _817 = _847;
	    vec3 _816 = _723;
	    vec3 _815 = _722;
	    vec3 _814 = _831;
	    vec3 _813 = _830;
	    vec2 _893 = _841;
	    vec2 _892 = _840;
	    vec2 _891 = _839;
	    vec2 _890 = _838;
	    vec2 _889 = _837;
	    vec2 _888 = _836;
	    vec2 _887 = _835;
	    ivec2 _886 = _834;
	    ivec2 _885 = _833;
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        _893 *= _826;
	        _891 *= _826;
	        _890 *= _826;
	        _892 *= _826;
	        _889 *= _826;
	        _888 *= _826;
	        _828 = _817;
	        if (true)
	        {
	            _829 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _893.xy, _891.xy, _890.xy) * _887.x;
	        }
	        if (true)
	        {
	            vec4 _5695 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _893.xy, _891.xy, _890.xy);
	            _818 = _5695.z * _887.x;
	            float _5700 = _5695.x;
	            float _5701 = _5695.y;
	            float _5703 = (_5700 + _5701) - 1.00392162799835205078125;
	            float _5704 = _5700 - _5701;
	            vec3 _5714 = normalize(vec3(vec2(_5703, _5704), (1.0 - abs(_5703)) - abs(_5704))).xyz * _887.x;
	            vec4 _5716;
	            _5716.x = _5714.x;
	            _5716.y = _5714.y;
	            vec4 _5720 = _5716;
	            _5720.z = _5714.z;
	            _828 = (_609[_886.x] * _5716.x) + (_613[_886.y] * _5716.y);
	        }
	        if (_887.y > 0.0)
	        {
	            if (true)
	            {
	                _829 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _892.xy, _889.xy, _888.xy) * _887.y);
	            }
	            if (true)
	            {
	                vec4 _5772 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _892.xy, _889.xy, _888.xy);
	                _818 += (_5772.z * _887.y);
	                float _5779 = _5772.x;
	                float _5780 = _5772.y;
	                float _5782 = (_5779 + _5780) - 1.00392162799835205078125;
	                float _5783 = _5779 - _5780;
	                vec3 _5793 = normalize(vec3(vec2(_5782, _5783), (1.0 - abs(_5782)) - abs(_5783))).xyz * _887.y;
	                vec4 _5795;
	                _5795.x = _5793.x;
	                _5795.y = _5793.y;
	                vec4 _5799 = _5795;
	                _5799.z = _5793.z;
	                _828 += ((_609[_885.x] * _5795.x) + (_613[_885.y] * _5795.y));
	            }
	        }
	        _828 = normalize(_828 + _817);
	    }
	    else
	    {
	        if (true)
	        {
	            _829 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _827.xy, _825.xy, _825.zw).xyzw;
	        }
	        if (true)
	        {
	            vec4 _5586 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _827.xy, _825.xy, _825.zw);
	            vec3 _5587 = _5586.xyz;
	            _818 = _5586.z;
	            float _5589 = _5586.x;
	            float _5590 = _5586.y;
	            float _5592 = (_5589 + _5590) - 1.00392162799835205078125;
	            float _5593 = _5589 - _5590;
	            vec3 _5600 = normalize(vec3(vec2(_5592, _5593), (1.0 - abs(_5592)) - abs(_5593)));
	            _5587.x = _5600.x;
	            _5587.y = _5600.y;
	            _5587.z = _5600.z;
	            vec3 _5613 = _5587;
	            _5613.x = dot(_5587.xy, _g_rtx_material_data_.g_vNormalXform_1.xy);
	            _5613.y = dot(_5587.xy, _g_rtx_material_data_.g_vNormalXform_1.zw);
	            vec3 _942 = _5613;
	            vec3 _883;
	            vec3 _884;
	            if (_g_rtx_material_data_.g_nUVSet1 > 1)
	            {
	                _884 = _814;
	                _883 = _813;
	            }
	            else
	            {
	                _884 = _816;
	                _883 = _815;
	            }
	            vec3 _5625 = abs(_942.xyz);
	            vec2 _5638 = (-vec2(_942.x, (-1.0) * _942.y)) / vec2(max(_5625.z, 0.0078125 * max(_5625.x, _5625.y)));
	            _828 = normalize(_915 - ((_884 * _5638.x) + (_883 * _5638.y)));
	        }
	    }
	    _824 = _829.w;
	    vec3 _812 = _847;
	    if (true)
	    {
	        _828 = normalize(mix(_812, _828, vec3(_g_rtx_material_data_.g_fTextureNormalContrast1)));
	        _818 = clamp(((_g_rtx_material_data_.g_fTextureRoughnessContrast1 * (_818 - 0.5)) + 0.5) * _g_rtx_material_data_.g_fTextureRoughnessBrightness1, 0.0, 1.0);
	    }
	    vec4 _811 = _729;
	    vec4 _937;
	    if (_g_rtx_material_data_.g_bAdjustBaseColor1)
	    {
	        _937 = vec4((vec4(_829.xyz, 1.0) * _g_rtx_material_data_.g_mTextureAdjust1).xyz, _829.w);
	    }
	    else
	    {
	        _937 = _829;
	    }
	    vec4 _5863 = _937;
	    float _5866 = _824;
	    float _5870 = clamp(mix(_g_rtx_material_data_.g_vAmbientOcclusionLevels1.x, _g_rtx_material_data_.g_vAmbientOcclusionLevels1.z, pow(_5866, _g_rtx_material_data_.g_vAmbientOcclusionLevels1.y)), 0.0, 1.0);
	    _824 = _5870;
	    float _5872 = _820;
	    float _5873 = _5872 * float(_g_rtx_material_data_.g_bMetalness1);
	    _820 = _5873;
	    float _5874 = _819;
	    float _5879 = clamp(((_g_rtx_material_data_.g_fTintMaskContrast1 * (_5874 - 0.5)) + 0.5) * _g_rtx_material_data_.g_fTintMaskBrightness1, 0.0, 1.0);
	    _819 = _5879;
	    vec3 _5883 = mix(_5863.xyz, vec4((vec4(_829.xyz, 1.0) * _g_rtx_material_data_.g_mTextureColorAdjust1).xyz, _698).xyz, vec3(_5879));
	    vec4 _5885 = _5863;
	    _5885.x = _5883.x;
	    _5885.y = _5883.y;
	    _5885.z = _5883.z;
	    float _5897 = dot(_5885.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _5900 = normalize(max(_811.xyz, vec3(0.001000000047497451305389404296875)));
	    vec4 _5919 = vec4(clamp(mix(_5885.xyz, (_5900 * min(_5897 / dot(_5900.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _5897) * max(_811.x, max(_811.y, _811.z)))).xyz, vec3((_811.w * _5879) * float(_g_rtx_material_data_.g_bModelTint1))), vec3(0.0), vec3(1.0)).xyz, _5885.w);
	    _829 = _5919;
	    _857 = _828.xyz;
	    _856 = _5919.xyz;
	    _853 = _5870;
	    vec2 _5925 = _855;
	    _5925.x = _818;
	    _855 = _5925;
	    _854 = _5873;
	    float _968 = _822;
	    _849 = _823;
	    float _974 = _g_rtx_material_data_.g_flHeightMapZeroPoint2;
	    float _975 = _g_rtx_material_data_.g_flHeightMapScale2;
	    vec2 _976 = vec2(0.0);
	    float _977 = 0.0;
	    float _978 = 1.0;
	    if (_g_rtx_material_data_.g_flColorOverlay2 == 0.0)
	    {
	        _966 = _g_rtx_material_data_.g_flColorReplace2 == 0.0;
	    }
	    else
	    {
	        _966 = false;
	    }
	    if (_966)
	    {
	        _966 = _g_rtx_material_data_.g_flAOCombine2 == 0.0;
	    }
	    else
	    {
	        _966 = false;
	    }
	    bool _979;
	    if (_966)
	    {
	        _979 = _g_rtx_material_data_.g_flAOReplace2 == 0.0;
	    }
	    else
	    {
	        _979 = false;
	    }
	    if (_g_rtx_material_data_.g_flNormalCombine2 == 0.0)
	    {
	        _966 = _g_rtx_material_data_.g_flNormalReplace2 == 0.0;
	    }
	    else
	    {
	        _966 = false;
	    }
	    if (_966)
	    {
	        _966 = _g_rtx_material_data_.g_flRoughnessCombine2 == 0.0;
	    }
	    else
	    {
	        _966 = false;
	    }
	    bool _980;
	    if (_966)
	    {
	        _980 = _g_rtx_material_data_.g_flRoughnessReplace2 == 0.0;
	    }
	    else
	    {
	        _980 = false;
	    }
	    vec4 _810 = vec4(0.0);
	    vec3 _809 = vec3(0.0);
	    vec3 _808 = vec3(0.0);
	    vec2 _807 = vec2(0.0);
	    vec4 _806 = vec4(0.0);
	    float _805 = 0.0;
	    float _804 = 0.0;
	    float _803 = 0.0;
	    float _802 = 0.0;
	    float _801 = 0.0;
	    float _800 = 0.0;
	    float _799 = 0.0;
	    vec3 _5982 = _808;
	    _5982.x = _727.z;
	    _5982.y = _727.w;
	    _808 = _5982;
	    _807 = _g_rtx_material_data_.g_vTexCoordScale2.xy;
	    vec2 _900 = _841;
	    vec2 _899 = _840;
	    vec2 _898 = _839;
	    vec2 _897 = _838;
	    vec2 _896 = _837;
	    vec2 _895 = _836;
	    vec2 _894 = _835;
	    vec4 _936;
	    if (_g_rtx_material_data_.g_nUVSet2 == 0)
	    {
	        vec2 _6010 = _900;
	        vec2 _6011 = _6010 * _807;
	        _900 = _6011;
	        vec2 _6012 = _898;
	        vec2 _6013 = _6012 * _807;
	        _898 = _6013;
	        vec2 _6014 = _897;
	        vec2 _6015 = _6014 * _807;
	        _897 = _6015;
	        vec2 _6016 = _899;
	        vec2 _6017 = _6016 * _807;
	        _899 = _6017;
	        vec2 _6018 = _896;
	        vec2 _6019 = _6018 * _807;
	        _896 = _6019;
	        vec2 _6020 = _895;
	        vec2 _6021 = _6020 * _807;
	        _895 = _6021;
	        _936 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _6011.xy, _6013.xy, _6015.xy) * _894.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _6017.xy, _6019.xy, _6021.xy) * _894.y);
	    }
	    else
	    {
	        _936 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _808.xy, 0.0).xyzw;
	    }
	    _802 = _936.x;
	    _800 = _936.y;
	    _801 = _936.w;
	    _803 = _936.x;
	    SPIRV_CROSS_BRANCH
	    if (_g_rtx_material_data_.g_bWetnessUseHeightmapAdjustments)
	    {
	        _803 = max(0.0, ((_803 + 0.5) - _974) * _975);
	    }
	    float _6064 = _974;
	    float _6065 = _6064 + (_967 * 0.5);
	    _974 = _6065;
	    float _6067 = _975;
	    float _6068 = _6067 + _969;
	    _975 = _6068;
	    vec2 _6071 = _976;
	    _6071.x = (-_6065) * _6068;
	    _6071.y = (1.0 - _6065) * _6068;
	    _976 = _6071;
	    if (true)
	    {
	        float _6080 = _975;
	        float _6081 = _6080 - (_969 * 2.0);
	        _975 = _6081;
	        if (_6081 == 0.0)
	        {
	            _975 = 9.9999997473787516355514526367188e-05;
	        }
	    }
	    _804 = (_802 - _974) * _975;
	    vec3 _798 = _857;
	    float _797 = _849;
	    vec3 _796 = _847;
	    SPIRV_CROSS_BRANCH
	    if (_g_rtx_material_data_.bBlendByFacingDirection2)
	    {
	        _965 *= clamp((((dot(_g_rtx_material_data_.g_vFacingDirection2.xyz, mix(_796.xyz, _798, vec3(_g_rtx_material_data_.g_vFacingDirectionMaskNormalMapStrength2)).xyz) - 1.0) + (_g_rtx_material_data_.g_flFacingDirectionMaskSpread2 * 2.0)) / (_g_rtx_material_data_.g_vFacingDirectionMaskSoftness2 * 2.0)) + 0.5, 0.0, 1.0);
	    }
	    float _6132 = _804 + mix((_973.x - _976.y) - _969, _973.y - _976.x, _965);
	    _978 = clamp((_6132 + _974) - _797, 0.0, 1.0);
	    float _6137 = max(_797, _6132);
	    if (true)
	    {
	        vec3 _6167 = _970;
	        _6167.x = _797;
	        _6167.y = _6132;
	        _970 = _6167;
	        vec2 _6175 = max((_6167.xy - vec2(_6137)) + vec2(_969), vec2(0.0));
	        _6175.x = _6175.x + 9.9999997473787516355514526367188e-05;
	        _977 = (_6175 / vec2(_6175.x + _6175.y)).y;
	    }
	    else
	    {
	        if (false)
	        {
	            vec3 _6143 = _970;
	            _6143.z = _6132;
	            _970 = _6143;
	            vec3 _6150 = max((_6143.xyz - vec3(_6137)) + vec3(_969), vec3(0.0));
	            _6150.x = _6150.x + 9.9999997473787516355514526367188e-05;
	            vec3 _6165;
	            _6165.z = (_6150.xyz / vec3((_6150.x + _6150.y) + _6150.z)).z;
	            _977 = _6165.z;
	        }
	    }
	    float _6185 = _977;
	    float _6190 = clamp((_6185 * mix(0.5, _802, _g_rtx_material_data_.g_flMaskWithHeight2)) * 2.0, 0.0, 1.0);
	    _977 = _6190;
	    bool _6191 = _6190 > 0.0500000007450580596923828125;
	    SPIRV_CROSS_BRANCH
	    if (_6191)
	    {
	        vec3 _795 = _847;
	        vec3 _794 = _723;
	        vec3 _793 = _722;
	        vec3 _792 = _831;
	        vec3 _791 = _830;
	        vec2 _911 = _841;
	        vec2 _910 = _840;
	        vec2 _909 = _839;
	        vec2 _908 = _838;
	        vec2 _907 = _837;
	        vec2 _906 = _836;
	        vec2 _905 = _835;
	        ivec2 _904 = _834;
	        ivec2 _903 = _833;
	        if (_g_rtx_material_data_.g_nUVSet2 == 0)
	        {
	            _911 *= _807;
	            _909 *= _807;
	            _908 *= _807;
	            _910 *= _807;
	            _907 *= _807;
	            _906 *= _807;
	            _809 = _795;
	            bool _6324 = !_979;
	            if (_6324)
	            {
	                _810 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _911.xy, _909.xy, _908.xy) * _905.x;
	            }
	            bool _6343 = !_980;
	            if (_6343)
	            {
	                vec4 _6358 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _911.xy, _909.xy, _908.xy);
	                _799 = _6358.z * _905.x;
	                float _6363 = _6358.x;
	                float _6364 = _6358.y;
	                float _6366 = (_6363 + _6364) - 1.00392162799835205078125;
	                float _6367 = _6363 - _6364;
	                vec3 _6377 = normalize(vec3(vec2(_6366, _6367), (1.0 - abs(_6366)) - abs(_6367))).xyz * _905.x;
	                vec4 _6379;
	                _6379.x = _6377.x;
	                _6379.y = _6377.y;
	                vec4 _6383 = _6379;
	                _6383.z = _6377.z;
	                _809 = (_609[_904.x] * _6379.x) + (_613[_904.y] * _6379.y);
	            }
	            if (_905.y > 0.0)
	            {
	                if (_6324)
	                {
	                    _810 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _910.xy, _907.xy, _906.xy) * _905.y);
	                }
	                if (_6343)
	                {
	                    vec4 _6435 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _910.xy, _907.xy, _906.xy);
	                    _799 += (_6435.z * _905.y);
	                    float _6442 = _6435.x;
	                    float _6443 = _6435.y;
	                    float _6445 = (_6442 + _6443) - 1.00392162799835205078125;
	                    float _6446 = _6442 - _6443;
	                    vec3 _6456 = normalize(vec3(vec2(_6445, _6446), (1.0 - abs(_6445)) - abs(_6446))).xyz * _905.y;
	                    vec4 _6458;
	                    _6458.x = _6456.x;
	                    _6458.y = _6456.y;
	                    vec4 _6462 = _6458;
	                    _6462.z = _6456.z;
	                    _809 += ((_609[_903.x] * _6458.x) + (_613[_903.y] * _6458.y));
	                }
	            }
	            _809 = normalize(_809 + _795);
	        }
	        else
	        {
	            if (!_979)
	            {
	                _810 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _808.xy, _806.xy, _806.zw).xyzw;
	            }
	            if (!_980)
	            {
	                vec4 _6247 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _808.xy, _806.xy, _806.zw);
	                vec3 _6248 = _6247.xyz;
	                _799 = _6247.z;
	                float _6250 = _6247.x;
	                float _6251 = _6247.y;
	                float _6253 = (_6250 + _6251) - 1.00392162799835205078125;
	                float _6254 = _6250 - _6251;
	                vec3 _6261 = normalize(vec3(vec2(_6253, _6254), (1.0 - abs(_6253)) - abs(_6254)));
	                _6248.x = _6261.x;
	                _6248.y = _6261.y;
	                _6248.z = _6261.z;
	                vec3 _6274 = _6248;
	                _6274.x = dot(_6248.xy, _g_rtx_material_data_.g_vNormalXform_2.xy);
	                _6274.y = dot(_6248.xy, _g_rtx_material_data_.g_vNormalXform_2.zw);
	                vec3 _935 = _6274;
	                vec3 _901;
	                vec3 _902;
	                if (_g_rtx_material_data_.g_nUVSet2 > 1)
	                {
	                    _902 = _792;
	                    _901 = _791;
	                }
	                else
	                {
	                    _902 = _794;
	                    _901 = _793;
	                }
	                vec3 _6286 = abs(_935.xyz);
	                vec2 _6299 = (-vec2(_935.x, (-1.0) * _935.y)) / vec2(max(_6286.z, 0.0078125 * max(_6286.x, _6286.y)));
	                _809 = normalize(_915 - ((_902 * _6299.x) + (_901 * _6299.y)));
	            }
	        }
	        _805 = _810.w;
	        vec3 _790 = _847;
	        if (!_980)
	        {
	            _809 = normalize(mix(_790, _809, vec3(_g_rtx_material_data_.g_fTextureNormalContrast2)));
	            _799 = clamp(((_g_rtx_material_data_.g_fTextureRoughnessContrast2 * (_799 - 0.5)) + 0.5) * _g_rtx_material_data_.g_fTextureRoughnessBrightness2, 0.0, 1.0);
	        }
	        vec4 _789 = _729;
	        vec4 _930;
	        if (_g_rtx_material_data_.g_bAdjustBaseColor2)
	        {
	            _930 = vec4((vec4(_810.xyz, 1.0) * _g_rtx_material_data_.g_mTextureAdjust2).xyz, _810.w);
	        }
	        else
	        {
	            _930 = _810;
	        }
	        vec4 _6528 = _930;
	        _805 = clamp(mix(_g_rtx_material_data_.g_vAmbientOcclusionLevels2.x, _g_rtx_material_data_.g_vAmbientOcclusionLevels2.z, pow(_805, _g_rtx_material_data_.g_vAmbientOcclusionLevels2.y)), 0.0, 1.0);
	        _801 *= float(_g_rtx_material_data_.g_bMetalness2);
	        float _6539 = _800;
	        float _6544 = clamp(((_g_rtx_material_data_.g_fTintMaskContrast2 * (_6539 - 0.5)) + 0.5) * _g_rtx_material_data_.g_fTintMaskBrightness2, 0.0, 1.0);
	        _800 = _6544;
	        vec3 _6548 = mix(_6528.xyz, vec4((vec4(_810.xyz, 1.0) * _g_rtx_material_data_.g_mTextureColorAdjust2).xyz, _698).xyz, vec3(_6544));
	        vec4 _6550 = _6528;
	        _6550.x = _6548.x;
	        _6550.y = _6548.y;
	        _6550.z = _6548.z;
	        float _6562 = dot(_6550.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        vec3 _6565 = normalize(max(_789.xyz, vec3(0.001000000047497451305389404296875)));
	        _810 = vec4(clamp(mix(_6550.xyz, (_6565 * min(_6562 / dot(_6565.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _6562) * max(_789.x, max(_789.y, _789.z)))).xyz, vec3((_789.w * _6544) * float(_g_rtx_material_data_.g_bModelTint2))), vec3(0.0), vec3(1.0)).xyz, _6550.w);
	    }
	    SPIRV_CROSS_BRANCH
	    if (_6191)
	    {
	        vec4 _788 = _810;
	        vec3 _787 = _809;
	        float _786 = _805;
	        float _785 = _804;
	        float _784 = _803;
	        float _783 = _801;
	        float _782 = _799;
	        if (!_979)
	        {
	            vec3 _6615 = _788.xyz * 12.9200000762939453125;
	            vec3 _6618 = (pow(_788.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	            float _927;
	            if (_788.x <= 0.003130800090730190277099609375)
	            {
	                _927 = _6615.x;
	            }
	            else
	            {
	                _927 = _6618.x;
	            }
	            float _928;
	            if (_788.y <= 0.003130800090730190277099609375)
	            {
	                _928 = _6615.y;
	            }
	            else
	            {
	                _928 = _6618.y;
	            }
	            float _929;
	            if (_788.z <= 0.003130800090730190277099609375)
	            {
	                _929 = _6615.z;
	            }
	            else
	            {
	                _929 = _6618.z;
	            }
	            _856 = mix(_856 * mix(vec3(1.0), vec3(_927, _928, _929) * 2.0, vec3(_977 * _g_rtx_material_data_.g_flColorOverlay2)), _788.xyz, vec3(_977 * _g_rtx_material_data_.g_flColorReplace2));
	            _853 = mix(_853 * mix(1.0, _786, _977 * _g_rtx_material_data_.g_flAOCombine2), _786, _977 * _g_rtx_material_data_.g_flAOReplace2);
	        }
	        if (!_980)
	        {
	            _857 = mix(mix(_857, normalize(mix(_847, (_857 + _787.xyz) * vec3(0.5), vec3(2.0))), vec3(_977 * _g_rtx_material_data_.g_flNormalCombine2)), _787.xyz, vec3((_977 * _978) * _g_rtx_material_data_.g_flNormalReplace2));
	            vec2 _6679 = _855;
	            _6679.x = _6679.x * (1.0 + ((((_782 - _6679.x) * 2.0) * _977) * _g_rtx_material_data_.g_flRoughnessCombine2));
	            _6679.x = mix(_6679.x, _782, _977 * _g_rtx_material_data_.g_flRoughnessReplace2);
	            _855 = _6679;
	        }
	        _854 = mix(_854 * mix(1.0, _783 * 2.0, _977 * _g_rtx_material_data_.g_flMetalnessCombine2), _783, _977 * _g_rtx_material_data_.g_flMetalnessReplace2);
	        _968 = mix(_968, _784, _977);
	        _849 = mix(_849, _785, _977);
	    }
	    float _6710 = saturate(1.0 - _977);
	    _856 *= mix(vec3(1.0), _726.xyz, vec3(clamp(clamp(((float(!_g_rtx_material_data_.g_bMaskVertexColor1) * _6710) + (float(!_g_rtx_material_data_.g_bMaskVertexColor2) * _977)) + ((_819 * _6710) + (_800 * _977)), 0.0, 1.0) * ((float(_g_rtx_material_data_.g_bVertexColorEnabled1) * _6710) + (float(_g_rtx_material_data_.g_bVertexColorEnabled2) * _977)), 0.0, 1.0)));
	    vec2 _6743 = _855;
	    vec2 _6745 = _6743;
	    _6745.x = _6743.x;
	    _6745.y = _6743.x;
	    _855 = _6745;
	    vec4 _781 = _730;
	    bool _924;
	    if (_g_rtx_material_data_.g_bWetness)
	    {
	        _924 = (_g_rtx_material_data_.g_fPuddleStrength + _g_rtx_material_data_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _924 = false;
	    }
	    if (_924)
	    {
	        _924 = _781.z > 0.0;
	    }
	    else
	    {
	        _924 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_924)
	    {
	        vec4 _925 = vec4(0.0, 0.0, 1.0, 0.0);
	        float _6777 = pow(max(0.0, _847.z), 32.0);
	        float _6783 = min(min(_781.z, 1.0), 1.0);
	        float _6785 = saturate(_6783 - 0.75);
	        float _6788 = _6783 + (4.0 * (_6785 * _6785));
	        float _6798 = saturate(_6788 * 20.0);
	        float _926;
	        SPIRV_CROSS_BRANCH
	        if (_g_rtx_material_data_.g_bPuddlesOnVerticalSurfaces)
	        {
	            vec4 _6815 = _925;
	            _6815.x = _847.x;
	            _6815.y = _847.y;
	            _6815.z = _847.z;
	            _925 = _6815;
	            _926 = max(0.0, _6788 - _g_rtx_material_data_.g_fWetEdgeSpread);
	        }
	        else
	        {
	            _926 = max(0.0, (_6788 * _6777) - _g_rtx_material_data_.g_fWetEdgeSpread);
	        }
	        float _6823 = max(0.001000000047497451305389404296875, _g_rtx_material_data_.g_fPuddleBlendSoftness);
	        float _6831 = smoothstep(_926 + _6823, _926 - (_781.w + (_6823 * 2.0)), _968) * _6798;
	        float _6834 = max((smoothstep(_6783, (_6788 - _g_rtx_material_data_.g_fWetEdgeSpread) - (0.20000000298023223876953125 * _6788), _968) * _g_rtx_material_data_.g_fWetEdgeStrength) * _6798, _6831) * _g_rtx_material_data_.g_fPuddleStrength;
	        float _6836 = (_6783 - 1.0) - _968;
	        float _6842 = (saturate(_6836 + _g_rtx_material_data_.g_fPuddleSedimentHeight) * _g_rtx_material_data_.g_fPuddleSedimentOpacity) * _6831;
	        _857 = mix(_857, _925.xyz, vec3(_6834 * _6842));
	        float _6862 = max(clamp(((clamp((((_6788 * 2.0) - (mix(0.5, 0.5, saturate(_6777 * 20.0)) * 0.5)) - (_968 * 0.5)) + 0.25, 0.0, 1.0) * _g_rtx_material_data_.g_fWetnessStrength) * _6798) + _6831, 0.0, 1.0), _6834);
	        vec2 _6866 = _855;
	        vec3 _6874 = mix(_856, pow(_856, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_856, vec3(0.25)) * (_6862 * _6866.x)) * 8.0, vec3(0.0), vec3(1.0)) * mix(_g_rtx_material_data_.g_flWetnessDarkeningStrength1, _g_rtx_material_data_.g_flWetnessDarkeningStrength2, _977 * _g_rtx_material_data_.g_flColorReplace2));
	        _856 = fma(mix((mix(_6874, _6874 * 0.5, vec3(saturate(_6831 * 1.5))) * mix(1.0, _853, _6834)) * mix(1.0, 1.0 - _6836, _6842), _g_rtx_material_data_.g_vPuddleSedimentColor, vec3(_6842 * _6834)), vec3(1.0), vec3(0.0));
	        _853 = mix(_853, 1.0, _6834);
	        vec2 _6897 = clamp(mix(_6866.xx, vec2(_g_rtx_material_data_.g_fPuddleRoughness), vec2(_6862)), vec2(0.0), vec2(1.0));
	        vec2 _6899 = _6866;
	        _6899.x = _6897.x;
	        _6899.y = _6897.y;
	        _855 = _6899;
	        _851 = mix(_851, 0.0350000001490116119384765625, _6862);
	    }
	    _853 = max(_853, 0.0);
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _846;
	    payload.vInterpolatedNormalWs = _847;
	    vec3 _922[3] = vec3[](_717, _710, _705);
	    vec3 _923[3] = vec3[](_716, _709, _704);
	    vec3 _6947 = ((_922[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_922[1] * attrs.barycentrics.x)) + (_922[2] * attrs.barycentrics.y);
	    vec3 _916[3];
	    _916[0] = _6947 - (_923[0] * dot(_6947 - _922[0], _923[0]));
	    _916[1] = _6947 - (_923[1] * dot(_6947 - _922[1], _923[1]));
	    _916[2] = _6947 - (_923[2] * dot(_6947 - _922[2], _923[2]));
	    vec3 _6987 = ((_916[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_916[1] * attrs.barycentrics.x)) + (_916[2] * attrs.barycentrics.y);
	    vec3 _917[3];
	    _917[0] = cross(_922[0] - _922[1], _846);
	    _917[1] = cross(_922[1] - _922[2], _846);
	    _917[2] = cross(_922[2] - _922[0], _846);
	    float _918 = dot(_6987 - _6947, _846);
	    vec3 _919 = _6987;
	    int _920 = 0;
	    for (;;)
	    {
	        bool _7003_ladder_break = false;
	        do
	        {
	            if (!(_920 < 3))
	            {
	                _7003_ladder_break = true;
	                break;
	            }
	            if (_918 > 0.00999999977648258209228515625)
	            {
	                _7003_ladder_break = true;
	                break;
	            }
	            if (dot(_917[_920], _917[_920]) == 0.0)
	            {
	                break;
	            }
	            _917[_920] = normalize(_917[_920]);
	            int _921 = 0;
	            for (;;)
	            {
	                if (!(_921 < 3))
	                {
	                    break;
	                }
	                vec3 _7041 = _923[_921] - (_917[_920] * dot(_917[_920], _923[_921]));
	                _916[_921] = _6947 - (_7041 * dot(_6947 - _922[_921], _7041));
	                _921++;
	                continue;
	            }
	            vec3 _7065 = ((_916[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_916[1] * attrs.barycentrics.x)) + (_916[2] * attrs.barycentrics.y);
	            _918 = dot(_7065 - _6947, _846);
	            _919 = _7065;
	            break;
	        } while(false);
	        if (_7003_ladder_break)
	        {
	            break;
	        }
	        _920++;
	        continue;
	    }
	    if (!(_918 > 0.00999999977648258209228515625))
	    {
	        _919 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _919;
	    payload.bFlippedNormal = _845;
	    f16vec3 _7078 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_7078, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _7078, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(_857);
	    payload.material.vAlbedo = f16vec3(_856);
	    payload.material.vEmissive = f16vec3(_852);
	    payload.material.flReflectance = float16_t(_851);
	    payload.material.flMetalness = float16_t(_854);
	    payload.material.flRoughness = float16_t(dot(_855, vec2(0.5)));
	    if (any(greaterThan(_850, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _7104 = f16vec3(_850);
	        payload.material.vMaterialBits.x = _7104.x;
	        payload.material.vMaterialBits.y = _7104.y;
	        payload.material.vMaterialBits.z = _7104.z;
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
	BoolAttribute(SupportsMaterialLayerSampling, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	FloatAttribute(_dummyMakeVisiblePropMaskBias1, g_flDetailPropMaskBias1);
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction1, g_flDetailPropPuddleReduction1);
	FloatAttribute(_dummyMakeVisiblePropMaskBias2, g_flDetailPropMaskBias2);
	FloatAttribute(_dummyMakeVisiblePropMaskSoftness2, g_flDetailPropMaskSoftness2);
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction2, g_flDetailPropPuddleReduction2);
	
	#if (S_SHARED_COLOR_OVERLAY == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || ((g_nUVSet3>0) && (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0)))) || ((g_nColorOverlayUVSet>0) && (((g_vOverlayTexCoordScale.x!=1) || (g_vOverlayTexCoordScale.y!=1)) || (g_flOverlayTexCoordRotation!=0)))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_ENABLE_LAYER_3 == 0)
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
	#if (S_BLEND_EFFECTS_3 == 1)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_DETAIL_NORMAL == 0)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_BLEND_EFFECTS_3 == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_SHARED_COLOR_OVERLAY == 0)
		BoolAttribute(HasTexcoordTransform, ((((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || ((g_nUVSet3>0) && (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0)))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_SHADER_QUALITY == 0)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	
	// Variant Attributes
	BoolAttribute(HasTexcoordTransform, (((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || 0);
	BoolAttribute(HasTexcoordTransform, ((((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || ((g_nUVSet2>0) && (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0)))) || ((g_nColorOverlayUVSet>0) && (((g_vOverlayTexCoordScale.x!=1) || (g_vOverlayTexCoordScale.y!=1)) || (g_flOverlayTexCoordRotation!=0)))) || 0);
}
