extends Area3D
@export var speed = 11
@export var damage = 1
var line_of_fire
func start(pos,the_rotation):
	print( name+" spawned")
	position = pos
	line_of_fire = the_rotation
	line_of_fire -= the_rotation
	line_of_fire -= the_rotation
	rotation.y -= the_rotation
func _process(delta):
	if line_of_fire == null:
		return
	position += Vector3(1,0,0).rotated(Vector3(0,1,0),line_of_fire)*speed*delta
func _on_enemy(area: Area3D) -> void:
	if area.collision_layer == 32:
		print("player "+name+",despawned from hitting:"+area.name)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("player "+name+", despawned from going off screen")
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		return
	print("Enemy "+name+", despawned from hitting:"+body.name)
	queue_free()
