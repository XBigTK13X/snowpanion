extends Node

var global_rng

func static_init():
	global_rng = RandomNumberGenerator.new()
	global_rng.randomize()

func set_seed(int_seed):
	global_rng.seed = int_seed

func integer(minimum, maximum = null):
	if (maximum == null):
		return global_rng.randi_range(0,minimum)
	return global_rng.randi_range(minimum,maximum)

func get_state():
	return global_rng.get_state()

func set_state(state):
	return global_rng.set_state(state)
