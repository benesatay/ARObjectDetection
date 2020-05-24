//
//  ObjectDetailViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 12.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class ObjectDetailViewController: MachineData {
    
    var objectName: String = ""
    var machineViewModel: MachineViewModel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var typeHeader: UILabel!
    @IBOutlet weak var nameHeader: UILabel!
    @IBOutlet weak var serialNoHeader: UILabel!
    
    @IBOutlet weak var objectTypeLabel: UILabel!
    @IBOutlet weak var objectNameLabel: UILabel!
    @IBOutlet weak var objectSerialNoLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var objectDetailView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        objectDetailView.layer.cornerRadius = 10
        
        setMachineData(onSuccess: {
            for index in 0..<self.machineListViewModel.machineList.count {
                if self.objectName == self.machineListViewModel.machineAtIndex(index).name {
                    self.machineViewModel = self.machineListViewModel.machineAtIndex(index)
                    self.machineImageData = self.machineViewModel
                }
            }
            self.setLabelText()
            self.imageCollectionView.reloadData()
            self.pageControl.numberOfPages = self.setImageUrlListCount()
            self.activityIndicator.isHidden = true
            print("details were downloaded")
        })


        let imageCollectionViewNib = UINib(nibName: "MachineImageCollectionViewCell", bundle: nil)
        imageCollectionView.register(imageCollectionViewNib, forCellWithReuseIdentifier: "MachineImageCollectionViewCell")
    }
        
    func setLabelText() {
        typeHeader.text = NSLocalizedString("Type", comment: "")
        nameHeader.text = NSLocalizedString("Name", comment: "")
        serialNoHeader.text = NSLocalizedString("Serial No", comment: "")
        
        objectTypeLabel.text = machineViewModel.type
        objectNameLabel.text = machineViewModel.name
        objectSerialNoLabel.text = machineViewModel.serialNo
    }
    
    func setupCell(indexPath: IndexPath, to cell: MachineImageCollectionViewCell) {
        setMachineImageToCollectionView(indexPath: indexPath, onSuccess: { (image) in
            cell.machineImageView.image = image
            cell.machineImageView.contentMode = .scaleAspectFill
        }, onError: { (error) in
            self.setAlertWithAction(title: "Error", message: error)
        })
        cell.layer.cornerRadius = 10
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
