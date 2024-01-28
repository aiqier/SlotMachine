extends Node2D

export var speed = 500 # 旋转速度

# 注意向下滚，所以顺序是反的
const CARD_DIAMOND = 0# 钻石
const CARD_ORANGE = 1
const CARD_CHERRY = 2
const CARD_SEVEN = 3
const CARD_BAR = 4
const CARD_WATERMELON = 5
const CARD_BELL = 6

# 状态机枚举
const STATUS_STOP = 0 # 状态停止
const STATUS_ROLL = 1 # 状态旋转

# 初始位置
var POS_INIT_Y

# 牌大小
const SCROLL_CARD_SIZE = 80
# 牌个数
const SCROLL_CARD_COUNT = 7

# 初始步数
const STEP_LEN_INIT = 0

# 状态
var status = STATUS_STOP

# 最终牌
var card = CARD_DIAMOND

# 目标步长
var out_roll = 0
var current_step_len = 0
var target_step_len = 0
var deviation = 0

# 是否停止状态
func is_stop():
	return status == STATUS_STOP
	
func get_card():
	return card
	
func get_card_name():
	card = get_card()
	if card == CARD_DIAMOND:
		return "DIAMOND"
	elif card == CARD_BELL:
		return "BELL"
	elif card == CARD_WATERMELON:
		return "WATERMELON"
	elif card == CARD_BAR:
		return "BAR"
	elif card == CARD_SEVEN:
		return "SEVEN"
	elif card == CARD_CHERRY:
		return "CHERRY"
	else:
		return "ORANGE"
		
func rand_card():
	# return random int 0~6
	return randi() % SCROLL_CARD_COUNT
	
func card_step(current_card, new_card):
	if current_card < new_card:
		return new_card - current_card
	else:
		return SCROLL_CARD_COUNT - current_card + new_card
	

func start(times):
	if status == STATUS_STOP:
		var current_card = card
		var new_card = rand_card()
		var step = card_step(current_card, new_card)
		card = new_card
		
		out_roll = times
		current_step_len = 0
		# 每次旋转都会有少许误差, 减去上次的误差, 进行修正
		target_step_len = step * SCROLL_CARD_SIZE - deviation
		status = STATUS_ROLL
		#print("current card:", current_card, "new card:", new_card, "step:", step, "targe_step:", target_step_len)

func expect_pos_y():
	return get_card() * SCROLL_CARD_SIZE - abs(POS_INIT_Y)

func stop():
	if status == STATUS_ROLL:
		status = STATUS_STOP
		out_roll = 0
		# 记录误差:
		deviation = abs(position.y - expect_pos_y())
		current_step_len = 0
		target_step_len = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	POS_INIT_Y = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if status == STATUS_STOP:
		return

	# 总长度达到就可以停止
	if out_roll == 0 && current_step_len >= target_step_len:
		#print("current card:", current_step_len, ":target_step_len:",target_step_len)
		stop()
		
	var move = speed * delta
	#print(move)
	position.y += move
	current_step_len += move
		
	# 完成一圈，重置
	if position.y >= SCROLL_CARD_SIZE * SCROLL_CARD_COUNT - abs(POS_INIT_Y):
		#print("reset:", position.y)
		position.y = POS_INIT_Y
	
	# 大圈算完，再计算小圈
	if out_roll > 0 && current_step_len >= SCROLL_CARD_SIZE * SCROLL_CARD_COUNT:
		out_roll -= 1
		current_step_len = 0

	#$AnimatedSprite.play()
