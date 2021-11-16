//
//  Cube.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 21/3/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation


class RubikCube{
    var baseWidth:Int!
    var baseHeight:Int!
    var cubeHeight:Int!
    var uniqueIdentifiersStartPosition:Int!
    var cubeItems:Array<CubeItem>!
    var partsCount:[partType:Int]!
    var partsPositions:[partType:Array<Int>]!
    var base:(color:CubeColor,face:Face)!//may use alway (Front,White)
    var faceColRowPos:[Face:Int]!//use to get a face numeric representation
    var facesColor:[Face:CubeColor]!//shoul determinate using cammeras and a camera as a front face for reference :), will be use tu dterminate if cube is solve and also for center peaces while determninaten cube state with cameras
    var faces:Array<Face>!
    var facesInitialColors:[Face:Array<CubeColor>]!
    var facesItemsPositions:[Face:[Int:Int]]!//useful to optimize eficciency, here i have a dictionary with cubeItem index as key and position as value/color etc,considere this as lazy cause may take a long to calculate, this may only help for 3x3x3, but for 4x4x4 or nxmxl will be useless for inner columns, next a better approach
    var faceUniqueIdentifiers:[Face:[Int:Int]]!
    var columsItemsPositions:[MoveOrigin:[cubeColumnMove:[Int:Array<Int>]]]!
    var rotationJumps:[Int:[RotationOrientation:[Int:Array<Int>]]]!//first key,column/row,second inner key, jumplenght, inner points ex. [1:[4:[2,3]]],[3:[3:[4,1]]]//not include destiny
    var columnsRowsChangeOrientation:[Face:[Face:[cubeColumnMove:Int]]]!//0 nothing to do, 1 reverse array
    var columnsOrRows:[MoveOrigin:[cubeColumnMove:[Face:Bool]]]!
    var itemsPositiosForRotations:[cubeColumnMove:[MoveOrigin:[Face:[Int:Int]]]]!
    var cubeUnitsZise:Int{//number of items that represent an entire cube
        get{
            guard let bw = self.baseWidth,let bh = self.baseHeight,let ch = self.cubeHeight  else{
                return 0
            }
            return bw*bh*ch
        }
    }
    
    var facesIndexData:[Face:Array<Int>]!//here i store index based in the unidimensional array, if not symmetrical, front and back faces would be  be same item sizes
    
    init(baseWidth bw:Int,baseHeight bh:Int,cubeHeight ch:Int,uniqueIdentifiersStartPosition:Int,items:Array<CubeItem>){
        self.baseWidth = bw
        self.baseHeight = bh
        self.cubeHeight = ch
        self.uniqueIdentifiersStartPosition = uniqueIdentifiersStartPosition
        if self.cubeUnitsZise == items.count{
            self.cubeItems = items
        }
        else{
            self.cubeItems =  Array.init(repeating: CubeItem.init(), count: self.cubeUnitsZise)
        }
        self.faces = [.Front,.Back,.Down,.Left,.Right,.Up]//order matters for unique identifiers
        self.faceColRowPos = [.Front:0,.Back:self.baseHeight-1,.Down:0,.Up:self.cubeHeight-1,.Right:0,.Left:self.baseWidth-1]//.Front face is 0 becouse from(watching from right)
        self.facesColor = [.Front:.Green,.Right:.Red,.Up:.White,.Left:.Orange,.Back:.Blue,.Down:.Yellow,]
        self.facesInitialColors = [:]
        self.partsPositions = [:]
        self.facesIndexData = [:]
        self.facesItemsPositions = [:]
        self.columsItemsPositions = [:]
        self.rotationJumps = [:]
        self.columnsRowsChangeOrientation = [:]
        self.setFacesIndexData()
        self.base = (CubeColor.White,Face.Front)
        self.setFacesInitialColors()
        self.setfacesItemsPositions()
        //self.setColumnWithItemPositions()
        self.setRotationJumps(envolvedFaces: 4)
        self.setColumnsRowsChangeOrientation()
        self.setItemsPositiosForRotations()
    }
    func setColumnsRowsChangeOrientation(){
        self.columnsRowsChangeOrientation[.Front] = [.Back:[.Vertical:0,.VerticalP:0]]
        self.columnsRowsChangeOrientation[.Right] = [.Up:[.Vertical:0,.VerticalP:0],.Left:[.Vertical:0,.VerticalP:0],.Down:[.Vertical:0,.VerticalP:0]]
        self.columnsRowsChangeOrientation[.Back] = [.Up:[.Vertical:0,.VerticalP:0],.Front:[.Vertical:0,.VerticalP:0],.Down:[.Vertical:0,.VerticalP:0]]
        self.columnsRowsChangeOrientation[.Up] = [.Right:[.Horizontal:0,.HorizontalP:0],.Down:[.Horizontal:0,.HorizontalP:0],.Back:[.Vertical:0,.VerticalP:0]]
        self.columnsRowsChangeOrientation[.Down] = [.Back:[.Vertical:0,.VerticalP:0],.Right:[.Horizontal:0,.HorizontalP:0],.Left:[.Horizontal:0,.HorizontalP:0]]
        self.columnsRowsChangeOrientation[.Left] = [.Right:[.Vertical:0,.VerticalP:0],.Down:[.Vertical:0,.VerticalP:0]]
    }
    func setColumnsOrRows(){//if not nil row, else not change and are horizontal o vertical columns that are treated  like this
        self.columnsOrRows = [:]
        self.columnsOrRows[.Side] = [.Vertical:[.Up:true],.VerticalP:[.Up:true],.Vertical:[.Down:true],.VerticalP:[.Down:true]]
    }
    
    
    //aproach no used now, not efficient
    func rotate(arrayData:Array<Int>,face:Face,degrees:ArrayRotationDegrees,columnMoveOrientation:cubeColumnMove)->[Int:Int]{//degrees may be just an iteration number = degrees.rawvalue, but now dont use it
        let rotationOrientation:RotationOrientation  = (columnMoveOrientation == .Horizontal || columnMoveOrientation == .Vertical) ? .ClockWise : .OppClockWise
        let rotatedItemsData = self.executeRotation(arrayData:arrayData,face:face,rotationOrientation:rotationOrientation,rotationsCount:degrees.rawValue)
        var temporalItems = [Int:CubeItem]()
        self.rotateItemsIn(collection: arrayData,columnMoveOrientation:columnMoveOrientation)
        for data in rotatedItemsData{
            temporalItems[arrayData[data.key]] = self.cubeItems[arrayData[data.key]]
            if (temporalItems[data.value] !=  nil){
                self.cubeItems[arrayData[data.key]] = temporalItems[data.value]!
            }else{
                self.cubeItems[arrayData[data.key]] = self.cubeItems[data.value]
            }
        }
        return rotatedItemsData
    }
    
