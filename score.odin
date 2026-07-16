package main

import rl "vendor:raylib"


score: rl.Vector2
TEAM :: enum{
	P1,
	P2
}

draw_score_text :: proc(score: rl.Vector2){
	SCORE_TEXT_FONT_SIZE :: 40
	screenWidth := rl.GetScreenWidth()
	scoreTextFormat := rl.TextFormat("%.0f / %.0f", score.x, score.y)
	textWidth := rl.MeasureText(scoreTextFormat, SCORE_TEXT_FONT_SIZE)
	rl.DrawText(scoreTextFormat, (screenWidth / 2) - (textWidth / 2), 10 ,SCORE_TEXT_FONT_SIZE, rl.WHITE)
}

add_point :: proc(team : TEAM){
	switch team{
		case .P1:
			score.x += 1
		case .P2: 
			score.y += 1
	}
}

