package main

import "core:fmt"
import rl "vendor:raylib"

PADDLE_SPEED :: 35

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
	radius: f32
	velocity: rl.Vector2,
}

main :: proc() {
    // 1. Initialize Window & Context
    rl.InitWindow(512, 512, "Odin Pong - Raylib")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)

    // 2. Main Game Loop
    for !rl.WindowShouldClose() {
        // Update logic (like checking keys)
        if rl.IsKeyDown(.ESCAPE) {
            break
        }

        handleInput()
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

draw :: proc(){
	 // 3. Draw Section
    rl.BeginDrawing()
    rl.ClearBackground(rl.Color{51, 76, 76, 255}) // Dark slate gray


    width := f32(rl.GetScreenWidth())
    height := f32(rl.GetScreenHeight())

    p1_x := 30
    p1_y := (height / 2) - (p1Paddle.size.y / 2) + (height / 100 * p1Paddle.y_offset)

    p2_x := width - 30 - p2Paddle.size.x
    p2_y := (height / 2) - (p2Paddle.size.y / 2) + (height / 100 * p2Paddle.y_offset)

    rl.DrawRectangle(i32(p1_x), i32(p1_y), i32(p1Paddle.size.x), i32(p1Paddle.size.y), p1Paddle.color)
	rl.DrawRectangle(i32(p2_x), i32(p2_y), i32(p2Paddle.size.x), i32(p2Paddle.size.y), p2Paddle.color)

    rl.EndDrawing()
}
