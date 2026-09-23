extends Control

var playback # Will hold the AudioStreamGeneratorPlayback.
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer
@export var music_notes = {"pitch":[],"the silence between the notes":[]}
@export var playmode:int
var playdir = 1
var current_note:int = 0
var done:bool = true
var music_length:int
func _ready():
	music_length = music_notes["pitch"].size()-1
	print("Music length:"+str(music_length))

func _physics_process(delta: float) -> void:
	if done==true:
		print("Current Note:"+str(current_note))
		play_note(music_notes["pitch"][current_note],music_notes["the silence between the notes"][current_note]*delta)
		current_note +=playdir
		match playmode:
			0:
				if current_note > music_length:
					current_note = 0
			1:
				if current_note > music_length-1:
					playdir = -1
				elif current_note <1:
					playdir = 1

func play_note(pitch,time):
	done = false
	audio_player.pitch_scale = pitch
	timer.wait_time = time
	timer.start()
	audio_player.play()


func _on_timer_timeout() -> void:
	done=true
