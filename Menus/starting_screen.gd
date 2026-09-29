extends Control

@onready var name_screen: Control = $VBoxContainer/Name
@onready var age_screen: Control = $VBoxContainer/Age
@onready var label: Label = $VBoxContainer/Label
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
@onready var letter = [$VBoxContainer/Name/VBoxContainer2/Letters/Label, $VBoxContainer/Name/VBoxContainer2/Letters/Label2, $VBoxContainer/Name/VBoxContainer2/Letters/Label3, $VBoxContainer/Name/VBoxContainer2/Letters/Label4, $VBoxContainer/Name/VBoxContainer2/Letters/Label5, $VBoxContainer/Name/VBoxContainer2/Letters/Label6]
@onready var buttony = [$VBoxContainer/Name/VBoxContainer2/ButtonY/Buttonx, $VBoxContainer/Name/VBoxContainer2/ButtonY/Buttonx2, $VBoxContainer/Name/VBoxContainer2/ButtonY/Buttonx3]
@onready var name_keyboard_pos= Vector2i(0,0)
var current_letter:=0

func _ready() -> void:
	buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
		name_keyboard_pos.x -=1
		if name_keyboard_pos.y == 2:
			if name_keyboard_pos.x == -1:
				name_keyboard_pos.x = 2
		else:
			if name_keyboard_pos.x == -1:
				name_keyboard_pos.x = 12
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_right"):
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
		name_keyboard_pos.x +=1
		if name_keyboard_pos.y == 2:
			if name_keyboard_pos.x == 3:
				name_keyboard_pos.x = 0
		else:
			if name_keyboard_pos.x == 13:
				name_keyboard_pos.x = 0
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_down"):
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
		name_keyboard_pos.y +=1
		name_keyboard_pos.y = clampi(name_keyboard_pos.y,0,2)
		if name_keyboard_pos.y == 2:
				if name_keyboard_pos.x == 6:name_keyboard_pos.x=1
				elif name_keyboard_pos.x<6:name_keyboard_pos.x=0
				else:name_keyboard_pos.x=2
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_up"):
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
		name_keyboard_pos.y -=1
		name_keyboard_pos.y = clampi(name_keyboard_pos.y,0,2)
		if name_keyboard_pos.y==1:
				match name_keyboard_pos.x:
					0:name_keyboard_pos.x=4
					1:name_keyboard_pos.x=6
					2:name_keyboard_pos.x=8
			
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_accept"):
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
					pass
