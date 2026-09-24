extends Arma
class_name MagicWand

func atirar(fonte, alvo):
	if alvo == null:
		return
	var projetil_da_arma = projetil.instantiate()
	fonte.get_tree().current_scene.add_child(projetil_da_arma)
	projetil_da_arma.global_position = fonte.position
	projetil_da_arma.dano = dano
	if "speed" in projetil_da_arma:
		projetil_da_arma.speed *= speed
	projetil_da_arma.direcao = (alvo.position - fonte.position).normalized()
	

func activate(fonte, alvo):
	atirar(fonte, alvo)
