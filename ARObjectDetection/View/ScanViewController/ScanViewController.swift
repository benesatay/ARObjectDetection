//
//  ScanViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 12.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import ARKit

class ScanViewController: MachineData {
    
    var machineName: String = ""
        
    var ARReferenceImageSet: Set<ARReferenceImage> = Set<ARReferenceImage>()
    
    let customButton = UIButton()
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
        // Set the scene to the view
        sceneView.scene = scene
        
        setCustomButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ARReferenceImageSet.removeAll()
        setMachineData(onSuccess: {
            DispatchQueue.main.async {
                self.setMachineImageToARImageList(onSuccess: {
                    DispatchQueue.main.async {
                        self.setupConfiguration()
                    }
                })
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Pause the view's session
        sceneView.session.pause()
    }
}

extension ScanViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let referenceImage = imageAnchor.referenceImage
            DispatchQueue.main.async {
                self.machineName = referenceImage.name ?? ""
                self.customButton.isHidden = false
            }
        }
        return node
    }
}

extension ScanViewController {
    
    func setMachineImageToARImageList(onSuccess: @escaping() -> Void) {
        setMachineImages(onSuccess: { (image, name) in
            let imageFromBundle = image
            //2. Convert It To A CIImage
            guard let imageToCIImage = CIImage(image: imageFromBundle),
                //3. Then Convert The CIImage To A CGImage
                let cgImage = self.convertCIImageToCGImage(inputImage: imageToCIImage) else { return }
            //4. Create An ARReference Image (Remembering Physical Width Is In Metres)
            let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
            arImage.name = name
            self.ARReferenceImageSet.insert(arImage)
            onSuccess()
            self.activityIndicator.isHidden = true
        }, onError: { (error) in
            self.setAlertWithAction(title: "Error", message: error)
            self.activityIndicator.isHidden = true
        })
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) { return cgImage }
        return nil
    }
    
    func setupConfiguration() {
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = ARReferenceImageSet
        configuration.maximumNumberOfTrackedImages = 1
        // Run the view's session
        sceneView.session.run(configuration, options: ARSession.RunOptions(arrayLiteral: [.resetTracking, .removeExistingAnchors]))
    }
}

extension ScanViewController {
    
    func setCustomButton() {
        customButton.frame = CGRect(x: UIScreen.main.bounds.width - 70, y: 150, width: 50, height: 50)
        customButton.layer.borderColor = UIColor.systemBlue.cgColor
        customButton.layer.cornerRadius = 25
        customButton.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            customButton.setImage(UIImage(systemName: "info"), for: .normal)
        }
        customButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.view.addSubview(customButton)
        customButton.isHidden = true
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        passToDetail(onSuccess: { (viewController) in
            self.navigationController?.pushViewController(viewController, animated: true)
            self.customButton.isHidden = true
        })
    }
    
    func passToDetail(onSuccess: @escaping (ObjectDetailViewController) -> Void) {
        let nib = ObjectDetailViewController(nibName: "ObjectDetailViewController", bundle: nil)
        nib.objectName = self.machineName
        onSuccess(nib)
    }
}



