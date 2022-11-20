extends Control

func _on_StartGameButton_pressed():
	GameManager.change_state(GameManager.GameState.IN_GAME)