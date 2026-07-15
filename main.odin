package main


import "core:fmt"

import rl "vendor:raylib"



ball : Ball
p1Paddle := Paddle{}
p2Paddle := Paddle{}
paddles : [2]Paddle


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
        update_ball_timer()

        for &paddle in paddles {
        	paddle_update(&paddle)
         	if collide_ball_with_paddle(&ball, &paddle){
          		ball_bounce_x(&ball)
          	}
        }
        ball_check_wall_collisions(&ball)
        ball_update(&ball, rl.GetFrameTime())

        draw()

    }
}


init_game :: proc(){
	width := f32(rl.GetScreenWidth())
    height := f32(rl.GetScreenHeight())
	ball = ball_init({width/2, height/2})
	p1Paddle = paddle_init(start_pos = {PADDLE_DISTANCE_FROM_WALL, height/2}, paddleControls = {upKey=rl.KeyboardKey.W, downKey=rl.KeyboardKey.S})
	p2Paddle = paddle_init(start_pos = {width - PADDLE_DISTANCE_FROM_WALL, height/2}, paddleControls = {upKey=rl.KeyboardKey.UP, downKey=rl.KeyboardKey.DOWN})
	paddles = [2]Paddle{p1Paddle, p2Paddle}

	ball_start_delayed(&ball)
}

draw :: proc(){
	 // 3. Draw Section
    rl.BeginDrawing()
    rl.ClearBackground(rl.Color{51, 76, 76, 255}) // Dark slate gray

    // Screen dimentions
    width := f32(rl.GetScreenWidth())
    height := f32(rl.GetScreenHeight())

    for &paddle in paddles{
    	p_x := paddle.pos.x
	    p_y := paddle.pos.y + paddle.y_offset

	    rl.DrawRectangle(i32(p_x), i32(p_y), i32(paddle.size.x), i32(paddle.size.y), paddle.color)

    }


	rl.DrawCircle(i32(ball.pos.x), i32(ball.pos.y), ball.radius, rl.WHITE)

    rl.EndDrawing()
}



