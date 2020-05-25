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
    
    func setCustomButton(customButton: UIButton, superview: UIView, title: String, titleColor: UIColor, backgroundColor: UIColor, viewFrame: CGRect, cornerRadius: CGFloat) {
        customButton.frame = viewFrame
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(titleColor, for: .normal)
        customButton.backgroundColor = backgroundColor
        customButton.layer.cornerRadius = cornerRadius
        superview.addSubview(customButton)
        customButton.didMoveToSuperview()
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
    
    func setAlertWithManyActions(title: String, message: String, onOK: @escaping () -> Void, onCancel: @escaping () -> Void) {
        let alert = UIAlertController(
            title: NSLocalizedString(title, comment: ""),
            message: NSLocalizedString(message, comment: ""),
            preferredStyle: .alert)
        let okButton = UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default)
        { (UIAlertAction) in
            onOK()
        }
        let cancelButton = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .default)
        { (UIAlertAction) in
            onCancel()
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    
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
