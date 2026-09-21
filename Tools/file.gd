class_name file_control
extends Resource
var savepath = "user://savedata.json"
var newsavepath = "res://savedata.json"
var savedata:Dictionary
const screen = [1024,512]

func load_json_file():
	var file = FileAccess.open(savepath, FileAccess.READ)
	if file == null:
		return null
	var json = file.get_as_text()
	var jsonobject = JSON.new()
	jsonobject.parse(json)
	print("Loaded:"+str(jsonobject.data)+"from file")
	return jsonobject.data

func make_new_json_file():
	print("making new file")
	var file = FileAccess.open(newsavepath, FileAccess.READ)
	var json = file.get_as_text()
	var jsonobject = JSON.new()
	jsonobject.parse(json)
	print("Loaded:"+str(jsonobject.data)+"from res")
	savedata = jsonobject.data
	file.close()
	var file2 = FileAccess.open(savepath, FileAccess.ModeFlags.WRITE)
	var json_text = JSON.stringify(savedata)
	file2.store_string(json_text)

func save_to_json_file(data):
	var file = FileAccess.open(savepath, FileAccess.ModeFlags.WRITE)
	var json_text = JSON.stringify(data)
	print("written:"+json_text+"to file")
	file.store_string(json_text)

func change_res(scale,window):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if window == null:
		print("File error:window is null")
		return
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	window.content_scale_factor =  scale
	window.size = (Vector2i(screen[0]*scale,screen[1]*scale))
	print("window size changed")

func fullscreen(window):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	if window == null:
		print("File error:window is null")
		return
	window.size = (Vector2i(screen[0],screen[1]))
	window.content_scale_factor =  1
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS

func set_volume(data):
	savedata = data
	print("setting volume")
	AudioServer.set_bus_volume_linear(1,savedata["settings"]["sounds"][0])#music
	AudioServer.set_bus_volume_linear(2,savedata["settings"]["sounds"][1])#sound

func map_inputs(data):#spesific to THE GAME WITH FAWAS
	print("mapping controls")
	savedata = data
	for no in 2:
		for pos in 6:
			var keyboardinput = InputEventKey.new()
			var controlerinput = InputEventJoypadButton.new()
			match no:
				0:
					controlerinput.button_index = int(savedata["settings"]["controls"][1][no][pos])
					keyboardinput.keycode = int(savedata["settings"]["controls"][0][no][pos])
					match pos:
						0:
							InputMap.action_erase_events("Shoot")
							InputMap.action_add_event("Shoot",keyboardinput)
							InputMap.action_add_event("Shoot",controlerinput)
						1:
							InputMap.action_erase_events("forwards")
							InputMap.action_add_event("forwards",keyboardinput)
							InputMap.action_add_event("forwards",controlerinput)
						2:
							InputMap.action_erase_events("backwards")
							InputMap.action_add_event("backwards",keyboardinput)
							InputMap.action_add_event("backwards",controlerinput)
						3:
							InputMap.action_erase_events("turn left")
							InputMap.action_add_event("turn left",keyboardinput)
							InputMap.action_add_event("turn left",controlerinput)
						4:
							InputMap.action_erase_events("turn right")
							InputMap.action_add_event("turn right",keyboardinput)
							InputMap.action_add_event("turn right",controlerinput)
						5:
							InputMap.action_erase_events("esc")
							InputMap.action_add_event("esc",keyboardinput)
							InputMap.action_add_event("esc",controlerinput)
				1:
					if pos == 5:
						save_to_json_file(savedata)
						return
					controlerinput.button_index = int(savedata["settings"]["controls"][1][no][pos])
					keyboardinput.keycode = int(savedata["settings"]["controls"][0][no][pos])
					match pos:
						0:
							InputMap.action_erase_events("ui_accept")
							InputMap.action_add_event("ui_accept",keyboardinput)
							InputMap.action_add_event("ui_accept",controlerinput)
						1:
							InputMap.action_erase_events("ui_up")
							InputMap.action_add_event("ui_up",keyboardinput)
							InputMap.action_add_event("ui_up",controlerinput)
						2:
							InputMap.action_erase_events("ui_down")
							InputMap.action_add_event("ui_down",keyboardinput)
							InputMap.action_add_event("ui_down",controlerinput)
						3:
							InputMap.action_erase_events("ui_left")
							InputMap.action_add_event("ui_left",keyboardinput)
							InputMap.action_add_event("ui_left",controlerinput)
						4:
							InputMap.action_erase_events("ui_right")
							InputMap.action_add_event("ui_right",keyboardinput)
							InputMap.action_add_event("ui_right",controlerinput)
