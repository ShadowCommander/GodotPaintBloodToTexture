extends Area2D

var is_colliding = false

var vspeed = randf_range(-5.0, 5.0)
var hspeed = randf_range(-3.0, 3.0)

var blood_acc = randf_range(0.05, 0.1)


var do_wobble = false

var max_count = randi_range(5, 50)
var count = 0

func _physics_process(delta: float) -> void:
	if (!is_colliding): # In the air
		do_wobble = false
		vspeed = lerp(vspeed, 5.0, 0.02)
		hspeed = lerp(hspeed, 0.0, 0.02)
		visible = true
		
	else: # Touching platform
		Surface.draw_blood(position) # Draw blood to surface
		
		# Count increase until max_count, then delete
		count += 1
		if (count > max_count):
			queue_free()
		
		# We make sure blood drop faster than 3, slowly reduce speed
		if (vspeed > 3):
			vspeed = 3.0
		vspeed = lerp(vspeed, 0.1, blood_acc)
		
		#If we're moving downwards in a line, add wobble
		if (hspeed > 0.1 or hspeed < -0.1):
			hspeed = lerp(hspeed, 0.0, 0.1)
		else:
			do_wobble = true

		visible = false
		
	# We add random wobble when moving downwards to avoid straight lines
	if (do_wobble):
		hspeed += randf_range(-0.01, 0.01)
		hspeed = clamp(hspeed, -0.1, 0.1)
		
	# Update our position based on the vspeed and hspeed
	position.y += vspeed
	position.x += hspeed
	
	# Delete this object if it left the screen downwards
	if (position.y > 1000):
		queue_free()

func _on_blood_body_entered(body: Node) -> void:
	is_colliding = true
	pass # Replace with function body.


func _on_blood_body_exited(body: Node) -> void:
	is_colliding = false
	pass # Replace with function body.
