//
//  vector.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 23/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation

struct Vector{
    var vectorDirection:VectorDirection!
    var color:CubeColor!//the color this vector points to,:)
    var base:Bool!//use to be de pivot in a rotation,if base = Front and rotate
    init(vectorDirection vd:VectorDirection,color:CubeColor,base:Bool){
        self.vectorDirection = vd
        self.color = color
        self.base = base
    }
    init(){}
}
