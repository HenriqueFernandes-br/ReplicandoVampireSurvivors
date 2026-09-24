extends CharacterBody2D
class_name Inimigo

# ==============================================================================
# CONFIGURAÇÕES E VARIÁVEIS EXPORTADAS
# ==============================================================================
@export var dados: InimigoData
@export var forca_knockback: float = 350.0

# ==============================================================================
# REFERÊNCIAS A NÓS (ONREADY)
# ==============================================================================
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var colisao: CollisionShape2D = $CollisionShape2D

# ==============================================================================
# VARIÁVEIS DE ESTADO INTERNO
# ==============================================================================
var vida_atual: int
var dano: int
var alvo: Node2D
var speed: float
var knockback_velocity: Vector2 = Vector2.ZERO

# ==============================================================================
# MÉTODOS NATIVOS DA GODOT
# ==============================================================================
func _ready() -> void:
	add_to_group("inimigos")
	if dados:
		configurar(dados)
	alvo = get_tree().get_first_node_in_group("jogador")

func _physics_process(delta: float) -> void:
	if vida_atual > 0:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 5.0 * delta * 100)
		if knockback_velocity.length() > 0:
			velocity = knockback_velocity
		else:	
			seguir_jogador()
		move_and_slide()
# ==============================================================================
# MÉTODOS CUSTOMIZADOS (CONTROLE E LÓGICA DO INIMIGO)
# ==============================================================================
func configurar(d: InimigoData) -> void:
	vida_atual = d.vida_maxima
	scale = Vector2.ONE * d.escala
	sprite.sprite_frames = d.sprite_frames
	speed = d.velocidade
	sprite.play("alive")
	dano = d.dano

func seguir_jogador():
	var direction = global_position.direction_to(alvo.global_position)
	velocity = direction * speed
	
	if velocity.x != 0:
		sprite.flip_h = (velocity.x < 0)

func sofrer_dano(dano_sofrido: int, fonte_dano: Node2D = null) -> void:
	if vida_atual <= 0:
		return
	
	vida_atual -= dano_sofrido
	
	var posicao_origem: Vector2
	
	if fonte_dano != null and fonte_dano.is_in_group("projetil"):
		posicao_origem = fonte_dano.global_position
	else:
		if alvo:
			posicao_origem = alvo.global_position
		else:
			posicao_origem = global_position
	var direcao_knockback = posicao_origem.direction_to(global_position)
	knockback_velocity = direcao_knockback * forca_knockback
	
	if vida_atual <= 0:
		sprite.play("death")
		colisao.set_deferred("disabled", true)
		velocity = Vector2.ZERO
		knockback_velocity = Vector2.ZERO

# ==============================================================================
# SINAIS (CONNECTORS)
# ==============================================================================
func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "death":
		queue_free()
