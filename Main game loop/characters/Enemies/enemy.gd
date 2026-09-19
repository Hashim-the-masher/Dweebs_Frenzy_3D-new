extends CharacterBody3D
var wait_for_it_flag = true
var enemy_detected_flag = false
@export var rotation_speed =.5
@export var min_rotation:float = -.1
@export var max_rotation:float = .1
@export var hp = 15
@export var extra_smash_damge = 14
var rotation_friction = 1.15
var rotation_velocity:float
@onready var dmg_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var player: CharacterBody3D = $"../../player"
var BULLET:PackedScene
signal kill

func _process(delta: float) -> void:
	if enemy_detected_flag == false:
		if rotation_speed == null:
			rotation_speed = 0.5
		print(name+str(rotation_degrees.y))
		var desireable_rotation = atan2((player.position.x-position.x),(player.position.z-position.z))-PI/2
		if absf(desireable_rotation-rotation.y)<0.05:
			pass
		elif desireable_rotation>rotation.y:
			if desireable_rotation-PI>rotation.y:
				rotation_velocity += -1*delta*rotation_speed
			else:
				rotation_velocity += 1*delta*rotation_speed
		else:
			if desireable_rotation+PI<rotation.y:
				rotation_velocity += 1*delta*rotation_speed
			else:
				rotation_velocity += -1*delta*rotation_speed
		rotation_velocity /= rotation_friction
		rotation_velocity = clampf(rotation_velocity,min_rotation,max_rotation)
		rotation.y += rotation_velocity
		
func _on_hitbox_area_entered(area: Area3D) -> void:
	print(name+",took damge from:"+area.name)
	hp -= 1 
	dmg_sound.play()
	if area.name == "Smash":
		hp -= extra_smash_damge
	if hp <= 0:
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
