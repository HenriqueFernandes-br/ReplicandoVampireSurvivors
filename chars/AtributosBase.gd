extends Resource
class_name PersonagemData

@export var nome: String
@export var icone: Texture2D
@export var sprite_frames: SpriteFrames

# Atributos
@export var vida_max: int = 100

@export var regeneracao: float = 0.0

@export var armadura: int = 0
@export var armadura_max: int = 50

@export var velocidade: float = 1

@export var forca: float = 1
@export var forca_max: float = 10

@export var area: float = 1
@export var area_max: float = 10

@export var agilidade: float = 1
@export var agilidade_max: float = 5

@export var duracao: float = 1
@export var duracao_max: float = 5

@export var quantidade: int = 0
@export var quantidade_max: int = 10

@export var cooldown: float = 1
@export var cooldown_min: float = 0.1

@export var sorte: float = 1

@export var crescimento: float = 1

@export var ganancia: float = 1

@export var maldicao: float = 1

@export var magnetismo: int = 30
