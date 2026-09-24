extends Resource
class_name Arma

@export var nome: String
@export var texture: Texture2D

@export var dano: float
@export var cooldown: float
@export var speed: float

@export var projetil:= preload("res://armas/projetil.tscn")

func activate(_fonte, _alvo):
	pass
