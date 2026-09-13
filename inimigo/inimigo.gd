extends CharacterBody2D
class_name Inimigo

enum Estado { ANDANDO, RECEBENDO_DANO, MORTO }

@export var dados: InimigoData
var estado: Estado = Estado.ANDANDO
var vida_atual: int
var dano: int
var alvo: Node2D
var speed: float
var velocidade_empurrao_sofrido := Vector2.ZERO
@export var atrito_empurrao_sofrido := 500.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var colisao: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("inimigos")
	if dados:
		configurar(dados)
	alvo = get_tree().get_first_node_in_group("jogador")

func configurar(d: InimigoData) -> void:
	vida_atual = d.vida_maxima
	scale = Vector2.ONE * d.escala
	sprite.sprite_frames = d.sprite_frames
	speed = d.velocidade
	sprite.play("alive")
	dano = d.dano

func seguir_jogador():
	var direction = global_position.direction_to(alvo.global_position)
	velocity = direction * speed + velocidade_empurrao_sofrido
	
	move_and_slide()
	if velocity.x != 0:
		sprite.flip_h = (velocity.x < 0)

func empurrar(direcao: Vector2, forca: float):
	velocidade_empurrao_sofrido = direcao.normalized() * forca

func _physics_process(delta: float) -> void:
	seguir_jogador()
