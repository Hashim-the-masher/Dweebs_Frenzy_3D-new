extends Control

@onready var name_screen: Control = $VBoxContainer/Name
@onready var age_screen: Control = $VBoxContainer/Age
@onready var label: Label = $VBoxContainer/Label
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
@onready var letters: HBoxContainer = $VBoxContainer/Name/VBoxContainer2/Letters
@onready var buttony = [$VBoxContainer/Name/VBoxContainer2/ButtonY/Buttonx, $VBoxContainer/Name/VBoxContainer2/ButtonY/Buttonx2, $VBoxContainer/Name/VBoxContainer2/ButtonY/Buttonx3]
@onready var name_keyboard_pos= Vector2i(0,0)

func _ready() -> void:
	buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
		name_keyboard_pos.x -=1
		if name_keyboard_pos.y == 2:
			name_keyboard_pos.x = clampi(name_keyboard_pos.x,0,2)
		else:name_keyboard_pos.x = clampi(name_keyboard_pos.x,0,12)
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_right"):
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
		name_keyboard_pos.x +=1
		if name_keyboard_pos.y == 2:
			name_keyboard_pos.x = clampi(name_keyboard_pos.x,0,2)
		else:name_keyboard_pos.x = clampi(name_keyboard_pos.x,0,12)
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_down"):
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
		name_keyboard_pos.y +=1
		name_keyboard_pos.y = clampi(name_keyboard_pos.y,0,2)
		if name_keyboard_pos.y == 2:name_keyboard_pos.x=2
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_up"):
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS
		name_keyboard_pos.y -=1
		name_keyboard_pos.y = clampi(name_keyboard_pos.y,0,2)
		if name_keyboard_pos.y == 2:name_keyboard_pos.x=2
		buttony[name_keyboard_pos.y].get_child(name_keyboard_pos.x).label_settings = UI_SETTINGS_SELECTED
	if event.is_action_pressed("ui_accept"):
		pass
