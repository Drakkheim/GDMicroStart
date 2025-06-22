extends Node2D

class_name  LevelManager

enum GAME_STATE {Loading,Attract,Starting,Playing,Stopping,GameOver}
const BIGROCK = preload("res://scenes/bigrock.tscn")
const SMALL_ROCK = preload("res://scenes/smallRock.tscn")
const PLAYER_SHIP = preload("res://scenes/playerShip.tscn")
@onready var camera_2d: Camera2D = %Camera2D
@onready var player_spawn: Node2D = %playerSpawn

var state:GAME_STATE = GAME_STATE.Loading
var _current_round:int = 0
@export var total_bullets = 4;
var current_ship:PlayerShip = null
var live_bullets = 0;
var current_round:int:
	get:
		return _current_round
	set(value):
		_current_round = value
		%Round.text = str(value)
var current_rocks = 0
var rocks_in_spawn = 0

var _lives:int
var lives:int:
	get:
		return _lives
	set(value):
		_lives = value
		%Lives.text = str(value)

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
	Globals.level_manager = self
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
			current_round = 0
			lives = 3
			#when done
			change_state(GAME_STATE.Playing)
			pass
		GAME_STATE.Playing:
			#play the game
			check_round()
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
			
## Checks and restarts the current round if no more rocks exist
func check_round():
	if current_rocks < 1: #start new round
		current_round = current_round +1
		print("New Round ", current_round)
		current_rocks = 4 + floor(current_round / 5)
		for x in current_rocks:
			var newRock = BIGROCK.instantiate()
			newRock.current_velocity = Vector2.UP * current_round
			get_parent().add_child(newRock)
	if current_ship == null:
		spawn_ship()
		
func spawn_ship():
	if lives > 0:
		if rocks_in_spawn == 0:
			lives = lives - 1
			current_ship = PLAYER_SHIP.instantiate()
			current_ship.position = %playerSpawn.position
			add_child(current_ship)	
	else:
		change_state(GAME_STATE.Stopping)
		
func destroy_player():
	if current_ship != null:
		current_ship.die();
		lives = lives -1

func destroy_rock(rock:SpaceRock):
	if rock.bDead == false:
		if rock.rock_size == 2:
			score += 5
			for x in 2:
				var newRock = SMALL_ROCK.instantiate()
				newRock.position = rock.position
				newRock.current_velocity = rock.current_velocity
				call_deferred("add_child", newRock) 
				current_rocks = current_rocks + 1
		if rock.rock_size == 1:
			score += 10;
		rock.die()
		current_rocks = current_rocks - 1
	
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


func _on_safe_spawn_area_area_entered(area: Area2D) -> void:
	rocks_in_spawn += 1


func _on_safe_spawn_area_area_exited(area: Area2D) -> void:
	rocks_in_spawn -= 1