    func rotateItemsIn(collection:Array<Int>,columnMoveOrientation:cubeColumnMove){
        for j in collection{
            self.cubeItems[j].proccessRotation(degrees: .D90, direction: columnMoveOrientation, moveOrigin: .Frontal)
        }
    }
    func executeRotation(arrayData:Array<Int>,face:Face,rotationOrientation:RotationOrientation,rotationsCount:Int)->[Int:Int]{//degrees may be just an iteration number = degrees.rawvalue, but now dont use it
        var position = 0
        var result:[Int:Int] = [:]
        let columnsCount = face == .Left || face == .Right ? self.baseHeight! : self.baseWidth!
        var faceIndexes = [Int]()
        var y = self.cubeHeight-1
        for column in 0..<columnsCount{
            var z = 0
            for i in (0..<self.cubeHeight).reversed(){
                if rotationOrientation == .ClockWise{
                    result[position] = arrayData[y+z*columnsCount]//position: of the index at the array result
                    faceIndexes.append(arrayData[y+z*columnsCount])
                }else{
                    result[position] = arrayData[column+i*columnsCount]
                    faceIndexes.append(arrayData[column+i*columnsCount])
                }
                position+=1
                z+=1
            }
            y-=1
        }
        
        if rotationsCount != 1{
            result =  self.executeRotation(arrayData: faceIndexes, face: face, rotationOrientation: rotationOrientation,rotationsCount:rotationsCount-1)
        }
        return result
    }
    func reverseRowsFor(arrayData:Array<Int>,rowsCount:Int,rowLength:Int)->[Int:Int]{
        var position = 0
        var result:[Int:Int] = [:]
        
        for row in 0..<self.cubeHeight{//cubeHeight is burn here, must be dynamic based
            for i in (0..<rowLength).reversed(){
                result[position] = arrayData[i+row*rowLength]
                position+=1
            }
        }
        return result
    }
    func assoicatePositionToItemIndexRepresentation(face:Face)->[Int:Int]{
        let faceRepresentation = self.getFaceNumericRepresentation(face: face)
        var result:[Int:Int] = [:]
        for (index,value) in faceRepresentation.enumerated(){
            result[index] = value
        }
        return result
    }
    func moveEntireCube(moveOrigin:MoveOrigin,degrees:degrees,cubeColumnMove:cubeColumnMove){//for a complete cube move, change new fron face
        for i in 0..<self.baseWidth{
            let _ = self.ROTATE(faceOfMoveOrigin: .Front, columnMove: cubeColumnMove, moveOrigin: moveOrigin, index: i, degrees: degrees)
        }
    }
    func setItemsPositiosForRotations(){
        func setDataTo(cubeCM:cubeColumnMove,moveOrigin:MoveOrigin,face:Face,arrayRotationDegrees:ArrayRotationDegrees){
            var data:Array<Int> = Array.init()
            var rotatedData:[Int:Int] = [:]
            if self.itemsPositiosForRotations[cubeCM] != nil{
                if self.itemsPositiosForRotations[cubeCM]![moveOrigin] != nil{
                    self.itemsPositiosForRotations[cubeCM]![moveOrigin]![face] = [:]
                }else{
                    self.itemsPositiosForRotations[cubeCM]![moveOrigin] = [:]
                }
            }else{
                self.itemsPositiosForRotations[cubeCM] = [:]
                self.itemsPositiosForRotations[cubeCM]![moveOrigin] = [:]
            }
            let itemsPos = self.facesItemsPositions[face]!
            for i in 0..<itemsPos.keys.count{
                for key in (itemsPos.keys){
                    if (key == i){
                        data.append(itemsPos[key]!)
                        break
                    }
                }
            }
            rotatedData = self.executeRotation(arrayData: data, face: face, rotationOrientation:.OppClockWise, rotationsCount: arrayRotationDegrees.rawValue)
            data.removeAll()
            self.itemsPositiosForRotations[cubeCM]?[moveOrigin]?[face] = rotatedData
        }
        self.itemsPositiosForRotations = [:]
        setDataTo(cubeCM:cubeColumnMove.Vertical,moveOrigin:MoveOrigin.Frontal,face:Face.Back,arrayRotationDegrees:ArrayRotationDegrees.D180)
        setDataTo(cubeCM:cubeColumnMove.Vertical,moveOrigin:MoveOrigin.Side,face:Face.Up,arrayRotationDegrees:ArrayRotationDegrees.D90)
        setDataTo(cubeCM:cubeColumnMove.Vertical,moveOrigin:MoveOrigin.Side,face:Face.Right,arrayRotationDegrees:ArrayRotationDegrees.D180)
        setDataTo(cubeCM:cubeColumnMove.Vertical,moveOrigin:MoveOrigin.Side,face:Face.Down,arrayRotationDegrees:ArrayRotationDegrees.D270)
    }
    func setRotationJumps(envolvedFaces:Int){
        for i in 1...envolvedFaces{
            self.rotationJumps[i] = [:]
            var colRowJumps = [Int:Array<Int>]()
            for j in 1...(envolvedFaces-1){
                var point:Int = i
                var innerPoints = Array<Int>.init()
                for _ in i..<i+j{
                    point = ((point == envolvedFaces) ? 1:point+1)
                    innerPoints.append(point)
                    
                }
                colRowJumps[j] = innerPoints
            }
            self.rotationJumps[i]?[RotationOrientation.ClockWise]  = colRowJumps
        }
        for j in 1...envolvedFaces{
            self.rotationJumps[j]?[RotationOrientation.OppClockWise] = [:]
            for k in 1...envolvedFaces-1{
                let staring_for_inverse_move = (k >= j) ? envolvedFaces - (k-j) - 1 : ((j-k-1)==0 ? envolvedFaces:(j-k-1))
                self.rotationJumps[j]?[RotationOrientation.OppClockWise]?[k] = self.rotationJumps[staring_for_inverse_move]?[RotationOrientation.ClockWise]?[k]?.reversed()
            }
            
        }
    }
    func createFaceUniqueIdentifiers(lastValueUsed:Int,face:Face)->Int{
        guard let items =  self.facesItemsPositions[face] else{
            return lastValueUsed
        }
        var value = lastValueUsed
        var uniqueValues:[Int:Int] = [:]
        var i = 0
        for key in items.keys{
            value+=1
            uniqueValues[items[key]!] = value
            i+=1
        }
        self.faceUniqueIdentifiers[face] = uniqueValues
        return value
    }
    func setfacesItemsPositions(){//may use this for setColumItemPositions externl leyers
        self.faceUniqueIdentifiers = [:]
        var lastValue4UniqueValues = self.uniqueIdentifiersStartPosition!
        for face in self.faces{
            if face == .Front || face == .Left{//reverse rows
                let rowLength = face == .Left || face == .Right ? self.baseHeight! : self.baseWidth!
                self.facesItemsPositions[face] = self.reverseRowsFor(arrayData: self.getFaceNumericRepresentation(face: face), rowsCount:rowLength,rowLength:rowLength)
            }else if(face == .Up){//rotate
                self.facesItemsPositions[face] = self.executeRotation(arrayData: self.getFaceNumericRepresentation(face: face)
                    , face: face, rotationOrientation:.OppClockWise, rotationsCount: ArrayRotationDegrees.D90.rawValue)
            }else if(face == .Down){
                //first we reverse rows, than rotate face
                var newArray = Array<Int>.init()
                let rowLength = face == .Left || face == .Right ? self.baseHeight! : self.baseWidth!
                let reversedResult = self.reverseRowsFor(arrayData: self.getFaceNumericRepresentation(face: face),rowsCount:rowLength,rowLength:rowLength)
                for n in 0..<self.baseWidth*self.baseHeight{
                    newArray.append(reversedResult[n]!)
                }
                self.facesItemsPositions[face] = self.executeRotation(arrayData:newArray , face: face, rotationOrientation: .OppClockWise, rotationsCount: ArrayRotationDegrees.D90.rawValue )
            }else{//normal obtained representatoion based on my order to see faces index order: see images
                self.facesItemsPositions[face] = self.assoicatePositionToItemIndexRepresentation(face: face)
            }
            lastValue4UniqueValues  = self.createFaceUniqueIdentifiers(lastValueUsed: lastValue4UniqueValues, face: face)
        }
        
        print(self.facesItemsPositions)
    }
    /*rotation last approach start here
     i alrready have each face (item,position), rotating a column or row must be as simple as get 4 face involved in rotation and change items positions, each face neiborg wil get data of previus face depending in move orientation
     */
    func getFacesInvolvedInRotation(faceOfMoveOrigin:Face,columnMove:cubeColumnMove,moveOrigin:MoveOrigin)->Array<Face>{
        //faceOfMoveOrigin:like touched face in a move to pivote for moving, they are  supposed to be append in order
        var faces = Array<Face>()
        faces.append(faceOfMoveOrigin)
        var lastFace = faceOfMoveOrigin
        let item = CubeItem()
        for _ in 1...3{
            let f = item.rotations[columnMove]![moveOrigin]![lastFace]!
            faces.append(f)
            lastFace = f
        }
        return faces
    }
    func getColumnRowPositionAfterRotationOf(degrees:degrees)->[Int:Int]{//column/row 1 for 90 dgrss wil move to 2, [1:2,2:3,3:4,4:1]etc
        guard degrees != .D360 else{
            return [:]
        }
        var res:[Int:Int] = [:]
        let advaceBy = degrees.rawValue
        for n in 0..<4{
            res[n] = (n < (4-advaceBy) ? n+advaceBy:advaceBy-(4-n))
            
        }
        print(res)
        return res
        
    }
    func ROTATE(faceOfMoveOrigin:Face,columnMove:cubeColumnMove,moveOrigin:MoveOrigin,index:Int,degrees:degrees)->[Int:CubeColor]{
        //have to document how only a faceOfMoveOrigin have sence for some columnMove and moveOrigin like side vertical only for origin face right or left
        let facesInvolved =  self.getFacesInvolvedInRotation(faceOfMoveOrigin: faceOfMoveOrigin, columnMove: columnMove, moveOrigin: moveOrigin)
        guard facesInvolved.count == 4 else{
            return [:]
        }
        var uniquePositionsColors:[Int:CubeColor] = [:]
        let newPositionsToColumns =  getColumnRowPositionAfterRotationOf(degrees:degrees)
        var orientation = RotationOrientation.ClockWise
        var itemsToBeOverride:[Int:CubeItem] = [:]
        var rotatedItems:Array<Int> = Array<Int>.init()
        var avoiding = Array<Int>.init()
        for i in 0..<facesInvolved.count{
            var actualRotatedItems:Array<Int> = Array<Int>.init()
            let originFaceData:(Array<Int>,[Int:Int])!
            var destinyFaceData:(Array<Int>,[Int:Int])!
            var tempUniquePositionsColors:[Int:CubeColor] = [:]
            if (columnMove == .Vertical || columnMove == .VerticalP){
                originFaceData = self.getColumnOf(face: facesInvolved[i], columnNumber:index,moveOrigin:moveOrigin,cubeColumnMove:columnMove)
                destinyFaceData = self.getColumnOf(face: facesInvolved[newPositionsToColumns[i]!], columnNumber:index,moveOrigin:moveOrigin,cubeColumnMove:columnMove)
            }else{
                originFaceData = self.getRowOf(face: facesInvolved[i], rowNumber: index,moveOrigin:moveOrigin,cubeColumnMove:columnMove)
                destinyFaceData = self.getRowOf(face: facesInvolved[newPositionsToColumns[i]!], rowNumber: index,moveOrigin:moveOrigin,cubeColumnMove:columnMove)
            }
            orientation = columnMove == .VerticalP || columnMove == .HorizontalP ? RotationOrientation.OppClockWise:orientation
            if (i > 0 && i < facesInvolved.count-1){
                avoiding.append(destinyFaceData.0[0])//para remover jiro redundante
            }
            if (i==facesInvolved.count-1){
                avoiding.append(destinyFaceData.0[0])
                avoiding.append(destinyFaceData.0[destinyFaceData.0.count-1])
            }
            (itemsToBeOverride,actualRotatedItems,tempUniquePositionsColors) = self.exchangeFaces(origin: originFaceData.0, originItems: originFaceData.1, destination: destinyFaceData.0, destinationItems: destinyFaceData.1, columnMove:columnMove,fromFace:facesInvolved[i],toFace:facesInvolved[newPositionsToColumns[i]!],degrees:degrees,moveOrigin:moveOrigin,items: itemsToBeOverride,avoiding: avoiding,alreadyRotatedItems:rotatedItems)
            rotatedItems+=actualRotatedItems
            for key in tempUniquePositionsColors.keys{
                uniquePositionsColors[key] = tempUniquePositionsColors[key]
            }
            avoiding.removeAll()//not  used
        }
        return uniquePositionsColors
        
    }
    func exchangeFaces(origin:Array<Int>,originItems:[Int:Int ],destination:Array<Int>, destinationItems:[Int:Int],columnMove:cubeColumnMove,fromFace:Face,toFace:Face,degrees:degrees,moveOrigin:MoveOrigin,items:[Int:CubeItem],avoiding:Array<Int>,alreadyRotatedItems:Array<Int>)->([Int:CubeItem],Array<Int>,[Int:CubeColor]){
        var uniquePositionsColors:[Int:CubeColor] = [:]
        var rotatedItems:Array<Int> = Array<Int>.init()
        var itemsToBeOverride:[Int:CubeItem] = items
        for i in destinationItems.keys{
            if alreadyRotatedItems.contains(destinationItems[i]!){
                continue
            }
            itemsToBeOverride[destinationItems[i]!] = self.cubeItems[destinationItems[i]!]
            rotatedItems.append(destinationItems[i]!)
            self.cubeItems[destinationItems[i]!]=itemsToBeOverride[originItems[i]!] != nil ? itemsToBeOverride[originItems[i]!]! : self.cubeItems[originItems[i]!]
            let vectorDirections = self.cubeItems[destinationItems[i]!].proccessRotation(degrees: degrees, direction: columnMove, moveOrigin:moveOrigin)
            for key in vectorDirections.keys{
                if let v = self.faceUniqueIdentifiers[key]?[destinationItems[i]!]{
                    uniquePositionsColors[v] = vectorDirections[key]
                }
            }
        }
        return (itemsToBeOverride,rotatedItems,uniquePositionsColors)
    }
    func getInitialColorForUniqueIdentifiers()->Dictionary<Int,CubeColor
    >{//initial color must be set if consuming this func, validate that
        var result:[Int:CubeColor] = [:]
        for face in self.faces{
            for (key,val) in self.getColorForIdentifiersInitialCube(face: face).enumerated(){
                result[val.key] = val.value
            }
        }
        return result
    }
    func getColorForIdentifiersInitialCube(face:Face)->Dictionary<Int,CubeColor>{
        var result:Dictionary<Int,CubeColor> = [:]
        var initialColor:CubeColor? = nil
        if let initColors = self.facesInitialColors[face]{
            if initColors.count > 0{
                initialColor = initColors[0]
            }else{
                return [:]
            }
        }
        guard let faceIdemtifiers = self.faceUniqueIdentifiers[face] else{
            return [:]
        }
        for (key,val) in faceIdemtifiers.enumerated(){
            result[val.value] = initialColor
        }
        return result
    }
    func getColumnOf(face:Face,columnNumber:Int,moveOrigin:MoveOrigin,cubeColumnMove:cubeColumnMove)->(Array<Int>,[Int:Int]){
        var data = self.facesItemsPositions[face]
        var localcubeColumnMove =  cubeColumnMove == .VerticalP ? .Vertical : cubeColumnMove
        localcubeColumnMove =  localcubeColumnMove == .HorizontalP ? .Horizontal : localcubeColumnMove
        if (self.itemsPositiosForRotations[localcubeColumnMove]?[moveOrigin]?[face] != nil){
            data = self.itemsPositiosForRotations[localcubeColumnMove]?[moveOrigin]?[face]
        }
        guard let faceItems  = data else{
            return ([],[:])
        }
        var columnPositions = Array<Int>()
        let position = columnNumber - 1
        var itemsPositions = [Int:Int]()
        for i in 0..<self.baseHeight{
            columnPositions.append(position+self.baseWidth*i)
            itemsPositions[position+self.baseWidth*i] = faceItems[position+self.baseWidth*i]
        }
        return (columnPositions,itemsPositions)
    }
    
