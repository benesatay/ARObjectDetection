//
//  CreatingViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 14.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class CreatingViewController: UIViewController {
    
    var firebaseManager = FirebaseManager()
    private var machineListViewModel: MachineListViewModel!

    var takenPhotoList : Array<UIImage> = []
    var imageUrlArray = [String]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var takenPhotoCollectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var serialNoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true

        nameTextField.delegate = self
        typeTextField.delegate = self
        serialNoTextField.delegate = self
        
        takenPhotoCollectionView.delegate = self
        takenPhotoCollectionView.dataSource = self
        
        setMachineData()
        setupTextField()
        setupNavigationItems()
        editCollectionViewStyle()
        
        let nib = UINib(nibName: "TakenPhotoCollectionViewCell", bundle: nil)
        takenPhotoCollectionView.register(nib, forCellWithReuseIdentifier: "TakenPhotoCollectionViewCell")
        
        DispatchQueue.main.async {
            self.takenPhotoCollectionView.reloadData()
        }
    }
    
    func setupNavigationItems() {
        let backButton = UIBarButtonItem()
        backButton.title = NSLocalizedString("Back", comment: "")
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openCamera))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveMachineData))
        doneButton.title = NSLocalizedString("Done", comment: "")
        cameraButton.tintColor = .black
        doneButton.tintColor = .black
        navigationItem.rightBarButtonItems = [doneButton, cameraButton]
    }
    
    func setMachineData() {
        firebaseManager.getMachineData(onSuccess: { machineinfo in
            DispatchQueue.main.async {
                self.machineListViewModel = MachineListViewModel(machineList: machineinfo)
            }
        })
    }
    
    @objc func saveMachineData() {
        let machineName = (nameTextField.text ?? "noname")
        let machineFolderName = machineName
        let serialNo = serialNoTextField.text ?? ""
        let type = typeTextField.text ?? ""
        self.imageUrlArray.removeAll()
        for machine in self.machineListViewModel.machineList {
            activityIndicator.isHidden = false
            if machineName == machine.name {
                setAlertWithAction(title: "Warning", message: "This name was used before, please enter a different name!")
            activityIndicator.isHidden = true
            } else {
                activityIndicator.isHidden = false
                for (index, image) in takenPhotoList.enumerated() {
                    let imageName = machineFolderName + "\(index)"
                    firebaseManager.writeToStorageMachineImage(
                        image: image,
                        machineFolderName: machineFolderName,
                        imageName: imageName,
                        onSuccess: { (imageUrl) in
                            self.imageUrlArray.append(imageUrl)
                            self.firebaseManager.writeToFirebase(
                                machineFolderName: machineFolderName,
                                imageUrlArray: self.imageUrlArray,
                                machineName: machineName,
                                serialNo: serialNo,
                                type: type)
                            self.setAlertWithoutAction(title: "Success", message: "Added")
                            self.activityIndicator.isHidden = true
                    }, onError: { (error) in
                        self.setAlertWithAction(title: "Error", message: error)
                        self.activityIndicator.isHidden = true
                    })
                }
            }
        }
    }
}

extension CreatingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func openCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            print("no image found")
            return
        }
        takenPhotoList.append(image)
        print("takenPhotoList.count", takenPhotoList.count)
        self.takenPhotoCollectionView.reloadData()
    }
}

extension CreatingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: takenPhotoCollectionView.frame.width, height: takenPhotoCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return takenPhotoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = takenPhotoCollectionView.dequeueReusableCell(withReuseIdentifier: "TakenPhotoCollectionViewCell", for: indexPath) as! TakenPhotoCollectionViewCell
        cell.imageView.image = self.takenPhotoList[indexPath.row]
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    func editCollectionViewStyle() {
        if #available(iOS 13.0, *) {
            takenPhotoCollectionView.backgroundColor = .systemGray6
        }  else {
            //.systemGray6
            takenPhotoCollectionView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        }
        takenPhotoCollectionView.layer.cornerRadius = 10
    }
}

extension CreatingViewController: UITextFieldDelegate {
    
    func setupTextField() {
        editTextField(textField: nameTextField, placeholder: "Name")
        editTextField(textField: typeTextField, placeholder: "Type")
        editTextField(textField: serialNoTextField, placeholder: "Serial No")
    }
    
    func editTextField(textField: UITextField, placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString(placeholder, comment: ""),
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        //underLine
        let underline = CALayer()
        print("textField.frame.width",textField.frame.width)
        underline.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        underline.backgroundColor = UIColor.lightGray.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(underline)
        
    }
}

extension CreatingViewController {
    // hide keyboard when the user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // user presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
