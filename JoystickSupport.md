The game requires at least one joystick to be connected. Since I had very limited time in building this game, I only pre-set configuration for PS3 controllers. You can try and play it with other controllers but it's unlikely that the usable buttons will be comfortable to use, and the axis may not even be configured correctly.

If you want to use a different controller, you need to add a new configuration in the gamestate.rb file, similar to the PS3 one:

```
PS3_CONTROLLER  = GamepadConfig.new({horizontal: 0, vertical: 1}, {:horizontal => 2, :vertical => 3}, 11, 9)
```

Then use your new configuration instead of PS3\_CONTROLLER when adding a new player to the player list:

```
@player_list.add(p.name, rand(window.width), rand(window.height), p.controller_type == :joystick ? GamePad.new(p.joystick_path, PS3_CONTROLLER) : Mouse.new(window), p.vehicle, p.crosshair)
```