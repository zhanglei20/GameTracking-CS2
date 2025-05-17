// MNetworkVarNames = "int32 m_nameStringableIndex"
class CEntityIdentity
{
	// MNetworkEnable
	// MNetworkChangeCallback = "entityIdentityNameChanged"
	int32 m_nameStringableIndex;
	CUtlSymbolLarge m_name;
	CUtlSymbolLarge m_designerName;
	uint32 m_flags;
	// MNetworkDisable
	WorldGroupId_t m_worldGroupId;
	uint32 m_fDataObjectTypes;
	// MNetworkDisable
	// MNetworkChangeAccessorFieldPathIndex
	ChangeAccessorFieldPathIndex_t m_PathIndex;
	CEntityIdentity* m_pPrev;
	CEntityIdentity* m_pNext;
	CEntityIdentity* m_pPrevByClass;
	CEntityIdentity* m_pNextByClass;
};
