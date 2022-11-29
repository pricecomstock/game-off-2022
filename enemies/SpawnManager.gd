extends Node

var timer = null
var enemy_count := 0
var enemy_budget_use := 0

export var spawn_cycle_seconds = 1.0;
export var target_enemy_budget := 10;
export var max_simul_spawns := 2;

export(Array, PackedScene) var spawnable_enemies := []

var enemy_budget_costs := []


# Called when the node enters the scene tree for the first time.
func _ready():
  randomize()

  timer = Timer.new()
  add_child(timer)

  timer.connect("timeout", self, "run_spawn_cycle")
  timer.set_wait_time(spawn_cycle_seconds)
  timer.set_one_shot(false)
  timer.start()

  # no static vars so we have to instantiate each enemy to get its cost
  enemy_budget_costs = []
  for enemy in spawnable_enemies:
    var instance = enemy.instance()
    enemy_budget_costs.append(instance.spawn_budget_cost)
    instance.queue_free()

func run_spawn_cycle() -> void:
  var scene_tree = get_tree()
  var spawners : Array = scene_tree.get_nodes_in_group("active_spawners")
  var enemies : Array = scene_tree.get_nodes_in_group("enemies")
  enemy_count = enemies.size()

  enemy_budget_use = 0
  for enemy in enemies:
    enemy_budget_use += enemy.spawn_budget_cost

  if (!spawners):
    return
  
  var enemy_spawn_indexes = choose_enemies_to_spawn(target_enemy_budget - enemy_budget_use)

  for esi in enemy_spawn_indexes:
    spawners[randi() % spawners.size()].spawn(spawnable_enemies[esi])
  
func choose_enemies_to_spawn(budget: int):
  var spawn_indexes = []
  var used_budget := 0

  while(used_budget < budget and spawn_indexes.size() < max_simul_spawns):
    var remaining_budget = budget - used_budget
    var enemy_index = randi() % spawnable_enemies.size()
    var budget_use = enemy_budget_costs[enemy_index]

    if budget_use < remaining_budget:
      spawn_indexes.append(enemy_index)
    else:
      break
  return spawn_indexes
  
