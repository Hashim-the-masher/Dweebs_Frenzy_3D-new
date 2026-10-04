extends Control

@onready var name_screen: Control = $VBoxContainer/Name
@onready var age_screen: Control = $VBoxContainer/Age
@onready var label: Label = $VBoxContainer/Label
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
@onready var letter = [$VBoxContainer/Name/VBoxContainer2/Letters/Label, $VBoxContainer/Name/VBoxContainer2/Letters/Label2, $VBoxContainer/Name/VBoxContainer2/Letters/Label3, $VBoxContainer/Name/VBoxContainer2/Letters/Label4, $VBoxContainer/Name/VBoxContainer2/Letters/Label5, $VBoxContainer/Name/VBoxContainer2/Letters/Label6]
@onready var number = $VBoxContainer/Age/VBoxContainer/Label
@onready var buttony = [$VBoxContainer/Name/VBoxContainer2/ButtonY/Buttonx, $VBoxContainer/Name/VBoxContainer2/ButtonY/Buttonx2, $VBoxContainer/Name/VBoxContainer2/ButtonY/Buttonx3]
@onready var keypad = [[$"VBoxContainer/Age/VBoxContainer/Num1/1", $"VBoxContainer/Age/VBoxContainer/Num1/2", $"VBoxContainer/Age/VBoxContainer/Num1/3"],[$"VBoxContainer/Age/VBoxContainer/Num2/4", $"VBoxContainer/Age/VBoxContainer/Num2/5", $"VBoxContainer/Age/VBoxContainer/Num2/6"],[$"VBoxContainer/Age/VBoxContainer/Num3/7", $"VBoxContainer/Age/VBoxContainer/Num3/8", $"VBoxContainer/Age/VBoxContainer/Num3/9"],[$VBoxContainer/Age/VBoxContainer/Mis/bksp, $"VBoxContainer/Age/VBoxContainer/Mis/0", $VBoxContainer/Age/VBoxContainer/Mis/Entr]]
var name_keyboard_pos:= Vector2i(0,0)
var age_keypad_pos:= Vector2i(0,0)
@onready var sure_screen: Control = $SureScreen
@onready var sure_button = [$SureScreen/VBoxContainer/HBoxContainer/Label, $SureScreen/VBoxContainer/HBoxContainer/Label2]
var current_letter:=0
var current_section:=0
var numvalue = []
var file_controls = file_control.new()
var savedata:Dictionary
func _ready() -> void:
	savedata = file_controls.load_json_file()
	file_controls.map_inputs(savedata)
	if savedata["settings"]["visuals"][1] == 0.0:
		file_controls.change_res(savedata["settings"]["visuals"][0],get_window())
	else:
		file_controls.fullscreen(get_window())
	buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED

