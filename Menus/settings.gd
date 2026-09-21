extends Control

@onready var menu_pause: Control = $".."
@onready var titles = [$SliderSettings/Titles,$"../Sound_settings/SliderSettings/Titles",$"../Visual_settings/SliderSettings/Titles",$"../Controler_settings/SliderSettings/Titles"]
var titles_sizes = [[0,0,0,0],[0,0,0],[0,0,0],[0,0,0,0]]
@onready var values = [null,$"../Sound_settings/SliderSettings/Display value",$"../Visual_settings/SliderSettings/Display value",$"../Controler_settings/SliderSettings/Display value"]
@onready var arrows = [[$SliderSettings/arrows/arrow, $SliderSettings/arrows/arrow2, $SliderSettings/arrows/arrow3, $SliderSettings/arrows/arrow4],[$"../Sound_settings/SliderSettings/arrows/arrow", $"../Sound_settings/SliderSettings/arrows/arrow2", $"../Sound_settings/SliderSettings/arrows/arrow3"],[$"../Visual_settings/SliderSettings/arrows/arrow", $"../Visual_settings/SliderSettings/arrows/arrow2", $"../Visual_settings/SliderSettings/arrows/arrow3"],[$"../Controler_settings/SliderSettings/arrows/arrow", $"../Controler_settings/SliderSettings/arrows/arrow2", $"../Controler_settings/SliderSettings/arrows/arrow3",$"../Controler_settings/SliderSettings/arrows/arrow4"]]
var setting_no = [3,2,2,2]
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
var back_confirmation_flag = false
@onready var asettings = [$".",$"../Sound_settings",$"../Visual_settings",$"../Controler_settings"]
var current_setting = 0
var on = [false,false]
@onready var keyboard = $"../keyboard"
@onready var controler = $"../controler"
var wait:bool = false
const LIGHT_BI_ARROW = preload("uid://d24grgb0ooerg")
const LIGHT_ARROW = preload("uid://dyf64kjp5hdow")
var move_mode = 0
var file_controls = file_control.new()
var savedata:Dictionary

func _ready() -> void: 
	if file_controls.load_json_file() == null:
		file_controls.make_new_json_file()
	savedata = file_controls.load_json_file()
	values[1].get_child(0).text =  str(savedata["settings"]["sounds"][0])
	values[1].get_child(1).text =  str(savedata["settings"]["sounds"][1])
	values[2].get_child(0).text = str(savedata["settings"]["visuals"][0])
	values[2].get_child(1).text = str(savedata["settings"]["visuals"][1])
	match values[2].get_child(1).text:
		"1.0":
			values[2].get_child(1).text = "Yes"
		"0.0":
			values[2].get_child(1).text = "No"

