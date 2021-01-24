class_name AnyActionButton
extends Node2D

export(String) var display_name


func is_hovered() -> bool:
	return $TextureButton.is_hovered()
