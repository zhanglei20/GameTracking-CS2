class CCSBot : public CBot
{
	Vector m_eyePosition;
	char[64] m_name;
	float32 m_combatRange;
	bool m_isRogue;
	CountdownTimer m_rogueTimer;
	bool m_diedLastRound;
	float32 m_safeTime;
	bool m_wasSafe;
	bool m_blindFire;
	CountdownTimer m_surpriseTimer;
	bool m_bAllowActive;
	bool m_isFollowing;
	CHandle< CCSPlayerPawn > m_leader;
	float32 m_followTimestamp;
	float32 m_allowAutoFollowTime;
	CountdownTimer m_hurryTimer;
	CountdownTimer m_alertTimer;
	CountdownTimer m_sneakTimer;
	CountdownTimer m_panicTimer;
	float32 m_stateTimestamp;
	bool m_isAttacking;
	bool m_isOpeningDoor;
	CHandle< CBaseEntity > m_taskEntity;
	Vector m_goalPosition;
	CHandle< CBaseEntity > m_goalEntity;
	CHandle< CBaseEntity > m_avoid;
	float32 m_avoidTimestamp;
	bool m_isStopping;
	bool m_hasVisitedEnemySpawn;
	IntervalTimer m_stillTimer;
	bool m_bEyeAnglesUnderPathFinderControl;
	int32 m_pathIndex;
	GameTime_t m_areaEnteredTimestamp;
	CountdownTimer m_repathTimer;
	CountdownTimer m_avoidFriendTimer;
	bool m_isFriendInTheWay;
	CountdownTimer m_politeTimer;
	bool m_isWaitingBehindFriend;
	float32 m_pathLadderEnd;
	CountdownTimer m_mustRunTimer;
	CountdownTimer m_waitTimer;
	CountdownTimer m_updateTravelDistanceTimer;
	float32[64] m_playerTravelDistance;
	uint8 m_travelDistancePhase;
	uint8 m_hostageEscortCount;
	float32 m_hostageEscortCountTimestamp;
	int32 m_desiredTeam;
	bool m_hasJoined;
	bool m_isWaitingForHostage;
	CountdownTimer m_inhibitWaitingForHostageTimer;
	CountdownTimer m_waitForHostageTimer;
	Vector m_noisePosition;
	float32 m_noiseTravelDistance;
	float32 m_noiseTimestamp;
	CCSPlayerPawn* m_noiseSource;
	CountdownTimer m_noiseBendTimer;
	Vector m_bentNoisePosition;
	bool m_bendNoisePositionValid;
	float32 m_lookAroundStateTimestamp;
	float32 m_lookAheadAngle;
	float32 m_forwardAngle;
	float32 m_inhibitLookAroundTimestamp;
	Vector m_lookAtSpot;
	float32 m_lookAtSpotDuration;
	float32 m_lookAtSpotTimestamp;
	float32 m_lookAtSpotAngleTolerance;
	bool m_lookAtSpotClearIfClose;
	bool m_lookAtSpotAttack;
	char* m_lookAtDesc;
	float32 m_peripheralTimestamp;
	uint8 m_approachPointCount;
	Vector m_approachPointViewPosition;
	IntervalTimer m_viewSteadyTimer;
	CountdownTimer m_tossGrenadeTimer;
	CountdownTimer m_isAvoidingGrenade;
	float32 m_spotCheckTimestamp;
	int32 m_checkedHidingSpotCount;
	float32 m_lookPitch;
	float32 m_lookPitchVel;
	float32 m_lookYaw;
	float32 m_lookYawVel;
	Vector m_targetSpot;
	Vector m_targetSpotVelocity;
	Vector m_targetSpotPredicted;
	QAngle m_aimError;
	QAngle m_aimGoal;
	GameTime_t m_targetSpotTime;
	float32 m_aimFocus;
	float32 m_aimFocusInterval;
	GameTime_t m_aimFocusNextUpdate;
	CountdownTimer m_ignoreEnemiesTimer;
	CHandle< CCSPlayerPawn > m_enemy;
	bool m_isEnemyVisible;
	uint8 m_visibleEnemyParts;
	Vector m_lastEnemyPosition;
	float32 m_lastSawEnemyTimestamp;
	float32 m_firstSawEnemyTimestamp;
	float32 m_currentEnemyAcquireTimestamp;
	float32 m_enemyDeathTimestamp;
	float32 m_friendDeathTimestamp;
	bool m_isLastEnemyDead;
	int32 m_nearbyEnemyCount;
	CHandle< CCSPlayerPawn > m_bomber;
	int32 m_nearbyFriendCount;
	CHandle< CCSPlayerPawn > m_closestVisibleFriend;
	CHandle< CCSPlayerPawn > m_closestVisibleHumanFriend;
	IntervalTimer m_attentionInterval;
	CHandle< CCSPlayerPawn > m_attacker;
	float32 m_attackedTimestamp;
	IntervalTimer m_burnedByFlamesTimer;
	int32 m_lastVictimID;
	bool m_isAimingAtEnemy;
	bool m_isRapidFiring;
	IntervalTimer m_equipTimer;
	CountdownTimer m_zoomTimer;
	GameTime_t m_fireWeaponTimestamp;
	CountdownTimer m_lookForWeaponsOnGroundTimer;
	bool m_bIsSleeping;
	bool m_isEnemySniperVisible;
	CountdownTimer m_sawEnemySniperTimer;
	uint8 m_enemyQueueIndex;
	uint8 m_enemyQueueCount;
	uint8 m_enemyQueueAttendIndex;
	bool m_isStuck;
	GameTime_t m_stuckTimestamp;
	Vector m_stuckSpot;
	CountdownTimer m_wiggleTimer;
	CountdownTimer m_stuckJumpTimer;
	GameTime_t m_nextCleanupCheckTimestamp;
	float32[10] m_avgVel;
	int32 m_avgVelIndex;
	int32 m_avgVelCount;
	Vector m_lastOrigin;
	float32 m_lastRadioRecievedTimestamp;
	float32 m_lastRadioSentTimestamp;
	CHandle< CCSPlayerPawn > m_radioSubject;
	Vector m_radioPosition;
	float32 m_voiceEndTimestamp;
	int32 m_lastValidReactionQueueFrame;
};
