//
//  CreateNodeViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/27.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit
class CreateNodeViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIAdaptivePresentationControllerDelegate {
   
    var metroLineList = [MetroLine]()
    var selectedLineList = [String]()
    //override var modalPresentationStyle: UIModalPresentationStyle =
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metroLineList.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MetroLineCell", for: indexPath)
        if let metroLineCell = cell as? MetroLineCollectionViewCell {
            metroLineCell.buttonText = metroLineList[indexPath.item].lineName
            metroLineCell.buttonColor = metroLineList[indexPath.item].color
        }
        return cell
       }
    func addCreatingNodeToLine(_ lineName:String) {
        selectedLineList.append(lineName)
    }
    
    
    @IBOutlet weak var stationNameInputField: UITextField!
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)

    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let mapvc = self.popoverPresentationController?.delegate as? MapViewController {
            if let stationName =  stationNameInputField.text {
                mapvc.createNode(stationName, selectedLineList)
            }
        }
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBOutlet weak var metroLineSelectionView: UICollectionView! {
        didSet {
            metroLineSelectionView.delegate = self
            metroLineSelectionView.dataSource = self
        }
    }
    
}

