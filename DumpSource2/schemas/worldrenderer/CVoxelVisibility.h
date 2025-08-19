// MGetKV3ClassDefaults = {
//	"m_nBaseClusterCount": 0,
//	"m_nPVSBytesPerCluster": 0,
//	"m_vMinBounds":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_vMaxBounds":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_flGridSize": 0.000000,
//	"m_nSkyVisibilityCluster": 0,
//	"m_nSunVisibilityCluster": 0,
//	"m_NodeBlock":
//	{
//		"m_nOffset": <HIDDEN FOR DIFF>,
//		"m_nElementCount": 134686576
//	},
//	"m_RegionBlock":
//	{
//		"m_nOffset": <HIDDEN FOR DIFF>,
//		"m_nElementCount": 1760408
//	},
//	"m_EnclosedClusterListBlock":
//	{
//		"m_nOffset": <HIDDEN FOR DIFF>,
//		"m_nElementCount": 21
//	},
//	"m_EnclosedClustersBlock":
//	{
//		"m_nOffset": <HIDDEN FOR DIFF>,
//		"m_nElementCount": 4
//	},
//	"m_MasksBlock":
//	{
//		"m_nOffset": <HIDDEN FOR DIFF>,
//		"m_nElementCount": 134686800
//	},
//	"m_nVisBlocks":
//	{
//		"m_nOffset": <HIDDEN FOR DIFF>,
//		"m_nElementCount": 30174504
//	}
//}
class CVoxelVisibility
{
	uint32 m_nBaseClusterCount;
	uint32 m_nPVSBytesPerCluster;
	Vector m_vMinBounds;
	Vector m_vMaxBounds;
	float32 m_flGridSize;
	uint32 m_nSkyVisibilityCluster;
	uint32 m_nSunVisibilityCluster;
	VoxelVisBlockOffset_t m_NodeBlock;
	VoxelVisBlockOffset_t m_RegionBlock;
	VoxelVisBlockOffset_t m_EnclosedClusterListBlock;
	VoxelVisBlockOffset_t m_EnclosedClustersBlock;
	VoxelVisBlockOffset_t m_MasksBlock;
	VoxelVisBlockOffset_t m_nVisBlocks;
};
