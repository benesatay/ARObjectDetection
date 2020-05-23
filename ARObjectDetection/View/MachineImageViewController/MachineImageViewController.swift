//
//  MachineImageViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 16.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit


class MachineImageViewController: MachineData {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        pageControl.numberOfPages = setUrlListCount()

        let imageCollectionViewNib = UINib(nibName: "MachineImageCollectionViewCell", bundle: nil)
        imageCollectionView.register(imageCollectionViewNib, forCellWithReuseIdentifier: "MachineImageCollectionViewCell")
    }
    
    func setUrlListCount() -> Int {
        let urlList = machineImageData.imageUrlList
        let urlListCount = urlList.count
        return urlListCount
    }

    
    func setupCell(indexPath: IndexPath, to cell: MachineImageCollectionViewCell) {
        setMachineImage(indexPath: indexPath) { (image) in
            cell.machineImageView.image = image
            cell.machineImageView.contentMode = .scaleAspectFill
        }
    }
}

extension MachineImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

extension MachineImageViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
