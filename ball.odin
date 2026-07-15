package main
import rl "vendor:raylib"
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