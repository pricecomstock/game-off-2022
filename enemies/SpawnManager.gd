extends Node

var timer = null
var enemy_count := 0

export var spawn_cycle_seconds = 1.0;
export var target_enemy_count := 1;
export var max_simul_spawns := 2;


# Called when the node enters the scene tree for the first time.
func _ready():
  randomize()

  timer = Timer.new()
  add_child(timer)

  timer.connect("timeout", self, "run_spawn_cycle")
  timer.set_wait_time(spawn_cycle_seconds)
  timer.set_one_shot(false)
  timer.start()

func run_spawn_cycle() -> void:
  var scene_tree = get_tree()
  var spawners : Array = scene_tree.get_nodes_in_group("active_spawners")
  var enemies : Array = scene_tree.get_nodes_in_group("enemies")
  enemy_count = enemies.size()

  if (!spawners):
    return

  var enemies_to_spawn : int = min(target_enemy_count - enemy_count, max_simul_spawns)
  # print("spawn cycle, spawning ", enemies_to_spawn, " enemies (", enemy_count + enemies_to_spawn, "/", target_enemy_count, ")")

  if (enemies_to_spawn <= 0): 
    return

  for _i in range(enemies_to_spawn):
    spawners[randi() % spawners.size()].spawn()
  
