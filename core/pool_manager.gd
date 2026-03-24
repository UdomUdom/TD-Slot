extends Node
# res://core/pool_manager.gd

# Dictionary stores the pool for each Scene
# Key: String (Scene path or ID name)
# Value: Array of pre-created Node2D elements
var _pools: Dictionary = {}

# Parent node that temporarily places objects from the pool there when not in use.
var _pool_container: Node

func _ready() -> void:
	_pool_container = Node.new()
	_pool_container.name = "PoolContainer"
	add_child(_pool_container)

# Function for preparing objects in advance (called during level loading)
func initialize_pool(scene: PackedScene, pool_key: String, initial_size: int) -> void:
	if not _pools.has(pool_key):
		_pools[pool_key] = []
		
	for i in range(initial_size):
		var instance = scene.instantiate()
		_deactivate_and_store(instance, pool_key)

# ฟังก์ชันดึง Object ออกมาใช้งาน
func get_instance(scene: PackedScene, pool_key: String) -> Node2D:
	if _pools.has(pool_key) and _pools[pool_key].size() > 0:
		var instance = _pools[pool_key].pop_back()
		_activate_instance(instance)
		return instance
	
	# ถ้าใน Pool หมด ให้สร้างใหม่ (Fallback)
	var new_instance = scene.instantiate() # <<-- Don't forget to add base_scene in Unit scene
	# ไม่ต้อง _activate เพราะเพิ่งสร้างใหม่
	return new_instance

# Function to return an object to the pool (instead of using queue_free)
func return_instance(instance: Node2D, pool_key: String) -> void:
	if not _pools.has(pool_key):
		_pools[pool_key] = []
	
	_deactivate_and_store(instance, pool_key)

func _deactivate_and_store(instance: Node2D, pool_key: String) -> void:
	# If it already has a Parent, remove it first.
	if instance.get_parent():
		instance.get_parent().remove_child(instance)
		
	_pool_container.add_child(instance)
	
	# ปิดการทำงานทุกอย่าง
	instance.process_mode = Node.PROCESS_MODE_DISABLED
	instance.hide()
	
	# รีเซ็ตตำแหน่ง
	instance.global_position = Vector2.ZERO
	
	_pools[pool_key].append(instance)

func _activate_instance(instance: Node2D) -> void:
	# เอาออกจาก container ชั่วคราว
	if instance.get_parent():
		instance.get_parent().remove_child(instance)
		
	instance.process_mode = Node.PROCESS_MODE_INHERIT
	instance.show()
