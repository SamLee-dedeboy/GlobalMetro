//
//  CreateLineViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/29.
//  Copyright © 2019 sam. All rights reserved.
//

import Foundation
import UIKit
import EFColorPicker
import SpriteKit
class CreateLineViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    var colorSelectionController = EFColorSelectionViewController()
    lazy var navCtrl = UINavigationController(rootViewController: colorSelectionController)
    var chosenColor = UIColor.white {
        didSet {
            
            if let scene = self.colorView.scene {
                let colorCircle = SKShapeNode()
                let path = CGMutablePath()
                path.addArc(center: CGPoint.zero,
                    radius: 10,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
                colorCircle.position = CGPoint.zero
                colorCircle.path = path
                
                colorCircle.fillColor = chosenColor
                scene.addChild(colorCircle)
            }
            if let demoScene = self.demoLineView.scene {
                let leftNode = MetroNode(withName: "南京大学", inLine: "demoLine", lineColor: self.chosenColor, center: CGPoint(x:-70, y:0))
            
                leftNode.label.position = CGPoint(x:0, y:40)
                leftNode.label.fontSize = 25
                demoScene.addChild(leftNode)
                
                let path = CGMutablePath()
                path.move(to: leftNode.position)
                path.addLine(to: CGPoint(x:70, y:0))
                let line = SKShapeNode(path:path)
                line.name = "demoLine"
                line.lineWidth = 40
                line.glowWidth = 0.5
                line.strokeColor = self.chosenColor
                line.zPosition = leftNode.zPosition - 1
                demoScene.addChild(line)
                print("addDemoLine")
                
                print(demoScene.children)
                
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.chosenColor = UIColor.blue
    }
    @IBOutlet weak var colorView: SKView! {
        didSet {
            let scene = SKScene(size: colorView.bounds.size)
            scene.backgroundColor = UIColor.white
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            colorView.presentScene(scene)
        }
    }
    @IBOutlet weak var demoLineView: SKView! {
        didSet {
            let scene = SKScene(size: demoLineView.bounds.size)
            scene.backgroundColor = UIColor.white
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            demoLineView.presentScene(scene)
        }
    }
    @IBOutlet weak var lineNameTextField: UITextField!
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let mapvc = self.presentationController?.delegate as? MapViewController {
            if let lineName =  lineNameTextField.text {
                mapvc.createLine(lineName, self.chosenColor)
            }
        } else {
            print("VC casting failed: \(self.presentationController?.delegate)")
        }
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func chooseColorButtonPressed(_ sender: UIButton) {

        navCtrl.navigationBar.backgroundColor = UIColor.white
        navCtrl.navigationBar.isTranslucent = false
        navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        navCtrl.popoverPresentationController?.delegate = self
        navCtrl.popoverPresentationController?.sourceView = sender
        navCtrl.popoverPresentationController?.sourceRect = sender.bounds
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )

        colorSelectionController.delegate = self
        colorSelectionController.color = self.view.backgroundColor ?? UIColor.white

        if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
            let doneBtn: UIBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("Done", comment: ""),
                style: UIBarButtonItem.Style.done,
                target: self,
                action: #selector(dismissColorSelector(sender:))
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        self.present(navCtrl, animated: true, completion: nil)
    }
    @objc func dismissColorSelector(sender: UIButton) {
        self.colorSelectionController.presentingViewController?.dismiss(animated: true)
        self.chosenColor = self.colorSelectionController.color
    }
}
extension CreateLineViewController: EFColorSelectionViewControllerDelegate  {
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {

        // TODO: You can do something here when color changed.
        //print("New color: " + color.debugDescription)
    }
}

