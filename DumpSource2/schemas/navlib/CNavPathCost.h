// MGetKV3ClassDefaults = Could not parse KV3 Defaults
class CNavPathCost : public INavPathCost
{
	bool m_bAllowLadders;
	bool m_bCanFly;
	bool m_bCanSwim;
	float32 m_flWaterToGroundMaxHeight;
	float32 m_flGroundToWaterMaxHeight;
	float32 m_flGroundToWaterTransitionDistance;
	float32 m_flWaterToGroundTransitionDistance;
	float32 m_flFlyingTransitionTolerance;
	bool m_bOptimizeFlySpacePathfinds;
	bool m_bStringPullFlySpacePathfinds;
	bool m_bSupportsTransitions;
	float32 m_flTransitionPenalty;
};
