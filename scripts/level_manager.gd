extends Node2D

class_name  LevelManager
enum GAME_STATE {Loading,Attract,Starting,Playing,Stopping,GameOver}

var state:GAME_STATE = GAME_STATE.Loading

var _score:int = 0
var score:int :
	get:
		return _score
	set(value):
		_score = value
		%CurrentScoreLabel.text = str(value)

func _ready() -> void:
	%Loading.show()
	%LoadingCL.show()
	%Attract.hide()
	%AttractCL.hide()
	%Playing.hide()
	%PlayingCL.hide()
	%GameOver.hide();
	%GameOverCL.hide();
	pass

## Handles the UI flipping and sets State 
func change_state(new_state:GAME_STATE):
	match state:
		GAME_STATE.Loading:
			%Loading.hide()
			%LoadingCL.hide()
		GAME_STATE.Attract:
			%Attract.hide()
			%AttractCL.hide()
		GAME_STATE.Playing:
			%Playing.hide()
			%PlayingCL.hide()
		GAME_STATE.GameOver:
			%GameOver.hide();
			%GameOverCL.hide();
	
	state = new_state
	
	match new_state:
		GAME_STATE.Loading:
			%Loading.show()
			%LoadingCL.show()
		GAME_STATE.Attract:
			%Attract.show()
			%AttractCL.show()
		GAME_STATE.Playing:
			%Playing.show()
			%PlayingCL.show()
		GAME_STATE.GameOver:
			%GameOver.show();
			%GameOverCL.show();
	pass

func _process(delta: float) -> void:
	# do different things based on what state the game is in.
	match state:
		GAME_STATE.Loading:			
			HighScoreManager.load_score()
			%HighScore.text = str(HighScoreManager.high_score)
			%HighScorePlayer.text = HighScoreManager.high_player
			#Handle Loading any assets needed here
			#When done Move to Attract Mode
			change_state(GAME_STATE.Attract)
			pass
		GAME_STATE.Attract:
			#Do any fancy main menu attract mode stuff
			pass
		GAME_STATE.Starting:
			#do prepare to play a round
			score = 0
			#when done
			change_state(GAME_STATE.Playing)
			pass
		GAME_STATE.Playing:
			#play the game
			pass
		GAME_STATE.Stopping:
			#clean up the game and prep the Game over UI
			%LastRoundScoreLabel.text = str(score)
			if score > HighScoreManager.high_score:
				%UpdateHighScore.show()
			else:
				%UpdateHighScore.hide()
			#when done
			change_state(GAME_STATE.GameOver)
			pass
		GAME_STATE.GameOver:
			#show and submit high score.
			pass
			
## This function can be used to increment/decrement score
func change_score(score_change: int) -> void:
	score = score + score_change
	
## This function submits and saves the current highscore and player
func update_initials() -> void:
	HighScoreManager.submit_high_score(score,%myInitials.text) 

## Use this to end the game
func end_game() -> void:
	change_state(GAME_STATE.Stopping)

## Handlers

func _on_game_over_done_button_pressed() -> void:
	HighScoreManager.load_score()
	%HighScore.text = str(HighScoreManager.high_score)
	%HighScorePlayer.text = HighScoreManager.high_player
	change_state(GAME_STATE.Attract) 


func _on_play_button_pressed() -> void:
	change_state(GAME_STATE.Starting)
