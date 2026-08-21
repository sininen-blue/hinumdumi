extends PlayerEvent


@export var lamppost: Lamppost
@export_range(0, 1, 0.05, "suffix:%") var off_chance: float = 0.2


func _ready() -> void:
	super._ready()


func run_event(_player: Player) -> void:
	if randf() > off_chance:
		lamppost.off()
	else:
		lamppost.flicker()
