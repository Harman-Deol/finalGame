extends KinematicBody2D

const ACC = 500
const MAX_SPEED = 100
const FRICTION = 500

enum{
	MOVE,
	ATTACK
}

var state = MOVE
var speed = Vector2.ZERO	



var compass = Vector2.RIGHT

var playAnim = null

var stats = playerInfo

onready var hitBox = $direction/hitBox
onready var hurtBox = $hurtBox


func _ready():
	stats.connect("killEnemy", self, "queue_free")
	playAnim = $AnimationPlayer
	hitBox.knockback = compass
	
	
func _physics_process(delta):
	match state:
		MOVE:
			moveState(delta)
					
		ATTACK:
			attackState(delta)
	
	if Input.is_action_just_pressed("info"):
		print(global.wood)
		print(hit.dmg)
	
	


func moveState(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO:
		hitBox.knockback = input_vector
		
		if input_vector.x > 0:
			playAnim.play("walkRight")
			compass = Vector2.RIGHT
		elif input_vector.x < 0:
			playAnim.play("walkLeft")
			compass = Vector2.LEFT
		elif input_vector.y < 0:
			playAnim.play("walkUp")
			compass = Vector2.UP
		elif input_vector.y > 0:
			playAnim.play("walkDown")
			compass = Vector2.DOWN
			
		#if input_vector.x > 0:
			#playAnim.play("runRight")
		#elif input_vector.x < 0:
			#playAnim.play("runLeft")
		speed = speed.move_toward(input_vector * MAX_SPEED, ACC * delta)
		
	else:
		if compass == Vector2.RIGHT:
			playAnim.play("rightIdle")
		elif compass == Vector2.LEFT:
			playAnim.play("leftIdle")
		elif compass == Vector2.UP:
			playAnim.play("upIdle")
		elif compass == Vector2.DOWN:
			playAnim.play("mainIdle")
		
		
		
		#playAnim.play("mainIdle")
		#playAnim.play("Idle")
		speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
		
	speed = move_and_slide(speed)
	
	if Input.get_action_strength("Attack"):
		#playerInfo.max_health += 1
		
		#print(playerInfo.max_health)
		state = ATTACK
		
func attackState(delta):
	speed = Vector2.ZERO
	
	if compass == Vector2.RIGHT:
		playAnim.play("attackRight")
	elif compass == Vector2.LEFT:
		playAnim.play("attackLeft")
	elif compass == Vector2.UP:
			playAnim.play("attackUP")
	elif compass == Vector2.DOWN:
			playAnim.play("attackDown")
	
	#playAnim.play("basicAttackR")
	
func attackFinish():
	state = MOVE
	#print(global.wood)
	
func _on_hurtBox_area_entered(area):
	stats.health -= 1
	hurtBox.iFrameActive(2)


