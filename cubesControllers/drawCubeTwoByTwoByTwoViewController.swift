//
//  drawCubeTwoByTwoByTwoViewController.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 30/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//  

import UIKit

class drawCubeTwoByTwoByTwoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate  {
    var imagesFace:Dictionary<Int,VectorDirection>!
    var imageHiddenColor:Dictionary<Int,UIColor>!
    var selectedColorFromPalete:UIColor!
    let imagePicker = UIImagePickerController()
    var actuallyPressedImageViewTag:Int? = nil
    @IBOutlet weak var yellowPalleteColor: UIImageView!
    @IBOutlet weak var redPalleteColor: UIImageView!
    @IBOutlet weak var orangePalleteColor: UIImageView!
    @IBOutlet weak var bluePalleteColor: UIImageView!
    @IBOutlet weak var greenPalleteColor: UIImageView!
    @IBOutlet weak var whitePalleteColor: UIImageView!
    @IBOutlet weak var movesLogs: UITextView!
    @IBOutlet weak var itemUpP4: UIImageViewCubeItem!
    @IBOutlet weak var itemUpP5: UIImageViewCubeItem!
    @IBOutlet weak var itemUpP6: UIImageViewCubeItem!
    @IBOutlet weak var itemUpP7: UIImageViewCubeItem!
    @IBOutlet weak var itemFrontP4: UIImageViewCubeItem!
    @IBOutlet weak var itemFrontP6: UIImageViewCubeItem!
    @IBOutlet weak var itemFrontP2: UIImageViewCubeItem!
    @IBOutlet weak var itemFrontP0: UIImageViewCubeItem!
    
    @IBOutlet weak var itemRightP5: UIImageViewCubeItem!
    @IBOutlet weak var itemRightP4: UIImageViewCubeItem!
    @IBOutlet weak var itemRightP1: UIImageViewCubeItem!
    @IBOutlet weak var itemRightP0: UIImageViewCubeItem!
    
    @IBOutlet weak var itemBackP5: UIImageViewCubeItem!
    @IBOutlet weak var itemBackP7: UIImageViewCubeItem!
    @IBOutlet weak var itemBackP1: UIImageViewCubeItem!
    @IBOutlet weak var itemBackP3: UIImageViewCubeItem!
    
    @IBOutlet weak var itemLeftP6: UIImageViewCubeItem!
    @IBOutlet weak var itemLeftP7: UIImageViewCubeItem!
    @IBOutlet weak var itemLeftP3: UIImageViewCubeItem!
    @IBOutlet weak var itemLeftP2: UIImageViewCubeItem!
    
    @IBOutlet weak var itemDownP2: UIImageViewCubeItem!
    @IBOutlet weak var itemDownP3: UIImageViewCubeItem!
    @IBOutlet weak var itemDownP1: UIImageViewCubeItem!
    @IBOutlet weak var itemDownP0: UIImageViewCubeItem!
    var Bokin2:RubikCube!
    var scrabler:Scrabler!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagesFace = [:]
        self.imageHiddenColor = [:]
        self.scrabler = Scrabler(verticalMoves: ["R2","L","LPrime","U2","R","RPrime","U","UPrime","L2"], moves4Scrable: 2, horizontalMoves: ["F","F2","B","FPrime","D2","BPrime","D","DPrime","B2"] )
        let bokinItems = Array<CubeItem>()
        Bokin2 = RubikCube(baseWidth: 2, baseHeight: 2, cubeHeight: 2, uniqueIdentifiersStartPosition: 1000, items: bokinItems )
        self.imagePicker.delegate = self
        Bokin2.createCubeFromScreensShots()
        self.setImagestags()
        self.getInitialColorForUniqueIdentifiers()
        var s = scrabler.generateScrable()
        self.execScrable(moves: s)
        self.addGestureRecognizers()
        self.redPalleteColor.backgroundColor = UIColor.red
        self.bluePalleteColor.backgroundColor = UIColor.blue
        self.yellowPalleteColor.backgroundColor = UIColor.yellow
        self.orangePalleteColor.backgroundColor = UIColor.orange
        self.whitePalleteColor.backgroundColor = UIColor.white
        self.greenPalleteColor.backgroundColor = UIColor.green
        
