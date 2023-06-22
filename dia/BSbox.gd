extends CanvasLayer

onready var cont = $TextboxContainer
onready var label = $TextboxContainer/MarginContainer/HBoxContainer/text

var text_queue = []


func _ready():
	hide_textbox()
	queue_text("Well Hello")
	queue_text("I was the blacksmith of the town")
	queue_text("Wow your weapons can really use some work")
	queue_text("I can take a look at them, for a price of course")
	queue_text("[Press 1 to upgrade] - [Cost: 3 Wood]")


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
