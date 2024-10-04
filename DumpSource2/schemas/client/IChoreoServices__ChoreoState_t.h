enum IChoreoServices::ChoreoState_t : uint32_t
{
	STATE_PRE_SCRIPT = 0,
	STATE_WAIT_FOR_SCRIPT = 1,
	STATE_WALK_TO_MARK = 2,
	STATE_SYNCHRONIZE_SCRIPT = 3,
	STATE_PLAY_SCRIPT = 4,
	STATE_PLAY_SCRIPT_POST_IDLE = 5,
	STATE_PLAY_SCRIPT_POST_IDLE_DONE = 6,
};
