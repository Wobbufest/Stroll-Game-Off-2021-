extends KinematicBody

export(NodePath) var Target

onready var MovementDirection = Vector3(0, 0, 0)

func MovementHandler():
	
	var Direction = self.transform.basis.z.linear_interpolate((get_node(Target).transform.origin - self.transform.origin).normalized(), get_physics_process_delta_time() * 1.5).normalized()
	
	self.transform.basis.z = Direction.normalized()
	self.transform.basis.x = Direction.cross(Vector3(0, 1, 0)).normalized()
	self.transform.basis.y = self.transform.basis.x.cross(self.transform.basis.z).normalized()
	
	MovementDirection = Vector3(0, 0, 0)
	
	MovementDirection += self.transform.basis.z
	
	if($Sensors/Forward.get_collider() != null):
		
		MovementDirection.y = -1
		
	else:
		
		if(self.transform.origin.y < 0):
			
			MovementDirection.y = 1
			
		else:
			
			MovementDirection.y = 0
			self.transform.origin.y = 0
			
	self.move_and_slide(MovementDirection * 2, Vector3(0, 1, 0))
	
	pass
	
func _physics_process(delta):
	
	MovementHandler()
	
	pass
