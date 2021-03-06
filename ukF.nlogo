extensions [ gis ]
patches-own [potential new-potential seedp capacity ccapacity ]
turtles-own [ xtur ytur xct yct]
globals [cIndex cIndext fileName j filePlots fileView i x1 y1 x2 y2 x3 y3 x4 y4 x5 y5 x6 y6 x10 y10 x11 y11 yt xt xm ym flag cities-dataset
          countries-dataset aspect] ;; x7 y7 x8 y8 x9 y9


;; Init VS and SOC

to setup
 clear-all
  RESET-TICKS
  ;;load map
  set cities-dataset gis:load-dataset "ukcities/ukcities.shp"
 set countries-dataset gis:load-dataset "ukcities/ukclose.shp"
  ; Set the world envelope to the union of all of our dataset's envelopes
  gis:set-world-envelope (gis:envelope-union-of (gis:envelope-of cities-dataset)
                                             (gis:envelope-of countries-dataset))
  ;set aspect gis:create-raster gis:width-of countries-dataset gis:height-of countries-dataset gis:envelope-of countries-dataset
  
  ;gis:set-drawing-color 0
  ;gis:draw countries-dataset 1
  ;gis:set-drawing-color green
  ;gis:draw cities-dataset 1

set i 1
set xm 312
set ym 95
; London  43ad
set x1 xm  
set y1 ym
;Birmingham seventh century
set x2 xm - 77 
set y2 ym + 46 
;Manchester first century
set x3 xm - 96
set y3 ym + 91
;Leeds-Bradford seventh century
set x4 xm - 61
set y4 ym + 106
;Liverpool/Birkenhead 1200
set x5 xm - 119
set y5 ym + 89
;Newcastle-Sunderland 
set x6 xm - 144
set y6 ym + 201
;Sheffield 
;set x7 805 - xt
;set y7 275
;Portsmouth/Southampton 
;set x8 0 - xt
;set y8 835
;Nottingham-Derby 
;set x9 825 - xt
;set y9 235
;Glasgow 10th
set x10 xm - 187 
set y10 ym + 200
;Cardiff & South Wales   1st
set x11 xm - 137
set y11 ym + 1
;Bristol  
;set x12 735 - xt
;set y12 75

ask patches [set pcolor 95 
  set potential -1000]
ask patches gis:intersecting countries-dataset
  [ set pcolor 67
    set potential one-of [1 -1]
    set capacity 5 
    set ccapacity 0
  ]
  
  set cIndex 1
  set cIndext 0
  set j 0
  my-update-plots
end

to setHA
  historicalAccidents 20.0 100 10 x1 y1 9.9
  ;let xv x2 - 75
  ;historicalAccidents 10.7 26.8 1 x10 y10  red
  ;historicalAccidents 7.4 18.6 1 x3 y3  green
  ;historicalAccidents 6.7 16.7 1 x4 y4  yellow
  ;historicalAccidents 6.5 16.3 1 x5 y5  gray
  ;historicalAccidents 4.6 10.1 1 x6 y6  lime
  ;historicalAccidents 3.2 8.0 1 x11 y11  violet 
end
to historicalAccidents [p c cc x y pc]
  ask patch x y [
    set potential p
    set capacity c
    set ccapacity cc
    set pcolor pc 
  ]
end


to setIR
  influenceR x1 y1 100 0 0
  influenceR x2 y2 10 1 threshold / 2
  influenceR x3 y3 10 1 threshold / 3
  influenceR x4 y4 10 1 threshold / 3
  influenceR x5 y5 10 1 threshold / 3
  influenceR x6 y6 10 1 threshold / 4
  influenceR x10 y10 10 1 threshold / 4
  influenceR x11 y11 10 1 threshold / 4
  let xv x2 - 70
  influenceR xv y2 30 1 -1
  
end

