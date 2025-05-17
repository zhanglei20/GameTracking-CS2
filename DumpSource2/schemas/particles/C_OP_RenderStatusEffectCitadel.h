// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_OP_RenderStatusEffectCitadel : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "color warp texture (3d)"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureColorWarp;
	// MPropertyFriendlyName = "normal texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureNormal;
	// MPropertyFriendlyName = "metalness texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureMetalness;
	// MPropertyFriendlyName = "roughness texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureRoughness;
	// MPropertyFriendlyName = "self illum texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureSelfIllum;
	// MPropertyFriendlyName = "detail texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureDetail;
};
