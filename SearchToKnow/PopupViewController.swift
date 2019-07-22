//
//  PopupViewController.swift
//  SearchToKnow
//
//  Created by A on 22/07/19.
//  Copyright © 2019 A. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var searchLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goBtnPressed(_ sender: UIButton) {
    }
    
}
