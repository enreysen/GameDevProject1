extends CharacterBody2D

@export var move_speed : float = 30
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float
@export var jump_force : float = 200
@export var stunned : bool = false

var slowed : bool = false
var bullet_path = preload("res://Scenes/projectile.tscn")
var move_input : float

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var node_2d: Node2D = $"."
@onready var air: ProgressBar = $"../Moving Wall/Air Remaining"
@onready var timer: Timer = $"Weapon Timer"
@onready var dash_timer : Timer = $"Dash Timer"
@onready var shoot_sound : AudioStreamPlayer2D = $Shoot
@onready var jump_sound : AudioStreamPlayer2D
@onready var air_sound : AudioStreamPlayer2D
@onready var underwater_shoot : AudioStreamPlayer2D
@onready var hurt_sound : AudioStreamPlayer2D = $Hurt
@onready var dash_sound : AudioStreamPlayer2D = $Dash

var underwater = false
var move_animation : String
var shoot_animation : String
var stun_animation : String
var slow_animation : String
var tutorial = false

var can_shoot = true
var can_dash = true

func _ready() -> void:
	if node_2d.has_meta("is_underwater"):
		underwater = node_2d.get_meta("is_underwater")
		
	if node_2d.has_meta("is_tutorial"):
		tutorial = node_2d.get_meta("is_tutorial")
		print(tutorial)

	if not underwater:
		move_animation = "player_run"
		shoot_animation = "player_shoot"
		stun_animation = "player_stun"
		gravity = 500
		jump_sound = $Jump
	else:
		move_animation = "player_swim_straight"
		shoot_animation = "player_swim_shoot"
		stun_animation = "player_swim_stun"
		slow_animation = "player_swim_slow"
		air.value = 100
		gravity = 100
		air_sound = $Air
		underwater_shoot = $"Underwater Shoot"
		
	_manage_animation(move_animation)

func _process(delta: float):
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor(): # how fast the player falls
		if not underwater:
			velocity.y += gravity * delta
		else:
			velocity.y += (gravity * delta) / 1.5
		
	if stunned:
		move_speed = 0
	else:
		move_speed = 30
		
	move_input = Input.get_axis("move_left", "move_right")
	
	# idea is player keeps moving forward
	# they move faster if looking right, slower if looking left
	if move_input == 1.0:
		if can_dash and not stunned:
			dash()
				
	elif move_input == -1.0:
		velocity.x = move_speed * 0.5
	else:
		if not slowed:
			velocity.x = move_speed 
		else:
			velocity.x = move_speed / 5
	
	# shoot projectile
	if Input.is_action_just_pressed("shoot") and not stunned and can_shoot:
		shoot()
	
	# jump
	if Input.is_action_pressed("jump") and not stunned:
		if not underwater:
			if is_on_floor():
				velocity.y = -jump_force
				jump_sound.play()
			elif Input.is_action_just_pressed("jump"):
				velocity.y += -jump_force * .02
			
			velocity.x += 20
				
		else: 
			velocity.y = -jump_force / 4
		
	# remove air, restart if run out
	if underwater:
		if air.value <= 0:
			if not tutorial:
				get_tree().change_scene_to_file("res://Scenes/ran_out_of_breath.tscn")
			else:
				get_tree().reload_current_scene()
		else:
			air.value -= 0.025
	
	move_and_slide()

# got this section from the following tutorial:
# "Simple Shooting system in Godot4 2D | godot tutorial" by GameStick on YouTube
func shoot():
	can_shoot = false
	timer.start()
	sprite.flip_h = true
	
	_manage_animation(shoot_animation)
	
	await get_tree().create_timer(0.55).timeout 
	_manage_animation(move_animation)
	sprite.flip_h = false
	
	for i in range(3):
		var bullet = bullet_path.instantiate()
		bullet.direction = rotation
		bullet.spawn_position = (node_2d.global_position) - Vector2(30, 0)
		bullet.rotate = global_rotation
		get_parent().add_child(bullet)
		if not underwater: 
			shoot_sound.play()
		else:
			underwater_shoot.play()
		await get_tree().create_timer(0.2).timeout 	

func stun():
	hurt_sound.play()
	anim.stop()
	stunned = true
	_manage_animation(stun_animation)
	await get_tree().create_timer(2.0).timeout 
	unstun()

func unstun():
	stunned = false
	_manage_animation(move_animation)

func add_air():
	air.value += 25
	air_sound.play()
	
func slow():
	hurt_sound.play()
	_manage_animation(slow_animation)
	slowed = true
	
func unslow():
	_manage_animation(move_animation)
	slowed = false
	
func _manage_animation(animation: String):
	anim.play(animation)

func dash():
	dash_sound.play()
	can_dash = false
	if not slowed:
		for i in range(8):
			position.x += 5
			await get_tree().create_timer(0.01).timeout
	else:
		velocity.x = move_speed / 5
	
	dash_timer.start()

func _on_weapon_timer_timeout() -> void:
	can_shoot = true

func _on_dash_timer_timeout() -> void:
	can_dash = true
