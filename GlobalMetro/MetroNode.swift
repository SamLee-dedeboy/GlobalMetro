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
    var metroLine:String
    var lineColor:UIColor = UIColor.red
    var coordinateInMap:CGPoint
    var adjacentNodes = [MetroNode]()
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
        path.addEllipse(in: CGRect(origin: center, size: CGSize(width: 30,height: 30)))
        /*
             path.addArc(center: center,
                        radius: 15,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        */
        self.position = center
        self.path = path
        self.lineWidth = 1
        self.glowWidth = 0.5
        self.fillColor = .white
        self.zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(from otherNode: MetroNode) {
        self.stationName = otherNode.stationName
        self.metroLine = otherNode.metroLine
        self.coordinateInMap = otherNode.coordinateInMap
        self.adjacentNodes = otherNode.adjacentNodes
        super.init()
    }
    convenience init(fromFile fileName:String) throws {
        let json = """
        {
            "name": "Durian",
            "points": 600,
            "description": "A fruit with a distinctive scent."
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let node = try decoder.decode(MetroNode.self, from: json)
        self.init(from:node)
    }
 
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stationName, forKey:.stationName)
        try container.encode(metroLine+".json", forKey:.metroLine)
        
        try container.encode(coordinateInMap, forKey:.coordinateInMap)
        
        var adjacentNodeFileNames = String()
        for adjacentNode in adjacentNodes {
            adjacentNodeFileNames += adjacentNode.name! + ".json,"
        }
        try container.encode(adjacentNodeFileNames, forKey:.adjacentNodeFileNames)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stationName = try values.decode(String.self, forKey: .stationName)
        metroLine = try values.decode(String.self, forKey: .metroLine)

        
        coordinateInMap = try values.decode(CGPoint.self, forKey: .coordinateInMap)
        super.init()
     
  }
}

extension MetroNode {
    enum CodingKeys: String, CodingKey {
        case stationName
        case metroLine
        
        case coordinateInMap
        case adjacentNodeFileNames
    }

}
