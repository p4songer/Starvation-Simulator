extends Node2D
## World manager responsible for spawning and tracking all Sim instances.

@onready var spawn_timer: Timer = $SpawnTimer
var sim_scene: PackedScene = preload("res://scenes/sim.tscn")
var active_sims: Array = []

## Called when the node enters the scene tree.
func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

## Spawns a new Sim at a random position within the viewport.
func _on_spawn_timer_timeout() -> void:
	var rect := get_viewport_rect()
	var pos := Vector2(randf() * rect.size.x, randf() * rect.size.y)

	var sim: Node = sim_scene.instantiate()
	sim.position = pos
	sim.set_world(self)

	add_child(sim)
	active_sims.append(sim)

## Removes a Sim from tracking.
func remove_sim(sim: Node) -> void:
	active_sims.erase(sim)

## Returns all Sims except the requester.
func get_other_sims(requester: Node) -> Array:
	return active_sims.filter(func(s): return s != requester)

## Returns the nearest Sim to a given position.
func get_nearest_sim(pos: Vector2, requester: Node) -> Node:
	var others := get_other_sims(requester)
	if others.is_empty():
		return null

	var nearest: Node = null
	var min_dist := INF

	for sim in others:
		var d := pos.distance_to(sim.position)
		if d < min_dist:
			min_dist = d
			nearest = sim

	return nearest
