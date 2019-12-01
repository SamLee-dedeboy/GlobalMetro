//
//  CreateLineViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/29.
//  Copyright © 2019 sam. All rights reserved.
//

import Foundation
import UIKit
class CreateLineViewController: UIViewController {
    
    @IBOutlet weak var lineNameTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
    
        if let mapvc = self.popoverPresentationController?.delegate as? MapViewController {
            if let lineName =  lineNameTextField.text, let colorName = colorTextField.text {
                var color = UIColor.init(named:colorName)
                print("color:", color)
                switch lineName {
                    case "1": color = UIColor.blue
                    case "2": color = UIColor.red
                    default: color = UIColor.blue
                }
                mapvc.createLine(lineName, color!)
            }
        }
        self.presentingViewController?.dismiss(animated: true)
    }
}
