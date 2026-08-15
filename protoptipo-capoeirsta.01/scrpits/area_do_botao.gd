extends Area2D

@onready var door := $door as StaticBody2D
@export var text: Label

var player_near:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_near and Input.is_action_just_pressed("ui_triangle"):
		if GlobalVariables.with_key == false:
			text.text = "Você nao tem a chave, va procurala"
		else:
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		text.text = "precione triangulo para acessar a porta"
		player_near = true

func _on_body_exited(body: Node2D) -> void:
	player_near = false
	text.text = ""
