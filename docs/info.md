<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

once it is assembled and set up, turn it on and press the reset button, the green light will then be on, that means you are in set lock mode

close the safe

enter a four digit code on the number pad, then presss hashtag or pound to submit the code

confirm the code by re entering it and pressing hashtag

at any point in the setting process you can press star to start over

if your codes don't match anything will happen

if your codes do match, the blue light will turn on, the green light will turn off, and the solenoid will activate, locking the safe

to open the safe put in the code you entered earlier and press hashtag or pound

you can clear what you are typing at any time with the star

if you put in the wrong code nothing happens

if you put in the right code, the solenoid will open, the lights will switch, and you will be back where you started in the set lock mode


## How to test

Connect the bidirectional I/O pins 4-7 (uio[4:7]) to the signals from the four rows in order of the membrane keypad

connect the bidirectional I/O pins 0-2 (uio[0:2]) to the first or only three columns of the membrane keypad

connect the first output pin (uo[0]) to the power transistor driving the solenoid

connect the second and third output pins (uo[1] and uo[2]) to the green and blue LEDs respectively
## External hardware

a 3x4 or 4x4 standard membrane keypad (if using 4x4 the 4th column is unused)

a power transistor

a solenoid

a power supply capable of running the solenoid

2 led's of different colors (green and blue ideal)
