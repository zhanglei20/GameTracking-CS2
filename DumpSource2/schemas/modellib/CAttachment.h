class CAttachment
{
	CUtlString m_name;
	CUtlString[3] m_influenceNames;
	Quaternion[3] m_vInfluenceRotations;
	Vector[3] m_vInfluenceOffsets;
	float32[3] m_influenceWeights;
	bool[3] m_bInfluenceRootTransform;
	uint8 m_nInfluences;
	bool m_bIgnoreRotation;
};
