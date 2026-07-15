package main
import rl "vendor:raylib"

PADDLE_SPEED :: 200
PADDLE_DISTANCE_FROM_WALL :: 30


Paddle :: struct {
	pos: rl.Vector2,
	y_offset : f32,
	size: rl.Vector2,
	color: rl.Color,
	paddleControls: PaddleControls
}

PaddleControls :: struct {
	upKey: rl.KeyboardKey,
	downKey: rl.KeyboardKey
}

paddle_init :: proc (start_pos: rl.Vector2, size: rl.Vector2 = {16,128}, paddleControls: PaddleControls = {rl.KeyboardKey.UP,rl.KeyboardKey.DOWN}) -> Paddle {
	return Paddle {
		pos = paddle_get_center_position(start_pos, size),
		y_offset = 0,
		size = size,
		color = rl.WHITE,
		paddleControls = paddleControls
	}
}

paddle_update ::proc (paddle: ^Paddle){
	height := rl.GetScreenHeight()

	maxPaddleOffset := .5 * (f32(height) - paddle.size.y)
	if rl.IsKeyDown(paddle.paddleControls.downKey){
		paddle.y_offset = rl.Clamp(paddle.y_offset + PADDLE_SPEED * rl.GetFrameTime(), -maxPaddleOffset,maxPaddleOffset)
	}
	if rl.IsKeyDown(paddle.paddleControls.upKey){
		paddle.y_offset = rl.Clamp(paddle.y_offset - PADDLE_SPEED * rl.GetFrameTime(), -maxPaddleOffset,maxPaddleOffset)
	}

}

paddle_get_center_position :: proc(pos: rl.Vector2, size: rl.Vector2) -> rl.Vector2{
	x := pos.x - size.x/2
	y := pos.y - size.y/2
	return rl.Vector2{x,y}
}

paddle_get_boundry_points :: proc(paddle: ^Paddle) -> [4]rl.Vector2{
	// Return points from top left clockwise
	return {
		{paddle.pos.x, paddle.pos.y + paddle.y_offset}, //Origin
		{paddle.pos.x + paddle.size.x, paddle.pos.y + paddle.y_offset}, //Origin + x_size
		{paddle.pos.x + paddle.size.x, paddle.pos.y + paddle.size.y + paddle.y_offset}, //Origin + xy_size
		{paddle.pos.x, paddle.pos.y + paddle.size.y + paddle.y_offset}} // Origin + y_size
}