    func getRowOf(face:Face,rowNumber:Int,moveOrigin:MoveOrigin,cubeColumnMove:cubeColumnMove)->(Array<Int>,[Int:Int]){
        var data = self.facesItemsPositions[face]
        if (self.itemsPositiosForRotations[cubeColumnMove]?[moveOrigin]?[face] != nil){
            data = self.itemsPositiosForRotations[cubeColumnMove]?[moveOrigin]?[face]
        }
        guard let faceItems  = data else{
            return ([],[:])
        }
        var itemsPositions = [Int:Int]()
        var columnPositions = Array<Int>()
        let position = (rowNumber - 1)*self.baseWidth//
        for i in 0..<self.baseWidth{
            columnPositions.append(position+i)
            itemsPositions[position+i] = faceItems[position+i]
        }
        return (columnPositions,itemsPositions)
    }
    //rotating approach ends here
    
    func setColumnWithItemPositions(){
        /*columsItemsPositions:[MoveOrigin:[cubeColumnMove:[Int:Array<Int>]]]
         it mattters to know every column(considering  a base fase, what items represent a column, is important if it is frontal<->ventica(p)<->frontal(horizontal(p),side<->Vertical(p)))), consider that rotating the entire cube will represent that movements (frontal vertical for column 1 will be a diferent thing) but i can be like many column moves, not efficeincy as well,
         note: a*/
        //White as base.
        /*let frontFace = self.base.1
         func set(mo:MoveOrigin,cCM:cubeColumnMove,leftBoundry:Int,rightBoundry:Int)->Bool{
         guard leftBoundry<rightBoundry else{
         return false
         }
         for i in leftBoundry..<rightBoundry{//0 or 1 , to baseHeight/baseWidth/cubeHeight
         self.columsItemsPositions[mo] = [:]
         self.columsItemsPositions[mo]?[cCM] = [:]
         if (mo == .Frontal && cCM == .Vertical){
         let rowsCount = self.baseWidth!//must be dinamyc base, like this just work for nxnxn cube
         self.reverseRowsFor(arrayData: self.getColumnNumericRepresentation(columnPos: i, moveOrigin: mo, cubeColumnMove: cCM), rowsCount: rowsCount, rowLength: rowsCount)
         }else if(mo == .Frontal && cCM == .Vertical){
         
         }else{
         
         }
         
         self.columsItemsPositions[mo]![cCM]![i] = self.getColumnNumericRepresentation(columnPos: i, moveOrigin: mo, cubeColumnMove: cCM)
         print("$$$$$")
         print("MoveOrigin : \(mo), cubeColumnMove: \(cCM) i=\(i)")
         print(self.columsItemsPositions[mo]![cCM]![i])
         }
         return true
         }
         set(mo: .Frontal, cCM: .Vertical, leftBoundry: 0, rightBoundry: self.baseWidth)
         set(mo: .Side, cCM: .Vertical, leftBoundry: 0, rightBoundry: self.baseHeight)
         set(mo: .Frontal, cCM: .Horizontal, leftBoundry: 0, rightBoundry: self.cubeHeight)*/
    }
    func setFacesIndexData(){
        for face in self.faces{
            self.facesIndexData[face] = self.getFaceNumericRepresentation(face: face)
        }
    }
    //brings an specific face index(of the cube) in an array(it is use for faces)
    func getFaceNumericRepresentation(face:Face)->Array<Int>{
        guard let faceColRowPos = self.faceColRowPos[face] else{
            return []
        }
        switch face {
        case Face.Front,Face.Back:
            return self.getSideVerticalColumn(columnNumber: faceColRowPos)
        case Face.Up,Face.Down:
            return  self.getHorizontalCollumn(columnNumber: faceColRowPos)
        default:
            return self.getVerticalColumn(columnNumber: faceColRowPos)
        }
    }
    //a generic function, to get necesary initial representation of tha cube items state
    func getColumnNumericRepresentation(columnPos:Int,moveOrigin:MoveOrigin,cubeColumnMove:cubeColumnMove)->Array<Int>{
        if moveOrigin == .Frontal && (cubeColumnMove == .VerticalP || cubeColumnMove == .Vertical){
            return self.getVerticalColumn(columnNumber: columnPos)
        }
        else if moveOrigin == .Frontal  && (cubeColumnMove == .Horizontal || cubeColumnMove == .HorizontalP){
            return  self.getHorizontalCollumn(columnNumber: columnPos)
        }
        else{
            return self.getSideVerticalColumn(columnNumber: columnPos)
        }
    }
    func getPartsCount()->[partType:Int]{//now only
        return [.Corner:8,.Arist:self.cubeUnitsZise-8-self.faces.count,.Center:self.faces.count*((self.baseWidth-2)*(self.cubeHeight-2)),]//fix for not equal faces cube
    }
    //brings just corners and centers, otherwise, they are arist
    func setItemsAndPartsPositions(){
        self.partsPositions[partType.Corner] = self.CreateCornerIntemsAndgetFaceCornerPeacesPositions()
        self.partsPositions[partType.Center] = self.CreateCenterIntemsAndgetFaceCenterPeacesPositions()
        //arist still missing
        
    }
    /*if i get the pocitions of a fece centers, no need to do it again, just use getFaceNumericRepresentation func,and  with the same indexs for every out layer
     (may be more efficient if we return cubeItems from here enstead of only the index they centers will be, or best , set  item of the index with values in here )*/
    func CreateCornerIntemsAndgetFaceCornerPeacesPositions()->Array<Int>{
        /*
         0:2,0,7
         */
        let corners_increment = (baseHeight*self.baseWidth)*(self.cubeHeight-1)//for top corners
        self.createCornerItemAt(index: 0, vData: [(Face.Front,self.baseWidth-1),(Face.Down,self.baseWidth*self.baseHeight-1),(Face.Right,0)])//face 1
        self.createCornerItemAt(index: self.baseHeight-1, vData: [(Face.Right,self.baseHeight-1),(Face.Down,self.baseWidth-1),(Face.Back,0)])//face 2
        self.createCornerItemAt(index: (self.baseHeight*self.baseWidth)-self.baseHeight, vData: [(Face.Front,0),(Face.Left,self.baseHeight-1),(Face.Down,(self.baseHeight*self.baseWidth)-self.baseWidth)])//face 3
        self.createCornerItemAt(index: self.baseHeight*self.baseWidth-1, vData: [(Face.Left,0),(Face.Down,0),(Face.Back,self.baseWidth-1)])//face 4
        self.createCornerItemAt(index: 0+corners_increment, vData: [(Face.Front,self.baseWidth*self.baseHeight-1),(Face.Right,(self.baseHeight*self.cubeHeight)-self.baseHeight),(Face.Up,self.baseWidth-1)])//face 5
        self.createCornerItemAt(index:self.baseHeight-1+corners_increment, vData: [(Face.Right,(self.baseHeight*self.cubeHeight)-1),(Face.Up,(self.baseWidth*self.baseHeight)-1),(Face.Back,(self.baseWidth*self.cubeHeight)-self.baseWidth)])//face 6
        self.createCornerItemAt(index: (self.baseHeight*self.baseWidth)-self.baseHeight+corners_increment, vData: [(Face.Front,(self.baseWidth*self.baseHeight)-self.baseWidth),(Face.Left,self.baseHeight*self.baseHeight-1),(Face.Up,0)])//face 7
        self.createCornerItemAt(index: self.baseHeight*self.baseWidth-1+corners_increment, vData: [(Face.Left,(self.baseHeight*self.baseHeight)-self.baseHeight),(Face.Up,(self.baseWidth*self.baseHeight)-self.baseWidth),(Face.Back,self.baseWidth*self.cubeHeight-1)])//face 8
        return [0,self.baseHeight-1,(self.baseHeight*self.baseWidth)-self.baseHeight,self.baseHeight*self.baseWidth-1,0+corners_increment,self.baseHeight-1+corners_increment,(self.baseHeight*self.baseWidth)-self.baseHeight+corners_increment,self.baseHeight*self.baseWidth-1+corners_increment]
    }
    func getFakeItemsPositions()->Array<Int>{//not real peaces, in a 3x3x3 like 13, 4x4x4 =  21,22,
        var result = Array<Int>()
        var position = self.baseWidth*self.baseHeight+self.baseHeight+1//13 for 3x3x3, 21 for 4x4x4
        for i in 1..<self.cubeHeight-1{
            for _ in 1..<self.baseWidth-1{
                for _ in 1..<self.baseHeight-1{
                    result.append(position)
                    position+=1
                }
                position+=3
            }
            position = (self.baseWidth*self.baseHeight)*(i+1)+self.baseHeight+1
        }
        return result
    }
    func createCornerItemAt(index:Int,vData:Array<(face:Face,facePosition:Int)>){
        let corner = CubeItem(cubePart: partType.Corner)
        var itemVectors = Array<Vector>()
        for faceData in vData{
            itemVectors.append(Vector.init(vectorDirection: faceData.face, color: self.facesInitialColors[faceData.face]![faceData.facePosition], base: self.isBase(face: faceData.face)))
        }
        corner.setVectorsWith(data: itemVectors)
        self.cubeItems[index] = corner
    }
    func CreateCenterIntemsAndgetFaceCenterPeacesPositions()->Array<Int>{
        var result = Array<Int>()
        var position = self.baseWidth+1
        var oneFaceCenters = Array<Int>()
        for i in 1..<self.cubeHeight-1{
            for _ in 1..<self.baseWidth-1{
                oneFaceCenters.append(position)
            }
            position=i*self.baseWidth+1
        }
        for face in self.faces{
            let xFace = self.getFaceNumericRepresentation(face: face)
            for centerPos in oneFaceCenters{
                let cubeItem = CubeItem(cubePart: .Center)
                var itemVectors = Array<Vector>()
                result.append(xFace[centerPos])
                itemVectors.append(Vector.init(vectorDirection: face, color: self.facesColor[face]!, base: self.isBase(face: face)))
                cubeItem.setVectorsWith(data: itemVectors)
                self.cubeItems[xFace[centerPos]] = cubeItem
                
            }
            
            
        }
        return result
    }
    func setFacesInitialColors(){
        self.facesInitialColors[.Front] = Array<CubeColor>()
        self.facesInitialColors[.Right] = Array<CubeColor>()
        self.facesInitialColors[.Up] = Array<CubeColor>()
        self.facesInitialColors[.Left] = Array<CubeColor>()
        self.facesInitialColors[.Back] = Array<CubeColor>()
        self.facesInitialColors[.Down] = Array<CubeColor>()
        /*self.facesInitialColors[.Front] = Array.init(repeating: .White, count: self.baseWidth*self.cubeHeight)
         self.facesInitialColors[.Right] = Array.init(repeating: .Red, count: self.baseHeight*self.cubeHeight)
         self.facesInitialColors[.Up] = Array.init(repeating: .Blue, count: self.baseHeight*self.baseHeight)
         self.facesInitialColors[.Left] = Array.init(repeating: .Yellow, count: self.baseHeight*self.cubeHeight)
         self.facesInitialColors[.Back] = Array.init(repeating: .Orange, count: self.baseWidth*self.cubeHeight)
         self.facesInitialColors[.Down] = Array.init(repeating: .Green, count: self.baseHeight*self.baseHeight)*/
        /*Firs Scramble
         self.facesInitialColors[.Front] = [.Yellow,.Yellow,.Blue,.White,.Green,.Blue,.White,.Orange,.Red]
         self.facesInitialColors[.Right] = [.Red,.Blue,.Blue,.Red,.Red,.White,.Green,.Green,.Orange]
         self.facesInitialColors[.Up] = [.Blue,.Yellow,.Yellow,.Yellow,.White,.Orange,.Red,.Red,.White]
         self.facesInitialColors[.Left] = [.Orange,.Orange,.Blue,.Red,.Orange,.Green,.Green,.Blue,.Orange]
         self.facesInitialColors[.Back] = [.Orange,.Red,.Yellow,.Orange,.Blue,.Yellow,.Green,.Green,.White]
         self.facesInitialColors[.Down] = [.Green,.White,.Yellow,.Blue,.Yellow,.White,.Red,.Green,.White]
         */
        /*self.facesInitialColors[.Front] = [.Orange,.Yellow,.Yellow,.Blue,.Green,.Orange,.White,.White,.White]
        self.facesInitialColors[.Right] = [.Green,.Red,.Red,.Green,.Red,.Yellow,.Orange,.Red,.Yellow]
        self.facesInitialColors[.Up] = [.Red,.Blue,.Green,.Blue,.White,.Yellow,.Yellow,.Green,.Red]
        self.facesInitialColors[.Left] = [.Yellow,.Blue,.White,.Green,.Orange,.Yellow,.Blue,.Red,.Blue]
        self.facesInitialColors[.Back] = [.Green,.Orange,.Green,.Green,.Blue,.Red,.Blue,.White,.Orange]
        self.facesInitialColors[.Down] = [.Orange,.White,.White,.Orange,.Yellow,.White,.Blue,.Orange,.Red]*/
        self.facesInitialColors[.Front] = [.Green,.Green,.Green,.Green,.Green,.Green,.Green,.Green,.Green]
        self.facesInitialColors[.Right] = [.Red,.Red,.Red,.Red,.Red,.Red,.Red,.Red,.Red]
        self.facesInitialColors[.Up] = [.White,.White,.White,.White,.White,.White,.White,.White,.White]
        self.facesInitialColors[.Left] = [.Orange,.Orange,.Orange,.Orange,.Orange,.Orange,.Orange,.Orange,.Orange]
        self.facesInitialColors[.Back] = [.Blue,.Blue,.Blue,.Blue,.Blue,.Blue,.Blue,.Blue,.Blue]
        self.facesInitialColors[.Down] = [.Yellow,.Yellow,.Yellow,.Yellow,.Yellow,.Yellow,.Yellow,.Yellow,.Yellow]
    }
    func createCubeFromScreensShots(){
        //becauce is a cube, to determinate the state from images, only edges will need of two or three faces to determinate the state of a cube item, inner items only have a vector(color)
        //we will calculate every row of the cube, we loop from 0 to cubeHeight-1 wich is
        self.setItemsAndPartsPositions()//.arist and .center positioon in cube already save
        let fakeItemsPos = self.getFakeItemsPositions()
        for i in 0..<self.baseWidth*self.baseHeight*self.cubeHeight{
            if (self.cubeItems[i].type == nil){//if false, is because  this index is not set yet, so is .arist, an alternative way is look for self.cubeItems[i] in self.partsPositions[.Corner] and self.partsPositions[.Center] if not there, is an .Arist
                
                if !fakeItemsPos.contains(i){//si no es una posicion falsa
                    self.calculateFacesAndColorFor(index:i,partType:.Arist)//only calculate arist, consider removing parameter in function
                }else{
                    print("Fake Item=====================> \(i)")//dosent exist
                }
            }
        }
    }
    