        self.redPalleteColor.isUserInteractionEnabled = true
        self.bluePalleteColor.isUserInteractionEnabled = true
        self.greenPalleteColor.isUserInteractionEnabled = true
        self.whitePalleteColor.isUserInteractionEnabled = true
        self.orangePalleteColor.isUserInteractionEnabled = true
        self.yellowPalleteColor.isUserInteractionEnabled = true
        self.redPalleteColor.tag = 100
        self.bluePalleteColor.tag = 101
        self.greenPalleteColor.tag = 102
        self.whitePalleteColor.tag = 103
        self.orangePalleteColor.tag = 104
        self.yellowPalleteColor.tag = 105
        // Do any additional setup after loading the view.
    }
    
    func execScrable(moves:Array<String>){
        for move in moves{
            let s = NSSelectorFromString(move)
            perform(s)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getInitialColorForUniqueIdentifiers(){
        let initColors = self.Bokin2.getInitialColorForUniqueIdentifiers()
        for tag in initColors.keys{
            imageHiddenColor[tag] = UICubeColors[initColors[tag]!]
        }
    }
    func EXECRotation(faceOfMoveOrigin:Face,columnMove:cubeColumnMove,moveOrigin:MoveOrigin,index:Int,degrees:degrees){
        let r1 = Bokin2.ROTATE(faceOfMoveOrigin: faceOfMoveOrigin, columnMove: columnMove, moveOrigin: moveOrigin, index: index, degrees: degrees)
        for tag in r1.keys{
            if  let imageView = self.view.viewWithTag(tag) as? UIImageViewCubeItem {
                //imageView.backgroundColor = UICubeColors[r1[tag]!]
                imageHiddenColor[tag] = UICubeColors[r1[tag]!]
            }
        }
    }
    func proccessClickedImage(imageView:UIImageView){
       // imageView.backgroundColor = UICubeColors[self.imagesFace[imageView.tag]]
    }
    func setImagestags(){
        self.itemUpP4.tag = (Bokin2.faceUniqueIdentifiers[Face.Up]?[4])!
        self.imagesFace[self.itemUpP4.tag] = .Up
        self.itemUpP5.tag = (Bokin2.faceUniqueIdentifiers[Face.Up]?[5])!
        self.imagesFace[self.itemUpP5.tag] = .Up
        self.itemUpP6.tag = (Bokin2.faceUniqueIdentifiers[Face.Up]?[6])!
        self.imagesFace[self.itemUpP6.tag] = .Up
        self.itemUpP7.tag = (Bokin2.faceUniqueIdentifiers[Face.Up]?[7])!
        self.imagesFace[self.itemUpP7.tag] = .Up
        self.itemFrontP4.tag = (Bokin2.faceUniqueIdentifiers[Face.Front]?[4])!
        self.imagesFace[self.itemFrontP4.tag] = .Front
        self.itemFrontP6.tag = (Bokin2.faceUniqueIdentifiers[Face.Front]?[6])!
        self.imagesFace[self.itemFrontP6.tag] = .Front
        self.itemFrontP2.tag = (Bokin2.faceUniqueIdentifiers[Face.Front]?[2])!
        self.imagesFace[self.itemFrontP2.tag] = .Front
        self.itemFrontP0.tag = (Bokin2.faceUniqueIdentifiers[Face.Front]?[0])!
        self.imagesFace[self.itemFrontP0.tag] = .Front
        self.itemBackP5.tag = (Bokin2.faceUniqueIdentifiers[Face.Back]?[5])!
        self.imagesFace[self.itemBackP5.tag] = .Back
        self.itemBackP7.tag = (Bokin2.faceUniqueIdentifiers[Face.Back]?[7])!
        self.imagesFace[self.itemBackP7.tag] = .Back
        self.itemBackP3.tag = (Bokin2.faceUniqueIdentifiers[Face.Back]?[3])!
        self.imagesFace[self.itemBackP3.tag] = .Back
        self.itemBackP1.tag = (Bokin2.faceUniqueIdentifiers[Face.Back]?[1])!
        self.imagesFace[self.itemBackP1.tag] = .Back
        self.itemLeftP6.tag = (Bokin2.faceUniqueIdentifiers[Face.Left]?[6])!
        self.imagesFace[self.itemLeftP6.tag ] = .Left
        self.itemLeftP7.tag = (Bokin2.faceUniqueIdentifiers[Face.Left]?[7])!
        self.imagesFace[self.itemLeftP7.tag] = .Left
        self.itemLeftP3.tag = (Bokin2.faceUniqueIdentifiers[Face.Left]?[3])!
        self.imagesFace[self.itemLeftP3.tag] = .Left
        self.itemLeftP2.tag = (Bokin2.faceUniqueIdentifiers[Face.Left]?[2])!
        self.imagesFace[self.itemLeftP2.tag] = .Left
        self.itemRightP4.tag = (Bokin2.faceUniqueIdentifiers[Face.Right]?[4])!
        self.imagesFace[self.itemRightP4.tag] = .Right
        self.itemRightP5.tag = (Bokin2.faceUniqueIdentifiers[Face.Right]?[5])!
        self.imagesFace[self.itemRightP5.tag] = .Right
        self.itemRightP0.tag = (Bokin2.faceUniqueIdentifiers[Face.Right]?[0])!
        self.imagesFace[self.itemRightP0.tag] = .Right
        self.itemRightP1.tag = (Bokin2.faceUniqueIdentifiers[Face.Right]?[1])!
        self.imagesFace[self.itemRightP1.tag] = .Right
        self.itemDownP0.tag = (Bokin2.faceUniqueIdentifiers[Face.Down]?[0])!
        self.imagesFace[self.itemDownP0.tag] = .Down
        self.itemDownP1.tag = (Bokin2.faceUniqueIdentifiers[Face.Down]?[1])!
        self.imagesFace[self.itemDownP1.tag] = .Down
        self.itemDownP2.tag = (Bokin2.faceUniqueIdentifiers[Face.Down]?[2])!
        self.imagesFace[self.itemDownP2.tag] = .Down
        self.itemDownP3.tag = (Bokin2.faceUniqueIdentifiers[Face.Down]?[3])!
        self.imagesFace[self.itemDownP3.tag] = .Down
        
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
    @objc func B2() {//B
        self.movesLogs.text = "\(self.movesLogs.text!) , B2"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 1, degrees: .D90)
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 1, degrees: .D90)
    }
    @objc func BPrime() {
        self.movesLogs.text = "\(self.movesLogs.text!) , B'"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 1, degrees: .D90)
    }
    @objc func DPrime( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .HorizontalP, moveOrigin: .Frontal, index: 1, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , D'"
    }
    @objc func D( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Horizontal, moveOrigin: .Frontal, index: 1, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , D"
    }
    @objc func D2( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Horizontal, moveOrigin: .Frontal, index: 1, degrees: .D90)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Horizontal, moveOrigin: .Frontal, index: 1, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , D2"
    }
    @objc func U( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .HorizontalP, moveOrigin: .Frontal, index: 2, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , U"
    }
    @objc func U2( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .HorizontalP, moveOrigin: .Frontal, index: 2, degrees: .D90)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .HorizontalP, moveOrigin: .Frontal, index: 2, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , U2"
    }
    @objc func UPrime( ) {
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Horizontal, moveOrigin: .Frontal, index: 2, degrees: .D90)
        self.movesLogs.text = "\(self.movesLogs.text!) , U'"
    }
    @objc func F( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , F"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 2, degrees: .D90)
    }
    @objc func F2( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , F2"
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 2, degrees: .D90)
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
    @objc func L2( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , L2"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 1, degrees: .D90)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 1, degrees: .D90)
    }
    
    
    @objc func R( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , R"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 2, degrees: .D90)
    }
    @objc func R2( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , R2"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 2, degrees: .D90)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 2, degrees: .D90)
    }
    @objc func RPrime( ) {
        self.movesLogs.text = "\(self.movesLogs.text!) , R'"
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 2, degrees: .D90)
    }
    @objc func imageClickedToShowColor(sender:AnyObject){
        //view.backgroundColor = imageHiddenColor[view.tag]
        if let gr = sender as? UITapGestureRecognizer {
            if let imgView = gr.view as? UIImageViewCubeItem {
                if self.selectedColorFromPalete == imageHiddenColor[imgView.tag]{
                    imgView.image = nil
                    imgView.backgroundColor = imageHiddenColor[imgView.tag]
                    if let tag = self.actuallyPressedImageViewTag {
                        let imageViewSel = self.view.viewWithTag(tag) as! UIImageView
                        imgView.image = imageViewSel.image
                    }
                    
                }else{
                    imgView.image = UIImage(named:"wrongChoice")
                }
            }
        }
        print()
    }
    @objc func colorSelected(sender:AnyObject){
        //view.backgroundColor = imageHiddenColor[view.tag]
        if let gr = sender as? UITapGestureRecognizer {
            if let imgView = gr.view as? UIImageView {
                self.selectedColorFromPalete = imgView.backgroundColor
            }
        }
    }
    func addGestureRecognizers(){
        for image in self.view.subviews{
            if let img = image as? UIImageViewCubeItem {
                if img.tag > 0 {
                    let imageClickedToShowColor = UITapGestureRecognizer(target: self, action: #selector(self.imageClickedToShowColor(sender:)))
                    img.addGestureRecognizer(imageClickedToShowColor)
                    img.isUserInteractionEnabled = true
                }
            }
        }
        let palleteRedLongPressGestureRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showImageSourceOption))
        let palleteRedColorSlectedRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.colorSelected(sender:)))
        self.redPalleteColor.addGestureRecognizer(palleteRedColorSlectedRecognizer)
        self.redPalleteColor.addGestureRecognizer(palleteRedLongPressGestureRecognizer)
        let palleteBlueLongPressGestureRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showImageSourceOption))
        let palleteBlueColorSlectedRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.colorSelected(sender:)))
        self.bluePalleteColor.addGestureRecognizer(palleteBlueColorSlectedRecognizer)
        self.bluePalleteColor.addGestureRecognizer(palleteBlueLongPressGestureRecognizer)
        let palleteYellowColorSlectedRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.colorSelected(sender:)))
        let palleteYellowLongPressGestureRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showImageSourceOption))
        self.yellowPalleteColor.addGestureRecognizer(palleteYellowColorSlectedRecognizer)
        self.yellowPalleteColor.addGestureRecognizer(palleteYellowLongPressGestureRecognizer)
        let palleteOrangeColorSlectedRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.colorSelected(sender:)))
        let palleteOrangeLongPressGestureRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showImageSourceOption))
        self.orangePalleteColor.addGestureRecognizer(palleteOrangeColorSlectedRecognizer)
        self.orangePalleteColor.addGestureRecognizer(palleteOrangeLongPressGestureRecognizer)
        let palleteWhiteColorSlectedRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.colorSelected(sender:)))
        let palleteWhiteLongPressGestureRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showImageSourceOption))
        self.whitePalleteColor.addGestureRecognizer(palleteWhiteColorSlectedRecognizer)
        self.whitePalleteColor.addGestureRecognizer(palleteWhiteLongPressGestureRecognizer)
        let palleteGreenColorSlectedRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.colorSelected(sender:)))
        let palleteGreenLongPressGestureRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showImageSourceOption))
        self.greenPalleteColor.addGestureRecognizer(palleteGreenColorSlectedRecognizer)
        self.greenPalleteColor.addGestureRecognizer(palleteGreenLongPressGestureRecognizer)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Image selection
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let tag = self.actuallyPressedImageViewTag  else{
            return
        }
        let imageView = self.view.viewWithTag(tag) as! UIImageView
        imageView.contentMode = .scaleAspectFit
        //self.UImgProfile.backgroundColor = UIColor.white
        //self.usingPersonalImage = true//for not loading empty background image in new account
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = pickedImage
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        } else {
            imageView.image = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    @objc func showImageSourceOption(sender:AnyObject){
        if let gr = sender as? UILongPressGestureRecognizer {
            if let imgView = gr.view as? UIImageView {
                self.actuallyPressedImageViewTag = imgView.tag
            }
        }
        let actionSheet:UIAlertController = UIAlertController(title: "Source", message: "Select a source", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            return
        }
        actionSheet.addAction(cancelActionButton)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let cameraActionButton: UIAlertAction = UIAlertAction(title: "Camera", style: .default)
            { action -> Void in
                self.presentImagePickerBy(type: .camera)
            }
            actionSheet.addAction(cameraActionButton)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default)
            { action -> Void in
                self.presentImagePickerBy(type: .photoLibrary)
            }
            actionSheet.addAction(photoLibraryActionButton)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Saved Photos Album", style: .default)
            { action -> Void in
                self.presentImagePickerBy(type: .savedPhotosAlbum)
            }
            actionSheet.addAction(deleteActionButton)
        }
        self.present(actionSheet, animated: true, completion: nil)//3:15 25 octubre 2016 :)
        
    }
     func presentImagePickerBy(type:UIImagePickerControllerSourceType){
        self.imagePicker.sourceType = type
        self.imagePicker.allowsEditing = true
        self.present(self.imagePicker, animated: true, completion: nil)
    }

}
