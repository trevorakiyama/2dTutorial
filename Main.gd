extends Node

export(PackedScene) var mob_scene
var score



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$DeathSound.play()
	fade_out($Music, 5)
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	
	.get_tree().call_group("mobs", "queue_free")
	$Music.volume_db = 0
	start_music($Music)
	


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_MobTimer_timeout():
	var mob = (mob_scene.instance() as Mob)
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.offset = randi()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += rand_range(-PI /4, PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(150.0,250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
	
	
func fade_out(stream_player: AudioStreamPlayer, transition_duration : float):
	var tween = get_node("Tween")

	tween.interpolate_property(stream_player, "volume_db", 0, -80, transition_duration, Tween.TRANS_QUAD, Tween.EASE_IN,0)
	tween.start();

func start_music(stream_player: AudioStreamPlayer):
	var tween = get_node("Tween")
	tween.remove(stream_player)
	stream_player.volume_db = 0;
	stream_player.play()
	

func _on_Tween_tween_completed(object, key):
	object.stop()
