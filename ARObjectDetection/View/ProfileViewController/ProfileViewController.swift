//
//  ProfileViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 18.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var sectionData: [Int: [String]] = [:]
    var tableViewSections = [String]()
    var tableViewSectionImages = [UIImage]()
    var helpSectionItem = [String]()
    var languageSectionItem = [String]()
    var changePasswordSectionItem = [String]()
    var signOutSectionItem = [String]()
    
    let signOutButton = UIButton()
    let subView = UIView()
    let subViewLabel = UILabel()
    let subviewDoneButton = UIButton()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupTableView()
        setupSubview()
        setupLabelSubview()
        setupButtonSubview()
        setupTableViewSectionsAndItems()
    }
    
    func setupTableViewSectionsAndItems() {
        tableViewSections = [(NSLocalizedString("Help", comment: "")),
                             (NSLocalizedString("Preferred Language", comment: "")),
                             (NSLocalizedString("Change Password", comment: "")),
                             (NSLocalizedString("Sign Out", comment: ""))]
        
        if #available(iOS 13.0, *) {
            tableViewSectionImages = [UIImage(systemName: "info.circle")!,
                                      UIImage(systemName: "globe")!,
                                      UIImage(systemName: "lock.circle")!,
                                      UIImage(systemName: "chevron.left.circle")!]
        }
        
        helpSectionItem = [(NSLocalizedString("Instruction", comment: "")),
                           (NSLocalizedString("About App", comment: "")),
                           (NSLocalizedString("About Us", comment: "")),
                           (NSLocalizedString("Contact", comment: ""))]
        
        guard let languageString = Locale.current.languageCode else { return }
        if languageString == "en" {
            languageSectionItem = [NSLocalizedString("English", comment: "")]
        } else if languageString == "tr" {
            languageSectionItem = [NSLocalizedString("Turkish", comment: "")]
        }
        
        changePasswordSectionItem = [NSLocalizedString("Change Password", comment: "")]
        signOutSectionItem = [NSLocalizedString("Sign Out", comment: "")]
        
        sectionData = [
            0: helpSectionItem,
            1: languageSectionItem,
            2: changePasswordSectionItem,
            3: signOutSectionItem]
    }
    
    func signOut() {
        setAlertWithManyActions(
            title: "Warning",
            message: "Are you sure that you want to sign out?",
            onOK: {
                do {
                    try  Auth.auth().signOut()
                    let signInNavigationController = UINavigationController(rootViewController: SignInViewController())
                    UIApplication.shared.keyWindow?.rootViewController = signInNavigationController
                } catch let error {
                    print(error)
                }
        }, onCancel: {
            self.tableView.reloadData()
        })
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let subView = UIView()
        if #available(iOS 13.0, *) {
            subView.backgroundColor = .systemGray6
        } else {
            //.systemGray6
            tableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        }
        
        let imageView = UIImageView()
        imageView.image = tableViewSectionImages[section]
        imageView.tintColor = .black
        imageView.frame = CGRect(x: 5, y: 35, width: 20, height: 20)
        
        let label = UILabel()
        label.text = tableViewSections[section]
        label.font = .systemFont(ofSize: 15)
        label.frame = CGRect(x: 30, y: 35, width: UIScreen.main.bounds.width-25, height: 20)
        
        subView.addSubview(imageView)
        subView.addSubview(label)
        
        return subView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemText = sectionData[indexPath.section]![indexPath.row]
        if itemText == NSLocalizedString("Sign Out" , comment: "") {
            signOut()
        } else if itemText == NSLocalizedString("Change Password", comment: "") {
            let destination = NewPasswordViewController(nibName: "NewPasswordViewController", bundle: nil)
            navigationController?.pushViewController(destination, animated: true)
            tableView.reloadData()
        } else if itemText == NSLocalizedString("English", comment: "") || itemText == NSLocalizedString("Turkish", comment: "") {
            setAlertWithAction(title: "Warning",
                               message: "You should change the phone language to change the app language!")
            tableView.reloadData()
        } else {
            subViewLabel.text = itemText
            UIView.animate(withDuration: 0.3) {
                self.subView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height/2)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionData[section]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let itemText = sectionData[indexPath.section]![indexPath.row]
        cell.textLabel?.text = itemText
        if itemText == NSLocalizedString("Sign Out" , comment: "") {
            cell.textLabel?.textColor = .systemBlue
        } else if itemText == NSLocalizedString("Change Password", comment: "") {
            cell.textLabel?.textColor = .systemBlue
        }
        return cell
    }
}

extension ProfileViewController {
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .systemGray6
        } else {
            //.systemGray6
            tableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        }
    }
    
    func setupSubview() {
        var viewFrame = UIScreen.main.bounds
        viewFrame.origin.y = UIScreen.main.bounds.height
        subView.frame = viewFrame
        subView.backgroundColor = .black
        subView.alpha = 0.7
        subView.layer.cornerRadius = 10
        view.addSubview(subView)
        subView.didMoveToSuperview()
    }
    
    func setupLabelSubview() {
        subViewLabel.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width-66, height: 50)
        //subViewLabel.textAlignment = .center
        subViewLabel.font = .systemFont(ofSize: 17)
        subViewLabel.textColor = .white
        subView.addSubview(subViewLabel)
        subViewLabel.didMoveToSuperview()
    }
    
    func setupButtonSubview() {
        let viewFrame = CGRect(x: UIScreen.main.bounds.width-58, y: 0, width: 50, height: 50)
        setCustomButton(
            customButton: subviewDoneButton,
            superview: subView,
            title: NSLocalizedString("Done", comment: ""),
            titleColor: .white,
            backgroundColor: .clear,
            viewFrame: viewFrame, cornerRadius: 0)
        subviewDoneButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        UIView.animate(withDuration: 0.3) {
            self.subView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2)
        }
        tableView.reloadData()
    }
}

