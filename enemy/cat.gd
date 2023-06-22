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
			playAnim.play("idle")
			
			if patrol.timeLeft() == 0:
				state = newState([IDLE, PATROL])
				patrol.beginTimer(rand_range(1,5))
		PATROL:
			var direction = global_position.direction_to(patrol.endPoint)
			speed = speed.move_toward(direction * MAX_SPEED, ACC * delta)
			playAnim.play("catRun")
			
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
				playAnim.play("catRun")
			else:
				state = IDLE
			sprite.flip_h = speed.x > 0		
			
	if enemyCollision.isOverlap():
		speed += enemyCollision.pushAway() * delta * 400
		
	speed = move_and_slide(speed)
	
				
func chasePlayer():
	if PawnSense.playerSeen():
		state = ATTACK	
	
	#sprite.play()
	
	
	#var player = PawnSense.player
	#var distance2Player = global_position.distance_to(player.global_position)

	
func newState(list):
	list.shuffle()
	return list.pop_front()

func _on_hurtBox_area_entered(area):
	enemyInfo.health -= area.dmg
	#print(enemyInfo.health)
	#playAnim.play("catAttack")
	#var attackEffect = attack.instance()
	#get_parent().add_child(attackEffect)
	#attackEffect.global_position = global_position
	
	
	knock = area.knockback * 125
	
	
func _on_enemyInfo_killEnemy():
	queue_free()
	var deathEffect = death.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	
	#playerInfo.max_health += 3
	global.fur = global.fur + randi()%2+0
	
	
