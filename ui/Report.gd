extends Control

export(String, MULTILINE) var template = ""

onready var report_text : Label = get_node("%ReportText")

func _ready():
  update_text()
  Events.connect("player_extraction", self, "update_text")

func update_text():
  var run_facts = RunFacts.dict()

  report_text.text = template.format(run_facts)
