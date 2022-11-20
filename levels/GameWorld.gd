extends Node2D
# class_name GameWorld

var test_scene = preload("./TestScene.tscn")

func _ready():
  pass

func _init():
  pass

func generate():
  add_child(test_scene.instance())

func _unhandled_input(event: InputEvent):
  if (event.is_action_pressed("menu")):
    GameManager.change_state(GameManager.GameState.MENU)