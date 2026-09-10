extends Area3D
@onready var sfx: AudioStreamPlayer3D = $AudioStreamPlayer2D
@export var speed = 3
@export var damage = 1
var line_of_fire
func start(pos,the_rotation,volume):
	position = pos
	line_of_fire = the_rotation
	sfx.volume_db = volume
	rotate_y(deg_to_rad(90))
	rotation.y += the_rotation
func _process(delta):
	if line_of_fire == null:
		return
	position += Vector3(0,1,0).rotated(Vector3(0,1,0),line_of_fire)*speed*delta
func _on_enemy(area: Area2D) -> void:
	if area.collision_layer == 32:
		print("player,"+name+",despawned from hitting:"+area.name)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("player,"+name+",despawned from going off screen")
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("player,"+name+",despawned from hitting:"+body.name)
	queue_free()
