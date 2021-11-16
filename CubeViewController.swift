//
//  CubeViewController.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 25/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit


class CubeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var movesLogs: UITextView!
    @IBOutlet weak var itemP26: UIImageViewCubeItem!
    @IBOutlet weak var itemP23: UIImageViewCubeItem!
    @IBOutlet weak var itemP20: UIImageViewCubeItem!
    @IBOutlet weak var itemP19: UIImageViewCubeItem!
    @IBOutlet weak var itemP22: UIImageViewCubeItem!
    @IBOutlet weak var itemP25: UIImageViewCubeItem!
    @IBOutlet weak var itemP18: UIImageViewCubeItem!
    @IBOutlet weak var itemP21: UIImageViewCubeItem!
    @IBOutlet weak var itemP24: UIImageViewCubeItem!
    @IBOutlet weak var itemRight20: UIImageViewCubeItem!
    @IBOutlet weak var itemUp20: UIImageViewCubeItem!
    @IBOutlet weak var itemRight19: UIImageViewCubeItem!
    @IBOutlet weak var itemRight18: UIImageViewCubeItem!
    @IBOutlet weak var itemUp26: UIImageViewCubeItem!
    @IBOutlet weak var itemUp23: UIImageViewCubeItem!
    @IBOutlet weak var itemFront18: UIImageViewCubeItem!
    @IBOutlet weak var itemFront21: UIImageViewCubeItem!
    @IBOutlet weak var itemFront24: UIImageViewCubeItem!
    @IBOutlet weak var itemLeft26: UIImageViewCubeItem!
    @IBOutlet weak var itemLeft25: UIImageViewCubeItem!
    @IBOutlet weak var itemLeft24: UIImageViewCubeItem!
    var lastRotationValue:CGFloat? = nil
    var valueOfActuaRotation:Float! = 0//if 0.5, rotate the cube
    
    var fZero: UIImageViewCubeItem? = nil
    var Bokin1:RubikCube!
    override func viewDidLoad() {
        super.viewDidLoad()
        let bokinItems = Array<CubeItem>()
        Bokin1 = RubikCube(baseWidth: 3, baseHeight: 3, cubeHeight: 3, uniqueIdentifiersStartPosition: 1000, items: bokinItems )
        Bokin1.createCubeFromScreensShots()
        fZero = UIImageViewCubeItem(frame: CGRect(x: 20, y: 20, width: 35, height: 35))
        fZero?.backgroundColor = UIColor.orange
        //self.view.addSubview(fZero!)
        // Do any additional setup after loading the view.
        self.setImagestags()
        self.addGestureRecognizers()
    }
    func setImagestags(){
        self.itemP24.tag = (Bokin1.faceUniqueIdentifiers[Face.Up]?[24])!
        self.itemP21.tag = (Bokin1.faceUniqueIdentifiers[Face.Up]?[21])!
        self.itemP18.tag = (Bokin1.faceUniqueIdentifiers[Face.Up]?[18])!
        self.itemP25.tag = (Bokin1.faceUniqueIdentifiers[Face.Up]?[25])!
        self.itemP22.tag = (Bokin1.faceUniqueIdentifiers[Face.Up]?[22])!
        self.itemP19.tag = (Bokin1.faceUniqueIdentifiers[Face.Up]?[19])!
        self.itemP26.tag = (Bokin1.faceUniqueIdentifiers[Face.Up]?[26])!
        self.itemP23.tag = (Bokin1.faceUniqueIdentifiers[Face.Up]?[23])!
        self.itemP20.tag = (Bokin1.faceUniqueIdentifiers[Face.Up]?[20])!
        self.itemRight20.tag = (Bokin1.faceUniqueIdentifiers[Face.Right]?[20])!
        self.itemUp20.tag = (Bokin1.faceUniqueIdentifiers[Face.Back]?[20])!
        self.itemRight19.tag = (Bokin1.faceUniqueIdentifiers[Face.Right]?[19])!
        self.itemRight18.tag = (Bokin1.faceUniqueIdentifiers[Face.Right]?[18])!
        self.itemUp23.tag = (Bokin1.faceUniqueIdentifiers[Face.Back]?[23])!
        self.itemUp26.tag = (Bokin1.faceUniqueIdentifiers[Face.Back]?[26])!
        self.itemLeft24.tag = (Bokin1.faceUniqueIdentifiers[Face.Left]?[24])!
        self.itemLeft25.tag = (Bokin1.faceUniqueIdentifiers[Face.Left]?[25])!
        self.itemLeft26.tag = (Bokin1.faceUniqueIdentifiers[Face.Left]?[26])!
        self.itemFront18.tag = (Bokin1.faceUniqueIdentifiers[Face.Front]?[18])!
        self.itemFront21.tag = (Bokin1.faceUniqueIdentifiers[Face.Front]?[21])!
        self.itemFront24.tag = (Bokin1.faceUniqueIdentifiers[Face.Front]?[24])!
    }
    
    func EXECRotation(faceOfMoveOrigin:Face,columnMove:cubeColumnMove,moveOrigin:MoveOrigin,index:Int,degrees:degrees){
        let r1 = Bokin1.ROTATE(faceOfMoveOrigin: faceOfMoveOrigin, columnMove: columnMove, moveOrigin: moveOrigin, index: index, degrees: degrees)
        for tag in r1.keys{
            if  let imageView = self.view.viewWithTag(tag) as? UIImageView{
                imageView.backgroundColor = UICubeColors[r1[tag]!]
            }
        }
    }
    @objc func B() {//B
        self.movesLogs.text = "\(self.movesLogs.text!) , B"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 1, degrees: .D90)
    }
    
    @objc func BPrime() {
        self.movesLogs.text = "\(self.movesLogs.text!) , B'"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 1, degrees: .D90)
    }
    
    @objc func middleSide( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , <"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 2, degrees: .D90)
    }
    @objc func middleSidePrime( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , >"
         self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 2, degrees: .D90)
    }
    
    @objc func U( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .HorizontalP, moveOrigin: .Frontal, index: 3, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , U"
    }
    @objc func UPrime( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Horizontal, moveOrigin: .Frontal, index: 3, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , U'"
    }
    @objc func F( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , F"
         self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 3, degrees: .D90)
    }
   
    @objc func FPrime( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , F'"
         self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 3, degrees: .D90)
    }
    @objc func LPrime( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , L'"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 1, degrees: .D90)
    }
    
    @objc func L( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , L"
         self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 1, degrees: .D90)
    }
    
    @objc func R( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , R"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 3, degrees: .D90)
    }
    @objc func RPrime( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , R'"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 3, degrees: .D90)
    }
    
    @objc func middleFront( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , ˆ"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 2, degrees: .D90)
    }
    @objc func middleFrontPrime( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , V"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 2, degrees: .D90)
    }
    
    func createImagesForFace(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        var x:Int = 0
        var y:Int = 0
        let itemImageViewWidth = Int((Int(screenHeight)/3)/(Bokin1.baseWidth))
        for face in Bokin1.faces{
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func getGestureRecognizers(selector:String,direction:UISwipeGestureRecognizerDirection)->UISwipeGestureRecognizer{
        let s = NSSelectorFromString(selector)
        let GR = UISwipeGestureRecognizer(target: self, action: s)
        GR.direction = direction
        return GR
    }

    func addGestureRecognizers(){
        self.itemP18.addGestureRecognizer(self.getGestureRecognizers(selector: "F", direction: .right))
        self.itemP18.addGestureRecognizer(self.getGestureRecognizers(selector: "R", direction: .up))
        self.itemP18.addGestureRecognizer(self.getGestureRecognizers(selector: "FPrime", direction: .left))
        self.itemP18.addGestureRecognizer(self.getGestureRecognizers(selector: "RPrime", direction: .down))
        self.itemP21.addGestureRecognizer(self.getGestureRecognizers(selector: "F", direction: .right))
        self.itemP21.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFront", direction: .down))
        self.itemP21.addGestureRecognizer(self.getGestureRecognizers(selector: "FPrime", direction: .left))
        self.itemP21.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrime", direction: .up))
        self.itemP24.addGestureRecognizer(self.getGestureRecognizers(selector: "F", direction: .right))
        self.itemP24.addGestureRecognizer(self.getGestureRecognizers(selector: "LPrime", direction: .up))
        self.itemP24.addGestureRecognizer(self.getGestureRecognizers(selector: "FPrime", direction: .left))
        self.itemP24.addGestureRecognizer(self.getGestureRecognizers(selector: "L", direction: .down))
        
        self.itemP19.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSidePrime", direction: .right))
        self.itemP19.addGestureRecognizer(self.getGestureRecognizers(selector: "R", direction: .up))
        self.itemP19.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSide", direction: .left))
        self.itemP19.addGestureRecognizer(self.getGestureRecognizers(selector: "RPrime", direction: .down))
        self.itemP20.addGestureRecognizer(self.getGestureRecognizers(selector: "BPrime", direction: .right))
        self.itemP20.addGestureRecognizer(self.getGestureRecognizers(selector: "R", direction: .up))
        self.itemP20.addGestureRecognizer(self.getGestureRecognizers(selector: "B", direction: .left))
        self.itemP20.addGestureRecognizer(self.getGestureRecognizers(selector: "RPrime", direction: .down))
        self.itemP22.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFront", direction: .down))
        self.itemP22.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSidePrime", direction: .right))
        self.itemP22.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrime", direction: .up))
        self.itemP22.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSide", direction: .left))
        self.itemP23.addGestureRecognizer(self.getGestureRecognizers(selector: "BPrime", direction: .right))
        self.itemP23.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrime", direction: .up))
        self.itemP23.addGestureRecognizer(self.getGestureRecognizers(selector: "B", direction: .left))
        self.itemP23.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFront", direction: .down))
        self.itemP26.addGestureRecognizer(self.getGestureRecognizers(selector: "BPrime", direction: .right))
        self.itemP26.addGestureRecognizer(self.getGestureRecognizers(selector: "LPrime", direction: .up))
        self.itemP26.addGestureRecognizer(self.getGestureRecognizers(selector: "B", direction: .left))
        self.itemP26.addGestureRecognizer(self.getGestureRecognizers(selector: "L", direction: .down))
        self.itemP25.addGestureRecognizer(self.getGestureRecognizers(selector: "LPrime", direction: .up))
        self.itemP25.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSidePrime", direction: .right))
        self.itemP25.addGestureRecognizer(self.getGestureRecognizers(selector: "L", direction: .down))
        self.itemP25.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSide", direction: .left))
        self.itemP26.isUserInteractionEnabled = true
        self.itemP25.isUserInteractionEnabled = true
        self.itemP22.isUserInteractionEnabled = true
        self.itemP18.isUserInteractionEnabled = true
        self.itemP21.isUserInteractionEnabled = true
        self.itemP24.isUserInteractionEnabled = true
        self.itemP19.isUserInteractionEnabled = true
        self.itemP20.isUserInteractionEnabled = true
         self.itemP23.isUserInteractionEnabled = true
        
        let dobleGR = UIRotationGestureRecognizer(target: self, action: #selector(Up))
        dobleGR.delegate = self
        self.view.addGestureRecognizer(dobleGR)
        self.view.isUserInteractionEnabled = true
    }
    func determineOrentation(){
        
    }
    public func Up(_ gestureRecognizer: UIRotationGestureRecognizer) -> Bool{
        if lastRotationValue == nil{
            lastRotationValue = gestureRecognizer.rotation
        }
        if (abs(lastRotationValue!-gestureRecognizer.rotation) >= 0.6){
            if lastRotationValue! < gestureRecognizer.rotation{
                self.U()
            }else{
                self.UPrime()
            }
            lastRotationValue = gestureRecognizer.rotation
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
