//
//  ViewController.swift
//  customSegue
//
//  Created by Benjamin on 2019-04-12.
//  Copyright © 2019 Benjamin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue is AnimatedSegue {
            (segue as! AnimatedSegue).animationType = .verticalPaging
        }
    }
}

