//
//  ViewController.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 14/3/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit
enum handImageState{
    case pressedDown
    case notPressed
    
}
class timerViewController: UIViewController {
    var Xtimer:XTimer!
    var timerLBLs:Array<UILabel>!
    var imageViewLH:UIImageView!
    var imageViewRH:UIImageView!
    var stateImageView:UIImageView!
    var running:Bool!
    var leftHandState:handImageState!
    var rightHandState:handImageState!
    var timerReady:Timer!
    var timerReadyCont = 0
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.landscape
    }
    @IBOutlet weak var laps_viewController: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewLH = UIImageView()
        imageViewRH = UIImageView()
        stateImageView = UIImageView()
        timerLBLs = Array<UILabel>()
        running = false
        self.tabBarController?.tabBar.isHidden = true
        self.leftHandState = handImageState.notPressed
        self.rightHandState = handImageState.notPressed
        
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        var labelIndex = self.addLable(fontSize: 90, initialText: "00",color:UIColor.red)
        var horas:TimeUnit = TimeUnit(name: "Horas",unit: 24,position: 3,p: nil,base:false,timerLblPointer: &self.timerLBLs[labelIndex],delimitator:" ")
        labelIndex = self.addLable(fontSize: 90, initialText: ":00",color:UIColor.green)
        var minutos:TimeUnit = TimeUnit(name: "Minutos",unit: 60,position: 2,p: &horas,base:false,timerLblPointer:  &self.timerLBLs[labelIndex],delimitator:":")
        labelIndex = self.addLable(fontSize: 90, initialText: ":00",color:UIColor.orange)
        var segundos:TimeUnit = TimeUnit(name: "Segundos",unit: 60,position: 1,p: &minutos,base:true,timerLblPointer: &self.timerLBLs[labelIndex],delimitator:":")
        labelIndex = self.addLable(fontSize: 90, initialText: ".00",color:UIColor.blue)
        let csegundos:TimeUnit = TimeUnit(name: "Centecimas de segundos",unit: 100,position: 1,p: &segundos,base:true,timerLblPointer: &self.timerLBLs[labelIndex],delimitator:".")
        self.addImageToTimerView()
        var tunits:[TimeUnit] = [TimeUnit]()
        tunits = [TimeUnit]()
        tunits.append(csegundos)
        tunits.append(segundos)
        tunits.append(minutos)
        tunits.append(horas)
        Xtimer = XTimer(tu:tunits,timeInterval:0.01)
        var tunits2:[TimeUnit] = [TimeUnit]()
        tunits2.append(csegundos)
    }
    override func viewWillLayoutSubviews() {
        self.udpdateViewsFrames()  //call after all label were saved
        self.addLabelToView()
        
        
    }
    func addLable(fontSize:CGFloat,initialText:String,color:UIColor)->Int{
        let lbfonts:UIFont = UIFont.boldSystemFont(ofSize:fontSize)
        let timerLbl = UILabel()
        //timerLbl = UILabel(frame: CGRect(x: 50, y: 100, width: 180, height: 100))
        timerLbl.textColor = color
        timerLbl.font = lbfonts
        timerLbl.text = initialText
        timerLBLs.append(timerLbl)
        return timerLBLs.count-1
        
    }
    func udpdateViewsFrames(){
        let screenHeight = self.view.frame.height
        let screenWidth = self.view.frame.width
        let timeUnitsCout = self.timerLBLs.count
        let unitWidth = (Int(screenWidth)/(timeUnitsCout+1))//add 1, to be the margin of the string at left and right,and  a margging of five between each unit must
        var Xpos = Int(unitWidth/2)
        for i in 0..<self.timerLBLs.count{
            self.timerLBLs[i].frame = CGRect(x: Xpos, y: Int(screenHeight/4), width: unitWidth, height: Int(screenHeight/4))
            Xpos+=unitWidth+10
        }
        self.imageViewLH.frame = CGRect(x: Int(screenWidth/5), y: Int(screenHeight/4)*2+10, width: Int(screenWidth/5), height: Int(screenHeight/4)*2-10)
        self.imageViewRH.frame = CGRect(x: Int(screenWidth/5)*3, y: Int(screenHeight/4)*2+10, width: Int(screenWidth/5), height: Int(screenHeight/4)*2-10)
        self.stateImageView.frame = CGRect(x: Int(screenWidth/2)-Int(30/2), y: Int(screenHeight/8), width: 30, height: 30)
        
    }
    func addLabelToView(){
        for label in self.timerLBLs{
            self.view.addSubview(label)
        }
    }
    
    @IBAction func start_timer(_ sender: Any) {
        self.Xtimer.Start()
        //self.Xtimer1.Start()
    }
    @IBAction func stop_timer(_ sender: Any) {
        self.Xtimer.Stop()
        var act_text  = ""
        if self.laps_viewController.text != nil{
            act_text = self.laps_viewController.text!
        }
        self.laps_viewController.text = "\(act_text)\(self.Xtimer.getActualTime())"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addImageToTimerView(){
        let leftHand = UIImage(named: "leftHandGesture")
        self.imageViewLH = UIImageView(image: leftHand!)
        self.imageViewLH.tag = 10
        imageViewLH.isUserInteractionEnabled = true
        self.view.addSubview(imageViewLH)
        
        let rightHand = UIImage(named: "rightHandGesture")
        self.imageViewRH = UIImageView(image: rightHand!)
        self.imageViewRH.isUserInteractionEnabled = true
        self.imageViewRH.tag = 11
        self.view.addSubview(self.imageViewRH)
        
        let timerStateImage = UIImage(named: "stoppedTimer")
        self.stateImageView = UIImageView(image: timerStateImage)
        self.view.addSubview(self.stateImageView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches{
            if touch.view?.tag == 10 || touch.view?.tag == 11{
                self.leftHandState = touch.view?.tag == 10 ? handImageState.pressedDown : self.leftHandState
                self.rightHandState = touch.view?.tag == 11 ? handImageState.pressedDown : self.rightHandState
                if self.leftHandState == handImageState.pressedDown && self.rightHandState == handImageState.pressedDown{
                    
                    if self.Xtimer.state == .Stopped{
                        self.timerReady = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkTimerCount), userInfo: nil, repeats: true)
                    }
                }
            }
           
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches{
            if touch.view?.tag == 10 || touch.view?.tag == 11{
                self.leftHandState = touch.view?.tag == 10 ? handImageState.notPressed : self.leftHandState
                self.rightHandState = touch.view?.tag == 11 ? handImageState.notPressed : self.rightHandState
                if self.leftHandState == handImageState.notPressed && self.rightHandState == handImageState.notPressed{
                    if self.Xtimer.state == .Stopped && self.timerReadyCont == 2{
                        self.Xtimer.Start()
                        self.timerReadyCont = 0
                    }else{
                        self.Xtimer.Stop()
                        self.timerReady.invalidate()
                    }
                   self.handleTimerState()
                }
                
            }
        }
        
    }
    func checkTimerCount(){
        if self.timerReadyCont == 2{
            self.timerReady.invalidate()
            self.handleTimerState()
        }else{
            self.timerReadyCont+=1
        }
    }
    func handleTimerState(){
        var imageName = ""
        if self.Xtimer.state == .Running || self.timerReadyCont == 2{
            imageName = "readyRunningTimer"
            
        }else{
            imageName = "stoppedTimer"
        }
        let timerStateImage = UIImage(named: imageName)
        self.stateImageView.image = timerStateImage
        
    }
    
    

}

