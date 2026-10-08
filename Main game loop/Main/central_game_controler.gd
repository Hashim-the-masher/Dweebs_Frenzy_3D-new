extends Node3D
@onready var player = $player
@onready var black: ColorRect = $screeneffects/Black
@onready var filecontrols = file_control.new()
var savedata:Dictionary
var alevel = [preload("uid://6iux07jg6eh0"), preload("uid://de734xiky0jrr"), preload("uid://bkns4lqn2imlv"), preload("uid://3yq15gpwfedm"), preload("uid://d200n62wqynj0")]
var current_level
@onready var player_spawn_timer: Timer = $playerSpawnTimer
@export var deafult_spawn_time:float = 1.0

func _ready() -> void:
	savedata = filecontrols.load_json_file()
	if savedata["settings"]["visuals"][1] == 1.0:
		filecontrols.fullscreen(get_window())
	else:
		filecontrols.change_res(savedata["settings"]["visuals"][0],get_window())
	filecontrols.set_volume(savedata)
	start_level(1)
	player.flags["spawn"] = true

func start_level(level):
	player.position = Vector3.ZERO
	level = alevel[level]
	current_level = level.instantiate()
	add_child(current_level)
	move_child(get_child(-1),0)

func reset_volume():
	print("reset volume")

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(black,"color",Color.hex(00000000),1)


func _on_win(Currentlevel: int, Wintype: int, Nextlevel: int) -> void:
	black.color = Color.BLACK
	print("Win code:"+str(Currentlevel)+str(Wintype)+str(Nextlevel))
	if Wintype == 0:
		start_level(Nextlevel)
	elif Wintype == 1:
		player.flags["spawn"] = false
		player.velocity_on_a_plane = Vector2(0,0)
		fade_out()
		if Currentlevel+1 > alevel.size()-1:
			print("Cannot load level "+str(Currentlevel+1))
			return
		call_deferred("remove_child",current_level)
		player_spawn_timer.start()
		start_level(Currentlevel+1)


func _on_player_spawn_timer_timeout() -> void:
	player.flags["spawn"]=true
	player_spawn_timer.wait_time = deafult_spawn_time
