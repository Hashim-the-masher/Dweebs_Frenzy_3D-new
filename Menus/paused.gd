extends Control

@onready var hbox: HBoxContainer = $HBoxContainer
@onready var resume: Label = $HBoxContainer/VBoxContainer/Resume
@onready var options: Label = $HBoxContainer/VBoxContainer/Options
@onready var arrow = [$HBoxContainer/VBoxContainer2/arrow, $HBoxContainer/VBoxContainer2/arrow2]
var file_controls = file_control.new()
var savedata:Dictionary
var option_selected:int = 0
var active:bool = false
var settings:bool = false
const screen = [1024,512]
const UI = preload("uid://clnnygmiqiu1")
const UI_SELECTED = preload("uid://dvpvf7wdsrfxi")
var ignore= false
func _ready() -> void:
	savedata = file_controls.load_json_file()
	match option_selected:
		1:
			resume.label_settings = UI
			options.label_settings = UI_SELECTED
		0:
			resume.label_settings = UI_SELECTED
			options.label_settings = UI
	DisplayServer.window_set_size(Vector2i(screen[0]*savedata["settings"]["visuals"][0],screen[1]*savedata["settings"]["visuals"][0]))
	get_window().content_scale_factor = savedata["settings"]["visuals"][0]
	match savedata["settings"]["visuals"][1]:
		1.0:
			get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			print("window fullsckeen")	
		0.0:
			get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			print("window windowed")	

func _process(_delta: float) -> void:
	if active == false:
		hide()
		return
	if settings == true:
		hbox.hide()
		return
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()
	hbox.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and ignore == true:
		ignore = false
		return
	if event.is_action_pressed("esc"):
		if settings == true:
			settings = false
			$settings.exit_settings()
			active = false
			return
		if active == true:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			active=false
		else:active=true
	if active == false:
		return
	if settings == true:
		return
	if event.is_action_pressed("ui_down"):
		option_selected =1
		resume.label_settings = UI
		options.label_settings = UI_SELECTED
		resume.text = "Resume"
		arrow[1].show()
		arrow[0].hide()
	if event.is_action_pressed("ui_up"):
		option_selected = 0
		resume.label_settings = UI_SELECTED
		options.label_settings = UI
		arrow[0].show()
		arrow[1].hide()
	if event.is_action_pressed("ui_accept"):
		match option_selected:
			1:
				settings = true
			0:
				active = false
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
