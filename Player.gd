extends Area2D
signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400
var screen_size




# Called when the node enters the scene tree for the first time.
func _ready():
	self.screen_size = get_viewport_rect().size
	.hide();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if (Input.is_action_pressed("move_up")):
		velocity.y -= 1
	if (Input.is_action_pressed("move_down")):
		velocity.y += 1
	if (Input.is_action_pressed("move_left")):
		velocity.x -= 1
	if (Input.is_action_pressed("move_right")):
		velocity.x += 1
	
	if (velocity.length() > 0 ):
		velocity = velocity.normalized() * speed
		$PlayerAnimatedSprite.play()
	else:
		$PlayerAnimatedSprite.stop()
		$PlayerAnimatedSprite.frame = 0
		
	if (velocity.x != 0):
		$PlayerAnimatedSprite.animation = "walk"
		$PlayerAnimatedSprite.flip_v = false
		$PlayerAnimatedSprite.flip_h = velocity.x < 0
		get_node("/root/Main/WalkingSound").play()
		
	elif (velocity.y != 0):
		$PlayerAnimatedSprite.animation = "up"
		$PlayerAnimatedSprite.flip_v = velocity.y > 0
	else:
		get_node("/root/Main/WalkingSound").stop()
		
		
	position += velocity * delta
	position.x = clamp(position.x,0,screen_size.x)
	position.y = clamp(position.y,0,screen_size.y)


func _on_Player_body_entered(body):
	.hide()
	emit_signal("hit")
	$PlayerCollisionShape2D.set_deferred("disabled", true)

func player_hide(pos):
	position = pos
	hide()
	$PlayerCollisionShape2D.disabled = true


func start(pos):
	position = pos
	show()
	$PlayerCollisionShape2D.disabled = false
	
