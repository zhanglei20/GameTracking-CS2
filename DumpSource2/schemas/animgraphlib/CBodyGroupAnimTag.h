// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MPropertyFriendlyName = "Body Group Tag"
// M_LEGACY_OptInToSchemaPropertyDomain
class CBodyGroupAnimTag : public CAnimTagBase
{
	// MPropertyFriendlyName = "Priority"
	int32 m_nPriority;
	// MPropertyFriendlyName = "Body Group Settings"
	CUtlVector< CBodyGroupSetting > m_bodyGroupSettings;
};
