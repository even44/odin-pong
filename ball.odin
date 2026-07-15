package main

import "core:fmt"
import rl "vendor:raylib"
import "core:math/rand"

ball_active: bool
ball_current_time: f64
ball_start_trigger_time: f64
ball_timer_active: bool
BALL_START_DELAY: f64 = 2
BALL_INITIAL_SPEED: f32 = 300
BALL_STEER_FORCE: f32 = .3



Ball :: struct {
	pos: rl.Vector2,
	velocity: rl.Vector2,
	radius: f32,
	speed: f32,
}

ball_init :: proc(start_pos: rl.Vector2) -> Ball {
	return Ball {
		pos = start_pos,
		velocity = {0,0},
		radius = 8.0,
		speed = BALL_INITIAL_SPEED,
	}
}

ball_update :: proc(ball: ^Ball, dt: f32){
	if ball.velocity != rl.Vector2(0){
		ball.pos += rl.Vector2Normalize(ball.velocity) * ball.speed * dt
	}
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
		reset_and_stop_ball(ball)
		ball_start_delayed(ball)
	}
	else if ball.pos.x + ball.radius >= screen_width {
		ball.pos.x = screen_width - ball.radius
		reset_and_stop_ball(ball)
		ball_start_delayed(ball)
	}
}

ball_bounce_y :: proc(ball: ^Ball){
	ball.velocity.y = -ball.velocity.y
}

ball_bounce_x :: proc(ball: ^Ball){
	ball.velocity.x = -ball.velocity.x
	ball.speed *= 1.05
}

ball_start :: proc(ball: ^Ball){
	
	ball.velocity = rl.Vector2Normalize(
		rl.Vector2{
			f32(sign_function((rand.float32() - .5))), 
			rl.Clamp(2* (rand.float32() -.5), -1, 1)
		})
}


sign_function :: proc(x: f32) -> int {
    if x > 0.0 { return 1; }
    if x < 0.0 { return -1; }
    return 0; // Handles zero and anything else
}

ball_start_delayed :: proc(ball: ^Ball)
{
	ball_start_trigger_time = rl.GetTime()
	ball_timer_active = true
}

update_ball_timer :: proc(){
	if ball_timer_active && ball_current_time - ball_start_trigger_time < BALL_START_DELAY {
		ball_current_time = rl.GetTime()

	} else if (ball_timer_active) {
		ball_start(&ball)
		ball_timer_active = false
	}
}

reset_and_stop_ball :: proc(ball: ^Ball){
	width := f32(rl.GetScreenWidth())
    height := f32(rl.GetScreenHeight())
	ball.pos = {width/2, height/2}
	ball.velocity = {0,0}
	ball.speed = BALL_INITIAL_SPEED
}

collide_ball_with_paddle :: proc(ball: ^Ball, paddle: ^Paddle) -> bool{
	points := paddle_get_boundry_points(paddle)

	min_x := points[0].x
	max_x := points[1].x
	min_y := points[0].y
	max_y := points[2].y

	paddle_height := max_y - min_y

    closest_x := rl.Clamp(ball.pos.x, min_x, max_x)
    closest_y := rl.Clamp(ball.pos.y, min_y, max_y)

    nearest_point := rl.Vector2{closest_x, closest_y}

    distance := rl.Vector2Distance(nearest_point, ball.pos)

    if distance < ball.radius {

    	//Calculate where on the paddle it hit in a position from 0-1
     	impactFactor := (2.0 * (nearest_point.y - min_y)) / (max_y - min_y) -1.0
      	fmt.printfln("Impact Factor: %f", impactFactor)
        ball.velocity.y += impactFactor * BALL_STEER_FORCE
        ball.velocity = rl.Vector2Normalize(ball.velocity)

        overlap := ball.radius - distance
        direction_vec := rl.Vector2Normalize(rl.Vector2{ball.pos.x - nearest_point.x, ball.pos.y - nearest_point.y})
        
        ball.pos += direction_vec * overlap * 1.05 // Push out slightly more than the overlap amount
        return true
    }
    return false
}
