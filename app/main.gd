class_name Main
extends Control

@export_subgroup("Scenes")
@export var store_path: NodePath
@export var job_path: NodePath
@export var fight_path: NodePath
@export_subgroup("Main Scene")
@export var player_inv: NodePath
@export var hot_bar: NodePath
@export var player_stats_display: NodePath
@export var contextual_menu: NodePath


func _ready() -> void:
	Global.main = self
	await call_deferred("_bootstrap")


func _bootstrap() -> void:
	GameBootstrap.setup()
