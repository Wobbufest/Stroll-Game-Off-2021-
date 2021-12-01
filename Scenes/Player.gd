extends KinematicBody

onready var UpPressed = false
onready var DownPressed = false
onready var LeftPressed = false
onready var RightPressed = false
onready var ZPressed = false
onready var XPressed = false

onready var Busy = false

onready var SpriteDirections = [
	
	Vector3(0, 0, 1).normalized(),
	Vector3(1, 0, 1).normalized(),
	Vector3(1, 0, 0).normalized(),
	Vector3(1, 0, -1).normalized(),
	Vector3(0, 0, -1).normalized(),
	Vector3(-1, 0, -1).normalized(),
	Vector3(-1, 0, 0).normalized(),
	Vector3(-1, 0, 1).normalized()
	
]

onready var AnimationDirection = "(North)"

onready var LeftPressing = false
onready var RightPressing = false

onready var PlayerSpeed = Vector3(0, 0, 0)
onready var MovementDirection = Vector3(0, 1, 0)
onready var RotationSpeed = 1.25
onready var MovementSpeed = 2

func _input(event):
	
	if(event is InputEventKey):
		
		match(event.scancode):
			
			KEY_Z:
				
				if(event.is_pressed()):
					
					ZPressed = true
					
				else:
					
					ZPressed = false
					
			KEY_X:
				
				if(event.is_pressed()):
					
					XPressed = true
					
				else:
					
					XPressed = false
					
			KEY_UP:
				
				if(event.is_pressed()):
					
					UpPressed = true
					
				else:
					
					UpPressed = false
					
			KEY_DOWN:
				
				if(event.is_pressed()):
					
					DownPressed = true
					
				else:
					
					DownPressed = false
					
			KEY_LEFT:
				
				if(event.is_pressed()):
					
					LeftPressed = true
					
				else:
					
					LeftPressed = false
					LeftPressing = false
					
			KEY_RIGHT:
				
				if(event.is_pressed()):
					
					RightPressed = true
					
				else:
					
					RightPressed = false
					RightPressing = false
					
	pass
	
func MovementHandler():
	
	var CurrentVelocity = Vector3(0, 0, 0)
	
	if(!ZPressed):
		
		$"Direction Pivot".rotate(Vector3(0, 1, 0), (deg2rad(RotationSpeed) * int(LeftPressed)) + (deg2rad(-RotationSpeed) * int(RightPressed)))
		
		CurrentVelocity += -($"Direction Pivot".transform.basis.z * int(UpPressed))
		
		MovementDirection = MovementDirection.linear_interpolate(CurrentVelocity, get_physics_process_delta_time() * 2)
		MovementDirection.y = 0
		
		self.move_and_slide(MovementDirection * MovementSpeed, Vector3(0, 1, 0))
		PlayerSpeed = MovementDirection * MovementSpeed
		
	else:
		
		if(XPressed):
			
			
			if(LeftPressed && !LeftPressing):
				
				$"Direction Pivot".rotate(Vector3(0, 1, 0), deg2rad(90))
				LeftPressing = true
				
			if(RightPressed && !RightPressing):
				
				$"Direction Pivot".rotate(Vector3(0, 1, 0), deg2rad(-90))
				RightPressing = true
				
		else:
			
			$"Direction Pivot".rotate(Vector3(0, 1, 0), (deg2rad(RotationSpeed) * int(LeftPressed)) + (deg2rad(-RotationSpeed) * int(RightPressed)))
			
		CurrentVelocity += -($"Direction Pivot".transform.basis.z * int(UpPressed))
		
		MovementDirection = MovementDirection.linear_interpolate(CurrentVelocity, get_physics_process_delta_time() * 2)
		MovementDirection.y = 0
		
		self.move_and_slide(MovementDirection * (MovementSpeed * 2), Vector3(0, 1, 0))
		PlayerSpeed = MovementDirection * (MovementSpeed * 2)
		
	$"Flashlight Pivot".transform = $"Flashlight Pivot".transform.interpolate_with($"Direction Pivot".transform, get_physics_process_delta_time() * 2)
	
	pass
	
func SpriteHandler():
	
	var Closest = 0
	var ClosestValue = 0
	
	for Direction in SpriteDirections:
		
		if($"Direction Pivot".transform.basis.z.dot(SpriteDirections[SpriteDirections.find(Direction)]) >= ClosestValue):
			
			Closest = SpriteDirections.find(Direction)
			ClosestValue = $"Direction Pivot".transform.basis.z.dot(SpriteDirections[SpriteDirections.find(Direction)])
			
	
	match(Closest):
		
		0:
			
			AnimationDirection = "(North)"
			$AnimatedSprite3D.flip_h = false
			
		1:
			
			AnimationDirection = "(Northeast)"
			$AnimatedSprite3D.flip_h = false
			
		2:
			
			AnimationDirection = "(East)"
			$AnimatedSprite3D.flip_h = false
			
		3:
			
			AnimationDirection = "(Southeast)"
			$AnimatedSprite3D.flip_h = false
			
		4:
			
			AnimationDirection = "(South)"
			$AnimatedSprite3D.flip_h = false
			 
		5:
			
			AnimationDirection = "(Southeast)"
			$AnimatedSprite3D.flip_h = true
			
		6:
			
			AnimationDirection = "(East)"
			$AnimatedSprite3D.flip_h = true
			
		7:
			
			AnimationDirection = "(Northeast)"
			$AnimatedSprite3D.flip_h = true
			
	pass
	
func AnimationHandler():
	
	if(PlayerSpeed.length() > 0.1):
		
		if(PlayerSpeed.length() > 2):
			
			$AnimatedSprite3D.animation = "Running " + AnimationDirection
			
			if($"Footstep Running Sounds".playing == false):
				
				$"Footstep Running Sounds".play()
				
			$"Footstep Walking Sounds".stop()
			
		else:
			
			$AnimatedSprite3D.animation = "Walking " + AnimationDirection
			
			if($"Footstep Walking Sounds".playing == false):
				
				$"Footstep Walking Sounds".play()
				
			$"Footstep Running Sounds".stop()
			
	else:
		
		$AnimatedSprite3D.animation = "Idle " + AnimationDirection
		$"Footstep Walking Sounds".stop()
		$"Footstep Running Sounds".stop()
		
	pass
	
func Die():
	
	$AnimationPlayer.play("Die")
	Busy = true
	$"Footstep Running Sounds".stop()
	$"Footstep Walking Sounds".stop()
	
	pass
	
func _ready():
	
	$Blood.visible = false
	$"Blood Particles".emitting = false
	
	pass
	
func _physics_process(delta):
	
	if(!Busy):
		
		MovementHandler()
		SpriteHandler()
		AnimationHandler()
		
	pass
