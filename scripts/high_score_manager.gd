extends Node
class_name high_score_manager

var save_path = "user://score.save"

@export var high_score:int = 0
@export var high_player:String = " * * *"
func _ready() -> void:
	print(OS.get_data_dir())
	pass
	
## Submit a new high score and Save it if it is a new high score
func submit_high_score(new_score : int, player_name: String)->bool:
	if (new_score > high_score):
		high_score = new_score
		high_player = player_name
	
		save_score()
		return true
	return false
		
## Save the highscore to the default saveFile
func save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	print("Saving",high_score)
	file.store_var(high_score)
	print("Saving",high_player)
	file.store_var(high_player) 
	
	file.close()
	
## Load the high score / Create if not found
func load_score():
	high_score = 0
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		high_score = file.get_var()
		print("loading",high_score)
		high_player = file.get_var() 
		file.close()
	else:
		save_score()
	return high_score
