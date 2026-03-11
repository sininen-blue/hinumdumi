extends Node

var has_met_frog: bool = false
var has_looked_at_picture: bool = false

# item handling
var current_item: String = ""
var current_item_node: String = ""
var inventory: Dictionary[String, bool] = {}
var openend_chests: Dictionary[String, bool] = {}

# mail handling
var current_mail_index: int = 0
var mailbox: Array[Dictionary] = []

func mail_get_message_sender() -> String:
	return mailbox[current_mail_index].get("sender")
func mail_length() -> int:
	return len(mailbox)
func mail_has_next() -> bool:
	return current_mail_index+1 < len(mailbox)
func mail_has_prev() -> bool:
	return current_mail_index > 0


# message handling
var current_message_line: int = 0
func message_get_content() -> String:
	var message: PackedStringArray = mailbox[current_mail_index].get("message")
	return message[current_message_line]
func message_has_next() -> bool:
	var message: PackedStringArray = mailbox[current_mail_index].get("message")
	return current_message_line < len(message)


var player: Player
var popups: Control
