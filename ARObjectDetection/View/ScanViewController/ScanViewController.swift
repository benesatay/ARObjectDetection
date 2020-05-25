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
    
    let infoButton = UIButton()
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupSceneView()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            self.setupMachineData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupSceneView() {
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
        // Set the scene to the view
        sceneView.scene = scene
    }
}

extension ScanViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let referenceImage = imageAnchor.referenceImage
            DispatchQueue.main.async {
                
                self.setInfoButton()
                self.machineName = referenceImage.name ?? ""
                self.infoButton.isHidden = false
            }
        }
        return node
    }
}

extension ScanViewController {
    
    func setupMachineData() {
        ARReferenceImageSet.removeAll()
        setMachineData(onSuccess: {
            DispatchQueue.main.async {
                self.insertImageToARImageList(onSuccess: {
                    DispatchQueue.main.async {
                        self.setupConfiguration()
                    }
                })
            }
        })
    }
    
    func insertImageToARImageList(onSuccess: @escaping() -> Void) {
        setMachineImages(onSuccess: { (image, name) in
            self.convertUIImagetoARReferenceImage(image: image) { (arImage) in
                arImage.name = name
                self.ARReferenceImageSet.insert(arImage)
                onSuccess()
            }
        }, onError: { (error) in
            self.setAlertWithAction(title: "Error", message: error)
        })
        self.activityIndicator.isHidden = true
    }
    
    func convertUIImagetoARReferenceImage(image: UIImage, converted: @escaping (ARReferenceImage) -> Void) {
        let imageFromBundle = image
        //2. Convert It To A CIImage
        guard let imageToCIImage = CIImage(image: imageFromBundle),
            //3. Then Convert The CIImage To A CGImage
            let cgImage = self.convertCIImageToCGImage(inputImage: imageToCIImage) else { return }
        //4. Create An ARReference Image (Remembering Physical Width Is In Metres)
        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
        converted(arImage)
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
    
    func setInfoButton() {
        let viewFrame = CGRect(x: UIScreen.main.bounds.width - 70, y: 150, width: 50, height: 50)
        infoButton.layer.borderColor = UIColor.systemBlue.cgColor
        infoButton.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            infoButton.setImage(UIImage(systemName: "info"), for: .normal)
        }
        setCustomButton(customButton: infoButton, superview: self.view, title: "", titleColor: .clear, backgroundColor: .clear, viewFrame: viewFrame, cornerRadius: 25)
        infoButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        infoButton.isHidden = true
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        passToDetail(onSuccess: { (viewController) in
            self.navigationController?.pushViewController(viewController, animated: true)
            self.infoButton.isHidden = true
        })
    }
    
    func passToDetail(onSuccess: @escaping (ObjectDetailViewController) -> Void) {
        let nib = ObjectDetailViewController(nibName: "ObjectDetailViewController", bundle: nil)
        nib.objectName = self.machineName
        onSuccess(nib)
    }
}



