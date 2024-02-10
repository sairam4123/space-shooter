extends Node

enum EnemyType {
	BASIC,
	INTERMEDIATE,
	ADVANCED,
	LEVEL_4,
	LEVEL_5
}

var kill_score = {
	EnemyType.BASIC: 1,
	EnemyType.INTERMEDIATE: 2,
	EnemyType.ADVANCED: 4,
	EnemyType.LEVEL_4: 8,
	EnemyType.LEVEL_5: 16
}

var damage_score = {
	EnemyType.BASIC: 0.01,
	EnemyType.INTERMEDIATE: 0.02,
	EnemyType.ADVANCED: 0.04,
	EnemyType.LEVEL_4: 0.08,
	EnemyType.LEVEL_5: 0.16
}
