//
//  secondViewController.swift
//  customSegue
//
//  Created by Benjamin on 2019-04-12.
//  Copyright © 2019 Benjamin. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
       
        let unwindSegue = AnimatedSegue(identifier: "", source: self, destination: subsequentVC) {
            
        }
        unwindSegue.animationType = .circle
    }
}
