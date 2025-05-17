// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_OP_SetPerChildControlPointFromAttribute : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "group ID to affect"
	int32 m_nChildGroupID;
	// MPropertyFriendlyName = "control point to set"
	int32 m_nFirstControlPoint;
	// MPropertyFriendlyName = "# of children to set"
	int32 m_nNumControlPoints;
	// MPropertyFriendlyName = "particle increment amount"
	int32 m_nParticleIncrement;
	// MPropertyFriendlyName = "first particle to copy"
	int32 m_nFirstSourcePoint;
	// MPropertyFriendlyName = "set number of children based on particle count"
	bool m_bNumBasedOnParticleCount;
	// MPropertyFriendlyName = "field to read"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nAttributeToRead;
	// MPropertyFriendlyName = "control point field for scalars"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nCPField;
};
