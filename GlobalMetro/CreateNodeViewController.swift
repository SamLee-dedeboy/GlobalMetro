//
//  CreateNodeViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/27.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit
class CreateNodeViewController: UIViewController{
    //override var modalPresentationStyle: UIModalPresentationStyle =


    @IBOutlet weak var stationNameInputField: UITextField!
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)

    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let mapvc = self.popoverPresentationController?.delegate as? MapViewController {
            if let stationName =  stationNameInputField.text {
                mapvc.createNode(stationName)
            }
        }
        self.presentingViewController?.dismiss(animated: true)
    }
}

