class_name SavedGame
extends Resource

const FORMAT_VERSION := 1

@export var version: int = FORMAT_VERSION
## Top-level state not tied to a participant (optional).
@export var meta: Dictionary = {}
@export var saved_data_array: Array[SavedData] = []
