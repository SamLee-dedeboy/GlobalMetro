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
final class MetroNode:SKShapeNode, Codable {
    var stationName: String
    var metroLine = [String]()
    var lineColor = [UIColor]()
    var coordinateInMap:CGPoint
    var labelPosition = CGPoint.zero
    var adjacentNodes = [String]()
    var outerCircle = SKShapeNode()
    var innerCircle = SKShapeNode()
    var label = SKLabelNode()
    var stationInfo = String()
    /*
    init(withName name:String, inLine line:String, center:CGPoint) {

        self.stationName = name
        self.metroLine = line
        switch line {
        case "1": self.lineColor = UIColor.blue
        case "2": self.lineColor = UIColor.red
        default: self.lineColor = UIColor.blue
        }
        self.coordinateInMap = center
        
        super.init()
        

        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
            radius: 20,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true)
        self.position = center
        self.path = path
        self.lineWidth = 1
        self.glowWidth = 0.5
        self.fillColor = .white
        self.zPosition = 11
    
        self.name = stationName
        addCircle()
        addLabel(atPosition: self.labelPosition)
        
    }
 */
    init(withName name:String, inLine line:String, lineColor:UIColor, center:CGPoint,_ info:String = "no info") {

        self.stationName = name
        self.metroLine.append(line)
        self.lineColor.append(lineColor)
        self.coordinateInMap = center
        self.stationInfo = info
        super.init()
        

        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
            radius: 20,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true)
        self.position = center
        self.path = path
        self.lineWidth = 1
        self.glowWidth = 0.5
        //self.fillColor = .white
        self.fillColor = .black
        self.zPosition = 11
    
        self.name = stationName
        addCircle()
        addLabel(atPosition: self.labelPosition)
        
    }
    init(withName name:String, center:CGPoint,_ info:String = "no info") {

        self.stationName = name
        self.coordinateInMap = center
        self.stationInfo = info

        super.init()
        

        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
            radius: 20,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true)
        self.position = center
        self.path = path
        self.lineWidth = 1
        self.glowWidth = 0.5
        //self.fillColor = .white
        self.fillColor = .black
        self.zPosition = 11
    
        self.name = stationName
        addCircle()
        addLabel(atPosition: self.labelPosition)
        
    }
    func addToLine(_ line:String, _ color:UIColor) {
        self.metroLine.append(line)
        self.lineColor.append(color)
        adjustCircleColor()
    }
    func adjustCircleColor() {
        if self.lineColor.count > 1 {
            self.outerCircle.fillColor = UIColor.black
        } else {
            self.outerCircle.fillColor = self.lineColor.first ?? UIColor.black
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(from otherNode: MetroNode) {
        self.stationName = otherNode.stationName
        self.metroLine = otherNode.metroLine
        self.adjacentNodes = otherNode.adjacentNodes
        self.coordinateInMap = otherNode.coordinateInMap

        super.init()

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stationName = try container.decode(String.self, forKey: .stationName)
        self.metroLine = try container.decode([String].self, forKey: .metroLine)
        self.coordinateInMap = try container.decode(CGPoint.self, forKey: .coordinateInMap)
        self.adjacentNodes = try container.decode([String].self, forKey: .adjacentNodes)
        self.labelPosition = try container.decode(CGPoint.self, forKey: .labelPosition)
        self.stationInfo = try container.decode(String.self, forKey: .stationInfo)

        let colorData = try container.decode(Data.self, forKey: .lineColor)
        self.lineColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? [UIColor] ?? [UIColor.black]
        
        super.init()
    
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
        radius: 15,
        startAngle: 0,
        endAngle: CGFloat.pi * 2,
        clockwise: true)
        /*
             path.addArc(center: center,
                        radius: 15,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        */
        
        self.position = self.coordinateInMap
        
        self.path = path
        self.lineWidth = 1
        self.glowWidth = 0.5
        //self.fillColor = .white
        self.fillColor = .black
        self.zPosition = 11
        self.name = stationName
        addCircle()
        addLabel(atPosition: self.labelPosition)
    }
    func addCircle() {
        let outerPath = CGMutablePath()
        outerPath.addArc(center: CGPoint.zero,
                   radius: 25,
                   startAngle: 0,
                   endAngle: CGFloat.pi * 2,
                   clockwise: true)
        outerCircle.path = outerPath
        outerCircle.position = CGPoint.zero
        outerCircle.fillColor = self.lineColor.first ?? UIColor.white
        
        let innerPath = CGMutablePath()
        innerPath.addArc(center: CGPoint.zero,
                   radius: 20,
                   startAngle: 0,
                   endAngle: CGFloat.pi * 2,
                   clockwise: true)
        innerCircle.path = innerPath
        innerCircle.position = CGPoint.zero
        innerCircle.fillColor = UIColor.white
        
        outerCircle.zPosition = self.zPosition - 2
        innerCircle.zPosition = self.zPosition - 1
        outerCircle.name = "outerCircle"
        innerCircle.name = "innerCircle"
        innerCircle.isUserInteractionEnabled = false
        outerCircle.isUserInteractionEnabled = false
        adjustCircleColor()
        self.addChild(outerCircle)
        self.addChild(innerCircle)
    }
    func addLabel(atPosition position:CGPoint) {
        self.label.text = self.stationName
        self.label.position = position
        self.label.zPosition = self.zPosition + 1
        self.label.fontSize = 35
        self.label.fontColor = UIColor.black
        self.label.fontName = "Avenir"
        self.addChild(label)
    }
}

extension MetroNode {
    enum CodingKeys: String, CodingKey {
        case stationName
        case metroLine
        case coordinateInMap
        case adjacentNodes
        case labelPosition
        case lineColor
        case stationInfo
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stationName, forKey: CodingKeys.stationName)
        try container.encode(metroLine, forKey: CodingKeys.metroLine)
        try container.encode(coordinateInMap, forKey: CodingKeys.coordinateInMap)
        try container.encode(adjacentNodes, forKey: CodingKeys.adjacentNodes)
        try container.encode(labelPosition, forKey: CodingKeys.labelPosition)
        try container.encode(stationInfo, forKey: CodingKeys.stationInfo)
        //super.encode(with: encoder as! NSCoder)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: lineColor, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .lineColor)
    }
    


}
