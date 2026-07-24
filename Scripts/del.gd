extends Area2D



func _on_body_entered(body: Node2D) -> void:
		body.queue_free()
		Global.Letter = false
		if Global.bad:
			underlineTitle()
		elif Global.click==true :

			Global.show_word_en+=Global.letter_global
			Global.click=false
		else:
			Global.show_word_en += "_"
func underlineTitle():
	
		if Global.bad:
			Global.show_word_en += "_"
			Global.bad=false

	
