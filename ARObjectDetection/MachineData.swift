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
}

class MachineData: UIViewController {
    var firebaseManager = FirebaseManager()
    var machineListViewModel: MachineListViewModel!
    
    func setMachineData(onSuccess: @escaping () -> Void) {
        firebaseManager.getMachineData(onSuccess: { machineinfo in
            DispatchQueue.main.async {
                self.machineListViewModel = MachineListViewModel(machineList: machineinfo)
                onSuccess()
            }
        })
    }
}
