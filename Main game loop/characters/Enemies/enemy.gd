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
@onready var timer: Timer = $Timer
const BULLET = preload("uid://drhbyeog3igbd")
signal kill

func _process(delta: float) -> void:
	if enemy_detected_flag == true:
		if timer.is_stopped() == true:
			timer.start()
		if rotation_speed == null:
			rotation_speed = 0.5
		var desireable_rotation = atan2((player.position.x-position.x),(player.position.z-position.z))-PI/2
		if rad_to_deg(desireable_rotation) >= -270  and rad_to_deg(desireable_rotation) <= -180:
			desireable_rotation += TAU
		if absf(desireable_rotation-rotation.y)<0.05:
			pass
		elif desireable_rotation>rotation.y:
			if rad_to_deg(desireable_rotation)-180>rotation_degrees.y:
				rotation_velocity += -1*delta*rotation_speed
			else:
				rotation_velocity += 1*delta*rotation_speed
		else:
			if rad_to_deg(desireable_rotation)+180<rotation_degrees.y:
				rotation_velocity += 1*delta*rotation_speed
			else:
				rotation_velocity += -1*delta*rotation_speed
		rotation_velocity /= rotation_friction
		rotation_velocity = clampf(rotation_velocity,min_rotation,max_rotation)
		rotation.y += rotation_velocity
		if rotation_degrees.y > 180:
			rotation_degrees.y = -179
		if rotation_degrees.y < -180:
			rotation_degrees.y = 179
func _on_hitbox_area_entered(area: Area3D) -> void:
	print(name+",took damge from:"+area.name)
	hp -= 1 
	dmg_sound.play()
	enemy_detected_flag = true
	if area.name == "Smash":
		hp -= extra_smash_damge
	if hp <= 0:
		kill.emit()
		queue_free()


func _on_timer_timeout() -> void:
	if enemy_detected_flag == true:
		shoot()

func shoot():
	if BULLET == null:
		print("enemy bullet is null")
		return
	var bullet = BULLET.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position,(-rotation.y))
