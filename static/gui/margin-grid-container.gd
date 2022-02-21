extends Node

static func build(columns, margin=20):
	var container = GridContainer.new()
	container.add_constant_override("hseparation", margin)
	container.add_constant_override("vseparation", margin)
	container.set_columns(columns)
	return container