// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_OP_QuantizeCPComponent : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "input"
	CParticleCollectionFloatInput m_flInputValue;
	// MPropertyFriendlyName = "output control point"
	int32 m_nCPOutput;
	// MPropertyFriendlyName = "output component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nOutVectorField;
	// MPropertyFriendlyName = "interval to snap to"
	CParticleCollectionFloatInput m_flQuantizeValue;
};
