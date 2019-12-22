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
    var lineSelected = false {
        didSet {
            if let cnvc = (self.superview as? UICollectionView)?.delegate as? CreateNodeViewController {
                if lineSelected {
                    metroLineButton.backgroundColor = self.buttonColor
                    cnvc.addSelectedLine(self.buttonText)
                } else {
                    metroLineButton.backgroundColor = UIColor.white
                    cnvc.deleteSelectedLine(self.buttonText)
                }
            }
        }
    }
    
    var buttonColor = UIColor.red
    @IBOutlet weak var metroLineButton: UIButton!
    @IBAction func metroLineButtonPressed(_ sender: UIButton) {
        lineSelected = !lineSelected
    }
    func highlightCell() {
        lineSelected = true
        metroLineButton.backgroundColor = self.buttonColor
    }
}
