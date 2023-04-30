extends CharacterBody2D


const SPEED = 850.0
const JUMP_VELOCITY = -1200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready
var anim_player : AnimationPlayer = $AnimationPlayer

@onready
var sprite : Sprite2D = $Body

func _physics_process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		anim_player.play("idle")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		anim_player.play("jump")

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x < 0 and sprite.scale.x > 0:
			sprite.scale.x *= -1
		if velocity.x > 0 and sprite.scale.x < 0:
			sprite.scale.x *= -1
		
		if is_on_floor():
			anim_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
