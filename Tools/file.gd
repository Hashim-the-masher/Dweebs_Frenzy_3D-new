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
	var action = [["Shoot","forwards","backwards","turn left","turn right","esc"],["uiAccept","uiUp","uiDown","uiLeft","uiRight"]]
	for no in 2:
		for pos in 6:
			if no ==1 and pos==5:
				save_to_json_file(data)
				break
			var keyboardinput = InputEventKey.new()
			var controlerinput = InputEventJoypadButton.new()
			var controleraxis = InputEventJoypadMotion.new()
			if int(savedata["settings"]["controls"][1][no][pos])<0:
				controleraxis.axis = int(savedata["settings"]["controls"][1][no][pos])+6
				controleraxis.axis_value = savedata["settings"]["controls"][0][no][-(pos+1)]
			else:
				controlerinput.button_index = int(savedata["settings"]["controls"][1][no][pos])
			keyboardinput.keycode = int(savedata["settings"]["controls"][0][no][pos])
			InputMap.action_erase_events(action[no][pos])
			InputMap.action_add_event(action[no][pos],keyboardinput)
			if int(savedata["settings"]["controls"][1][no][pos])>=0:
				InputMap.action_add_event(action[no][pos],controlerinput)
			else:
				InputMap.action_add_event(action[no][pos],controleraxis)
