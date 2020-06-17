extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	utils.connect("score_current_changed", self, "_on_score_current_changed")
	pass

func _on_score_current_changed():
	set_text(str(utils.score_current))
	pass
