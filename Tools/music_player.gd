extends Control

var playback # Will hold the AudioStreamGeneratorPlayback.
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer
var pulse_hz = 440.0 # The frequency of the sound wave.
var phase = 0.0

func _ready():
	audio_player.play()
