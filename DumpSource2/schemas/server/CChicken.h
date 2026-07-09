class CChicken : public CDynamicProp, public IHasAttributes
{
	CAttributeContainer m_AttributeManager;
	CountdownTimer m_updateTimer;
	VectorWS m_stuckAnchor;
	CountdownTimer m_collisionStuckTimer;
	bool m_isOnGround;
	Vector m_vFallVelocity;
	EChickenActivity m_desiredActivity;
	EChickenActivity m_currentActivity;
	CountdownTimer m_activityTimer;
	float32 m_turnRate;
	CHandle< CBaseEntity > m_fleeFrom;
	CountdownTimer m_moveRateThrottleTimer;
	CountdownTimer m_startleTimer;
	CountdownTimer m_vocalizeTimer;
	CHandle< CCSPlayerPawn > m_leader;
	CountdownTimer m_reuseTimer;
	CountdownTimer m_jumpTimer;
	float32 m_flLastJumpTime;
	CountdownTimer m_repathTimer;
	VectorWS m_vecPathGoal;
	GameTime_t m_flActiveFollowStartTime;
	CountdownTimer m_followMinuteTimer;
	CountdownTimer m_BlockDirectionTimer;
};
