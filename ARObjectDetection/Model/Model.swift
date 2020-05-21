//
//  MachineModel.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 14.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

struct MachineModel: Codable {
    let imageUrlList: [String]?
    let name: String?
    var type: String?
    var serialNo: String?

    init (imageUrlList: [String], name: String, type: String, serialNo: String) {
        self.imageUrlList = imageUrlList
        self.name = name
        self.type = type
        self.serialNo = serialNo
    }
}
