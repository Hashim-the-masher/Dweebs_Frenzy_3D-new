extends Control

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
var cocksize = 64
var file_controls = file_control.new()
var savedata:Dictionary
var ttime = 3.405

func _ready() -> void:
	savedata = file_controls.load_json_file()
	savedata["w/l"][1] += 1
	file_controls.save_to_json_file(savedata)
	timer.wait_time = ttime


func _process(delta: float) -> void:
	label.label_settings.font_size = lerp(16,cocksize,ttime-timer.time_left)
	label.label_settings.font_color.a8 = lerp(0,255,ttime-timer.time_left)
	if ttime-timer.time_left > ttime-0.05:
		timer.stop()
		get_tree().change_scene_to_file("res://Menus/Title_screen.tscn")
