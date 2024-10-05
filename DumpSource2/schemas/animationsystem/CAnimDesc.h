class CAnimDesc
{
	CBufferString m_name;
	CAnimDesc_Flag m_flags;
	float32 fps;
	CAnimEncodedFrames m_Data;
	CUtlVector< CAnimMovement > m_movementArray;
	CTransform m_xInitialOffset;
	CUtlVector< CAnimEventDefinition > m_eventArray;
	CUtlVector< CAnimActivity > m_activityArray;
	CUtlVector< CAnimLocalHierarchy > m_hierarchyArray;
	float32 framestalltime;
	Vector m_vecRootMin;
	Vector m_vecRootMax;
	CUtlVector< Vector > m_vecBoneWorldMin;
	CUtlVector< Vector > m_vecBoneWorldMax;
	CAnimSequenceParams m_sequenceParams;
};
