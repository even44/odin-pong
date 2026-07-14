package main

import "core:sys/darwin/CoreFoundation"
import "core:fmt"
import rl "vendor:raylib"

PADDLE_SPEED :: 35
PADDLE_DISTANCE_FROM_WALL :: 30

ball : Ball

Paddle :: struct {
	y_offset : f32,
	size: rl.Vector2,
	color: rl.Color,
}
p1Paddle := Paddle {
	0,
	{16,128},
	rl.Color{255,255,255,255}
}

p2Paddle := Paddle {
	0,
	{16,128},
	rl.Color{255,255,255,255}
}

Ball :: struct {
	pos: rl.Vector2,
	velocity: rl.Vector2,
	radius: f32,
	speed: f32,
}

ball_init :: proc(start_pos: rl.Vector2) -> Ball {
	return Ball {
		pos = start_pos,
		velocity = rl.Vector2Normalize(rl.Vector2{1.0, 0.5}),
		radius = 8.0,
		speed = 300,
	}
}

ball_update :: proc(ball: ^Ball, dt: f32){
	ball.pos += rl.Vector2Normalize(ball.velocity) * ball.speed * dt	
}

ball_check_wall_collisions :: proc(ball: ^Ball){
	screen_height := f32(rl.GetScreenHeight())
	screen_width := f32(rl.GetScreenWidth())
	
	if ball.pos.y - ball.radius <= 0 {
		ball.pos.y = ball.radius
		ball_bounce_y(ball)
	}
	else if ball.pos.y + ball.radius >= screen_height {
		ball.pos.y = screen_height - ball.radius
		ball_bounce_y(ball)
	}

	if ball.pos.x - ball.radius <= 0 {
		ball.pos.x = ball.radius
		ball_bounce_x(ball)
	}
	else if ball.pos.x + ball.radius >= screen_width {
		ball.pos.x = screen_width - ball.radius
		ball_bounce_x(ball)
	}
}

ball_bounce_y :: proc(ball: ^Ball){
	ball.velocity.y = -ball.velocity.y
}

ball_bounce_x :: proc(ball: ^Ball){
	ball.velocity.x = -ball.velocity.x
	ball.speed *= 1.05
}

main :: proc() {
    // 1. Initialize Window & Context
    rl.InitWindow(512, 512, "Odin Pong - Raylib")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)
    
    init_game()
    

    // 2. Main Game Loop
    for !rl.WindowShouldClose() {
        // Update logic (like checking keys)
        if rl.IsKeyDown(.ESCAPE) {
            break
        }

        handleInput()
        ball_check_wall_collisions(&ball)
        ball_update(&ball, rl.GetFrameTime())
        fmt.println(ball.pos)
        draw()

    }
}


handleInput :: proc(){
	height := rl.GetScreenHeight()

	maxPaddleOffset := .5 - (p1Paddle.size.y / (2 * f32(height)))
	maxPaddleOffset *= 100

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

init_game :: proc(){
	width := f32(rl.GetScreenWidth())
    height := f32(rl.GetScreenHeight())
	ball = ball_init({height/2, width/2})
}

draw :: proc(){
	 // 3. Draw Section
    rl.BeginDrawing()
    rl.ClearBackground(rl.Color{51, 76, 76, 255}) // Dark slate gray

    // Screen dimentions
    width := f32(rl.GetScreenWidth())
    height := f32(rl.GetScreenHeight())

    p1_x := PADDLE_DISTANCE_FROM_WALL
    p1_y := (height / 2) - (p1Paddle.size.y / 2) + (height / 100 * p1Paddle.y_offset)

    // Right size
    p2_x := width - PADDLE_DISTANCE_FROM_WALL - p2Paddle.size.x
    p2_y := (height / 2) - (p2Paddle.size.y / 2) + (height / 100 * p2Paddle.y_offset)

    rl.DrawRectangle(i32(p1_x), i32(p1_y), i32(p1Paddle.size.x), i32(p1Paddle.size.y), p1Paddle.color)
	rl.DrawRectangle(i32(p2_x), i32(p2_y), i32(p2Paddle.size.x), i32(p2Paddle.size.y), p2Paddle.color)

	rl.DrawCircle(i32(ball.pos.x), i32(ball.pos.y), ball.radius, rl.WHITE)


    rl.EndDrawing()
}
