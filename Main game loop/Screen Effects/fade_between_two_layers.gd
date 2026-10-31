extends Node3D

@export var layerShown:GridMap
@export var layerHidden:GridMap
@export var fadeTime:float=1
var start:=false
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start==false:
		return


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("%s son of %s" % [area.name,area.get_parent().name])
	tween()

func tween():
	if start ==true:
		return
	if start==false:
		var tween = get_tree().create_tween()
		tween.tween_property(layerHidden,"cell_scale",0.01,fadeTime)
		await tween.finished
		layerHidden.hide()
		tween.kill()
		start = true
