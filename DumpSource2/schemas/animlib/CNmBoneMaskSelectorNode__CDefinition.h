class CNmBoneMaskSelectorNode::CDefinition : public CNmBoneMaskValueNode::CDefinition
{
	int16 m_defaultMaskNodeIdx;
	int16 m_parameterValueNodeIdx;
	bool m_switchDynamically;
	CUtlVectorFixedGrowable< int16, 7 > m_maskNodeIndices;
	CUtlVectorFixedGrowable< CGlobalSymbol, 7 > m_parameterValues;
	float32 m_flBlendTimeSeconds;
};
