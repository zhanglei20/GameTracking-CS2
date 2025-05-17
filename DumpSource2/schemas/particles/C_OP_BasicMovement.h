// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_OP_BasicMovement : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "gravity"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_Gravity;
	// MPropertyFriendlyName = "drag"
	// MPropertyAttributeRange = "-1 1"
	CParticleCollectionFloatInput m_fDrag;
	// MPropertyFriendlyName = "Mass controls"
	CParticleMassCalculationParameters m_massControls;
	// MPropertyFriendlyName = "max constraint passes"
	int32 m_nMaxConstraintPasses;
	// MPropertyFriendlyName = "use new code"
	bool m_bUseNewCode;
};
