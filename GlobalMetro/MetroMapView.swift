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

    var selectedNode: MetroNode?
    var mapInfo = [String:[MetroNode]]()
    
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
    }
    @objc func scaleView(pinchRecognizedBy recognizer: UIPinchGestureRecognizer) {
        print("recognized")
        self.transform = CGAffineTransform.identity.scaledBy(x: recognizer.scale, y: recognizer.scale)
    }
}
extension MetroMapView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if let scene = self.scene {
            let touchedNodes = scene.nodes(at:touch.location(in:scene))
        
            if let touchedNode = touchedNodes.first, ((touchedNode as? MetroNode) != nil) {
                print("node selected")
                selectedNode = touchedNode as? MetroNode
            }
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
                self.scene!.removeChildren(in:[(self.scene?.childNode(withName: touchedNode.stationName + "-" + adjacentNode.stationName))!])
                drawLineBetweenNode(onScene: self.scene!, touchedNode, adjacentNode)
            }
            
            //drawMap()
            print(touchedNode.position)
        } else {
            print("moved")

            self.center.x += positionInScene.x - previousPosition.x
            self.center.y += positionInScene.y - previousPosition.y
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selectedNode = nil
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
        line.lineWidth = 1
        line.glowWidth = 0.5
        line.fillColor = .red
        scene.addChild(line)
        print("addNewLine")
        self.presentScene(scene)
    }
}
