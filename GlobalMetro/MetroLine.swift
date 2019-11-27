//
//  MetroLine.swift
//  MetroDesignSystem
//
//  Created by sam on 2019/11/12.
//  Copyright © 2019 sam. All rights reserved.
//

import Foundation
import UIKit
class MetroLine {
    var lineName:String
    var stations = [MetroNode]()
    var color:UIColor
    init() {
        self.lineName = "someName"
        self.color = UIColor.red
    }
    init(fromFile filename:String) {
        //TODO: init line info from node files
        self.lineName = "someName"
        self.color = UIColor.red
        
    }
    init(_ name:String, _ color:UIColor) {
        self.lineName = name
        self.color = color
    }
}
