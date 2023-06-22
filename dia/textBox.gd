extends CanvasLayer

onready var cont = $TextboxContainer
onready var label = $TextboxContainer/MarginContainer/HBoxContainer/text

var text_queue = []


func _ready():
	hide_textbox()
	queue_text("Well Hello")
	queue_text("I was not expecting anyone else to show up to our island")
	queue_text("Well no worries, you are welcome here")
	queue_text("But please be careful, due to summer many have gone out to gather materials")
	queue_text("So the island is kinda infested")
	queue_text("However we still have our blacksmith and healer here to aid you")
	queue_text("Feel free to explore before we can get you all setup")
	queue_text("Now excuse me, I am waiting for my boat to arrive")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !text_queue.empty():
			display_text()
		elif text_queue.empty():
			hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	label.text = ""
	cont.hide()

func show_textbox():
	cont.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	show_textbox()
