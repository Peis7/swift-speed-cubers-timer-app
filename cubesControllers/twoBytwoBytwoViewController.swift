//
//  twoBytwoBytwoViewController.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 28/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class twoBytwoBytwoViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var scrableDescription: UILabel!
    @IBOutlet weak var movesLogs: UITextView!
    @IBOutlet weak var itemUpP4: UIImageView!
    @IBOutlet weak var itemUpP5: UIImageView!
    @IBOutlet weak var itemUpP6: UIImageView!
    @IBOutlet weak var itemUpP7: UIImageView!
    @IBOutlet weak var itemFrontP4: UIImageView!
    @IBOutlet weak var itemRightP5: UIImageView!
    @IBOutlet weak var itemRightP4: UIImageView!
    @IBOutlet weak var itemFrontP6: UIImageView!
    @IBOutlet weak var itemBackP5: UIImageView!
    @IBOutlet weak var itemBackP7: UIImageView!
    @IBOutlet weak var itemLeftP6: UIImageView!
    @IBOutlet weak var itemLeftP7: UIImageView!
    var cubeScrableMove:cubeScrableMove!
    var Bokin2:RubikCube!
    var scrabler:Scrabler!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrabler = Scrabler(verticalMoves: ["R2","L","LPrime","U2","R","RPrime","U","UPrime","L2"], moves4Scrable: 20, horizontalMoves:["F","F2","B","FPrime","D2","BPrime","D","DPrime","B2"])
        let bokinItems = Array<CubeItem>()
        Bokin2 = RubikCube(baseWidth: 2, baseHeight: 2, cubeHeight: 2, uniqueIdentifiersStartPosition: 1000, items: bokinItems )
        Bokin2.createCubeFromScreensShots()
        self.setImagestags()
        self.addGestureRecognizers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func EXECRotation(faceOfMoveOrigin:Face,columnMove:cubeColumnMove,moveOrigin:MoveOrigin,index:Int,degrees:degrees){
        let r1 = Bokin2.ROTATE(faceOfMoveOrigin: faceOfMoveOrigin, columnMove: columnMove, moveOrigin: moveOrigin, index: index, degrees: degrees)
        for tag in r1.keys{
            if  let imageView = self.view.viewWithTag(tag) as? UIImageView{
                imageView.backgroundColor = UICubeColors[r1[tag]!]
            }
        }
    }
    
    func setImagestags(){
        self.itemUpP4.tag = (Bokin2.faceUniqueIdentifiers[Face.Up]?[4])!
        self.itemUpP5.tag = (Bokin2.faceUniqueIdentifiers[Face.Up]?[5])!
        self.itemUpP6.tag = (Bokin2.faceUniqueIdentifiers[Face.Up]?[6])!
        self.itemUpP7.tag = (Bokin2.faceUniqueIdentifiers[Face.Up]?[7])!
        self.itemFrontP4.tag = (Bokin2.faceUniqueIdentifiers[Face.Front]?[4])!
        self.itemFrontP6.tag = (Bokin2.faceUniqueIdentifiers[Face.Front]?[6])!
        self.itemBackP5.tag = (Bokin2.faceUniqueIdentifiers[Face.Back]?[5])!
        self.itemBackP7.tag = (Bokin2.faceUniqueIdentifiers[Face.Back]?[7])!
        self.itemLeftP6.tag = (Bokin2.faceUniqueIdentifiers[Face.Left]?[6])!
        self.itemLeftP7.tag = (Bokin2.faceUniqueIdentifiers[Face.Left]?[7])!
        self.itemRightP4.tag = (Bokin2.faceUniqueIdentifiers[Face.Right]?[4])!
        self.itemRightP5.tag = (Bokin2.faceUniqueIdentifiers[Face.Right]?[5])!
    }
    func getGestureRecognizers(selector:String,direction:UISwipeGestureRecognizerDirection)->UISwipeGestureRecognizer{
        let s = NSSelectorFromString(selector)
        let GR = UISwipeGestureRecognizer(target: self, action: s)
        GR.direction = direction
        return GR
    }
    @objc func B() {//B
        self.movesLogs.text = "\(self.movesLogs.text!) , B"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 1, degrees: .D90)
    }
    
    @objc func BPrime() {
        self.movesLogs.text = "\(self.movesLogs.text!) , B'"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 1, degrees: .D90)
    }
    
    @objc func U( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .HorizontalP, moveOrigin: .Frontal, index: 2, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , U"
    }
    @objc func UPrime( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Horizontal, moveOrigin: .Frontal, index: 2, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , U'"
    }
    @objc func F( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , F"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 2, degrees: .D90)
    }
    
    @objc func FPrime( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , F'"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 2, degrees: .D90)
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
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 2, degrees: .D90)
    }
    @objc func RPrime( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , R'"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 2, degrees: .D90)
    }
    
    
    
    func addGestureRecognizers(){
        self.itemUpP6.addGestureRecognizer(self.getGestureRecognizers(selector: "F", direction: .right))
         self.itemUpP4.addGestureRecognizer(self.getGestureRecognizers(selector: "F", direction: .right))
        self.itemUpP5.addGestureRecognizer(self.getGestureRecognizers(selector: "BPrime", direction: .right))
        self.itemUpP7.addGestureRecognizer(self.getGestureRecognizers(selector: "BPrime", direction: .right))
        self.itemUpP6.addGestureRecognizer(self.getGestureRecognizers(selector: "FPrime", direction: .left))
        self.itemUpP4.addGestureRecognizer(self.getGestureRecognizers(selector: "FPrime", direction: .left))
        self.itemUpP5.addGestureRecognizer(self.getGestureRecognizers(selector: "B", direction: .left))
        self.itemUpP7.addGestureRecognizer(self.getGestureRecognizers(selector: "B", direction: .left))
        self.itemUpP6.addGestureRecognizer(self.getGestureRecognizers(selector: "LPrime", direction: .up))
        self.itemUpP4.addGestureRecognizer(self.getGestureRecognizers(selector: "R", direction: .up))
        self.itemUpP5.addGestureRecognizer(self.getGestureRecognizers(selector: "R", direction: .up))
        self.itemUpP7.addGestureRecognizer(self.getGestureRecognizers(selector: "LPrime", direction: .up))
        self.itemUpP6.addGestureRecognizer(self.getGestureRecognizers(selector: "L", direction: .down))
        self.itemUpP4.addGestureRecognizer(self.getGestureRecognizers(selector: "RPrime", direction: .down))
        self.itemUpP5.addGestureRecognizer(self.getGestureRecognizers(selector: "RPrime", direction: .down))
        self.itemUpP7.addGestureRecognizer(self.getGestureRecognizers(selector: "L", direction: .down))
        self.itemUpP4.isUserInteractionEnabled = true
        self.itemUpP5.isUserInteractionEnabled = true
        self.itemUpP6.isUserInteractionEnabled = true
        self.itemUpP7.isUserInteractionEnabled = true
        let emtireCubeMoveGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rotateEntireCube))
        emtireCubeMoveGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(emtireCubeMoveGestureRecognizer)
        self.view.isUserInteractionEnabled = true
    }
    
    @IBAction func doScrable(_ sender: Any) {
        var scrableText = ""
        var moveData:[String:UISwipeGestureRecognizerDirection] = ["R2":.up,"L":.down,"LPrime":.up,"U2":.right,"R":.up,"RPrime":.down,"U":.left,"UPrime":.right,"L2":.up,"F":.right,"F2":.right,"B":.left,"FPrime":.left,"D2":.right,"BPrime":.right,"D":.right,"DPrime":.left,"B2":.up]
        let res =  self.scrabler.generateScrable()
        for n in res{
            scrableText+="\(n.replacingOccurrences(of: "Prime", with: "'")) "
        }
        self.scrableDescription.text =  scrableText
        
    }
    
    func rotateEntireCube(_ gestureRecognizer: UISwipeGestureRecognizer){
        switch gestureRecognizer.direction {
        case .up:
            print("Up")
        case .down:
            print("Down")
        case .right:
            print("Right")
        case .left:
            print("Right")
        default:
            print("Defaul")
        }
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
