//
//  ObjectDetailViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 12.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import Firebase

class ObjectDetailViewController: MachineData {
        
    var objectName: String = ""
    var machineViewModel: MachineViewModel!
    
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var typeHeader: UILabel!
    @IBOutlet weak var nameHeader: UILabel!
    @IBOutlet weak var serialNoHeader: UILabel!
    
    @IBOutlet weak var objectTypeTextField: UITextField!
    @IBOutlet weak var objectNameTextField: UITextField!
    @IBOutlet weak var objectSerialNoTextField: UITextField!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var objectDetailView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        objectDetailView.layer.cornerRadius = 10
        setupMachineData()
        setupNavigationBarItems()
        
        setSaveButton()
        setCancelButton()
        
        let imageCollectionViewNib = UINib(nibName: "MachineImageCollectionViewCell", bundle: nil)
        imageCollectionView.register(imageCollectionViewNib, forCellWithReuseIdentifier: "MachineImageCollectionViewCell")
    }
    
    
    func setupMachineData() {
        setMachineData(onSuccess: {
            for index in 0..<self.machineListViewModel.machineList.count {
                if self.objectName == self.machineListViewModel.machineAtIndex(index).name {
                    self.machineViewModel = self.machineListViewModel.machineAtIndex(index)
                    self.machineImageData = self.machineViewModel
                }
            }
            self.setLabelText(type: self.machineViewModel.type, name: self.machineViewModel.name, serialNo: self.machineViewModel.serialNo)
            self.imageCollectionView.reloadData()
            self.pageControl.numberOfPages = self.setImageUrlListCount()
            self.activityIndicator.isHidden = true
            print("details were downloaded")
        })
    }
    
    @objc func trashTapped() {
        setAlertWithManyActions(
            title: "Warning",
            message: "Are you sure that you want to delete this item?",
            onOK: {
                guard let machineImageData = self.machineImageData else { return }
                for index in 0..<machineImageData.imageUrlList.count {
                    let url = machineImageData.imageUrlList[index]
                    self.firebaseManager.removeSelectedItemFromFirebase(childName: self.machineViewModel.name, url: url, onSuccess: {
                        self.setAlertWithoutAction(title: "Success", message: "Deleted")
                    }, onError: { (error) in
                        self.setAlertWithAction(title: "Error", message: error)
                    })
                }
                self.navigationController?.popViewController(animated: true)
        },
            onCancel: {
                self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func editTapped() {
        setAlertWithAction(title: "Warning", message: "Images and the name are not updatable!")
        openUserInteraction()
        showCustomButtons()
    }
    
    func setupNavigationBarItems() {
        let backButton = UIBarButtonItem()
        backButton.title = NSLocalizedString("Back", comment: "")
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        trashButton.tintColor = .black
        editButton.tintColor = .black
        navigationItem.rightBarButtonItems = [trashButton, editButton]
    }
    
    func setLabelText(type: String, name: String, serialNo: String) {
        typeHeader.text = NSLocalizedString("Type", comment: "")
        nameHeader.text = NSLocalizedString("Name", comment: "")
        serialNoHeader.text = NSLocalizedString("Serial No", comment: "")
        objectTypeTextField.text = type
        objectNameTextField.text = name
        objectSerialNoTextField.text = serialNo
    }
    
    func setupCell(indexPath: IndexPath, to cell: MachineImageCollectionViewCell) {
        setMachineImageToCollectionView(indexPath: indexPath, onSuccess: { (image) in
            DispatchQueue.main.async {
                cell.machineImageView.image = image
            }
        }, onError: { (error) in
            self.setAlertWithAction(title: "Error", message: error)
        })
        cell.layer.cornerRadius = 10
        cell.machineImageView.contentMode = .scaleAspectFill
    }
}

extension ObjectDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setImageUrlListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "MachineImageCollectionViewCell", for: indexPath) as! MachineImageCollectionViewCell
        setupCell(indexPath: indexPath, to: cell)
        return cell
    }
}

extension ObjectDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension ObjectDetailViewController {
    
    func setSaveButton() {
        let buttonOriginY = topBarHeight + objectDetailView.frame.origin.y + objectDetailView.frame.height + 20
        let viewFrame = CGRect(x: 20, y: buttonOriginY, width: UIScreen.main.bounds.width-40, height: 50)
        setCustomButton(customButton: saveButton, superview: self.view, title: "Save", titleColor: .white, backgroundColor: .systemBlue, viewFrame: viewFrame, cornerRadius: 25)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        saveButton.isHidden = true
    }
    
    func setCancelButton() {
        let buttonOriginY = topBarHeight + objectDetailView.frame.origin.y + objectDetailView.frame.height + 90
        let viewFrame = CGRect(x: 20, y: buttonOriginY, width: UIScreen.main.bounds.width-40, height: 50)
        setCustomButton(customButton: cancelButton, superview: self.view, title: "Cancel", titleColor: .white, backgroundColor: .systemBlue, viewFrame: viewFrame, cornerRadius: 25)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        cancelButton.isHidden = true
    }
    
    @objc func saveButtonAction() {
        guard let machineName = objectNameTextField.text,
            let serialNo = objectSerialNoTextField.text,
            let type = objectTypeTextField.text else { return }
        let machineFolderName = machineViewModel.name
        setAlertWithManyActions(
            title: "Warning",
            message: "Do you realy want to update?",
            onOK: {
                self.firebaseManager.update(machineFolderName: machineFolderName, serialNo: serialNo, type: type)
                self.setLabelText(type: type, name: machineName, serialNo: serialNo)
                self.hideCustomButtons()
                self.closeUserInteraction()
        }, onCancel: {
            self.dismiss(animated: true, completion: nil)
            self.hideCustomButtons()
            self.closeUserInteraction()
        })
    }
    @objc func cancelButtonAction() {
        hideCustomButtons()
        closeUserInteraction()
    }
    
    func openUserInteraction() {
        objectSerialNoTextField.isUserInteractionEnabled = true
        objectTypeTextField.isUserInteractionEnabled = true
    }
    
    func closeUserInteraction() {
        objectSerialNoTextField.isUserInteractionEnabled = false
        objectTypeTextField.isUserInteractionEnabled = false
    }
    
    func showCustomButtons() {
        saveButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    func hideCustomButtons() {
        cancelButton.isHidden = true
        saveButton.isHidden = true
    }
}
