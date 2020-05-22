//
//  MachineViewModel.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 22.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import Foundation

struct MachineListViewModel {
    let machineList: [MachineModel]
    
    func numberOfRowsInSection() -> Int {
        return self.machineList.count
    }
    
    func machineAtIndex(_ index: Int) -> MachineViewModel {
        let machine = self.machineList[index]
        return MachineViewModel(machine: machine)
    }
}

struct MachineViewModel {
    let machine: MachineModel
    
    var name: String {
        return self.machine.name ?? ""
    }
    
    var imageUrlList: [String] {
        return self.machine.imageUrlList ?? []
    }
    
    var type: String {
        return self.machine.type ?? ""
    }
    
    var serialNo: String {
        return self.machine.serialNo ?? ""
    }
}
