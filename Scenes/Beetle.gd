extends Spatial

onready var State = "Charging"
export(float) var Speed = 4

func _ready():
	
	$Mesh/AnimationPlayer.play("Standing")
	
	pass
	
func MovementHandler():
	
	if(State == "Charging"):
		
		self.transform.origin += self.transform.basis.z * (-Speed * get_physics_process_delta_time())
		
	pass
	
func TurnAround():
	
	self.rotate(Vector3(0, 1, 0), deg2rad(180))
	State = "Charging"
	$RayCast.force_raycast_update()
	
	pass
	
func BehaviorHandler():
	
	if(State == "Charging" && $RayCast.get_collider() != null):
		
		State = "Turning"
		
	for Body in $Area.get_overlapping_bodies():
		
		if(Body.is_in_group("Player")):
			
			Body.Die()
			
	pass
	
func AnimationHandler():
	
	if(State == "Charging"):
		
		$AnimationPlayer.play("Charge")
		$Mesh/AnimationPlayer.play("Charging")
		
	if(State == "Turning"):
		
		$AnimationPlayer.play("Turn", 0, floor(Speed / 2) + 1)
		$Mesh/AnimationPlayer.play("Standing")
		
	pass
	
func _process(delta):
	
	BehaviorHandler()
	AnimationHandler()
	$AnimationPlayer.advance(delta)
	
	pass
	
func _physics_process(delta):
	
	MovementHandler()
	print($Mesh.rotation_degrees)
	
	pass
