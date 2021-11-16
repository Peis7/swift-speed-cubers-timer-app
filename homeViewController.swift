//
//  homeViewController.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 16/3/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class homeViewController: UIViewController {
    
    
    var homeStayDurationCount:Int = 0
    let duration:Int = 2
     var timer:Timer!
    @IBOutlet weak var clockImageViewController: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startTimer(duration: 2)
    }
    func startTimer(duration:Int){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.evaluateTimer), userInfo: nil, repeats: true)
    }
    @objc func evaluateTimer(){
        if self.homeStayDurationCount == self.duration{
            self.homeStayDurationCount = 0
            self.timer.invalidate()
            self.goToMainTabViewController()
        }
        self.homeStayDurationCount+=1
    }
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    func openTimerViewController(){
        let timerViewController = self.storyboard?.instantiateViewController(withIdentifier: "timerViewControllerID") as! timerViewController
        self.navigationController?.pushViewController(timerViewController, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToMainTabViewController(){
        let timerViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarViewControllerID") as! MainTabBarViewController
        self.navigationController?.pushViewController(timerViewController, animated: true)
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
