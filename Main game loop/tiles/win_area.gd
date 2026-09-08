extends Area2D

@export var Current_level:int
@export var Win_type:int#1 for normal 2 for custom next level
@export var Next_level:int#only works for win type 2

func _on_area_entered(_area: Area2D) -> void:
	if get_parent().get_parent() == null:
		print("win area parent. null")
		return
	get_parent().get_parent()._on_win(Current_level,Win_type,Next_level)
