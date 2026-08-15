extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -600.0

#MLC = meia lua de compasso MLCR = meia lua de compasso rasteira 
enum State {GINGA, WALK, JUMP, FALL, ARMADA, CROUNCH, MLC, MLCR}

var current_state:State = State.GINGA
var is_square:bool
var is_circle:bool
var is_triangle:bool
var is_crounch:bool
var is_atacking:bool
var direction

@onready var animation := $animation as AnimatedSprite2D
@onready var hitbox := $player_hitbox as Area2D

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	
	direction = Input.get_axis("ui_left", "ui_right")
	if direction and !is_crounch:
		velocity.x = direction * SPEED
		animation.flip_h = direction < 0
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_pressed("ui_down"):
		is_crounch = true
	else:
		is_crounch = false
	#print(animation.animation, animation.frame)
	match animation.animation:
		"armada":
			if animation.frame == animation.sprite_frames.get_frame_count("armada") - 1:
				is_square = false
				is_atacking = false
		"mlcr":
			if animation.frame == animation.sprite_frames.get_frame_count("mlcr") - 1:
				is_circle = false
				is_atacking = false
		"mlc":
			if animation.frame == animation.sprite_frames.get_frame_count("mlc") -1:
				is_circle = false
				is_atacking = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
			
	update_state(direction)
	move_and_slide()
	play_current_state()
	
	
func update_state(direction) -> void:
	if is_on_floor():
		if !is_atacking:
			GlobalVariables.current_atack = GlobalVariables.Type_atack.NOTHING
			if !is_crounch:
				if velocity.x != 0:
					current_state = State.WALK
					if direction == -1:
						hitbox.scale.x = -1
					else:
						hitbox.scale.x = 1
				else:
					current_state = State.GINGA
			else:
				current_state = State.CROUNCH
		else:
			if is_circle:
				if is_crounch and current_state != State.MLC:
					current_state = State.MLCR
					GlobalVariables.current_atack = GlobalVariables.Type_atack.UP_ATACK
					print(GlobalVariables.current_atack)
				elif !is_crounch and current_state != State.MLCR:
					current_state = State.MLC
					GlobalVariables.current_atack = GlobalVariables.Type_atack.UP_ATACK
					print(GlobalVariables.current_atack)
			elif is_square:
				current_state = State.ARMADA
				GlobalVariables.current_atack = GlobalVariables.Type_atack.UP_ATACK
	else:
		if velocity.y < 0:
			current_state = State.JUMP	
		else:
			current_state = State.FALL
			
func play_current_state() -> void:
	if not animation:
		return
	match current_state:
		State.GINGA:
			animation.play("ginga")
		State.WALK:
			animation.play("walk")
		State.JUMP:
			animation.play("jump")
		State.FALL:
			animation.play("fall")
		State.ARMADA:
			animation.play("armada")
		State.CROUNCH:
			animation.play("crounch")
		State.MLCR:
			animation.play("mlcr")
		State.MLC:
			animation.play("mlc")


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	

func _input(event):
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("ui_square"):
		is_square = true
		is_atacking = true
		print("square")
	if Input.is_action_just_pressed("ui_circle"):
		is_circle = true
		is_atacking = true
		print("circle")
		
