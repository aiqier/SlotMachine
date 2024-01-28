extends Node2D

const STATUS_STOP = 0 # 状态停止
const STATUS_ROLL = 1 # 状态旋转


# 状态(三个滚动条一起的状态)
var status = STATUS_STOP

func show_scrolls():
	print(
		$ScrollLayer/First.get_card_name(), 
		"|",
		$ScrollLayer/Second.get_card_name(), 
		"|",
		$ScrollLayer/Third.get_card_name())

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	show_scrolls()


# 所有都停止
func all_scroll_stop():
	return $ScrollLayer/First.is_stop() && $ScrollLayer/Second.is_stop() && $ScrollLayer/Third.is_stop()
	

func start():
	if status == STATUS_STOP:
		status = STATUS_ROLL
		$ScrollLayer/First.start(3)
		$ScrollLayer/Second.start(5)
		$ScrollLayer/Third.start(7)

func stop():
	if status == STATUS_ROLL:
		status = STATUS_STOP
		show_scrolls()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_down"):
		start()
	if all_scroll_stop():
		stop()
