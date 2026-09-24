extends StaticBody3D

@export var KillAmount:int=-1
@onready var audio_open: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("KillGateLoaded")



func _on_enemy_kill() -> void:
	KillAmount-=1
	print(KillAmount)
	if KillAmount<=0:
		print("KillGateOpen")
		audio_open.play()
		await audio_open.finished
		queue_free()
