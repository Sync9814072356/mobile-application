extends Control
var counter = 0
var duration = 100.0
var counting = false
var end = false
var decimals = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Counter.text = "0%"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_settings_button_pressed():
	$SettingsButton.hide()
	$StartStopButton.hide()
	$Settings.show()
	
func _on_ok_button_pressed():
	var invalid = false
	var minutes = int($Settings/MinutesTextbox/MinutesEdit.text)
	var seconds = int($Settings/SecondsTextbox/SecondsEdit.text)
	if $Settings/MinutesTextbox/MinutesEdit.text == "":
		minutes - 0
		$Settings/MinutesTextbox/MinutesEdit.text = "0"
	if $Settings/SecondsTextbox/SecondsEdit.text == "":
		seconds = 0
		$Settings/SecondsTextbox/SecondsEdit.text = "0"
	if $Settings/MinutesTextbox/MinutesEdit.text == "" and $Settings/SecondsTextbox/SecondsEdit.text == "" or $Settings/MinutesTextbox/MinutesEdit.text == "0" and $Settings/SecondsTextbox/SecondsEdit.text == "0":
		minutes = 1
		seconds = 40
		$Settings/MinutesTextbox/MinutesEdit.text = "1"
		$Settings/SecondsTextbox/SecondsEdit.text = "40"
	if minutes > 59 or seconds > 59:
		invalid = true
	if invalid:
		$Settings/InvalidPrompt.show()
	else:
		$Settings/InvalidPrompt.hide()
		duration = float(minutes * 60 + seconds)
		$Settings.hide()
		$SettingsButton.show()
		$StartStopButton.show()
		$ColorRect.color = $Settings/BackgroundColourSetting.color
		$Counter.set("theme_override_colors/font_color", $Settings/TextColourSetting.color)
		if decimals == 0:
			$Counter.text = "0%"
			$Timer.wait_time = duration / 100
		elif decimals == 1:
			$Counter.text = "0.0%"
			$Timer.wait_time = duration / 1000
		elif decimals == 2:
			$Counter.text = "0.00%"
			$Timer.wait_time = duration / 10000

func _on_start_stop_button_pressed():
	counting = !counting
	if counting == true:
		$StartStopButton.texture_normal = load("res://stopbutton.png")
		$Timer.start()
		$Counter.text = str(counter) + "%"
		$SettingsButton.hide()
	elif counting == false:
		if end == true:
			$FakeDetails.hide()
			$Counter.show()
		$StartStopButton.texture_normal = load("res://playbutton.png")
		counter = 0.0
		if decimals == 0:
			$Counter.text = "0%"
		elif decimals == 1:
			$Counter.text = "0.0%"
		elif decimals == 2:
			$Counter.text = "0.00%"
		$Timer.stop()
		$SettingsButton.show()

func _on_timer_timeout():
	if decimals == 0:
		counter += 1
		$Counter.text = str(counter) + "%"
	elif decimals == 1:
		counter += 0.1
		$Counter.text = str("%0.1f" % counter) + "%"
	elif decimals == 2:
		counter += 0.01
		$Counter.text = str("%0.2f" % counter) + "%"
	if counter >= 100.0:
		if decimals == 1:
			$Counter.text = "100.0%"
		elif decimals == 2:
			$Counter.text = "100.00%"
		$StartStopButton.hide()
		$StartStopButton.texture_normal = load("res://resetbutton.png")
		$Timer.stop()
		var fake_attempts = randi_range(1, 100)
		var fake_jumps = randi_range(1, 1000)
		var fake_duration = int(duration + 3)
		var fake_time = str("%02d" % (fake_duration / 60)) + ":" + str("%02d" % (fake_duration % 60))
		$FakeDetails.text = "Attempts: " + str(fake_attempts) + "\nJumps: " + str(fake_jumps) + "\nTime: " + str(fake_time)
		await get_tree().create_timer(3).timeout
		end = true
		$StartStopButton.show()
		$Counter.hide()
		$FakeDetails.show()
		$SettingsButton.show()
	
func _on_background_colour_setting_color_changed(color):
	$Settings/BackgroundColourSetting/ColourSquare.self_modulate = color

func _on_text_colour_setting_color_changed(color):
	$Settings/TextColourSetting/ColourSquare.self_modulate = color

func _on_zero_decimals_pressed():
	if $Settings/ZeroDecimals.button_pressed == true:
		if decimals == 1:
			$Settings/OneDecimal.button_pressed = false
		if decimals == 2:
			$Settings/TwoDecimals.button_pressed = false
	elif $Settings/ZeroDecimals.button_pressed == false:
		$Settings/ZeroDecimals.button_pressed = true
	decimals = 0
	$Settings/WarningPrompt.hide()

func _on_one_decimal_pressed():
	if $Settings/OneDecimal.button_pressed == true:
		if decimals == 0:
			$Settings/ZeroDecimals.button_pressed = false
		if decimals == 2:
			$Settings/TwoDecimals.button_pressed = false
	elif $Settings/OneDecimal.button_pressed == false:
		$Settings/OneDecimal.button_pressed = true
	decimals = 1
	$Settings/WarningPrompt.show()
		
func _on_two_decimals_pressed():
	if $Settings/TwoDecimals.button_pressed == true:
		if decimals == 0:
			$Settings/ZeroDecimals.button_pressed = false
		if decimals == 1:
			$Settings/OneDecimal.button_pressed = false
	elif $Settings/TwoDecimals.button_pressed == false:
		$Settings/TwoDecimals.button_pressed = true
	decimals = 2
	$Settings/WarningPrompt.show()
