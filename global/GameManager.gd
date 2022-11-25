extends Node

signal game_state_change(new_state, previous_state)

var GameWorld = preload("res://levels/GameWorld.tscn")
var MainMenu = preload("res://ui/MainMenu.tscn")
var Hud = preload("res://ui/HUD.tscn")
var current_game_world

enum GameState {MENU, IN_GAME}

var current_state = GameState.MENU

func _ready():
  current_state = GameState.MENU

func change_state(new_state: int) -> void:
  var root = get_tree().root
  var previous_state = current_state
  current_state = new_state

  emit_signal("game_state_change", current_state, previous_state)

  # set up new state
  match current_state:
    GameState.MENU:
      root.add_child(MainMenu.instance())
    GameState.IN_GAME:
      current_game_world = GameWorld.instance()
      root.add_child(current_game_world)
      
      current_game_world.generate()

      root.add_child(Hud.instance())
      

  # cleanup previous state
  match previous_state:
    GameState.MENU:
      root.get_node("MainMenu").queue_free()
      pass
    GameState.IN_GAME:
      root.get_node("GameWorld").queue_free()
      pass
