package main


import "core:fmt"

import rl "vendor:raylib"

SCREEN_WIDTH :: 512
SCREEN_HEIGHT :: 512
CAMERA_ZOOM :: 0.90

ball : Ball
p1Paddle := Paddle{}
p2Paddle := Paddle{}
paddles : [2]Paddle

// 1. Les filen inn under kompilering (relativ sti fra der main.odin ligger)
CRT_SHADER_SOURCE :: #load("shaders/frag/crt.fs", string)


main :: proc() {
    // 1. Initialize Window & Context
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Odin Pong - Raylib")
    defer rl.CloseWindow()

    fs_render_texture := rl.LoadRenderTexture(SCREEN_WIDTH,SCREEN_HEIGHT)
    defer rl.UnloadRenderTexture(fs_render_texture)

    fs_shader := rl.LoadShaderFromMemory(nil, cstring(raw_data(CRT_SHADER_SOURCE)))
    defer rl.UnloadShader(fs_shader)

    // Locate the "uTime" variable inside the loaded GLSL code
    time_loc := rl.GetShaderLocation(fs_shader, "uTime")

    // 1. Setup a Camera to scale down your game contents
    // A zoom of 0.90 provides a 10% safety margin around the screen
    camera := rl.Camera2D{
        target   = {f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}, // Target center of your game world
        offset   = {f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}, // Anchor to center of screen
        rotation = 0.0,
        zoom     = 0.90, 
    }
    
    rl.SetTargetFPS(60)

    init_game()


    // 2. Main Game Loop
    for !rl.WindowShouldClose() {
        // Update logic (like checking keys)
        if rl.IsKeyDown(.ESCAPE) {
            break
        }

        // Update time tracking variable
        total_time := f32(rl.GetTime())

        // Send the updated float address pointer over to the GPU
        rl.SetShaderValue(fs_shader, time_loc, &total_time, .FLOAT)

        update_ball_timer()

        for &paddle in paddles {
        	paddle_update(&paddle)
         	if collide_ball_with_paddle(&ball, &paddle){
          		ball_bounce_x(&ball)
          	}
        }
        ball_check_wall_collisions(&ball)
        ball_update(&ball, rl.GetFrameTime())

        rl.BeginTextureMode(fs_render_texture)
        	rl.BeginMode2D(camera)
        		draw_game()
          	rl.EndMode2D()
        rl.EndTextureMode()

        rl.BeginDrawing()
        	//Draw to screen
        	rl.ClearBackground(rl.BLACK)
	        rl.BeginShaderMode(fs_shader)
		        source_rec := rl.Rectangle{0,0,f32(fs_render_texture.texture.width),f32(-fs_render_texture.texture.height)}
		        dest_rec := rl.Rectangle{0,0,f32(SCREEN_WIDTH), f32(SCREEN_HEIGHT)}
		        rl.DrawTexturePro(fs_render_texture.texture, source_rec, dest_rec, {0,0}, 0, rl.WHITE)
	        rl.EndShaderMode()
        rl.EndDrawing()
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

draw_game :: proc(){
 	// Screen dimentions
    width := f32(rl.GetScreenWidth())
    height := f32(rl.GetScreenHeight())

    rl.ClearBackground(rl.Color{51, 76, 76, 255}) // Dark slate gray
    // 1. Draw the playable area background (Optional)
    rl.DrawRectangle(0, 0, i32(width), i32(height), rl.DARKBLUE) 

    // 2. Draw the thin white border precisely along your collision bounds
    // Parameters: Rectangle{x, y, width, height}, line_thickness, color
    border_rec := rl.Rectangle{0, 0, f32(width), f32(height)}
    rl.DrawRectangleLinesEx(border_rec, 3.0, rl.RAYWHITE) // 3 pixels thick
    


    for &paddle in paddles{
    	p_x := paddle.pos.x
	    p_y := paddle.pos.y + paddle.y_offset

	    rl.DrawRectangle(i32(p_x), i32(p_y), i32(paddle.size.x), i32(paddle.size.y), paddle.color)

    }


	rl.DrawCircle(i32(ball.pos.x), i32(ball.pos.y), ball.radius, rl.WHITE)
	draw_score_text(score)


}
