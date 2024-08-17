extends Node


# warning-ignore:unused_signal
signal enemy_killed(event)

signal game_stop()

# warning-ignore:unused_signal
signal enemy_damaged(enemy)

# warning-ignore:unused_signal
signal player_killed(event)

# warning-ignore:unused_signal
signal game_over(event)

# warning-ignore:unused_signal
signal game_start()

# warning-ignore:unused_signal
signal game_restart()

signal player_resurrected()

signal spawn_pickup(type, pos)
