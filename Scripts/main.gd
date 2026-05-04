extends Node2D

var ListLetter: Array = []
var ListWords: Array = []
var MainWord := "" 
var DificultEnemy:=450
var i := 0
var w := 0
var Body:Node2D=null
var Posi:=0
var key:=''
var Scene := preload("res://Scenes/word.tscn")
var Hero_Scene:=preload("res://Scenes/main_person.tscn")
var Hero_Inst:=Hero_Scene.instantiate()
var currentLetter:=""
var SceneEnemy:=preload("res://Scenes/Enemy.tscn")
var NextWord:=true	
var start:=1.0
var End:=5.0
var path="http://localhost:3250/api/getWorld"
@onready var label: Label = $Palavra
@onready var pontuacao: Label = $Pontuacao
@onready var area: Sprite2D = $spaceTime/Sprite2D2
@onready var status: Label = $STATUS

@onready var vida: Label = $Vida
@onready var Enemy: AnimatedSprite2D = $CharacterBody2D/Sprite2D
@onready var palavra_en: Label = $PalavraEN
@onready var collision_shape_2d: CollisionShape2D = $MainPerson/Area2D/CollisionShape2D
@onready var space_time: Area2D = $spaceTime
@onready var spawn_timer: Timer = $SpawnTimer
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var lvl: Label = $LVL



func _ready() -> void:
	http_request.request(path)
	print(ListWords)
	add_child(Hero_Inst)
	if ListWords.size() > 0:
		ShowWorlds()
		SpawnLetter()
	
	spawn_timer.wait_time = randf_range(1.0, 3.0)
	spawn_timer.start()
	
func _process(delta: float) -> void:
	if Global.SPEED > 700 and NextWord:
		DificultEnemy-=50
	if Body !=null:
		Posi=Body.global_position.y
	if ListWords.size() > 0:
		ShowWorlds()
		SpawnLetter()
	

func _input(event) -> void:
	
	if event is InputEventKey and event.pressed:
		
		key = event.as_text().to_upper()
		
		Del(key, Body)
func SpawnLetter():
	if Global.Letter == false and Global.LIFE>0:
		
		if i < ListLetter.size():
			
			currentLetter=ListLetter[i].to_upper()
			
			

			var WordInst = Scene.instantiate()
			
			WordInst.position = Vector2((label.global_position.x+45), 0)

			add_child(WordInst)

			
			WordInst.ControlLetter(ListLetter[i].to_upper())

			i += 1
			Global.Letter = true

		else:
			#Palavra traduzida do inglês será mostrada aqui!
			NextWord=true	
			
			SumSpeed(Global.SPEED)
			

			i = 0
			w += 1

			if w >= ListWords.size():
				w = 0  

			Global.Letter = false
			ListLetter.clear()
			SwitchWord(w)
func SwitchWord(word_index: int):
	
	if NextWord == true:
		MainWord = ListWords[word_index]["WorldEN"]
		
		ListLetter.clear()
		
		for l in MainWord:
			ListLetter.append(l)
		NextWord=false
func Del(tecla: String, body):

	if body == null or not is_instance_valid(body):
		area.modulate=Color.RED
		await get_tree().create_timer(0.2).timeout
		area.modulate=Color(0.20,0.14,0.36,0.70)
	
		
		return
	if tecla == currentLetter:
		
		calc(Posi)

	
	else:
		area.modulate=Color.RED
		await get_tree().create_timer(0.2).timeout
		area.modulate=Color(0.20,0.14,0.36,0.70)
	
func calc(posiY):
	
	var Distancia = (space_time.global_position.y - posiY)
	

	
	if Distancia < 10 and Distancia>-10:
		Global.Points+=30
		Hero_Inst.Attack(Color.GREEN,"PERFECT! +30",area,status)

	elif Distancia <= 30 and Distancia >= -30:

		Global.Points+=20

		Hero_Inst.Attack(Color.YELLOW,"GOOD +20",area,status)


	else:
		Global.Points+=10
		Hero_Inst.Attack(Color.ORANGE,"MISS +10",area,status)
func _on_body_entered(body: Node2D) -> void:

	Body=body
func _on_body_exited(body: Node2D) -> void:
	SwitchWord(w)
	Body=null
func SumSpeed(currentSpeed):
	if currentSpeed <=750:
		Global.SPEED+=50
func ShowWorlds():
	label.text=ListWords[w]["WorldPT"].to_upper()
	palavra_en.text=ListWords[w]["WorldEN"].to_upper()
	vida.text=str(Global.LIFE)
	pontuacao.text=str(Global.Points)
	lvl.text=str(ListWords[w]["LVL"])
func inst(instanciate,posiInst):
	if Global.LIFE >0:
		instanciate.position = posiInst
		add_child(instanciate)
func _on_spawn_timer_timeout() -> void:
		inst(SceneEnemy.instantiate(), $Tv2.global_position)
		spawn_timer.wait_time = randf_range(start, End)
		spawn_timer.start() 

	
	


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:

	var json_string = body.get_string_from_utf8()

	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if parse_result != OK:
		print("Erro ao parsear")
		return

	var data = json.data  
	ListWords=data
		
