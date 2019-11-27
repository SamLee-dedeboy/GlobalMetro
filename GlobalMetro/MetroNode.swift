//
//  MetroNode.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/26.
//  Copyright © 2019 sam. All rights reserved.
//

import Foundation
//
//  MetroNode.swift
//  MetroDesignSystem
//
//  Created by sam on 2019/11/12.
//  Copyright © 2019 sam. All rights reserved.
//

import Foundation
import SpriteKit
class MetroNode:SKShapeNode {
    var stationName: String
    var metroLine:String
    var location:CGPoint
    init(withName name:String, inLine line:String, center:CGPoint) {

        self.stationName = name
        self.metroLine = line
        self.location = center
        super.init()
        let path = CGMutablePath()
        path.addArc(center: center,
                        radius: 15,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        self.path = path
        self.lineWidth = 1
        self.glowWidth = 0.5
        self.fillColor = .red
        self.zPosition = 1000
    }
    init(fromFile filename:String) {
        //TODO: init node from node file
        self.stationName = "someName"
        self.metroLine = "someLine"
        self.location = CGPoint(x:0,y:0)
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}


