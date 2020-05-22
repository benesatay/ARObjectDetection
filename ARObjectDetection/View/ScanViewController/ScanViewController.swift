//
//  ScanViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 12.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import ARKit

class ScanViewController: UIViewController {
    
    let customButton = UIButton()
    var machineName: String = ""
    var firebaseManager = FirebaseManager()
    
    private var machineListViewModel: MachineListViewModel!
    var machineImageData: MachineViewModel?
    
    var imageArray: [UIImage] = []
    //var machineArray = [MachineModel]()
    var ARImageArray: [ARReferenceImage] = []
    var machineNameArray: [String] = []
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
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
        setMachineDataToScan(onSuccess: {
            DispatchQueue.main.async {
                self.setMachineImageToARImageList()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupConfiguration()
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
    func setCustomButton() {
        customButton.frame = CGRect(x: UIScreen.main.bounds.width / 2, y: 100, width: 50, height: 50)
        customButton.backgroundColor = .black
        customButton.layer.cornerRadius = 25
        customButton.setTitle("i", for: .normal)
        customButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.view.addSubview(customButton)
        customButton.isHidden = true
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        passToDetail(onSuccess: { (viewController) in
            self.navigationController?.pushViewController(viewController, animated: true)
        })
    }
    
    func passToDetail(onSuccess: @escaping (ObjectDetailViewController) -> Void) {
        let nib = ObjectDetailViewController(nibName: "ObjectDetailViewController", bundle: nil)
        nib.objectName = self.machineName
        onSuccess(nib)
    }
}

extension ScanViewController {
    func setMachineDataToScan(onSuccess: @escaping () -> Void) {
        //self.machineArray.removeAll()
        firebaseManager.getMachineData(onSuccess: { machineinfo in
            DispatchQueue.main.async {
                self.machineListViewModel = MachineListViewModel(machineList: machineinfo)
                //  self.machineArray = machineinfo
                onSuccess()
            }
        })
    }
    
    func setMachineImageToARImageList() {
        for index in 0..<machineListViewModel.numberOfRowsInSection() {
            let machineViewModel = self.machineListViewModel.machineAtIndex(index)
            machineImageData = machineViewModel
        }
        //        for index in 0..<machineArray.count {
        //            machineImageData = machineArray[index]
        //        }
        ARImageArray.removeAll()
        guard let machineImageData = machineImageData else { return }
        let urlListCount = machineImageData.imageUrlList.count
        for index in 0..<urlListCount {
            let urlList = machineImageData.imageUrlList
            if let imageURL = URL(string: urlList[index]) {
                firebaseManager.getImage(from: imageURL) { (image, error) in
                    DispatchQueue.main.async {
                        guard let imageFromBundle = image,
                            //2. Convert It To A CIImage
                            let imageToCIImage = CIImage(image: imageFromBundle),
                            //3. Then Convert The CIImage To A CGImage
                            let cgImage = self.convertCIImageToCGImage(inputImage: imageToCIImage) else { return }
                        //4. Create An ARReference Image (Remembering Physical Width Is In Metres)
                        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
                        self.ARImageArray.append(arImage)
                    }
                    print("ARImageArray.count3",self.ARImageArray.count)
                }
            }
        }
        activityIndicator.isHidden = true
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) { return cgImage }
        return nil
    }
    
    func setupConfiguration() {
        let configuration = ARImageTrackingConfiguration()
        for ARImage in ARImageArray {
            ARImage.name = "deneme"
            configuration.trackingImages = [ARImage]
            configuration.maximumNumberOfTrackedImages = 1
        }
        // Run the view's session
        sceneView.session.run(configuration, options: ARSession.RunOptions(arrayLiteral: [.resetTracking, .removeExistingAnchors]))
    }
}

