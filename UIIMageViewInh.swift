//
//  UIIMageViewInh.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 25/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation
import UIKit

class UIImageViewCubeItem:UIImageView{

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}
