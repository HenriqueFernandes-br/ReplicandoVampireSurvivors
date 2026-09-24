extends Area2D

var direcao : Vector2 = Vector2.ZERO
var speed : float = 200
var dano : float = 1

func _physics_process(delta: float) -> void:
	global_position += direcao * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("sofrer_dano"):
		body.sofrer_dano(dano, self)
		queue_free()
