//
//  CreateNodeViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/27.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit
class CreateNodeViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIAdaptivePresentationControllerDelegate {
    override func viewDidLoad() {
        if isViewOnlyMode {
            self.saveButton.isHidden = true
            self.stationNameTextField.isUserInteractionEnabled = false
            self.metroLineCollectionView.isUserInteractionEnabled = false
            self.descriptionTextView.isUserInteractionEnabled = false
        } else {
            self.saveButton.isHidden = false
            self.stationNameTextField.isUserInteractionEnabled = true
            self.metroLineCollectionView.isUserInteractionEnabled = true
            self.descriptionTextView.isUserInteractionEnabled = true
        }
        
        if isEditMode || isViewOnlyMode, let presentedNode = self.presentedNode {
            self.stationNameTextField.text = presentedNode.stationName
            self.descriptionTextView.text = presentedNode.stationInfo
        }
    }
    var presentedNode: MetroNode?
    var isViewOnlyMode = false
    var isCreateMode = false
    var isEditMode = false
    var metroLineList = [MetroLine]()
    var selectedLineList = [String]()
    //override var modalPresentationStyle: UIModalPresentationStyle =
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isViewOnlyMode, let presentedNode = self.presentedNode {
            return presentedNode.metroLine.count
        } else {
            return metroLineList.count
        }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MetroLineCell", for: indexPath)
        if let metroLineCell = cell as? MetroLineCollectionViewCell {
            if isViewOnlyMode, let presentedNode = self.presentedNode {
                metroLineCell.buttonText = presentedNode.metroLine[indexPath.item]
                metroLineCell.buttonColor = presentedNode.lineColor[indexPath.item]
                metroLineCell.highlightCell()
                addSelectedLine(metroLineCell.buttonText)
                
            } else {
                metroLineCell.buttonText = metroLineList[indexPath.item].lineName
                metroLineCell.buttonColor = metroLineList[indexPath.item].color
                if isEditMode, let presentedNode = self.presentedNode {
                    for presentedNodeLine in presentedNode.metroLine {
                        if metroLineCell.buttonText == presentedNodeLine {
                            metroLineCell.highlightCell()
                            addSelectedLine(metroLineCell.buttonText)

                        }
                    }
                }
            }
        }
        
        return cell
       }
    func addSelectedLine(_ lineName:String) {
        //TODO: delte
        selectedLineList.append(lineName)
    }
    func deleteSelectedLine(_ lineName:String) {
        if let index = selectedLineList.firstIndex(of: lineName) {
            selectedLineList.remove(at:index)
        }
    }
    
    @IBOutlet weak var stationNameInputField: UITextField!
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)

    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let mapvc = self.presentationController?.delegate as? MapViewController {
            if let stationName =  stationNameInputField.text {
                if mapvc.checkStationName(stationName) {
                    if selectedLineList.isEmpty {
                        var alert = UIAlertController (
                                title:"MetroLine Not Selected",
                                message:"Please select a line for this station",
                                preferredStyle: .alert
                            )
                            alert.addAction(UIAlertAction(
                                title:"OK",
                                style:.default))
                            present(alert, animated:true, completion:nil)
                            return
                    }
                    
                    if isEditMode, let presentedNode = self.presentedNode {
                        mapvc.editNode(presentedNode, stationName, selectedLineList, descriptionTextView.text)
                    } else {
                        mapvc.createNode(stationName, selectedLineList, descriptionTextView.text)
                    }
                    self.presentingViewController?.dismiss(animated: true)
                } else {
                    var alert = UIAlertController (
                        title:"Station Name Exists",
                        message:"Please enter another Station Name",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(
                        title:"OK",
                        style:.default))
                    present(alert, animated:true, completion:nil)
                }
            }
        }
        
    }
    @IBOutlet weak var metroLineSelectionView: UICollectionView! {
        didSet {
            metroLineSelectionView.delegate = self
            metroLineSelectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var stationNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.layer.borderColor = UIColor.gray.cgColor
            descriptionTextView.layer.borderWidth = 1.0
            descriptionTextView.layer.cornerRadius = 5.0
            
        }
    }
    @IBOutlet weak var metroLineCollectionView: UICollectionView! {
        didSet {
            metroLineCollectionView.layer.borderColor = UIColor.gray.cgColor
            metroLineCollectionView.layer.borderWidth = 1.0
            metroLineCollectionView.layer.cornerRadius = 5.0
        }
    }
}

