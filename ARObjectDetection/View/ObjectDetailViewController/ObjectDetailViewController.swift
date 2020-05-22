//
//  ObjectDetailViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 12.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class ObjectDetailViewController: UIViewController {
    
    let firebaseManager = FirebaseManager()
    // var machineArray = [MachineModel]()
    var objectName: String = ""
    var machineImageData: MachineViewModel!
    private var machineListViewModel: MachineListViewModel!
    
    @IBOutlet weak var typeHeader: UILabel!
    @IBOutlet weak var nameHeader: UILabel!
    @IBOutlet weak var serialNoHeader: UILabel!
    
    @IBOutlet weak var objectTypeLabel: UILabel!
    @IBOutlet weak var objectNameLabel: UILabel!
    @IBOutlet weak var objectSerialNoLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelText()
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        //pageControl.numberOfPages = setUrlListCount()
        
        setMachineDataToDetail(onSuccess: {
            
            for index in 0..<self.machineListViewModel.machineList.count {
                let machineViewModel = self.machineListViewModel.machineAtIndex(index)
                self.machineImageData = machineViewModel
            }
            print("details were downloaded")
        })
        let imageCollectionViewNib = UINib(nibName: "MachineImageCollectionViewCell", bundle: nil)
        imageCollectionView.register(imageCollectionViewNib, forCellWithReuseIdentifier: "MachineImageCollectionViewCell")
    }
    
    func setLabelText() {
        typeHeader.text = NSLocalizedString("Type", comment: "")
        nameHeader.text = NSLocalizedString("Name", comment: "")
        serialNoHeader.text = NSLocalizedString("Serial No", comment: "")
    }
    
    func setMachineDataToDetail(onSuccess: @escaping () -> Void) {
        firebaseManager.getMachineData(onSuccess: { machineinfo in
            DispatchQueue.main.async {
                self.machineListViewModel = MachineListViewModel(machineList: machineinfo)
                self.imageCollectionView.reloadData()
                onSuccess()
            }
        })
    }
    
    func setUrlListCount() -> Int {
        let urlList = machineImageData.imageUrlList
        let urlListCount = urlList.count
        return urlListCount
    }
    
    func setupCell(indexPath: IndexPath, to cell: MachineImageCollectionViewCell) {
        let urlList = machineImageData.imageUrlList
        if let imageURL = URL(string: urlList[indexPath.row]) {
            firebaseManager.getImage(from: imageURL) { (image, error) in
                DispatchQueue.main.async {
                    cell.machineImageView.image = image
                    cell.machineImageView.contentMode = .scaleAspectFill
                }
            }
        }
    }
}

extension ObjectDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setUrlListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "MachineImageCollectionViewCell", for: indexPath) as! MachineImageCollectionViewCell
        setupCell(indexPath: indexPath, to: cell)
        return cell
    }
}

//extension ObjectDetailViewController: UIScrollViewDelegate {
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//    }
//}
