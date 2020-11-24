#!/usr/bin/liquidsoap

# Standard settings
set("log.file.path","/var/log/liquidsoap/radio.log")
set("log.stdout",false)
set("log.file",true)

# Songs
weeb = playlist.safe(mode='random', "/srv/music/weeb/mp3") 
oneshot = single("/srv/music/fallback.mp3")

# Schedule
weekmorning = random(weights = [1], [weeb])
weekafternoon = random(weights = [2], [weeb])
weeknights = random(weights = [1], [weeb])
fridaymorning = random(weights = [1], [weeb])
fridayafternoon = random(weights = [3], [weeb])
fridaynight = random(weights = [2], [weeb])
saturdaymorning = random(weights = [2, 1], [weeb, oneshot])
saturdayafternoon = random(weights = [2], [weeb])
saturdaynight = random(weights = [2], [weeb])
sundaymorning = random(weights = [2], [weeb])
sundayafternoon = random(weights = [2], [weeb])
sundaynight = random(weights = [2], [weeb])

# Implement Schedule
radio=fallback([
    switch([
        ({ (1w or 2w or 3w or 4w) and 6h-13h}, weekmorning),
        ({ (1w or 2w or 3w or 4w) and 13h-20h}, weekafternoon),
        ({ (1w or 2w or 3w or 4w) and 20h-23h59}, weeknights),
        ({ (2w or 3w or 4w or 5w) and 0h-6h}, weeknights),
        ({ (5w) and 6h-13h}, fridaymorning),
        ({ (5w) and 13h-20h}, fridayafternoon),
        ({ (5w) and 20h-23h59}, fridaynight),
        ({ (6w) and 0h-6h}, fridaynight),
        ({ (6w) and 6h-13h}, saturdaymorning),
        ({ (6w) and 13h-20h}, saturdayafternoon),
        ({ (6w) and 20h-23h59}, saturdaynight),
        ({ (7w) and 0h-6h}, saturdaynight),
        ({ (7w) and 6h-13h}, sundaymorning),
        ({ (7w) and 13h-20h}, sundayafternoon),
        ({ (7w) and 20h-23h59}, sundaynight),
        ({ (1w) and 0h-6h}, sundaynight),
        ]),
        kawaii])

#ignore(radio, fallible=false)

# Output the full stream in OGG and MP3
#start = output.icecast.mp3(
#  host="localhost", port=8000, password="hackme2112yyz@", 
#  genre="Electronica", url="http://localhost",
# description="Radio",mount="/kawaii",name="(((( Evolution Bass Radio ))))", bitrate=128,default)

output.icecast(%mp3(bitrate=128), name="--- jlab Radio ---",mount="/radio.mp3", host="localhost", port=8000, password="hackme*******@", radio)