to influenceR [xc yc ri s si]
  ask patches gis:intersecting countries-dataset [
  let x pxcor let y pycor
  let r (sqrt((x - xc)*(x - xc) + (y - yc)*(y - yc)))
     if r < ri and r != 0
      [
        ;set pcolor 69
        let p ceiling((r ^ -0.3) * 25)
        set capacity p
        if s = 1 [set potential si]
      ]
 ]
  
end

to go
  
  ask patches gis:intersecting countries-dataset [ 
    
    
    let stemp count neighbors4 with [potential < -500]
    let s sum [potential] of neighbors4  + stemp * 1000
   ; set new-potential (potential + sum [potential] of neighbors4 ) / 5 + one-of [1 -1] + (0.0001 * (ccapacity + sum [ccapacity] of neighbors4 / 5 ))]
   set new-potential (potential + s ) / 5 + one-of [1 -1] + (0.0001 * (ccapacity + sum [ccapacity] of neighbors4 / 5 ))]
  ask patches gis:intersecting countries-dataset [
               ;let ptemp potential
               set potential new-potential
               fixPotential x1 y1 20
               set xt x1 + 1
               fixPotential xt y1 20
              ; set xt x1 - 1
              ; fixPotential xt y1 20.0
              ; set yt y1 + 1
              ; fixPotential x1 yt 20.0
              ; set yt y1 - 1
              ; fixPotential x1 yt 20.0
               ;fixPotential x2 y2 ptemp 
               ;set xt x2 + 1
               ;fixPotential xt y2 ptemp 
               ;set xt x2 - 1
               ;fixPotential xt y2 ptemp 
               ;fixPotential x3 y3 ptemp 
               ;set xt x3 + 1
               ;fixPotential x3 y3 ptemp
               ;fixPotential x4 y4 ptemp 
               ;set xt x4 + 1
               ;fixPotential xt y4 ptemp 
               ;fixPotential x5 y5 ptemp 
               ;set xt x5 + 1
               ;fixPotential xt y5 ptemp
               ;fixPotential x6 y6 ptemp 
               ;set xt x6 + 1               
               ;fixPotential xt y6 ptemp
               ;fixPotential x10 y10 ptemp
               ;fixPotential x11 y11 ptemp
               ;set xt x11 + 1
               ;fixPotential xt y11 ptemp
               
               if potential > threshold [ set pcolor 9.9 
                 ;set pcolor scale-color red ccapacity 1 10
                                          set ccapacity ccapacity + 1
                                          if ccapacity > capacity 
                                          [avalanche]
                                        ]
  ]
  
  my-update-plots
  tick

  ifelse ticks >= 50 + i * 10 and ticks <= 100 [createP 10 set i i + 1] [set i 1]
  ifelse ticks >= 101 + i * 10 and ticks <= 200 [createP 15 set i i + 1][set i 1]
  ifelse ticks >= 201 + i * 10 and ticks <= 300 [createP 25 set i i + 1]  [set i 1]
  ifelse ticks >= 301 + i * 10 and ticks <= 400 [createP 35 set i i + 1] [set i 1]
  if ticks >= 401 + i * 10 and ticks <= 500 [createP 65 set i i + 1]
  
  movePeople
                
 saveFile
 if cIndex >= 100 [stop]
end

to fixPotential [x y p]
  ask patch x y [
    ;if new-potential < p [set potential p]
    set potential p
    ]
end

to movePeople
  ask turtles 
    [ 
     while [[pcolor] of patch-here = 95 ] [lt random-float 360
      forward 1 ]
    lt random-float 180
      forward 3 
     ;getInradius x1 y1 100 green
     ;getInradius x2 y2 40 blue
     ;getInradius x3 y3 9 green 
     ;getInradius x4 y3 8 yellow
     ;getInradius x5 y3 8 gray
     ;getInradius x6 y6 5 lime
     ;getInradius x11 y11 4 violet      
     
     if any? neighbors with [pcolor = 9.9] or any? neighbors with [pcolor = 9]
          [
            set pcolor 9
            ;set pcolor scale-color gray ccapacity 1 50   ; whit this line we can or can not see the spiders
            set ccapacity ccapacity + 1
            ;show ccapacity
            if ccapacity > capacity 
               [avalanche]
             die
          ]
   ]
