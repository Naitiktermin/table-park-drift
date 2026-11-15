extends CharacterBody2D
@export var max_speed: float = 1000.0
@export var acceleration: float = 900.0
@export var steer_speed: float = 3.6
var spin_speed: float = 0.0
var bounce_timer: float = 0.0

func _physics_process(delta):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		return

	if bounce_timer > 0.0:
		bounce_timer -= delta
		rotation += spin_speed * delta
		spin_speed = lerp(spin_speed, 0.0, 3.8 * delta)
		velocity = velocity.move_toward(Vector2.ZERO, 360.0 * delta)
	else:
		var steer = Input.get_axis("ui_left", "ui_right")
		if Input.is_key_pressed(KEY_A): steer -= 1.0
		if Input.is_key_pressed(KEY_D): steer += 1.0
		steer = clamp(steer, -1.0, 1.0)
		rotation += steer * steer_speed * delta

		if Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down"):
			velocity = velocity.move_toward(Vector2.ZERO, 750.0 * delta)
		else:
			velocity += transform.x * acceleration * delta
			velocity = velocity.limit_length(max_speed)

		velocity = transform.x * velocity.length()

	$SmokeLeft.emitting = bounce_timer > 0.0
	$SmokeRight.emitting = bounce_timer > 0.0
	move_and_slide()

	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		var collider = col.get_collider()
		if not collider:
			continue
		if collider.is_in_group("tires") or collider.name.begins_with("Tire"):
			velocity = col.get_normal().rotated(randf_range(-0.3, 0.3)) * 980.0
			spin_speed = randf_range(18.0, 28.0) * (1.0 if randf() > 0.5 else -1.0)
			bounce_timer = 0.46
			if collider.has_method("on_car_hit"):
				collider.on_car_hit(col.get_normal())
			break
		elif collider is RigidBody2D:
			collider.apply_impulse(-col.get_normal() * 400.0)
