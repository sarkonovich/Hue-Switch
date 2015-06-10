
## Installation
Add this line to your application's Gemfile:
```ruby
gem 'hue_switch'
```
And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hue_switch
    
#####Note: There are significant changes between .9 versions and 1.0.0. Some basic commands work slightly differently. Random Colors have been removed. Version 1.0.0 includes a new method -- #voice -- that allows most Switch methods to be passed as a string. Please see end of README for details.

## Usage
A Hue Switch is designed control Hue lights, groups, and scenes. You can schedule a Switch. You can save a Switch as a Hue Scene on the bridge.

NOTE: The first time you run this gem, you'll need to press the link button on the bridge immediately beforehand. If you don't, you'll get an error telling you to do so and try again.

Why is this different from other wrappers?  

1. Hue-Switch is not designed to give full access to Hue API, but to make access to basic operations super easy. A Hue Switch can be assigned an existing group, scene, or one or more individual lights. Switches can be scheduled easily. Color effects can be added (color loop, long and short alerts etc.) For example, a switch could be three random lights on a colorloop. If you turn the switch off, the lights go off. Turn it on, and they continue to cycle through colors.

2. Hue-Switch comes with a utility method (dare I call it a DSL?), #voice. The voice method allows access to (almost) all of the Switch class funtionality with a single string. See below for important differences when using the #voice method.

###Create a Switch

Basic case, an on-off switch for all lights
```ruby
switch = Switch.new
```

Then
```ruby
switch.on
switch.off
```
You can fully specify a switch at creation

```ruby
switch = Switch.new do
  light :kitchen
  color :blue
  saturation 255
  brightness 120
  fade 10  #specified in seconds
end
```
Then `switch.on`

Colors can be specified by

1. Color name (red, pink, purple, violet, blue, orange, turquoise, yellow, green, orange), including Hue mired color names (candle, relax, reading, concentrate, energize.)

2. Numeric value of hue [0-65535], or mired color value [0-500]

```ruby
switch.mired 250
switch.hue 45000
switch.color :green
switch.color :concentrate
```

Groups are indicated by **:lights**, single lights by **:light**.

A switch can control multiple individual lights, even if they are not in a group.

```ruby
switch.lights :'living room' #controls a group
switch.light :bedside #controls a single light
switch.light :table, :"front door" #controls two lights not in a group together.
```
Note: multi-word group/light/scene names must be enclosed in quotation marks.
###Scenes
#####Recall
```ruby
switch = Switch.new do
  scene :dinner
end

switch.scene :dinner
```
#####Save
The current switch state can be saved as a scene on the bridge.
```ruby
switch.save_scene "romantic dinner"
```
If a group is assigned to the switch, the scene will be assigned to that group. If no group is assigned, the scene will affect all lights.
###Modify Switch

After the switch is created, you can modify it:
```ruby
switch.group :fireplace
switch.color :red
```
You can assign a new group, scene, or set of individual lights to a switch

####Or reset it
```ruby
switch.reset
```
###Schedule the lights
Switches can be scheduled:

```ruby
switch.schedule :on, "eight thirty tonight"
switch.schedule :on, "June 9 at 08:00"
switch.schedule :off, "in three minutes"  # "tomorrow", "next week"
```

####Delete the schedule(s) created by the switch:

```ruby
switch.delete_schedules!
```
###Dynamic Effects:
```ruby
switch.colorloop  :start # to cycle through colors
switch.alert :short # to flash lights once
switch.alert :long  # to flash lights for 30 seconds
```
Then `switch.on`

Stop dynamic effects
```ruby
switch.colorloop :stop
switch.alert :stop
```
Then `switch.on`
##Voice
The voice method takes a single string and is meant to control the Switch class with voice commands. *This allows the Switch class to be used as a full-featured replacement for the Hue module on [Zach Feldman's](https://github.com/zachfeldman/alexa-home) Alexa-Home GitHub Repo.*

Because #voice takes a string meant to be spoken, there are important differences between using switch and switch.voice:

1. switch.voice takes no numeric inputs. Brightness and Saturation are set on a scale of one to ten. Fade times for lights are similarly specified in words by seconds. See examples below. Scheduling has some restrictions.
2. Colors can only be specified by name (i.e., 'hue 40000' is not available using #voice).
3. Only a single light can be specified after a 'light' command.
4. \#reset and #delete_scenes! methods not available with #voice
5. **Changes take effect immediately.** Using the #voice method, you don't need to send a separate "on" command for switch properties to be sent to the lights. So:

```ruby
switch.color :blue ; switch.on
switch.lights :kitchen ; switch.saturation 255 ; switch.brightness 127 ; switch.on
```
is now
```ruby
switch.voice "color blue"
switch.voice "kitchen lights saturation ten brightness five"
```
###Examples
#####Recall a scene
```ruby
switch.voice "romantic scene"
switch.voice "purple paradise scene"
```
#####Save a scene
Will save the current light configuration to a scene on the bridge.
```ruby
switch.voice "save scene as romantic dinner"
```
note: scenes saved with \#voice will be affect all lights.
######Schedules
Scheduling syntax is extremely flexible. Any command can be scheduled. With \#voice you can schedule up to a week ahead of time (e.g., "next Monday") and dates ("June 22") are not supported
```ruby
switch.voice "schedule kitchen lights color blue in ten minutes"
switch.voice "start colorloop bedside light schedule at eight fifty three next Friday"
switch.voice "romantic scene schedule tomorrow at eight in the evening"
switch.voice "schedule purple paradise scene thursday evening at eight forty five"
```
######Dynamic Effects:
```ruby
switch.voice "living room lights short alert" [flash lights in the group once]
switch.voice "long alert table light" [flash light for 30 seconds]
switch.voice "brightness five fireplace lights start colorloop"
switch.voice "fireplace lights stop colorloop"
```







