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
	// SPIR-V source (8588 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec4 _11323 = vec4(_Globals_.g_vColorTint, _23812.w * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
	    vec3 _14119 = _11323.xyz * mix(vec3(1.0), vColorBlendValues.xyz, vec3(vColorBlendValues.w));
	    vec4 _23714 = _11323;
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
	
	// Occlusion Culling
	float g_flOcclusionCullingBoundsScale < Default(1); Range(1, 100); UiType(Slider); UiGroup("Occlusion Culling"); UiVisibility(F_OCCLUSION_CULLING_BOUNDS_SCALE); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_MODE_DEPTH == 1)
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
	#endif
	#if (S_ALPHA_TEST == 1)
	#endif
	#if (S_SHADER_QUALITY == 1)
	#endif
	#if (S_BLEND_EFFECTS_2 == 1)
	#endif
	#if (S_BLEND_EFFECTS_3 == 1)
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 5 (name: g_vBiplanarTexCoordScale) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (86820 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	const vec3 _1370[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _183[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
	struct _2814
	{
	    vec4 _m0[3];
	};
	
	struct _85
	{
	    vec4 _m0[4];
	};
	
	struct _2815
	{
	    vec4 _m0[3];
	};
	
	struct _718
	{
	    anon_g_mTextureColorAdjust1 _m0[4];
	};
	
	struct _901
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
	    _2815 _m15;
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
	vec4 _7;
	float _10;
	vec2 _14;
	
	struct _2906
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
	
	layout(set = 1) uniform _2906 PerViewConstantBufferCsgo_t;
	
	struct _1263
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    vec3 _m4;
	};
	
	layout(set = 1) uniform _1263 PerViewConstantBuffer_t;
	
	struct _74
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
	
	layout(set = 1) uniform _74 _Globals_;
	
	struct _867
	{
	    _2814 _m0;
	    _85 _m1;
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
	    _718 _m18;
	    _85 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _867 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    _901 _m0[];
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
	        vec2 _19651 = clamp((vec2(_16100[_23727.x], _16100[_9992]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        vec3 _18781 = _10061 * _Globals_.g_vBiplanarTexCoordScale.xyz;
	        vec3 _16418 = _18781;
	        vec3 _16419 = dFdxFine(_18781);
	        vec3 _16446 = dFdyFine(_18781);
	        _13136 = _19321;
	        _16305 = _19322;
	        _17114 = _19651 / vec2(_19651.x + _19651.y);
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
	    vec2 _13137;
	    vec2 _13998;
	    vec2 _16306;
	    vec2 _17119;
	    vec2 _17120;
	    vec2 _17121;
	    vec4 _23299;
	    if (_23685)
	    {
	        vec2 _19978 = _6616 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _21750 = _13694 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _22329 = _17118 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _22330 = _17117 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _21037 = _17116 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _13654 = _17115 * _Globals_.g_vTexCoordScale1.xy;
	        _13137 = _19978;
	        _16306 = _22330;
	        _17119 = _21750;
	        _17120 = _22329;
	        _17121 = _21037;
	        _13998 = _13654;
	        _23299 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _19978.xy, _21750.xy, _22329.xy) * _17114.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _22330.xy, _21037.xy, _13654.xy) * _17114.y);
	    }
	    else
	    {
	        _13137 = _6616;
	        _16306 = _17117;
	        _17119 = _13694;
	        _17120 = _17118;
	        _17121 = _17116;
	        _13998 = _17115;
	        _23299 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _24878.xy).xyzw;
	    }
	    vec2 _6383 = textureQueryLod(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _24878.xy);
	    float _16356 = _6383.x;
	    float _19275 = fwidth(_23299.x * _Globals_.g_flHeightMapScale1);
	    float _15317 = ((((_16356 * _16356) * (0.012500000186264514923095703125 + _19275)) * 0.0199999995529651641845703125) * _Globals_.g_flBlendSoftnessDistanceModifierStrength) * _18843.x;
	    float _8284 = max(min(input_0.w + _Globals_.g_flBlendSoftness2, 1.0), 9.9999997473787516355514526367188e-05) + _15317;
	    bool _14876 = _Globals_.g_bWetnessUseHeightmapAdjustments != 0;
	    float _11237;
	    if (_14876)
	    {
	        _11237 = max(0.0, ((_23299.x + 0.5) - _Globals_.g_flHeightMapZeroPoint1) * _Globals_.g_flHeightMapScale1);
	    }
	    else
	    {
	        _11237 = _23299.x;
	    }
	    float _17767 = _Globals_.g_flHeightMapZeroPoint1 + (_15317 * 0.5);
	    float _6379 = _Globals_.g_flHeightMapScale1 + _8284;
	    float _20609 = (_23299.x - _17767) * _6379;
	    float _13139;
	    vec3 _13189;
	    vec4 _22995;
	    if (_23685)
	    {
	        vec2 _21820 = (_13137 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _17053 = (_17119 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _8904 = (_17120 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec4 _23806 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _21820, _17053, _8904) * _17114.x;
	        vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _21820, _17053, _8904);
	        float _18178 = _12167.z * _17114.x;
	        float _15456 = _12167.x;
	        float _24534 = _12167.y;
	        float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	        float _11177 = _15456 - _24534;
	        vec3 _21631 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _17114.x;
	        vec3 _24466 = (_1370[_13136.x] * _21631.x) + (_183[_13136.y] * _21631.y);
	        float _13138;
	        vec3 _13753;
	        vec4 _14101;
	        if (_17114.y > 0.0)
	        {
	            vec2 _17048 = (_16306 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _10018 = (_17121 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _8905 = (_13998 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _17048, _10018, _8905);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _21632 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _17114.y;
	            _13138 = _18178 + (_12168.z * _17114.y);
	            _14101 = _23806 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _17048, _10018, _8905) * _17114.y);
	            _13753 = _24466 + ((_1370[_16305.x] * _21632.x) + (_183[_16305.y] * _21632.y));
	        }
	        else
	        {
	            _13138 = _18178;
	            _14101 = _23806;
	            _13753 = _24466;
	        }
	        _13139 = _13138;
	        _13189 = normalize(_13753 + _24347);
	        _22995 = _14101;
	    }
	    else
	    {
	        vec4 _11179 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw);
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
	        _13139 = _11179.z;
	        _13189 = normalize(_8889 - ((mix(_9521, _10020, _20662) * _16475.x) + (mix(_15323, _22186, _20662) * _16475.y)));
	        _22995 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw).xyzw;
	    }
	    float _7812 = clamp(((_Globals_.g_fTextureRoughnessContrast1 * (_13139 - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness1, 0.0, 1.0);
	    vec4 _22411 = vec4(_22995.xyz, 1.0);
	    float _10048 = clamp(mix(_Globals_.g_vAmbientOcclusionLevels1.x, _Globals_.g_vAmbientOcclusionLevels1.z, pow(_22995.w, _Globals_.g_vAmbientOcclusionLevels1.y)), 0.0, 1.0);
	    float _9068 = _23299.w * float(_Globals_.g_bMetalness1 != 0);
	    float _24803 = clamp(((_Globals_.g_fTintMaskContrast1 * (_23299.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness1, 0.0, 1.0);
	    vec3 _25191 = mix(mix(_22995, vec4((_22411 * mat4(vec4(_Globals_.g_mTextureAdjust1._m0[0].x, _Globals_.g_mTextureAdjust1._m0[1].x, _Globals_.g_mTextureAdjust1._m0[2].x, _Globals_.g_mTextureAdjust1._m0[3].x), vec4(_Globals_.g_mTextureAdjust1._m0[0].y, _Globals_.g_mTextureAdjust1._m0[1].y, _Globals_.g_mTextureAdjust1._m0[2].y, _Globals_.g_mTextureAdjust1._m0[3].y), vec4(_Globals_.g_mTextureAdjust1._m0[0].z, _Globals_.g_mTextureAdjust1._m0[1].z, _Globals_.g_mTextureAdjust1._m0[2].z, _Globals_.g_mTextureAdjust1._m0[3].z), vec4(_Globals_.g_mTextureAdjust1._m0[0].w, _Globals_.g_mTextureAdjust1._m0[1].w, _Globals_.g_mTextureAdjust1._m0[2].w, _Globals_.g_mTextureAdjust1._m0[3].w))).xyz, _22995.w), bvec4(_Globals_.g_bAdjustBaseColor1 != 0)).xyz, vec4((_22411 * mat4(vec4(_Globals_.g_mTextureColorAdjust1._m0[0].x, _Globals_.g_mTextureColorAdjust1._m0[1].x, _Globals_.g_mTextureColorAdjust1._m0[2].x, _Globals_.g_mTextureColorAdjust1._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].y, _Globals_.g_mTextureColorAdjust1._m0[1].y, _Globals_.g_mTextureColorAdjust1._m0[2].y, _Globals_.g_mTextureColorAdjust1._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].z, _Globals_.g_mTextureColorAdjust1._m0[1].z, _Globals_.g_mTextureColorAdjust1._m0[2].z, _Globals_.g_mTextureColorAdjust1._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].w, _Globals_.g_mTextureColorAdjust1._m0[1].w, _Globals_.g_mTextureColorAdjust1._m0[2].w, _Globals_.g_mTextureColorAdjust1._m0[3].w))).xyz, _4).xyz, vec3(_24803));
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
	    vec2 _13140;
	    vec2 _13999;
	    vec2 _16307;
	    vec2 _17122;
	    vec2 _17123;
	    vec2 _17124;
	    vec4 _23300;
	    if (_23686)
	    {
	        vec2 _19980 = _13137 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _21753 = _17119 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _22333 = _17120 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _22335 = _16306 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _21304 = _17121 * _Globals_.g_vTexCoordScale2.xy;
	        vec2 _11575 = _13998 * _Globals_.g_vTexCoordScale2.xy;
	        _13140 = _19980;
	        _16307 = _22335;
	        _17122 = _21753;
	        _17123 = _22333;
	        _17124 = _21304;
	        _13999 = _11575;
	        _23300 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _19980.xy, _21753.xy, _22333.xy) * _17114.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _22335.xy, _21304.xy, _11575.xy) * _17114.y);
	    }
	    else
	    {
	        _13140 = _13137;
	        _16307 = _16306;
	        _17122 = _17119;
	        _17123 = _17120;
	        _17124 = _17121;
	        _13999 = _13998;
	        _23300 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _24879.xy).xyzw;
	    }
	    vec2 _6384 = textureQueryLod(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _24879.xy);
	    float _16357 = _6384.x;
	    float _19276 = fwidth(_23300.x * _Globals_.g_flHeightMapScale2);
	    float _19817 = _15317 + (((((_16357 * _16357) * (0.012500000186264514923095703125 + _19276)) * 0.0199999995529651641845703125) * _Globals_.g_flBlendSoftnessDistanceModifierStrength) * _18843.y);
	    float _6913 = _8284 + _19817;
	    float _11243;
	    if (_14876)
	    {
	        _11243 = max(0.0, ((_23300.x + 0.5) - _Globals_.g_flHeightMapZeroPoint2) * _Globals_.g_flHeightMapScale2);
	    }
	    else
	    {
	        _11243 = _23300.x;
	    }
	    float _17768 = _Globals_.g_flHeightMapZeroPoint2 + (_19817 * 0.5);
	    float _6380 = _Globals_.g_flHeightMapScale2 + _6913;
	    float _11621;
	    if (_Globals_.bBlendByFacingDirection2 != 0)
	    {
	        _11621 = _10136 * clamp((((dot(_Globals_.g_vFacingDirection2.xyz, mix(_24347.xyz, _24174, vec3(_Globals_.g_vFacingDirectionMaskNormalMapStrength2)).xyz) - 1.0) + (_Globals_.g_flFacingDirectionMaskSpread2 * 2.0)) / (_Globals_.g_vFacingDirectionMaskSoftness2 * 2.0)) + 0.5, 0.0, 1.0);
	    }
	    else
	    {
	        _11621 = _10136;
	    }
	    float _6994 = ((_23300.x - _17768) * (_6380 - (_6913 * 2.0))) + mix((((-_17767) * _6379) - ((1.0 - _17768) * _6380)) - _6913, ((1.0 - _17767) * _6379) - ((-_17768) * _6380), _11621);
	    vec3 _16290;
	    _16290.x = _20609;
	    _16290.y = _6994;
	    vec2 _9007 = max((_16290.xy - vec2(max(_20609, _6994))) + vec2(_6913), vec2(0.0));
	    float _6253 = clamp(((_9007 / vec2((_9007.x + 9.9999997473787516355514526367188e-05) + _9007.y)).y * mix(0.5, _23300.x, _Globals_.g_flMaskWithHeight2)) * 2.0, 0.0, 1.0);
	    bool _19615 = _6253 > 0.0500000007450580596923828125;
	    float _13143;
	    vec4 _16308;
	    float _16863;
	    vec3 _17125;
	    float _17126;
	    float _17152;
	    if (_19615)
	    {
	        float _13142;
	        vec3 _13190;
	        vec4 _22996;
	        if (_23686)
	        {
	            vec2 _19981 = _13140 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _21754 = _17122 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _22336 = _17123 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _22337 = _16307 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _22994 = _17124 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _18440 = _13999 * _Globals_.g_vTexCoordScale2.xy;
	            bool _23211 = !_21711;
	            vec4 _7425;
	            if (_23211)
	            {
	                _7425 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], undetermined[_Globals_.g_sUserConfig]), _19981.xy, _21754.xy, _22336.xy) * _17114.x;
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
	                vec4 _11182 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], undetermined[_Globals_.g_sUserConfig]), _19981.xy, _21754.xy, _22336.xy);
	                float _15457 = _11182.x;
	                float _24535 = _11182.y;
	                float _16787 = (_15457 + _24535) - 1.00392162799835205078125;
	                float _11183 = _15457 - _24535;
	                vec3 _21633 = normalize(vec3(vec2(_16787, _11183), (1.0 - abs(_16787)) - abs(_11183))).xyz * _17114.x;
	                _10024 = (_1370[_13136.x] * _21633.x) + (_183[_13136.y] * _21633.y);
	                _24485 = _11182.z * _17114.x;
	            }
	            else
	            {
	                _10024 = _24347;
	                _24485 = 0.0;
	            }
	            float _13141;
	            vec3 _13754;
	            vec4 _14102;
	            if (_17114.y > 0.0)
	            {
	                vec4 _12893;
	                if (_23211)
	                {
	                    _12893 = _7425 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], undetermined[_Globals_.g_sUserConfig]), _22337.xy, _22994.xy, _18440.xy) * _17114.y);
	                }
	                else
	                {
	                    _12893 = _7425;
	                }
	                float _13213;
	                vec3 _15671;
	                if (_24030)
	                {
	                    vec4 _12169 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], undetermined[_Globals_.g_sUserConfig]), _22337.xy, _22994.xy, _18440.xy);
	                    float _13492 = _12169.x;
	                    float _21309 = _12169.y;
	                    float _16788 = (_13492 + _21309) - 1.00392162799835205078125;
	                    float _11184 = _13492 - _21309;
	                    vec3 _21634 = normalize(vec3(vec2(_16788, _11184), (1.0 - abs(_16788)) - abs(_11184))).xyz * _17114.y;
	                    _13213 = _24485 + (_12169.z * _17114.y);
	                    _15671 = _10024 + ((_1370[_16305.x] * _21634.x) + (_183[_16305.y] * _21634.y));
	                }
	                else
	                {
	                    _13213 = _24485;
	                    _15671 = _10024;
	                }
	                _13141 = _13213;
	                _14102 = _12893;
	                _13754 = _15671;
	            }
	            else
	            {
	                _13141 = _24485;
	                _14102 = _7425;
	                _13754 = _10024;
	            }
	            _13142 = _13141;
	            _13190 = normalize(_13754 + _24347);
	            _22996 = _14102;
	        }
	        else
	        {
	            vec4 _7424;
	            if (!_21711)
	            {
	                _7424 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], undetermined[_Globals_.g_sUserConfig]), _24879.xy, _9717.xy, _9717.zw).xyzw;
	            }
	            else
	            {
	                _7424 = vec4(0.0);
	            }
	            float _13212;
	            vec3 _15670;
	            if (!_21712)
	            {
	                vec4 _11180 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], undetermined[_Globals_.g_sUserConfig]), _24879.xy, _9717.xy, _9717.zw);
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
	            _13142 = _13212;
	            _13190 = _15670;
	            _22996 = _7424;
	        }
	        vec3 _9718;
	        float _24880;
	        if (!_21712)
	        {
	            _9718 = normalize(mix(_24347, _13190, vec3(_Globals_.g_fTextureNormalContrast2)));
	            _24880 = clamp(((_Globals_.g_fTextureRoughnessContrast2 * (_13142 - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness2, 0.0, 1.0);
	        }
	        else
	        {
	            _9718 = _13190;
	            _24880 = _13142;
	        }
	        vec4 _21847 = vec4(_22996.xyz, 1.0);
	        float _24804 = clamp(((_Globals_.g_fTintMaskContrast2 * (_23300.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness2, 0.0, 1.0);
	        vec3 _25192 = mix(mix(_22996, vec4((_21847 * mat4(vec4(_Globals_.g_mTextureAdjust2._m0[0].x, _Globals_.g_mTextureAdjust2._m0[1].x, _Globals_.g_mTextureAdjust2._m0[2].x, _Globals_.g_mTextureAdjust2._m0[3].x), vec4(_Globals_.g_mTextureAdjust2._m0[0].y, _Globals_.g_mTextureAdjust2._m0[1].y, _Globals_.g_mTextureAdjust2._m0[2].y, _Globals_.g_mTextureAdjust2._m0[3].y), vec4(_Globals_.g_mTextureAdjust2._m0[0].z, _Globals_.g_mTextureAdjust2._m0[1].z, _Globals_.g_mTextureAdjust2._m0[2].z, _Globals_.g_mTextureAdjust2._m0[3].z), vec4(_Globals_.g_mTextureAdjust2._m0[0].w, _Globals_.g_mTextureAdjust2._m0[1].w, _Globals_.g_mTextureAdjust2._m0[2].w, _Globals_.g_mTextureAdjust2._m0[3].w))).xyz, _22996.w), bvec4(_Globals_.g_bAdjustBaseColor2 != 0)).xyz, vec4((_21847 * mat4(vec4(_Globals_.g_mTextureColorAdjust2._m0[0].x, _Globals_.g_mTextureColorAdjust2._m0[1].x, _Globals_.g_mTextureColorAdjust2._m0[2].x, _Globals_.g_mTextureColorAdjust2._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust2._m0[0].y, _Globals_.g_mTextureColorAdjust2._m0[1].y, _Globals_.g_mTextureColorAdjust2._m0[2].y, _Globals_.g_mTextureColorAdjust2._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust2._m0[0].z, _Globals_.g_mTextureColorAdjust2._m0[1].z, _Globals_.g_mTextureColorAdjust2._m0[2].z, _Globals_.g_mTextureColorAdjust2._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust2._m0[0].w, _Globals_.g_mTextureColorAdjust2._m0[1].w, _Globals_.g_mTextureColorAdjust2._m0[2].w, _Globals_.g_mTextureColorAdjust2._m0[3].w))).xyz, _4).xyz, vec3(_24804));
	        vec4 _17843;
	        _17843.x = _25192.x;
	        _17843.y = _25192.y;
	        _17843.z = _25192.z;
	        float _16721 = dot(_17843.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        _13143 = _24804;
	        _16308 = vec4(clamp(mix(_17843.xyz, (_9577 * min(_16721 / _21159, (3.0 * _16721) * _24175)).xyz, vec3((input_1.w * _24804) * float(_Globals_.g_bModelTint2 != 0))), vec3(0.0), vec3(1.0)).xyz, _10);
	        _17125 = _9718;
	        _17126 = clamp(mix(_Globals_.g_vAmbientOcclusionLevels2.x, _Globals_.g_vAmbientOcclusionLevels2.z, pow(_22996.w, _Globals_.g_vAmbientOcclusionLevels2.y)), 0.0, 1.0);
	        _17152 = _23300.w * float(_Globals_.g_bMetalness2 != 0);
	        _16863 = _24880;
	    }
	    else
	    {
	        _13143 = _23300.y;
	        _16308 = vec4(0.0);
	        _17125 = vec3(0.0);
	        _17126 = 0.0;
	        _17152 = _23300.w;
	        _16863 = 0.0;
	    }
	    float _13144;
	    vec3 _13381;
	    vec2 _14948;
	    float _16309;
	    float _17129;
	    vec3 _17130;
	    float _17131;
	    if (_19615)
	    {
	        vec3 _10593;
	        float _11673;
	        if (!_21711)
	        {
	            vec3 _18442 = _16308.xyz * 12.9200000762939453125;
	            vec3 _7485 = (pow(_16308.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	            float _21354;
	            if (_16308.x <= 0.003130800090730190277099609375)
	            {
	                _21354 = _18442.x;
	            }
	            else
	            {
	                _21354 = _7485.x;
	            }
	            float _21355;
	            if (_16308.y <= 0.003130800090730190277099609375)
	            {
	                _21355 = _18442.y;
	            }
	            else
	            {
	                _21355 = _7485.y;
	            }
	            float _20653;
	            if (_16308.z <= 0.003130800090730190277099609375)
	            {
	                _20653 = _18442.z;
	            }
	            else
	            {
	                _20653 = _7485.z;
	            }
	            _11673 = mix(_10048 * mix(1.0, _17126, _6253 * _Globals_.g_flAOCombine2), _17126, _6253 * _Globals_.g_flAOReplace2);
	            _10593 = mix(_23405 * mix(vec3(1.0), vec3(_21354, _21355, _20653) * 2.0, vec3(_6253 * _Globals_.g_flColorOverlay2)), _16308.xyz, vec3(_6253 * _Globals_.g_flColorReplace2));
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
	            _11008 = mix(mix(_24174, normalize(mix(_24347, (_24174 + _17125.xyz) * vec3(0.5), vec3(2.0))), vec3(_6253 * _Globals_.g_flNormalCombine2)), _17125.xyz, vec3((_6253 * clamp((_6994 + _17768) - _20609, 0.0, 1.0)) * _Globals_.g_flNormalReplace2));
	            _14482 = _12792;
	        }
	        else
	        {
	            _11008 = _24174;
	            _14482 = _22927;
	        }
	        _13144 = mix(_9068 * mix(1.0, _17152 * 2.0, _6253 * _Globals_.g_flMetalnessCombine2), _17152, _6253 * _Globals_.g_flMetalnessReplace2);
	        _16309 = mix(_7406, float(_Globals_.g_bSnowLayer2 != 0), _6253);
	        _17129 = _11673;
	        _17130 = _11008;
	        _17131 = mix(_11237, _11243, _6253);
	        _14948 = _14482;
	        _13381 = _10593;
	    }
	    else
	    {
	        _13144 = _9068;
	        _16309 = _7406;
	        _17129 = _10048;
	        _17130 = _24174;
	        _17131 = _11237;
	        _14948 = _22927;
	        _13381 = _23405;
	    }
	    float _13984 = saturate(1.0 - _6253);
	    vec3 _14081 = _13381 * mix(vec3(1.0), input_5.xyz, vec3(clamp(clamp(((float(!(_Globals_.g_bMaskVertexColor1 != 0)) * _13984) + (float(!(_Globals_.g_bMaskVertexColor2 != 0)) * _6253)) + ((_24803 * _13984) + (_13143 * _6253)), 0.0, 1.0) * ((float(_Globals_.g_bVertexColorEnabled1 != 0) * _13984) + (float(_Globals_.g_bVertexColorEnabled2 != 0) * _6253)), 0.0, 1.0)));
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
	    vec3 _13147;
	    vec2 _16310;
	    float _17133;
	    vec3 _17134;
	    float _17135;
	    vec3 _18774;
	    if (_12897)
	    {
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14498 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_0.z, saturate(PerViewConstantBufferCsgo_t._m11)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m12 - 0.5) * 2.0));
	        float _18408 = saturate(_23204 - 0.75) * 2.0;
	        float _8286 = _23204 + (_18408 * _18408);
	        float _16777 = _8286 - _Globals_.g_fWetEdgeSpread;
	        float _11964 = saturate(_8286 * 20.0);
	        vec4 _9719;
	        float _24883;
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
	        float _14611 = smoothstep(_24883 + _16799, _24883 - (input_0.w + (_16799 * 2.0)), _17131) * _11964;
	        float _19808 = max((smoothstep(_23204, _16777 - (0.20000000298023223876953125 * _8286), _17131) * _Globals_.g_fWetEdgeStrength) * _11964, _14611) * _Globals_.g_fPuddleStrength;
	        float _17924 = (_23204 - 1.0) - _17131;
	        float _10334 = (saturate(_17924 + _Globals_.g_fPuddleSedimentHeight) * _Globals_.g_fPuddleSedimentOpacity) * _14611;
	        float _13706 = clamp(((clamp((((_8286 * 2.0) - (mix(0.5, _19372.w, saturate(_14498 * 20.0)) * 0.5)) - (_17131 * 0.5)) + 0.25, 0.0, 1.0) * _Globals_.g_fWetnessStrength) * _11964) + _14611, 0.0, 1.0);
	        float _13146;
	        float _13151;
	        vec4 _23607;
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m9;
	            vec3 _6617;
	            vec4 _12898;
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
	                vec4 _20877 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                vec2 _18922 = (_20877.xy * 2.0) - vec2(1.0);
	                float _22222 = clamp(length(fwidth(_15991)) * 10.0, 0.0, 1.0);
	                vec2 _15297 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_0.z) * mix(1.0, 0.300000011920928955078125, _22222);
	                vec2 _13712 = _21326.xy;
	                vec4 _19601 = vec4(0.0);
	                _19601.x = dot(_22900.xy, _15297);
	                _19601.y = dot(_13712, _15297);
	                vec2 _16048 = (vec2(_20274.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _20878 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_16048 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                vec2 _17104 = (((_20878.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_0.z;
	                _17104.y = _17104.y * 0.5;
	                float _9251 = clamp(length(fwidth(_16048)) * 10.0, 0.0, 1.0);
	                vec2 _13561 = _17104 * mix(1.0, 0.300000011920928955078125, _9251);
	                vec2 _13330 = _19601.xy + vec2(dot(_22900.xy, _13561), dot(_13712, _13561));
	                vec4 _20490 = _19601;
	                _20490.x = _13330.x;
	                _20490.y = _13330.y;
	                _20490.w = input_0.z * (_20877.z + _20878.z);
	                vec3 _20491;
	                _20491.x = _10061.x;
	                _20491.y = _10061.y;
	                _13145 = _12497 * (0.039999999105930328369140625 * (_22222 + _9251));
	                _12898 = _9719 + ((_20490 * _14498) * _12497);
	                _6617 = _20491;
	            }
	            else
	            {
	                _13145 = 0.0;
	                _12898 = _9719;
	                _6617 = _10061;
	            }
	            float _8914 = (_Globals_.g_fRainStrength * PerViewConstantBufferCsgo_t._m8) * PerViewConstantBufferCsgo_t._m8;
	            float _9982;
	            vec4 _21594;
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
	                    _25251 = vec3(_13155.xy + (((-(((((_7848 / vec2(_8329)) * cos(mix(1.0, (_20173 * 40.0) + (PerViewConstantBuffer_t._m0 * 65.0), _14611))) * _20173) * _20173) * mix(2.0, 0.25, clamp(fwidth(_20173) * 20.0, 0.0, 1.0)))) * ((clamp((sin(((_20173 * mix(1.0, 4.0, _14611)) + _18429) * _8914) - (1.0 - ((0.20000000298023223876953125 * _18120) * mix(0.25, 1.0, _14611)))) * 2.0, 0.0, 1.0) * _20173) / _18120)) * mix(16.0, 2.0, _14611)), _13155.z + (((clamp((sin((((_20213 + _18429) + 4.0) + (sin(_17131 * 60.0) * 0.25)) * _8914) - (1.0 - (_18120 * 0.02000000141561031341552734375))) * 2.0, 0.0, 1.0) * _20213) / _18120) * 28.0));
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
	            _13146 = _9982;
	            _13151 = _13145;
	            _23607 = _16886;
	        }
	        else
	        {
	            _13146 = 0.0;
	            _13151 = 0.0;
	            _23607 = _9719;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _13713 = normalize(mix(_17130.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m12 * 2.0)), _19808);
	        vec3 _18806 = mix(_14081, pow(_14081, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_14081, vec3(0.25)) * (_9038 * _14948.x)) * 8.0, vec3(0.0), vec3(1.0)) * mix(_Globals_.g_flWetnessDarkeningStrength1, _Globals_.g_flWetnessDarkeningStrength2, _6253 * _Globals_.g_flColorReplace2));
	        _13147 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _17129, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, vec3(_10334 * _19808)), vec3(1.0 + _13146), vec3(_13146 * 0.100000001490116119384765625));
	        _16310 = clamp(mix(_23398.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13713.xyz)) * 0.5)), vec2(0.0), vec2(1.0));
	        _17133 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17134 = _13713;
	        _17135 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _12727 = mix(_17129, 1.0, _19808);
	        _18774 = mix(_17130, _23607.xyz, vec3(_19808 * _10334));
	    }
	    else
	    {
	        _13147 = _14081;
	        _16310 = _23398;
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
	    vec2 _21819 = max(_16310.xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    vec3 _15598 = -_24347;
	    vec4 _23875 = vec4(_18774.xyz, 1.0);
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21714;
	    if (_24464.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m15) * PerViewConstantBufferCsgo_t._m14.xy) + (PerViewConstantBufferCsgo_t._m14.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], undetermined[_Globals_.g_sCookieSampler]), _11087).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12023 = _18418.z;
	        bool _12285 = abs(_12023) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m14.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12023 : _18579;
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
	        _21714 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m3], undetermined[_Globals_.g_sPointClamp]), (_11087 + mix(_23169, PerViewConstantBufferCsgo_t._m14.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21714 = 1.0;
	    }
	    float _21715;
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
	                vec3 _20493 = _19470;
	                _20493.x = _20561.x;
	                _20493.y = _20561.y;
	                _13148 = saturate(_22193.x * _22193.y);
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
	                    vec3 _20494;
	                    _20494.x = _20562.x;
	                    _20494.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20494.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
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
	        _21715 = _12502;
	    }
	    else
	    {
	        _21715 = 1.0;
	    }
	    vec3 _9720;
	    vec3 _24884;
	    if ((dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _18774.xyz) * _21715) > 0.0)
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
	        vec2 _17301 = max(_21819, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, _15460.xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _21715).xyz;
	        _9720 = ((_9453.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
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
	        vec4 _24261 = vec4(_10061.xyz, 1.0).xyzw * mat4(vec4(PerViewConstantBufferCsgo_t._m13._m0[0].x, PerViewConstantBufferCsgo_t._m13._m0[1].x, PerViewConstantBufferCsgo_t._m13._m0[2].x, PerViewConstantBufferCsgo_t._m13._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m13._m0[0].y, PerViewConstantBufferCsgo_t._m13._m0[1].y, PerViewConstantBufferCsgo_t._m13._m0[2].y, PerViewConstantBufferCsgo_t._m13._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m13._m0[0].z, PerViewConstantBufferCsgo_t._m13._m0[1].z, PerViewConstantBufferCsgo_t._m13._m0[2].z, PerViewConstantBufferCsgo_t._m13._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m13._m0[0].w, PerViewConstantBufferCsgo_t._m13._m0[1].w, PerViewConstantBufferCsgo_t._m13._m0[2].w, PerViewConstantBufferCsgo_t._m13._m0[3].w));
	        float _20176 = _24261.w;
	        vec2 _11414 = _24261.xy / vec2(_20176);
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
	    _13152 = _9720;
	    _16324 = _24884;
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
	                vec4 _15817 = mat4(vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].x, g_BarnLights_1._m0[_12608]._m0._m0[1].x, g_BarnLights_1._m0[_12608]._m0._m0[2].x, g_BarnLights_1._m0[_12608]._m0._m0[3].x), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].y, g_BarnLights_1._m0[_12608]._m0._m0[1].y, g_BarnLights_1._m0[_12608]._m0._m0[2].y, g_BarnLights_1._m0[_12608]._m0._m0[3].y), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].z, g_BarnLights_1._m0[_12608]._m0._m0[1].z, g_BarnLights_1._m0[_12608]._m0._m0[2].z, g_BarnLights_1._m0[_12608]._m0._m0[3].z), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].w, g_BarnLights_1._m0[_12608]._m0._m0[1].w, g_BarnLights_1._m0[_12608]._m0._m0[2].w, g_BarnLights_1._m0[_12608]._m0._m0[3].w)) * vec4(input_2.xyz, 1.0);
	                vec3 _10521 = _15817.xyz / vec3(_15817.w);
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
	                    _12899 = !all(lessThanEqual(abs((mat4x3(vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].x, g_BarnLights_1._m0[_12608]._m15._m0[1].x, g_BarnLights_1._m0[_12608]._m15._m0[2].x), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].y, g_BarnLights_1._m0[_12608]._m15._m0[1].y, g_BarnLights_1._m0[_12608]._m15._m0[2].y), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].z, g_BarnLights_1._m0[_12608]._m15._m0[1].z, g_BarnLights_1._m0[_12608]._m15._m0[2].z), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].w, g_BarnLights_1._m0[_12608]._m15._m0[1].w, g_BarnLights_1._m0[_12608]._m15._m0[2].w)) * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12899)
	                {
	                    _13214 = _13153;
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
	                        vec3 _23594 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23594 * _15156)) + cross(_23594, _20479);
	                        vec3 _14082 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14082.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20497 = _14082;
	                        _20497.x = _20564.x;
	                        _20497.y = _20564.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sTrilinearWrap]), _20497.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20496 = _13791;
	                        _20496.x = _20563.x;
	                        _20496.y = _20563.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sCookieSampler]), _20496.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13214 = _13153;
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
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _13214 = _13153;
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
	                vec3 _18232;
	                if (_17135 > 0.0)
	                {
	                    float _8781 = dot(_15461, _11186.xyz);
	                    float _8125 = saturate(_17135);
	                    _18232 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * clamp((_8781 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_18774.xyz, _15461, vec3(10.0)), _11186.xyz), 1.0, _8125), 0.0, 1.0)), vec3(_8125));
	                }
	                else
	                {
	                    _18232 = _17875;
	                }
	                vec2 _17302 = max(_21819, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11186.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, _15461.xyz);
	                float _19211 = max(0.0, dot(_11186.xyz, _12282));
	                float _9851 = _17302.x;
	                float _25215 = _9851 * _9851;
	                float _19097 = _25215 * _25215;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13214 = _13153.xyz + (((_9453.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
	                _15676 = _16325.xyz + (_18232.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13153 = _13214;
	            _16325 = _15676;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13152 = _13153;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21819.xy, vec2(0.5));
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
	    vec3 _9666 = _8745 * vec3(_21714 * _10796).xyz;
	    vec3 _13436 = vec3(_10796 * _21714).xyz;
	    vec3 _20579;
	    if (_16309 > 0.0)
	    {
	        _20579 = mix(_9666, pow(_9666, vec3(1.0499999523162841796875, 0.949999988079071044921875, 0.800000011920928955078125)), vec3(_16309));
	    }
	    else
	    {
	        _20579 = _9666;
	    }
	    vec3 _22686 = (_16324.xyz + _20579.xyz) * (_13147.xyz * (1.0 - _13144)).xyz;
	    float _12932 = _22686.x;
	    vec4 _11203 = vec4(_12932, _22686.yz, input_5.w);
	    _11203.x = _12932;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15754 = _11203.xyz + (_13152.xyz * _13436).xyz;
	    vec4 _20498 = _11203;
	    _20498.x = _15754.x;
	    _20498.y = _15754.y;
	    _20498.z = _15754.z;
	    vec3 _15734 = _20498.xyz + ((((mix(_11427.xxx, _11427.yyy, _9453) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m6], undetermined[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _13436).xyz;
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
	
	#if (S_ENABLE_LAYER_3 == 0)
		BoolAttribute(HasTexcoordTransform, ((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || 0);
		IntAttribute(MaterialLayerCount, 2);
	#endif
	#if (S_BLEND_EFFECTS_3 == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
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
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
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
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	
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
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
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
	// SPIR-V source (160084 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec3 bBiplanarUsedAny;
	    float _m1;
	    float _m2;
	    bool _m3;
	    int _m4;
	    float _m5;
	    vec2 _m6;
	    vec2 _m7;
	    float _m8;
	    float _m9;
	    vec2 _m10;
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
	    int _m26;
	    float _m27;
	    float _m28;
	    bool _m29;
	    int _m30;
	    float _m31;
	    vec2 _m32;
	    vec2 _m33;
	    float _m34;
	    float _m35;
	    vec2 _m36;
	    float _m37;
	    float _m38;
	    vec4 _m39;
	    vec4 _m40;
	    vec4 _m41;
	    float _m42;
	    int _m43;
	    vec2 _m44;
	    vec2 _m45;
	    float _m46;
	    float _m47;
	    vec2 _m48;
	    float _m49;
	    float _m50;
	    vec4 _m51;
	    vec4 _m52;
	    vec4 _m53;
	    float _m54;
	    float _m55;
	    float _m56;
	    uint _m57;
	    uint _m58;
	    uint _m59;
	    float _m60;
	    float _m61;
	    float _m62;
	    float _m63;
	    float _m64;
	    float _m65;
	    vec3 _m66;
	    float _m67;
	    vec3 _m68;
	    float _m69;
	    float _m70;
	    float _m71;
	    int _m72;
	    bool _m73;
	    float _m74;
	    float _m75;
	    int _m76;
	    bool _m77;
	    bool _m78;
	    float _m79;
	    float _m80;
	    float _m81;
	    bool _m82;
	    bool _m83;
	    float _m84;
	    float _m85;
	    mat4 _m86;
	    mat4 _m87;
	    float _m88;
	    float _m89;
	    float _m90;
	    float _m91;
	    float _m92;
	    float _m93;
	    float _m94;
	    float _m95;
	    float _m96;
	    float _m97;
	    float _m98;
	    float _m99;
	    float _m100;
	    float _m101;
	    bool _m102;
	    float _m103;
	    float _m104;
	    uint _m105;
	    uint _m106;
	    uint _m107;
	    vec3 _m108;
	    float _m109;
	    vec3 _m110;
	    float _m111;
	    float _m112;
	    float _m113;
	    int _m114;
	    bool _m115;
	    mat4 _m116;
	    mat4 _m117;
	    float _m118;
	    float _m119;
	    float _m120;
	    float _m121;
	    vec3 _m122;
	    float _m123;
	    float _m124;
	    float _m125;
	    int _m126;
	    bool _m127;
	    bool _m128;
	    bool _m129;
	    uint _m130;
	    float _m131;
	    bool _m132;
	    bool _m133;
	    float _m134;
	    float _m135;
	    float _m136;
	    float _m137;
	    float _m138;
	    float _m139;
	    vec3 _m140;
	    float _m141;
	    float _m142;
	    float _m143;
	    float _m144;
	    float _m145;
	    float _m146;
	    float _m147;
	    float _m148;
	    float _m149;
	    float _m150;
	    int _m151;
	    int _m152;
	    bool _m153;
	    vec4 _m154;
	    vec4 _m155;
	    vec2 _m156;
	    float _m157;
	    float _m158;
	    vec2 _m159;
	    float _m160;
	    float _m161;
	    vec4 _m162;
	    float _m163;
	    float _m164;
	    float _m165;
	    float _m166;
	    vec4 _m167;
	    vec2 _m168;
	    vec2 _m169;
	    float _m170;
	    float _m171;
	    vec2 _m172;
	    vec4 _m173;
	    vec4 _m174;
	    vec2 _m175;
	    int _m176;
	    int _m177;
	    bool _m178;
	    float _m179;
	    float _m180;
	    float _m181;
	    vec4 _m182;
	    vec4 _m183;
	    vec3 _m184;
	    float _m185;
	    bool _m186;
	    uint _m187;
	    uint _m188;
	    uint _m189;
	    uint _m190;
	    uint _m191;
	    int _m192;
	    int _m193;
	    uint _m194;
	    uint _m195;
	    uint _m196;
	    bool _m197;
	    bool _m198;
	    bool _m199;
	    float _m200;
	    uint _m201;
	    float _m202;
	    float _m203;
	    bool _m204;
	    bool _m205;
	    bool _m206;
	    bool _m207;
	    bool _m208;
	    bool _m209;
	    bool _m210;
	    bool _m211;
	    bool _m212;
	    bool _m213;
	    bool _m214;
	    bool _m215;
	    bool _m216;
	    bool _m217;
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
	
	const vec3 _618[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _622[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
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
	
	vec4 _700;
	float _701;
	vec3 _702;
	
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
	    _RTX_MATERIAL_DATA_ _2614 = _RTX_MATERIAL_DATA_(vec3(g_MaterialData_1._m0[g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 4u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 8u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 12u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 16u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 20u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 24u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 28u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 32u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 36u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 40u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 44u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 48u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 52u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 56u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 60u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 64u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 68u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 72u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 76u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 80u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 84u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 88u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 92u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 96u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 100u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 104u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 108u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 112u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 116u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 124u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 132u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 140u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 152u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 156u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 160u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 164u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 168u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 172u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 176u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 180u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 184u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 188u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 192u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 196u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 200u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 204u) / 4u]), g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 212u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 216u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 220u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 224u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 228u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 232u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 236u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 240u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 244u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 248u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 252u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 256u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 260u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 264u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 268u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 272u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 276u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 280u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 284u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 288u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 292u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 296u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 300u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 304u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 324u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 328u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 332u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 336u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 340u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 344u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 348u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 352u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 356u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 360u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 364u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 368u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 372u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 376u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 380u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 384u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 388u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 392u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 396u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 400u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 404u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 408u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 412u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 416u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 420u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 424u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 428u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 432u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 436u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 440u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 444u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 448u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 452u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 456u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 460u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 464u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 468u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 472u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 476u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 480u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 484u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 488u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 492u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 496u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 500u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 504u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 508u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 512u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 516u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 520u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 524u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 528u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 532u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 536u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 540u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 544u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 548u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 552u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 556u) / 4u], mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 560u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 576u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 592u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 608u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 564u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 580u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 596u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 612u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 568u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 584u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 600u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 616u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 572u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 588u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 604u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 620u) / 4u])), mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 624u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 640u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 656u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 672u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 628u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 644u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 660u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 676u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 632u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 648u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 664u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 680u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 636u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 652u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 668u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 684u) / 4u])), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 688u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 692u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 696u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 700u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 704u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 708u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 712u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 716u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 720u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 724u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 728u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 732u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 736u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 740u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 744u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 748u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 752u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 756u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 760u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 764u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 768u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 772u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 776u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 780u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 784u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 788u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 792u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 796u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 800u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 804u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 808u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 812u) / 4u] != 0, mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 816u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 832u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 848u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 864u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 820u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 836u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 852u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 868u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 824u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 840u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 856u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 872u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 828u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 844u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 860u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 876u) / 4u])), mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 880u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 896u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 912u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 928u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 884u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 900u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 916u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 932u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 888u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 904u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 920u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 936u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 892u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 908u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 924u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 940u) / 4u])), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 944u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 948u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 952u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 956u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 960u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 964u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 968u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 972u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 976u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 980u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 984u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 988u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 992u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 996u) / 4u] != 0, g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1000u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1004u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1008u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1012u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1016u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1020u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1024u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1028u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1032u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1036u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1040u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1044u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1048u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1052u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1056u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1060u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1064u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1068u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1072u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1076u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1080u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1084u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1088u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1092u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1096u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1100u) / 4u] != 0, vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1104u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1108u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1112u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1116u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1124u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1132u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1140u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1148u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1152u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1156u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1160u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1164u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1168u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1172u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1176u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1180u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1184u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1188u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1192u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1196u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1200u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1204u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1212u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1216u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1220u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1224u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1228u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1232u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1236u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1240u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1244u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1248u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1252u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1256u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1260u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1264u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1268u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1272u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1276u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1280u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1284u) / 4u]), g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1288u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1292u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1296u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1300u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1304u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1308u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1312u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1316u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1320u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1324u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1328u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1332u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1336u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1340u) / 4u]), vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1344u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1348u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1352u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1356u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1360u) / 4u] != 0, g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1364u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1368u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1372u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1376u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1380u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1384u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1388u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1392u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1396u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1400u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1404u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1408u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1412u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1416u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1420u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1424u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1428u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1432u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1436u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1440u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1444u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1448u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1452u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1456u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1460u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1464u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1468u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1472u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1476u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1480u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1484u) / 4u] != 0);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _2614;
	    uvec3 _1015;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _2675 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _1015 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2675 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_2675 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_2675 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _2650 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _2651 = _2650 & 4294967292u;
	            uint _2652 = _2651 / 4u;
	            uint _2656 = (_2651 + 4u) / 4u;
	            uint _2661 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2652] & 4294901760u) >> uint(16);
	            uint _2662 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2656] & 65535u;
	            uvec3 _1016;
	            if (_2650 == _2651)
	            {
	                _1016 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2652] & 65535u, _2661, _2662);
	            }
	            else
	            {
	                _1016 = uvec3(_2661, _2662, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2656] & 4294901760u) >> uint(16));
	            }
	            _1015 = _1016;
	            break;
	        }
	        break;
	    } while(false);
	    uint _2690 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _2698 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _1015) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _1009[3];
	    uint _2700 = _2698.x;
	    _1009[0] = vec3(g_Vertices_1[_2690]._m0[_2700 / 4u], g_Vertices_1[_2690]._m0[(_2700 + 4u) / 4u], g_Vertices_1[_2690]._m0[(_2700 + 8u) / 4u]);
	    uint _2714 = _2698.y;
	    _1009[1] = vec3(g_Vertices_1[_2690]._m0[_2714 / 4u], g_Vertices_1[_2690]._m0[(_2714 + 4u) / 4u], g_Vertices_1[_2690]._m0[(_2714 + 8u) / 4u]);
	    uint _2728 = _2698.z;
	    _1009[2] = vec3(g_Vertices_1[_2690]._m0[_2728 / 4u], g_Vertices_1[_2690]._m0[(_2728 + 4u) / 4u], g_Vertices_1[_2690]._m0[(_2728 + 8u) / 4u]);
	    int _1010 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_1010 < 3))
	        {
	            break;
	        }
	        vsInput[_1010].vColorBlendValues = _1009[_1010];
	        _1010++;
	        continue;
	    }
	    vec2 _1011[3];
	    _1011[0] = vec2(0.0);
	    _1011[1] = vec2(0.0);
	    _1011[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _1008 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2771 = uint(_1008[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _2773 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _1006 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1007 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2784 = (uvec3(uint(_1006[_2773])) * _1015) + uvec3(uint(_1007[_2773]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _2919 = _2784.x;
	            _1011[0] = vec2(g_Vertices_1[_2771]._m0[_2919 / 4u], g_Vertices_1[_2771]._m0[(_2919 + 4u) / 4u]);
	            uint _2928 = _2784.y;
	            _1011[1] = vec2(g_Vertices_1[_2771]._m0[_2928 / 4u], g_Vertices_1[_2771]._m0[(_2928 + 4u) / 4u]);
	            uint _2937 = _2784.z;
	            _1011[2] = vec2(g_Vertices_1[_2771]._m0[_2937 / 4u], g_Vertices_1[_2771]._m0[(_2937 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _2890 = _2784.x / 4u;
	                _1011[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2771]._m0[_2890], g_Vertices_3[_2771]._m0[_2890] >> uint(16)) & uvec2(65535u))));
	                uint _2900 = _2784.y / 4u;
	                _1011[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2771]._m0[_2900], g_Vertices_3[_2771]._m0[_2900] >> uint(16)) & uvec2(65535u))));
	                uint _2910 = _2784.z / 4u;
	                _1011[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2771]._m0[_2910], g_Vertices_3[_2771]._m0[_2910] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _2797 = _2784.x / 4u;
	                    uint _2801 = (g_Vertices_3[_2771]._m0[_2797] & 65535u);
	                    int _1005;
	                    if (_2801 > 32767u)
	                    {
	                        _1005 = int(4294901760u | _2801);
	                    }
	                    else
	                    {
	                        _1005 = int(_2801);
	                    }
	                    uint _2814 = (g_Vertices_3[_2771]._m0[_2797] & 4294901760u) >> uint(16);
	                    int _1004;
	                    if (_2814 > 32767u)
	                    {
	                        _1004 = int(4294901760u | _2814);
	                    }
	                    else
	                    {
	                        _1004 = int(_2814);
	                    }
	                    _1011[0] = vec2(max(float(_1005) * 3.0518509447574615478515625e-05, -1.0), max(float(_1004) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2828 = _2784.y / 4u;
	                    uint _2832 = (g_Vertices_3[_2771]._m0[_2828] & 65535u);
	                    int _1003;
	                    if (_2832 > 32767u)
	                    {
	                        _1003 = int(4294901760u | _2832);
	                    }
	                    else
	                    {
	                        _1003 = int(_2832);
	                    }
	                    uint _2845 = (g_Vertices_3[_2771]._m0[_2828] & 4294901760u) >> uint(16);
	                    int _1002;
	                    if (_2845 > 32767u)
	                    {
	                        _1002 = int(4294901760u | _2845);
	                    }
	                    else
	                    {
	                        _1002 = int(_2845);
	                    }
	                    _1011[1] = vec2(max(float(_1003) * 3.0518509447574615478515625e-05, -1.0), max(float(_1002) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2859 = _2784.z / 4u;
	                    uint _2863 = (g_Vertices_3[_2771]._m0[_2859] & 65535u);
	                    int _1001;
	                    if (_2863 > 32767u)
	                    {
	                        _1001 = int(4294901760u | _2863);
	                    }
	                    else
	                    {
	                        _1001 = int(_2863);
	                    }
	                    uint _2876 = (g_Vertices_3[_2771]._m0[_2859] & 4294901760u) >> uint(16);
	                    int _1000;
	                    if (_2876 > 32767u)
	                    {
	                        _1000 = int(4294901760u | _2876);
	                    }
	                    else
	                    {
	                        _1000 = int(_2876);
	                    }
	                    _1011[2] = vec2(max(float(_1001) * 3.0518509447574615478515625e-05, -1.0), max(float(_1000) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _1010 = 0;
	    for (;;)
	    {
	        if (!(_1010 < 3))
	        {
	            break;
	        }
	        vsInput[_1010]._m1 = _1011[_1010];
	        _1010++;
	        continue;
	    }
	    _1011[0] = vec2(0.0);
	    _1011[1] = vec2(0.0);
	    _1011[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _999 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2976 = uint(_999[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _2978 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _997 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _998 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2989 = (uvec3(uint(_997[_2978])) * _1015) + uvec3(uint(_998[_2978]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _3124 = _2989.x;
	            _1011[0] = vec2(g_Vertices_1[_2976]._m0[_3124 / 4u], g_Vertices_1[_2976]._m0[(_3124 + 4u) / 4u]);
	            uint _3133 = _2989.y;
	            _1011[1] = vec2(g_Vertices_1[_2976]._m0[_3133 / 4u], g_Vertices_1[_2976]._m0[(_3133 + 4u) / 4u]);
	            uint _3142 = _2989.z;
	            _1011[2] = vec2(g_Vertices_1[_2976]._m0[_3142 / 4u], g_Vertices_1[_2976]._m0[(_3142 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _3095 = _2989.x / 4u;
	                _1011[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2976]._m0[_3095], g_Vertices_3[_2976]._m0[_3095] >> uint(16)) & uvec2(65535u))));
	                uint _3105 = _2989.y / 4u;
	                _1011[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2976]._m0[_3105], g_Vertices_3[_2976]._m0[_3105] >> uint(16)) & uvec2(65535u))));
	                uint _3115 = _2989.z / 4u;
	                _1011[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2976]._m0[_3115], g_Vertices_3[_2976]._m0[_3115] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _3002 = _2989.x / 4u;
	                    uint _3006 = (g_Vertices_3[_2976]._m0[_3002] & 65535u);
	                    int _996;
	                    if (_3006 > 32767u)
	                    {
	                        _996 = int(4294901760u | _3006);
	                    }
	                    else
	                    {
	                        _996 = int(_3006);
	                    }
	                    uint _3019 = (g_Vertices_3[_2976]._m0[_3002] & 4294901760u) >> uint(16);
	                    int _995;
	                    if (_3019 > 32767u)
	                    {
	                        _995 = int(4294901760u | _3019);
	                    }
	                    else
	                    {
	                        _995 = int(_3019);
	                    }
	                    _1011[0] = vec2(max(float(_996) * 3.0518509447574615478515625e-05, -1.0), max(float(_995) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _3033 = _2989.y / 4u;
	                    uint _3037 = (g_Vertices_3[_2976]._m0[_3033] & 65535u);
	                    int _994;
	                    if (_3037 > 32767u)
	                    {
	                        _994 = int(4294901760u | _3037);
	                    }
	                    else
	                    {
	                        _994 = int(_3037);
	                    }
	                    uint _3050 = (g_Vertices_3[_2976]._m0[_3033] & 4294901760u) >> uint(16);
	                    int _993;
	                    if (_3050 > 32767u)
	                    {
	                        _993 = int(4294901760u | _3050);
	                    }
	                    else
	                    {
	                        _993 = int(_3050);
	                    }
	                    _1011[1] = vec2(max(float(_994) * 3.0518509447574615478515625e-05, -1.0), max(float(_993) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _3064 = _2989.z / 4u;
	                    uint _3068 = (g_Vertices_3[_2976]._m0[_3064] & 65535u);
	                    int _992;
	                    if (_3068 > 32767u)
	                    {
	                        _992 = int(4294901760u | _3068);
	                    }
	                    else
	                    {
	                        _992 = int(_3068);
	                    }
	                    uint _3081 = (g_Vertices_3[_2976]._m0[_3064] & 4294901760u) >> uint(16);
	                    int _991;
	                    if (_3081 > 32767u)
	                    {
	                        _991 = int(4294901760u | _3081);
	                    }
	                    else
	                    {
	                        _991 = int(_3081);
	                    }
	                    _1011[2] = vec2(max(float(_992) * 3.0518509447574615478515625e-05, -1.0), max(float(_991) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _1010 = 0;
	    for (;;)
	    {
	        if (!(_1010 < 3))
	        {
	            break;
	        }
	        vsInput[_1010]._m2 = _1011[_1010];
	        _1010++;
	        continue;
	    }
	    vec3 _1012[3];
	    vec4 _1013[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _977 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _3184 = uint(_977[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _3186 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _975 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _976 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _3197 = (uvec3(uint(_975[_3186])) * _1015) + uvec3(uint(_976[_3186]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _3728 = _3197.x;
	                _1012[0] = vec3(g_Vertices_1[_3184]._m0[_3728 / 4u], g_Vertices_1[_3184]._m0[(_3728 + 4u) / 4u], g_Vertices_1[_3184]._m0[(_3728 + 8u) / 4u]);
	                uint _3742 = _3197.y;
	                _1012[1] = vec3(g_Vertices_1[_3184]._m0[_3742 / 4u], g_Vertices_1[_3184]._m0[(_3742 + 4u) / 4u], g_Vertices_1[_3184]._m0[(_3742 + 8u) / 4u]);
	                uint _3756 = _3197.z;
	                _1012[2] = vec3(g_Vertices_1[_3184]._m0[_3756 / 4u], g_Vertices_1[_3184]._m0[(_3756 + 4u) / 4u], g_Vertices_1[_3184]._m0[(_3756 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _3461 = _3197.x;
	                    uvec2 _3469 = uvec2(g_Vertices_3[_3184]._m0[_3461 / 4u], g_Vertices_3[_3184]._m0[(_3461 + 4u) / 4u]);
	                    uint _3470 = _3197.y;
	                    uvec2 _724 = uvec2(g_Vertices_3[_3184]._m0[_3470 / 4u], g_Vertices_3[_3184]._m0[(_3470 + 4u) / 4u]);
	                    uint _3479 = _3197.z;
	                    uvec2 _723 = uvec2(g_Vertices_3[_3184]._m0[_3479 / 4u], g_Vertices_3[_3184]._m0[(_3479 + 4u) / 4u]);
	                    uint _3491 = _3469.x;
	                    uint _3500 = _3469.y;
	                    vec2 _3510 = ((vec2(float((_3491) & 65535u), float((_3491 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3511 = _3510.x;
	                    float _3516 = (1.0 - abs(_3511)) - abs(_3510.y);
	                    vec3 _3517 = vec3(_3511, _3510.y, _3516);
	                    float _3519 = saturate(-_3516);
	                    vec2 _3525 = _3510 + mix(vec2(_3519), vec2(-_3519), greaterThanEqual(_3510, vec2(0.0)));
	                    _3517.x = _3525.x;
	                    _3517.y = _3525.y;
	                    vec3 _985 = normalize(_3517);
	                    vec2 _3532 = ((vec2(float((_3500 >> uint(1)) & 32767u), float((_3500 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3533 = _3532.x;
	                    float _3538 = (1.0 - abs(_3533)) - abs(_3532.y);
	                    vec3 _3539 = vec3(_3533, _3532.y, _3538);
	                    float _3541 = saturate(-_3538);
	                    vec2 _3547 = _3532 + mix(vec2(_3541), vec2(-_3541), greaterThanEqual(_3532, vec2(0.0)));
	                    _3539.x = _3547.x;
	                    _3539.y = _3547.y;
	                    vec3 _984 = normalize(_3539);
	                    float _965;
	                    if ((_3500 & 1u) != 0u)
	                    {
	                        _965 = 1.0;
	                    }
	                    else
	                    {
	                        _965 = -1.0;
	                    }
	                    _1012[0] = _985;
	                    _1013[0].w = _965;
	                    _1013[0].x = _984.x;
	                    _1013[0].y = _984.y;
	                    _1013[0].z = _984.z;
	                    vec2 _3590 = ((vec2(float((_724.x) & 65535u), float((_724.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3591 = _3590.x;
	                    float _3596 = (1.0 - abs(_3591)) - abs(_3590.y);
	                    vec3 _3597 = vec3(_3591, _3590.y, _3596);
	                    float _3599 = saturate(-_3596);
	                    vec2 _3605 = _3590 + mix(vec2(_3599), vec2(-_3599), greaterThanEqual(_3590, vec2(0.0)));
	                    _3597.x = _3605.x;
	                    _3597.y = _3605.y;
	                    vec3 _987 = normalize(_3597);
	                    vec2 _3612 = ((vec2(float((_724.y >> uint(1)) & 32767u), float((_724.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3613 = _3612.x;
	                    float _3618 = (1.0 - abs(_3613)) - abs(_3612.y);
	                    vec3 _3619 = vec3(_3613, _3612.y, _3618);
	                    float _3621 = saturate(-_3618);
	                    vec2 _3627 = _3612 + mix(vec2(_3621), vec2(-_3621), greaterThanEqual(_3612, vec2(0.0)));
	                    _3619.x = _3627.x;
	                    _3619.y = _3627.y;
	                    vec3 _986 = normalize(_3619);
	                    float _964;
	                    if ((_724.y & 1u) != 0u)
	                    {
	                        _964 = 1.0;
	                    }
	                    else
	                    {
	                        _964 = -1.0;
	                    }
	                    _1012[1] = _987;
	                    _1013[1].w = _964;
	                    _1013[1].x = _986.x;
	                    _1013[1].y = _986.y;
	                    _1013[1].z = _986.z;
	                    vec2 _3670 = ((vec2(float((_723.x) & 65535u), float((_723.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3671 = _3670.x;
	                    float _3676 = (1.0 - abs(_3671)) - abs(_3670.y);
	                    vec3 _3677 = vec3(_3671, _3670.y, _3676);
	                    float _3679 = saturate(-_3676);
	                    vec2 _3685 = _3670 + mix(vec2(_3679), vec2(-_3679), greaterThanEqual(_3670, vec2(0.0)));
	                    _3677.x = _3685.x;
	                    _3677.y = _3685.y;
	                    vec3 _989 = normalize(_3677);
	                    vec2 _3692 = ((vec2(float((_723.y >> uint(1)) & 32767u), float((_723.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3693 = _3692.x;
	                    float _3698 = (1.0 - abs(_3693)) - abs(_3692.y);
	                    vec3 _3699 = vec3(_3693, _3692.y, _3698);
	                    float _3701 = saturate(-_3698);
	                    vec2 _3707 = _3692 + mix(vec2(_3701), vec2(-_3701), greaterThanEqual(_3692, vec2(0.0)));
	                    _3699.x = _3707.x;
	                    _3699.y = _3707.y;
	                    vec3 _988 = normalize(_3699);
	                    float _963;
	                    if ((_723.y & 1u) != 0u)
	                    {
	                        _963 = 1.0;
	                    }
	                    else
	                    {
	                        _963 = -1.0;
	                    }
	                    _1012[2] = _989;
	                    _1013[2].w = _963;
	                    _1013[2].x = _988.x;
	                    _1013[2].y = _988.y;
	                    _1013[2].z = _988.z;
	                    break;
	                }
	                else
	                {
	                    uint _3207 = _3197.x / 4u;
	                    vec4 _979 = _1013[0];
	                    float _3222 = (float((g_Vertices_3[_3184]._m0[_3207] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3225 = (float((g_Vertices_3[_3184]._m0[_3207] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3229 = (1.0 - abs(_3222)) - abs(_3225);
	                    vec3 _3230 = vec3(_3222, _3225, _3229);
	                    float _3232 = saturate(-_3229);
	                    vec2 _3233 = vec2(_3222, _3225);
	                    vec2 _3239 = _3233 + mix(vec2(_3232), vec2(-_3232), greaterThanEqual(_3233, vec2(0.0)));
	                    _3230.x = _3239.x;
	                    _3230.y = _3239.y;
	                    vec3 _3244 = normalize(_3230);
	                    vec3 _978 = _3244;
	                    float _3245 = _3244.z;
	                    float _972;
	                    if (_3245 >= 0.0)
	                    {
	                        _972 = 1.0;
	                    }
	                    else
	                    {
	                        _972 = -1.0;
	                    }
	                    float _3252 = (-1.0) / (_972 + _3245);
	                    float _3253 = _3244.x;
	                    vec3 _973;
	                    vec3 _3261 = _973;
	                    _3261.x = 1.0 + (((_972 * _3253) * _3253) * _3252);
	                    _3261.y = _972 * ((_3253 * _3244.y) * _3252);
	                    _3261.z = (-_972) * _3253;
	                    _973 = _3261;
	                    float _3269 = float((g_Vertices_3[_3184]._m0[_3207] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3275 = (_3261 * cos(_3269)) + (cross(_3244, _3261) * sin(_3269));
	                    vec4 _3277 = _979;
	                    _3277.x = _3275.x;
	                    _3277.y = _3275.y;
	                    _3277.z = _3275.z;
	                    _979 = _3277;
	                    float _974;
	                    if ((g_Vertices_3[_3184]._m0[_3207] & 1u) == 0u)
	                    {
	                        _974 = -1.0;
	                    }
	                    else
	                    {
	                        _974 = 1.0;
	                    }
	                    vec4 _3288 = _979;
	                    _3288.w = _974;
	                    _979 = _3288;
	                    _1012[0] = _978;
	                    _1013[0] = _3288;
	                    uint _3292 = _3197.y / 4u;
	                    vec4 _981 = _1013[1];
	                    float _3307 = (float((g_Vertices_3[_3184]._m0[_3292] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3310 = (float((g_Vertices_3[_3184]._m0[_3292] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3314 = (1.0 - abs(_3307)) - abs(_3310);
	                    vec3 _3315 = vec3(_3307, _3310, _3314);
	                    float _3317 = saturate(-_3314);
	                    vec2 _3318 = vec2(_3307, _3310);
	                    vec2 _3324 = _3318 + mix(vec2(_3317), vec2(-_3317), greaterThanEqual(_3318, vec2(0.0)));
	                    _3315.x = _3324.x;
	                    _3315.y = _3324.y;
	                    vec3 _3329 = normalize(_3315);
	                    vec3 _980 = _3329;
	                    float _3330 = _3329.z;
	                    float _969;
	                    if (_3330 >= 0.0)
	                    {
	                        _969 = 1.0;
	                    }
	                    else
	                    {
	                        _969 = -1.0;
	                    }
	                    float _3337 = (-1.0) / (_969 + _3330);
	                    float _3338 = _3329.x;
	                    vec3 _970;
	                    vec3 _3346 = _970;
	                    _3346.x = 1.0 + (((_969 * _3338) * _3338) * _3337);
	                    _3346.y = _969 * ((_3338 * _3329.y) * _3337);
	                    _3346.z = (-_969) * _3338;
	                    _970 = _3346;
	                    float _3354 = float((g_Vertices_3[_3184]._m0[_3292] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3360 = (_3346 * cos(_3354)) + (cross(_3329, _3346) * sin(_3354));
	                    vec4 _3362 = _981;
	                    _3362.x = _3360.x;
	                    _3362.y = _3360.y;
	                    _3362.z = _3360.z;
	                    _981 = _3362;
	                    float _971;
	                    if ((g_Vertices_3[_3184]._m0[_3292] & 1u) == 0u)
	                    {
	                        _971 = -1.0;
	                    }
	                    else
	                    {
	                        _971 = 1.0;
	                    }
	                    vec4 _3373 = _981;
	                    _3373.w = _971;
	                    _981 = _3373;
	                    _1012[1] = _980;
	                    _1013[1] = _3373;
	                    uint _3377 = _3197.z / 4u;
	                    vec4 _983 = _1013[2];
	                    float _3392 = (float((g_Vertices_3[_3184]._m0[_3377] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3395 = (float((g_Vertices_3[_3184]._m0[_3377] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3399 = (1.0 - abs(_3392)) - abs(_3395);
	                    vec3 _3400 = vec3(_3392, _3395, _3399);
	                    float _3402 = saturate(-_3399);
	                    vec2 _3403 = vec2(_3392, _3395);
	                    vec2 _3409 = _3403 + mix(vec2(_3402), vec2(-_3402), greaterThanEqual(_3403, vec2(0.0)));
	                    _3400.x = _3409.x;
	                    _3400.y = _3409.y;
	                    vec3 _3414 = normalize(_3400);
	                    vec3 _982 = _3414;
	                    float _3415 = _3414.z;
	                    float _966;
	                    if (_3415 >= 0.0)
	                    {
	                        _966 = 1.0;
	                    }
	                    else
	                    {
	                        _966 = -1.0;
	                    }
	                    float _3422 = (-1.0) / (_966 + _3415);
	                    float _3423 = _3414.x;
	                    vec3 _967;
	                    vec3 _3431 = _967;
	                    _3431.x = 1.0 + (((_966 * _3423) * _3423) * _3422);
	                    _3431.y = _966 * ((_3423 * _3414.y) * _3422);
	                    _3431.z = (-_966) * _3423;
	                    _967 = _3431;
	                    float _3439 = float((g_Vertices_3[_3184]._m0[_3377] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3445 = (_3431 * cos(_3439)) + (cross(_3414, _3431) * sin(_3439));
	                    vec4 _3447 = _983;
	                    _3447.x = _3445.x;
	                    _3447.y = _3445.y;
	                    _3447.z = _3445.z;
	                    _983 = _3447;
	                    float _968;
	                    if ((g_Vertices_3[_3184]._m0[_3377] & 1u) == 0u)
	                    {
	                        _968 = -1.0;
	                    }
	                    else
	                    {
	                        _968 = 1.0;
	                    }
	                    vec4 _3458 = _983;
	                    _3458.w = _968;
	                    _983 = _3458;
	                    _1012[2] = _982;
	                    _1013[2] = _3458;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _1012[0] = vec3(0.0);
	            _1012[1] = vec3(0.0);
	            _1012[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _990 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _3781 = uint(_990[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _3783 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _961 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _962 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _3794 = (uvec3(uint(_961[_3783])) * _1015) + uvec3(uint(_962[_3783]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _3796 = _3794.x;
	            _1013[0] = vec4(g_Vertices_1[_3781]._m0[_3796 / 4u], g_Vertices_1[_3781]._m0[(_3796 + 4u) / 4u], g_Vertices_1[_3781]._m0[(_3796 + 8u) / 4u], g_Vertices_1[_3781]._m0[(_3796 + 12u) / 4u]);
	            uint _3814 = _3794.y;
	            _1013[1] = vec4(g_Vertices_1[_3781]._m0[_3814 / 4u], g_Vertices_1[_3781]._m0[(_3814 + 4u) / 4u], g_Vertices_1[_3781]._m0[(_3814 + 8u) / 4u], g_Vertices_1[_3781]._m0[(_3814 + 12u) / 4u]);
	            uint _3832 = _3794.z;
	            _1013[2] = vec4(g_Vertices_1[_3781]._m0[_3832 / 4u], g_Vertices_1[_3781]._m0[(_3832 + 4u) / 4u], g_Vertices_1[_3781]._m0[(_3832 + 8u) / 4u], g_Vertices_1[_3781]._m0[(_3832 + 12u) / 4u]);
	        }
	        else
	        {
	            _1013[0] = vec4(0.0);
	            _1013[1] = vec4(0.0);
	            _1013[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _1010 = 0;
	    for (;;)
	    {
	        if (!(_1010 < 3))
	        {
	            break;
	        }
	        vsInput[_1010]._m3 = _1012[_1010];
	        vsInput[_1010]._m4 = _1013[_1010];
	        _1010++;
	        continue;
	    }
	    vec4 _1014[3];
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _960 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _3883 = uint(_960[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _3885 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _958 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _959 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3896 = (uvec3(uint(_958[_3885])) * _1015) + uvec3(uint(_959[_3885]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _3950 = _3896.x;
	            _1014[0] = vec4(g_Vertices_1[_3883]._m0[_3950 / 4u], g_Vertices_1[_3883]._m0[(_3950 + 4u) / 4u], g_Vertices_1[_3883]._m0[(_3950 + 8u) / 4u], g_Vertices_1[_3883]._m0[(_3950 + 12u) / 4u]);
	            uint _3968 = _3896.y;
	            _1014[1] = vec4(g_Vertices_1[_3883]._m0[_3968 / 4u], g_Vertices_1[_3883]._m0[(_3968 + 4u) / 4u], g_Vertices_1[_3883]._m0[(_3968 + 8u) / 4u], g_Vertices_1[_3883]._m0[(_3968 + 12u) / 4u]);
	            uint _3986 = _3896.z;
	            _1014[2] = vec4(g_Vertices_1[_3883]._m0[_3986 / 4u], g_Vertices_1[_3883]._m0[(_3986 + 4u) / 4u], g_Vertices_1[_3883]._m0[(_3986 + 8u) / 4u], g_Vertices_1[_3883]._m0[(_3986 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _3903 = _3896.x / 4u;
	            _1014[0] = vec4(uvec4((g_Vertices_3[_3883]._m0[_3903] & 255u), (g_Vertices_3[_3883]._m0[_3903] & 65280u) >> uint(8), (g_Vertices_3[_3883]._m0[_3903] & 16711680u) >> uint(16), (g_Vertices_3[_3883]._m0[_3903] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _3919 = _3896.y / 4u;
	            _1014[1] = vec4(uvec4((g_Vertices_3[_3883]._m0[_3919] & 255u), (g_Vertices_3[_3883]._m0[_3919] & 65280u) >> uint(8), (g_Vertices_3[_3883]._m0[_3919] & 16711680u) >> uint(16), (g_Vertices_3[_3883]._m0[_3919] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _3935 = _3896.z / 4u;
	            _1014[2] = vec4(uvec4((g_Vertices_3[_3883]._m0[_3935] & 255u), (g_Vertices_3[_3883]._m0[_3935] & 65280u) >> uint(8), (g_Vertices_3[_3883]._m0[_3935] & 16711680u) >> uint(16), (g_Vertices_3[_3883]._m0[_3935] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _1014[0] = vec4(0.0);
	        _1014[1] = vec4(0.0);
	        _1014[2] = vec4(0.0);
	    }
	    _1010 = 0;
	    for (;;)
	    {
	        if (!(_1010 < 3))
	        {
	            break;
	        }
	        vsInput[_1010]._m7 = _1014[_1010];
	        _1010++;
	        continue;
	    }
	    vec4 _1017[3];
	    _1017[0] = vec4(0.0);
	    _1017[1] = vec4(0.0);
	    _1017[2] = vec4(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _957 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _4037 = uint(_957[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _4039 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _955 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _956 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _4050 = (uvec3(uint(_955[_4039])) * _1015) + uvec3(uint(_956[_4039]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _4103 = _4050.x;
	            _1017[0] = vec4(g_Vertices_1[_4037]._m0[_4103 / 4u], g_Vertices_1[_4037]._m0[(_4103 + 4u) / 4u], g_Vertices_1[_4037]._m0[(_4103 + 8u) / 4u], g_Vertices_1[_4037]._m0[(_4103 + 12u) / 4u]);
	            uint _4120 = _4050.y;
	            _1017[1] = vec4(g_Vertices_1[_4037]._m0[_4120 / 4u], g_Vertices_1[_4037]._m0[(_4120 + 4u) / 4u], g_Vertices_1[_4037]._m0[(_4120 + 8u) / 4u], g_Vertices_1[_4037]._m0[(_4120 + 12u) / 4u]);
	            uint _4137 = _4050.z;
	            _1017[2] = vec4(g_Vertices_1[_4037]._m0[_4137 / 4u], g_Vertices_1[_4037]._m0[(_4137 + 4u) / 4u], g_Vertices_1[_4037]._m0[(_4137 + 8u) / 4u], g_Vertices_1[_4037]._m0[(_4137 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _4059 = _4050.x / 4u;
	                _1017[0] = vec4(uvec4((g_Vertices_3[_4037]._m0[_4059] & 255u), (g_Vertices_3[_4037]._m0[_4059] & 65280u) >> uint(8), (g_Vertices_3[_4037]._m0[_4059] & 16711680u) >> uint(16), (g_Vertices_3[_4037]._m0[_4059] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _4074 = _4050.y / 4u;
	                _1017[1] = vec4(uvec4((g_Vertices_3[_4037]._m0[_4074] & 255u), (g_Vertices_3[_4037]._m0[_4074] & 65280u) >> uint(8), (g_Vertices_3[_4037]._m0[_4074] & 16711680u) >> uint(16), (g_Vertices_3[_4037]._m0[_4074] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _4089 = _4050.z / 4u;
	                _1017[2] = vec4(uvec4((g_Vertices_3[_4037]._m0[_4089] & 255u), (g_Vertices_3[_4037]._m0[_4089] & 65280u) >> uint(8), (g_Vertices_3[_4037]._m0[_4089] & 16711680u) >> uint(16), (g_Vertices_3[_4037]._m0[_4089] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _1018 = 0;
	    for (;;)
	    {
	        if (!(_1018 < 3))
	        {
	            break;
	        }
	        vsInput[_1018]._m8 = _1017[_1018];
	        _1018++;
	        continue;
	    }
	    vec3 _952 = vsInput[0]._m3;
	    vec4 _953;
	    vec4 _4178 = _953;
	    _4178.x = vsInput[0]._m4.x;
	    _4178.y = vsInput[0]._m4.y;
	    _4178.z = vsInput[0]._m4.z;
	    _4178.w = vsInput[0]._m4.w;
	    _953 = _4178;
	    vec4 _4203 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _951 = _4203;
	    vec3 _4204 = _4203.xyz;
	    vec3 _4205 = _4204 * vec3(0.077399380505084991455078125);
	    vec3 _4208 = pow((_4204 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _948;
	    if (_4203.x <= 0.040449999272823333740234375)
	    {
	        _948 = _4205.x;
	    }
	    else
	    {
	        _948 = _4208.x;
	    }
	    float _949;
	    if (_4203.y <= 0.040449999272823333740234375)
	    {
	        _949 = _4205.y;
	    }
	    else
	    {
	        _949 = _4208.y;
	    }
	    float _950;
	    if (_4203.z <= 0.040449999272823333740234375)
	    {
	        _950 = _4205.z;
	    }
	    else
	    {
	        _950 = _4208.z;
	    }
	    vec3 _4233 = vec3(_948, _949, _950);
	    vec4 _4235 = _951;
	    _4235.x = _4233.x;
	    _4235.y = _4233.y;
	    _4235.z = _4233.z;
	    _951 = _4235;
	    vec4 _742;
	    vec4 _4242 = _742;
	    _4242.x = _4235.x;
	    _4242.y = _4235.y;
	    _4242.z = _4235.z;
	    _4242.w = _4235.w;
	    _742 = _4242;
	    mat3x4 _4253 = transpose(gl_WorldToObjectEXT);
	    mat3 _947;
	    mat3 _4256 = _947;
	    _4256[0] = _4253[0].xyz;
	    _4256[1] = _4253[1].xyz;
	    _4256[2] = _4253[2].xyz;
	    _947 = _4256;
	    vec3 _4265 = normalize(_4256 * _952.xyz);
	    vec3 _743;
	    vec3 _4267 = _743;
	    _4267.x = _4265.x;
	    _4267.y = _4265.y;
	    _4267.z = _4265.z;
	    _743 = _4267;
	    mat3x4 _4279 = transpose(gl_WorldToObjectEXT);
	    mat3 _946;
	    mat3 _4282 = _946;
	    _4282[0] = _4279[0].xyz;
	    _4282[1] = _4279[1].xyz;
	    _4282[2] = _4279[2].xyz;
	    _946 = _4282;
	    vec3 _4291 = normalize(_4282 * _953.xyz);
	    vec4 _741;
	    vec4 _4293 = _741;
	    _4293.x = _4291.x;
	    _4293.y = _4291.y;
	    _4293.z = _4291.z;
	    _4293.w = _953.w;
	    _741 = _4293;
	    vec4 _4302 = vsInput[0]._m1.xyxy;
	    _4302.z = vsInput[0]._m2.x;
	    _4302.w = vsInput[0]._m2.y;
	    vec4 _744;
	    vec4 _745;
	    vec4 _740 = _745;
	    vec4 _739 = _744;
	    vec3 _738 = vec4(vsInput[0].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _737 = _4267;
	    vec4 _736 = _4302;
	    vec4 _735 = _4242;
	    vec4 _734 = _4293;
	    vec2 _954;
	    if (_g_rtx_material_data_._m4 > 0)
	    {
	        if (_g_rtx_material_data_._m4 == 2)
	        {
	            _954 = _4302.zw;
	        }
	        else
	        {
	            _954 = _4302.xy;
	        }
	        vec4 _4325 = _736;
	        _4325.x = _954.x;
	        _4325.y = _954.y;
	        vec4 _4344 = _4325;
	        _4344.x = dot(_4325.xy, _g_rtx_material_data_._m11.xy) + _g_rtx_material_data_._m11.w;
	        _4344.y = dot(_4325.xy, _g_rtx_material_data_._m12.xy) + _g_rtx_material_data_._m12.w;
	        _736 = _4344;
	    }
	    if (_g_rtx_material_data_._m30 > 0)
	    {
	        if (_g_rtx_material_data_._m30 == 2)
	        {
	            _954 = _4302.zw;
	        }
	        else
	        {
	            _954 = _4302.xy;
	        }
	        vec4 _4360 = _736;
	        _4360.z = _954.x;
	        _4360.w = _954.y;
	        vec4 _4379 = _4360;
	        _4379.z = dot(_4360.zw, _g_rtx_material_data_._m39.xy) + _g_rtx_material_data_._m39.w;
	        _4379.w = dot(_4360.zw, _g_rtx_material_data_._m40.xy) + _g_rtx_material_data_._m40.w;
	        _736 = _4379;
	    }
	    vec4 _4382 = _735;
	    vec4 _4384 = _739;
	    _4384.x = _4382.x;
	    _4384.y = _4382.y;
	    _4384.z = _4382.z;
	    _4384.w = _g_rtx_material_data_._m185 * (1.0 - min(_4384.x, min(_4384.y, _4384.z)));
	    _739 = _4384;
	    _4382.x = _g_rtx_material_data_._m184.x;
	    _4382.y = _g_rtx_material_data_._m184.y;
	    _4382.z = _g_rtx_material_data_._m184.z;
	    vec3 _4413 = _4382.xyz * mix(vec3(1.0), vsInput[0]._m7.xyz, vec3(vsInput[0]._m7.w));
	    vec4 _4415 = _4382;
	    _4415.x = _4413.x;
	    _4415.y = _4413.y;
	    _4415.z = _4413.z;
	    _735 = _4415;
	    vec4 _4422 = _740;
	    _4422.x = vsInput[0]._m8.x;
	    _4422.y = vsInput[0]._m8.y;
	    _4422.z = vsInput[0]._m8.z;
	    _4422.w = vsInput[0]._m8.w;
	    _740 = _4422;
	    vec4 _722 = _4422;
	    vec4 _721 = _4384;
	    vec3 _720 = _738;
	    vec3 _719 = _737;
	    vec4 _718 = _736;
	    vec4 _717 = _4415;
	    vec4 _716 = _734;
	    vec3 _943 = vsInput[1]._m3;
	    vec4 _944;
	    vec4 _4439 = _944;
	    _4439.x = vsInput[1]._m4.x;
	    _4439.y = vsInput[1]._m4.y;
	    _4439.z = vsInput[1]._m4.z;
	    _4439.w = vsInput[1]._m4.w;
	    _944 = _4439;
	    vec4 _4464 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _942 = _4464;
	    vec3 _4465 = _4464.xyz;
	    vec3 _4466 = _4465 * vec3(0.077399380505084991455078125);
	    vec3 _4469 = pow((_4465 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _939;
	    if (_4464.x <= 0.040449999272823333740234375)
	    {
	        _939 = _4466.x;
	    }
	    else
	    {
	        _939 = _4469.x;
	    }
	    float _940;
	    if (_4464.y <= 0.040449999272823333740234375)
	    {
	        _940 = _4466.y;
	    }
	    else
	    {
	        _940 = _4469.y;
	    }
	    float _941;
	    if (_4464.z <= 0.040449999272823333740234375)
	    {
	        _941 = _4466.z;
	    }
	    else
	    {
	        _941 = _4469.z;
	    }
	    vec3 _4494 = vec3(_939, _940, _941);
	    vec4 _4496 = _942;
	    _4496.x = _4494.x;
	    _4496.y = _4494.y;
	    _4496.z = _4494.z;
	    _942 = _4496;
	    vec4 _754;
	    vec4 _4503 = _754;
	    _4503.x = _4496.x;
	    _4503.y = _4496.y;
	    _4503.z = _4496.z;
	    _4503.w = _4496.w;
	    _754 = _4503;
	    mat3x4 _4514 = transpose(gl_WorldToObjectEXT);
	    mat3 _938;
	    mat3 _4517 = _938;
	    _4517[0] = _4514[0].xyz;
	    _4517[1] = _4514[1].xyz;
	    _4517[2] = _4514[2].xyz;
	    _938 = _4517;
	    vec3 _4526 = normalize(_4517 * _943.xyz);
	    vec3 _755;
	    vec3 _4528 = _755;
	    _4528.x = _4526.x;
	    _4528.y = _4526.y;
	    _4528.z = _4526.z;
	    _755 = _4528;
	    mat3x4 _4540 = transpose(gl_WorldToObjectEXT);
	    mat3 _937;
	    mat3 _4543 = _937;
	    _4543[0] = _4540[0].xyz;
	    _4543[1] = _4540[1].xyz;
	    _4543[2] = _4540[2].xyz;
	    _937 = _4543;
	    vec3 _4552 = normalize(_4543 * _944.xyz);
	    vec4 _753;
	    vec4 _4554 = _753;
	    _4554.x = _4552.x;
	    _4554.y = _4552.y;
	    _4554.z = _4552.z;
	    _4554.w = _944.w;
	    _753 = _4554;
	    vec4 _4563 = vsInput[1]._m1.xyxy;
	    _4563.z = vsInput[1]._m2.x;
	    _4563.w = vsInput[1]._m2.y;
	    vec4 _756;
	    vec4 _757;
	    vec4 _752 = _757;
	    vec4 _751 = _756;
	    vec3 _750 = vec4(vsInput[1].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _749 = _4528;
	    vec4 _748 = _4563;
	    vec4 _747 = _4503;
	    vec4 _746 = _4554;
	    vec2 _945;
	    if (_g_rtx_material_data_._m4 > 0)
	    {
	        if (_g_rtx_material_data_._m4 == 2)
	        {
	            _945 = _4563.zw;
	        }
	        else
	        {
	            _945 = _4563.xy;
	        }
	        vec4 _4586 = _748;
	        _4586.x = _945.x;
	        _4586.y = _945.y;
	        vec4 _4605 = _4586;
	        _4605.x = dot(_4586.xy, _g_rtx_material_data_._m11.xy) + _g_rtx_material_data_._m11.w;
	        _4605.y = dot(_4586.xy, _g_rtx_material_data_._m12.xy) + _g_rtx_material_data_._m12.w;
	        _748 = _4605;
	    }
	    if (_g_rtx_material_data_._m30 > 0)
	    {
	        if (_g_rtx_material_data_._m30 == 2)
	        {
	            _945 = _4563.zw;
	        }
	        else
	        {
	            _945 = _4563.xy;
	        }
	        vec4 _4621 = _748;
	        _4621.z = _945.x;
	        _4621.w = _945.y;
	        vec4 _4640 = _4621;
	        _4640.z = dot(_4621.zw, _g_rtx_material_data_._m39.xy) + _g_rtx_material_data_._m39.w;
	        _4640.w = dot(_4621.zw, _g_rtx_material_data_._m40.xy) + _g_rtx_material_data_._m40.w;
	        _748 = _4640;
	    }
	    vec4 _4643 = _747;
	    vec4 _4645 = _751;
	    _4645.x = _4643.x;
	    _4645.y = _4643.y;
	    _4645.z = _4643.z;
	    _4645.w = _g_rtx_material_data_._m185 * (1.0 - min(_4645.x, min(_4645.y, _4645.z)));
	    _751 = _4645;
	    _4643.x = _g_rtx_material_data_._m184.x;
	    _4643.y = _g_rtx_material_data_._m184.y;
	    _4643.z = _g_rtx_material_data_._m184.z;
	    vec3 _4674 = _4643.xyz * mix(vec3(1.0), vsInput[1]._m7.xyz, vec3(vsInput[1]._m7.w));
	    vec4 _4676 = _4643;
	    _4676.x = _4674.x;
	    _4676.y = _4674.y;
	    _4676.z = _4674.z;
	    _747 = _4676;
	    vec4 _4683 = _752;
	    _4683.x = vsInput[1]._m8.x;
	    _4683.y = vsInput[1]._m8.y;
	    _4683.z = vsInput[1]._m8.z;
	    _4683.w = vsInput[1]._m8.w;
	    _752 = _4683;
	    vec4 _715 = _4683;
	    vec4 _714 = _4645;
	    vec3 _713 = _750;
	    vec3 _712 = _749;
	    vec4 _711 = _748;
	    vec4 _710 = _4676;
	    vec4 _709 = _746;
	    vec3 _934 = vsInput[2]._m3;
	    vec4 _935;
	    vec4 _4700 = _935;
	    _4700.x = vsInput[2]._m4.x;
	    _4700.y = vsInput[2]._m4.y;
	    _4700.z = vsInput[2]._m4.z;
	    _4700.w = vsInput[2]._m4.w;
	    _935 = _4700;
	    vec4 _4725 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _933 = _4725;
	    vec3 _4726 = _4725.xyz;
	    vec3 _4727 = _4726 * vec3(0.077399380505084991455078125);
	    vec3 _4730 = pow((_4726 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _930;
	    if (_4725.x <= 0.040449999272823333740234375)
	    {
	        _930 = _4727.x;
	    }
	    else
	    {
	        _930 = _4730.x;
	    }
	    float _931;
	    if (_4725.y <= 0.040449999272823333740234375)
	    {
	        _931 = _4727.y;
	    }
	    else
	    {
	        _931 = _4730.y;
	    }
	    float _932;
	    if (_4725.z <= 0.040449999272823333740234375)
	    {
	        _932 = _4727.z;
	    }
	    else
	    {
	        _932 = _4730.z;
	    }
	    vec3 _4755 = vec3(_930, _931, _932);
	    vec4 _4757 = _933;
	    _4757.x = _4755.x;
	    _4757.y = _4755.y;
	    _4757.z = _4755.z;
	    _933 = _4757;
	    vec4 _766;
	    vec4 _4764 = _766;
	    _4764.x = _4757.x;
	    _4764.y = _4757.y;
	    _4764.z = _4757.z;
	    _4764.w = _4757.w;
	    _766 = _4764;
	    mat3x4 _4775 = transpose(gl_WorldToObjectEXT);
	    mat3 _929;
	    mat3 _4778 = _929;
	    _4778[0] = _4775[0].xyz;
	    _4778[1] = _4775[1].xyz;
	    _4778[2] = _4775[2].xyz;
	    _929 = _4778;
	    vec3 _4787 = normalize(_4778 * _934.xyz);
	    vec3 _767;
	    vec3 _4789 = _767;
	    _4789.x = _4787.x;
	    _4789.y = _4787.y;
	    _4789.z = _4787.z;
	    _767 = _4789;
	    mat3x4 _4801 = transpose(gl_WorldToObjectEXT);
	    mat3 _928;
	    mat3 _4804 = _928;
	    _4804[0] = _4801[0].xyz;
	    _4804[1] = _4801[1].xyz;
	    _4804[2] = _4801[2].xyz;
	    _928 = _4804;
	    vec3 _4813 = normalize(_4804 * _935.xyz);
	    vec4 _765;
	    vec4 _4815 = _765;
	    _4815.x = _4813.x;
	    _4815.y = _4813.y;
	    _4815.z = _4813.z;
	    _4815.w = _935.w;
	    _765 = _4815;
	    vec4 _4824 = vsInput[2]._m1.xyxy;
	    _4824.z = vsInput[2]._m2.x;
	    _4824.w = vsInput[2]._m2.y;
	    vec4 _768;
	    vec4 _769;
	    vec4 _764 = _769;
	    vec4 _763 = _768;
	    vec3 _762 = vec4(vsInput[2].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _761 = _4789;
	    vec4 _760 = _4824;
	    vec4 _759 = _4764;
	    vec4 _758 = _4815;
	    vec2 _936;
	    if (_g_rtx_material_data_._m4 > 0)
	    {
	        if (_g_rtx_material_data_._m4 == 2)
	        {
	            _936 = _4824.zw;
	        }
	        else
	        {
	            _936 = _4824.xy;
	        }
	        vec4 _4847 = _760;
	        _4847.x = _936.x;
	        _4847.y = _936.y;
	        vec4 _4866 = _4847;
	        _4866.x = dot(_4847.xy, _g_rtx_material_data_._m11.xy) + _g_rtx_material_data_._m11.w;
	        _4866.y = dot(_4847.xy, _g_rtx_material_data_._m12.xy) + _g_rtx_material_data_._m12.w;
	        _760 = _4866;
	    }
	    if (_g_rtx_material_data_._m30 > 0)
	    {
	        if (_g_rtx_material_data_._m30 == 2)
	        {
	            _936 = _4824.zw;
	        }
	        else
	        {
	            _936 = _4824.xy;
	        }
	        vec4 _4882 = _760;
	        _4882.z = _936.x;
	        _4882.w = _936.y;
	        vec4 _4901 = _4882;
	        _4901.z = dot(_4882.zw, _g_rtx_material_data_._m39.xy) + _g_rtx_material_data_._m39.w;
	        _4901.w = dot(_4882.zw, _g_rtx_material_data_._m40.xy) + _g_rtx_material_data_._m40.w;
	        _760 = _4901;
	    }
	    vec4 _4904 = _759;
	    vec4 _4906 = _763;
	    _4906.x = _4904.x;
	    _4906.y = _4904.y;
	    _4906.z = _4904.z;
	    _4906.w = _g_rtx_material_data_._m185 * (1.0 - min(_4906.x, min(_4906.y, _4906.z)));
	    _763 = _4906;
	    _4904.x = _g_rtx_material_data_._m184.x;
	    _4904.y = _g_rtx_material_data_._m184.y;
	    _4904.z = _g_rtx_material_data_._m184.z;
	    vec3 _4935 = _4904.xyz * mix(vec3(1.0), vsInput[2]._m7.xyz, vec3(vsInput[2]._m7.w));
	    vec4 _4937 = _4904;
	    _4937.x = _4935.x;
	    _4937.y = _4935.y;
	    _4937.z = _4935.z;
	    _759 = _4937;
	    vec4 _4944 = _764;
	    _4944.x = vsInput[2]._m8.x;
	    _4944.y = vsInput[2]._m8.y;
	    _4944.z = vsInput[2]._m8.z;
	    _4944.w = vsInput[2]._m8.w;
	    _764 = _4944;
	    vec3 _708 = _762;
	    vec3 _707 = _761;
	    vec3 _4979 = ((_719 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_712 * _22.barycentrics.x)) + (_761 * _22.barycentrics.y);
	    bool _4985 = gl_HitKindEXT == 254u;
	    vec3 _770;
	    vec4 _5022 = ((_722 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_715 * _22.barycentrics.x)) + (_4944 * _22.barycentrics.y);
	    vec4 _733 = _5022;
	    vec4 _732 = ((_721 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_714 * _22.barycentrics.x)) + (_4906 * _22.barycentrics.y);
	    vec3 _731 = _4979;
	    vec4 _730 = ((_718 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_711 * _22.barycentrics.x)) + (_760 * _22.barycentrics.y);
	    vec4 _729 = ((_717 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_710 * _22.barycentrics.x)) + (_4937 * _22.barycentrics.y);
	    vec4 _728 = ((_716 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_709 * _22.barycentrics.x)) + (_758 * _22.barycentrics.y);
	    bool _727 = _4985;
	    float _912 = clamp((_5022.x * 1.10000002384185791015625) - 0.0500000007450580596923828125, 0.0, 1.0);
	    vec3 _830 = vec3(0.5);
	    vec2 _829 = vec2(0.5);
	    float _828 = 0.0;
	    float _827 = 1.0;
	    vec3 _826 = vec3(0.0);
	    float _825 = 0.039999999105930328369140625;
	    vec3 _824 = vec3(0.0);
	    float _823 = 0.0;
	    vec3 _822 = vec3(0.0);
	    vec3 _820 = vec3(1.0);
	    bool _819 = false;
	    vec3 _5036 = _4979.xyz;
	    vec3 _821 = _5036;
	    if (dot(_5036, _5036) >= 1.0099999904632568359375)
	    {
	        _821 = _770.xyz;
	    }
	    _825 = _g_rtx_material_data_._m200;
	    _820 = normalize(cross(_713 - _720, _762 - _720));
	    bool _910;
	    if (_g_rtx_material_data_._m199)
	    {
	        _910 = !_g_rtx_material_data_._m198;
	    }
	    else
	    {
	        _910 = false;
	    }
	    if (_910)
	    {
	        float _911;
	        if (_4985)
	        {
	            _911 = 1.0;
	        }
	        else
	        {
	            _911 = -1.0;
	        }
	        _821 *= _911;
	        if (_4985)
	        {
	            _911 = 1.0;
	        }
	        else
	        {
	            _911 = -1.0;
	        }
	        _820 *= _911;
	        _819 = !_4985;
	    }
	    vec3 _5067 = _821;
	    vec3 _5068 = normalize(_5067);
	    _821 = _5068;
	    vec3 _818 = _5068;
	    vec3 _817 = _830;
	    vec2 _816 = _829;
	    float _815 = _828;
	    float _814 = _827;
	    vec3 _813 = _826;
	    float _812 = _825;
	    vec3 _811 = _824;
	    float _810 = _823;
	    vec3 _809 = _822;
	    vec3 _808 = _5068;
	    vec3 _807 = _820;
	    bool _806 = _819;
	    vec2 _805 = vec2(0.0);
	    vec2 _804 = vec2(0.0);
	    vec2 _803 = vec2(0.0);
	    vec2 _802 = vec2(0.0);
	    vec2 _801 = vec2(0.0);
	    vec2 _800 = vec2(0.0);
	    vec2 _799 = vec2(0.0);
	    ivec2 _798 = ivec2(0);
	    ivec2 _797 = ivec2(0);
	    if (_g_rtx_material_data_._m217)
	    {
	        vec3 _5086 = abs(_808);
	        vec3 _905 = _5086;
	        float _5087 = _5086.x;
	        float _5088 = _5086.y;
	        bool _906;
	        if (_5087 > _5088)
	        {
	            _906 = _5087 > _5086.z;
	        }
	        else
	        {
	            _906 = false;
	        }
	        ivec3 _907;
	        if (_906)
	        {
	            _907 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5088 > _5086.z)
	            {
	                _907 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _907 = ivec3(2, 0, 1);
	            }
	        }
	        if (_5087 < _5088)
	        {
	            _906 = _5087 < _5086.z;
	        }
	        else
	        {
	            _906 = false;
	        }
	        ivec3 _908;
	        if (_906)
	        {
	            _908 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5088 < _5086.z)
	            {
	                _908 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _908 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _5122 = (ivec3(3) - _908) - _907;
	        ivec2 _909;
	        if (_907.x == 1)
	        {
	            _909 = _907.zy;
	        }
	        else
	        {
	            _909 = _907.yz;
	        }
	        ivec2 _5134 = _798;
	        _5134.x = _909.x;
	        _5134.y = _909.y;
	        _798 = _5134;
	        int _5138 = _5122.x;
	        if (_5138 == 1)
	        {
	            _909 = _5122.zy;
	        }
	        else
	        {
	            _909 = _5122.yz;
	        }
	        ivec2 _5147 = _797;
	        _5147.x = _909.x;
	        _5147.y = _909.y;
	        _797 = _5147;
	        vec2 _5158 = clamp((vec2(_905[_907.x], _905[_5138]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        _799 = _5158 / vec2(_5158.x + _5158.y);
	        vec3 _896 = _809 * _g_rtx_material_data_.bBiplanarUsedAny.xyz;
	        _805 = vec2(_896[_798.x], _896[_798.y]);
	        vec3 _897 = vec3(0.0);
	        vec3 _898 = vec3(0.0);
	        _803 = vec2(_897[_798.x], _898[_798.y]);
	        vec3 _899 = vec3(0.0);
	        vec3 _900 = vec3(0.0);
	        _802 = vec2(_899[_798.x], _900[_798.y]);
	        _804 = vec2(_896[_5147.x], _896[_5147.y]);
	        vec3 _901 = vec3(0.0);
	        vec3 _902 = vec3(0.0);
	        _801 = vec2(_901[_5147.x], _902[_5147.y]);
	        vec3 _903 = vec3(0.0);
	        vec3 _904 = vec3(0.0);
	        _800 = vec2(_903[_5147.x], _904[_5147.y]);
	    }
	    bool _913;
	    if (_g_rtx_material_data_._m30 > 1)
	    {
	        _913 = true;
	    }
	    else
	    {
	        _913 = _g_rtx_material_data_._m4 > 1;
	    }
	    bool _894;
	    if (_g_rtx_material_data_._m199)
	    {
	        _894 = !_g_rtx_material_data_._m198;
	    }
	    else
	    {
	        _894 = false;
	    }
	    if (_894)
	    {
	        float _895;
	        if (_727)
	        {
	            _895 = 1.0;
	        }
	        else
	        {
	            _895 = -1.0;
	        }
	        _894 = _895 < 0.0;
	    }
	    else
	    {
	        _894 = false;
	    }
	    vec3 _834 = vec3(0.0);
	    vec3 _833 = vec3(0.0);
	    float _892;
	    if (_728.w > 0.0)
	    {
	        _892 = 1.0;
	    }
	    else
	    {
	        _892 = -1.0;
	    }
	    float _5253 = 1.0 / length(_731);
	    vec3 _835 = _731 * _5253;
	    vec3 _726 = _728.xyz * _5253;
	    vec3 _725 = (cross(_731, _728.xyz) * _892) * _5253;
	    if (_894)
	    {
	        _835 *= (-1.0);
	    }
	    vec3 _832 = _834 - (_835 * dot(_834, _835));
	    vec3 _831 = _833 - (_835 * dot(_833, _835));
	    int _893;
	    if (dot(_833, cross(_835, _834)) < 0.0)
	    {
	        _893 = -1;
	    }
	    else
	    {
	        _893 = 1;
	    }
	    vec3 _862 = _835;
	    vec3 _861 = _832;
	    vec3 _860 = _831;
	    float _859 = float(_893);
	    vec3 _795;
	    vec3 _796;
	    if (_913)
	    {
	        float _891;
	        if (false)
	        {
	            _891 = -1.0;
	        }
	        else
	        {
	            _891 = 1.0;
	        }
	        vec2 _5290 = vec2(0.0, -0.0) * _891;
	        vec3 _836 = (_861 * _5290.x) + (_860 * _5290.y);
	        float _5298 = abs(0.0);
	        if (_5298 > 0.0)
	        {
	            _836 = normalize(_836);
	        }
	        _796 = _836;
	        _795 = cross(_862, _836) * (_891 * _859);
	    }
	    float _914 = 0.0;
	    float _916 = max(min(_733.w + _g_rtx_material_data_._m27, 1.0), 9.9999997473787516355514526367188e-05);
	    vec3 _917 = vec3(0.0);
	    float _918 = _g_rtx_material_data_._m75;
	    float _919 = _g_rtx_material_data_._m74;
	    vec2 _920 = vec2(0.0);
	    vec4 _794 = vec4(0.0);
	    vec3 _793 = vec3(0.0);
	    vec4 _790 = vec4(0.0);
	    float _789 = 0.0;
	    float _788 = 0.0;
	    float _787 = 0.0;
	    float _786 = 0.0;
	    float _785 = 0.0;
	    float _784 = 0.0;
	    float _783 = 0.0;
	    vec3 _5324 = vec3(0.0);
	    _5324.x = _730.x;
	    _5324.y = _730.y;
	    vec3 _792 = _5324;
	    vec2 _791 = _g_rtx_material_data_._m6.xy;
	    vec4 _890;
	    if (_g_rtx_material_data_._m4 == 0)
	    {
	        vec2 _5343 = _805;
	        vec2 _5344 = _5343 * _791;
	        _805 = _5344;
	        vec2 _5345 = _803;
	        vec2 _5346 = _5345 * _791;
	        _803 = _5346;
	        vec2 _5347 = _802;
	        vec2 _5348 = _5347 * _791;
	        _802 = _5348;
	        vec2 _5349 = _804;
	        vec2 _5350 = _5349 * _791;
	        _804 = _5350;
	        vec2 _5351 = _801;
	        vec2 _5352 = _5351 * _791;
	        _801 = _5352;
	        vec2 _5353 = _800;
	        vec2 _5354 = _5353 * _791;
	        _800 = _5354;
	        _890 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m58], g_bindless_Sampler[_g_rtx_material_data_._m194]), _5344.xy, _5346.xy, _5348.xy) * _799.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m58], g_bindless_Sampler[_g_rtx_material_data_._m194]), _5350.xy, _5352.xy, _5354.xy) * _799.y);
	    }
	    else
	    {
	        _890 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m58], g_bindless_Sampler[_g_rtx_material_data_._m194]), _792.xy, 0.0).xyzw;
	    }
	    _786 = _890.x;
	    _784 = _890.y;
	    _785 = _890.w;
	    _787 = _890.x;
	    if (_g_rtx_material_data_._m133)
	    {
	        _787 = max(0.0, ((_787 + 0.5) - _918) * _919);
	    }
	    float _5395 = _918;
	    float _5396 = _5395 + (_914 * 0.5);
	    _918 = _5396;
	    float _5398 = _919;
	    float _5399 = _5398 + _916;
	    _919 = _5399;
	    vec2 _5402 = _920;
	    _5402.x = (-_5396) * _5399;
	    _5402.y = (1.0 - _5396) * _5399;
	    _920 = _5402;
	    if (false)
	    {
	        _919 -= (_916 * 2.0);
	    }
	    _788 = (_786 - _918) * _919;
	    vec2 _847 = _805;
	    vec2 _846 = _804;
	    vec2 _845 = _803;
	    vec2 _844 = _802;
	    vec2 _843 = _801;
	    vec2 _842 = _800;
	    vec2 _841 = _799;
	    ivec2 _840 = _798;
	    ivec2 _839 = _797;
	    if (_g_rtx_material_data_._m4 == 0)
	    {
	        _847 *= _791;
	        _845 *= _791;
	        _844 *= _791;
	        _846 *= _791;
	        _843 *= _791;
	        _842 *= _791;
	        _793 = _808;
	        if (true)
	        {
	            _794 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m196], g_bindless_Sampler[_g_rtx_material_data_._m194]), _847.xy, _845.xy, _844.xy) * _841.x;
	        }
	        if (true)
	        {
	            vec4 _5567 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m57], g_bindless_Sampler[_g_rtx_material_data_._m194]), _847.xy, _845.xy, _844.xy);
	            _783 = _5567.z * _841.x;
	            float _5572 = _5567.x;
	            float _5573 = _5567.y;
	            float _5575 = (_5572 + _5573) - 1.00392162799835205078125;
	            float _5576 = _5572 - _5573;
	            vec3 _5586 = normalize(vec3(vec2(_5575, _5576), (1.0 - abs(_5575)) - abs(_5576))).xyz * _841.x;
	            vec4 _5588;
	            _5588.x = _5586.x;
	            _5588.y = _5586.y;
	            vec4 _5592 = _5588;
	            _5592.z = _5586.z;
	            _793 = (_618[_840.x] * _5588.x) + (_622[_840.y] * _5588.y);
	        }
	        if (_841.y > 0.0)
	        {
	            if (true)
	            {
	                _794 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m196], g_bindless_Sampler[_g_rtx_material_data_._m194]), _846.xy, _843.xy, _842.xy) * _841.y);
	            }
	            if (true)
	            {
	                vec4 _5642 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m57], g_bindless_Sampler[_g_rtx_material_data_._m194]), _846.xy, _843.xy, _842.xy);
	                _783 += (_5642.z * _841.y);
	                float _5649 = _5642.x;
	                float _5650 = _5642.y;
	                float _5652 = (_5649 + _5650) - 1.00392162799835205078125;
	                float _5653 = _5649 - _5650;
	                vec3 _5663 = normalize(vec3(vec2(_5652, _5653), (1.0 - abs(_5652)) - abs(_5653))).xyz * _841.y;
	                vec4 _5665;
	                _5665.x = _5663.x;
	                _5665.y = _5663.y;
	                vec4 _5669 = _5665;
	                _5669.z = _5663.z;
	                _793 += ((_618[_839.x] * _5665.x) + (_622[_839.y] * _5665.y));
	            }
	        }
	        _793 = normalize(_793 + _808);
	    }
	    else
	    {
	        if (true)
	        {
	            _794 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m196], g_bindless_Sampler[_g_rtx_material_data_._m194]), _792.xy, _790.xy, _790.zw).xyzw;
	        }
	        if (true)
	        {
	            vec4 _5465 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m57], g_bindless_Sampler[_g_rtx_material_data_._m194]), _792.xy, _790.xy, _790.zw);
	            vec3 _5466 = _5465.xyz;
	            _783 = _5465.z;
	            float _5468 = _5465.x;
	            float _5469 = _5465.y;
	            float _5471 = (_5468 + _5469) - 1.00392162799835205078125;
	            float _5472 = _5468 - _5469;
	            vec3 _5479 = normalize(vec3(vec2(_5471, _5472), (1.0 - abs(_5471)) - abs(_5472)));
	            _5466.x = _5479.x;
	            _5466.y = _5479.y;
	            _5466.z = _5479.z;
	            vec3 _5492 = _5466;
	            _5492.x = dot(_5466.xy, _g_rtx_material_data_._m13.xy);
	            _5492.y = dot(_5466.xy, _g_rtx_material_data_._m13.zw);
	            vec3 _889 = _5492;
	            vec3 _837;
	            vec3 _838;
	            if (_g_rtx_material_data_._m4 > 1)
	            {
	                _838 = _796;
	                _837 = _795;
	            }
	            else
	            {
	                _838 = _726;
	                _837 = _725;
	            }
	            vec3 _5500 = abs(_889.xyz);
	            vec2 _5513 = (-vec2(_889.x, (-1.0) * _889.y)) / vec2(max(_5500.z, 0.0078125 * max(_5500.x, _5500.y)));
	            _793 = normalize(_862 - ((_838 * _5513.x) + (_837 * _5513.y)));
	        }
	    }
	    _789 = _794.w;
	    if (true)
	    {
	        _793 = normalize(mix(_808, _793, vec3(_g_rtx_material_data_._m81)));
	        _783 = clamp(((_g_rtx_material_data_._m79 * (_783 - 0.5)) + 0.5) * _g_rtx_material_data_._m80, 0.0, 1.0);
	    }
	    vec4 _884;
	    if (_g_rtx_material_data_._m73)
	    {
	        _884 = vec4((vec4(_794.xyz, 1.0) * _g_rtx_material_data_._m87).xyz, _794.w);
	    }
	    else
	    {
	        _884 = _794;
	    }
	    vec4 _5732 = _884;
	    float _5735 = _789;
	    float _5739 = clamp(mix(_g_rtx_material_data_._m66.x, _g_rtx_material_data_._m66.z, pow(_5735, _g_rtx_material_data_._m66.y)), 0.0, 1.0);
	    _789 = _5739;
	    float _5741 = _785;
	    float _5742 = _5741 * float(_g_rtx_material_data_._m82);
	    _785 = _5742;
	    float _5743 = _784;
	    float _5748 = clamp(((_g_rtx_material_data_._m61 * (_5743 - 0.5)) + 0.5) * _g_rtx_material_data_._m62, 0.0, 1.0);
	    _784 = _5748;
	    vec3 _5752 = mix(_5732.xyz, vec4((vec4(_794.xyz, 1.0) * _g_rtx_material_data_._m86).xyz, _701).xyz, vec3(_5748));
	    vec4 _5754 = _5732;
	    _5754.x = _5752.x;
	    _5754.y = _5752.y;
	    _5754.z = _5752.z;
	    float _5765 = dot(_5754.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _5768 = normalize(max(_732.xyz, vec3(0.001000000047497451305389404296875)));
	    vec4 _5787 = vec4(clamp(mix(_5754.xyz, (_5768 * min(_5765 / dot(_5768.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _5765) * max(_732.x, max(_732.y, _732.z)))).xyz, vec3((_732.w * _5748) * float(_g_rtx_material_data_._m83))), vec3(0.0), vec3(1.0)).xyz, _5754.w);
	    _794 = _5787;
	    _818 = _793.xyz;
	    _817 = _5787.xyz;
	    _814 = _5739;
	    vec2 _5793 = _816;
	    _5793.x = _783;
	    _816 = _5793;
	    _815 = _5742;
	    float _915 = _787;
	    _810 = _788;
	    float _921 = _g_rtx_material_data_._m119;
	    float _922 = _g_rtx_material_data_._m118;
	    vec2 _923 = vec2(0.0);
	    float _924 = 0.0;
	    float _925 = 1.0;
	    if (_g_rtx_material_data_._m90 == 0.0)
	    {
	        _913 = _g_rtx_material_data_._m89 == 0.0;
	    }
	    else
	    {
	        _913 = false;
	    }
	    if (_913)
	    {
	        _913 = _g_rtx_material_data_._m98 == 0.0;
	    }
	    else
	    {
	        _913 = false;
	    }
	    bool _926;
	    if (_913)
	    {
	        _926 = _g_rtx_material_data_._m97 == 0.0;
	    }
	    else
	    {
	        _926 = false;
	    }
	    if (_g_rtx_material_data_._m92 == 0.0)
	    {
	        _913 = _g_rtx_material_data_._m91 == 0.0;
	    }
	    else
	    {
	        _913 = false;
	    }
	    if (_913)
	    {
	        _913 = _g_rtx_material_data_._m94 == 0.0;
	    }
	    else
	    {
	        _913 = false;
	    }
	    bool _927;
	    if (_913)
	    {
	        _927 = _g_rtx_material_data_._m93 == 0.0;
	    }
	    else
	    {
	        _927 = false;
	    }
	    vec4 _782 = vec4(0.0);
	    vec3 _781 = vec3(0.0);
	    vec3 _780 = vec3(0.0);
	    vec2 _779 = vec2(0.0);
	    vec4 _778 = vec4(0.0);
	    float _777 = 0.0;
	    float _776 = 0.0;
	    float _775 = 0.0;
	    float _774 = 0.0;
	    float _773 = 0.0;
	    float _772 = 0.0;
	    float _771 = 0.0;
	    vec3 _5850 = _780;
	    _5850.x = _730.z;
	    _5850.y = _730.w;
	    _780 = _5850;
	    _779 = _g_rtx_material_data_._m32.xy;
	    vec4 _883;
	    if (_g_rtx_material_data_._m30 == 0)
	    {
	        vec2 _5870 = _805;
	        vec2 _5871 = _5870 * _779;
	        _805 = _5871;
	        vec2 _5872 = _803;
	        vec2 _5873 = _5872 * _779;
	        _803 = _5873;
	        vec2 _5874 = _802;
	        vec2 _5875 = _5874 * _779;
	        _802 = _5875;
	        vec2 _5876 = _804;
	        vec2 _5877 = _5876 * _779;
	        _804 = _5877;
	        vec2 _5878 = _801;
	        vec2 _5879 = _5878 * _779;
	        _801 = _5879;
	        vec2 _5880 = _800;
	        vec2 _5881 = _5880 * _779;
	        _800 = _5881;
	        _883 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m107], g_bindless_Sampler[_g_rtx_material_data_._m194]), _5871.xy, _5873.xy, _5875.xy) * _799.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m107], g_bindless_Sampler[_g_rtx_material_data_._m194]), _5877.xy, _5879.xy, _5881.xy) * _799.y);
	    }
	    else
	    {
	        _883 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m107], g_bindless_Sampler[_g_rtx_material_data_._m194]), _780.xy, 0.0).xyzw;
	    }
	    _774 = _883.x;
	    _772 = _883.y;
	    _773 = _883.w;
	    _775 = _883.x;
	    if (_g_rtx_material_data_._m133)
	    {
	        _775 = max(0.0, ((_775 + 0.5) - _921) * _922);
	    }
	    float _5922 = _921;
	    float _5923 = _5922 + (_914 * 0.5);
	    _921 = _5923;
	    float _5925 = _922;
	    float _5926 = _5925 + _916;
	    _922 = _5926;
	    vec2 _5929 = _923;
	    _5929.x = (-_5923) * _5926;
	    _5929.y = (1.0 - _5923) * _5926;
	    _923 = _5929;
	    if (true)
	    {
	        _922 -= (_916 * 2.0);
	    }
	    _776 = (_774 - _921) * _922;
	    if (_g_rtx_material_data_._m214)
	    {
	        _912 *= clamp((((dot(_g_rtx_material_data_._m122.xyz, mix(_808.xyz, _818, vec3(_g_rtx_material_data_._m124)).xyz) - 1.0) + (_g_rtx_material_data_._m123 * 2.0)) / (_g_rtx_material_data_._m125 * 2.0)) + 0.5, 0.0, 1.0);
	    }
	    float _5985 = _776 + mix((_920.x - _923.y) - _916, _920.y - _923.x, _912);
	    _925 = clamp((_5985 + _921) - _810, 0.0, 1.0);
	    float _5989 = max(_810, _5985);
	    if (true)
	    {
	        vec3 _6019 = _917;
	        _6019.x = _810;
	        _6019.y = _5985;
	        _917 = _6019;
	        vec2 _6027 = max((_6019.xy - vec2(_5989)) + vec2(_916), vec2(0.0));
	        _6027.x = _6027.x + 9.9999997473787516355514526367188e-05;
	        _924 = (_6027 / vec2(_6027.x + _6027.y)).y;
	    }
	    else
	    {
	        if (false)
	        {
	            vec3 _5995 = _917;
	            _5995.z = _5985;
	            _917 = _5995;
	            vec3 _6002 = max((_5995.xyz - vec3(_5989)) + vec3(_916), vec3(0.0));
	            _6002.x = _6002.x + 9.9999997473787516355514526367188e-05;
	            vec3 _6017;
	            _6017.z = (_6002.xyz / vec3((_6002.x + _6002.y) + _6002.z)).z;
	            _924 = _6017.z;
	        }
	    }
	    float _6037 = _924;
	    float _6042 = clamp((_6037 * mix(0.5, _774, _g_rtx_material_data_._m120)) * 2.0, 0.0, 1.0);
	    _924 = _6042;
	    bool _6043 = _6042 > 0.0500000007450580596923828125;
	    if (_6043)
	    {
	        vec2 _858 = _805;
	        vec2 _857 = _804;
	        vec2 _856 = _803;
	        vec2 _855 = _802;
	        vec2 _854 = _801;
	        vec2 _853 = _800;
	        vec2 _852 = _799;
	        ivec2 _851 = _798;
	        ivec2 _850 = _797;
	        if (_g_rtx_material_data_._m30 == 0)
	        {
	            _858 *= _779;
	            _856 *= _779;
	            _855 *= _779;
	            _857 *= _779;
	            _854 *= _779;
	            _853 *= _779;
	            _781 = _808;
	            bool _6169 = !_926;
	            if (_6169)
	            {
	                _782 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m105], g_bindless_Sampler[_g_rtx_material_data_._m194]), _858.xy, _856.xy, _855.xy) * _852.x;
	            }
	            bool _6187 = !_927;
	            if (_6187)
	            {
	                vec4 _6201 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m106], g_bindless_Sampler[_g_rtx_material_data_._m194]), _858.xy, _856.xy, _855.xy);
	                _771 = _6201.z * _852.x;
	                float _6206 = _6201.x;
	                float _6207 = _6201.y;
	                float _6209 = (_6206 + _6207) - 1.00392162799835205078125;
	                float _6210 = _6206 - _6207;
	                vec3 _6220 = normalize(vec3(vec2(_6209, _6210), (1.0 - abs(_6209)) - abs(_6210))).xyz * _852.x;
	                vec4 _6222;
	                _6222.x = _6220.x;
	                _6222.y = _6220.y;
	                vec4 _6226 = _6222;
	                _6226.z = _6220.z;
	                _781 = (_618[_851.x] * _6222.x) + (_622[_851.y] * _6222.y);
	            }
	            if (_852.y > 0.0)
	            {
	                if (_6169)
	                {
	                    _782 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m105], g_bindless_Sampler[_g_rtx_material_data_._m194]), _857.xy, _854.xy, _853.xy) * _852.y);
	                }
	                if (_6187)
	                {
	                    vec4 _6276 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m106], g_bindless_Sampler[_g_rtx_material_data_._m194]), _857.xy, _854.xy, _853.xy);
	                    _771 += (_6276.z * _852.y);
	                    float _6283 = _6276.x;
	                    float _6284 = _6276.y;
	                    float _6286 = (_6283 + _6284) - 1.00392162799835205078125;
	                    float _6287 = _6283 - _6284;
	                    vec3 _6297 = normalize(vec3(vec2(_6286, _6287), (1.0 - abs(_6286)) - abs(_6287))).xyz * _852.y;
	                    vec4 _6299;
	                    _6299.x = _6297.x;
	                    _6299.y = _6297.y;
	                    vec4 _6303 = _6299;
	                    _6303.z = _6297.z;
	                    _781 += ((_618[_850.x] * _6299.x) + (_622[_850.y] * _6299.y));
	                }
	            }
	            _781 = normalize(_781 + _808);
	        }
	        else
	        {
	            if (!_926)
	            {
	                _782 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m105], g_bindless_Sampler[_g_rtx_material_data_._m194]), _780.xy, _778.xy, _778.zw).xyzw;
	            }
	            if (!_927)
	            {
	                vec4 _6097 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m106], g_bindless_Sampler[_g_rtx_material_data_._m194]), _780.xy, _778.xy, _778.zw);
	                vec3 _6098 = _6097.xyz;
	                _771 = _6097.z;
	                float _6100 = _6097.x;
	                float _6101 = _6097.y;
	                float _6103 = (_6100 + _6101) - 1.00392162799835205078125;
	                float _6104 = _6100 - _6101;
	                vec3 _6111 = normalize(vec3(vec2(_6103, _6104), (1.0 - abs(_6103)) - abs(_6104)));
	                _6098.x = _6111.x;
	                _6098.y = _6111.y;
	                _6098.z = _6111.z;
	                vec3 _6124 = _6098;
	                _6124.x = dot(_6098.xy, _g_rtx_material_data_._m41.xy);
	                _6124.y = dot(_6098.xy, _g_rtx_material_data_._m41.zw);
	                vec3 _882 = _6124;
	                vec3 _848;
	                vec3 _849;
	                if (_g_rtx_material_data_._m30 > 1)
	                {
	                    _849 = _796;
	                    _848 = _795;
	                }
	                else
	                {
	                    _849 = _726;
	                    _848 = _725;
	                }
	                vec3 _6132 = abs(_882.xyz);
	                vec2 _6145 = (-vec2(_882.x, (-1.0) * _882.y)) / vec2(max(_6132.z, 0.0078125 * max(_6132.x, _6132.y)));
	                _781 = normalize(_862 - ((_849 * _6145.x) + (_848 * _6145.y)));
	            }
	        }
	        _777 = _782.w;
	        if (!_927)
	        {
	            _781 = normalize(mix(_808, _781, vec3(_g_rtx_material_data_._m101)));
	            _771 = clamp(((_g_rtx_material_data_._m99 * (_771 - 0.5)) + 0.5) * _g_rtx_material_data_._m100, 0.0, 1.0);
	        }
	        vec4 _877;
	        if (_g_rtx_material_data_._m115)
	        {
	            _877 = vec4((vec4(_782.xyz, 1.0) * _g_rtx_material_data_._m117).xyz, _782.w);
	        }
	        else
	        {
	            _877 = _782;
	        }
	        vec4 _6368 = _877;
	        _777 = clamp(mix(_g_rtx_material_data_._m108.x, _g_rtx_material_data_._m108.z, pow(_777, _g_rtx_material_data_._m108.y)), 0.0, 1.0);
	        _773 *= float(_g_rtx_material_data_._m102);
	        float _6379 = _772;
	        float _6384 = clamp(((_g_rtx_material_data_._m103 * (_6379 - 0.5)) + 0.5) * _g_rtx_material_data_._m104, 0.0, 1.0);
	        _772 = _6384;
	        vec3 _6388 = mix(_6368.xyz, vec4((vec4(_782.xyz, 1.0) * _g_rtx_material_data_._m116).xyz, _701).xyz, vec3(_6384));
	        vec4 _6390 = _6368;
	        _6390.x = _6388.x;
	        _6390.y = _6388.y;
	        _6390.z = _6388.z;
	        float _6401 = dot(_6390.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        vec3 _6404 = normalize(max(_732.xyz, vec3(0.001000000047497451305389404296875)));
	        _782 = vec4(clamp(mix(_6390.xyz, (_6404 * min(_6401 / dot(_6404.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _6401) * max(_732.x, max(_732.y, _732.z)))).xyz, vec3((_732.w * _6384) * float(_g_rtx_material_data_._m129))), vec3(0.0), vec3(1.0)).xyz, _6390.w);
	    }
	    if (_6043)
	    {
	        if (!_926)
	        {
	            vec3 _6453 = _782.xyz * 12.9200000762939453125;
	            vec3 _6456 = (pow(_782.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	            float _874;
	            if (_782.x <= 0.003130800090730190277099609375)
	            {
	                _874 = _6453.x;
	            }
	            else
	            {
	                _874 = _6456.x;
	            }
	            float _875;
	            if (_782.y <= 0.003130800090730190277099609375)
	            {
	                _875 = _6453.y;
	            }
	            else
	            {
	                _875 = _6456.y;
	            }
	            float _876;
	            if (_782.z <= 0.003130800090730190277099609375)
	            {
	                _876 = _6453.z;
	            }
	            else
	            {
	                _876 = _6456.z;
	            }
	            _817 = mix(_817 * mix(vec3(1.0), vec3(_874, _875, _876) * 2.0, vec3(_924 * _g_rtx_material_data_._m90)), _782.xyz, vec3(_924 * _g_rtx_material_data_._m89));
	            _814 = mix(_814 * mix(1.0, _777, _924 * _g_rtx_material_data_._m98), _777, _924 * _g_rtx_material_data_._m97);
	        }
	        if (!_927)
	        {
	            _818 = mix(mix(_818, normalize(mix(_808, (_818 + _781.xyz) * vec3(0.5), vec3(2.0))), vec3(_924 * _g_rtx_material_data_._m92)), _781.xyz, vec3((_924 * _925) * _g_rtx_material_data_._m91));
	            vec2 _6514 = _816;
	            _6514.x = _6514.x * (1.0 + ((((_771 - _6514.x) * 2.0) * _924) * _g_rtx_material_data_._m94));
	            _6514.x = mix(_6514.x, _771, _924 * _g_rtx_material_data_._m93);
	            _816 = _6514;
	        }
	        _815 = mix(_815 * mix(1.0, _773 * 2.0, _924 * _g_rtx_material_data_._m96), _773, _924 * _g_rtx_material_data_._m95);
	        _915 = mix(_915, _775, _924);
	        _810 = mix(_810, _776, _924);
	    }
	    float _6542 = saturate(1.0 - _924);
	    _817 *= mix(vec3(1.0), _729.xyz, vec3(clamp(clamp(((float(!_g_rtx_material_data_._m78) * _6542) + (float(!_g_rtx_material_data_._m128) * _924)) + ((_784 * _6542) + (_772 * _924)), 0.0, 1.0) * ((float(_g_rtx_material_data_._m77) * _6542) + (float(_g_rtx_material_data_._m127) * _924)), 0.0, 1.0)));
	    vec2 _6575 = _816;
	    vec2 _6577 = _6575;
	    _6577.x = _6575.x;
	    _6577.y = _6575.x;
	    _816 = _6577;
	    bool _871;
	    if (_g_rtx_material_data_._m216)
	    {
	        _871 = (_g_rtx_material_data_._m136 + _g_rtx_material_data_._m148) > 0.0;
	    }
	    else
	    {
	        _871 = false;
	    }
	    if (_871)
	    {
	        _871 = _733.z > 0.0;
	    }
	    else
	    {
	        _871 = false;
	    }
	    if (_871)
	    {
	        vec4 _872 = vec4(0.0, 0.0, 1.0, 0.0);
	        float _6608 = pow(max(0.0, _808.z), 32.0);
	        float _6613 = min(min(_733.z, 1.0), 1.0);
	        float _6616 = saturate(_6613 - 0.75) * 2.0;
	        float _6618 = _6613 + (_6616 * _6616);
	        float _6628 = saturate(_6618 * 20.0);
	        float _873;
	        if (_g_rtx_material_data_._m132)
	        {
	            vec4 _6645 = _872;
	            _6645.x = _808.x;
	            _6645.y = _808.y;
	            _6645.z = _808.z;
	            _872 = _6645;
	            _873 = max(0.0, _6618 - _g_rtx_material_data_._m146);
	        }
	        else
	        {
	            _873 = max(0.0, (_6618 * _6608) - _g_rtx_material_data_._m146);
	        }
	        float _6653 = max(0.001000000047497451305389404296875, _g_rtx_material_data_._m144);
	        float _6661 = smoothstep(_873 + _6653, _873 - (_733.w + (_6653 * 2.0)), _915) * _6628;
	        float _6664 = max((smoothstep(_6613, (_6618 - _g_rtx_material_data_._m146) - (0.20000000298023223876953125 * _6618), _915) * _g_rtx_material_data_._m145) * _6628, _6661) * _g_rtx_material_data_._m136;
	        float _6666 = (_6613 - 1.0) - _915;
	        float _6672 = (saturate(_6666 + _g_rtx_material_data_._m141) * _g_rtx_material_data_._m142) * _6661;
	        _818 = mix(_818, _872.xyz, vec3(_6664 * _6672));
	        float _6692 = max(clamp(((clamp((((_6618 * 2.0) - (mix(0.5, 0.5, saturate(_6608 * 20.0)) * 0.5)) - (_915 * 0.5)) + 0.25, 0.0, 1.0) * _g_rtx_material_data_._m148) * _6628) + _6661, 0.0, 1.0), _6664);
	        vec2 _6696 = _816;
	        vec3 _6704 = mix(_817, pow(_817, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_817, vec3(0.25)) * (_6692 * _6696.x)) * 8.0, vec3(0.0), vec3(1.0)) * mix(_g_rtx_material_data_._m14, _g_rtx_material_data_._m42, _924 * _g_rtx_material_data_._m89));
	        _817 = fma(mix((mix(_6704, _6704 * 0.5, vec3(saturate(_6661 * 1.5))) * mix(1.0, _814, _6664)) * mix(1.0, 1.0 - _6666, _6672), _g_rtx_material_data_._m140, vec3(_6672 * _6664)), vec3(1.0), vec3(0.0));
	        _814 = mix(_814, 1.0, _6664);
	        vec2 _6727 = clamp(mix(_6696.xx, vec2(_g_rtx_material_data_._m143), vec2(_6692)), vec2(0.0), vec2(1.0));
	        vec2 _6729 = _6696;
	        _6729.x = _6727.x;
	        _6729.y = _6727.y;
	        _816 = _6729;
	        _812 = mix(_812, 0.0350000001490116119384765625, _6692);
	    }
	    _814 = max(_814, 0.0);
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _807;
	    _21._m2 = _808;
	    vec3 _863[3] = vec3[](_719, _712, _707);
	    vec3 _864[3] = vec3[](_720, _713, _708);
	    vec3 _6771 = ((_720 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_713 * _22.barycentrics.x)) + (_708 * _22.barycentrics.y);
	    vec3 _865[3];
	    _865[0] = _6771 - (_719 * dot(_6771 - _720, _719));
	    _865[1] = _6771 - (_712 * dot(_6771 - _713, _712));
	    _865[2] = _6771 - (_707 * dot(_6771 - _708, _707));
	    vec3 _6799 = ((_865[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_865[1] * _22.barycentrics.x)) + (_865[2] * _22.barycentrics.y);
	    vec3 _866[3];
	    _866[0] = cross(_720 - _713, _21._m1);
	    _866[1] = cross(_713 - _708, _21._m1);
	    _866[2] = cross(_708 - _720, _21._m1);
	    float _867 = dot(_6799 - _6771, _21._m1);
	    vec3 _868 = _6799;
	    int _869 = 0;
	    for (;;)
	    {
	        bool _6815_ladder_break = false;
	        do
	        {
	            if (!(_869 < 3))
	            {
	                _6815_ladder_break = true;
	                break;
	            }
	            if (_867 > 0.00999999977648258209228515625)
	            {
	                _6815_ladder_break = true;
	                break;
	            }
	            if (dot(_866[_869], _866[_869]) == 0.0)
	            {
	                break;
	            }
	            _866[_869] = normalize(_866[_869]);
	            int _870 = 0;
	            for (;;)
	            {
	                if (!(_870 < 3))
	                {
	                    break;
	                }
	                vec3 _6853 = _863[_870] - (_866[_869] * dot(_866[_869], _863[_870]));
	                _865[_870] = _6771 - (_6853 * dot(_6771 - _864[_870], _6853));
	                _870++;
	                continue;
	            }
	            vec3 _6877 = ((_865[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_865[1] * _22.barycentrics.x)) + (_865[2] * _22.barycentrics.y);
	            _867 = dot(_6877 - _6771, _21._m1);
	            _868 = _6877;
	            break;
	        } while(false);
	        if (_6815_ladder_break)
	        {
	            break;
	        }
	        _869++;
	        continue;
	    }
	    if (!(_867 > 0.00999999977648258209228515625))
	    {
	        _868 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _868;
	    _21._m6 = _806;
	    f16vec3 _6890 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_6890, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _6890, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(_818);
	    _21._m7._m2 = f16vec3(_817);
	    _21._m7._m4 = f16vec3(_813);
	    _21._m7._m5 = float16_t(_812);
	    _21._m7._m1 = float16_t(_815);
	    _21._m7._m3 = float16_t(dot(_816, vec2(0.5)));
	    if (any(greaterThan(_811, vec3(0.0))))
	    {
	        f16vec4 _6919 = _21._m7._m7;
	        f16vec3 _6922 = f16vec3(_811);
	        _6919.x = _6922.x;
	        _6919.y = _6922.y;
	        _6919.z = _6922.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _6919);
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
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction1, g_flDetailPropPuddleReduction1);
	FloatAttribute(_dummyMakeVisiblePropMaskBias2, g_flDetailPropMaskBias2);
	FloatAttribute(_dummyMakeVisiblePropMaskSoftness2, g_flDetailPropMaskSoftness2);
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction2, g_flDetailPropPuddleReduction2);
	
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
	#if (S_BLEND_EFFECTS_3 == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_DETAIL_NORMAL == 0)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
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
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_SHADER_QUALITY == 0)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
}
