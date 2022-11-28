extends Node

signal game_state_change(new_state, previous_state)
signal unpaused
signal paused
signal world_generated

export(PackedScene) var game_world
export(PackedScene) var main_menu
export(PackedScene) var hud_scene
export(PackedScene) var pause_menu

var current_game_world
var current_hud
var current_pause_menu

var is_paused

enum GameState {MENU, IN_GAME, DEBRIEF}

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
      if is_instance_valid(current_game_world):
        current_game_world.queue_free()
      if is_instance_valid(current_hud):
        current_hud.queue_free()
      root.add_child(main_menu.instance())

    GameState.IN_GAME:
      current_game_world = game_world.instance()
      current_hud = hud_scene.instance()
      root.add_child(current_hud)
      root.add_child(current_game_world)
      
      current_game_world.generate()
      emit_signal("world_generated")

    GameState.DEBRIEF:
      pause_game()

  # cleanup previous state
  match previous_state:
    GameState.MENU:
      root.get_node("MainMenu").queue_free()
      pass
    GameState.IN_GAME:
      pass
    GameState.DEBRIEF:
      unpause_game()


func _unhandled_input(event: InputEvent):
  if (event.is_action_pressed("menu")):
    match current_state:
      GameState.MENU: # Start Game
        change_state(GameState.IN_GAME)
      GameState.IN_GAME: # Pause
        toggle_pause()
      GameState.DEBRIEF: # Go to menu
        change_state(GameState.MENU)

func toggle_pause():
  if (is_paused):
    unpause_game()
  else:
    pause_game()

func pause_game():
  is_paused = true
  get_tree().paused = true
  emit_signal("paused")
  current_pause_menu = pause_menu.instance()
  get_tree().root.add_child(current_pause_menu)
  
  
func unpause_game():
  is_paused = false
  get_tree().paused = false
  emit_signal("unpaused")
  current_pause_menu.queue_free()

func temp_pause(seconds: float):
  pause_until(get_tree().create_timer(seconds), "timeout")

func pause_until(obj, sig):
  var tree = get_tree()
  tree.paused = true
  emit_signal("paused")
  yield(obj, sig)
  tree.paused = false
  emit_signal("unpaused")
