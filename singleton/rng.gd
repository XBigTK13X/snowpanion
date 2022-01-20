extends Node

var global_rng = RandomNumberGenerator.new()

func set_seed(int_seed):
	global_rng.seed = int_seed

func integer(ceiling):
	return global_rng.randi_range(0,ceiling)
	
func get_state():
	return global_rng.get_state()

func set_state(state):
	return global_rng.set_state(state)
