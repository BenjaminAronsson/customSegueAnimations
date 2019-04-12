//
//  DesignableButton.swift
//  customSegue
//
//  Created by Benjamin on 2019-04-12.
//  Copyright © 2019 Benjamin. All rights reserved.
//

import UIKit



class DesignableButton: UIButton {

    
    @IBInspectable
    var showBadgeOnIndex:Int = 0 {
        didSet {
            if showBadgeOnIndex >= 5 {
                showBadgeOnIndex = 0
            }
            //updateView()
        }
    }
    
    @IBInspectable
    var showAllBadge:Bool = false {
        didSet {
            //updateView()
        }
    }

}
