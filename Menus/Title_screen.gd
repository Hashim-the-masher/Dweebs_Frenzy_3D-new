extends Control
#
@onready var arrows = [$Title_screen/VBoxContainer2/arrow,$Title_screen/VBoxContainer2/arrow2,$Title_screen/VBoxContainer2/arrow3,$Title_screen/VBoxContainer2/arrow4,$Title_screen/VBoxContainer2/arrow5,$Title_screen/VBoxContainer2/arrow6]
@onready var labels = [$Title_screen/VBoxContainer/Start,$Title_screen/VBoxContainer/Options,$Title_screen/VBoxContainer/Exit,$Title_screen/VBoxContainer/Exit2,$Title_screen/VBoxContainer/Exit3,$Title_screen/VBoxContainer/Exit4]
@onready var title_screen: HBoxContainer = $Title_screen
@onready var settings: VBoxContainer = $settings
@onready var you_did_it: TextureRect = $you_did_it
var sure_flag = false
var deactivate:bool = false
var inputflag = true
var savedata:Dictionary
var option_selected:int = 0
var max_options:int = 5
var file_controls = file_control.new()
const UI = preload("uid://b5pijvb5s1ujn")
const UI_SELECTED = preload("uid://dvpvf7wdsrfxi")
const UI_HIDDEN = preload("uid://jeih4ch5reov")

func _ready() -> void:
	if file_controls.load_json_file() == null:
		file_controls.make_new_json_file()
	savedata = file_controls.load_json_file()
	file_controls.map_inputs(savedata)
	option_selected = savedata["setting_no"]["title"]
	if option_selected > 1: option_selected = 1
	match savedata["w/l"][0]:
		2.0:
			you_did_it.show()
		1.0:
			you_did_it.show()
		0.0:
			you_did_it.hide()
	for numbers in max_options+1:
		if numbers > 2:
			labels[numbers].label_settings = UI_HIDDEN
		elif numbers != option_selected:
			labels[numbers].label_settings = UI
			arrows[numbers].hide()
		else:
			labels[numbers].label_settings = UI_SELECTED
			arrows[numbers].show()
	match savedata["settings"]["visuals"][1]:
		1.0:
			file_controls.fullscreen(get_window())
		0.0:
			file_controls.change_res(savedata["settings"]["visuals"][0],get_window())

func _input(event: InputEvent) -> void:
	if deactivate == true:
		return
	if inputflag == false:
		inputflag = true
		return
	title_screen.show()
	if event.is_action_pressed("ui_down"):
		option_selected +=1
		option_selected = clamp(option_selected,0,max_options)
	if event.is_action_pressed("ui_up"):
		option_selected -=1
		option_selected = clamp(option_selected,0,max_options)
	for numbers in max_options+1:#highlight loop
		if numbers >= 2:
			if numbers == 2:
				labels[numbers].label_settings = UI
				if numbers == option_selected or option_selected>2:
					labels[numbers].label_settings = UI_HIDDEN
			elif numbers == option_selected+1:
				labels[numbers].label_settings = UI
			else:
				labels[numbers].label_settings = UI_HIDDEN
		elif numbers != option_selected:
			labels[numbers].label_settings = UI
		else:
			labels[numbers].label_settings = UI_SELECTED
	for numbers in max_options+1:#arrow loop
		if numbers == option_selected:
			arrows[numbers].show()
		else:
			arrows[numbers].hide()
	if event.is_action_pressed("ui_accept"):
		match option_selected:
			1:
				savedata["setting_no"]["title"] = option_selected
				deactivate = true
				inputflag = false
				print("deactivated")
				title_screen.hide()
				settings.show()
			0:
				match sure_flag:
					true:
						savedata["setting_no"]["title"] = option_selected
						get_tree().change_scene_to_file("res://Main game loop/Main/Central_game_controler.tscn")
					false:
						sure_flag = true
						labels[0].text = "You sure?"
