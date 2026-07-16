package main

import rl "vendor:raylib"


score: rl.Vector2
TEAM :: enum{
	P1,
	P2
}

draw_score_text :: proc(score: rl.Vector2){
	rl.DrawText(rl.TextFormat("%.0f / %.0f", score.x, score.y), 10, 10 ,20, rl.WHITE)
}

add_point :: proc(team : TEAM){
	switch team{
		case .P1:
			score.x += 1
		case .P2: 
			score.y += 1
	}
}