end

to getInradius [x y rad c]
 if (distancexy x y) < rad
   [ set color c 
     set heading towards patch x y forward 3]

   let r max-one-of patches in-radius 15 [potential]
   set heading towards r
   forward 2
         
end

to avalanche

  set ccapacity ccapacity - 4

   ask neighbors4 [ 
                    ;set pcolor red
                    ;set pcolor scale-color gray ccapacity 1 50
                    set ccapacity ccapacity + 1
                    if ccapacity > capacity
                     [avalanche]
                  ]
end

;;create migrates waves
to createP [n]
  ;let np int n
  create-turtles n
    [ 
      set flag 0
      set xtur random-xcor
      set ytur random-ycor
      ;let trlid who
      ask patch-at xtur ytur [if potential <= -100.00 [set flag 1]]
      ifelse flag = 0 [set color red set size 2.5
                      setxy xtur ytur]
                      [die]
    ]
    
end

to saveFile
    
    if ticks = 50 + j * 50 [
      ask turtles [ht]
      set j j + 1
      set cIndext cIndext + 1
      set fileName word "uk" cIndex
      set fileName word fileName "_"
      set fileName word fileName cIndext
      set fileName word fileName ".csv"
      export-world fileName
      set fileView word "uk" cIndex
      set fileView word fileView "_"
      set fileView word fileView cIndext
      set fileView word fileView ".png"
      export-view fileView
      ask turtles [st]
    ]  
    if ticks > 600 [  
                  ask turtles [die]
                  set cIndex cIndex + 1
                  set cIndext 0
                  set j 0
                ;  set fileName word "uk" cIndex
                 ; set fileName word fileName ".csv"
                  ;export-world fileName
                 ; set fileView word "uk" cIndex
                 ; set fileView word fileView ".png"
                 ; export-view fileView
                  ;print cIndex
                  reset-ticks clear-turtles clear-patches clear-drawing clear-all-plots clear-output
              ask patches [set pcolor 95
                set potential -1000]
                ;gis:set-drawing-color black
                ;gis:draw countries-dataset 1
               ask patches gis:intersecting countries-dataset
             [ set pcolor 67
            set potential one-of [1 -1]
            set capacity 5 
          set ccapacity 0
           ]               
             setHA
             setIR 
         ]
end

to my-update-plots
  set-current-plot "Cells above threshold"
  plot count patches with [potential > threshold]
end
@#$#@#$#@
GRAPHICS-WINDOW
224
10
1437
1394
-1
-1
3.0
1
10
1
1
1
0
1
1
1
0
400
0
450
1
1
1
ticks
30.0

BUTTON
9
10
75
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
118
54
196
87
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
9
52
90
85
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
12
149
213
358
Cells above threshold
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

SLIDER
8
100
180
133
threshold
threshold
0
10
5.5
0.1
1
NIL
HORIZONTAL

BUTTON
79
11
144
44
setHA
setHA
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
148
11
211
44
setIR
setIR
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
113
471
206
516
NIL
count turtles
17
1
11

@#$#@#$#@
## VERSION

$Header: /home/cvs/netlogo/models/Curricular\040Models/Cities/Urban\040Suite\040-\040Structure\040from\040Randomness\0402.nlogo,v 1.5 2007-09-09 21:56:16 tisue Exp $

## WHAT IS IT?

This is another model that demonstrates the concept of "structure from randomness".  In particular, it is an implementation of the model described in the book "Cities and Complexity" by Michael Batty, on pages 45-47.  For analysis and discussion beyond that provided with this model, the reader is encouraged to refer to this text.

The basic idea here is showing how structured formations can easily from completely random initial data, through a simple process.

## HOW IT WORKS

Each grid cell is initialized to have an potential value of either 1 or -1, at random. 

Each tick of the model, the cell takes on a new potential value which is the average of the potential values from its Von Neumann neighborhood (that is, itself and its 4 neighbors) from the previous step, plus a random number which is either 1 or -1.

