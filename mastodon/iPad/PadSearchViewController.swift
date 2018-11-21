//
//  PadSearchViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 30/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SJFluidSegmentedControl

class PadSearchViewController: UIViewController, SJFluidSegmentedControlDataSource, SJFluidSegmentedControlDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var segmentedControl: SJFluidSegmentedControl!
    var typeOfSearch = 0
    var newestText = ""
    var searcherView = UIView()
    var searchTextField = UITextField()
    var backgroundView = UIButton()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        self.view.backgroundColor = Colours.grayDark3
        
        
        self.tableView.register(FollowersCell.self, forCellReuseIdentifier: "cellfs")
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell00")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell002")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tSearch()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    
    func tSearch() {
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let imp = UIImpactFeedbackGenerator()
            imp.impactOccurred()
        }
        
        self.typeOfSearch = 0
        
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.backgroundView.backgroundColor = UIColor.black
        self.backgroundView.alpha = 0.1
//        self.backgroundView.addTarget(self, action: #selector(self.dismissOverlaySearch), for: .touchUpInside)
//        self.view.addSubview(self.backgroundView)
        
        let wid = self.view.bounds.width - 20
        self.searcherView.frame = CGRect(x: 10, y: 5, width: Int(wid), height: Int(self.view.bounds.height - 10))
        self.searcherView.backgroundColor = Colours.grayDark3
        self.searcherView.layer.cornerRadius = 20
        self.searcherView.alpha = 1
        self.searcherView.layer.masksToBounds = true
        self.view.addSubview(self.searcherView)
        
        //text field
        
        searchTextField.frame = CGRect(x: 10, y: 5, width: Int(Int(wid) - 20), height: 40)
        searchTextField.backgroundColor = Colours.grayDark3
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.layer.cornerRadius = 10
        searchTextField.alpha = 1
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...".localized,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:110/250, green: 113/250, blue: 121/250, alpha: 1.0)])
        searchTextField.becomeFirstResponder()
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.textColor = UIColor.white
        searchTextField.keyboardAppearance = UIKeyboardAppearance.dark
        self.searcherView.addSubview(searchTextField)
        
        
        segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: 20, y: 50, width: Int(wid - 40), height: Int(40)))
        segmentedControl.dataSource = self
        segmentedControl.shapeStyle = .roundedRect
        segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
        segmentedControl.cornerRadius = 12
        segmentedControl.shadowsEnabled = false
        segmentedControl.transitionStyle = .slide
        segmentedControl.delegate = self
        self.searcherView.addSubview(segmentedControl)
        
        //table
        
        self.tableView.frame = CGRect(x: 0, y: 110, width: Int(wid), height: Int(self.view.bounds.height - 10))
        self.tableView.alpha = 1
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.grayDark3
        self.tableView.separatorColor = UIColor(red: 50/250, green: 53/250, blue: 63/250, alpha: 1.0)
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        self.searcherView.addSubview(self.tableView)
        
        //animate
        self.searcherView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.searcherView.alpha = 1
            self.searcherView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    
    
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 3
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, titleForSegmentAtIndex index: Int) -> String? {
        if index == 0 {
            return "Hash".localized
        } else if index == 1 {
            return "Related".localized
        } else {
            return "Users".localized
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {
        return [Colours.tabSelected, Colours.tabSelected]
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForBounce bounce: SJFluidSegmentedControlBounce) -> [UIColor] {
        return [Colours.tabSelected, Colours.tabSelected]
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didChangeFromSegmentAtIndex fromIndex: Int, toSegmentAtIndex toIndex: Int) {
        
        if toIndex == 0 {
            self.typeOfSearch = 0
            let request = Timelines.tag(self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat
                        self.tableView.reloadData()
                    }
                }
            }
            //self.tableView.reloadData()
        }
        if toIndex == 1 {
            self.typeOfSearch = 1
            let request = Search.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat.statuses
                        self.tableView.reloadData()
                    }
                }
            }
            //self.tableView.reloadData()
        }
        if toIndex == 2 {
            self.typeOfSearch = 2
            let request = Accounts.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearchUser = stat
                        self.tableView.reloadData()
                    }
                }
            }
            //self.tableView.reloadData()
        }
        
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print("changed")
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        let wid = self.view.bounds.width - 20
        self.newestText = textField.text ?? ""
        if self.typeOfSearch == 0 {
            let theText = textField.text?.replacingOccurrences(of: "#", with: "")
            let request = Timelines.tag(theText ?? "")
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat
                        self.tableView.reloadData()
                    }
                }
            }
        }
        if self.typeOfSearch == 1 {
            let request = Search.search(query: textField.text ?? "")
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat.statuses
                        self.tableView.reloadData()
                    }
                }
            }
        }
        if self.typeOfSearch == 2 {
            
            let request = Accounts.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearchUser = stat
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
        
        
//        if textField.text == "" {
//            self.searcherView.frame = CGRect(x: 10, y: 5, width: Int(wid), height: 340)
//            springWithDelay(duration: 0.7, delay: 0, animations: {
//                self.searcherView.alpha = 1
//                self.searcherView.frame = CGRect(x: 10, y: 5, width: Int(wid), height: 120)
//            })
//            self.tableView.frame = CGRect(x: 0, y: 110, width: Int(wid), height: Int(500))
//            springWithDelay(duration: 0.7, delay: 0, animations: {
//                self.tableView.alpha = 0
//                self.tableView.frame = CGRect(x: 0, y: 110, width: Int(wid), height: Int(0))
//            })
//        } else {
//
//            if self.tableView.alpha == 0 {
//                self.searcherView.frame = CGRect(x: 10, y: 5, width: Int(wid), height: 100)
//                springWithDelay(duration: 0.5, delay: 0, animations: {
//                    self.searcherView.alpha = 1
//                    self.searcherView.frame = CGRect(x: 10, y: 5, width: Int(wid), height: 340)
//                })
//                self.tableView.frame = CGRect(x: 0, y: 110, width: Int(wid), height: Int(0))
//                springWithDelay(duration: 0.5, delay: 0, animations: {
//                    self.tableView.alpha = 1
//                    self.tableView.frame = CGRect(x: 0, y: 110, width: Int(wid), height: Int(500))
//                })
//            }
//
//        }
        
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.typeOfSearch == 2 {
                return StoreStruct.statusSearchUser.count
            } else {
                return StoreStruct.statusSearch.count
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if self.typeOfSearch == 2 {
                print("oomp")
                if StoreStruct.statusSearchUser.count > 0 {
                    print("oomp1")
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellfs", for: indexPath) as! FollowersCell
                    cell.configure(StoreStruct.statusSearchUser[indexPath.row])
                    cell.profileImageView.tag = indexPath.row
                    //cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = UIColor.white
                    cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as! MainFeedCell
                    cell.profileImageView.tag = indexPath.row
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = UIColor.white
                    cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                }
            } else {
                
                if StoreStruct.statusSearch.count > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as! MainFeedCell
                    cell.configure(StoreStruct.statusSearch[indexPath.row])
                    cell.profileImageView.tag = indexPath.row
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = UIColor.white
                    cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as! MainFeedCell
                    cell.profileImageView.tag = indexPath.row
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = UIColor.white
                    cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                }
            }
            
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        StoreStruct.searchIndex = indexPath.row
        if self.typeOfSearch == 2 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "setVC2"), object: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "setVC"), object: nil)
        }
        
        
    }
    
    
    
    
}
