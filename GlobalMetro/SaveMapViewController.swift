//
//  SaveMapViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/12/18.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit

class SaveMapViewController: UIViewController {
    
    @IBOutlet weak var mapNameTextField: UITextField!
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        if let mapvc = self.popoverPresentationController?.delegate as? MapViewController {
            if let mapName =  mapNameTextField.text {
                mapvc.saveMap(withName: mapName)
            }
        }
        self.presentingViewController?.dismiss(animated: true)
    }
}