The potential values are not displayed directly in the graphical view.  Instead, a cell is shown as white in the view when it becomes activated, which occurs when its potential value exceeds the threshold specified by the THRESHOLD slider.  Once a cell has become activated it stays activated, even though the potential value of the cell may drop down below the threshold again.

## HOW TO USE IT

Press the SETUP button to initialize the grid squares.

Press the GO button to run the model.  Press the GO ONCE button to run the model just a single tick.  For a while nothing may change in the view -- this is because none of the cells have reached the threshold yet, to become activated.  Let the model run for some time, and then you will see cells start to light up.

The THRESHOLD slider controls the threshold which cell's potential value must reach in order to become activated.

The CELLS ABOVE THRESHOLD plot records (at each tick) the number of cells that are currently above the threshold.  Note that this is different than plotting the number of activated cells, which is a monotonically increasing function.

The POTENTIAL plot shows two different things.  The maximum potential value that any cell currently has is plotted in green.  The average potential of all the cells (times a factor of 10, so that it it can be seen better on the same graph) is plotted in blue.   
(These plots were designed to match the plots shown in Figure 1.11 of the Cities and Complexity Book.)

## THINGS TO NOTICE

The maximum potential shoots up quickly at first, but then slows.  However, it continues to slowly increase over time.  It is important to understand that the maximum potential that is being plotted is the largest potential found in any of the cells -- not the theoretically maximum potential, which increases linearly with the number of ticks, since it is possible (though very improbable) that all the cells could continually have 1 added to them, and never have -1.  

## THINGS TO TRY

Choose a medium threshold level (such as 4 or 5) and let the model run for about 1500 ticks.  The white patterns of activated cells that form have been shown definitively to be fractal in nature (by Viscek and Szalay, 1987).  Furthermore, it was shown that the fractal dimension (which gives an indication of the amount to which a fractal fills the space) varies with respect to the THRESHOLD value.  This makes sense, and you can see it visually be setting different THRESHOLD values and running the model for a fixed number of ticks.

## EXTENDING THE MODEL

Make it so that cells can be activated in either the positive or negative direction -- that is, if they go below -THRESHOLD, then they should become negatively activated.  Color positively activated cells blue, and negatively activated cells red.  If a cell gets activated one way, and then later is activated the other way, color that cell purple.

## NETLOGO FEATURES

When creating or adding white noise to the system, this model uses the expression "ONE-OF [1 -1]", to choose either 1 or -1 randomly.  ONE-OF is a primitive that works with either agentsets or lists.  It makes a random choice from the collection it is given.  An alternative choice would have been "(RANDOM 2) * 2 - 1", but the ONE-OF notation is easier to read.

## RELATED MODELS

This model is related to all of the other models in the "Urban Suite".  

In particular, it is related to "Urban Suite - Structure from Randomness 1", which is another model demonstrating the same concept.

It is also related to the DLA (diffusion-limited aggregation) model in the NetLogo models library, which grows fractal structures from random particle motion.

## CREDITS AND REFERENCES

This model is based on pages 45-47 of the book "Cities and Complexity" by Michael Batty.

Thanks to Seth Tisue and Forrest Sondahl for their work on this model.

The Urban Suite models were developed as part of the Procedural Modeling of Cities project, under the sponsorship of NSF ITR award 0326542, Electronic Arts & Maxis.  

Please see the project web site ( http://ccl.northwestern.edu/cities/ ) for more information.

To refer to this model in academic publications, please use:  Sondhal, F. and Wilensky, U. (2007).  NetLogo Urban Suite - Structure from Randomness 2 model.  http://ccl.northwestern.edu/netlogo/models/UrbanSuite-StructurefromRandomness2.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

In other publications, please use:  Copyright 2007 Uri Wilensky.  All rights reserved.  See http://ccl.northwestern.edu/netlogo/models/UrbanSuite-StructurefromRandomness2 for terms of use.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.4
@#$#@#$#@
setup repeat 200 [ go ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
