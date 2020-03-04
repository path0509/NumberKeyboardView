//
//  ViewController.swift
//  NumberKeyboardView
//
//  Created by 김수겸 on 2020/03/04.
//  Copyright © 2020 myname.sg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField! {
        didSet {
            NumberKeyboardView.set(field: textField, mode: .shuffle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}

