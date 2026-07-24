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
@onready var area: Sprite2D 
@onready var status: Label = $STATUS
@onready var vida: Label = $Vida
@onready var Enemy: AnimatedSprite2D = $CharacterBody2D/Sprite2D
@onready var palavra_en: Label = $PalavraEN
@onready var collision_shape_2d: CollisionShape2D 
@onready var space_time: Area2D = $spaceTime
@onready var spawn_timer: Timer = $SpawnTimer
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var lvl: Label = $LVL
@onready var button: Sprite2D = $spaceTime/Sprite2D
@onready var recorde: Label = $Recorde
@onready var letter_position: Marker2D = $letter_position
@onready var hero_position: Marker2D = $hero_position
@onready var combo: Label = $COMBO
var bad:=false
var liberar_combo=false


func _ready() -> void:
	http_request.request(path)
	print(ListWords)
	Hero_Inst.position=Vector2(hero_position.global_position.x,hero_position.global_position.y)
	add_child(Hero_Inst)

	if ListWords.size() > 0:
		ShowWorlds()
		SpawnLetter()
	
	spawn_timer.wait_time = randf_range(1.0, 3.0)
	spawn_timer.start()
	
func _process(delta: float) -> void:
	print(Global.SPEED)
	if Global.SPEED > 500 and NextWord:
		DificultEnemy-=50
	if Body !=null:
		Posi=Body.global_position.x
	if ListWords.size() > 0:
		ShowWorlds()
		SpawnLetter()
	if Global.letter_total>=10 and liberar_combo :
		print("CAIU AQUI!!!")
		Global.COMBO=true
		Global.letter_total=0
		combo.visible=true
		await  get_tree().create_timer(1).timeout
		combo.visible=false
		
	

func _input(event) -> void:
	
	if event is InputEventKey and event.pressed:
		
		key = event.as_text().to_upper()
		
		Del(key, Body)
func SpawnLetter():
	if Global.Letter == false and Global.LIFE>0:
		
		if i < ListLetter.size():
			
			currentLetter=ListLetter[i].to_upper()
			
			

			var WordInst = Scene.instantiate()
			
			WordInst.position = Vector2((letter_position.global_position.x+90), letter_position.global_position.y)

			add_child(WordInst)
			
			WordInst.ControlLetter(ListLetter[i].to_upper())
			i += 1
			Global.Letter = true

		else:
		
			NextWord=true	
			
			SumSpeed(Global.SPEED)
			
			End-=1
			i = 0
			w += 1
			Global.show_word_en=""
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
		Hero_Inst.STATUS(status,area,"BAD!",Color.RED,4,button)
		Global.bad=true
		
		
		
	if tecla == currentLetter:
		Global.letter_global=currentLetter
		Global.letter_total+=1	
		calc(Posi)
	else:
		
		Global.bad=true
	
	
func calc(posiX):
	
	var Distancia = (space_time.global_position.x - posiX)
	

	
	if Distancia <= -16 and Distancia>-35:
		Global.Points+=30
		Hero_Inst.Attack(Color.GREEN,"PERFECT! +30",area,status,1,button)
		Global.bad=false
		Global.click=true
		print(Distancia,Global.click)
	elif Distancia <= 10 and Distancia >= -50:
		print(Distancia,Global.click)
		Global.Points+=20
		Global.bad=false
		Global.click=true
		Hero_Inst.Attack(Color.REBECCA_PURPLE,"GOOD +20",area,status,2,button)


	elif Distancia <= -50 and Distancia >= -70:
		print(Distancia,Global.click)
		Global.Points+=10
		Global.bad=false
		Global.click=true
		Hero_Inst.Attack(Color.ORANGE,"MISS +10",area,status,3,button)
		
func _on_body_entered(body: Node2D) -> void:

	Body=body
func _on_body_exited(body: Node2D) -> void:
	SwitchWord(w)
	Body=null
func SumSpeed(currentSpeed):
	if currentSpeed <=550:
		Global.SPEED+=50
	if currentSpeed >= 550 :
		liberar_combo=true
		print("COMBO LIBERADO !!!:",liberar_combo)
func ShowWorlds():
	label.text=ListWords[w]["WorldPT"].to_upper()
	vida.text=str(Global.LIFE)
	palavra_en.text=Global.show_word_en
	pontuacao.text=str(Global.Points)
	recorde.text=str(Global.recorde)
	
func inst(instanciate,posiInst):
	if Global.LIFE >0:
		instanciate.position = posiInst
		add_child(instanciate)
		
func _on_spawn_timer_timeout() -> void:
		inst(SceneEnemy.instantiate(), $Tv2.global_position)
		if(End>0):
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
