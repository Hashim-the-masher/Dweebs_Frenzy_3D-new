extends Node3D
@onready var player = $player
@onready var black: ColorRect = $screeneffects/Black
@onready var filecontrols = file_control.new()
var alevel = [preload("uid://c2sdayly3ckis"), preload("uid://th2xsi4ecpks"), preload("uid://dmg15bcspfka8"), preload("uid://w4s1n77gvswu"), preload("uid://dlbh7daxflal5"), preload("uid://bchtimm4qxhwo")]
var current_level
signal on_win
func _ready() -> void:
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
	print(str(Currentlevel)+str(Wintype)+str(Nextlevel))
	if Wintype == 1:
		fade_out()
		call_deferred("remove_child",current_level)
		start_level(Currentlevel+1)
