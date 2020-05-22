//
//  FirebaseManager.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 15.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import Firebase
import FirebaseDatabase

class FirebaseManager {
    var machineModel: MachineModel?
    
    func writeToStorageMachineImage(
        image: UIImage,
        machineFolderName: String,
        imageName: String,
        onSuccess: @escaping (String) -> Void,
        onError: @escaping (String) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        if let data = image.jpegData(compressionQuality: 0.0) {
            let machineFolder = mediaFolder.child(machineFolderName)
            let imageReference = machineFolder.child(imageName)
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                guard error == nil else {
                    onError(error?.localizedDescription ?? "Error")
                    return
                }
                imageReference.downloadURL { (url, error) in
                    guard error == nil else { return }
                    let imageUrl = url?.absoluteString
                    onSuccess(imageUrl ?? "")
                }
            }
        }
    }

    func writeToFirebase(
        machineFolderName: String,
        imageUrlArray: [String],
        machineName: String,
        serialNo: String,
        type: String) {
        guard let user = Auth.auth().currentUser else { return }
        let firebaseDatabaseRef = Database.database().reference().child("users/\(user.uid)")
        let values = [
            "imageUrlList": imageUrlArray,
            "machineName": machineName,
            "serialNo": serialNo,
            "type": type] as [String : Any]
        firebaseDatabaseRef.child(machineFolderName).setValue(values)
        
    }
    
    func getMachineData(onSuccess: @escaping ([MachineModel]) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let firebaseDatabaseRef = Database.database().reference().child("users/\(user.uid)")
        firebaseDatabaseRef.observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                var machineInfoArray: [MachineModel] = []
                for machineData in snapshot.children.allObjects as! [DataSnapshot] {
                    if let machineObject = machineData.value as? [String:Any],
                        let url = machineObject["imageUrlList"] as? [NSString],
                        let name = machineObject["machineName"] as? NSString,
                        let type = machineObject["type"] as? NSString,
                        let serialNo = machineObject["serialNo"] as? NSString {
                        let imageUrlArray = url as [String]
                        let machineName = name as String
                        let machineType = type as String
                        let machineSerialNo = serialNo as String

                        let machineInfo = MachineModel(
                            imageUrlList: imageUrlArray,
                            name: machineName,
                            type: machineType,
                            serialNo: machineSerialNo)
                        machineInfoArray.append(machineInfo)
                    }
                }
                onSuccess(machineInfoArray)
                
            }
        }
    }
    
    func getImage(from url: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data else { return }
            completion(UIImage(data: data), error)
        }).resume()
    }
}
