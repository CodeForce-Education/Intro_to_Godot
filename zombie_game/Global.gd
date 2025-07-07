extends Node

var node_creation_parent = null
var player = null
var points = 0
var Camera = null
var highscore = 0
var gameOff = false

func instance_node(node, location, parent):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
