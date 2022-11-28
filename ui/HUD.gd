extends CanvasLayer

onready var letters_display = get_node("%LettersDisplay")
onready var letter_view : LetterView = get_node("%LetterView")
onready var report = get_node("%Report")

func _ready():
  letters_display.connect("letter_inspected", self, "_on_letter_inspected")
  letters_display.connect("inspection_stopped", self, "_on_inspection_stopped")
  Events.connect("player_extraction", self, "_on_player_extraction")
  letter_view.hide()
  report.hide()

func _on_letter_inspected(id):
  var letter = LetterManager.get_letters()[id]
  if (!letter):
    print("invalid letter id", id)
    return

  letter_view.display_letter(letter)
  letter_view.show()

func _on_inspection_stopped():
  letter_view.hide()

func _on_player_extraction():
  GameManager.change_state(GameManager.GameState.DEBRIEF)
  GameManager.connect("game_state_change", self, "_on_game_state_change")
  report.show()
  report.update_text()

func _on_game_state_change(new_state, previous_state):
  if new_state != GameManager.GameState.DEBRIEF:
    report.hide()
