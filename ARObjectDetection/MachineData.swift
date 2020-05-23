//
//  BaseClassReadingData.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 23.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

protocol MachineDataProtocol {
    func setMachineData(onSuccess: @escaping () -> Void)
    
    func setMachineImage(indexPath: IndexPath, onSuccess: @escaping (UIImage) -> Void)
    
    func setImageUrlListCount() -> Int

}

class MachineData: UIViewController, MachineDataProtocol {
 
    var firebaseManager = FirebaseManager()
    var machineListViewModel: MachineListViewModel!
    var machineImageData: MachineViewModel!

    func setMachineData(onSuccess: @escaping () -> Void) {
        firebaseManager.getMachineData(onSuccess: { machineinfo in
            DispatchQueue.main.async {
                self.machineListViewModel = MachineListViewModel(machineList: machineinfo)
                onSuccess()
            }
        })
    }
        
    func setImageUrlListCount() -> Int {
           guard let machineImageData = machineImageData else { return 0 }
               let urlList = machineImageData.imageUrlList
               let urlListCount = urlList.count
               return urlListCount
     }
    
    func setMachineImage(indexPath: IndexPath, onSuccess: @escaping (UIImage) -> Void) {
        guard let machineImageData = machineImageData else { return }
        let urlList = machineImageData.imageUrlList
        if let imageURL = URL(string: urlList[indexPath.row]) {
            firebaseManager.getImage(from: imageURL) { (image, error) in
                DispatchQueue.main.async {
                    guard let image = image, error == nil else { return }
                    onSuccess(image)
                }
            }
        }
    }
}