func _input(event: InputEvent) -> void:
	if menu_pause.deactivate == false:
		asettings[current_setting].hide()
		return
	if move_mode == 1:
		titles[current_setting].get_child(setting_no[current_setting]).label_settings = UI_SETTINGS
		values[current_setting].get_child(setting_no[current_setting]).label_settings = UI_SETTINGS_SELECTED
		arrows[current_setting][setting_no[current_setting]].get_child(0).texture = LIGHT_BI_ARROW
		match current_setting:
			1:
				if event.is_action_pressed("ui_left"):
					savedata["settings"]["sounds"][setting_no[current_setting]] -=.1
					savedata["settings"]["sounds"][setting_no[current_setting]] = clampf(savedata["settings"]["sounds"][setting_no[current_setting]],0.0,1.0)
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["sounds"][setting_no[current_setting]])
				if event.is_action_pressed("ui_right"):
					savedata["settings"]["sounds"][setting_no[current_setting]] +=.1
					savedata["settings"]["sounds"][setting_no[current_setting]] = clampf(savedata["settings"]["sounds"][setting_no[current_setting]],0.0,1.0)
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["sounds"][setting_no[current_setting]])
				if event.is_action_pressed("ui_accept"):
					arrows[current_setting][setting_no[current_setting]].get_child(0).texture = LIGHT_ARROW
					values[current_setting].get_child(setting_no[current_setting]).label_settings = UI_SETTINGS
					move_mode=0
					file_controls.save_to_json_file(savedata)
					return
			2:
				if event.is_action_pressed("ui_left"):
					match setting_no[current_setting]:
						0:
							savedata["settings"]["visuals"][setting_no[current_setting]] -=.5
							savedata["settings"]["visuals"][setting_no[current_setting]] = clampf(savedata["settings"]["visuals"][setting_no[current_setting]],0.5,3.0)
							if savedata["settings"]["visuals"][1] !=1:
								file_controls.change_res(savedata["settings"]["visuals"][0],get_window())
						1:
							savedata["settings"]["visuals"][setting_no[current_setting]] -=1
							savedata["settings"]["visuals"][setting_no[current_setting]] = clampf(savedata["settings"]["visuals"][setting_no[current_setting]],0,1.0)
							file_controls.change_res(savedata["settings"]["visuals"][0],get_window())
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["visuals"][setting_no[current_setting]])
					match values[current_setting].get_child(1).text:
						"1.0":
							values[current_setting].get_child(1).text = "Yes"
						"0.0":
							values[current_setting].get_child(1).text = "No"
				if event.is_action_pressed("ui_right"):
					match setting_no[current_setting]:
						0:
							savedata["settings"]["visuals"][setting_no[current_setting]] +=.5
							savedata["settings"]["visuals"][setting_no[current_setting]] = clampf(savedata["settings"]["visuals"][setting_no[current_setting]],0.5,3.0)
							if savedata["settings"]["visuals"][1] !=1:
								file_controls.change_res(savedata["settings"]["visuals"][0],get_window())
						1:
							savedata["settings"]["visuals"][setting_no[current_setting]] +=1
							savedata["settings"]["visuals"][setting_no[current_setting]] = clampf(savedata["settings"]["visuals"][setting_no[current_setting]],0,1.0)
							file_controls.fullscreen(get_window())
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["visuals"][setting_no[current_setting]])
					match values[current_setting].get_child(1).text:
						"1.0":
							values[current_setting].get_child(1).text = "Yes"
						"0.0":
							values[current_setting].get_child(1).text = "No"
				if event.is_action_pressed("ui_accept"):
					values[current_setting].get_child(setting_no[current_setting]).label_settings = UI_SETTINGS
					arrows[current_setting][setting_no[current_setting]].get_child(0).texture = LIGHT_ARROW
					move_mode=0
					file_controls.save_to_json_file(savedata)
					return
			3:
				if event.is_action_pressed("ui_left"):
					savedata["settings"]["controls"][setting_no[current_setting]] -=.1
					savedata["settings"]["controls"][setting_no[current_setting]] = clampf(savedata["settings"]["controls"][setting_no[current_setting]],0.1,4.0)
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["controls"][setting_no[current_setting]])
				if event.is_action_pressed("ui_right"):
					savedata["settings"]["controls"][setting_no[current_setting]] +=.1
					savedata["settings"]["controls"][setting_no[current_setting]] = clampf(savedata["settings"]["controls"][setting_no[current_setting]],0.1,4.0)
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["controls"][setting_no[current_setting]])
				if event.is_action_pressed("ui_accept"):
					arrows[current_setting][setting_no[current_setting]].get_child(0).texture = LIGHT_ARROW
					values[current_setting].get_child(setting_no[current_setting]).label_settings = UI_SETTINGS
					move_mode=0
					file_controls.save_to_json_file(savedata)
		return
	asettings[current_setting].show()
	if event.is_action_pressed("ui_up") and on[1] == false and on[0] == false:
		setting_no[current_setting] -= 1
		setting_no[current_setting] = clampi(setting_no[current_setting],0,titles_sizes[current_setting].size()-1)
		if current_setting == 0:
			back_confirmation_flag = false
			titles[current_setting].get_child(3).text = "Back"
	if event.is_action_pressed("ui_down") and on[1] == false and on[0] == false:
		setting_no[current_setting] += 1
		setting_no[current_setting] = clampi(setting_no[current_setting],0,titles_sizes[current_setting].size()-1)
	if back_confirmation_flag == false and on[1] == false and on[0] == false:
		for numbers in titles_sizes[current_setting].size():
			if numbers == setting_no[current_setting]:
				titles[current_setting].get_child(numbers).label_settings = UI_SETTINGS_SELECTED
				arrows[current_setting][numbers].show()
			else:
				titles[current_setting].get_child(numbers).label_settings = UI_SETTINGS
				arrows[current_setting][numbers].hide()
		for nodes in asettings:
			if nodes != asettings[current_setting]:
				nodes.hide()
			else:nodes.show()
	if event.is_action_pressed("ui_accept"):
		match current_setting:
			0:
				print("on settings")
				match setting_no[current_setting]:
					0:
						print("on sound")
						current_setting = 1
						return
					1:
						print("on visuals")
						current_setting = 2
						return
					2:
						print("on controls")
						current_setting = 3
						return
					3:
						asettings[current_setting].hide()
						menu_pause.deactivate = false
						$"../Title_screen".show()
						return
			1:
				
				match setting_no[current_setting]:
					0:
						move_mode = 1
					1:
						move_mode = 1
					2:
						current_setting = 0
						return
			2:
				
				match setting_no[current_setting]:
					0:
						move_mode = 1
					1:
						move_mode = 1
					2:
						current_setting = 0
						return
			3:
				#controls
				match setting_no[current_setting]:
					0:
						if on[0] == false:
							on[0]= true
							titles[current_setting].get_child(0).label_settings = UI_SETTINGS
							arrows[current_setting][setting_no[current_setting]].hide()
							keyboard.show()
					1:
						if on[1] == false:
							on[1]= true
							titles[current_setting].get_child(1).label_settings = UI_SETTINGS
							arrows[current_setting][setting_no[current_setting]].hide()
							controler.show()
					2:
						move_mode = 1
					3:
						current_setting = 0
						return
	if event.is_action_pressed("esc"):
		if on[0] == true and wait == false:
			on[0]=false
			titles[current_setting].get_child(0).label_settings = UI_SETTINGS_SELECTED
			arrows[current_setting][setting_no[current_setting]].show()
			keyboard.hide()
			return
		if on[1] == true and wait == false:
			on[1]=false
			titles[current_setting].get_child(1).label_settings = UI_SETTINGS_SELECTED
			arrows[current_setting][setting_no[current_setting]].show()
			controler.hide()
			return


func exit_settings():
	on[0] = false
	on[1] = false
	current_setting = 0
	move_mode = 0 
	keyboard.hide()
	controler.hide()
	for node in asettings:
		node.hide()
