//
//  UIView.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 24/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation
import UIKit
extension UIView{
    func paintImageView(tag:Int,color:UIColor)->Bool{
        guard let imageView = self.viewWithTag(tag) as? UIImageView else {
            return false
        }
        imageView.backgroundColor = color
        return true
        
    }
}
