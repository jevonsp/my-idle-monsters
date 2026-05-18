extends Node

@warning_ignore_start("unused_signal")
signal time_ticked(delta: float)


@warning_ignore_restore("unused_signal")
func _process(delta: float) -> void:
	time_ticked.emit(delta)


func subscribe(object: Object, event: Signal, callable: Callable, is_oneshot: bool = false):
	if not object.event.is_connected(callable):
		if not is_oneshot:
			object.event.connect(callable)
			return
		event.connect(callable, CONNECT_ONE_SHOT)


func unsubscribe(object: Object, event: Signal, callable: Callable):
	if object.event.is_connected(callable):
		object.event.disconnect(callable)
