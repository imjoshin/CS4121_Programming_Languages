#lang reader "txtadv-reader.rkt"

===VERBS===

start
 "start"

north, n
 "go north"

south, s
 "go south"

east, e
 "go east"

west, w
 "go west"

up
 "go up"

down
 "go down"

in, enter
 "enter"

out, leave
 "leave"

get _, grab _, take _
 "take"

put _, drop _, leave _
 "drop"

push _, press _, touch _
 "push"

use _

open _, unlock _
 "open"

close _, lock _
 "close"

knock _

quit, exit
 "quit"

look, show
 "look"

inventory
 "check inventory"

help

save

load

action

===EVERYWHERE===

quit 
 (begin
  (printf "Bye!\n")
  (exit))

look 
 (show-current-place)

inventory 
 (show-inventory)

save
 (save-game)

load
 (load-game)

help
 (show-help)


===THINGS===

---backpack---

get
  (try-take! backpack)

put
  (try-drop! backpack)


---circle---

get
  (try-take! circle)

put
  (try-drop! circle)

use
  "Studying. Studying everywhere."


---triangle---

get
  (try-take! triangle)

put
  (try-drop! triangle)

use
  "Servers. Servers everywhere."


---square---

get
  (try-take! square)

put
  (try-drop! square)

use
  "Classes. Classes everywhere."


---button---
push
 (begin
   (printf "A sunroof opens above above. The light starts pouring in and you can hear the howls of the monsters in the building.\nCongratulations, adventurer!")
   (exit))

---flower---
get
  (try-take! flower)

put
  (try-drop! flower)

---candy---
get
  (try-take! candy)

put
  (try-drop! candy)

---lounge-door---
open 
  (if (and (have-thing? lounge-key) (have-thing? circle)
           (have-thing? triangle) (have-thing? square))
      (begin
        (set-thing-state! lounge-door 'open)
        "You hear a lot of gears turning. The door slowly opens.")
      "The door is locked. There is an imprint of a circle, triangle, and square, and a keyhole above.")

close
  (begin
   (set-thing-state! lounge-door #f)
   "You hear a lot of gears turning. The door is now locked.")

knock
  "No one is home."


---server-door---
open 
  (if (have-thing? server-key)
      (begin
        (set-thing-state! server-door 'open)
        "The door is now unlocked and open.")
      "The door is locked.")

close
  (begin
   (set-thing-state! server-door #f)
   "The door is now closed.")

knock
  "No one is home."


---server-key---

get
  (try-take! server-key)

put
  (try-drop! server-key)


---lounge-key---

get
  (try-take! lounge-key)

put
  (try-drop! lounge-key)


===PLACES===

---intro---
"Welcome, adventurer! Your job is to find the sunlight to stop the Demented Professor and the Zombie Grad students.
Watch out! Those monsters will move around. The Professor will teleport you to a new area, and the zombies will eat you if you stay in one place to long!
Type 'start' to begin."
[]

start
 rekhi112

---rekhi112---
"You're standing in Rekhi 112. There is a door to the east."
[backpack, server-key, triangle]

east
 hallway1


---rekhi114---
"You are standing in Rekhi 114. There is a door to the west."
[]

west
 hallway1


---rekhi101---
"You are standing in Rekhi 101. There is a door to the south."
[]

south
 intersection1


---rekhiLounge---
"You are standing in the Rekhi Lounge."
[button]

south
 intersection2


---rekhi214---
"You are standing in Rekhi 214. There is a door to the west."
[circle]

east
 hallway2


---rekhi215---
"You are standing in Rekhi 215. There is a door to the east."
[]

west
 hallway2


---rekhi315---
"You are standing in Rekhi 315. There is a door to the east."
[lounge-key, square]

east
 hallway3


---rekhi316---
"You are standing in Rekhi 316. There is a door to the west."
[]

west
 hallway3


---hallway1---
"You are standing in the hallway of the first floor. There are rooms to the east and west, and an intersection to the north."
[]

north
 intersection1

west
 rekhi112

east
 rekhi114


---hallway2---
"You are standing in the hallway of the second floor. There are rooms to the east and west, and an intersection to the north."
[]

north
 intersection2

west
 rekhi214

east
 rekhi215


---hallway3---
"You are standing in the hallway of the third floor. There are rooms to the east and west, and an intersection to the north."
[server-door]

north
 intersection3

west
  (if (eq? (thing-state server-door) 'open)
      rekhi315
      "The door is not open.")

east
 rekhi316

---intersection1---
"You are standing in the intersection of the first floor. There is a room to the north, a hallway to the south, and a stairwell to the west."
[]

north
 rekhi101

south
 hallway1

west
 stairwell1


---intersection2---
"You are standing in the intersection of the second floor. There is a lounge to the north, a hallway to the south, and a stairwell to the west."
[lounge-door]

north
  (if (eq? (thing-state lounge-door) 'open)
      rekhiLounge
      "The door is not open.")

south
 hallway2

west
 stairwell2


---intersection3---
"You are standing in the intersection of the third floor. There is a hallway to the south, and a stairwell to the west."
[]

south
 hallway3

west
 stairwell3


---stairwell1---
"You are standing on the first floor of the stairwell. There is a floor above you and a door to the north."
[]

up
 stairwell2

north
 intersection1


---stairwell2---
"You are standing on the second floor of the stairwell. There is a floor above, below you, and a door to the north."
[]

up
 stairwell3

down
 stairwell1

north
 intersection2


---stairwell3---
"You are standing on the third floor of the stairwell. There is a floor below you and a door to the north."
[]

down
 stairwell2

north
 intersection3


===MONSTERS===

---professor---
"Demented Professor"
[hallway3, intersection2, rekhi215, rekhi114, stairwell3, rekhi316, rekhi214, rekhi112, rekhi101, hallway2]

action
 (teleport)

---zombie1---
"Zombie Grad Student 1"
[rekhi101, intersection1, hallway1, rekhi112, hallway1, rekhi114, hallway1, intersection1]

action
 "There is a zombie grad student in the room!"

---zombie2---
"Zombie Grad Student 2"
[rekhi214, hallway2, intersection2, stairwell2, stairwell3, intersection3, hallway3, intersection3, stairwell3, stairwell2, intersection2, hallway2]

action
 "There is a zombie grad student in the room!"



