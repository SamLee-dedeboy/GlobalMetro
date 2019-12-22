//
//  myColorView.swift
//  GlobalMetro
//
//  Created by sam on 2019/12/22.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit
import SpriteKit
class myColorView: SKView {
    var myDelegate : MyColorViewControllerDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let cnvc = self.myDelegate as? CreateLineViewController {
            cnvc.showColorPicker(self)
        }
    }
}
