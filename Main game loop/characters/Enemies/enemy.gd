extends CharacterBody3D
var wait_for_it_flag = true
var enemy_detected_flag = false
@export var rotation_speed =.5
@export var min_rotation:float = -.1
@export var max_rotation:float = .1
@export var hp = 15
@export var extra_smash_damge = 14
var rotation_friction = 1.15
var rotaion_velocity:float
@onready var dmg_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D
var file_controls = file_control.new()
var savedata:Dictionary
@onready var player: CharacterBody3D = $"../../player"
var BULLET:PackedScene
signal kill

func _ready() -> void:
	savedata = file_controls.load_json_file()
	dmg_sound.volume_linear = savedata["settings"]["sounds"][1]

func _process(delta: float) -> void:
	if enemy_detected_flag == true:
		var desireable_rotation = atan2((player.position.z-position.z),(player.position.x-position.x))
		if absf(desireable_rotation-rotation.y)<0.05:
			pass
		elif desireable_rotation>rotation.y:
			if desireable_rotation>rotation_degrees.y:
				rotaion_velocity += -1*delta*rotation_speed
				
			else:
				rotaion_velocity += 1*delta*rotation_speed
		else:
			if desireable_rotation<rotation_degrees.y:
				rotaion_velocity += 1*delta*rotation_speed
			else:
				rotaion_velocity += -1*delta*rotation_speed
		rotaion_velocity /= rotation_friction
		rotaion_velocity = clampf(rotaion_velocity,min_rotation,max_rotation)
		rotation.y += rotaion_velocity

func _on_hitbox_area_entered(area: Area2D) -> void:
	enemy_detected_flag = true
	print(name+",took damge from:"+area.name)
	hp -= 1 
	dmg_sound.play()
	if area.name == "Smash":
		hp -= extra_smash_damge
	if hp <= 0:
		kill.emit()
		queue_free()
	


func _on_timer_timeout() -> void:
	if enemy_detected_flag == true:
		shoot()

func shoot():
	if wait_for_it_flag == true:
		wait_for_it_flag = false
		return
	if BULLET == null:
		print("enemy bullet is null")
		return
	var bullet = BULLET.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position,rotation)


func _on_seeing_radius_body_entered(body: Node2D) -> void:
	enemy_detected_flag = true

func _on_seeing_radius_body_exited(body: Node2D) -> void:
	enemy_detected_flag = false
