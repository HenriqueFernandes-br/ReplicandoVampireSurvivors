extends CharacterBody2D

@export var speed = 150
@onready var animated_sprite = %AnimatedSprite2D
var sofrendo_dano := false
@export var vida = 100
var dano_sofrido := 0

@onready var intervalo_dano = $IntervaloDano

func _ready():
	add_to_group("jogador")

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	input_direction = input_direction.normalized()
	velocity = input_direction * speed

func _physics_process(delta):
	var direction_x = Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down")
	
	get_input()
	move_and_slide()
	
	if direction_x != 0:
		animated_sprite.flip_h = (direction_x == -1)
		animated_sprite.play("Walk")
	else:
		if direction_y != 0:
			animated_sprite.play("Walk")
		else:
			animated_sprite.play("Idle")
	
	var inimigos_encostando = $Hitbox.get_overlapping_bodies()
	if not inimigos_encostando:
		sofrendo_dano = false

func sofrer_dano():
	vida -= dano_sofrido

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigos"):
		sofrendo_dano = true
		dano_sofrido += body.dano
		sofrer_dano()
		intervalo_dano.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("inimigos"):
		dano_sofrido -= body.dano


func _on_intervalo_dano_timeout() -> void:
	if sofrendo_dano == true:
		sofrer_dano()
