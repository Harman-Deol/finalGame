extends KinematicBody2D

const death = preload("res://cat/catDeath.tscn")


var knock = Vector2.ZERO
onready var playAnim = $AnimationPlayer

onready var enemyInfo = $enemyInfo
onready var PawnSense = $PawnSense


onready var Asprite = $AnimatedSprite
onready var sprite = $Sprite
onready var attack = $catAttack

onready var hurtBox = $hurtBox
onready var enemyCollision = $enemyCollision
onready var patrol = $patrol

export var ACC = 300
export var MAX_SPEED = 50 
export var FRICTION = 200

enum {
	IDLE,
	PATROL,
	ATTACK
}

var state = IDLE
var speed = Vector2.ZERO


func _physics_process(delta):
	knock = knock.move_toward(Vector2.ZERO, FRICTION * delta)
	knock = move_and_slide(knock)
	
	match state:
		IDLE:
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			chasePlayer()
			playAnim.play("skIdle")
			
			if patrol.timeLeft() == 0:
				state = newState([IDLE, PATROL])
				patrol.beginTimer(rand_range(1,5))
		PATROL:
			var direction = global_position.direction_to(patrol.endPoint)
			speed = speed.move_toward(direction * MAX_SPEED, ACC * delta)
			playAnim.play("skRun")
			
			if global_position.distance_to(patrol.endPoint) <= 10:
				state = newState([IDLE, PATROL])
				patrol.beginTimer(rand_range(1,5))
				
			if patrol.timeLeft() == 0:
				state = newState([IDLE, PATROL])
				patrol.beginTimer(rand_range(1,5))
				
		ATTACK:
			var player = PawnSense.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				speed = speed.move_toward(direction * MAX_SPEED, ACC * delta)
				playAnim.play("skRun")
			else:
				state = IDLE
			sprite.flip_h = speed.x < 0		
			
	if enemyCollision.isOverlap():
		speed += enemyCollision.pushAway() * delta * 400
		
	speed = move_and_slide(speed)
	
				
func chasePlayer():
	if PawnSense.playerSeen():
		state = ATTACK	


func newState(list):
	list.shuffle()
	return list.pop_front()

func _on_hurtBox_area_entered(area):
	enemyInfo.health -= area.dmg

	
	knock = area.knockback * 125
	
	
func _on_enemyInfo_killEnemy():
	#playAnim.play("skDeath")
	queue_free()
	global.fur = global.fur + randi()%3+1

	
	
