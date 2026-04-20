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
	Feature( F_BLEND_BY_FACING_DIRECTION_2, 0..2 (0="None", 1="Geometric", 2="Normal Map"), "Layer 2" );
	Feature( F_ENABLE_LAYER_3, 0..1, "Layer 3" );
	Feature( F_BLEND_BY_FACING_DIRECTION_3, 0..2 (0="None", 1="Geometric", 2="Normal Map"), "Layer 3" );
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
	Feature( F_VISUALIZATION, 0..3 (0="None", 1="Show Blending", 2="Show Final Heights", 3="Show Vertex Painting"), "Visualizations" );
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
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	bool bGeoBlendByFacingDirection2 < UiType(CheckBox); Expression((F_BLEND_BY_FACING_DIRECTION_2>0) || 0); >;
	bool bGeoBlendByFacingDirection3 < UiType(CheckBox); Expression((F_BLEND_BY_FACING_DIRECTION_3>0) || 0); >;
	bool bVertexBlendByFacingDirection3 < UiType(CheckBox); Expression((F_BLEND_BY_FACING_DIRECTION_3==1) || 0); >;
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
	float2 g_vFacingDirectionMinMax2 < UiType(VectorText); Expression(float2(max(0,(1-g_flFacingDirectionMaskSpread2)-g_vFacingDirectionMaskFalloff2),min(1,((1-g_flFacingDirectionMaskSpread2)+.001)+g_vFacingDirectionMaskFalloff2))); >;
	float2 g_vFacingDirectionMinMax3 < UiType(VectorText); Expression(float2(max(0,(1-g_flFacingDirectionMaskSpread3)-g_vFacingDirectionMaskFalloff3),min(1,((1-g_flFacingDirectionMaskSpread3)+.001)+g_vFacingDirectionMaskFalloff3))); >;
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
	float3 g_vFacingDirection2 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material2/Height/40"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flFacingDirectionMaskSpread2 < Default(0.5); UiType(Slider); UiGroup("Material2/Height/50"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_vFacingDirectionMaskFalloff2 < Default(0.1); Range(0, 0.5); UiType(Slider); UiGroup("Material2/Height/55"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	
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
	float3 g_vFacingDirection3 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material3/Height/40"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flFacingDirectionMaskSpread3 < Default(0.5); UiType(Slider); UiGroup("Material3/Height/50"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_vFacingDirectionMaskFalloff3 < Default(0.1); Range(0, 0.5); UiType(Slider); UiGroup("Material3/Height/55"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	
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
	// cbuffer ID 5618 (name: _Globals_), member index 6 (name: g_vFacingDirection2) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (9192 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _2704
	{
	    vec4 _m0[3];
	};
	
	struct _345
	{
	    _2704 _m0;
	};
	
	struct _1205
	{
	    vec4 _m0[4];
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _345 _m0[];
	} g_transformBuffer_1;
	
	struct _421
	{
	    _1205 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _421 PerViewConstantBuffer_t;
	
	struct _1913
	{
	    int g_nUVSet1;
	    vec4 g_vTexCoordXform0_1;
	    vec4 g_vTexCoordXform1_1;
	    int g_nUVSet2;
	    vec4 g_vTexCoordXform0_2;
	    vec4 g_vTexCoordXform1_2;
	    vec3 g_vFacingDirection2;
	    vec2 g_vFacingDirectionMinMax2;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    int bGeoBlendByFacingDirection2;
	};
	
	layout(set = 0) uniform _1913 _Globals_;
	
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
	    vec4 _13903 = vBlendColorTint;
	    vec4 _19363;
	    if (_Globals_.bGeoBlendByFacingDirection2 != 0)
	    {
	        vec4 _20254 = _13903;
	        _20254.x = _13903.x * smoothstep(_Globals_.g_vFacingDirectionMinMax2.x, _Globals_.g_vFacingDirectionMinMax2.y, (dot(_Globals_.g_vFacingDirection2.xyz, _11179.xyz) * 0.5) + 0.5);
	        _19363 = _20254;
	    }
	    else
	    {
	        _19363 = _13903;
	    }
	    output_0 = _19363;
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
	bool bBlendByFacingDirection2 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_2==2); >;
	bool bBlendByFacingDirection3 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_3==2); >;
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
	int g_nVisualization < UiType(Slider); Expression(F_VISUALIZATION); >;
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
	float2 g_vFacingDirectionMinMax2 < UiType(VectorText); Expression(float2(max(0,(1-g_flFacingDirectionMaskSpread2)-g_vFacingDirectionMaskFalloff2),min(1,((1-g_flFacingDirectionMaskSpread2)+.001)+g_vFacingDirectionMaskFalloff2))); >;
	float2 g_vFacingDirectionMinMax3 < UiType(VectorText); Expression(float2(max(0,(1-g_flFacingDirectionMaskSpread3)-g_vFacingDirectionMaskFalloff3),min(1,((1-g_flFacingDirectionMaskSpread3)+.001)+g_vFacingDirectionMaskFalloff3))); >;
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
	float3 g_vTextureColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2,0/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Lighting/12"); >;
	float g_fTextureNormalContrast2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Lighting/13"); >;
	bool g_bMetalness2 < Default(1); UiType(CheckBox); UiGroup("Material2/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flNormalReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/20"); >;
	float3 g_vAmbientOcclusionLevels2 < Default2(0, 0.5); Range(-1, 1); UiType(VectorText); UiGroup("Material2/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness2, Linear, 8, "", "_metal", "Material2/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/30"); >;
	float g_flHeightMapZeroPoint2 < Default(0.5); UiType(Slider); UiGroup("Material2/Height/30"); >;
	float g_flNormalCombine2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Selective Blending/30"); >;
	CreateInputTexture2D(TextureNormalDetail2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Color Correction/40"); >;
	float g_flBlendSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Height,30/40"); >;
	float g_flRoughnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/40"); >;
	float3 g_vFacingDirection2 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material2/Height/40"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flUnderlyingHeightMapInfluence2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height,30/41"); >;
	float g_fDetailTextureNormalContrast2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Detail/45"); >;
	float g_flRoughnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/45"); >;
	int g_nColorCorrectionMode2 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material2/Color Correction/45"); >;
	float g_flFacingDirectionMaskSpread2 < Default(0.5); UiType(Slider); UiGroup("Material2/Height/50"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flMetalnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/50"); >;
	float g_flMetalnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/55"); >;
	float g_vFacingDirectionMaskFalloff2 < Default(0.1); Range(0, 0.5); UiType(Slider); UiGroup("Material2/Height/55"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	bool g_bModelTint2 < Default(1); UiType(CheckBox); UiGroup("Material2/Color Correction/60"); >;
	float g_flAOReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/60"); >;
	int g_nVertexColorMode2 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material2/Color Correction/60"); >;
	float g_vFacingDirectionMaskSoftness2 < UiType(Slider); UiGroup("Material2/Height/60"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2==2); >;
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
	float3 g_vTextureColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3,2/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Lighting/12"); >;
	float g_fTextureNormalContrast3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Lighting/13"); >;
	bool g_bMetalness3 < Default(1); UiType(CheckBox); UiGroup("Material3/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flNormalReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/20"); >;
	float3 g_vAmbientOcclusionLevels3 < Default2(0, 0.5); Range(-1, 1); UiType(VectorText); UiGroup("Material3/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness3, Linear, 8, "", "_metal", "Material3/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/30"); >;
	float g_flHeightMapZeroPoint3 < Default(0.5); UiType(Slider); UiGroup("Material3/Height/30"); >;
	float g_flNormalCombine3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Selective Blending/30"); >;
	CreateInputTexture2D(TextureNormalDetail3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Color Correction/40"); >;
	float g_flBlendSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Height,30/40"); >;
	float g_flRoughnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/40"); >;
	float3 g_vFacingDirection3 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material3/Height/40"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flUnderlyingHeightMapInfluence3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height,30/41"); >;
	float g_fDetailTextureNormalContrast3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Detail/45"); >;
	float g_flRoughnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/45"); >;
	int g_nColorCorrectionMode3 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material3/Color Correction/45"); >;
	float g_flFacingDirectionMaskSpread3 < Default(0.5); UiType(Slider); UiGroup("Material3/Height/50"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flMetalnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/50"); >;
	float g_flMetalnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/55"); >;
	float g_vFacingDirectionMaskFalloff3 < Default(0.1); Range(0, 0.5); UiType(Slider); UiGroup("Material3/Height/55"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flAOReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/60"); >;
	int g_nVertexColorMode3 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material3/Color Correction/60"); >;
	float g_vFacingDirectionMaskSoftness3 < UiType(Slider); UiGroup("Material3/Height/60"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3==2); >;
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
	float3 g_vColorOverlayTintMaskStrengths < Default3(1, 1, 1); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/65"); >;
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
	// SPIR-V source (88260 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	const vec3 _2757[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, -1.0));
	
	struct _1638
	{
	    vec4 _m0[3];
	};
	
	struct _1849
	{
	    vec4 _m0[4];
	};
	
	struct _1639
	{
	    vec4 _m0[3];
	};
	
	struct _2288
	{
	    anon_g_mTextureColorAdjust1 _m0[4];
	};
	
	struct _2884
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
	    _1639 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	};
	
	float _4;
	ivec2 _5;
	vec2 _6;
	vec3 _7;
	vec3 _10;
	vec4 _14;
	
	struct _169
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
	    vec3 g_vFacingDirection2;
	    vec2 g_vFacingDirectionMinMax2;
	    float g_vFacingDirectionMaskSoftness2;
	    float g_flMaskWithHeight2;
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
	    uint g_nVisualization;
	    int bBiplanarUsedAny;
	};
	
	layout(set = 1) uniform _169 _Globals_;
	
	struct _427
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	    uint _m8;
	    float _m9;
	    float _m10;
	    float _m11;
	    float _m12;
	    float _m13;
	    anon_g_mTextureColorAdjust1 _m14;
	    vec2 _m15;
	    float _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    vec4 _m22;
	    anon_g_mTextureColorAdjust1 _m23;
	    vec4 _m24;
	    vec4 _m25;
	    vec4 _m26;
	};
	
	layout(set = 1) uniform _427 PerViewConstantBufferCsgo_t;
	
	struct _1263
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    vec3 _m4;
	};
	
	layout(set = 1) uniform _1263 PerViewConstantBuffer_t;
	
	struct _2998
	{
	    _1638 _m0;
	    _1849 _m1;
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
	    _2288 _m18;
	    _1849 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _2998 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    _2884 _m0[];
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
	    float _9110 = clamp((input_0.x * 1.10000002384185791015625) - 0.0500000007450580596923828125, 0.0, 1.0);
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
	    vec3 _10061 = input_2 + PerViewConstantBufferCsgo_t._m26.xyz;
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
	        _22864 = input_4.xy;
	    }
	    else
	    {
	        _22864 = _21710;
	    }
	    vec3 _22993 = _10061 - PerViewConstantBuffer_t._m4.xyz;
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _18545;
	    if (_12886)
	    {
	        _18545 = (gl_FrontFacing ? 1.0 : (-1.0)) < 0.0;
	    }
	    else
	    {
	        _18545 = false;
	    }
	    vec3 _7147 = dFdxFine(_22993);
	    vec3 _20949 = dFdyFine(_22993);
	    float _22035 = (input_7.w > 0.0) ? 1.0 : (-1.0);
	    float _12157 = 1.0 / length(input_3);
	    vec3 _11587 = input_3 * _12157;
	    vec3 _9521 = input_7.xyz * _12157;
	    vec3 _15323 = (cross(input_3, input_7.xyz) * _22035) * _12157;
	    vec3 _8889;
	    if (_18545)
	    {
	        _8889 = _11587 * (-1.0);
	    }
	    else
	    {
	        _8889 = _11587;
	    }
	    vec3 _10074;
	    vec3 _11730;
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
	        _11730 = _9082;
	        _10074 = cross(_8889, _9082) * (_17298 * float((dot(_20949, cross(_8889, _7147)) < 0.0) ? (-1) : 1));
	    }
	    else
	    {
	        _11730 = _7;
	        _10074 = _7;
	    }
	    bool _19330 = _Globals_.g_nUVSet1 != 0;
	    vec3 _13136;
	    vec4 _13960;
	    vec4 _16305;
	    vec3 _22402;
	    if (_19330)
	    {
	        vec3 _23135;
	        _23135.x = input_4.x;
	        _23135.y = input_4.y;
	        _13136 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _23135.xy).xyz;
	        _16305 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _23135.xy).xyzw;
	        _13960 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _23135.xy).xyzw;
	        _22402 = _23135;
	    }
	    else
	    {
	        _13136 = vec3(0.0);
	        _16305 = vec4(0.0);
	        _13960 = vec4(0.0);
	        _22402 = vec3(0.0);
	    }
	    vec3 _14435 = cross(input_3.xyz, input_7.xyz) * _22035;
	    bool _14875 = _Globals_.bBiplanarUsedAny != 0;
	    ivec2 _11056;
	    vec2 _13137;
	    ivec2 _15689;
	    vec2 _16306;
	    vec2 _17114;
	    vec2 _17115;
	    vec2 _17116;
	    vec2 _17117;
	    vec2 _17118;
	    if (_14875)
	    {
	        vec3 _10577 = abs(_24347);
	        vec3 _16100 = _10577;
	        float _17349 = _10577.x;
	        float _8043 = _10577.y;
	        bool _12887;
	        if (_17349 > _8043)
	        {
	            _12887 = _17349 > _10577.z;
	        }
	        else
	        {
	            _12887 = false;
	        }
	        ivec3 _23727;
	        if (_12887)
	        {
	            _23727 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            _23727 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_8043 > _10577.z));
	        }
	        bool _12888;
	        if (_17349 < _8043)
	        {
	            _12888 = _17349 < _10577.z;
	        }
	        else
	        {
	            _12888 = false;
	        }
	        ivec3 _11775;
	        if (_12888)
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
	        _13137 = vec2(_16418[_19321.x], _16418[_19321.y]);
	        _16306 = vec2(_16418[_19322.x], _16418[_19322.y]);
	        _17114 = vec2(_16419[_19321.x], _16419[_19321.y]);
	        _17115 = vec2(_16446[_19321.x], _16446[_19321.y]);
	        _17116 = vec2(_16419[_19322.x], _16419[_19322.y]);
	        _17117 = vec2(_16446[_19322.x], _16446[_19322.y]);
	        _17118 = _19651 / vec2(_19651.x + _19651.y);
	        _15689 = _19322;
	        _11056 = _19321;
	    }
	    else
	    {
	        _13137 = _6;
	        _16306 = _6;
	        _17114 = _6;
	        _17115 = _6;
	        _17116 = _6;
	        _17117 = _6;
	        _17118 = _6;
	        _15689 = _5;
	        _11056 = _5;
	    }
	    bool _8452 = _Globals_.g_nUVSet1 == 0;
	    vec3 _9716;
	    vec2 _24878;
	    if (_8452)
	    {
	        _9716 = _10061.xyz * _Globals_.g_vBiplanarTexCoordScale.xyz;
	        _24878 = _Globals_.g_vTexCoordScale1.xy;
	    }
	    else
	    {
	        _9716 = _22402;
	        _24878 = vec2(0.0);
	    }
	    vec4 _22411 = vec4(_13960.xyz, 1.0);
	    vec4 _10468 = vec4((_22411 * mat4(vec4(_Globals_.g_mTextureColorAdjust1._m0[0].x, _Globals_.g_mTextureColorAdjust1._m0[1].x, _Globals_.g_mTextureColorAdjust1._m0[2].x, _Globals_.g_mTextureColorAdjust1._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].y, _Globals_.g_mTextureColorAdjust1._m0[1].y, _Globals_.g_mTextureColorAdjust1._m0[2].y, _Globals_.g_mTextureColorAdjust1._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].z, _Globals_.g_mTextureColorAdjust1._m0[1].z, _Globals_.g_mTextureColorAdjust1._m0[2].z, _Globals_.g_mTextureColorAdjust1._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].w, _Globals_.g_mTextureColorAdjust1._m0[1].w, _Globals_.g_mTextureColorAdjust1._m0[2].w, _Globals_.g_mTextureColorAdjust1._m0[3].w))).xyz, _4);
	    vec4 _9356 = mix(_13960, vec4((_22411 * mat4(vec4(_Globals_.g_mTextureAdjust1._m0[0].x, _Globals_.g_mTextureAdjust1._m0[1].x, _Globals_.g_mTextureAdjust1._m0[2].x, _Globals_.g_mTextureAdjust1._m0[3].x), vec4(_Globals_.g_mTextureAdjust1._m0[0].y, _Globals_.g_mTextureAdjust1._m0[1].y, _Globals_.g_mTextureAdjust1._m0[2].y, _Globals_.g_mTextureAdjust1._m0[3].y), vec4(_Globals_.g_mTextureAdjust1._m0[0].z, _Globals_.g_mTextureAdjust1._m0[1].z, _Globals_.g_mTextureAdjust1._m0[2].z, _Globals_.g_mTextureAdjust1._m0[3].z), vec4(_Globals_.g_mTextureAdjust1._m0[0].w, _Globals_.g_mTextureAdjust1._m0[1].w, _Globals_.g_mTextureAdjust1._m0[2].w, _Globals_.g_mTextureAdjust1._m0[3].w))).xyz, _13960.w), bvec4(_Globals_.g_bAdjustBaseColor1 != 0));
	    bool _15258 = _Globals_.g_nUVSet2 == 0;
	    float _13138;
	    float _16307;
	    vec2 _16863;
	    vec3 _17119;
	    float _17152;
	    if (_15258)
	    {
	        _13138 = 0.0;
	        _16307 = 0.0;
	        _17119 = _10061.xyz * _Globals_.g_vBiplanarTexCoordScale.xyz;
	        _17152 = 0.0;
	        _16863 = _Globals_.g_vTexCoordScale2.xy;
	    }
	    else
	    {
	        vec3 _23136;
	        _23136.x = input_4.z;
	        _23136.y = input_4.w;
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _23136.xy);
	        _13138 = _19372.y;
	        _16307 = _19372.w;
	        _17119 = _23136;
	        _17152 = _19372.x;
	        _16863 = vec2(0.0);
	    }
	    float _13142;
	    float _13961;
	    vec3 _16311;
	    vec4 _17124;
	    float _17125;
	    float _17126;
	    float _17127;
	    vec3 _17128;
	    float _17129;
	    float _17130;
	    vec4 _23645;
	    if (_14875)
	    {
	        float _13140;
	        vec3 _16309;
	        vec3 _16864;
	        float _17120;
	        float _17121;
	        vec4 _17153;
	        if (_8452)
	        {
	            vec3 _14690 = _14435.xyz;
	            vec2 _8312 = (_13137 * _24878).xy;
	            vec2 _7410 = (_17114 * _24878).xy;
	            vec2 _8901 = (_17115 * _24878).xy;
	            vec2 _16083 = (_16306 * _24878).xy;
	            vec2 _14628 = (_17116 * _24878).xy;
	            vec2 _8902 = (_17117 * _24878).xy;
	            vec4 _9696 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _8312, _7410, _8901) * _17118.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _16083, _14628, _8902) * _17118.y);
	            vec4 _11179 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _8312, _7410, _8901);
	            float _15751 = _11179.x;
	            float _17299 = _11179.y;
	            float _16783 = (_15751 + _17299) - 1.00392162799835205078125;
	            float _11176 = _15751 - _17299;
	            vec3 _21631 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176))).xyz * _17118.x;
	            vec3 _18849 = _21631;
	            _18849.x = _21631.x * ((int(sign(dot(input_7.xyz, _2757[_11056.x]))) < 0) ? (-1.0) : 1.0);
	            _18849.y = _21631.y * ((int(sign(dot(_14690, _2757[_11056.y]))) < 0) ? (-1.0) : 1.0);
	            vec4 _11180 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _16083, _14628, _8902);
	            float _15752 = _11180.x;
	            float _17300 = _11180.y;
	            float _16784 = (_15752 + _17300) - 1.00392162799835205078125;
	            float _11177 = _15752 - _17300;
	            vec3 _21632 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _17118.y;
	            vec4 _13681;
	            _13681.z = _21632.z;
	            _13681.x = _21632.x * ((int(sign(dot(input_7.xyz, _2757[_15689.x]))) < 0) ? (-1.0) : 1.0);
	            _13681.y = _21632.y * ((int(sign(dot(_14690, _2757[_15689.y]))) < 0) ? (-1.0) : 1.0);
	            vec3 _15733 = _18849.xyz + _13681.xyz;
	            vec2 _11003 = _15733.xy * _Globals_.g_fTextureNormalContrast1;
	            vec3 _8673 = _15733;
	            _8673.x = _11003.x;
	            _8673.y = _11003.y;
	            bool _12889;
	            if (_14874)
	            {
	                _12889 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	            }
	            else
	            {
	                _12889 = false;
	            }
	            bool _24327;
	            if (_12889)
	            {
	                _24327 = (gl_FrontFacing ? 1.0 : (-1.0)) < 0.0;
	            }
	            else
	            {
	                _24327 = false;
	            }
	            vec3 _14436 = cross((input_3.xyz * (_24327 ? (-1.0) : 1.0)).xyz, input_7.xyz) * _22035;
	            vec3 _12501;
	            if (notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0)).w)
	            {
	                _12501 = -_14436;
	            }
	            else
	            {
	                _12501 = _14436;
	            }
	            _13140 = _9696.y;
	            _16309 = _8673;
	            _17120 = _9696.x;
	            _17121 = _9696.w;
	            _17153 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _8312, _7410, _8901) * _17118.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _16083, _14628, _8902) * _17118.y);
	            _16864 = _12501;
	        }
	        else
	        {
	            float _20452 = mix(_Globals_.g_vAmbientOcclusionLevels1.x, _Globals_.g_vAmbientOcclusionLevels1.z, pow(_9356.w, _Globals_.g_vAmbientOcclusionLevels1.y));
	            float _15161 = clamp(((_Globals_.g_fTintMaskContrast1 * (_16305.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness1, 0.0, 1.0);
	            vec3 _25173 = mix(_9356.xyz, _10468.xyz, vec3(_15161));
	            vec4 _12346 = vec4(_25173, _20452);
	            float _24324 = dot(_12346.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	            vec3 _9578 = normalize(max(input_1.xyz, vec3(0.001000000047497451305389404296875)));
	            _13140 = _15161;
	            _16309 = _13136;
	            _17120 = _16305.x;
	            _17121 = _16305.w * float(_Globals_.g_bMetalness1 != 0);
	            _17153 = vec4(clamp(mix(_12346.xyz, (_9578 * min(_24324 / dot(_9578.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _24324) * max(input_1.x, max(input_1.y, input_1.z)))).xyz, vec3((input_1.w * _15161) * float(_Globals_.g_bModelTint1 != 0))), vec3(0.0), vec3(1.0)).xyz, _20452);
	            _16864 = _14435;
	        }
	        vec3 _13141;
	        vec4 _16310;
	        float _16480;
	        float _17122;
	        float _17123;
	        float _17192;
	        if (_15258)
	        {
	            vec2 _8313 = (_13137 * _16863).xy;
	            vec2 _7411 = (_17114 * _16863).xy;
	            vec2 _8903 = (_17115 * _16863).xy;
	            vec2 _16084 = (_16306 * _16863).xy;
	            vec2 _14629 = (_17116 * _16863).xy;
	            vec2 _8904 = (_17117 * _16863).xy;
	            vec4 _9697 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _8313, _7411, _8903) * _17118.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], undetermined[_Globals_.g_sUserConfig]), _16084, _14629, _8904) * _17118.y);
	            vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], undetermined[_Globals_.g_sUserConfig]), _8313, _7411, _8903);
	            float _15456 = _12167.x;
	            float _24534 = _12167.y;
	            float _16785 = (_15456 + _24534) - 1.00392162799835205078125;
	            float _11178 = _15456 - _24534;
	            vec3 _21633 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _17118.x;
	            vec3 _18851 = _21633;
	            _18851.x = _21633.x * ((int(sign(dot(input_7.xyz, _2757[_11056.x]))) < 0) ? (-1.0) : 1.0);
	            _18851.y = _21633.y * ((int(sign(dot(_16864.xyz, _2757[_11056.y]))) < 0) ? (-1.0) : 1.0);
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], undetermined[_Globals_.g_sUserConfig]), _16084, _14629, _8904);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16786 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11181 = _13491 - _21308;
	            vec3 _21634 = normalize(vec3(vec2(_16786, _11181), (1.0 - abs(_16786)) - abs(_11181))).xyz * _17118.y;
	            vec4 _13682;
	            _13682.z = _21634.z;
	            _13682.x = _21634.x * ((int(sign(dot(input_7.xyz, _2757[_15689.x]))) < 0) ? (-1.0) : 1.0);
	            _13682.y = _21634.y * ((int(sign(dot(_16864.xyz, _2757[_15689.y]))) < 0) ? (-1.0) : 1.0);
	            vec3 _15734 = _18851.xyz + _13682.xyz;
	            vec2 _11004 = _15734.xy * _Globals_.g_fTextureNormalContrast2;
	            vec3 _8674 = _15734;
	            _8674.x = _11004.x;
	            float _21775 = _11004.y;
	            _8674.y = _21775;
	            vec3 _12865 = _8674.xyz;
	            bool _12890;
	            if (_14874)
	            {
	                _12890 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	            }
	            else
	            {
	                _12890 = false;
	            }
	            bool _24328;
	            if (_12890)
	            {
	                _24328 = (gl_FrontFacing ? 1.0 : (-1.0)) < 0.0;
	            }
	            else
	            {
	                _24328 = false;
	            }
	            vec3 _9740 = input_3.xyz * (_24328 ? (-1.0) : 1.0);
	            vec3 _14437 = cross(_9740.xyz, input_7.xyz) * _22035;
	            vec3 _7424;
	            if (notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0)).w)
	            {
	                _7424 = -_14437;
	            }
	            else
	            {
	                _7424 = _14437;
	            }
	            vec3 _20480;
	            if (!_24328)
	            {
	                vec3 _16556 = _12865;
	                _16556.y = -_21775;
	                _20480 = _16556;
	            }
	            else
	            {
	                _20480 = _12865;
	            }
	            _13141 = normalize((((input_7.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_9740.xyz * _20480.z)).xyz);
	            _16310 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], undetermined[_Globals_.g_sUserConfig]), _8313, _7411, _8903) * _17118.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], undetermined[_Globals_.g_sUserConfig]), _16084, _14629, _8904) * _17118.y);
	            _17122 = _9697.y;
	            _17123 = (_12167.z * _17118.x) + (_12168.z * _17118.y);
	            _17192 = _9697.w;
	            _16480 = _9697.x;
	        }
	        else
	        {
	            _13141 = vec3(0.0, 0.0, 1.0);
	            _16310 = vec4(0.5);
	            _17122 = 0.5;
	            _17123 = 0.5;
	            _17192 = 0.5;
	            _16480 = 0.5;
	        }
	        _13142 = _13140;
	        _16311 = _13141;
	        _17124 = _16310;
	        _17125 = _17122;
	        _17126 = _17123;
	        _17127 = _17192;
	        _17128 = _16309;
	        _17129 = _16480;
	        _17130 = _17120;
	        _13961 = _17121;
	        _23645 = _17153;
	    }
	    else
	    {
	        float _13139;
	        float _16308;
	        vec4 _16479;
	        float _17190;
	        if (_19330)
	        {
	            float _20451 = mix(_Globals_.g_vAmbientOcclusionLevels1.x, _Globals_.g_vAmbientOcclusionLevels1.z, pow(_9356.w, _Globals_.g_vAmbientOcclusionLevels1.y));
	            float _15160 = clamp(((_Globals_.g_fTintMaskContrast1 * (_16305.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness1, 0.0, 1.0);
	            vec3 _25172 = mix(_9356.xyz, _10468.xyz, vec3(_15160));
	            vec4 _12345 = vec4(_25172, _20451);
	            float _24323 = dot(_12345.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	            vec3 _9577 = normalize(max(input_1.xyz, vec3(0.001000000047497451305389404296875)));
	            _13139 = _15160;
	            _16308 = _16305.x;
	            _17190 = _16305.w * float(_Globals_.g_bMetalness1 != 0);
	            _16479 = vec4(clamp(mix(_12345.xyz, (_9577 * min(_24323 / dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _24323) * max(input_1.x, max(input_1.y, input_1.z)))).xyz, vec3((input_1.w * _15160) * float(_Globals_.g_bModelTint1 != 0))), vec3(0.0), vec3(1.0)).xyz, _20451);
	        }
	        else
	        {
	            _13139 = 0.0;
	            _16308 = 0.0;
	            _17190 = 0.0;
	            _16479 = _9356;
	        }
	        _13142 = _13139;
	        _16311 = vec3(0.0);
	        _17124 = vec4(0.0);
	        _17125 = _13138;
	        _17126 = 0.0;
	        _17127 = _16307;
	        _17128 = _13136;
	        _17129 = _17152;
	        _17130 = _16308;
	        _13961 = _17190;
	        _23645 = _16479;
	    }
	    float _7068 = float(_Globals_.g_bSnowLayer1 != 0);
	    vec2 _6383 = textureQueryLod(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _9716.xy);
	    float _14915 = _6383.x;
	    float _7460 = fwidth(_17130 * _Globals_.g_flHeightMapScale1);
	    float _16827 = fwidth(_17129 * _Globals_.g_flHeightMapScale2);
	    float _23621 = ((_14915 * _14915) * 0.004999999888241291046142578125) * ((0.100000001490116119384765625 + ((_7460 + _16827) * 2.0)) * _Globals_.g_flBlendSoftnessDistanceModifierStrength);
	    float _13965 = max(min(input_0.w + _Globals_.g_flBlendSoftness2, 1.0), 9.9999997473787516355514526367188e-05) + _23621;
	    float _6579 = _23621 * 0.5;
	    float _14400 = _Globals_.g_flHeightMapZeroPoint1 + _6579;
	    float _21726 = _Globals_.g_flHeightMapScale1 + _13965;
	    float _9176 = (_17130 - _14400) * _21726;
	    vec3 _18392;
	    _18392.x = _9176;
	    bool _14876 = _Globals_.g_bWetnessUseHeightmapAdjustments != 0;
	    float _21711;
	    if (_14876)
	    {
	        _21711 = max(0.0, ((_17130 + 0.5) - _14400) * _Globals_.g_flHeightMapScale1);
	    }
	    else
	    {
	        _21711 = _17130;
	    }
	    float _14438 = _Globals_.g_flHeightMapZeroPoint2 + _6579;
	    float _23339 = _Globals_.g_flHeightMapScale2 + _13965;
	    float _16787 = (_17128.x + _17128.y) - 1.00392162799835205078125;
	    float _11182 = _17128.x - _17128.y;
	    vec3 _14896 = normalize(vec3(vec2(_16787, _11182), (1.0 - abs(_16787)) - abs(_11182)));
	    vec2 _21659 = _14896.xy;
	    vec2 _11005 = vec2(dot(_21659, _Globals_.g_vNormalXform_1.xy), dot(_21659, _Globals_.g_vNormalXform_1.zw)) * _Globals_.g_fTextureNormalContrast1;
	    float _15073 = _11005.x;
	    vec3 _8675 = _14896;
	    _8675.x = _15073;
	    float _21813 = _11005.y;
	    _8675.y = _21813;
	    bvec3 _20911 = bvec3(_17559);
	    vec3 _10844 = abs(_8675.xyz);
	    vec2 _16475 = (-vec2(_15073, (-1.0) * _21813)) / vec2(max(_10844.z, 0.0078125 * max(_10844.x, _10844.y)));
	    float _14894 = clamp(((_Globals_.g_fTextureRoughnessContrast1 * (_17128.z - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness1, 0.0, 1.0);
	    vec3 _15210 = normalize(_8889 - ((mix(_9521, _11730, _20911) * _16475.x) + (mix(_15323, _10074, _20911) * _16475.y))).xyz;
	    float _11621;
	    if (_Globals_.bBlendByFacingDirection2 != 0)
	    {
	        _11621 = _9110 * smoothstep(_Globals_.g_vFacingDirectionMinMax2.x, _Globals_.g_vFacingDirectionMinMax2.y, (dot(_Globals_.g_vFacingDirection2.xyz, mix(_15210, _24347.xyz, vec3(min(1.0, _Globals_.g_flBlendSoftness2 + _Globals_.g_vFacingDirectionMaskSoftness2))).xyz) * 0.5) + 0.5);
	    }
	    else
	    {
	        _11621 = _9110;
	    }
	    float _11036;
	    if (_14876)
	    {
	        _11036 = max(0.0, ((_17129 + 0.5) - _14438) * _Globals_.g_flHeightMapScale2);
	    }
	    else
	    {
	        _11036 = _17129;
	    }
	    float _7453 = ((_17129 - _14438) * (_Globals_.g_flHeightMapScale2 - _13965)) + mix((((-_14400) * _21726) - ((1.0 - _14438) * _23339)) - _13965, ((1.0 - _14400) * _21726) - ((-_14438) * _23339), _11621);
	    _18392.y = _7453;
	    vec2 _8095 = max((_18392.xy - vec2(max(_9176, _7453))) + vec2(_13965), vec2(0.0));
	    float _6647 = clamp(((_8095.xy / vec2((_8095.x + 9.9999997473787516355514526367188e-05) + _8095.y)).y * mix(0.5, _11036, _Globals_.g_flMaskWithHeight2)) * 2.0, 0.0, 1.0);
	    vec2 _16668 = dFdx(_17119.xy);
	    vec2 _11616 = dFdy(_17119.xy);
	    bool _9698 = _6647 > 0.0500000007450580596923828125;
	    float _13144;
	    vec3 _16312;
	    vec4 _16865;
	    float _17132;
	    float _17154;
	    if (_9698)
	    {
	        float _6616;
	        vec4 _12891;
	        vec3 _13143;
	        if (_Globals_.g_nUVSet2 != 0)
	        {
	            vec2 _7970 = _16668.xy;
	            vec2 _10524 = _11616.xy;
	            vec4 _11183 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], undetermined[_Globals_.g_sUserConfig]), _17119.xy, _7970, _10524);
	            float _15753 = _11183.x;
	            float _17301 = _11183.y;
	            float _16788 = (_15753 + _17301) - 1.00392162799835205078125;
	            float _11184 = _15753 - _17301;
	            vec3 _14897 = normalize(vec3(vec2(_16788, _11184), (1.0 - abs(_16788)) - abs(_11184)));
	            vec2 _21660 = _14897.xy;
	            vec2 _11006 = vec2(dot(_21660, _Globals_.g_vNormalXform_2.xy), dot(_21660, _Globals_.g_vNormalXform_2.zw)) * _Globals_.g_fTextureNormalContrast2;
	            float _15074 = _11006.x;
	            vec3 _8682 = _14897;
	            _8682.x = _15074;
	            float _21814 = _11006.y;
	            _8682.y = _21814;
	            bvec3 _24600 = bvec3(_Globals_.g_nUVSet2 == 1);
	            vec3 _10845 = abs(_8682.xyz);
	            vec2 _16476 = (-vec2(_15074, (-1.0) * _21814)) / vec2(max(_10845.z, 0.0078125 * max(_10845.x, _10845.y)));
	            _13143 = normalize(_8889 - ((mix(_11730, _9521, _24600) * _16476.x) + (mix(_10074, _15323, _24600) * _16476.y)));
	            _12891 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], undetermined[_Globals_.g_sUserConfig]), _17119.xy, _7970, _10524).xyzw;
	            _6616 = _11183.z;
	        }
	        else
	        {
	            _13143 = _16311;
	            _12891 = _17124;
	            _6616 = _17126;
	        }
	        float _17240 = clamp(((_Globals_.g_fTintMaskContrast2 * (_17125 - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness2, 0.0, 1.0);
	        vec4 _22412 = vec4(_12891.xyz, 1.0);
	        vec4 _21907 = mix(_12891, vec4((_22412 * mat4(vec4(_Globals_.g_mTextureAdjust2._m0[0].x, _Globals_.g_mTextureAdjust2._m0[1].x, _Globals_.g_mTextureAdjust2._m0[2].x, _Globals_.g_mTextureAdjust2._m0[3].x), vec4(_Globals_.g_mTextureAdjust2._m0[0].y, _Globals_.g_mTextureAdjust2._m0[1].y, _Globals_.g_mTextureAdjust2._m0[2].y, _Globals_.g_mTextureAdjust2._m0[3].y), vec4(_Globals_.g_mTextureAdjust2._m0[0].z, _Globals_.g_mTextureAdjust2._m0[1].z, _Globals_.g_mTextureAdjust2._m0[2].z, _Globals_.g_mTextureAdjust2._m0[3].z), vec4(_Globals_.g_mTextureAdjust2._m0[0].w, _Globals_.g_mTextureAdjust2._m0[1].w, _Globals_.g_mTextureAdjust2._m0[2].w, _Globals_.g_mTextureAdjust2._m0[3].w))).xyz, _12891.w), bvec4(_Globals_.g_bAdjustBaseColor2 != 0));
	        vec3 _25174 = mix(_21907.xyz, vec4((_22412 * mat4(vec4(_Globals_.g_mTextureColorAdjust2._m0[0].x, _Globals_.g_mTextureColorAdjust2._m0[1].x, _Globals_.g_mTextureColorAdjust2._m0[2].x, _Globals_.g_mTextureColorAdjust2._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust2._m0[0].y, _Globals_.g_mTextureColorAdjust2._m0[1].y, _Globals_.g_mTextureColorAdjust2._m0[2].y, _Globals_.g_mTextureColorAdjust2._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust2._m0[0].z, _Globals_.g_mTextureColorAdjust2._m0[1].z, _Globals_.g_mTextureColorAdjust2._m0[2].z, _Globals_.g_mTextureColorAdjust2._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust2._m0[0].w, _Globals_.g_mTextureColorAdjust2._m0[1].w, _Globals_.g_mTextureColorAdjust2._m0[2].w, _Globals_.g_mTextureColorAdjust2._m0[3].w))).xyz, _4).xyz, vec3(_17240));
	        float _20928 = mix(_Globals_.g_vAmbientOcclusionLevels2.x, _Globals_.g_vAmbientOcclusionLevels2.z, pow(_21907.w, _Globals_.g_vAmbientOcclusionLevels2.y));
	        vec4 _10870 = vec4(_25174, _20928);
	        float _24325 = dot(_10870.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        vec3 _9579 = normalize(max(input_1.xyz, vec3(0.001000000047497451305389404296875)));
	        _13144 = _17240;
	        _16312 = mix(mix(_15210, normalize(mix(_24347, (_15210 + _13143.xyz) * vec3(0.5), vec3(2.0))), vec3(_6647 * _Globals_.g_flNormalCombine2)), _13143.xyz, vec3((_6647 * clamp((_7453 + _14438) - _9176, 0.0, 1.0)) * _Globals_.g_flNormalReplace2));
	        _17132 = _17127 * float(_Globals_.g_bMetalness2 != 0);
	        _17154 = clamp(((_Globals_.g_fTextureRoughnessContrast2 * (_6616 - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness2, 0.0, 1.0);
	        _16865 = vec4(clamp(mix(_10870.xyz, (_9579 * min(_24325 / dot(_9579.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _24325) * max(input_1.x, max(input_1.y, input_1.z)))).xyz, vec3((input_1.w * _17240) * float(_Globals_.g_bModelTint2 != 0))), vec3(0.0), vec3(1.0)).xyz, _20928);
	    }
	    else
	    {
	        _13144 = _17125;
	        _16312 = _15210;
	        _17132 = _17127;
	        _17154 = _17126;
	        _16865 = _17124;
	    }
	    float _13145;
	    vec3 _13381;
	    float _14948;
	    float _16313;
	    float _17134;
	    float _17135;
	    if (_9698)
	    {
	        vec3 _22672 = _16865.xyz * 12.9200000762939453125;
	        vec3 _7485 = (pow(_16865.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	        float _21354;
	        if (_16865.x <= 0.003130800090730190277099609375)
	        {
	            _21354 = _22672.x;
	        }
	        else
	        {
	            _21354 = _7485.x;
	        }
	        float _21355;
	        if (_16865.y <= 0.003130800090730190277099609375)
	        {
	            _21355 = _22672.y;
	        }
	        else
	        {
	            _21355 = _7485.y;
	        }
	        float _20653;
	        if (_16865.z <= 0.003130800090730190277099609375)
	        {
	            _20653 = _22672.z;
	        }
	        else
	        {
	            _20653 = _7485.z;
	        }
	        _13145 = mix(_13961 * mix(1.0, _17132 * 2.0, _6647 * _Globals_.g_flMetalnessCombine2), _17132, _6647 * _Globals_.g_flMetalnessReplace2);
	        _16313 = mix(_23645.w * mix(1.0, _16865.w, _6647 * _Globals_.g_flAOCombine2), _16865.w, _6647 * _Globals_.g_flAOReplace2);
	        _17134 = mix(_21711, _11036, _6647);
	        _17135 = mix(_14894 * (1.0 + ((((_17154 - _14894) * 2.0) * _6647) * _Globals_.g_flRoughnessCombine2)), _17154, _6647 * _Globals_.g_flRoughnessReplace2);
	        _14948 = mix(_7068, float(_Globals_.g_bSnowLayer2 != 0), _6647);
	        _13381 = mix(_23645.xyz * mix(vec3(1.0), vec3(_21354, _21355, _20653) * 2.0, vec3(_6647 * _Globals_.g_flColorOverlay2)), _16865.xyz, vec3(_6647 * _Globals_.g_flColorReplace2));
	    }
	    else
	    {
	        _13145 = _13961;
	        _16313 = _23645.w;
	        _17134 = _17130;
	        _17135 = _14894;
	        _14948 = _7068;
	        _13381 = _23645.xyz;
	    }
	    float _13984 = saturate(1.0 - _6647);
	    vec3 _13969 = _13381 * mix(vec3(1.0), input_5.xyz, vec3(clamp(clamp(((float(!(_Globals_.g_bMaskVertexColor1 != 0)) * _13984) + (float(!(_Globals_.g_bMaskVertexColor2 != 0)) * _6647)) + ((_13142 * _13984) + (_13144 * _6647)), 0.0, 1.0) * ((float(_Globals_.g_bVertexColorEnabled1 != 0) * _13984) + (float(_Globals_.g_bVertexColorEnabled2 != 0) * _6647)), 0.0, 1.0)));
	    vec2 _22449 = vec2(_17135);
	    bool _12892;
	    if (_Globals_.g_bWetness != 0)
	    {
	        _12892 = (_Globals_.g_fPuddleStrength + _Globals_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _12892 = false;
	    }
	    vec3 _6618;
	    vec3 _13148;
	    float _13694;
	    vec2 _16314;
	    float _17137;
	    vec3 _17138;
	    float _17139;
	    if (_12892)
	    {
	        vec4 _19373 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], undetermined[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14499 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_0.z, saturate(PerViewConstantBufferCsgo_t._m12)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m13 - 0.5) * 2.0));
	        float _18408 = saturate(_23204 - 0.75) * 2.0;
	        float _8285 = _23204 + (_18408 * _18408);
	        float _16777 = _8285 - _Globals_.g_fWetEdgeSpread;
	        float _11964 = saturate(_8285 * 20.0);
	        vec4 _9717;
	        float _24879;
	        if (_Globals_.g_bPuddlesOnVerticalSurfaces != 0)
	        {
	            vec4 _9186 = vec4(0.0, 0.0, 1.0, 0.0);
	            _9186.x = _24347.x;
	            _9186.y = _24347.y;
	            _9186.z = _21302;
	            _9717 = _9186;
	            _24879 = max(0.0, _16777);
	        }
	        else
	        {
	            _9717 = vec4(0.0, 0.0, 1.0, 0.0);
	            _24879 = max(0.0, (_8285 * _14499) - _Globals_.g_fWetEdgeSpread);
	        }
	        float _16799 = max(0.001000000047497451305389404296875, _Globals_.g_fPuddleBlendSoftness);
	        float _14611 = smoothstep(_24879 + _16799, _24879 - (input_0.w + (_16799 * 2.0)), _17134) * _11964;
	        float _19808 = max((smoothstep(_23204, _16777 - (0.20000000298023223876953125 * _8285), _17134) * _Globals_.g_fWetEdgeStrength) * _11964, _14611) * _Globals_.g_fPuddleStrength;
	        float _17924 = (_23204 - 1.0) - _17134;
	        float _10334 = (saturate(_17924 + _Globals_.g_fPuddleSedimentHeight) * _Globals_.g_fPuddleSedimentOpacity) * _14611;
	        float _13706 = clamp(((clamp((((_8285 * 2.0) - (mix(0.5, _19373.w, saturate(_14499 * 20.0)) * 0.5)) - (_17134 * 0.5)) + 0.25, 0.0, 1.0) * _Globals_.g_fWetnessStrength) * _11964) + _14611, 0.0, 1.0);
	        float _13147;
	        float _13151;
	        vec4 _23607;
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m10;
	            vec3 _6617;
	            vec4 _12893;
	            float _13146;
	            if (_12497 > 0.0)
	            {
	                vec3 _18756 = normalize(vec3(-1.0, 0.20000000298023223876953125, 0.0));
	                float _9925 = PerViewConstantBufferCsgo_t._m11 * 6.283185482025146484375;
	                float _22373 = sin(_9925);
	                float _20617 = cos(_9925);
	                vec2 _23932 = _18756.xy * mat2(vec2(_20617, -_22373), vec2(_22373, _20617));
	                vec3 _22900 = _18756;
	                _22900.x = _23932.x;
	                _22900.y = _23932.y;
	                vec3 _21326 = -cross(_22900, _24347);
	                vec3 _13887 = _10061.xyz;
	                float _9965 = dot(_13887, _21326);
	                float _12056 = 1.0 - input_0.z;
	                vec2 _20275 = ((vec2(dot(_13887, _22900)) + (vec2(0.100000001490116119384765625, -0.100000001490116119384765625) * _9965)) + (vec2(8.0, 5.0) * _10061.z)) + vec2((_12056 * _12056) * (-80.0));
	                vec2 _15991 = vec2(_20275.x, _9965) * vec2(0.0199999995529651641845703125, 0.010999999940395355224609375);
	                vec4 _15054 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], undetermined[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                float _18070 = clamp(length(fwidth(_15991)) * 10.0, 0.0, 1.0);
	                vec2 _18922 = (_15054.xy * 2.0) - vec2(1.0);
	                vec2 _10456 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_0.z) * mix(1.0, 0.300000011920928955078125, _18070);
	                vec2 _13710 = _21326.xy;
	                vec4 _19601 = vec4(0.0);
	                _19601.x = dot(_22900.xy, _10456);
	                _19601.y = dot(_13710, _10456);
	                vec2 _16050 = (vec2(_20275.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _15055 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], undetermined[_Globals_.g_sUserConfig]), (_16050 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                float _9252 = clamp(length(fwidth(_16050)) * 10.0, 0.0, 1.0);
	                vec2 _9825 = ((((_15055.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_0.z) * mix(1.0, 0.300000011920928955078125, _9252);
	                _9825.y = _9825.y * 0.5;
	                vec2 _13330 = _19601.xy + vec2(dot(_22900.xy, _9825), dot(_13710, _9825));
	                vec4 _20488 = _19601;
	                _20488.x = _13330.x;
	                _20488.y = _13330.y;
	                _20488.w = input_0.z * (_15054.z + _15055.z);
	                vec3 _20489;
	                _20489.x = _10061.x;
	                _20489.y = _10061.y;
	                _13146 = _12497 * (0.039999999105930328369140625 * (_18070 + _9252));
	                _12893 = _9717 + ((_20488 * _14499) * _12497);
	                _6617 = _20489;
	            }
	            else
	            {
	                _13146 = 0.0;
	                _12893 = _9717;
	                _6617 = _10061;
	            }
	            float _8914 = (_Globals_.g_fRainStrength * PerViewConstantBufferCsgo_t._m9) * PerViewConstantBufferCsgo_t._m9;
	            float _9982;
	            vec4 _21594;
	            if (_8914 > 0.0)
	            {
	                vec2 _10473 = _6617.xy * 0.119999997317790985107421875;
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
	                    float _23411 = _20506[_16208];
	                    vec2 _10212 = ((_21666 * _10473) * _16409[_16208]) + vec2(_23411 * 0.0199999995529651641845703125);
	                    vec2 _7848 = _21666 * ((fract(_10212) * 2.0) - vec2(1.0));
	                    float _8329 = length(_7848);
	                    float _20173 = clamp(1.0 - (_8329 * mix(3.0, 1.0, _14611)), 0.0, 1.0);
	                    float _20213 = clamp(1.0 - (_8329 * 6.0), 0.0, 1.0);
	                    float _7135 = floor(fract(_10212.x * 0.100000001490116119384765625) * 10.0);
	                    float _23598 = _20506[_16208];
	                    float _18429 = _23598 + ((_7135 + (floor(fract(_10212.y * 0.100000001490116119384765625) * 10.0) * (0.20000000298023223876953125 + _7135))) * 8.0);
	                    _20506[_16208] = _18429;
	                    float _18120 = _8914 * _8914;
	                    _25251 = vec3(_13155.xy + (((-(((((_7848 / vec2(_8329)) * cos(mix(1.0, (_20173 * 40.0) + (PerViewConstantBuffer_t._m0 * 65.0), _14611))) * _20173) * _20173) * mix(2.0, 0.25, clamp(fwidth(_20173) * 20.0, 0.0, 1.0)))) * ((clamp((sin(((_20173 * mix(1.0, 4.0, _14611)) + _18429) * _8914) - (1.0 - ((0.20000000298023223876953125 * _18120) * mix(0.25, 1.0, _14611)))) * 2.0, 0.0, 1.0) * _20173) / _18120)) * mix(16.0, 2.0, _14611)), _13155.z + (((clamp((sin((((_20213 + _18429) + 4.0) + (sin(_17134 * 60.0) * 0.25)) * _8914) - (1.0 - (_18120 * 0.02000000141561031341552734375))) * 2.0, 0.0, 1.0) * _20213) / _18120) * 28.0));
	                    _18440 = _16208 + 1;
	                    _13155 = _25251;
	                    _16208 = _18440;
	                    continue;
	                }
	                vec3 _9348 = _13155 * _14499;
	                vec2 _15754 = _12893.xy + _9348.xy;
	                vec4 _20490 = _12893;
	                _20490.x = _15754.x;
	                _20490.y = _15754.y;
	                _9982 = _9348.z;
	                _21594 = _20490;
	            }
	            else
	            {
	                _9982 = 0.0;
	                _21594 = _12893;
	            }
	            vec3 _10508 = normalize(_21594.xyz);
	            vec4 _16886 = _21594;
	            _16886.x = _10508.x;
	            _16886.y = _10508.y;
	            _16886.z = _10508.z;
	            _13147 = _9982;
	            _13151 = _13146;
	            _23607 = _16886;
	        }
	        else
	        {
	            _13147 = 0.0;
	            _13151 = 0.0;
	            _23607 = _9717;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _13711 = normalize(mix(_16312.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m13 * 2.0)), _19808);
	        vec3 _18806 = mix(_13969, pow(_13969, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_13969, vec3(0.25)) * (_9038 * _17135)) * 8.0, vec3(0.0), vec3(1.0)) * mix(_Globals_.g_flWetnessDarkeningStrength1, _Globals_.g_flWetnessDarkeningStrength2, _6647 * _Globals_.g_flColorReplace2));
	        _13148 = mix(_16312, _23607.xyz, vec3(_19808 * _10334));
	        _16314 = clamp(mix(_22449.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13711.xyz)) * 0.5)), vec2(0.0), vec2(1.0));
	        _17137 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17138 = _13711;
	        _17139 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _13694 = mix(_16313, 1.0, _19808);
	        _6618 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _16313, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, vec3(_10334 * _19808)), vec3(1.0 + _13147), vec3(_13147 * 0.100000001490116119384765625));
	    }
	    else
	    {
	        _13148 = _16312;
	        _16314 = _22449;
	        _17137 = _Globals_.g_flReflectance;
	        _17138 = vec3(1.0);
	        _17139 = 0.0;
	        _13694 = _16313;
	        _6618 = _13969;
	    }
	    vec3 _14796;
	    switch (_Globals_.g_nVisualization)
	    {
	        case 0u:
	        {
	            _14796 = _6618;
	            break;
	        }
	        case 1u:
	        {
	            _14796 = vec3(_13984, _6647, 0.0);
	            break;
	        }
	        case 2u:
	        {
	            _14796 = vec3((mix(_9176, _7453, _6647) * 0.5) + 0.5);
	            break;
	        }
	        case 3u:
	        {
	            _14796 = vec3(input_0.xyz);
	            break;
	        }
	        default:
	        {
	            _14796 = _6618;
	            break;
	        }
	    }
	    float _9987 = max(_13694, 0.0);
	    vec3 _9455 = mix(vec3(_17137).xyz, _14796.xyz, vec3(_13145));
	    vec3 _17892 = mix(_17138, _13148, bvec3(all(equal(_17138, vec3(1.0)))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _13392 = max(_16314.xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    bvec4 _24466 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21785;
	    if (_24466.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11088 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m16) * PerViewConstantBufferCsgo_t._m15.xy) + (PerViewConstantBufferCsgo_t._m15.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], undetermined[_Globals_.g_sCookieSampler]), _11088).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m15.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12287 = abs(_15372) < _20965;
	        vec2 _23169;
	        if (_12287)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m15.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _17422 = (max(vec4(dot(PerViewLightingConstantBufferGpu_t._m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[3].xyz, _11394)).xyzw, vec4(0.0)).xyzw * PerViewLightingConstantBufferGpu_t._m2.xyzw).xyzw;
	        _21785 = (1.0 / (dot(_17422, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_17422, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], undetermined[_Globals_.g_sPointClamp]), (_11088 + mix(_23169, PerViewConstantBufferCsgo_t._m15.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0).xyzw));
	    }
	    else
	    {
	        _21785 = 1.0;
	    }
	    vec4 _23875 = vec4(_13148.xyz, 1.0);
	    float _21712;
	    if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13152;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	            {
	                _13152 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_2.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].w));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m13[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - clamp((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14), vec2(0.0), vec2(1.0));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                vec3 _20491 = _19470;
	                _20491.x = _20561.x;
	                _20491.y = _20561.y;
	                _13152 = saturate(_22193.x * _22193.y);
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
	            float _12502;
	            if (_13152 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                {
	                    int _15337 = _10191 + 1;
	                    vec4 _19671 = vec4(input_2.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[0].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[1].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[2].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[0].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[1].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[2].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[0].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[1].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[2].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[0].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[1].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[2].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15337]._m0[3].w));
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15337].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15337].xy;
	                    vec3 _20492;
	                    _20492.x = _20562.x;
	                    _20492.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20492.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12502 = mix(_7934, _18270, _13152);
	            }
	            else
	            {
	                _12502 = _18270;
	            }
	            _18423 = _12502;
	        }
	        else
	        {
	            _18423 = 1.0;
	        }
	        float _13279 = mix(_18423, 1.0, clamp((distance(_10061.xyz, PerViewConstantBuffer_t._m4) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16, 0.0, 1.0));
	        float _12503;
	        if (_24466.y)
	        {
	            _12503 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m6], undetermined[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12503 = _13279;
	        }
	        _21712 = _12503;
	    }
	    else
	    {
	        _21712 = 1.0;
	    }
	    vec3 _9718;
	    vec3 _24880;
	    if ((dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _13148.xyz) * _21712) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _13148.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_13148.xyz, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18225;
	        if (_17139 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m9.xyz);
	            float _8124 = saturate(_17139);
	            _18225 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * clamp((_8780 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_13148.xyz, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m9.xyz), 1.0, _8124), 0.0, 1.0)), vec3(_8124));
	        }
	        else
	        {
	            _18225 = _17874;
	        }
	        vec2 _17302 = max(_13392, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, _15460.xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _17302.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _21712).xyz;
	        _9718 = ((_9455.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
	        _24880 = PerViewLightingConstantBufferGpu_t._m4.xyz + (_18225.xyz * _16808);
	    }
	    else
	    {
	        _9718 = vec3(0.0);
	        _24880 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24467 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20061 = _24467.x;
	    vec4 _19363;
	    if (_20061)
	    {
	        vec4 _24261 = vec4(_10061.xyz, 1.0).xyzw * mat4(vec4(PerViewConstantBufferCsgo_t._m14._m0[0].x, PerViewConstantBufferCsgo_t._m14._m0[1].x, PerViewConstantBufferCsgo_t._m14._m0[2].x, PerViewConstantBufferCsgo_t._m14._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m14._m0[0].y, PerViewConstantBufferCsgo_t._m14._m0[1].y, PerViewConstantBufferCsgo_t._m14._m0[2].y, PerViewConstantBufferCsgo_t._m14._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m14._m0[0].z, PerViewConstantBufferCsgo_t._m14._m0[1].z, PerViewConstantBufferCsgo_t._m14._m0[2].z, PerViewConstantBufferCsgo_t._m14._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m14._m0[0].w, PerViewConstantBufferCsgo_t._m14._m0[1].w, PerViewConstantBufferCsgo_t._m14._m0[2].w, PerViewConstantBufferCsgo_t._m14._m0[3].w));
	        float _20176 = _24261.w;
	        vec2 _11414 = _24261.xy / vec2(_20176);
	        vec4 _6652;
	        _6652.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6652.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6652.w = _20176;
	        _19363 = _6652;
	    }
	    else
	    {
	        _19363 = _11408;
	    }
	    uvec2 _12083 = uvec2(_19363.xy - PerViewConstantBuffer_t._m1.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13153;
	    vec3 _16324;
	    _13153 = _9718;
	    _16324 = _24880;
	    uint _21567;
	    vec3 _13154;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13154 = _13153;
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
	                float _21776 = _10521.z;
	                _22905.z = _21776;
	                vec3 _21642 = _22905.xyz;
	                bool _7425;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7425 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7425 = false;
	                }
	                bool _12894;
	                if (!_7425)
	                {
	                    _12894 = true;
	                }
	                else
	                {
	                    _12894 = !all(lessThanEqual(abs((mat4x3(vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].x, g_BarnLights_1._m0[_12608]._m15._m0[1].x, g_BarnLights_1._m0[_12608]._m15._m0[2].x), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].y, g_BarnLights_1._m0[_12608]._m15._m0[1].y, g_BarnLights_1._m0[_12608]._m15._m0[2].y), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].z, g_BarnLights_1._m0[_12608]._m15._m0[1].z, g_BarnLights_1._m0[_12608]._m15._m0[2].z), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].w, g_BarnLights_1._m0[_12608]._m15._m0[1].w, g_BarnLights_1._m0[_12608]._m15._m0[2].w)) * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12894)
	                {
	                    _13212 = _13154;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23573 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23573 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = min(1.0, _21776 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * min(1.0, (1.0 - _21776) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11186;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - input_2.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10017 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _12302;
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
	                    _11186 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * clamp(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647), 0.0, 1.0)) * clamp(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23573 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))), 0.0, 1.0);
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
	                    _24419 = !_20061;
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
	                    vec3 _12504;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11186).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23597 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23597 * _15156)) + cross(_23597, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20494 = _14081;
	                        _20494.x = _20564.x;
	                        _20494.y = _20564.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sTrilinearWrap]), _20494.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20493 = _13791;
	                        _20493.x = _20563.x;
	                        _20493.y = _20563.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sCookieSampler]), _20493.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12504;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13154;
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
	                        _13212 = _13154;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _21549 = _20482;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15461 = mix(_17892, _13148.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_13148.xyz, _11186.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18229;
	                if (_17139 > 0.0)
	                {
	                    float _8781 = dot(_15461, _11186.xyz);
	                    float _8125 = saturate(_17139);
	                    _18229 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * clamp((_8781 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_13148.xyz, _15461, vec3(10.0)), _11186.xyz), 1.0, _8125), 0.0, 1.0)), vec3(_8125));
	                }
	                else
	                {
	                    _18229 = _17875;
	                }
	                vec2 _17303 = max(_13392, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11186.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, _15461.xyz);
	                float _19211 = max(0.0, dot(_11186.xyz, _12282));
	                float _9851 = _17303.x;
	                float _25215 = _9851 * _9851;
	                float _19097 = _25215 * _25215;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13212 = _13154.xyz + (((_9455.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
	                _15670 = _16325.xyz + (_18229.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13154 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13153 = _13154;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_13392.xy, vec2(0.5));
	    vec3 _7507 = _17892.xyz;
	    vec3 _17140 = normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec4 _15343 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15343.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17140).xyz, _7507)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _19842 = _8745 * vec3(_21785 * _9987).xyz;
	    vec3 _13436 = vec3(_9987 * _21785).xyz;
	    vec3 _19630;
	    if (_14948 > 0.0)
	    {
	        _19630 = mix(_19842, pow(_19842, vec3(1.0499999523162841796875, 0.949999988079071044921875, 0.800000011920928955078125)), vec3(_14948));
	    }
	    else
	    {
	        _19630 = _19842;
	    }
	    vec3 _22686 = ((_16324.xyz * vec3(_21785)).xyz + _19630.xyz) * (_14796.xyz * (1.0 - _13145)).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, input_5.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15757 = _11203.xyz + (_13153.xyz * _13436).xyz;
	    vec4 _20496 = _11203;
	    _20496.x = _15757.x;
	    _20496.y = _15757.y;
	    _20496.z = _15757.z;
	    vec3 _15736 = _20496.xyz + ((((mix(_11427.xxx, _11427.yyy, _9455) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17140.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _13436).xyz;
	    vec4 _13888 = _20496;
	    _13888.x = _15736.x;
	    _13888.y = _15736.y;
	    _13888.z = _15736.z;
	    vec4 _6911;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22956 = _10061.xyz - PerViewConstantBuffer_t._m4.xyz;
	        vec3 _9057 = _22956.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12895;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m20.x)
	            {
	                _12895 = (_10061.z * PerViewConstantBufferCsgo_t._m20.z) < PerViewConstantBufferCsgo_t._m20.y;
	            }
	            else
	            {
	                _12895 = false;
	            }
	            if (_12895)
	            {
	                vec2 _9342 = clamp(PerViewConstantBufferCsgo_t._m17.xy + (PerViewConstantBufferCsgo_t._m17.zw * vec2(length(_21493), _10061.z)), vec2(0.0), vec2(1.0));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m18.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m18.y)) * PerViewConstantBufferCsgo_t._m19.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m19.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _13888;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12896;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m24.x)
	            {
	                _12896 = (PerViewConstantBufferCsgo_t._m24.z * _10061.z) < PerViewConstantBufferCsgo_t._m24.y;
	            }
	            else
	            {
	                _12896 = false;
	            }
	            if (_12896)
	            {
	                float _14602 = clamp(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m21.y) + PerViewConstantBufferCsgo_t._m21.x), PerViewConstantBufferCsgo_t._m21.w), 0.0, 1.0) * clamp(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m22.y) + PerViewConstantBufferCsgo_t._m22.x), PerViewConstantBufferCsgo_t._m22.z), 0.0, 1.0);
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m24.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m3], undetermined[_Globals_.g_sTrilinearClamp]), normalize((mat4(vec4(PerViewConstantBufferCsgo_t._m23._m0[0].x, PerViewConstantBufferCsgo_t._m23._m0[1].x, PerViewConstantBufferCsgo_t._m23._m0[2].x, PerViewConstantBufferCsgo_t._m23._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m23._m0[0].y, PerViewConstantBufferCsgo_t._m23._m0[1].y, PerViewConstantBufferCsgo_t._m23._m0[2].y, PerViewConstantBufferCsgo_t._m23._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m23._m0[0].z, PerViewConstantBufferCsgo_t._m23._m0[1].z, PerViewConstantBufferCsgo_t._m23._m0[2].z, PerViewConstantBufferCsgo_t._m23._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m23._m0[0].w, PerViewConstantBufferCsgo_t._m23._m0[1].w, PerViewConstantBufferCsgo_t._m23._m0[2].w, PerViewConstantBufferCsgo_t._m23._m0[3].w)) * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m22.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m21.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m25.x).xyz, _8892).xyz, vec3(_8892));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _6911 = _23944;
	    }
	    else
	    {
	        _6911 = _13888;
	    }
	    vec4 _6805;
	    if (_Globals_.g_nVisualization != 0u)
	    {
	        vec3 _10599 = mix(_6911.xyz, _14796, vec3(0.999000012874603271484375));
	        vec4 _17842 = _6911;
	        _17842.x = _10599.x;
	        _17842.y = _10599.y;
	        _17842.z = _10599.z;
	        _6805 = _17842;
	    }
	    else
	    {
	        _6805 = _6911;
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
		IntAttribute(MaterialLayerCount, 3);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
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
	bool bBlendByFacingDirection2 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_2==2); >;
	bool bBlendByFacingDirection3 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_3==2); >;
	bool bGeoBlendByFacingDirection2 < UiType(CheckBox); Expression((F_BLEND_BY_FACING_DIRECTION_2>0) || 0); >;
	bool bGeoBlendByFacingDirection3 < UiType(CheckBox); Expression((F_BLEND_BY_FACING_DIRECTION_3>0) || 0); >;
	bool bVertexBlendByFacingDirection3 < UiType(CheckBox); Expression((F_BLEND_BY_FACING_DIRECTION_3==1) || 0); >;
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
	int g_nVisualization < UiType(Slider); Expression(F_VISUALIZATION); >;
	float2 g_vFacingDirectionMinMax2 < UiType(VectorText); Expression(float2(max(0,(1-g_flFacingDirectionMaskSpread2)-g_vFacingDirectionMaskFalloff2),min(1,((1-g_flFacingDirectionMaskSpread2)+.001)+g_vFacingDirectionMaskFalloff2))); >;
	float2 g_vFacingDirectionMinMax3 < UiType(VectorText); Expression(float2(max(0,(1-g_flFacingDirectionMaskSpread3)-g_vFacingDirectionMaskFalloff3),min(1,((1-g_flFacingDirectionMaskSpread3)+.001)+g_vFacingDirectionMaskFalloff3))); >;
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
	float3 g_vTextureColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2,0/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Lighting/12"); >;
	float g_fTextureNormalContrast2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Lighting/13"); >;
	bool g_bMetalness2 < Default(1); UiType(CheckBox); UiGroup("Material2/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flNormalReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/20"); >;
	CreateInputTexture2D(TextureMetalness2, Linear, 8, "", "_metal", "Material2/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/30"); >;
	float g_flHeightMapZeroPoint2 < Default(0.5); UiType(Slider); UiGroup("Material2/Height/30"); >;
	float g_flNormalCombine2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Selective Blending/30"); >;
	float g_fTextureColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Color Correction/40"); >;
	float g_flBlendSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Height,30/40"); >;
	float g_flRoughnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/40"); >;
	float3 g_vFacingDirection2 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material2/Height/40"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flUnderlyingHeightMapInfluence2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height,30/41"); >;
	float g_flRoughnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/45"); >;
	int g_nColorCorrectionMode2 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material2/Color Correction/45"); >;
	float g_flFacingDirectionMaskSpread2 < Default(0.5); UiType(Slider); UiGroup("Material2/Height/50"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flMetalnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/50"); >;
	float g_flMetalnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/55"); >;
	float g_vFacingDirectionMaskFalloff2 < Default(0.1); Range(0, 0.5); UiType(Slider); UiGroup("Material2/Height/55"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	bool g_bModelTint2 < Default(1); UiType(CheckBox); UiGroup("Material2/Color Correction/60"); >;
	int g_nVertexColorMode2 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material2/Color Correction/60"); >;
	float g_vFacingDirectionMaskSoftness2 < UiType(Slider); UiGroup("Material2/Height/60"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2==2); >;
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
	float3 g_vTextureColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3,2/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Lighting/12"); >;
	float g_fTextureNormalContrast3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Lighting/13"); >;
	bool g_bMetalness3 < Default(1); UiType(CheckBox); UiGroup("Material3/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flNormalReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/20"); >;
	CreateInputTexture2D(TextureMetalness3, Linear, 8, "", "_metal", "Material3/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/30"); >;
	float g_flHeightMapZeroPoint3 < Default(0.5); UiType(Slider); UiGroup("Material3/Height/30"); >;
	float g_flNormalCombine3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Selective Blending/30"); >;
	float g_fTextureColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Color Correction/40"); >;
	float g_flBlendSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Height,30/40"); >;
	float g_flRoughnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/40"); >;
	float3 g_vFacingDirection3 < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material3/Height/40"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flUnderlyingHeightMapInfluence3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height,30/41"); >;
	float g_flRoughnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/45"); >;
	int g_nColorCorrectionMode3 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material3/Color Correction/45"); >;
	float g_flFacingDirectionMaskSpread3 < Default(0.5); UiType(Slider); UiGroup("Material3/Height/50"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flMetalnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/50"); >;
	float g_flMetalnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/55"); >;
	float g_vFacingDirectionMaskFalloff3 < Default(0.1); Range(0, 0.5); UiType(Slider); UiGroup("Material3/Height/55"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	int g_nVertexColorMode3 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material3/Color Correction/60"); >;
	float g_vFacingDirectionMaskSoftness3 < UiType(Slider); UiGroup("Material3/Height/60"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3==2); >;
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
	float3 g_vColorOverlayTintMaskStrengths < Default3(1, 1, 1); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/65"); >;
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
	
	// Wetness
	bool g_bWetnessUseHeightmapAdjustments < UiType(CheckBox); UiGroup("Wetness/2"); UiVisibility(F_WETNESS || 0); >;
	
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
	// SPIR-V source (156396 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec3 _g_fl_AutoPad32_;
	    bool _m1;
	    int _m2;
	    float _m3;
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
	    float _m15;
	    float _m16;
	    bool _m17;
	    int _m18;
	    float _m19;
	    vec2 _m20;
	    vec2 _m21;
	    float _m22;
	    float _m23;
	    vec2 _m24;
	    float _m25;
	    float _m26;
	    vec4 _m27;
	    vec4 _m28;
	    vec4 _m29;
	    float _m30;
	    uint _m31;
	    uint _m32;
	    float _m33;
	    float _m34;
	    float _m35;
	    float _m36;
	    float _m37;
	    vec3 _m38;
	    float _m39;
	    vec3 _m40;
	    float _m41;
	    float _m42;
	    float _m43;
	    int _m44;
	    bool _m45;
	    float _m46;
	    float _m47;
	    int _m48;
	    bool _m49;
	    bool _m50;
	    float _m51;
	    float _m52;
	    float _m53;
	    bool _m54;
	    bool _m55;
	    float _m56;
	    float _m57;
	    mat4 _m58;
	    mat4 _m59;
	    float _m60;
	    float _m61;
	    float _m62;
	    float _m63;
	    float _m64;
	    float _m65;
	    float _m66;
	    float _m67;
	    float _m68;
	    float _m69;
	    float _m70;
	    float _m71;
	    float _m72;
	    float _m73;
	    bool _m74;
	    float _m75;
	    float _m76;
	    uint _m77;
	    uint _m78;
	    uint _m79;
	    vec3 _m80;
	    float _m81;
	    vec3 _m82;
	    float _m83;
	    float _m84;
	    float _m85;
	    int _m86;
	    bool _m87;
	    mat4 _m88;
	    mat4 _m89;
	    float _m90;
	    float _m91;
	    float _m92;
	    float _m93;
	    vec3 _m94;
	    float _m95;
	    float _m96;
	    float _m97;
	    vec2 _m98;
	    float _m99;
	    float _m100;
	    int _m101;
	    bool _m102;
	    bool _m103;
	    bool _m104;
	    bool _m105;
	    bool _m106;
	    float _m107;
	    float _m108;
	    float _m109;
	    float _m110;
	    vec3 _m111;
	    float _m112;
	    float _m113;
	    float _m114;
	    float _m115;
	    float _m116;
	    float _m117;
	    float _m118;
	    float _m119;
	    float _m120;
	    int _m121;
	    int _m122;
	    bool _m123;
	    float _m124;
	    vec4 _m125;
	    vec4 _m126;
	    vec2 _m127;
	    float _m128;
	    float _m129;
	    vec2 _m130;
	    float _m131;
	    float _m132;
	    vec4 _m133;
	    float _m134;
	    float _m135;
	    float _m136;
	    float _m137;
	    vec4 _m138;
	    vec2 _m139;
	    vec2 _m140;
	    float _m141;
	    float _m142;
	    vec2 _m143;
	    vec4 _m144;
	    vec4 _m145;
	    vec2 _m146;
	    int _m147;
	    int _m148;
	    bool _m149;
	    float _m150;
	    float _m151;
	    float _m152;
	    vec4 _m153;
	    vec4 _m154;
	    vec3 _m155;
	    float _m156;
	    bool _m157;
	    bool _m158;
	    bool _m159;
	    bool _m160;
	    bool _m161;
	    uint _m162;
	    uint _m163;
	    uint _m164;
	    uint _m165;
	    uint _m166;
	    int _m167;
	    int _m168;
	    uint _m169;
	    uint _m170;
	    uint _m171;
	    bool _m172;
	    bool _m173;
	    bool _m174;
	    float _m175;
	    uint _m176;
	    float _m177;
	    float _m178;
	    bool _m179;
	    bool _m180;
	    bool _m181;
	    bool _m182;
	    bool _m183;
	    bool _m184;
	    bool _m185;
	    bool _m186;
	    bool _m187;
	    bool _m188;
	    bool _m189;
	    bool _m190;
	    bool _m191;
	    uint _m192;
	    bool _m193;
	    bool _m194;
	    float _m195;
	    float _m196;
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
	
	const vec3 _591[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, -1.0));
	
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
	
	float _645;
	
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
	    _RTX_MATERIAL_DATA_ _2355 = _RTX_MATERIAL_DATA_(vec3(g_MaterialData_1._m0[g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 4u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 8u) / 4u]), g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 12u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 16u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 20u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 24u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 28u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 32u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 36u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 40u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 44u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 48u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 52u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 56u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 60u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 64u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 68u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 72u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 76u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 80u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 84u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 88u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 92u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 96u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 100u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 104u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 108u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 112u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 116u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 120u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 124u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 132u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 140u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 152u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 156u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 160u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 164u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 168u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 172u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 176u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 180u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 184u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 188u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 192u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 196u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 200u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 204u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 212u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 216u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 220u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 224u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 228u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 232u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 236u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 240u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 244u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 248u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 252u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 256u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 260u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 264u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 268u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 272u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 276u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 280u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 284u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 288u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 292u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 296u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 300u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 304u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 324u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 328u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 332u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 336u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 340u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 344u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 348u) / 4u], mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 352u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 368u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 384u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 400u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 356u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 372u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 388u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 404u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 360u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 376u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 392u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 408u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 364u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 380u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 396u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 412u) / 4u])), mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 416u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 432u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 448u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 464u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 420u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 436u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 452u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 468u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 424u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 440u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 456u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 472u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 428u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 444u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 460u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 476u) / 4u])), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 480u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 484u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 488u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 492u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 496u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 500u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 504u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 508u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 512u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 516u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 520u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 524u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 528u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 532u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 536u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 540u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 544u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 548u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 552u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 556u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 560u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 564u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 568u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 572u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 576u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 580u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 584u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 588u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 592u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 596u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 600u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 604u) / 4u] != 0, mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 608u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 624u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 640u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 656u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 612u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 628u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 644u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 660u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 616u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 632u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 648u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 664u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 620u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 636u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 652u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 668u) / 4u])), mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 672u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 688u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 704u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 720u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 676u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 692u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 708u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 724u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 680u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 696u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 712u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 728u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 684u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 700u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 716u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 732u) / 4u])), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 736u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 740u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 744u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 748u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 752u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 756u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 760u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 764u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 768u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 772u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 776u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 780u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 784u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 788u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 792u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 796u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 800u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 804u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 808u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 812u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 816u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 820u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 824u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 828u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 832u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 836u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 840u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 844u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 848u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 852u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 856u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 860u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 864u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 868u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 872u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 876u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 880u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 884u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 888u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 892u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 896u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 900u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 904u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 908u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 912u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 916u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 920u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 924u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 928u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 932u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 936u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 940u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 944u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 948u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 952u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 956u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 960u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 964u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 968u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 972u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 976u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 980u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 984u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 988u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 992u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 996u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1000u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1004u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1008u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1012u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1016u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1020u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1024u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1028u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1032u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1036u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1040u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1044u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1048u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1052u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1056u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1060u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1064u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1068u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1072u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1076u) / 4u]), g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1080u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1084u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1088u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1092u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1096u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1100u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1104u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1108u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1112u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1116u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1124u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1132u) / 4u]), vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1140u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1144u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1148u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1152u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1156u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1160u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1164u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1168u) / 4u] != 0, g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1172u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1176u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1180u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1184u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1188u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1192u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1196u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1200u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1204u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1208u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1212u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1216u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1220u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1224u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1228u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1232u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1236u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1240u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1244u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1248u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1252u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1256u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1260u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1264u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1268u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1272u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1276u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1280u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1284u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1288u) / 4u] != 0, g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1292u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1296u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1300u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1304u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 1308u) / 4u]);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _2355;
	    uvec3 _938;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _2416 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _938 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2416 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_2416 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_2416 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _2391 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _2392 = _2391 & 4294967292u;
	            uint _2393 = _2392 / 4u;
	            uint _2397 = (_2392 + 4u) / 4u;
	            uint _2402 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2393] & 4294901760u) >> uint(16);
	            uint _2403 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2397] & 65535u;
	            uvec3 _939;
	            if (_2391 == _2392)
	            {
	                _939 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2393] & 65535u, _2402, _2403);
	            }
	            else
	            {
	                _939 = uvec3(_2402, _2403, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_2397] & 4294901760u) >> uint(16));
	            }
	            _938 = _939;
	            break;
	        }
	        break;
	    } while(false);
	    uint _2431 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _2439 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _938) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _932[3];
	    uint _2441 = _2439.x;
	    _932[0] = vec3(g_Vertices_1[_2431]._m0[_2441 / 4u], g_Vertices_1[_2431]._m0[(_2441 + 4u) / 4u], g_Vertices_1[_2431]._m0[(_2441 + 8u) / 4u]);
	    uint _2455 = _2439.y;
	    _932[1] = vec3(g_Vertices_1[_2431]._m0[_2455 / 4u], g_Vertices_1[_2431]._m0[(_2455 + 4u) / 4u], g_Vertices_1[_2431]._m0[(_2455 + 8u) / 4u]);
	    uint _2469 = _2439.z;
	    _932[2] = vec3(g_Vertices_1[_2431]._m0[_2469 / 4u], g_Vertices_1[_2431]._m0[(_2469 + 4u) / 4u], g_Vertices_1[_2431]._m0[(_2469 + 8u) / 4u]);
	    int _933 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_933 < 3))
	        {
	            break;
	        }
	        vsInput[_933].vColorBlendValues = _932[_933];
	        _933++;
	        continue;
	    }
	    vec2 _934[3];
	    _934[0] = vec2(0.0);
	    _934[1] = vec2(0.0);
	    _934[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _931 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2512 = uint(_931[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _2514 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _929 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _930 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2525 = (uvec3(uint(_929[_2514])) * _938) + uvec3(uint(_930[_2514]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _2660 = _2525.x;
	            _934[0] = vec2(g_Vertices_1[_2512]._m0[_2660 / 4u], g_Vertices_1[_2512]._m0[(_2660 + 4u) / 4u]);
	            uint _2669 = _2525.y;
	            _934[1] = vec2(g_Vertices_1[_2512]._m0[_2669 / 4u], g_Vertices_1[_2512]._m0[(_2669 + 4u) / 4u]);
	            uint _2678 = _2525.z;
	            _934[2] = vec2(g_Vertices_1[_2512]._m0[_2678 / 4u], g_Vertices_1[_2512]._m0[(_2678 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _2631 = _2525.x / 4u;
	                _934[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2512]._m0[_2631], g_Vertices_3[_2512]._m0[_2631] >> uint(16)) & uvec2(65535u))));
	                uint _2641 = _2525.y / 4u;
	                _934[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2512]._m0[_2641], g_Vertices_3[_2512]._m0[_2641] >> uint(16)) & uvec2(65535u))));
	                uint _2651 = _2525.z / 4u;
	                _934[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2512]._m0[_2651], g_Vertices_3[_2512]._m0[_2651] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _2538 = _2525.x / 4u;
	                    uint _2542 = (g_Vertices_3[_2512]._m0[_2538] & 65535u);
	                    int _928;
	                    if (_2542 > 32767u)
	                    {
	                        _928 = int(4294901760u | _2542);
	                    }
	                    else
	                    {
	                        _928 = int(_2542);
	                    }
	                    uint _2555 = (g_Vertices_3[_2512]._m0[_2538] & 4294901760u) >> uint(16);
	                    int _927;
	                    if (_2555 > 32767u)
	                    {
	                        _927 = int(4294901760u | _2555);
	                    }
	                    else
	                    {
	                        _927 = int(_2555);
	                    }
	                    _934[0] = vec2(max(float(_928) * 3.0518509447574615478515625e-05, -1.0), max(float(_927) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2569 = _2525.y / 4u;
	                    uint _2573 = (g_Vertices_3[_2512]._m0[_2569] & 65535u);
	                    int _926;
	                    if (_2573 > 32767u)
	                    {
	                        _926 = int(4294901760u | _2573);
	                    }
	                    else
	                    {
	                        _926 = int(_2573);
	                    }
	                    uint _2586 = (g_Vertices_3[_2512]._m0[_2569] & 4294901760u) >> uint(16);
	                    int _925;
	                    if (_2586 > 32767u)
	                    {
	                        _925 = int(4294901760u | _2586);
	                    }
	                    else
	                    {
	                        _925 = int(_2586);
	                    }
	                    _934[1] = vec2(max(float(_926) * 3.0518509447574615478515625e-05, -1.0), max(float(_925) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2600 = _2525.z / 4u;
	                    uint _2604 = (g_Vertices_3[_2512]._m0[_2600] & 65535u);
	                    int _924;
	                    if (_2604 > 32767u)
	                    {
	                        _924 = int(4294901760u | _2604);
	                    }
	                    else
	                    {
	                        _924 = int(_2604);
	                    }
	                    uint _2617 = (g_Vertices_3[_2512]._m0[_2600] & 4294901760u) >> uint(16);
	                    int _923;
	                    if (_2617 > 32767u)
	                    {
	                        _923 = int(4294901760u | _2617);
	                    }
	                    else
	                    {
	                        _923 = int(_2617);
	                    }
	                    _934[2] = vec2(max(float(_924) * 3.0518509447574615478515625e-05, -1.0), max(float(_923) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _933 = 0;
	    for (;;)
	    {
	        if (!(_933 < 3))
	        {
	            break;
	        }
	        vsInput[_933]._m1 = _934[_933];
	        _933++;
	        continue;
	    }
	    _934[0] = vec2(0.0);
	    _934[1] = vec2(0.0);
	    _934[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _922 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2717 = uint(_922[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _2719 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _920 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _921 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2730 = (uvec3(uint(_920[_2719])) * _938) + uvec3(uint(_921[_2719]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _2865 = _2730.x;
	            _934[0] = vec2(g_Vertices_1[_2717]._m0[_2865 / 4u], g_Vertices_1[_2717]._m0[(_2865 + 4u) / 4u]);
	            uint _2874 = _2730.y;
	            _934[1] = vec2(g_Vertices_1[_2717]._m0[_2874 / 4u], g_Vertices_1[_2717]._m0[(_2874 + 4u) / 4u]);
	            uint _2883 = _2730.z;
	            _934[2] = vec2(g_Vertices_1[_2717]._m0[_2883 / 4u], g_Vertices_1[_2717]._m0[(_2883 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _2836 = _2730.x / 4u;
	                _934[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2717]._m0[_2836], g_Vertices_3[_2717]._m0[_2836] >> uint(16)) & uvec2(65535u))));
	                uint _2846 = _2730.y / 4u;
	                _934[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2717]._m0[_2846], g_Vertices_3[_2717]._m0[_2846] >> uint(16)) & uvec2(65535u))));
	                uint _2856 = _2730.z / 4u;
	                _934[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_2717]._m0[_2856], g_Vertices_3[_2717]._m0[_2856] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _2743 = _2730.x / 4u;
	                    uint _2747 = (g_Vertices_3[_2717]._m0[_2743] & 65535u);
	                    int _919;
	                    if (_2747 > 32767u)
	                    {
	                        _919 = int(4294901760u | _2747);
	                    }
	                    else
	                    {
	                        _919 = int(_2747);
	                    }
	                    uint _2760 = (g_Vertices_3[_2717]._m0[_2743] & 4294901760u) >> uint(16);
	                    int _918;
	                    if (_2760 > 32767u)
	                    {
	                        _918 = int(4294901760u | _2760);
	                    }
	                    else
	                    {
	                        _918 = int(_2760);
	                    }
	                    _934[0] = vec2(max(float(_919) * 3.0518509447574615478515625e-05, -1.0), max(float(_918) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2774 = _2730.y / 4u;
	                    uint _2778 = (g_Vertices_3[_2717]._m0[_2774] & 65535u);
	                    int _917;
	                    if (_2778 > 32767u)
	                    {
	                        _917 = int(4294901760u | _2778);
	                    }
	                    else
	                    {
	                        _917 = int(_2778);
	                    }
	                    uint _2791 = (g_Vertices_3[_2717]._m0[_2774] & 4294901760u) >> uint(16);
	                    int _916;
	                    if (_2791 > 32767u)
	                    {
	                        _916 = int(4294901760u | _2791);
	                    }
	                    else
	                    {
	                        _916 = int(_2791);
	                    }
	                    _934[1] = vec2(max(float(_917) * 3.0518509447574615478515625e-05, -1.0), max(float(_916) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2805 = _2730.z / 4u;
	                    uint _2809 = (g_Vertices_3[_2717]._m0[_2805] & 65535u);
	                    int _915;
	                    if (_2809 > 32767u)
	                    {
	                        _915 = int(4294901760u | _2809);
	                    }
	                    else
	                    {
	                        _915 = int(_2809);
	                    }
	                    uint _2822 = (g_Vertices_3[_2717]._m0[_2805] & 4294901760u) >> uint(16);
	                    int _914;
	                    if (_2822 > 32767u)
	                    {
	                        _914 = int(4294901760u | _2822);
	                    }
	                    else
	                    {
	                        _914 = int(_2822);
	                    }
	                    _934[2] = vec2(max(float(_915) * 3.0518509447574615478515625e-05, -1.0), max(float(_914) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _933 = 0;
	    for (;;)
	    {
	        if (!(_933 < 3))
	        {
	            break;
	        }
	        vsInput[_933]._m2 = _934[_933];
	        _933++;
	        continue;
	    }
	    vec3 _935[3];
	    vec4 _936[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _900 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _2925 = uint(_900[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _2927 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _898 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _899 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2938 = (uvec3(uint(_898[_2927])) * _938) + uvec3(uint(_899[_2927]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _3469 = _2938.x;
	                _935[0] = vec3(g_Vertices_1[_2925]._m0[_3469 / 4u], g_Vertices_1[_2925]._m0[(_3469 + 4u) / 4u], g_Vertices_1[_2925]._m0[(_3469 + 8u) / 4u]);
	                uint _3483 = _2938.y;
	                _935[1] = vec3(g_Vertices_1[_2925]._m0[_3483 / 4u], g_Vertices_1[_2925]._m0[(_3483 + 4u) / 4u], g_Vertices_1[_2925]._m0[(_3483 + 8u) / 4u]);
	                uint _3497 = _2938.z;
	                _935[2] = vec3(g_Vertices_1[_2925]._m0[_3497 / 4u], g_Vertices_1[_2925]._m0[(_3497 + 4u) / 4u], g_Vertices_1[_2925]._m0[(_3497 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _3202 = _2938.x;
	                    uvec2 _3210 = uvec2(g_Vertices_3[_2925]._m0[_3202 / 4u], g_Vertices_3[_2925]._m0[(_3202 + 4u) / 4u]);
	                    uint _3211 = _2938.y;
	                    uvec2 _667 = uvec2(g_Vertices_3[_2925]._m0[_3211 / 4u], g_Vertices_3[_2925]._m0[(_3211 + 4u) / 4u]);
	                    uint _3220 = _2938.z;
	                    uvec2 _666 = uvec2(g_Vertices_3[_2925]._m0[_3220 / 4u], g_Vertices_3[_2925]._m0[(_3220 + 4u) / 4u]);
	                    uint _3232 = _3210.x;
	                    uint _3241 = _3210.y;
	                    vec2 _3251 = ((vec2(float((_3232) & 65535u), float((_3232 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3252 = _3251.x;
	                    float _3257 = (1.0 - abs(_3252)) - abs(_3251.y);
	                    vec3 _3258 = vec3(_3252, _3251.y, _3257);
	                    float _3260 = saturate(-_3257);
	                    vec2 _3266 = _3251 + mix(vec2(_3260), vec2(-_3260), greaterThanEqual(_3251, vec2(0.0)));
	                    _3258.x = _3266.x;
	                    _3258.y = _3266.y;
	                    vec3 _908 = normalize(_3258);
	                    vec2 _3273 = ((vec2(float((_3241 >> uint(1)) & 32767u), float((_3241 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3274 = _3273.x;
	                    float _3279 = (1.0 - abs(_3274)) - abs(_3273.y);
	                    vec3 _3280 = vec3(_3274, _3273.y, _3279);
	                    float _3282 = saturate(-_3279);
	                    vec2 _3288 = _3273 + mix(vec2(_3282), vec2(-_3282), greaterThanEqual(_3273, vec2(0.0)));
	                    _3280.x = _3288.x;
	                    _3280.y = _3288.y;
	                    vec3 _907 = normalize(_3280);
	                    float _888;
	                    if ((_3241 & 1u) != 0u)
	                    {
	                        _888 = 1.0;
	                    }
	                    else
	                    {
	                        _888 = -1.0;
	                    }
	                    _935[0] = _908;
	                    _936[0].w = _888;
	                    _936[0].x = _907.x;
	                    _936[0].y = _907.y;
	                    _936[0].z = _907.z;
	                    vec2 _3331 = ((vec2(float((_667.x) & 65535u), float((_667.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3332 = _3331.x;
	                    float _3337 = (1.0 - abs(_3332)) - abs(_3331.y);
	                    vec3 _3338 = vec3(_3332, _3331.y, _3337);
	                    float _3340 = saturate(-_3337);
	                    vec2 _3346 = _3331 + mix(vec2(_3340), vec2(-_3340), greaterThanEqual(_3331, vec2(0.0)));
	                    _3338.x = _3346.x;
	                    _3338.y = _3346.y;
	                    vec3 _910 = normalize(_3338);
	                    vec2 _3353 = ((vec2(float((_667.y >> uint(1)) & 32767u), float((_667.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3354 = _3353.x;
	                    float _3359 = (1.0 - abs(_3354)) - abs(_3353.y);
	                    vec3 _3360 = vec3(_3354, _3353.y, _3359);
	                    float _3362 = saturate(-_3359);
	                    vec2 _3368 = _3353 + mix(vec2(_3362), vec2(-_3362), greaterThanEqual(_3353, vec2(0.0)));
	                    _3360.x = _3368.x;
	                    _3360.y = _3368.y;
	                    vec3 _909 = normalize(_3360);
	                    float _887;
	                    if ((_667.y & 1u) != 0u)
	                    {
	                        _887 = 1.0;
	                    }
	                    else
	                    {
	                        _887 = -1.0;
	                    }
	                    _935[1] = _910;
	                    _936[1].w = _887;
	                    _936[1].x = _909.x;
	                    _936[1].y = _909.y;
	                    _936[1].z = _909.z;
	                    vec2 _3411 = ((vec2(float((_666.x) & 65535u), float((_666.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3412 = _3411.x;
	                    float _3417 = (1.0 - abs(_3412)) - abs(_3411.y);
	                    vec3 _3418 = vec3(_3412, _3411.y, _3417);
	                    float _3420 = saturate(-_3417);
	                    vec2 _3426 = _3411 + mix(vec2(_3420), vec2(-_3420), greaterThanEqual(_3411, vec2(0.0)));
	                    _3418.x = _3426.x;
	                    _3418.y = _3426.y;
	                    vec3 _912 = normalize(_3418);
	                    vec2 _3433 = ((vec2(float((_666.y >> uint(1)) & 32767u), float((_666.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3434 = _3433.x;
	                    float _3439 = (1.0 - abs(_3434)) - abs(_3433.y);
	                    vec3 _3440 = vec3(_3434, _3433.y, _3439);
	                    float _3442 = saturate(-_3439);
	                    vec2 _3448 = _3433 + mix(vec2(_3442), vec2(-_3442), greaterThanEqual(_3433, vec2(0.0)));
	                    _3440.x = _3448.x;
	                    _3440.y = _3448.y;
	                    vec3 _911 = normalize(_3440);
	                    float _886;
	                    if ((_666.y & 1u) != 0u)
	                    {
	                        _886 = 1.0;
	                    }
	                    else
	                    {
	                        _886 = -1.0;
	                    }
	                    _935[2] = _912;
	                    _936[2].w = _886;
	                    _936[2].x = _911.x;
	                    _936[2].y = _911.y;
	                    _936[2].z = _911.z;
	                    break;
	                }
	                else
	                {
	                    uint _2948 = _2938.x / 4u;
	                    vec4 _902 = _936[0];
	                    float _2963 = (float((g_Vertices_3[_2925]._m0[_2948] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2966 = (float((g_Vertices_3[_2925]._m0[_2948] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2970 = (1.0 - abs(_2963)) - abs(_2966);
	                    vec3 _2971 = vec3(_2963, _2966, _2970);
	                    float _2973 = saturate(-_2970);
	                    vec2 _2974 = vec2(_2963, _2966);
	                    vec2 _2980 = _2974 + mix(vec2(_2973), vec2(-_2973), greaterThanEqual(_2974, vec2(0.0)));
	                    _2971.x = _2980.x;
	                    _2971.y = _2980.y;
	                    vec3 _2985 = normalize(_2971);
	                    vec3 _901 = _2985;
	                    float _2986 = _2985.z;
	                    float _895;
	                    if (_2986 >= 0.0)
	                    {
	                        _895 = 1.0;
	                    }
	                    else
	                    {
	                        _895 = -1.0;
	                    }
	                    float _2993 = (-1.0) / (_895 + _2986);
	                    float _2994 = _2985.x;
	                    vec3 _896;
	                    vec3 _3002 = _896;
	                    _3002.x = 1.0 + (((_895 * _2994) * _2994) * _2993);
	                    _3002.y = _895 * ((_2994 * _2985.y) * _2993);
	                    _3002.z = (-_895) * _2994;
	                    _896 = _3002;
	                    float _3010 = float((g_Vertices_3[_2925]._m0[_2948] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3016 = (_3002 * cos(_3010)) + (cross(_2985, _3002) * sin(_3010));
	                    vec4 _3018 = _902;
	                    _3018.x = _3016.x;
	                    _3018.y = _3016.y;
	                    _3018.z = _3016.z;
	                    _902 = _3018;
	                    float _897;
	                    if ((g_Vertices_3[_2925]._m0[_2948] & 1u) == 0u)
	                    {
	                        _897 = -1.0;
	                    }
	                    else
	                    {
	                        _897 = 1.0;
	                    }
	                    vec4 _3029 = _902;
	                    _3029.w = _897;
	                    _902 = _3029;
	                    _935[0] = _901;
	                    _936[0] = _3029;
	                    uint _3033 = _2938.y / 4u;
	                    vec4 _904 = _936[1];
	                    float _3048 = (float((g_Vertices_3[_2925]._m0[_3033] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3051 = (float((g_Vertices_3[_2925]._m0[_3033] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3055 = (1.0 - abs(_3048)) - abs(_3051);
	                    vec3 _3056 = vec3(_3048, _3051, _3055);
	                    float _3058 = saturate(-_3055);
	                    vec2 _3059 = vec2(_3048, _3051);
	                    vec2 _3065 = _3059 + mix(vec2(_3058), vec2(-_3058), greaterThanEqual(_3059, vec2(0.0)));
	                    _3056.x = _3065.x;
	                    _3056.y = _3065.y;
	                    vec3 _3070 = normalize(_3056);
	                    vec3 _903 = _3070;
	                    float _3071 = _3070.z;
	                    float _892;
	                    if (_3071 >= 0.0)
	                    {
	                        _892 = 1.0;
	                    }
	                    else
	                    {
	                        _892 = -1.0;
	                    }
	                    float _3078 = (-1.0) / (_892 + _3071);
	                    float _3079 = _3070.x;
	                    vec3 _893;
	                    vec3 _3087 = _893;
	                    _3087.x = 1.0 + (((_892 * _3079) * _3079) * _3078);
	                    _3087.y = _892 * ((_3079 * _3070.y) * _3078);
	                    _3087.z = (-_892) * _3079;
	                    _893 = _3087;
	                    float _3095 = float((g_Vertices_3[_2925]._m0[_3033] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3101 = (_3087 * cos(_3095)) + (cross(_3070, _3087) * sin(_3095));
	                    vec4 _3103 = _904;
	                    _3103.x = _3101.x;
	                    _3103.y = _3101.y;
	                    _3103.z = _3101.z;
	                    _904 = _3103;
	                    float _894;
	                    if ((g_Vertices_3[_2925]._m0[_3033] & 1u) == 0u)
	                    {
	                        _894 = -1.0;
	                    }
	                    else
	                    {
	                        _894 = 1.0;
	                    }
	                    vec4 _3114 = _904;
	                    _3114.w = _894;
	                    _904 = _3114;
	                    _935[1] = _903;
	                    _936[1] = _3114;
	                    uint _3118 = _2938.z / 4u;
	                    vec4 _906 = _936[2];
	                    float _3133 = (float((g_Vertices_3[_2925]._m0[_3118] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3136 = (float((g_Vertices_3[_2925]._m0[_3118] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3140 = (1.0 - abs(_3133)) - abs(_3136);
	                    vec3 _3141 = vec3(_3133, _3136, _3140);
	                    float _3143 = saturate(-_3140);
	                    vec2 _3144 = vec2(_3133, _3136);
	                    vec2 _3150 = _3144 + mix(vec2(_3143), vec2(-_3143), greaterThanEqual(_3144, vec2(0.0)));
	                    _3141.x = _3150.x;
	                    _3141.y = _3150.y;
	                    vec3 _3155 = normalize(_3141);
	                    vec3 _905 = _3155;
	                    float _3156 = _3155.z;
	                    float _889;
	                    if (_3156 >= 0.0)
	                    {
	                        _889 = 1.0;
	                    }
	                    else
	                    {
	                        _889 = -1.0;
	                    }
	                    float _3163 = (-1.0) / (_889 + _3156);
	                    float _3164 = _3155.x;
	                    vec3 _890;
	                    vec3 _3172 = _890;
	                    _3172.x = 1.0 + (((_889 * _3164) * _3164) * _3163);
	                    _3172.y = _889 * ((_3164 * _3155.y) * _3163);
	                    _3172.z = (-_889) * _3164;
	                    _890 = _3172;
	                    float _3180 = float((g_Vertices_3[_2925]._m0[_3118] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3186 = (_3172 * cos(_3180)) + (cross(_3155, _3172) * sin(_3180));
	                    vec4 _3188 = _906;
	                    _3188.x = _3186.x;
	                    _3188.y = _3186.y;
	                    _3188.z = _3186.z;
	                    _906 = _3188;
	                    float _891;
	                    if ((g_Vertices_3[_2925]._m0[_3118] & 1u) == 0u)
	                    {
	                        _891 = -1.0;
	                    }
	                    else
	                    {
	                        _891 = 1.0;
	                    }
	                    vec4 _3199 = _906;
	                    _3199.w = _891;
	                    _906 = _3199;
	                    _935[2] = _905;
	                    _936[2] = _3199;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _935[0] = vec3(0.0);
	            _935[1] = vec3(0.0);
	            _935[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _913 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _3522 = uint(_913[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _3524 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _884 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _885 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _3535 = (uvec3(uint(_884[_3524])) * _938) + uvec3(uint(_885[_3524]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _3537 = _3535.x;
	            _936[0] = vec4(g_Vertices_1[_3522]._m0[_3537 / 4u], g_Vertices_1[_3522]._m0[(_3537 + 4u) / 4u], g_Vertices_1[_3522]._m0[(_3537 + 8u) / 4u], g_Vertices_1[_3522]._m0[(_3537 + 12u) / 4u]);
	            uint _3555 = _3535.y;
	            _936[1] = vec4(g_Vertices_1[_3522]._m0[_3555 / 4u], g_Vertices_1[_3522]._m0[(_3555 + 4u) / 4u], g_Vertices_1[_3522]._m0[(_3555 + 8u) / 4u], g_Vertices_1[_3522]._m0[(_3555 + 12u) / 4u]);
	            uint _3573 = _3535.z;
	            _936[2] = vec4(g_Vertices_1[_3522]._m0[_3573 / 4u], g_Vertices_1[_3522]._m0[(_3573 + 4u) / 4u], g_Vertices_1[_3522]._m0[(_3573 + 8u) / 4u], g_Vertices_1[_3522]._m0[(_3573 + 12u) / 4u]);
	        }
	        else
	        {
	            _936[0] = vec4(0.0);
	            _936[1] = vec4(0.0);
	            _936[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _933 = 0;
	    for (;;)
	    {
	        if (!(_933 < 3))
	        {
	            break;
	        }
	        vsInput[_933]._m3 = _935[_933];
	        vsInput[_933]._m4 = _936[_933];
	        _933++;
	        continue;
	    }
	    vec4 _937[3];
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _883 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _3624 = uint(_883[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _3626 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _881 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _882 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3637 = (uvec3(uint(_881[_3626])) * _938) + uvec3(uint(_882[_3626]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _3691 = _3637.x;
	            _937[0] = vec4(g_Vertices_1[_3624]._m0[_3691 / 4u], g_Vertices_1[_3624]._m0[(_3691 + 4u) / 4u], g_Vertices_1[_3624]._m0[(_3691 + 8u) / 4u], g_Vertices_1[_3624]._m0[(_3691 + 12u) / 4u]);
	            uint _3709 = _3637.y;
	            _937[1] = vec4(g_Vertices_1[_3624]._m0[_3709 / 4u], g_Vertices_1[_3624]._m0[(_3709 + 4u) / 4u], g_Vertices_1[_3624]._m0[(_3709 + 8u) / 4u], g_Vertices_1[_3624]._m0[(_3709 + 12u) / 4u]);
	            uint _3727 = _3637.z;
	            _937[2] = vec4(g_Vertices_1[_3624]._m0[_3727 / 4u], g_Vertices_1[_3624]._m0[(_3727 + 4u) / 4u], g_Vertices_1[_3624]._m0[(_3727 + 8u) / 4u], g_Vertices_1[_3624]._m0[(_3727 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _3644 = _3637.x / 4u;
	            _937[0] = vec4(uvec4((g_Vertices_3[_3624]._m0[_3644] & 255u), (g_Vertices_3[_3624]._m0[_3644] & 65280u) >> uint(8), (g_Vertices_3[_3624]._m0[_3644] & 16711680u) >> uint(16), (g_Vertices_3[_3624]._m0[_3644] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _3660 = _3637.y / 4u;
	            _937[1] = vec4(uvec4((g_Vertices_3[_3624]._m0[_3660] & 255u), (g_Vertices_3[_3624]._m0[_3660] & 65280u) >> uint(8), (g_Vertices_3[_3624]._m0[_3660] & 16711680u) >> uint(16), (g_Vertices_3[_3624]._m0[_3660] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _3676 = _3637.z / 4u;
	            _937[2] = vec4(uvec4((g_Vertices_3[_3624]._m0[_3676] & 255u), (g_Vertices_3[_3624]._m0[_3676] & 65280u) >> uint(8), (g_Vertices_3[_3624]._m0[_3676] & 16711680u) >> uint(16), (g_Vertices_3[_3624]._m0[_3676] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _937[0] = vec4(0.0);
	        _937[1] = vec4(0.0);
	        _937[2] = vec4(0.0);
	    }
	    _933 = 0;
	    for (;;)
	    {
	        if (!(_933 < 3))
	        {
	            break;
	        }
	        vsInput[_933]._m7 = _937[_933];
	        _933++;
	        continue;
	    }
	    vec4 _940[3];
	    _940[0] = vec4(0.0);
	    _940[1] = vec4(0.0);
	    _940[2] = vec4(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _880 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _3778 = uint(_880[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _3780 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _878 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _879 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3791 = (uvec3(uint(_878[_3780])) * _938) + uvec3(uint(_879[_3780]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _3844 = _3791.x;
	            _940[0] = vec4(g_Vertices_1[_3778]._m0[_3844 / 4u], g_Vertices_1[_3778]._m0[(_3844 + 4u) / 4u], g_Vertices_1[_3778]._m0[(_3844 + 8u) / 4u], g_Vertices_1[_3778]._m0[(_3844 + 12u) / 4u]);
	            uint _3861 = _3791.y;
	            _940[1] = vec4(g_Vertices_1[_3778]._m0[_3861 / 4u], g_Vertices_1[_3778]._m0[(_3861 + 4u) / 4u], g_Vertices_1[_3778]._m0[(_3861 + 8u) / 4u], g_Vertices_1[_3778]._m0[(_3861 + 12u) / 4u]);
	            uint _3878 = _3791.z;
	            _940[2] = vec4(g_Vertices_1[_3778]._m0[_3878 / 4u], g_Vertices_1[_3778]._m0[(_3878 + 4u) / 4u], g_Vertices_1[_3778]._m0[(_3878 + 8u) / 4u], g_Vertices_1[_3778]._m0[(_3878 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _3800 = _3791.x / 4u;
	                _940[0] = vec4(uvec4((g_Vertices_3[_3778]._m0[_3800] & 255u), (g_Vertices_3[_3778]._m0[_3800] & 65280u) >> uint(8), (g_Vertices_3[_3778]._m0[_3800] & 16711680u) >> uint(16), (g_Vertices_3[_3778]._m0[_3800] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _3815 = _3791.y / 4u;
	                _940[1] = vec4(uvec4((g_Vertices_3[_3778]._m0[_3815] & 255u), (g_Vertices_3[_3778]._m0[_3815] & 65280u) >> uint(8), (g_Vertices_3[_3778]._m0[_3815] & 16711680u) >> uint(16), (g_Vertices_3[_3778]._m0[_3815] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _3830 = _3791.z / 4u;
	                _940[2] = vec4(uvec4((g_Vertices_3[_3778]._m0[_3830] & 255u), (g_Vertices_3[_3778]._m0[_3830] & 65280u) >> uint(8), (g_Vertices_3[_3778]._m0[_3830] & 16711680u) >> uint(16), (g_Vertices_3[_3778]._m0[_3830] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _941 = 0;
	    for (;;)
	    {
	        if (!(_941 < 3))
	        {
	            break;
	        }
	        vsInput[_941]._m8 = _940[_941];
	        _941++;
	        continue;
	    }
	    vec3 _875 = vsInput[0]._m3;
	    vec4 _876;
	    vec4 _3919 = _876;
	    _3919.x = vsInput[0]._m4.x;
	    _3919.y = vsInput[0]._m4.y;
	    _3919.z = vsInput[0]._m4.z;
	    _3919.w = vsInput[0]._m4.w;
	    _876 = _3919;
	    vec4 _3944 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _874 = _3944;
	    vec3 _3945 = _3944.xyz;
	    vec3 _3946 = _3945 * vec3(0.077399380505084991455078125);
	    vec3 _3949 = pow((_3945 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _871;
	    if (_3944.x <= 0.040449999272823333740234375)
	    {
	        _871 = _3946.x;
	    }
	    else
	    {
	        _871 = _3949.x;
	    }
	    float _872;
	    if (_3944.y <= 0.040449999272823333740234375)
	    {
	        _872 = _3946.y;
	    }
	    else
	    {
	        _872 = _3949.y;
	    }
	    float _873;
	    if (_3944.z <= 0.040449999272823333740234375)
	    {
	        _873 = _3946.z;
	    }
	    else
	    {
	        _873 = _3949.z;
	    }
	    vec3 _3974 = vec3(_871, _872, _873);
	    vec4 _3976 = _874;
	    _3976.x = _3974.x;
	    _3976.y = _3974.y;
	    _3976.z = _3974.z;
	    _874 = _3976;
	    vec4 _685;
	    vec4 _3983 = _685;
	    _3983.x = _3976.x;
	    _3983.y = _3976.y;
	    _3983.z = _3976.z;
	    _3983.w = _3976.w;
	    _685 = _3983;
	    mat3x4 _3994 = transpose(gl_WorldToObjectEXT);
	    mat3 _870;
	    mat3 _3997 = _870;
	    _3997[0] = _3994[0].xyz;
	    _3997[1] = _3994[1].xyz;
	    _3997[2] = _3994[2].xyz;
	    _870 = _3997;
	    vec3 _4006 = normalize(_3997 * _875.xyz);
	    vec3 _686;
	    vec3 _4008 = _686;
	    _4008.x = _4006.x;
	    _4008.y = _4006.y;
	    _4008.z = _4006.z;
	    _686 = _4008;
	    mat3x4 _4020 = transpose(gl_WorldToObjectEXT);
	    mat3 _869;
	    mat3 _4023 = _869;
	    _4023[0] = _4020[0].xyz;
	    _4023[1] = _4020[1].xyz;
	    _4023[2] = _4020[2].xyz;
	    _869 = _4023;
	    vec3 _4032 = normalize(_4023 * _876.xyz);
	    vec4 _684;
	    vec4 _4034 = _684;
	    _4034.x = _4032.x;
	    _4034.y = _4032.y;
	    _4034.z = _4032.z;
	    _4034.w = _876.w;
	    _684 = _4034;
	    vec4 _4043 = vsInput[0]._m1.xyxy;
	    _4043.z = vsInput[0]._m2.x;
	    _4043.w = vsInput[0]._m2.y;
	    vec4 _687;
	    vec4 _688;
	    vec4 _683 = _688;
	    vec4 _682 = _687;
	    vec3 _681 = vec4(vsInput[0].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _680 = _4008;
	    vec4 _679 = _4043;
	    vec4 _678 = _3983;
	    vec4 _677 = _4034;
	    vec2 _877;
	    if (_g_rtx_material_data_._m2 > 0)
	    {
	        if (_g_rtx_material_data_._m2 == 2)
	        {
	            _877 = _4043.zw;
	        }
	        else
	        {
	            _877 = _4043.xy;
	        }
	        vec4 _4066 = _679;
	        _4066.x = _877.x;
	        _4066.y = _877.y;
	        vec4 _4085 = _4066;
	        _4085.x = dot(_4066.xy, _g_rtx_material_data_._m11.xy) + _g_rtx_material_data_._m11.w;
	        _4085.y = dot(_4066.xy, _g_rtx_material_data_._m12.xy) + _g_rtx_material_data_._m12.w;
	        _679 = _4085;
	    }
	    if (_g_rtx_material_data_._m18 > 0)
	    {
	        if (_g_rtx_material_data_._m18 == 2)
	        {
	            _877 = _4043.zw;
	        }
	        else
	        {
	            _877 = _4043.xy;
	        }
	        vec4 _4101 = _679;
	        _4101.z = _877.x;
	        _4101.w = _877.y;
	        vec4 _4120 = _4101;
	        _4120.z = dot(_4101.zw, _g_rtx_material_data_._m27.xy) + _g_rtx_material_data_._m27.w;
	        _4120.w = dot(_4101.zw, _g_rtx_material_data_._m28.xy) + _g_rtx_material_data_._m28.w;
	        _679 = _4120;
	    }
	    vec4 _4123 = _678;
	    vec4 _4125 = _682;
	    _4125.x = _4123.x;
	    _4125.y = _4123.y;
	    _4125.z = _4123.z;
	    _4125.w = _g_rtx_material_data_._m156 * (1.0 - min(_4125.x, min(_4125.y, _4125.z)));
	    _682 = _4125;
	    _4123.x = _g_rtx_material_data_._m155.x;
	    _4123.y = _g_rtx_material_data_._m155.y;
	    _4123.z = _g_rtx_material_data_._m155.z;
	    vec3 _4154 = _4123.xyz * mix(vec3(1.0), vsInput[0]._m7.xyz, vec3(vsInput[0]._m7.w));
	    vec4 _4156 = _4123;
	    _4156.x = _4154.x;
	    _4156.y = _4154.y;
	    _4156.z = _4154.z;
	    _678 = _4156;
	    vec4 _4163 = _683;
	    _4163.x = vsInput[0]._m8.x;
	    _4163.y = vsInput[0]._m8.y;
	    _4163.z = vsInput[0]._m8.z;
	    _4163.w = vsInput[0]._m8.w;
	    _683 = _4163;
	    if (_g_rtx_material_data_._m158)
	    {
	        vec4 _4187 = _683;
	        _4187.x = _4187.x * smoothstep(_g_rtx_material_data_._m98.x, _g_rtx_material_data_._m98.y, (dot(_g_rtx_material_data_._m94.xyz, _680.xyz) * 0.5) + 0.5);
	        _683 = _4187;
	    }
	    vec4 _665 = _683;
	    vec4 _664 = _682;
	    vec3 _663 = _681;
	    vec3 _662 = _680;
	    vec4 _661 = _679;
	    vec4 _660 = _678;
	    vec4 _659 = _677;
	    vec3 _866 = vsInput[1]._m3;
	    vec4 _867;
	    vec4 _4204 = _867;
	    _4204.x = vsInput[1]._m4.x;
	    _4204.y = vsInput[1]._m4.y;
	    _4204.z = vsInput[1]._m4.z;
	    _4204.w = vsInput[1]._m4.w;
	    _867 = _4204;
	    vec4 _4229 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _865 = _4229;
	    vec3 _4230 = _4229.xyz;
	    vec3 _4231 = _4230 * vec3(0.077399380505084991455078125);
	    vec3 _4234 = pow((_4230 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _862;
	    if (_4229.x <= 0.040449999272823333740234375)
	    {
	        _862 = _4231.x;
	    }
	    else
	    {
	        _862 = _4234.x;
	    }
	    float _863;
	    if (_4229.y <= 0.040449999272823333740234375)
	    {
	        _863 = _4231.y;
	    }
	    else
	    {
	        _863 = _4234.y;
	    }
	    float _864;
	    if (_4229.z <= 0.040449999272823333740234375)
	    {
	        _864 = _4231.z;
	    }
	    else
	    {
	        _864 = _4234.z;
	    }
	    vec3 _4259 = vec3(_862, _863, _864);
	    vec4 _4261 = _865;
	    _4261.x = _4259.x;
	    _4261.y = _4259.y;
	    _4261.z = _4259.z;
	    _865 = _4261;
	    vec4 _697;
	    vec4 _4268 = _697;
	    _4268.x = _4261.x;
	    _4268.y = _4261.y;
	    _4268.z = _4261.z;
	    _4268.w = _4261.w;
	    _697 = _4268;
	    mat3x4 _4279 = transpose(gl_WorldToObjectEXT);
	    mat3 _861;
	    mat3 _4282 = _861;
	    _4282[0] = _4279[0].xyz;
	    _4282[1] = _4279[1].xyz;
	    _4282[2] = _4279[2].xyz;
	    _861 = _4282;
	    vec3 _4291 = normalize(_4282 * _866.xyz);
	    vec3 _698;
	    vec3 _4293 = _698;
	    _4293.x = _4291.x;
	    _4293.y = _4291.y;
	    _4293.z = _4291.z;
	    _698 = _4293;
	    mat3x4 _4305 = transpose(gl_WorldToObjectEXT);
	    mat3 _860;
	    mat3 _4308 = _860;
	    _4308[0] = _4305[0].xyz;
	    _4308[1] = _4305[1].xyz;
	    _4308[2] = _4305[2].xyz;
	    _860 = _4308;
	    vec3 _4317 = normalize(_4308 * _867.xyz);
	    vec4 _696;
	    vec4 _4319 = _696;
	    _4319.x = _4317.x;
	    _4319.y = _4317.y;
	    _4319.z = _4317.z;
	    _4319.w = _867.w;
	    _696 = _4319;
	    vec4 _4328 = vsInput[1]._m1.xyxy;
	    _4328.z = vsInput[1]._m2.x;
	    _4328.w = vsInput[1]._m2.y;
	    vec4 _699;
	    vec4 _700;
	    vec4 _695 = _700;
	    vec4 _694 = _699;
	    vec3 _693 = vec4(vsInput[1].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _692 = _4293;
	    vec4 _691 = _4328;
	    vec4 _690 = _4268;
	    vec4 _689 = _4319;
	    vec2 _868;
	    if (_g_rtx_material_data_._m2 > 0)
	    {
	        if (_g_rtx_material_data_._m2 == 2)
	        {
	            _868 = _4328.zw;
	        }
	        else
	        {
	            _868 = _4328.xy;
	        }
	        vec4 _4351 = _691;
	        _4351.x = _868.x;
	        _4351.y = _868.y;
	        vec4 _4370 = _4351;
	        _4370.x = dot(_4351.xy, _g_rtx_material_data_._m11.xy) + _g_rtx_material_data_._m11.w;
	        _4370.y = dot(_4351.xy, _g_rtx_material_data_._m12.xy) + _g_rtx_material_data_._m12.w;
	        _691 = _4370;
	    }
	    if (_g_rtx_material_data_._m18 > 0)
	    {
	        if (_g_rtx_material_data_._m18 == 2)
	        {
	            _868 = _4328.zw;
	        }
	        else
	        {
	            _868 = _4328.xy;
	        }
	        vec4 _4386 = _691;
	        _4386.z = _868.x;
	        _4386.w = _868.y;
	        vec4 _4405 = _4386;
	        _4405.z = dot(_4386.zw, _g_rtx_material_data_._m27.xy) + _g_rtx_material_data_._m27.w;
	        _4405.w = dot(_4386.zw, _g_rtx_material_data_._m28.xy) + _g_rtx_material_data_._m28.w;
	        _691 = _4405;
	    }
	    vec4 _4408 = _690;
	    vec4 _4410 = _694;
	    _4410.x = _4408.x;
	    _4410.y = _4408.y;
	    _4410.z = _4408.z;
	    _4410.w = _g_rtx_material_data_._m156 * (1.0 - min(_4410.x, min(_4410.y, _4410.z)));
	    _694 = _4410;
	    _4408.x = _g_rtx_material_data_._m155.x;
	    _4408.y = _g_rtx_material_data_._m155.y;
	    _4408.z = _g_rtx_material_data_._m155.z;
	    vec3 _4439 = _4408.xyz * mix(vec3(1.0), vsInput[1]._m7.xyz, vec3(vsInput[1]._m7.w));
	    vec4 _4441 = _4408;
	    _4441.x = _4439.x;
	    _4441.y = _4439.y;
	    _4441.z = _4439.z;
	    _690 = _4441;
	    vec4 _4448 = _695;
	    _4448.x = vsInput[1]._m8.x;
	    _4448.y = vsInput[1]._m8.y;
	    _4448.z = vsInput[1]._m8.z;
	    _4448.w = vsInput[1]._m8.w;
	    _695 = _4448;
	    if (_g_rtx_material_data_._m158)
	    {
	        vec4 _4472 = _695;
	        _4472.x = _4472.x * smoothstep(_g_rtx_material_data_._m98.x, _g_rtx_material_data_._m98.y, (dot(_g_rtx_material_data_._m94.xyz, _692.xyz) * 0.5) + 0.5);
	        _695 = _4472;
	    }
	    vec4 _658 = _695;
	    vec4 _657 = _694;
	    vec3 _656 = _693;
	    vec3 _655 = _692;
	    vec4 _654 = _691;
	    vec4 _653 = _690;
	    vec4 _652 = _689;
	    vec3 _857 = vsInput[2]._m3;
	    vec4 _858;
	    vec4 _4489 = _858;
	    _4489.x = vsInput[2]._m4.x;
	    _4489.y = vsInput[2]._m4.y;
	    _4489.z = vsInput[2]._m4.z;
	    _4489.w = vsInput[2]._m4.w;
	    _858 = _4489;
	    vec4 _4514 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _856 = _4514;
	    vec3 _4515 = _4514.xyz;
	    vec3 _4516 = _4515 * vec3(0.077399380505084991455078125);
	    vec3 _4519 = pow((_4515 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _853;
	    if (_4514.x <= 0.040449999272823333740234375)
	    {
	        _853 = _4516.x;
	    }
	    else
	    {
	        _853 = _4519.x;
	    }
	    float _854;
	    if (_4514.y <= 0.040449999272823333740234375)
	    {
	        _854 = _4516.y;
	    }
	    else
	    {
	        _854 = _4519.y;
	    }
	    float _855;
	    if (_4514.z <= 0.040449999272823333740234375)
	    {
	        _855 = _4516.z;
	    }
	    else
	    {
	        _855 = _4519.z;
	    }
	    vec3 _4544 = vec3(_853, _854, _855);
	    vec4 _4546 = _856;
	    _4546.x = _4544.x;
	    _4546.y = _4544.y;
	    _4546.z = _4544.z;
	    _856 = _4546;
	    vec4 _709;
	    vec4 _4553 = _709;
	    _4553.x = _4546.x;
	    _4553.y = _4546.y;
	    _4553.z = _4546.z;
	    _4553.w = _4546.w;
	    _709 = _4553;
	    mat3x4 _4564 = transpose(gl_WorldToObjectEXT);
	    mat3 _852;
	    mat3 _4567 = _852;
	    _4567[0] = _4564[0].xyz;
	    _4567[1] = _4564[1].xyz;
	    _4567[2] = _4564[2].xyz;
	    _852 = _4567;
	    vec3 _4576 = normalize(_4567 * _857.xyz);
	    vec3 _710;
	    vec3 _4578 = _710;
	    _4578.x = _4576.x;
	    _4578.y = _4576.y;
	    _4578.z = _4576.z;
	    _710 = _4578;
	    mat3x4 _4590 = transpose(gl_WorldToObjectEXT);
	    mat3 _851;
	    mat3 _4593 = _851;
	    _4593[0] = _4590[0].xyz;
	    _4593[1] = _4590[1].xyz;
	    _4593[2] = _4590[2].xyz;
	    _851 = _4593;
	    vec3 _4602 = normalize(_4593 * _858.xyz);
	    vec4 _708;
	    vec4 _4604 = _708;
	    _4604.x = _4602.x;
	    _4604.y = _4602.y;
	    _4604.z = _4602.z;
	    _4604.w = _858.w;
	    _708 = _4604;
	    vec4 _4613 = vsInput[2]._m1.xyxy;
	    _4613.z = vsInput[2]._m2.x;
	    _4613.w = vsInput[2]._m2.y;
	    vec4 _711;
	    vec4 _712;
	    vec4 _707 = _712;
	    vec4 _706 = _711;
	    vec3 _705 = vec4(vsInput[2].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _704 = _4578;
	    vec4 _703 = _4613;
	    vec4 _702 = _4553;
	    vec4 _701 = _4604;
	    vec2 _859;
	    if (_g_rtx_material_data_._m2 > 0)
	    {
	        if (_g_rtx_material_data_._m2 == 2)
	        {
	            _859 = _4613.zw;
	        }
	        else
	        {
	            _859 = _4613.xy;
	        }
	        vec4 _4636 = _703;
	        _4636.x = _859.x;
	        _4636.y = _859.y;
	        vec4 _4655 = _4636;
	        _4655.x = dot(_4636.xy, _g_rtx_material_data_._m11.xy) + _g_rtx_material_data_._m11.w;
	        _4655.y = dot(_4636.xy, _g_rtx_material_data_._m12.xy) + _g_rtx_material_data_._m12.w;
	        _703 = _4655;
	    }
	    if (_g_rtx_material_data_._m18 > 0)
	    {
	        if (_g_rtx_material_data_._m18 == 2)
	        {
	            _859 = _4613.zw;
	        }
	        else
	        {
	            _859 = _4613.xy;
	        }
	        vec4 _4671 = _703;
	        _4671.z = _859.x;
	        _4671.w = _859.y;
	        vec4 _4690 = _4671;
	        _4690.z = dot(_4671.zw, _g_rtx_material_data_._m27.xy) + _g_rtx_material_data_._m27.w;
	        _4690.w = dot(_4671.zw, _g_rtx_material_data_._m28.xy) + _g_rtx_material_data_._m28.w;
	        _703 = _4690;
	    }
	    vec4 _4693 = _702;
	    vec4 _4695 = _706;
	    _4695.x = _4693.x;
	    _4695.y = _4693.y;
	    _4695.z = _4693.z;
	    _4695.w = _g_rtx_material_data_._m156 * (1.0 - min(_4695.x, min(_4695.y, _4695.z)));
	    _706 = _4695;
	    _4693.x = _g_rtx_material_data_._m155.x;
	    _4693.y = _g_rtx_material_data_._m155.y;
	    _4693.z = _g_rtx_material_data_._m155.z;
	    vec3 _4724 = _4693.xyz * mix(vec3(1.0), vsInput[2]._m7.xyz, vec3(vsInput[2]._m7.w));
	    vec4 _4726 = _4693;
	    _4726.x = _4724.x;
	    _4726.y = _4724.y;
	    _4726.z = _4724.z;
	    _702 = _4726;
	    vec4 _4733 = _707;
	    _4733.x = vsInput[2]._m8.x;
	    _4733.y = vsInput[2]._m8.y;
	    _4733.z = vsInput[2]._m8.z;
	    _4733.w = vsInput[2]._m8.w;
	    _707 = _4733;
	    if (_g_rtx_material_data_._m158)
	    {
	        vec4 _4757 = _707;
	        _4757.x = _4757.x * smoothstep(_g_rtx_material_data_._m98.x, _g_rtx_material_data_._m98.y, (dot(_g_rtx_material_data_._m94.xyz, _704.xyz) * 0.5) + 0.5);
	        _707 = _4757;
	    }
	    vec3 _651 = _705;
	    vec3 _650 = _704;
	    vec3 _4792 = ((_662 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_655 * _22.barycentrics.x)) + (_704 * _22.barycentrics.y);
	    bool _4798 = gl_HitKindEXT == 254u;
	    vec3 _713;
	    vec4 _4835 = ((_665 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_658 * _22.barycentrics.x)) + (_707 * _22.barycentrics.y);
	    vec4 _676 = _4835;
	    vec4 _675 = ((_664 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_657 * _22.barycentrics.x)) + (_706 * _22.barycentrics.y);
	    vec3 _674 = _4792;
	    vec4 _673 = ((_661 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_654 * _22.barycentrics.x)) + (_703 * _22.barycentrics.y);
	    vec4 _672 = ((_660 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_653 * _22.barycentrics.x)) + (_702 * _22.barycentrics.y);
	    vec4 _671 = ((_659 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_652 * _22.barycentrics.x)) + (_701 * _22.barycentrics.y);
	    bool _670 = _4798;
	    float _4848 = clamp((_4835.x * 1.10000002384185791015625) - 0.0500000007450580596923828125, 0.0, 1.0);
	    vec3 _764 = vec3(0.5);
	    vec2 _763 = vec2(0.5);
	    vec3 _762 = vec3(0.0);
	    float _761 = 0.039999999105930328369140625;
	    vec3 _760 = vec3(0.0);
	    vec3 _759 = vec3(0.0);
	    vec3 _757 = vec3(1.0);
	    bool _756 = false;
	    vec3 _755 = vec3(1.0, 0.0, 0.0);
	    vec3 _754 = vec3(0.0, 1.0, 0.0);
	    vec3 _4849 = _4792.xyz;
	    vec3 _758 = _4849;
	    if (dot(_4849, _4849) >= 1.0099999904632568359375)
	    {
	        _758 = _713.xyz;
	    }
	    _761 = _g_rtx_material_data_._m175;
	    _757 = normalize(cross(_656 - _663, _705 - _663));
	    bool _835;
	    if (_g_rtx_material_data_._m174)
	    {
	        _835 = !_g_rtx_material_data_._m173;
	    }
	    else
	    {
	        _835 = false;
	    }
	    if (_835)
	    {
	        float _836;
	        if (_4798)
	        {
	            _836 = 1.0;
	        }
	        else
	        {
	            _836 = -1.0;
	        }
	        _758 *= _836;
	        if (_4798)
	        {
	            _836 = 1.0;
	        }
	        else
	        {
	            _836 = -1.0;
	        }
	        _757 *= _836;
	        _756 = !_4798;
	    }
	    vec3 _4880 = _758;
	    vec3 _4881 = normalize(_4880);
	    _758 = _4881;
	    vec3 _753 = _4881;
	    vec3 _752 = _764;
	    vec2 _751 = _763;
	    vec3 _750 = _762;
	    float _749 = _761;
	    vec3 _748 = _760;
	    vec3 _747 = _759;
	    vec3 _746 = _4881;
	    vec3 _745 = _757;
	    bool _744 = _756;
	    vec3 _743 = _755;
	    vec3 _742 = _754;
	    bool _837;
	    if (_g_rtx_material_data_._m18 > 1)
	    {
	        _837 = true;
	    }
	    else
	    {
	        _837 = _g_rtx_material_data_._m2 > 1;
	    }
	    bool _833;
	    if (_g_rtx_material_data_._m174)
	    {
	        _833 = !_g_rtx_material_data_._m173;
	    }
	    else
	    {
	        _833 = false;
	    }
	    if (_833)
	    {
	        float _834;
	        if (_670)
	        {
	            _834 = 1.0;
	        }
	        else
	        {
	            _834 = -1.0;
	        }
	        _833 = _834 < 0.0;
	    }
	    else
	    {
	        _833 = false;
	    }
	    vec3 _768 = vec3(0.0);
	    vec3 _767 = vec3(0.0);
	    float _831;
	    if (_671.w > 0.0)
	    {
	        _831 = 1.0;
	    }
	    else
	    {
	        _831 = -1.0;
	    }
	    float _4933 = 1.0 / length(_674);
	    vec3 _769 = _674 * _4933;
	    vec3 _669 = _671.xyz * _4933;
	    vec3 _668 = (cross(_674, _671.xyz) * _831) * _4933;
	    if (_833)
	    {
	        _769 *= (-1.0);
	    }
	    vec3 _766 = _768 - (_769 * dot(_768, _769));
	    vec3 _765 = _767 - (_769 * dot(_767, _769));
	    int _832;
	    if (dot(_767, cross(_769, _768)) < 0.0)
	    {
	        _832 = -1;
	    }
	    else
	    {
	        _832 = 1;
	    }
	    vec3 _782 = _769;
	    vec3 _781 = _766;
	    vec3 _780 = _765;
	    float _779 = float(_832);
	    vec3 _740;
	    vec3 _741;
	    if (_837)
	    {
	        float _830;
	        if (false)
	        {
	            _830 = -1.0;
	        }
	        else
	        {
	            _830 = 1.0;
	        }
	        vec2 _4970 = vec2(0.0, -0.0) * _830;
	        vec3 _770 = (_781 * _4970.x) + (_780 * _4970.y);
	        float _4978 = abs(0.0);
	        if (_4978 > 0.0)
	        {
	            _770 = normalize(_770);
	        }
	        _741 = _770;
	        _740 = cross(_782, _770) * (_830 * _779);
	    }
	    vec4 _739 = vec4(0.0);
	    vec3 _738 = vec3(0.0);
	    vec3 _737 = vec3(0.0);
	    vec3 _736 = vec3(0.0);
	    vec2 _735 = vec2(0.0);
	    float _734 = 0.0;
	    float _733 = 0.0;
	    float _732 = 0.0;
	    float _731 = 0.0;
	    vec4 _730 = vec4(0.0);
	    vec3 _729 = vec3(0.0);
	    vec3 _728 = vec3(0.0);
	    vec3 _727 = vec3(0.0);
	    vec2 _726 = vec2(0.0);
	    float _725 = 0.0;
	    float _724 = 0.0;
	    float _723 = 0.0;
	    float _722 = 0.0;
	    vec4 _838;
	    if (_g_rtx_material_data_._m2 != 0)
	    {
	        vec3 _4999 = _736;
	        _4999.x = _673.x;
	        _4999.y = _673.y;
	        _736 = _4999;
	        _739 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m171], g_bindless_Sampler[_g_rtx_material_data_._m169]), _4999.xy, 0.0).xyzw;
	        _738 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m31], g_bindless_Sampler[_g_rtx_material_data_._m169]), _4999.xy, 0.0).xyz;
	        _838 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m32], g_bindless_Sampler[_g_rtx_material_data_._m169]), _4999.xy, 0.0).xyzw;
	    }
	    else
	    {
	        _838 = vec4(0.0);
	    }
	    _743 = _671.xyz;
	    float _839;
	    if (_671.w > 0.0)
	    {
	        _839 = 1.0;
	    }
	    else
	    {
	        _839 = -1.0;
	    }
	    _742 = cross(_674.xyz, _743.xyz) * _839;
	    vec2 _716;
	    vec2 _717;
	    vec2 _718;
	    vec2 _719;
	    vec2 _720;
	    vec2 _721;
	    ivec2 _840;
	    ivec2 _841;
	    vec2 _842;
	    if (_g_rtx_material_data_._m194)
	    {
	        vec3 _5047 = abs(_746);
	        vec3 _825 = _5047;
	        float _5048 = _5047.x;
	        float _5049 = _5047.y;
	        bool _826;
	        if (_5048 > _5049)
	        {
	            _826 = _5048 > _5047.z;
	        }
	        else
	        {
	            _826 = false;
	        }
	        ivec3 _827;
	        if (_826)
	        {
	            _827 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5049 > _5047.z)
	            {
	                _827 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _827 = ivec3(2, 0, 1);
	            }
	        }
	        if (_5048 < _5049)
	        {
	            _826 = _5048 < _5047.z;
	        }
	        else
	        {
	            _826 = false;
	        }
	        ivec3 _828;
	        if (_826)
	        {
	            _828 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5049 < _5047.z)
	            {
	                _828 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _828 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _5083 = (ivec3(3) - _828) - _827;
	        ivec2 _829;
	        if (_827.x == 1)
	        {
	            _829 = _827.zy;
	        }
	        else
	        {
	            _829 = _827.yz;
	        }
	        ivec2 _5095 = _840;
	        _5095.x = _829.x;
	        _5095.y = _829.y;
	        _840 = _5095;
	        int _5099 = _5083.x;
	        if (_5099 == 1)
	        {
	            _829 = _5083.zy;
	        }
	        else
	        {
	            _829 = _5083.yz;
	        }
	        ivec2 _5108 = _841;
	        _5108.x = _829.x;
	        _5108.y = _829.y;
	        _841 = _5108;
	        vec2 _5119 = clamp((vec2(_825[_827.x], _825[_5099]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        _842 = _5119 / vec2(_5119.x + _5119.y);
	        vec3 _820 = _747 * _g_rtx_material_data_._g_fl_AutoPad32_.xyz;
	        _721 = vec2(_820[_840.x], _820[_840.y]);
	        vec3 _821 = vec3(0.0);
	        vec3 _822 = vec3(0.0);
	        vec2 _5142 = vec2(_821[_840.x], _822[_840.y]);
	        _719 = _5142;
	        _718 = _5142;
	        _720 = vec2(_820[_5108.x], _820[_5108.y]);
	        vec3 _823 = vec3(0.0);
	        vec3 _824 = vec3(0.0);
	        vec2 _5154 = vec2(_823[_5108.x], _824[_5108.y]);
	        _717 = _5154;
	        _716 = _5154;
	    }
	    if (_g_rtx_material_data_._m2 == 0)
	    {
	        vec3 _5165 = _747.xyz * _g_rtx_material_data_._g_fl_AutoPad32_.xyz;
	        vec3 _5167 = _736;
	        _5167.x = _5165.x;
	        _5167.y = _5165.y;
	        _5167.z = _5165.z;
	        _736 = _5167;
	        _735 = _g_rtx_material_data_._m4.xy;
	    }
	    vec4 _5175 = _739;
	    vec4 _5189 = vec4((vec4(_5175.xyz, 1.0) * _g_rtx_material_data_._m58).xyz, _645);
	    vec4 _843;
	    if (_g_rtx_material_data_._m45)
	    {
	        _843 = vec4((vec4(_5175.xyz, 1.0) * _g_rtx_material_data_._m59).xyz, _5175.w);
	    }
	    else
	    {
	        _843 = _739;
	    }
	    _739 = _843;
	    if (_g_rtx_material_data_._m18 == 0)
	    {
	        vec3 _5225 = _747.xyz * _g_rtx_material_data_._g_fl_AutoPad32_.xyz;
	        vec3 _5227 = _727;
	        _5227.x = _5225.x;
	        _5227.y = _5225.y;
	        _5227.z = _5225.z;
	        _727 = _5227;
	        _726 = _g_rtx_material_data_._m20.xy;
	    }
	    else
	    {
	        vec3 _5205 = _727;
	        _5205.x = _673.z;
	        _5205.y = _673.w;
	        _727 = _5205;
	        vec4 _5216 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m79], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5205.xy, 0.0);
	        _725 = _5216.x;
	        _723 = _5216.y;
	        _724 = _5216.w;
	    }
	    if (_g_rtx_material_data_._m194)
	    {
	        _730 = vec4(0.5);
	        _729 = vec3(0.0, 0.0, 1.0);
	        _728 = vec3(0.0, 0.0, 1.0);
	        _725 = 0.5;
	        _724 = 0.5;
	        _723 = 0.5;
	        _722 = 0.5;
	        if (_g_rtx_material_data_._m2 == 0)
	        {
	            vec2 _5404 = _721 * _735;
	            vec2 _5405 = _719 * _735;
	            vec2 _5406 = _718 * _735;
	            vec2 _5407 = _720 * _735;
	            vec2 _773 = _5407;
	            vec2 _5408 = _717 * _735;
	            vec2 _772 = _5408;
	            vec2 _5409 = _716 * _735;
	            vec2 _771 = _5409;
	            vec4 _5430 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m32], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5404.xy, _5405.xy, _5406.xy) * _842.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m32], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5407.xy, _5408.xy, _5409.xy) * _842.y);
	            _739 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m171], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5404.xy, _5405.xy, _5406.xy) * _842.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m171], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5407.xy, _5408.xy, _5409.xy) * _842.y);
	            vec4 _5457 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m31], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5404.xy, _5405.xy, _5406.xy);
	            vec4 _814 = _5457;
	            _731 = _5457.z * _842.x;
	            float _5460 = _5457.x;
	            float _5461 = _5457.y;
	            float _5463 = (_5460 + _5461) - 1.00392162799835205078125;
	            float _5464 = _5460 - _5461;
	            vec3 _5473 = normalize(vec3(vec2(_5463, _5464), (1.0 - abs(_5463)) - abs(_5464))).xyz * _842.x;
	            vec3 _5475 = _738;
	            _5475.x = _5473.x;
	            _5475.y = _5473.y;
	            _5475.z = _5473.z;
	            _738 = _5475;
	            float _816;
	            if (int(sign(dot(_743.xyz, _591[_840.x]))) < 0)
	            {
	                _816 = -1.0;
	            }
	            else
	            {
	                _816 = 1.0;
	            }
	            vec3 _5491 = _738;
	            _5491.x = _5491.x * _816;
	            _738 = _5491;
	            if (int(sign(dot(_742.xyz, _591[_840.y]))) < 0)
	            {
	                _816 = -1.0;
	            }
	            else
	            {
	                _816 = 1.0;
	            }
	            vec3 _5506 = _738;
	            _5506.y = _5506.y * _816;
	            _738 = _5506;
	            vec4 _5522 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m31], g_bindless_Sampler[_g_rtx_material_data_._m169]), _773.xy, _772.xy, _771.xy);
	            _731 += (_5522.z * _842.y);
	            float _5527 = _5522.x;
	            float _5528 = _5522.y;
	            float _5530 = (_5527 + _5528) - 1.00392162799835205078125;
	            float _5531 = _5527 - _5528;
	            vec3 _5540 = normalize(vec3(vec2(_5530, _5531), (1.0 - abs(_5530)) - abs(_5531))).xyz * _842.y;
	            vec4 _5542 = _5522;
	            _5542.x = _5540.x;
	            _5542.y = _5540.y;
	            _5542.z = _5540.z;
	            _814 = _5542;
	            if (int(sign(dot(_743.xyz, _591[_841.x]))) < 0)
	            {
	                _816 = -1.0;
	            }
	            else
	            {
	                _816 = 1.0;
	            }
	            vec4 _5557 = _814;
	            _5557.x = _5557.x * _816;
	            _814 = _5557;
	            if (int(sign(dot(_742.xyz, _591[_841.y]))) < 0)
	            {
	                _816 = -1.0;
	            }
	            else
	            {
	                _816 = 1.0;
	            }
	            vec4 _5572 = _814;
	            _5572.y = _5572.y * _816;
	            _814 = _5572;
	            vec3 _5577 = _738;
	            vec3 _5580 = _5577.xyz + _5572.xyz;
	            vec3 _5582 = _5577;
	            _5582.x = _5580.x;
	            _5582.y = _5580.y;
	            _5582.z = _5580.z;
	            _734 = _5430.x;
	            _732 = _5430.y;
	            _733 = _5430.w;
	            vec2 _5593 = _5582.xy * _g_rtx_material_data_._m53;
	            vec3 _5595 = _5582;
	            _5595.x = _5593.x;
	            _5595.y = _5593.y;
	            _738 = _5595;
	            vec3 _812 = _5595.xyz;
	            bool _810;
	            if (_g_rtx_material_data_._m174)
	            {
	                _810 = !_g_rtx_material_data_._m173;
	            }
	            else
	            {
	                _810 = false;
	            }
	            if (_810)
	            {
	                float _811;
	                if (_670)
	                {
	                    _811 = 1.0;
	                }
	                else
	                {
	                    _811 = -1.0;
	                }
	                _810 = _811 < 0.0;
	            }
	            else
	            {
	                _810 = false;
	            }
	            float _813;
	            if (_810)
	            {
	                _813 = -1.0;
	            }
	            else
	            {
	                _813 = 1.0;
	            }
	            float _5623 = _813;
	            vec3 _5624 = _674.xyz * _5623;
	            if (_671.w > 0.0)
	            {
	                _813 = 1.0;
	            }
	            else
	            {
	                _813 = -1.0;
	            }
	            vec3 _5635 = cross(_5624.xyz, _671.xyz) * _813;
	            bool _808;
	            if (_g_rtx_material_data_._m174)
	            {
	                _808 = !_g_rtx_material_data_._m173;
	            }
	            else
	            {
	                _808 = false;
	            }
	            if (_808)
	            {
	                float _809;
	                if (_670)
	                {
	                    _809 = 1.0;
	                }
	                else
	                {
	                    _809 = -1.0;
	                }
	                _808 = _809 < 0.0;
	            }
	            else
	            {
	                _808 = false;
	            }
	            if (!_808)
	            {
	                vec3 _5657 = _812;
	                _5657.y = -_5657.y;
	                _812 = _5657;
	            }
	            _743 = _671.xyz;
	            _742 = _5635;
	            vec3 _5664 = _671.xyz * _812.x;
	            vec3 _807;
	            vec3 _5666 = _807;
	            _5666.x = _5664.x;
	            _5666.y = _5664.y;
	            _5666.z = _5664.z;
	            vec3 _5676 = _5666.xyz + (_5635.xyz * _812.y);
	            vec3 _5678 = _5666;
	            _5678.x = _5676.x;
	            _5678.y = _5676.y;
	            _5678.z = _5676.z;
	            vec3 _5687 = _5678.xyz + (_5624.xyz * _812.z);
	            vec3 _5689 = _5678;
	            _5689.x = _5687.x;
	            _5689.y = _5687.y;
	            _5689.z = _5687.z;
	            _807 = _5689;
	            vec3 _5695 = normalize(_5689.xyz);
	            _753 = _5695;
	            _737 = _5695;
	        }
	        else
	        {
	            _734 = _838.x;
	            vec4 _5327 = _739;
	            _5327.w = mix(_g_rtx_material_data_._m38.x, _g_rtx_material_data_._m38.z, pow(_5327.w, _g_rtx_material_data_._m38.y));
	            _733 = _838.w * float(_g_rtx_material_data_._m54);
	            float _5344 = clamp(((_g_rtx_material_data_._m33 * (_838.y - 0.5)) + 0.5) * _g_rtx_material_data_._m34, 0.0, 1.0);
	            _732 = _5344;
	            vec3 _5348 = mix(_5327.xyz, _5189.xyz, vec3(_5344));
	            vec4 _5350 = _5327;
	            _5350.x = _5348.x;
	            _5350.y = _5348.y;
	            _5350.z = _5348.z;
	            float _5363 = dot(_5350.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	            vec3 _5366 = normalize(max(_675.xyz, vec3(0.001000000047497451305389404296875)));
	            _739 = vec4(clamp(mix(_5350.xyz, (_5366 * min(_5363 / dot(_5366.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _5363) * max(_675.x, max(_675.y, _675.z)))).xyz, vec3((_675.w * _5344) * float(_g_rtx_material_data_._m55))), vec3(0.0), vec3(1.0)).xyz, _5350.w);
	        }
	        if (_g_rtx_material_data_._m18 == 0)
	        {
	            vec2 _5720 = _721 * _726;
	            vec2 _5721 = _719 * _726;
	            vec2 _5722 = _718 * _726;
	            vec2 _5723 = _720 * _726;
	            vec2 _776 = _5723;
	            vec2 _5724 = _717 * _726;
	            vec2 _775 = _5724;
	            vec2 _5725 = _716 * _726;
	            vec2 _774 = _5725;
	            vec4 _5746 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m79], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5720.xy, _5721.xy, _5722.xy) * _842.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m79], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5723.xy, _5724.xy, _5725.xy) * _842.y);
	            _730 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m77], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5720.xy, _5721.xy, _5722.xy) * _842.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m77], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5723.xy, _5724.xy, _5725.xy) * _842.y);
	            vec4 _5773 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m78], g_bindless_Sampler[_g_rtx_material_data_._m169]), _5720.xy, _5721.xy, _5722.xy);
	            vec4 _801 = _5773;
	            _722 = _5773.z * _842.x;
	            float _5776 = _5773.x;
	            float _5777 = _5773.y;
	            float _5779 = (_5776 + _5777) - 1.00392162799835205078125;
	            float _5780 = _5776 - _5777;
	            vec3 _5789 = normalize(vec3(vec2(_5779, _5780), (1.0 - abs(_5779)) - abs(_5780))).xyz * _842.x;
	            vec3 _5791 = _729;
	            _5791.x = _5789.x;
	            _5791.y = _5789.y;
	            _5791.z = _5789.z;
	            _729 = _5791;
	            float _803;
	            if (int(sign(dot(_743.xyz, _591[_840.x]))) < 0)
	            {
	                _803 = -1.0;
	            }
	            else
	            {
	                _803 = 1.0;
	            }
	            vec3 _5807 = _729;
	            _5807.x = _5807.x * _803;
	            _729 = _5807;
	            if (int(sign(dot(_742.xyz, _591[_840.y]))) < 0)
	            {
	                _803 = -1.0;
	            }
	            else
	            {
	                _803 = 1.0;
	            }
	            vec3 _5822 = _729;
	            _5822.y = _5822.y * _803;
	            _729 = _5822;
	            vec4 _5838 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m78], g_bindless_Sampler[_g_rtx_material_data_._m169]), _776.xy, _775.xy, _774.xy);
	            _722 += (_5838.z * _842.y);
	            float _5843 = _5838.x;
	            float _5844 = _5838.y;
	            float _5846 = (_5843 + _5844) - 1.00392162799835205078125;
	            float _5847 = _5843 - _5844;
	            vec3 _5856 = normalize(vec3(vec2(_5846, _5847), (1.0 - abs(_5846)) - abs(_5847))).xyz * _842.y;
	            vec4 _5858 = _5838;
	            _5858.x = _5856.x;
	            _5858.y = _5856.y;
	            _5858.z = _5856.z;
	            _801 = _5858;
	            if (int(sign(dot(_743.xyz, _591[_841.x]))) < 0)
	            {
	                _803 = -1.0;
	            }
	            else
	            {
	                _803 = 1.0;
	            }
	            vec4 _5873 = _801;
	            _5873.x = _5873.x * _803;
	            _801 = _5873;
	            if (int(sign(dot(_742.xyz, _591[_841.y]))) < 0)
	            {
	                _803 = -1.0;
	            }
	            else
	            {
	                _803 = 1.0;
	            }
	            vec4 _5888 = _801;
	            _5888.y = _5888.y * _803;
	            _801 = _5888;
	            vec3 _5893 = _729;
	            vec3 _5896 = _5893.xyz + _5888.xyz;
	            vec3 _5898 = _5893;
	            _5898.x = _5896.x;
	            _5898.y = _5896.y;
	            _5898.z = _5896.z;
	            _725 = _5746.x;
	            _723 = _5746.y;
	            _724 = _5746.w;
	            vec2 _5909 = _5898.xy * _g_rtx_material_data_._m73;
	            vec3 _5911 = _5898;
	            _5911.x = _5909.x;
	            _5911.y = _5909.y;
	            _729 = _5911;
	            vec3 _799 = _5911.xyz;
	            bool _797;
	            if (_g_rtx_material_data_._m174)
	            {
	                _797 = !_g_rtx_material_data_._m173;
	            }
	            else
	            {
	                _797 = false;
	            }
	            if (_797)
	            {
	                float _798;
	                if (_670)
	                {
	                    _798 = 1.0;
	                }
	                else
	                {
	                    _798 = -1.0;
	                }
	                _797 = _798 < 0.0;
	            }
	            else
	            {
	                _797 = false;
	            }
	            float _800;
	            if (_797)
	            {
	                _800 = -1.0;
	            }
	            else
	            {
	                _800 = 1.0;
	            }
	            float _5939 = _800;
	            vec3 _5940 = _674.xyz * _5939;
	            if (_671.w > 0.0)
	            {
	                _800 = 1.0;
	            }
	            else
	            {
	                _800 = -1.0;
	            }
	            vec3 _5951 = cross(_5940.xyz, _671.xyz) * _800;
	            bool _795;
	            if (_g_rtx_material_data_._m174)
	            {
	                _795 = !_g_rtx_material_data_._m173;
	            }
	            else
	            {
	                _795 = false;
	            }
	            if (_795)
	            {
	                float _796;
	                if (_670)
	                {
	                    _796 = 1.0;
	                }
	                else
	                {
	                    _796 = -1.0;
	                }
	                _795 = _796 < 0.0;
	            }
	            else
	            {
	                _795 = false;
	            }
	            if (!_795)
	            {
	                vec3 _5973 = _799;
	                _5973.y = -_5973.y;
	                _799 = _5973;
	            }
	            _743 = _671.xyz;
	            _742 = _5951;
	            vec3 _5980 = _671.xyz * _799.x;
	            vec3 _794;
	            vec3 _5982 = _794;
	            _5982.x = _5980.x;
	            _5982.y = _5980.y;
	            _5982.z = _5980.z;
	            vec3 _5992 = _5982.xyz + (_5951.xyz * _799.y);
	            vec3 _5994 = _5982;
	            _5994.x = _5992.x;
	            _5994.y = _5992.y;
	            _5994.z = _5992.z;
	            vec3 _6003 = _5994.xyz + (_5940.xyz * _799.z);
	            vec3 _6005 = _5994;
	            _6005.x = _6003.x;
	            _6005.y = _6003.y;
	            _6005.z = _6003.z;
	            _794 = _6005;
	            vec3 _6011 = normalize(_6005.xyz);
	            _753 = _6011;
	            _728 = _6011;
	        }
	    }
	    else
	    {
	        if (_g_rtx_material_data_._m2 != 0)
	        {
	            _734 = _838.x;
	            vec4 _5254 = _739;
	            _5254.w = mix(_g_rtx_material_data_._m38.x, _g_rtx_material_data_._m38.z, pow(_5254.w, _g_rtx_material_data_._m38.y));
	            _733 = _838.w * float(_g_rtx_material_data_._m54);
	            float _5271 = clamp(((_g_rtx_material_data_._m33 * (_838.y - 0.5)) + 0.5) * _g_rtx_material_data_._m34, 0.0, 1.0);
	            _732 = _5271;
	            vec3 _5275 = mix(_5254.xyz, _5189.xyz, vec3(_5271));
	            vec4 _5277 = _5254;
	            _5277.x = _5275.x;
	            _5277.y = _5275.y;
	            _5277.z = _5275.z;
	            float _5290 = dot(_5277.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	            vec3 _5293 = normalize(max(_675.xyz, vec3(0.001000000047497451305389404296875)));
	            _739 = vec4(clamp(mix(_5277.xyz, (_5293 * min(_5290 / dot(_5293.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _5290) * max(_675.x, max(_675.y, _675.z)))).xyz, vec3((_675.w * _5271) * float(_g_rtx_material_data_._m55))), vec3(0.0), vec3(1.0)).xyz, _5277.w);
	        }
	    }
	    float _6022 = max(min(_676.w + _g_rtx_material_data_._m15, 1.0), 9.9999997473787516355514526367188e-05);
	    vec2 _845 = vec2(1.0, 0.0);
	    float _6027 = _g_rtx_material_data_._m46 + _6022;
	    vec3 _6033 = vec3(0.0);
	    _6033.x = (_734 - _g_rtx_material_data_._m47) * _6027;
	    vec3 _844 = _6033;
	    if (_g_rtx_material_data_._m106)
	    {
	        _734 = max(0.0, ((_734 + 0.5) - _g_rtx_material_data_._m47) * _g_rtx_material_data_._m46);
	    }
	    float _6051 = _g_rtx_material_data_._m90 + _6022;
	    vec3 _6058 = _738;
	    float _6062 = (_6058.x + _6058.y) - 1.00392162799835205078125;
	    float _6063 = _6058.x - _6058.y;
	    vec3 _6070 = normalize(vec3(vec2(_6062, _6063), (1.0 - abs(_6062)) - abs(_6063)));
	    vec3 _6072 = _6058;
	    _6072.x = _6070.x;
	    _6072.y = _6070.y;
	    _6072.z = _6070.z;
	    vec2 _6087 = vec2(dot(_6072.xy, _g_rtx_material_data_._m13.xy), dot(_6072.xy, _g_rtx_material_data_._m13.zw)) * _g_rtx_material_data_._m53;
	    vec3 _6089 = _6072;
	    _6089.x = _6087.x;
	    _6089.y = _6087.y;
	    _738 = _6089;
	    _731 = _6058.z;
	    vec3 _777;
	    vec3 _778;
	    if (_g_rtx_material_data_._m2 > 1)
	    {
	        _778 = _741;
	        _777 = _740;
	    }
	    else
	    {
	        _778 = _669;
	        _777 = _668;
	    }
	    vec3 _6100 = abs(_738.xyz);
	    vec2 _6113 = (-vec2(_738.x, (-1.0) * _738.y)) / vec2(max(_6100.z, 0.0078125 * max(_6100.x, _6100.y)));
	    vec3 _6123 = normalize(_782 - ((_778 * _6113.x) + (_777 * _6113.y)));
	    _737 = _6123;
	    float _6126 = _731;
	    float _6132 = clamp(((_g_rtx_material_data_._m51 * (_6126 - 0.5)) + 0.5) * _g_rtx_material_data_._m52, 0.0, 1.0);
	    _731 = _6132;
	    vec3 _6133 = _6123.xyz;
	    float _846;
	    if (_g_rtx_material_data_._m189)
	    {
	        _846 = _4848 * smoothstep(_g_rtx_material_data_._m98.x, _g_rtx_material_data_._m98.y, (dot(_g_rtx_material_data_._m94.xyz, mix(_737.xyz, _746.xyz, vec3(min(1.0, _g_rtx_material_data_._m15 + _g_rtx_material_data_._m99))).xyz) * 0.5) + 0.5);
	    }
	    else
	    {
	        _846 = _4848;
	    }
	    vec3 _6167 = _844;
	    _6167.y = (_725 - _g_rtx_material_data_._m91) * (_g_rtx_material_data_._m90 - _6022);
	    _844 = _6167;
	    if (_g_rtx_material_data_._m106)
	    {
	        _725 = max(0.0, ((_725 + 0.5) - _g_rtx_material_data_._m91) * _g_rtx_material_data_._m90);
	    }
	    vec3 _6180 = _844;
	    _6180.y = _6180.y + mix((((-_g_rtx_material_data_._m47) * _6027) - ((1.0 - _g_rtx_material_data_._m91) * _6051)) - _6022, ((1.0 - _g_rtx_material_data_._m47) * _6027) - ((-_g_rtx_material_data_._m91) * _6051), _846);
	    _844 = _6180;
	    vec2 _6197 = max((_6180.xy - vec2(max(_6180.x, _6180.y))) + vec2(_6022), vec2(0.0));
	    vec2 _6199 = _845;
	    _6199.x = _6197.x;
	    _6199.y = _6197.y;
	    _6199.x = _6199.x + 9.9999997473787516355514526367188e-05;
	    vec2 _6211 = _6199.xy / vec2(_6199.x + _6199.y);
	    vec2 _6213 = _6199;
	    _6213.x = _6211.x;
	    _6213.y = _6211.y;
	    _845 = _6213;
	    float _6223 = clamp((_6213.y * mix(0.5, _725, _g_rtx_material_data_._m100)) * 2.0, 0.0, 1.0);
	    bool _6228 = _6223 > 0.0500000007450580596923828125;
	    vec3 _847;
	    if (_6228)
	    {
	        if (_g_rtx_material_data_._m18 != 0)
	        {
	            _730 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m77], g_bindless_Sampler[_g_rtx_material_data_._m169]), _727.xy, vec2(0.0), vec2(0.0)).xyzw;
	            vec4 _6253 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m78], g_bindless_Sampler[_g_rtx_material_data_._m169]), _727.xy, vec2(0.0), vec2(0.0));
	            float _6254 = _6253.x;
	            float _6255 = _6253.y;
	            float _6257 = (_6254 + _6255) - 1.00392162799835205078125;
	            float _6258 = _6254 - _6255;
	            vec3 _6265 = normalize(vec3(vec2(_6257, _6258), (1.0 - abs(_6257)) - abs(_6258)));
	            vec3 _6267 = _729;
	            _6267.x = _6265.x;
	            _6267.y = _6265.y;
	            _6267.z = _6265.z;
	            vec2 _6283 = vec2(dot(_6267.xy, _g_rtx_material_data_._m29.xy), dot(_6267.xy, _g_rtx_material_data_._m29.zw)) * _g_rtx_material_data_._m73;
	            vec3 _6285 = _6267;
	            _6285.x = _6283.x;
	            _6285.y = _6283.y;
	            _729 = _6285;
	            _722 = _6253.z;
	            vec3 _714;
	            vec3 _715;
	            if (_g_rtx_material_data_._m18 == 1)
	            {
	                _715 = _669;
	                _714 = _668;
	            }
	            else
	            {
	                _715 = _741;
	                _714 = _740;
	            }
	            vec3 _6298 = abs(_729.xyz);
	            vec2 _6311 = (-vec2(_729.x, (-1.0) * _729.y)) / vec2(max(_6298.z, 0.0078125 * max(_6298.x, _6298.y)));
	            _728 = normalize(_782 - ((_715 * _6311.x) + (_714 * _6311.y)));
	        }
	        _724 *= float(_g_rtx_material_data_._m74);
	        _722 = clamp(((_g_rtx_material_data_._m71 * (_722 - 0.5)) + 0.5) * _g_rtx_material_data_._m72, 0.0, 1.0);
	        _723 = clamp(((_g_rtx_material_data_._m75 * (_723 - 0.5)) + 0.5) * _g_rtx_material_data_._m76, 0.0, 1.0);
	        if (_g_rtx_material_data_._m87)
	        {
	            _838 = vec4((vec4(_730.xyz, 1.0) * _g_rtx_material_data_._m89).xyz, _730.w);
	        }
	        else
	        {
	            _838 = _730;
	        }
	        vec4 _6362 = _838;
	        vec3 _6367 = mix(_6362.xyz, vec4((vec4(_730.xyz, 1.0) * _g_rtx_material_data_._m88).xyz, _645).xyz, vec3(_723));
	        vec4 _6369 = _6362;
	        _6369.x = _6367.x;
	        _6369.y = _6367.y;
	        _6369.z = _6367.z;
	        _6369.w = mix(_g_rtx_material_data_._m80.x, _g_rtx_material_data_._m80.z, pow(_6369.w, _g_rtx_material_data_._m80.y));
	        float _6393 = dot(_6369.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        vec3 _6396 = normalize(max(_675.xyz, vec3(0.001000000047497451305389404296875)));
	        _730 = vec4(clamp(mix(_6369.xyz, (_6396 * min(_6393 / dot(_6396.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _6393) * max(_675.x, max(_675.y, _675.z)))).xyz, vec3((_675.w * _723) * float(_g_rtx_material_data_._m104))), vec3(0.0), vec3(1.0)).xyz, _6369.w);
	        _847 = mix(mix(_6133, normalize(mix(_746, (_6133 + _728.xyz) * vec3(0.5), vec3(2.0))), vec3(_6223 * _g_rtx_material_data_._m64)), _728.xyz, vec3((_6223 * clamp((_6180.y + _g_rtx_material_data_._m91) - _6180.x, 0.0, 1.0)) * _g_rtx_material_data_._m63));
	    }
	    else
	    {
	        _847 = _6133;
	    }
	    float _848;
	    float _849;
	    vec3 _850;
	    if (_6228)
	    {
	        vec3 _6438 = _730.xyz * 12.9200000762939453125;
	        vec3 _6441 = (pow(_730.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	        float _791;
	        if (_730.x <= 0.003130800090730190277099609375)
	        {
	            _791 = _6438.x;
	        }
	        else
	        {
	            _791 = _6441.x;
	        }
	        float _792;
	        if (_730.y <= 0.003130800090730190277099609375)
	        {
	            _792 = _6438.y;
	        }
	        else
	        {
	            _792 = _6441.y;
	        }
	        float _793;
	        if (_730.z <= 0.003130800090730190277099609375)
	        {
	            _793 = _6438.z;
	        }
	        else
	        {
	            _793 = _6441.z;
	        }
	        _850 = mix(_739.xyz * mix(vec3(1.0), vec3(_791, _792, _793) * 2.0, vec3(_6223 * _g_rtx_material_data_._m62)), _730.xyz, vec3(_6223 * _g_rtx_material_data_._m61));
	        _848 = mix(_6132 * (1.0 + ((((_722 - _6132) * 2.0) * _6223) * _g_rtx_material_data_._m66)), _722, _6223 * _g_rtx_material_data_._m65);
	        _849 = mix(_733 * mix(1.0, _724 * 2.0, _6223 * _g_rtx_material_data_._m68), _724, _6223 * _g_rtx_material_data_._m67);
	    }
	    else
	    {
	        _850 = _739.xyz;
	        _848 = _6132;
	        _849 = _733;
	    }
	    _753 = _847;
	    float _6503 = saturate(1.0 - _6223);
	    vec2 _6537 = _751;
	    _6537.x = _848;
	    _6537.y = _848;
	    _751 = _6537;
	    _752 = _850 * mix(vec3(1.0), _672.xyz, vec3(clamp(clamp(((float(!_g_rtx_material_data_._m50) * _6503) + (float(!_g_rtx_material_data_._m103) * _6223)) + ((_732 * _6503) + (_723 * _6223)), 0.0, 1.0) * ((float(_g_rtx_material_data_._m49) * _6503) + (float(_g_rtx_material_data_._m102) * _6223)), 0.0, 1.0)));
	    switch (_g_rtx_material_data_._m192)
	    {
	        case 0u:
	        {
	            break;
	        }
	        case 1u:
	        {
	            vec3 _6561 = _752;
	            _6561.x = _6503;
	            _6561.y = _6223;
	            _6561.z = 0.0;
	            _752 = _6561;
	            break;
	        }
	        case 2u:
	        {
	            float _6556 = (mix(_6180.x, _6180.y, _6223) * 0.5) + 0.5;
	            vec3 _6557 = _752;
	            _6557.x = _6556;
	            _6557.y = _6556;
	            _6557.z = _6556;
	            _752 = _6557;
	            break;
	        }
	        case 3u:
	        {
	            vec3 _6549 = _752;
	            _6549.x = _676.x;
	            _6549.y = _676.y;
	            _6549.z = _676.z;
	            _752 = _6549;
	            break;
	        }
	        default:
	        {
	            break;
	        }
	    }
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _745;
	    _21._m2 = _746;
	    vec3 _783[3] = vec3[](_662, _655, _650);
	    vec3 _784[3] = vec3[](_663, _656, _651);
	    vec3 _6600 = ((_663 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_656 * _22.barycentrics.x)) + (_651 * _22.barycentrics.y);
	    vec3 _785[3];
	    _785[0] = _6600 - (_662 * dot(_6600 - _663, _662));
	    _785[1] = _6600 - (_655 * dot(_6600 - _656, _655));
	    _785[2] = _6600 - (_650 * dot(_6600 - _651, _650));
	    vec3 _6628 = ((_785[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_785[1] * _22.barycentrics.x)) + (_785[2] * _22.barycentrics.y);
	    vec3 _786[3];
	    _786[0] = cross(_663 - _656, _21._m1);
	    _786[1] = cross(_656 - _651, _21._m1);
	    _786[2] = cross(_651 - _663, _21._m1);
	    float _787 = dot(_6628 - _6600, _21._m1);
	    vec3 _788 = _6628;
	    int _789 = 0;
	    for (;;)
	    {
	        bool _6644_ladder_break = false;
	        do
	        {
	            if (!(_789 < 3))
	            {
	                _6644_ladder_break = true;
	                break;
	            }
	            if (_787 > 0.00999999977648258209228515625)
	            {
	                _6644_ladder_break = true;
	                break;
	            }
	            if (dot(_786[_789], _786[_789]) == 0.0)
	            {
	                break;
	            }
	            _786[_789] = normalize(_786[_789]);
	            int _790 = 0;
	            for (;;)
	            {
	                if (!(_790 < 3))
	                {
	                    break;
	                }
	                vec3 _6682 = _783[_790] - (_786[_789] * dot(_786[_789], _783[_790]));
	                _785[_790] = _6600 - (_6682 * dot(_6600 - _784[_790], _6682));
	                _790++;
	                continue;
	            }
	            vec3 _6706 = ((_785[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_785[1] * _22.barycentrics.x)) + (_785[2] * _22.barycentrics.y);
	            _787 = dot(_6706 - _6600, _21._m1);
	            _788 = _6706;
	            break;
	        } while(false);
	        if (_6644_ladder_break)
	        {
	            break;
	        }
	        _789++;
	        continue;
	    }
	    if (!(_787 > 0.00999999977648258209228515625))
	    {
	        _788 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _788;
	    _21._m6 = _744;
	    f16vec3 _6719 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_6719, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _6719, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(_753);
	    _21._m7._m2 = f16vec3(_752);
	    _21._m7._m4 = f16vec3(_750);
	    _21._m7._m5 = float16_t(_749);
	    _21._m7._m1 = float16_t(_849);
	    _21._m7._m3 = float16_t(dot(_751, vec2(0.5)));
	    if (any(greaterThan(_748, vec3(0.0))))
	    {
	        f16vec4 _6748 = _21._m7._m7;
	        f16vec3 _6751 = f16vec3(_748);
	        _6748.x = _6751.x;
	        _6748.y = _6751.y;
	        _6748.z = _6751.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _6748);
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
	
	#if (S_DETAIL_NORMAL == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
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
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(HasTexcoordTransform, (((((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || (((g_vTexCoordScale2.x!=1) || (g_vTexCoordScale2.y!=1)) || (g_flTexCoordRotation2!=0))) || (((g_vTexCoordScale3.x!=1) || (g_vTexCoordScale3.y!=1)) || (g_flTexCoordRotation3!=0))) || 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
	#endif
	#if (S_SHADER_QUALITY == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
}
