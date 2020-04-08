# A 3D-Printable ISA Expansion Card Bracket
========================

![Photo of 2 3D Printed ISA card brackets](https://i.imgur.com/GLypbM1.jpg)

This repository contains the OpenSCAD code to render and produce `.stl` files
for a 3D-printable ISA card bracket, suitable for mounting to cards like the
[XT-IDE rev4](https://www.glitchwrks.com/2017/11/23/xt-ide-rev4), the
[Sergey Kiselev 8-bit ISA Floppy Controller](http://www.malinov.com/Home/sergeys-projects/isa-fdc-and-uart),
and for the commodity CompactFlash to IDE adapters you can find basically anywhere.

Most of the top level constants can be adjusted, and the bracket largely follows the standard
ISA bracket measurements, with adjustments made for the rigidity of PLA materials printed
on cheap 3D printers, as well as using M3 metric bolts and washers rather than 4-40 screws,
since those printers tend to not be able to produce threads that require effort that won't
break the bracket during the card mount. My 3D Printer is very barebones, and my discipline
with leveling is next to nothing, but with this design I've been able to produce a servicable
bracket that mounts in my cases with a very good fit, and one that doesn't flex too bad
while inserting CF cards.

To print a port-less card that can be used with the XT-IDE or other cards, simply leave the constant `cf_slot_enabled`
set to `false`. Setting this to `true` will adjust the screwmount distances and depth on the card to accept one of
those CF adapters in a position that should clear both ISA and PCI slots and other components in your
computer's case.

Eventually I intend to make the top level constants compatible with customizers in both OpenSCAD and Thingiverse.
