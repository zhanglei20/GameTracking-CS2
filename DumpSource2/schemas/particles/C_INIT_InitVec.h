// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_INIT_InitVec : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "value"
	CPerParticleVecInput m_InputValue;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nOutputField;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod;
	// MPropertyFriendlyName = "normalize result"
	bool m_bNormalizedOutput;
	// MPropertyFriendlyName = "set previous position"
	// MPropertySuppressExpr = "m_nOutputField != PARTICLE_ATTRIBUTE_XYZ"
	bool m_bWritePreviousPosition;
};
