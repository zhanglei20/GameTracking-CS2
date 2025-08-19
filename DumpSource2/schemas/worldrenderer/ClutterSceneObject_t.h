// MGetKV3ClassDefaults = {
//	"m_Bounds":
//	{
//		"m_vMinBounds":
//		[
//			0.000000,
//			0.000000,
//			-11891999938445312.000000
//		],
//		"m_vMaxBounds":
//		[
//			0.000000,
//			0.000000,
//			0.000000
//		]
//	},
//	"m_flags": "OBJECT_TYPE_NONE",
//	"m_nLayer": 0,
//	"m_instancePositions":
//	[
//	],
//	"m_instanceScales":
//	[
//	],
//	"m_instanceTintSrgb":
//	[
//	],
//	"m_tiles":
//	[
//	],
//	"m_renderableModel": "",
//	"m_materialGroup": "",
//	"m_flBeginCullSize": 0.020000,
//	"m_flEndCullSize": 0.012500,
//	"m_InstanceOrientations32":
//	[
//	]
//}
class ClutterSceneObject_t
{
	AABB_t m_Bounds;
	ObjectTypeFlags_t m_flags;
	int16 m_nLayer;
	CUtlVector< Vector > m_instancePositions;
	CUtlVector< float32 > m_instanceScales;
	CUtlVector< Color > m_instanceTintSrgb;
	CUtlVector< ClutterTile_t > m_tiles;
	CStrongHandle< InfoForResourceTypeCModel > m_renderableModel;
	CUtlStringToken m_materialGroup;
	float32 m_flBeginCullSize;
	float32 m_flEndCullSize;
};
