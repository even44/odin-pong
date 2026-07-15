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

        for &paddle in paddles {
        	paddle_update(&paddle)
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
	p1Paddle = paddle_init({PADDLE_DISTANCE_FROM_WALL, height/2})
	p2Paddle = paddle_init({width - PADDLE_DISTANCE_FROM_WALL, height/2})
	paddles = [2]Paddle{p1Paddle, p2Paddle}
}

draw :: proc(){
	 // 3. Draw Section
    rl.BeginDrawing()
    rl.ClearBackground(rl.Color{51, 76, 76, 255}) // Dark slate gray

    // Screen dimentions
    width := f32(rl.GetScreenWidth())
    height := f32(rl.GetScreenHeight())
    
    for &paddle in paddles{
    	fmt.println(&paddle)
    	p_x := paddle.pos.x
	    p_y := paddle.pos.y + paddle.y_offset
	
	    rl.DrawRectangle(i32(p_x), i32(p_y), i32(paddle.size.x), i32(paddle.size.y), paddle.color)
		
    }
    
    
	

	rl.DrawCircle(i32(ball.pos.x), i32(ball.pos.y), ball.radius, rl.WHITE)


    rl.EndDrawing()
}
