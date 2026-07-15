package main
import rl "vendor:raylib"

PADDLE_SPEED :: 65
PADDLE_DISTANCE_FROM_WALL :: 30


Paddle :: struct {
	pos: rl.Vector2,
	y_offset : f32,
	size: rl.Vector2,
	color: rl.Color,
}

paddle_init :: proc (start_pos: rl.Vector2, size: rl.Vector2 = {16,128}) -> Paddle {
	return Paddle {
		pos = paddle_get_center_position(start_pos, size),
		y_offset = 0,
		size = size,
		color = rl.WHITE,
	}
}

paddle_update ::proc (paddle: ^Paddle){
	height := rl.GetScreenHeight()

	maxPaddleOffset := .5 * (f32(height) - paddle.size.y)

	if rl.IsKeyDown(rl.KeyboardKey.DOWN){
		p2Paddle.y_offset = rl.Clamp(p2Paddle.y_offset + PADDLE_SPEED * rl.GetFrameTime(), -maxPaddleOffset,maxPaddleOffset)
	}
	if rl.IsKeyDown(rl.KeyboardKey.UP){
		p2Paddle.y_offset = rl.Clamp(p2Paddle.y_offset - PADDLE_SPEED * rl.GetFrameTime(), -maxPaddleOffset,maxPaddleOffset)
	}

	if rl.IsKeyDown(rl.KeyboardKey.S){
		p1Paddle.y_offset = rl.Clamp(p1Paddle.y_offset + PADDLE_SPEED * rl.GetFrameTime(), -maxPaddleOffset,maxPaddleOffset)
	}
	if rl.IsKeyDown(rl.KeyboardKey.W){
		p1Paddle.y_offset = rl.Clamp(p1Paddle.y_offset - PADDLE_SPEED * rl.GetFrameTime(), -maxPaddleOffset,maxPaddleOffset)
	}
}

paddle_get_center_position :: proc(pos: rl.Vector2, size: rl.Vector2) -> rl.Vector2{
	x := pos.x - size.x/2
	y := pos.y - size.y/2
	return rl.Vector2{x,y}
}
