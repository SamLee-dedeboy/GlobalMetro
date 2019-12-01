//
//  MetroMapView.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/26.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit
import SpriteKit
class MetroMapView: SKView {
    var mapInfo = [String:[MetroNode]]()
    var selectedNode: MetroNode?
    var selectedLine: String?
    /*
    func drawMap() {
        //TODO: optimized so that each line is on different layer
        let newScene = SKScene(size: self.bounds.size)
        
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        for nodeList in mapInfo.values {
            if var lastNode = nodeList.first {
                lastNode.removeFromParent()
                newScene.addChild(lastNode)
                if nodeList.count > 1 {
                    for node in nodeList[1...] {
                        node.removeFromParent()

                        drawLineBetweenNode(onScene: newScene, lastNode, node)
                        newScene.addChild(node)
                        lastNode = node
                    }
                }
            }
        }
        presentScene(newScene)
    }
 */
    func drawMap(_ mapInfo: [String:[MetroNode]]) {
        
    }
    func drawNode(_ node:MetroNode) {
        if mapInfo[node.metroLine] != nil{
            print("add1")
            let lastNode = mapInfo[node.metroLine]!.last!
            mapInfo[node.metroLine]!.append(node)
            node.adjacentNodes.append(lastNode)
            lastNode.adjacentNodes.append(node)
            drawLineBetweenNode(onScene: self.scene!, node, lastNode)
            self.scene!.addChild(node)

        } else {
            print("add2")
            mapInfo[node.metroLine] = [node]
            self.scene!.addChild(node)
            //self.presentScene(self.scene!)
        }
        highlightedNode(node, onScene: self.scene!)
    }

    @objc func scaleView(pinchRecognizedBy recognizer: UIPinchGestureRecognizer) {
        print("recognized")
        self.transform = CGAffineTransform.identity.scaledBy(x: recognizer.scale, y: recognizer.scale)
    }
}
extension MetroMapView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch began")
        guard let touch = touches.first else {
            return
        }
        if let scene = self.scene {
            let touchedNodes = scene.nodes(at:touch.location(in:scene))
        
            if let touchedNode = touchedNodes.first {
                if let touchedNode = touchedNode as? MetroNode {
                    print("node selected")
                
                    selectedNode = touchedNode
                    selectedLine = touchedNode.metroLine
                    highLightLine(selectedLine!)
                    print("returning")
                    return
                }
            } else {
                print("no nodes")
            }
            selectedNode = nil
            selectedLine = nil
        } else {
            print("no scene")
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        guard let touch = touches.first else {
            return
        }

        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
            
            
        if let touchedNode = self.selectedNode {
            print("node moved")
            print(touchedNode.position)
            touchedNode.position = touch.location(in: self.scene!)
            print(touchedNode.stationName)
            for adjacentNode in touchedNode.adjacentNodes {
                self.scene!.removeChildren(in:[
                    (self.scene!.childNode(withName:
                        touchedNode.stationName + "-" + adjacentNode.stationName))
                        ??
                        (self.scene!.childNode(withName:
                            adjacentNode.stationName + "-" + touchedNode.stationName))!                    ]
                )
                drawLineBetweenNode(onScene: self.scene!, touchedNode, adjacentNode)
            }

            //drawMap()
            print(touchedNode.position)
        } else {
            print("moved")

            //self.center.x += positionInScene.x - previousPosition.x
            //self.center.y += positionInScene.y - previousPosition.y
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch ended")
        superview?.isUserInteractionEnabled = true

        self.selectedNode = nil
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch canceled")
        superview?.isUserInteractionEnabled = true

        self.selectedNode = nil
    }
    override var next: UIResponder? {
        get {
            return nil
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
}
extension MetroMapView {
    func drawLineBetweenNode(onScene scene:SKScene, _ src:MetroNode, _ dst:MetroNode) {
        //TODO: cut out lines in the circle
        let path = CGMutablePath()
        path.move(to: src.position)
        path.addLine(to: dst.position)
        let line = SKShapeNode(path:path)
        line.name = src.stationName + "-" + dst.stationName
        line.lineWidth = 30
        line.glowWidth = 0.5
        line.strokeColor = src.lineColor
        line.zPosition = src.zPosition - 1
        scene.addChild(line)
        print("addNewLine:\(src.metroLine), \(src.lineColor)")
        //self.presentScene(scene)
    }
    func highLightLine(_ lineName: String) {
        if let scene = self.scene {
            if let line = mapInfo[lineName] {
                for node in line {
                    highlightedNode(node, onScene: scene)
                }
            }
        }
    }
    func highlightedNode(_ node:MetroNode, onScene scene:SKScene) {
        let path = CGMutablePath()
        path.addArc(center: node.coordinateInMap,
                        radius: 20,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        node.path = path
        print("highlighted")
    }
}
