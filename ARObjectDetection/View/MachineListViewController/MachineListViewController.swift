//
//  MachineListViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 16.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class MachineListViewController: MachineData {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var machineInfoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        
        machineInfoCollectionView.delegate = self
        machineInfoCollectionView.dataSource = self
        
        DispatchQueue.main.async {
            self.machineInfoCollectionView.reloadData()
        }
        
        setMachineData(onSuccess: {
            self.machineInfoCollectionView.reloadData()
            self.activityIndicator.isHidden = true
        })
        
        let nib = UINib(nibName: "MachineCollectionViewCell", bundle: nil)
        machineInfoCollectionView.register(nib, forCellWithReuseIdentifier: "MachineCollectionViewCell")
    }
    
    func setupCell(indexPath: IndexPath, to cell: MachineCollectionViewCell) {
        cell.typeHeader.text = NSLocalizedString("Type", comment: "")
        cell.nameHeader.text = NSLocalizedString("Name", comment: "")
        cell.serialNoHeader.text = NSLocalizedString("Serial No", comment: "")
        
        let machineViewModel = self.machineListViewModel.machineAtIndex(indexPath.row)
        
        cell.typeLabel.text = machineViewModel.type
        cell.nameLabel.text = machineViewModel.name
        cell.serialNoLabel.text = machineViewModel.serialNo
        
        let destination = MachineImageViewController(nibName: "MachineImageViewController", bundle: nil)
        destination.machineImageData = machineViewModel
        let viewFrame = CGRect(x: 0, y: 0, width: cell.subView.frame.width, height: cell.subView.frame.height)
        destination.view.frame = viewFrame
        cell.subView.addSubview(destination.view)
        addChild(destination)
        
        cell.layer.cornerRadius = 10
    }
}

extension MachineListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = ObjectDetailViewController(nibName: "ObjectDetailViewController", bundle: nil)
        let machineViewModel = self.machineListViewModel.machineAtIndex(indexPath.row)
        destination.objectName = machineViewModel.name
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-16, height: 403)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.machineListViewModel == nil ? 0 : self.machineListViewModel.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = machineInfoCollectionView.dequeueReusableCell(withReuseIdentifier: "MachineCollectionViewCell", for: indexPath) as! MachineCollectionViewCell
        setupCell(indexPath: indexPath, to: cell)
        return cell
    }
}
