extends CharacterBody2D


const SPEED = 850.0
const JUMP_VELOCITY = -1260.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Body
@onready var flowers_sprite = %Flowers
@onready var mushrooms_sprite = %Mushrooms
@onready var audio_walk : AudioStreamPlayer = $AudioWalk
@onready var audio_jump : AudioStreamPlayer = $AudioJump

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	GameManager.connect("deliver_flowers_activated", _on_deliver_flowers_activated)
	GameManager.connect("deliver_mushrooms_activated", _on_deliver_mushrooms_activated)

func _physics_process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		anim_player.play("idle")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		anim_player.play("jump")

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if !audio_jump.playing:
			audio_jump.pitch_scale = rng.randf_range(0.85, 1.15)
			audio_jump.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.scale.x = sign(velocity.x)
		if is_on_floor() and not is_on_wall():
			anim_player.play("run")
			if !audio_walk.playing:
				audio_walk.pitch_scale = rng.randf_range(0.85, 1.15)
				audio_walk.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_deliver_flowers_activated() -> void:
	flowers_sprite.scale = Vector2()
	flowers_sprite.show()
	var tween = create_tween()
	tween.tween_property(flowers_sprite, "scale", Vector2(1, 1), 0.6).set_trans(Tween.TRANS_ELASTIC)
	audio_jump.pitch_scale = 2
	audio_jump.play()

func _on_deliver_mushrooms_activated() -> void:
	mushrooms_sprite.scale = Vector2()
	mushrooms_sprite.show()
	var tween = create_tween()
	tween.tween_property(mushrooms_sprite, "scale", Vector2(1, 1), 0.6).set_trans(Tween.TRANS_ELASTIC)
	audio_jump.pitch_scale = 2
	audio_jump.play()

func hide_flowers() -> void:
	flowers_sprite.hide()

func hide_mushrooms() -> void:
	mushrooms_sprite.hide()