    //determinate if a face is been use as a base
    func isBase(face:Face)->Bool{
        return self.base.face == face ? true:false
    }
    /*this function  given a index of the cube, will return the faces and respective colors for this faces, expl. centers will have one vector and tha same color of the face .
     it may be only use for partType.arist, nut sure now.
     i have to doit arist by arist becouse arist are the remaining from other peaces(centesr and corners)*/
    func calculateFacesAndColorFor(index:Int,partType:partType){
        let cubeItem = CubeItem(cubePart: partType)
        var itemVectors = Array<Vector>()
        if partType == .Arist{
            var foundedFaceVectors = 0
            for face in faces{
                if self.facesIndexData[face] == nil{
                    continue
                }
                for item in self.facesItemsPositions[face]!{
                    if item.value == index{
                        //we will found a match 2 times for each arist
                        //to get the index(to get the color in this face) i use a variable that will count from 0 to the number that represents the
                        //aristData[]
                        itemVectors.append(Vector.init(vectorDirection: face, color: self.facesInitialColors[face]! [item.key], base: self.isBase(face: face)))
                        foundedFaceVectors+=1
                    }
                }
                if foundedFaceVectors == Int(partType.rawValue){//we have found all vector for actual arist, we are done
                    continue
                }
            }
        }
        cubeItem.setVectorsWith(data: itemVectors)
        self.cubeItems[index] = cubeItem
        
    }
    //brings the entire column,
    func getVerticalColumn(columnNumber:Int)->Array<Int>{
        var result = Array<Int>()
        var i = 0
        while(i<self.cubeHeight){
            for n in 0..<baseWidth{
                result.append(i*baseWidth*baseHeight+n+columnNumber*baseWidth)
            }
            i=i+1
            
        }
        return result
    }
    
