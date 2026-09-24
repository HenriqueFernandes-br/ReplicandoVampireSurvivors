extends PanelContainer

@export var arma: Arma:
	set(value):
		arma = value
		$TextureRect.texture = value.texture
		$Cooldown.wait_time = value.cooldown


func _on_cooldown_timeout() -> void:
	if arma:
		$Cooldown.wait_time = arma.cooldown
		arma.activate(owner, owner.achar_inimigo_proximo())
