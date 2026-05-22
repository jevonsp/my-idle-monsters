class_name JobManager
extends RefCounted

const JOBS_PATH := "res://res/jobs/"

var jobs: Array[Job] = []


func _init() -> void:
	jobs = _load_jobs(JOBS_PATH)
	for i in jobs.size():
		print("Job: ", jobs[i])
		print("name: ", jobs[i].name)
		print("    number_slots: ", jobs[i].number_slots)
		print("    number_seconds: ", jobs[i].number_seconds)
		print("    rate_per_second: ", jobs[i].rate_per_second)


func _find_jobs_path(folder: String = JOBS_PATH) -> Array[String]:
	var paths: Array[String]
	for file_name in DirAccess.get_files_at(folder):
		if file_name.ends_with(".tres"):
			paths.append(folder.path_join(file_name))
	return paths


func _load_jobs(folder: String = JOBS_PATH) -> Array[Job]:
	var _jobs: Array[Job] = []
	for path in _find_jobs_path(folder):
		if not ResourceLoader.exists(path):
			continue
		var res := load(path)
		if res is Job:
			_jobs.append(res)
	return _jobs