    //brings every individual row of an specific column as an array
    func getHorizontalColumnAsArray(columnNumber:Int)->Array<Array<Int>>{
        var result  = Array<Array<Int>>()
        var i = 0
        while(i<cubeHeight){
            var columnLine = Array<Int>()
            for n in 0..<baseWidth{
                //columnLine.append(cubeItems[i*baseWidth*baseHeight]+n+columnNumber*baseWidth)
                columnLine.append(i*baseWidth*baseHeight+n+columnNumber*baseWidth)
            }
            i=i+1
            result.append(columnLine)
        }
        return result
    }
    //havin a column, get ortogonal columns or verical columns from a side, of the enire cube
    func getSpecificHorizontalColumnAsArray(columnNumber:Int,row:Int)->Array<Int>{
        var result = Array<Int>()
        for column in getHorizontalColumnAsArray(columnNumber:columnNumber){
            result.append(column[row-1])
        }
        return result
    }
    //of the entire club
    func getSpecificVerticalColumnAsArray(columnNumber:Int,row:Int)->Array<Int>{
        if (self.cubeItems.count >  columnNumber){
            return []
        }
        return getHorizontalColumnAsArray(columnNumber:columnNumber)[row-1]
    }
    
    //-------------------------------1END---------------------------------
    //having a pespective front,considering the a side , gets the vertical column(first column 0,0+1,0+2 ), of the entire cube
    func getSideVerticalColumn(columnNumber:Int)->Array<Int>{
        var result = Array<Int>()
        for n in 0..<self.cubeHeight*self.baseHeight{
            result.append(n*baseHeight+columnNumber)
        }
        return result
    }
    //of the entire cube
    func getHorizontalCollumn(columnNumber:Int)->Array<Int>{
        var result = Array<Int>()
        for n in 0..<self.baseWidth*self.baseHeight{
            result.append(columnNumber*baseWidth*baseHeight+n)
        }
        return result
    }
    
    
}
