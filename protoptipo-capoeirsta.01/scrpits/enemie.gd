extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const STOP_RANGE:float = 80

enum State {IDLE, WALKING, PUNCH, DAMAGE_UP, WAIT}

@onready var eyes := $eyes as Area2D
@onready var player := get_tree().get_first_node_in_group("player")
@onready var anim :=  $AnimatedSprite2D as AnimatedSprite2D

var current_state:State = State.IDLE

var already_atack:bool= false
var is_seeing:bool
var is_touching:bool

var direction_player:int
var life:int = 5

func _ready() -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var target:float = abs(player.global_position.x - global_position.x)
	direction_player = sign(player.global_position.x - global_position.x)
	
	if is_seeing and target > STOP_RANGE or is_touching and target > STOP_RANGE:
			velocity.x = SPEED * direction_player
			if velocity.x < 0:
				eyes.scale.x = -1
				anim.flip_h = true
			else:
				eyes.scale.x = 1
				anim.flip_h = false
	else:
		velocity.x = 0
	
	if life <= 0:
		queue_free()
	
	update_state(target, delta)
	anim_state()
	move_and_slide()

func update_state(target, delta) -> void:
	if GlobalVariables.current_atack == GlobalVariables.Type_atack.NOTHING:
		already_atack = false
		if velocity.x != 0:
			current_state = State.WALKING
		else:
			current_state = State.IDLE
	else:
		if is_touching:
			match GlobalVariables.current_atack:
				GlobalVariables.Type_atack.UP_ATACK:
					current_state = State.DAMAGE_UP
					if !already_atack:
						life = life -1
						already_atack = true
						
		
func anim_state() -> void:
	match current_state:
		State.WALKING:
			anim.play("walking")
		State.IDLE:
			anim.play("idle")
		State.DAMAGE_UP:
			anim.play("damage_up")
			
func _on_eyes_body_entered(body: Node2D) -> void:
	if body.name == "player":
		is_seeing = true
			
func _on_eyes_body_exited(body: Node2D) -> void:
	if body.name == "player":
		is_seeing = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "player_hitbox":
		is_touching = true


func _on_hurtbox_area_exited(area: Area2D) -> void:
	if area.name == "player_hitbox":
		is_touching = false
