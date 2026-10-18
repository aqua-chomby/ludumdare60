extends CharacterBody2D


@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var win_screen: Control = $"../UIElements/WinScreen"

var coyote_time_activated: bool = false

const jump_height : float = -390.0 # was 230
var gravity : float = 12.0
const max_gravity : float = 14.5

const max_speed : float = 80
const acceleration : float = 8
const friction : float = 10

func _physics_process(delta: float) -> void:
	
	# animation
	if velocity.x < 0.02 and velocity.x > -0.02:
		animated_sprite_2d.play("idle")
	else: animated_sprite_2d.play("run")
	if velocity.x > 0.02:
		animated_sprite_2d.flip_h = false
	if velocity.x < -0.02:
		animated_sprite_2d.flip_h = true
	
	var x_input : float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var velocity_weight : float = delta * (acceleration if x_input else friction)
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)

	if is_on_floor():
		coyote_time_activated = false
		# lerp toward minumum value
		gravity = lerp(gravity, 12.0, 12.0 * delta)
	else:
		if coyote_timer.is_stopped() and !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true
		
		if Input.is_action_just_released("ui_up") or is_on_ceiling(): # don't stick to the ceiling
			velocity.y *= 0.5
			
		gravity = lerp(gravity, max_gravity, 12.0 * delta)
	
	if Input.is_action_just_pressed("ui_up"):
		if jump_buffer_timer.is_stopped():
			jump_buffer_timer.start()
	
	if !jump_buffer_timer.is_stopped() and (!coyote_timer.is_stopped() or is_on_floor()):
		velocity.y = jump_height
		jump_buffer_timer.stop()
		coyote_timer.stop()
		coyote_time_activated = true
		
	# head nudge
	if velocity.y < jump_height/2.0:
		var head_collision : Array = [$LeftHeadNudge.is_colliding(), $LeftHeadNudge2.is_colliding(), $RightHeadNudge3.is_colliding(), $RightHeadNudge4.is_colliding()]
		if head_collision.count(true) == 1:
			if head_collision[0]:
				global_position.x += 1.75
			if head_collision[2]:
				global_position.x -= 1.75
	
	if velocity.y > -30 and velocity.y < -5 and abs(velocity.x) > 3:
		if $LeftLedgehop.is_colliding() and !$LeftLedgehop2.is_colliding() and velocity.x < 0:
			velocity.y += jump_height/3.25
		if $RightLedgehop.is_colliding() and !$RightLedgehop2.is_colliding() and velocity.x < 0:
			velocity.y += jump_height/3.25
				
	velocity.y += gravity
	
	move_and_slide()


func _on_spinning_wheel_body_entered(body: Node2D) -> void:
	if GameState.wool_count >= 3:
		win_screen.show()
