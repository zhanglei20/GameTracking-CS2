class CCachedPose
{
	CUtlVector< CTransform > m_transforms;
	CUtlVector< float32 > m_morphWeights;
	HSequence m_hSequence;
	float32 m_flCycle;
};
