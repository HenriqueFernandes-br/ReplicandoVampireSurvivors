extends CharacterBody2D

# ==============================================================================
# SINAIS CUSTOMIZADOS
# ==============================================================================
signal vida_mudou

# ==============================================================================
# CONFIGURAÇÕES E VARIÁVEIS EXPORTADAS
# ==============================================================================
@export var speed = 150 # pixels de movimentação
@export var vida_maxima = 100
@export var vida_atual = vida_maxima

# ==============================================================================
# REFERÊNCIAS A NÓS (ONREADY)
# ==============================================================================
@onready var animated_sprite = %AnimatedSprite2D
@onready var intervalo_dano = $IntervaloDano
@onready var barra_vida = $BarraDeVida

# ==============================================================================
# VARIÁVEIS DE ESTADO INTERNO
# ==============================================================================
var sofrendo_dano := false
var dano_sofrido := 0

# ==============================================================================
# MÉTODOS NATIVOS DA GODOT
# ==============================================================================
func _ready():
	add_to_group("jogador")
	barra_vida.max_value = vida_maxima
	barra_vida.value = vida_atual

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
	
	if vida_atual < 0:
		vida_atual = 0

# ==============================================================================
# MÉTODOS CUSTOMIZADOS (CONTROLE E LÓGICA DO JOGADOR)
# ==============================================================================
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	input_direction = input_direction.normalized()
	velocity = input_direction * speed

func sofrer_dano():
	vida_atual -= dano_sofrido
	vida_mudou.emit()

# ==============================================================================
# SINAIS (CONNECTORS)
# ==============================================================================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigos"):
		sofrendo_dano = true
		dano_sofrido += body.dano
		vida_atual -= body.dano
		vida_mudou.emit
		intervalo_dano.start()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("inimigos"):
		dano_sofrido -= body.dano

func _on_intervalo_dano_timeout() -> void:
	if sofrendo_dano == true:
		sofrer_dano()

func _on_vida_mudou() -> void:
	barra_vida.value = vida_atual
	barra_vida.max_value = vida_maxima
