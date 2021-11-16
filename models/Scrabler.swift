//
//  Scrabler.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 29/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation
import Darwin

enum moveDirection:String{
    case Right = "R"
    case Left = "L"
    case Down = "D"
    case Up = "U"
}

struct cubeScrableMove{
    var name:String!
    var moveDirection:moveDirection!
    init(name:String,moveDirection:moveDirection) {
        self.name = name
        self.moveDirection = moveDirection
    }
}

class Scrabler{
    var verticalMoves:Array<String>
    var horizontalMoves:Array<String>
    var moves4Scrable:Int!
    init(){
        self.verticalMoves = Array<String>.init()
        self.horizontalMoves = Array<String>.init()
    }
    init(verticalMoves:Array<String>, moves4Scrable m4s:Int,horizontalMoves:Array<String>){
        self.verticalMoves = verticalMoves
        self.moves4Scrable = m4s
        self.horizontalMoves = horizontalMoves
    }
    func generateScrable()->Array<String>{
        var scrable:Array<String> = Array<String>.init()
        let notRepeatingLast = 4
        var lastItems = Array<String>.init()
        //var tempLastItems = Array<String>.init()
        var lastMoveTypeUsed = false
        var last = -1
        var i = 0
        //var y = 0
        
        while (i<self.moves4Scrable){
            let randomNumber:Int = Int(arc4random_uniform(UInt32(self.verticalMoves.count)))
            let val = lastMoveTypeUsed == false ? self.verticalMoves[generateRightRandom()]:self.horizontalMoves[generateRightRandom()]
            if isRepeatedOrRelated(value:val,inside: lastItems){
               continue
            }
            scrable.append("\(val)")
            lastMoveTypeUsed = !lastMoveTypeUsed
            last = randomNumber
            lastItems.append(val)
            if i >= notRepeatingLast{
                lastItems.remove(at: 0)
            }
           /* if lastItems.count < notRepeatingLast{
                lastItems.append(val)
            }else{
                y = y+1
                tempLastItems.append(val)
                if y == notRepeatingLast{
                    y = 0
                    lastItems = tempLastItems
                    tempLastItems.removeAll()
                }
                
            }*/
            i+=1
        }
        return scrable
    }
    func isRepeatedOrRelated(value:String,inside:Array<String>)->Bool{
        guard !inside.contains(value) else{
            return true
        }
        let relatedMoves:Array<String> = ["Prime","2"]
        for item in inside{
            for v in relatedMoves{
                if item.contains("\(value)\(v)") ||  item.contains("\(value)") || value.contains("\(item)"){
                    return true
                }
            }
        }
        return false
    }
    private func generateRightRandom()->Int{
        return Int(arc4random_uniform(UInt32(self.verticalMoves.count)))
        
    }
}
