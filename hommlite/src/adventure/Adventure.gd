extends Node2D

onready var map: AdventureMap = $AdventureMap


func _ready():
	$Selector.map = map
	$Debug.hexmap = map.hexmap

