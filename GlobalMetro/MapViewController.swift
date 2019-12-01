//
//  ViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/26.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit
import SpriteKit
class MapViewController: UIViewController, UIScrollViewDelegate {
    var metroMap = MetroMap()
    var selectedLine: String? {
        didSet {
            if selectedLine == nil {
                addNodeButton.isEnabled = false
            } else {
                addNodeButton.isEnabled = true
            }

        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Create Node" {
        
            if let cnvc = segue.destination as? CreateNodeViewController {
                if let ppc = cnvc.popoverPresentationController {
                    ppc.sourceRect = addNodeButton.frame
                    ppc.delegate = self
                    cnvc.preferredContentSize = CGSize(width: 250, height: 500)
                }
            }
            return
        }
        
        if segue.identifier == "Create Line" {
            if let clvc = segue.destination as? CreateLineViewController {
                if let ppc = clvc.popoverPresentationController {
                    ppc.sourceRect = addLineButton.frame
                    ppc.delegate = self
                    clvc.preferredContentSize = CGSize(width: 250, height:500)
                }
            }
            return
        }
    }
    
    var counter = 0
    @IBOutlet weak var metroMapView: MetroMapView! {
        didSet {
            
            let scene = SKScene(size: metroMapView.bounds.size)
            
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

            metroMapView.presentScene(scene)
            
            //let pinchGestureReconizer = UIPinchGestureRecognizer(
                //target:metroMapView, action: #selector(metroMapView.scaleView(pinchRecognizedBy:)))
            //metroMapView.addGestureRecognizer(pinchGestureReconizer)
        }
    }
    
    @IBOutlet weak var mapScrollView: myScrollView! {
        didSet {
            mapScrollView.minimumZoomScale = 1/25
            mapScrollView.maximumZoomScale = 1.2
            mapScrollView.delegate = self
            mapScrollView.canCancelContentTouches = true
            
        }
    }
    @IBOutlet weak var addLineButton: UIButton!
    @IBOutlet weak var addNodeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //metroMapView.frame = CGRect(x: 0, y: 0, width: 1200, height: 800)
        
    


        mapScrollView.contentSize = metroMapView.frame.size
        
        
        do {
            //var node:MetroNode = try .init(fromFile: "test_node.json")
        
        } catch {
            print("init from file failed")
        }
    }
    
    
    
    @IBAction func testButtonPressed(_ sender: UIButton) {
    
        print(metroMapView.center)
        /*
        metroMapView.drawNode(MetroNode(withName: "1", inLine: "2", center:CGPoint(x:0.5,y:0.5)))
        metroMapView.drawNode(MetroNode(withName: "2", inLine: "2", center:CGPoint(x:0.5,y:0.5)))
        metroMapView.drawNode(MetroNode(withName: "3", inLine: "2", center:CGPoint(x:0.5,y:0.5)))
        metroMapView.drawNode(MetroNode(withName: "4", inLine: "2", center:CGPoint(x:0.5,y:0.5)))
 */
    }
    func createNode(_ name: String) {
        
        if let selectedLine = self.selectedLine {
            print("pressed")
            metroMap.addNewNode(inLine: selectedLine, naming:name)
            metroMapView.drawNode(metroMap.getNodeByName(name)!)
        
        }
    }
    func createLine(_ name:String, _ color:UIColor) {
        metroMap.addNewLine(lineName: name, color: color)
        self.selectedLine = name
        metroMapView.selectedLine = name
    }
    
   
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        metroMap.save()
    }
}
extension MapViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return metroMapView
    }
}

class myScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        print("check touch")
        if let metroMapView = subviews.first as? MetroMapView {
            return metroMapView.selectedNode == nil
        } else {
            return true
        }
    }
}
