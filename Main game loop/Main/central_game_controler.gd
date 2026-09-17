extends Node3D
@onready var player = $player
@onready var black: ColorRect = $screeneffects/Black
@onready var filecontrols = file_control.new()
var savedata:Dictionary
var alevel = [preload("res://Main game loop/Levels/L0.tscn"), preload("res://Main game loop/Levels/L1.tscn"),preload("res://Main game loop/Levels/L2.tscn")]
var current_level
signal on_win
func _ready() -> void:
	savedata = filecontrols.load_json_file()
	if savedata["settings"]["visuals"][1] == 1.0:
		filecontrols.fullscreen(get_window())
	else:
		filecontrols.change_res(savedata["settings"]["visuals"][0],get_window())
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
	if Wintype == 1:
		fade_out()
		if Currentlevel+1 > alevel.size()-1:
			print("Cannot load level "+str(Currentlevel+1))
			return
		call_deferred("remove_child",current_level)
		start_level(Currentlevel+1)
