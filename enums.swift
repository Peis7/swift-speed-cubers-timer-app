//
//  enums.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 23/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation

enum cubeColumnMove{//representas a move that a column of the cube can make, using a cube face as a reference
    case Vertical//having the cube whit white face in front, red at right and blue up,  this move means moving in clock needles orientation
    case VerticalP
    case Horizontal
    case HorizontalP
    
}
enum ArrayRotationDegrees:Int{
    case D0 = 0
    case D90 = 1
    case D180 = 2
    case D270 = 3
}
enum MoveOrigin{//if white face is in front,red at right and red at top, a frontal origin move would be rotate self.baseWidth rows
    case Frontal
    case Side
}
enum CubeColor:String{
    case Red = "Red"
    case Blue = "Blue"
    case White = "White"
    case Green = "Green"
    case Orange = "Orange"
    case Yellow = "Yellow"
}
enum VectorDirection:Character{//represents the vector direction, using on a front face as a base
    case Front = "F"
    case Back = "B"
    case Right = "R"
    case Left = "L"
    case Down = "D"
    case Up =  "U"
}

enum partType:Int8{
    case Center = 1//this assosiated number represents the number of colors(vector for me) this tems has visibles
    case Corner = 3
    case Arist = 2
}
enum degrees:Int{//degrees that a cube column/row cam turn
    case D90 = 1
    case D180 = 2
    case D270 = 3
    case D360 = 0//the same as a clock orientation opposite move, a 90 degrees move
}

enum RotationOrientation:Int{
    case ClockWise = 1
    case OppClockWise = 2
}
