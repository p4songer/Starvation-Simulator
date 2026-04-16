extends CharacterBody2D
## Sim agent that moves toward the nearest other Sim and attacks when close.

const SPEED := 100.0
const ATTACK_RANGE := 30.0

var world: Node = null

## Called when the node enters the scene tree.
func _ready() -> void:
    $VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exit)

## Assigns the world reference.
func set_world(w) -> void:
    world = w

## Main behavior loop.
func _process(delta: float) -> void:
    if world == null:
        return

    var target: Node = world.get_nearest_sim(global_position, self)
    if target == null:
        velocity = Vector2.ZERO
        return

    var dist := global_position.distance_to(target.global_position)

    if dist <= ATTACK_RANGE:
        _attack(target)
        return

    var dir: Vector2 = (target.global_position - global_position).normalized()
    velocity = dir * SPEED
    move_and_slide()

## Randomly destroys one of the two Sims.
func _attack(target: Node) -> void:
    if randf() < 0.5:
        die()
    else:
        target.die()

## Removes the Sim when off-screen.
func _on_screen_exit() -> void:
    die()

## Handles destruction and cleanup.
func die() -> void:
    if world:
        world.remove_sim(self)
    queue_free()
