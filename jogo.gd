extends Node2D

# ==============================================================================
# ENUMS E CONSTANTES
# ==============================================================================
const INIMIGO_CENA := preload("res://inimigo/inimigo.tscn")

# ==============================================================================
# CONFIGURAÇÕES E VARIÁVEIS EXPORTADAS
# ==============================================================================
@export var tipos_disponiveis: Array[InimigoData] = []

# ==============================================================================
# REFERÊNCIAS A NÓS (ONREADY)
# ==============================================================================
@onready var timer_spawn = $Timer

# ==============================================================================
# MÉTODOS NATIVOS DA GODOT
# ==============================================================================
func _ready() -> void:
	timer_spawn.start()

# ==============================================================================
# MÉTODOS CUSTOMIZADOS (SISTEMA DE SPAWN)
# ==============================================================================
func spawnar_inimigo(dados: InimigoData):
	var inimigo = INIMIGO_CENA.instantiate()
	inimigo.dados = dados
	inimigo.global_position = posicao_do_spawn()
	add_child(inimigo)
	var pilar_index = $Pilares.get_index()
	move_child(inimigo, pilar_index)

func posicao_do_spawn():
	var camera = $Jogador/Camera2D
	var viewport_size = get_viewport_rect().size
	var half_size = viewport_size / 2 / camera.zoom
	
	var camera_pos = camera.global_position
	
	var side = randi_range(1,4)
	
	match side:
		1: # Esquerda
			return Vector2(
				camera_pos.x - half_size.x - 100,
				randf_range(camera_pos.y - half_size.y, camera_pos.y + half_size.y)
			)

		2: # Direita
			return Vector2(
				camera_pos.x + half_size.x + 100,
				randf_range(camera_pos.y - half_size.y, camera_pos.y + half_size.y)
			)

		3: # Cima
			return Vector2(
				randf_range(camera_pos.x - half_size.x, camera_pos.x + half_size.x),
				camera_pos.y - half_size.y - 100
			)

		4: # Baixo
			return Vector2(
				randf_range(camera_pos.x - half_size.x, camera_pos.x + half_size.x),
				camera_pos.y + half_size.y + 100
			)

# ==============================================================================
# SINAIS (CONNECTORS)
# ==============================================================================
func _on_timer_timeout() -> void:
	var dados_sorteados = tipos_disponiveis.pick_random()
	spawnar_inimigo(dados_sorteados)
