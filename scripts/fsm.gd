extends Node
class_name FSM

var debug = Game._debug
var states = {}
var state_cur = null
var state_next = null
var state_last = null
var obj = null 


func _init(_obj, states_parent_node, initial_state, _debug = false):
	self.obj = _obj
	self.debug = _debug
	_set_states_parent_node(states_parent_node)
	state_next = initial_state


func _set_states_parent_node(nodeP):
	if debug:
		print("Found ", nodeP.get_child_count(), " states")
		if nodeP.get_child_count() == 0:
			return

	var state_nodes = nodeP.get_children()
	for state_node in state_nodes:
		if debug:
			print("adding state:", state_node.name)
		states[state_node.name] = state_node
		state_node.fsm = self
		state_node.obj = self.obj


func run_machine(delta):
	if state_next != state_cur:
		if state_cur != null:
			if debug:
				print(obj.name, ": changing from state ", state_cur.name, " to ", state_next.name)
			state_cur.terminate()
		elif debug:
			pass
			print( obj.name, ": starting with state ", state_next.name )
		state_last = state_cur
		state_cur = state_next
		state_cur.initialize()
	
	state_cur.run(delta)
