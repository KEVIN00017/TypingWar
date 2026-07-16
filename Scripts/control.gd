extends Control



func _ready() -> void:
	Global.SPEED=200
	Global.Letter=false
	Global.Points=0
	Global.LIFE=33
	Global.PositionMain=0
	

func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("uid://luyuwylrf3v8")
 
