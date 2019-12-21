//
//  MetroLineCollectionViewCell.swift
//  GlobalMetro
//
//  Created by sam on 2019/12/21.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit

class MetroLineCollectionViewCell: UICollectionViewCell {
    var buttonText = String() {
        didSet {
            self.metroLineButton.setTitle(buttonText, for: UIControl.State.normal)
        }
    }
    var lineSelected = false
    var buttonColor = UIColor.red
    @IBOutlet weak var metroLineButton: UIButton!
    @IBAction func metroLineButtonPressed(_ sender: UIButton) {
        if !lineSelected {
            metroLineButton.backgroundColor = self.buttonColor
            if let cnvc = self.superView?.delegate as? CreateNodeViewController {
                cnvc.addCreatingNodeToLine(self.buttonText)
            }
        } else {
            metroLineButton.backgroundColor = UIColor.white
        }
    }
}
