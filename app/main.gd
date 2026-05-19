extends Control

@export var player_inv: NodePath
@export var hot_bar: NodePath
@export var player_stats_display: NodePath
@export var contextual_menu: NodePath


func _ready() -> void:
	Global.main = self
	call_deferred("_bootstrap")


func _bootstrap() -> void:
	GameBootstrap.setup()
