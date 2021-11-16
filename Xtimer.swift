//
//  Xtimer.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 14/3/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation

import UIKit
import Foundation
var str = "XTimmer"


struct TimeUnit{
    var name:String//description, seconds, minutes, years,etc
    var base:Bool = false
    var timerLbl:UnsafeMutablePointer<UILabel>?
    var delimitator:String!
    var actualValue:Int64{
        willSet(newValue){
            //print("\(self.name) \(newValue)")
            if newValue == self.baseUnitEquivalent{
                if (relatedUnit != nil){
                    self.updateRelatedUnit()
                }
            }
            self.updateRelatedLabel(value: newValue)
            
        }
        didSet(oldValue){
            if oldValue == self.baseUnitEquivalent-1{
                self.setActualValue(value: 0)
            }
        }
    }//value shown on screen
    var baseUnitEquivalent:Int64//we use seconds as base, so a minute is 60 secods, an hour is 60x60 secods,so it will be the value use for other units if needed
    var position:Int//1, if the first time unit(the bigest will be the one with more baseUnitEquivalent number)
    var relatedUnit:UnsafeMutablePointer<TimeUnit>? = nil//seconds, wil have minutes related, because seconds define when minutes change, based in baseUnitEquivalent
    init(name:String,unit:Int64,position:Int,p:UnsafeMutablePointer<TimeUnit>?,base:Bool,timerLblPointer:UnsafeMutablePointer<UILabel>?,delimitator:String){
        self.name = name
        self.baseUnitEquivalent = unit
        
        self.position = position
        if let pointer = p{
            self.relatedUnit = UnsafeMutablePointer<TimeUnit>.allocate(capacity: 1)
            self.relatedUnit?.initialize(from: pointer, count: 1)
        }
        self.base = base
        if (base==true){
           self.actualValue = 0
        }else{
            self.actualValue = 0
        }
        self.delimitator = delimitator
        if let pointerLabel = timerLblPointer{
            self.timerLbl = UnsafeMutablePointer<UILabel>.allocate(capacity: 1)
            self.timerLbl?.initialize(from: pointerLabel, count: 1)
        }
    }
    private mutating func setActualValue(value:Int64){
        self.actualValue = value
    }
    private func updateRelatedUnit(){
        self.relatedUnit?.pointee.actualValue += 1
    }
    
    private func numberZeroFill(number:String,baseUnitEquivalent:Int64)->String{
        
        var res = ""
        for _ in 0..<String(baseUnitEquivalent).characters.count - number.characters.count{
            res="\(res)\(0)"
        }
        return res
    }
    private func updateRelatedLabel(value:Int64){
        /*let fill = self.numberZeroFill(number:value,baseUnitEquivalent:self.baseUnitEquivalent)
        if !self.base{
            self.timerLbl!.pointee.text = "\(fill)\(value):"
        }else{
             self.timerLbl!.pointee.text = "\(fill)\(value)"
        }*/
        self.timerLbl!.pointee.text = "\(String(format: "%@%02d",self.delimitator,value))"
        
    }
}
class XTimer{
    let timeUnits:[TimeUnit]
    var T:Timer!
    var baseUnit:TimeUnit!
    var timeInterval:Double!
    enum State{
        case Running
        case Stopped
    }
    
    var state:State
    init(tu:[TimeUnit],timeInterval:Double){
        self.timeInterval = timeInterval
        self.timeUnits = tu
        self.state = .Stopped
        self.baseUnit = tu[0]
        for t in tu{
            if t.base{
                self.baseUnit = t
                break
            }
        }
    }
    
    func Start(){
        print("Initialazing Timer...")
        guard self.state == .Stopped else {
            return
        }
        self.state = .Running
        self.T = Timer.scheduledTimer(timeInterval: self.timeInterval!, target: self, selector: #selector(self.Display), userInfo: nil, repeats: true)
        
        //self.T.fire()
        
    }
    func Stop(){
        print("Stopping Timer...")
        if self.state == .Running{
            self.T.invalidate()
        }
        self.state = .Stopped
    }
    func getActualTime()->String{
        var result = ""
        for n in self.timeUnits{
            result = "\(n.timerLbl!.pointee.text!)\(result)"
        }
        return result
    }
    @objc func Display(){
        self.baseUnit?.actualValue += 1
    }
}


