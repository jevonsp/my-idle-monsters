extends Control


func _ready() -> void:
	Global.main = self
	call_deferred("_bootstrap")


func _bootstrap() -> void:
	GameBootstrap.setup()
