extends CharacterBody3D 
var rotaion_velocity:float
@export var rotation_speed:float = .5
@export var max_rotation:float = .1
@export var min_rotation:float = -.1
@export var rotation_friction:float = 1.15
@export var coursorspeed:float = 0.015
@export var speed:float = 150 
var tank_speed:float = speed*4
@export var max_velocity:float = 250
@export var min_velocity:float = 0.1  
@export var back_slow_mutiplyer:float = .2 
@export var friction:float = 1.03 
@export var breaking_friction:float = 1.1 
@onready var camera = $Camera3D
@onready var audio_listener = $AudioListener3D
@onready var menu_pause: Control = $"../Ui/menu_pause"
@onready var hitbox = $Area3D 
@onready var coursor: TextureRect = $CanvasLayer/coursor
@onready var bullet_scenes = {"bullet":preload("res://Main game loop/characters/Player/Player bullets/Bullet.tscn"),"smash":preload("res://Main game loop/characters/Player/Player bullets/smash.tscn"),"dash":preload("res://Main game loop/characters/Player/Player bullets/dash.tscn")} 
@onready var wait_time = {"shoot":.1,"smash":.5,"dash":.2} 
@onready var cooldown_timer: Timer = $cooldown
var flags = {"spawn":false,"cooldown":true,"hit?":false} 
var state = "Normal state"
var meshstate
@onready var meshes = {"Normal state":$"Mesh(es)/Normal state", "Dash state":$"Mesh(es)/Dash state", "Smash state":$"Mesh(es)/Smash state"}
var states = {0:"Normal state",1:"Smash state",2:"Dash state"} 
var bullet_volume:float
@onready var file_tools = file_control.new()
var savedata:Dictionary

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	savedata = file_tools.load_json_file()
	state = states[0]
	switch_mesh()
	bullet_volume = linear_to_db(savedata["settings"]["sounds"][1])

func reset_volume():
	savedata = file_tools.load_json_file()
	bullet_volume = linear_to_db(savedata["settings"]["sounds"][1])

func switch_mesh(selectstate=state):
	meshstate = selectstate
	for num in meshes:
		if meshstate == num:
			meshes[num].show()
			print(num+" shown")
		elif meshstate != num:
			meshes[num].hide()
			print(num+" hidden")

func _physics_process(delta: float) -> void:
	if menu_pause != null:
		if menu_pause.active == true:
			return
	if Input.is_action_pressed("Shoot") and flags["cooldown"] == true:  
		shoot()
	elif flags["spawn"] == true:
		if Input.get_vector("backwards","forwards","turn left","turn right"):
			if sqrt(velocity.x**2+velocity.y**2) < max_velocity:
				var velocity_on_a_plane = Vector2(0,0)
				if Input.is_action_pressed("forwards") or Input.is_action_pressed("backwards"):
					velocity_on_a_plane += Input.get_vector("backwards","forwards","turn left","turn right").rotated(rotation.y)*speed*delta
				if Input.is_action_pressed("backwards"):
					velocity_on_a_plane -= (Input.get_vector("backwards","forwards","NA","NA").rotated(rotation.y)*speed*delta)*back_slow_mutiplyer
				if Input.is_action_pressed("turn left") or Input.is_action_pressed("turn right"):
					velocity_on_a_plane += Input.get_vector("backwards","forwards","turn left","turn right").rotated(rotation.y)*tank_speed*delta 
					velocity_on_a_plane /= breaking_friction
				velocity_on_a_plane /= friction
				velocity = Vector3(velocity_on_a_plane.x,0,velocity_on_a_plane.y)
		elif sqrt(velocity.x**2+velocity.z**2)>min_velocity:
			velocity /= breaking_friction
		else:pass
		if atan2(coursor.position.y-225,coursor.position.x-480)>rotation.y:
			if (rad_to_deg(atan2(coursor.position.y-225,coursor.position.x-480))-180)>rotation_degrees.y:
				rotaion_velocity += -1*delta*rotation_speed
				
			else:
				rotaion_velocity += 1*delta*rotation_speed
		else:
			if (rad_to_deg(atan2(coursor.position.y-225,coursor.position.x-480))+180)<rotation_degrees.y:
				rotaion_velocity += 1*delta*rotation_speed
			else:
				rotaion_velocity += -1*delta*rotation_speed
		rotaion_velocity /= rotation_friction
		rotaion_velocity = clampf(rotaion_velocity,min_rotation,max_rotation)
		rotation.y += rotaion_velocity
		meshes[state].get_parent().rotation_degrees.y -= rad_to_deg(rotaion_velocity)
		meshes[state].get_parent().rotation_degrees.y -= rad_to_deg(rotaion_velocity)#i dont want to know, but it works
		audio_listener.rotation.y -= rotaion_velocity
		camera.rotation.y -= rotaion_velocity
		move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		coursor.position += event.velocity*coursorspeed
		coursor.position.x = clamp(coursor.position.x,-29,991)
		coursor.position.y = clamp(coursor.position.y,-29,481)


func shoot():
	match state:
		"Normal state":
			var bullet = bullet_scenes["bullet"].instantiate()
			add_sibling(bullet)
			bullet.start(position,rotation.z,bullet_volume)
			flags["cooldown"]= false
			cooldown_timer.wait_time = wait_time["shoot"]
			cooldown_timer.start()
		"Smash state":
			pass
		"Dash state":
			pass

func on_kill(killdata):
	print("killed:"+str(killdata))

func _on_Enemy_contact(area: Area2D) -> void:
	if flags["hit?"] == true:
		return
	
	print("this area killed me:"+area.name)
	Death()
	flags["hit?"] = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	if flags["hit?"] == true:
		return
	print("this body killed me:"+body.name)
	Death()
	flags["hit?"] = true

func Death():
	get_tree().change_scene_to_file("")


func _on_cooldown_timeout() -> void:
	flags["cooldown"] = true
