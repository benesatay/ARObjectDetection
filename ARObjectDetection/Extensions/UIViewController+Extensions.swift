//
//  UIViewController+Extensions.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 18.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension UIViewController {
    var topBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return (UIApplication.shared.statusBarFrame.size.height) + (self.navigationController?.navigationBar.frame.size.height ?? 0.0)
        }
    }
    
    func setAlertWithAction(title: String, message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString(title, comment: ""),
            message: NSLocalizedString(message, comment: ""),
            preferredStyle: .alert)
        let okButton = UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default,
            handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
//    func setAlertWithActions(title: String, message: String) {
//        let alert = UIAlertController(
//            title: NSLocalizedString(title, comment: ""),
//            message: NSLocalizedString(message, comment: ""),
//            preferredStyle: .alert)
//        let okButton = UIAlertAction(
//            title: NSLocalizedString("OK", comment: ""),
//            style: .default,
//            handler: nil)
//        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (UIAlertAction) in
//            <#code#>
//        }
//        let cancelButton = UIAlertAction(
//            title: NSLocalizedString("Cancel", comment: ""),
//            style: .default,
//            handler: nil)
//        alert.addAction(okButton)
//        alert.addAction(cancelButton)
//        self.present(alert, animated: true)
//    }
    
    func setAlertWithoutAction(title: String, message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString(title, comment: ""),
            message: NSLocalizedString(message, comment: ""),
            preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }    
}
