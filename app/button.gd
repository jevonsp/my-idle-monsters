extends Button

@export var store: InvGrid


func _on_pressed() -> void:
	if store:
		store.toggle_visible(true)
