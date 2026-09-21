extends HBoxContainer
@onready var settings: VBoxContainer = $"../settings"
@onready var controler = [$".", $"../controler"]
@onready var controleractions = [{"actions":[[$actions/Label2, $actions/Label3, $actions/Label4, $actions/Label5, $actions/Label6, $actions/Label7],[$ui_actions/Label2, $ui_actions/Label3, $ui_actions/Label4, $ui_actions/Label5, $ui_actions/Label6]],"key":[[$key/Label2, $key/Label3, $key/Label4, $key/Label5, $key/Label6, $key/Label7],[$key2/Label2, $key2/Label3, $key2/Label4, $key2/Label5, $key2/Label6]]},{"actions":[[$"../controler/actions/Label2", $"../controler/actions/Label3", $"../controler/actions/Label4", $"../controler/actions/Label5", $"../controler/actions/Label6", $"../controler/actions/Label7"],[$"../controler/ui_actions/Label2", $"../controler/ui_actions/Label3", $"../controler/ui_actions/Label4", $"../controler/ui_actions/Label5", $"../controler/ui_actions/Label6"]],"key":[[$"../controler/key/Label2", $"../controler/key/Label3", $"../controler/key/Label4", $"../controler/key/Label5", $"../controler/key/Label6", $"../controler/key/Label7"],[$"../controler/key2/Label2", $"../controler/key2/Label3", $"../controler/key2/Label4", $"../controler/key2/Label5", $"../controler/key2/Label6"]]}]
var keyno:int = 0
var keypos:int = 0
var pressnow:bool = false
var wait:bool = true
var current_setting = "keyboard"
var filecontrols = file_control.new()
var savedata
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")

func _ready() -> void:
	savedata = filecontrols.load_json_file()
	reset_values()


func _input(event: InputEvent) -> void:
	if controler[0].visible != true and controler[1].visible != true:
		pressnow = false
		reset_values()
		return
	if controler[0].visible == true:
		current_setting = 0
	if controler[1].visible == true:
		current_setting = 1
	if pressnow == true:
		match current_setting:
			0:
				controleractions[0]["key"][keyno][keypos].text = "Listing for input"
				if wait == true:
					wait = false
				elif event is InputEventKey:
					settings.wait = true
					var input = InputEventKey.new()
					input.keycode = event.keycode
					controleractions[0]["key"][keyno][keypos].text = input.as_text()
					savedata["settings"]["controls"][current_setting][keyno][keypos] = event.keycode
					filecontrols.map_inputs(savedata)
					pressnow = false
					wait = true
				return
			1:
				controleractions[1]["key"][keyno][keypos].text = "Listing for input"
				if wait == true:
					wait = false
				elif event is InputEventJoypadButton:
					settings.wait = true
					var input = InputEventJoypadButton.new()
					input.button_index = event.button_index
					controleractions[current_setting]["key"][keyno][keypos].text = input.as_text()
					savedata["settings"]["controls"][current_setting][keyno][keypos] = event.button_index
					filecontrols.map_inputs(savedata)
					pressnow = false
					wait = true
				return
	else:
		if  event.is_action_pressed("ui_up"):
			keypos-=1
		if event.is_action_pressed("ui_down"):
			keypos+=1
		if event.is_action_pressed("ui_left"):
			keyno-=1
		if event.is_action_pressed("ui_right"):
			keyno+=1
		settings.wait = false
		keyno =  clampi(keyno,0,1)
		keypos = clampi(keypos,0,5)
		if keyno == 1 and keypos == 5:
			keypos = 4
		for no in 2:
			for pos in 6:
				if pos == 5:
					if no == 1:
						pass
					else:controleractions[current_setting]["key"][no][pos].label_settings = UI_SETTINGS
				else:controleractions[current_setting]["key"][no][pos].label_settings = UI_SETTINGS
		controleractions[current_setting]["key"][keyno][keypos].label_settings = UI_SETTINGS_SELECTED
		if event.is_action_pressed("ui_accept"):
			pressnow = true
			print("keyno:"+str(keyno)+" keypos:"+str(keypos)+" selected")

func reset_values():
	for no in 2:
		for pos in 6:
			var keyboardinput = InputEventKey.new()
			var controlerinput = InputEventJoypadButton.new()
			if pos == 5:
				if no == 1:
					pass
				else:
					keyboardinput.keycode = int(savedata["settings"]["controls"][0][no][pos])
					controlerinput.button_index =int(savedata["settings"]["controls"][1][no][pos])
					controleractions[0]["key"][no][pos].text = keyboardinput.as_text()
					controleractions[1]["key"][no][pos].text = controlerinput.as_text()
			else:
				keyboardinput.keycode = int(savedata["settings"]["controls"][0][no][pos])
				controlerinput.button_index =int(savedata["settings"]["controls"][1][no][pos])
				controleractions[0]["key"][no][pos].text = keyboardinput.as_text()
				controleractions[1]["key"][no][pos].text = controlerinput.as_text()
	
