// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_OP_SetControlPointFieldFromVectorExpression : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "expression"
	VectorFloatExpressionType_t m_nExpression;
	// MPropertyFriendlyName = "input 1"
	CParticleCollectionVecInput m_vecInput1;
	// MPropertyFriendlyName = "input 2"
	CParticleCollectionVecInput m_vecInput2;
	// MPropertyFriendlyName = "lerp value"
	// MPropertySuppressExpr = "m_nExpression != VECTOR_EXPRESSION_LERP"
	CPerParticleFloatInput m_flLerp;
	// MPropertyFriendlyName = "output"
	CParticleRemapFloatInput m_flOutputRemap;
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutputCP;
	// MPropertyFriendlyName = "output component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nOutVectorField;
};
