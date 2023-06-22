extends CanvasLayer

export(String, FILE, "*.json") var dia

var dialogue = []


func _ready():
	start()
	
func start():
	dialogue = load_dialogue()
	
	$NinePatchRect/Name.text = dialogue[0]['name']
	$NinePatchRect/chat.text = dialogue[0]['chat']
	
func load_dialogue():
	var file = File.new()
	if file.file_exists(dia):
		file.open(dia, file.READ)
		return parse_json(file.get_as_text())
