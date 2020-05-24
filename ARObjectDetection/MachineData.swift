//
//  BaseClassReadingData.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 23.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import Foundation
import UIKit

protocol MachineDataProtocol {
    func setMachineData(onSuccess: @escaping () -> Void)
    
    func setMachineImageToCollectionView(indexPath: IndexPath, onSuccess: @escaping(UIImage) -> Void, onError: @escaping(String) -> Void)
    
    func setMachineImages(onSuccess: @escaping(UIImage, String) -> Void, onError: @escaping(String) -> Void)

    func setImageUrlListCount() -> Int
}

class MachineData: UIViewController, MachineDataProtocol {

    var firebaseManager = FirebaseManager()
    var machineListViewModel: MachineListViewModel!
    var machineImageData: MachineViewModel?

    func setMachineData(onSuccess: @escaping () -> Void) {
        firebaseManager.getMachineData(onSuccess: { machineinfo in
            DispatchQueue.main.async {
                self.machineListViewModel = MachineListViewModel(machineList: machineinfo)
                onSuccess()
            }
        })
    }
    
    func setMachineImageToCollectionView(indexPath: IndexPath, onSuccess: @escaping (UIImage) -> Void, onError: @escaping (String) -> Void) {
        guard let machineImageData = machineImageData else { return }
        let urlList = machineImageData.imageUrlList
        if let imageURL = URL(string: urlList[indexPath.row]) {
            firebaseManager.getImage(from: imageURL) { (image, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        onError(error?.localizedDescription ?? "Error")
                    }
                    guard let image = image else { return }
                    onSuccess(image)
                    
                }
            }
        }
    }
    
    func setMachineImages(onSuccess: @escaping (UIImage, String) -> Void, onError: @escaping (String) -> Void) {
        for index in 0..<machineListViewModel.numberOfRowsInSection() {
            let machineViewModel = self.machineListViewModel.machineAtIndex(index)
            machineImageData = machineViewModel
            
            guard let machineImageData = machineImageData else { return }
            let urlListCount = machineImageData.imageUrlList.count
            for indexx in 0..<urlListCount {
                let urlList = machineImageData.imageUrlList
                if let imageURL = URL(string: urlList[indexx]) {
                    firebaseManager.getImage(from: imageURL) { (image, error) in
                        DispatchQueue.main.async {
                            if error != nil {
                                onError(error?.localizedDescription ?? "Error")
                            }
                            let name = machineImageData.name

                            guard let image = image else { return }
                            onSuccess(image, name)
                        }
                    }
                }
            }
        }
    }
    
    func setImageUrlListCount() -> Int {
        guard let machineImageData = machineImageData else { return 0 }
        let urlList = machineImageData.imageUrlList
        let urlListCount = urlList.count
        return urlListCount
    }
}
