//
//  MachineListViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 16.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class MachineListViewController: UIViewController {
    let firebaseManager = FirebaseManager()
    var machineArray = [MachineModel]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var machineInfoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        
        machineInfoCollectionView.delegate = self
        machineInfoCollectionView.dataSource = self
        
        setMachineData()
        
        let nib = UINib(nibName: "MachineCollectionViewCell", bundle: nil)
        machineInfoCollectionView.register(nib, forCellWithReuseIdentifier: "MachineCollectionViewCell")
    }
    
    func setMachineData() {
        self.machineArray.removeAll()
        firebaseManager.getMachineData(onSuccess: { machineinfo in
            DispatchQueue.main.async {
                self.machineArray = machineinfo
                self.machineInfoCollectionView.reloadData()
                self.activityIndicator.isHidden = true
            }
        })
    }
    
    func setupCell(indexPath: IndexPath, to cell: MachineCollectionViewCell) {
        cell.typeHeader.text = NSLocalizedString("Type", comment: "")
        cell.nameHeader.text = NSLocalizedString("Name", comment: "")
        cell.serialNoHeader.text = NSLocalizedString("Serial No", comment: "")
        
        cell.typeLabel.text = machineArray[indexPath.row].type
        cell.nameLabel.text = machineArray[indexPath.row].name
        cell.serialNoLabel.text = machineArray[indexPath.row].serialNo
        
        let destination = MachineImageViewController(nibName: "MachineImageViewController", bundle: nil)
        destination.imageData = machineArray[indexPath.row]
        let viewFrame = CGRect(x: 0, y: 0, width: cell.subView.frame.width, height: cell.subView.frame.height)
        destination.view.frame = viewFrame
        cell.subView.addSubview(destination.view)
        addChild(destination)

        cell.layer.cornerRadius = 10
    }
}

extension MachineListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-16, height: 403)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return machineArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = machineInfoCollectionView.dequeueReusableCell(withReuseIdentifier: "MachineCollectionViewCell", for: indexPath) as! MachineCollectionViewCell
        setupCell(indexPath: indexPath, to: cell)
        return cell
    }
}
