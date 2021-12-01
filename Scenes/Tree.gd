extends Spatial

func _ready():
	
	randomize()
	
	var TreeSprite = int(round(rand_range(0, 2)))
	
	match(TreeSprite):
		
		_:
			
			$Sprite3D.texture = preload("res://Tree A.png")
			
		0:
			
			$Sprite3D.texture = preload("res://Tree A.png")
			
		1:
			
			$Sprite3D.texture = preload("res://Tree B.png")
			
		2:
			
			$Sprite3D.texture = preload("res://Tree C.png")
			
	pass
