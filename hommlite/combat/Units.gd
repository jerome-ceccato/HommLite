extends Node2D

var left_army: Army
var right_army: Army

var hex_size: HexCoords

func setup_armies(left: Army, right: Army, map_size: HexCoords):
	left_army = left
	right_army = right
	hex_size = map_size
	
	create_sprites(left, false)
	create_sprites(right, true)

func create_sprites(army: Army, right: bool):
	for i in range(army.stacks.size()):
		var stack = army.stacks[i]
		var y = i + 1
		var x = 0 if !right else (hex_size.x - 1 if y % 2 else hex_size.x)
		stack.sprite = make_unit(stack.unit.texture, right)
		stack.position = HexCoords.new(x, y)

func make_unit(texture: Texture, right: bool) -> Sprite:
	var sprite := Sprite.new()
	sprite.texture = texture
	sprite.flip_h = right
	sprite.scale = Vector2(1.5, 1.5)
	sprite.offset = Vector2(0, -8)
	add_child(sprite)
	return sprite