func _input(event: InputEvent) -> void:
	if sure_screen.visible == true:
		if event.is_action_pressed("ui_left"):
			sure_button[1].label_settings = UI_SETTINGS
			sure_button[0].label_settings = UI_SETTINGS_SELECTED
		if event.is_action_pressed("ui_right"):
			sure_button[0].label_settings = UI_SETTINGS
			sure_button[1].label_settings = UI_SETTINGS_SELECTED
		if event.is_action_pressed("ui_accept"):
			match current_section:
				0:
					if sure_button[0].label_settings == UI_SETTINGS_SELECTED:
						print(letter[0].text+letter[1].text+letter[2].text+letter[3].text+letter[4].text+letter[5].text)
						savedata["info"][0] = (letter[0].text+letter[1].text+letter[2].text+letter[3].text+letter[4].text+letter[5].text)
						file_controls.save_to_json_file(savedata)
						sure_screen.hide()
						current_section=1
						label.text = "Your Age?"
						keypad[age_keypad_pos.x][age_keypad_pos.y].label_settings = UI_SETTINGS_SELECTED
						name_screen.hide()
						age_screen.show()
					else:
						sure_screen.hide()
				1:
					if sure_button[0].label_settings == UI_SETTINGS_SELECTED:
						print(display_number())
						savedata["info"][1] = display_number()
						savedata["flags"][0] = 1.0
						file_controls.save_to_json_file(savedata)
						sure_screen.hide()
						current_section=3
						get_tree().change_scene_to_file("res://Menus/Title_screen.tscn")
					else:
						sure_screen.hide()
				
		return
	
	if event.is_action_pressed("ui_left"):
		match  current_section:
			0:
				buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
				name_keyboard_pos.x -=1
				if name_keyboard_pos.y == 2:
					if name_keyboard_pos.x == -1:
						name_keyboard_pos.x = 2
				else:
					if name_keyboard_pos.x == -1:
						name_keyboard_pos.x = 12
				buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
			1:
				keypad[age_keypad_pos.y][age_keypad_pos.x].label_settings = UI_SETTINGS
				age_keypad_pos.x -= 1
				if age_keypad_pos.x ==-1:
					age_keypad_pos.x = 2
				keypad[age_keypad_pos.y][age_keypad_pos.x].label_settings = UI_SETTINGS_SELECTED
		
	if event.is_action_pressed("ui_right"):
		match current_section:
			0:
				buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
				name_keyboard_pos.x +=1
				if name_keyboard_pos.y == 2:
					if name_keyboard_pos.x == 3:
						name_keyboard_pos.x = 0
				else:
					if name_keyboard_pos.x == 13:
						name_keyboard_pos.x = 0
				buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
			1:
				keypad[age_keypad_pos.y][age_keypad_pos.x].label_settings = UI_SETTINGS
				age_keypad_pos.x += 1
				if age_keypad_pos.x ==3:
					age_keypad_pos.x = 0
				keypad[age_keypad_pos.y][age_keypad_pos.x].label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_down"):
		match current_section:
			0:
				buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
				name_keyboard_pos.y +=1
				name_keyboard_pos.y = clampi(name_keyboard_pos.y,0,2)
				if name_keyboard_pos.y == 2:
						if name_keyboard_pos.x == 6:name_keyboard_pos.x=1
						elif name_keyboard_pos.x<6:name_keyboard_pos.x=0
						else:name_keyboard_pos.x=2
				buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
			1:
				keypad[age_keypad_pos.y][age_keypad_pos.x].label_settings = UI_SETTINGS
				age_keypad_pos.y += 1
				if age_keypad_pos.y ==4:
					age_keypad_pos.y = 0
				keypad[age_keypad_pos.y][age_keypad_pos.x].label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_up"):
		match current_section:
			0:
				buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
				name_keyboard_pos.y -=1
				name_keyboard_pos.y = clampi(name_keyboard_pos.y,0,2)
				if name_keyboard_pos.y==1:
						match name_keyboard_pos.x:
							0:name_keyboard_pos.x=4
							1:name_keyboard_pos.x=6
							2:name_keyboard_pos.x=8
			1:
				keypad[age_keypad_pos.y][age_keypad_pos.x].label_settings = UI_SETTINGS
				age_keypad_pos.y -= 1
				if age_keypad_pos.y ==-1:
					age_keypad_pos.y = 3
				keypad[age_keypad_pos.y][age_keypad_pos.x].label_settings = UI_SETTINGS_SELECTED
			
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_accept"):
		match current_section:
			0:
				if name_keyboard_pos.y!=2:
					if current_letter >5:
						return
					letter[current_letter].text = buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).text
					current_letter+=1
				else:
					match name_keyboard_pos.x:
						0:
							if current_letter<1:
								return
							current_letter-=1
							letter[current_letter].text = "⌷"
							
						1:
							for i in 6:
								letter[i].text = "⌷"
							current_letter = 0
						2:
							sure_screen.show()
							sure_button[1].label_settings = UI_SETTINGS_SELECTED
			1:
				if age_keypad_pos.y <3:
					if numvalue.size() <3:
						numvalue.append(keypad[age_keypad_pos.y][age_keypad_pos.x].text)
					display_number()
				else:
					match age_keypad_pos.x:
						0:
							numvalue.pop_back()
							display_number()
						1:
							if numvalue.size() >=3:
								return
							numvalue.append("0")
							display_number()
						2:
							sure_button[0].label_settings = UI_SETTINGS
							sure_button[1].label_settings = UI_SETTINGS_SELECTED
							sure_screen.show()
	if event.is_action_pressed("ui_text_backspace"):
		match current_section:
			0:
				if current_letter<1:
					return
				current_letter-=1
				letter[current_letter].text = "⌷"
			1:
				if numvalue.is_empty() == false:
					
					numvalue.pop_back()
					display_number()

func display_number() -> int:
	number.text = ""
	for letterz in numvalue.size():
		number.text += numvalue[letterz]
	if number.text == "":
		number.text = "0"
	return int(number.text)
