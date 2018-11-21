//
//  PadLogInViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 29/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import StatusAlert

class PadLogInViewController: UIViewController, UITextFieldDelegate {
    
    var loginBG = UIView()
    var loginLogo = UIImageView()
    var loginLabel = UILabel()
    var textField = PaddedTextField()
    var safariVC: SFSafariViewController?
    var statusBarView = UIView()
    var searcherView = UIView()
    var searchTextField = UITextField()
    var backgroundView = UIButton()
    let volumeBar = VolumeBar.shared
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.logged), name: NSNotification.Name(rawValue: "logged"), object: nil)
        self.view.backgroundColor = Colours.white
        print("didload123")
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.loginBG.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.loginBG.backgroundColor = Colours.tabSelected
        self.view.addSubview(self.loginBG)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.createLoginView()
    }
    
    func createLoginView() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.loginBG.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.loginBG.backgroundColor = Colours.tabSelected
                self.view.addSubview(self.loginBG)
//        window.addSubview(self.loginBG)
        
        self.loginLogo.frame = CGRect(x: self.view.bounds.width/2 - 40, y: self.view.bounds.height/4 - 40, width: 80, height: 80)
        self.loginLogo.image = UIImage(named: "logLogo")
        self.loginLogo.contentMode = .scaleAspectFit
        self.loginLogo.backgroundColor = UIColor.clear
                self.view.addSubview(self.loginLogo)
//        window.addSubview(self.loginLogo)
        
        self.loginLabel.frame = CGRect(x: 50, y: self.view.bounds.height/2 - 57.5, width: self.view.bounds.width - 80, height: 35)
        self.loginLabel.text = "Mastodon instance:".localized
        self.loginLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        self.loginLabel.font = UIFont.systemFont(ofSize: 14)
                self.view.addSubview(self.loginLabel)
//        window.addSubview(self.loginLabel)
        
        self.textField.frame = CGRect(x: 40, y: self.view.bounds.height/2 - 22.5, width: self.view.bounds.width - 80, height: 45)
        self.textField.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        self.textField.borderStyle = .none
        self.textField.layer.cornerRadius = 10
        self.textField.textColor = UIColor.white
        self.textField.spellCheckingType = .no
        self.textField.returnKeyType = .done
        self.textField.autocapitalizationType = .none
        self.textField.delegate = self
        self.textField.attributedPlaceholder = NSAttributedString(string: "mastodon.technology",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: Colours.tabSelected])
                self.view.addSubview(self.textField)
//        window.addSubview(self.textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        let wid = self.view.bounds.width - 20
        let he = Int(self.view.bounds.height) - fromTop - fromTop
        
        
        springWithDelay(duration: 0.75, delay: 0.02, animations: {
            self.textField.transform = CGAffineTransform(translationX: 0, y: -40)
        })
        springWithDelay(duration: 0.6, delay: 0, animations: {
            self.loginLabel.transform = CGAffineTransform(translationX: 0, y: -40)
        })
        
        //        if textField.text == "" {} else {
        //            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: Int(he))
        //            springWithDelay(duration: 0.5, delay: 0, animations: {
        //                self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
        //            })
        //            self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(he) - 60)
        //            springWithDelay(duration: 0.5, delay: 0, animations: {
        //                self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
        //            })
        //        }
    }
    
    //    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //        return true
    //    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.searchTextField {
            
            return true
            
            //            var fromTop = 45
            //            if UIDevice().userInterfaceIdiom == .phone {
            //                switch UIScreen.main.nativeBounds.height {
            //                case 2688:
            //                    print("iPhone Xs Max")
            //                    fromTop = 45
            //                case 2436:
            //                    print("iPhone X")
            //                    fromTop = 45
            //                default:
            //                    fromTop = 22
            //                }
            //            }
            //
            //            let wid = self.view.bounds.width - 20
            //            let he = Int(self.view.bounds.height) - fromTop - fromTop
            //
            //            textField.resignFirstResponder()
            //
            //            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
            //            springWithDelay(duration: 0.5, delay: 0, animations: {
            //                self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: Int(he))
            //            })
            //            self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
            //            springWithDelay(duration: 0.5, delay: 0, animations: {
            //                self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(he) - 60)
            //            })
            //
            //            return true
            
            
        } else {
            
            let returnedText = textField.text ?? ""
            if returnedText == "" || returnedText == " " || returnedText == "  " {
                
            } else {
                
                
                DispatchQueue.main.async {
                    self.textField.resignFirstResponder()
                }
                
                // Send off returnedText to client
                StoreStruct.client = Client(baseURL: "https://\(returnedText)")
                let request = Clients.register(
                    clientName: "Mast",
                    redirectURI: "com.shi.mastodon://success",
                    scopes: [.read, .write, .follow],
                    website: "https://twitter.com/jpeguin"
                )
                StoreStruct.client.run(request) { (application) in
                    
                    if application.value == nil {
                        
                        DispatchQueue.main.async {
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Not a valid Instance".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = "Please enter an Instance name like mastodon.technology"
                            statusAlert.show()
                        }
                        
                    } else {
                        let application = application.value!
                        
                        StoreStruct.clientID = application.clientID
                        StoreStruct.clientSecret = application.clientSecret
                        StoreStruct.returnedText = returnedText
                        
                        DispatchQueue.main.async {
                            StoreStruct.redirect = "com.shi.mastodon://success".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                            let queryURL = URL(string: "https://\(returnedText)/oauth/authorize?response_type=code&redirect_uri=\(StoreStruct.redirect!)&scope=read%20write%20follow&client_id=\(application.clientID)")!
                            self.safariVC = SFSafariViewController(url: queryURL)
                            self.present(self.safariVC!, animated: true, completion: nil)
                        }
                    }
                }
            }
            return true
            
        }
    }
    
    
    
    @objc func logged() {
        
        self.loginBG.removeFromSuperview()
        self.loginLogo.removeFromSuperview()
        self.loginLabel.removeFromSuperview()
        self.textField.removeFromSuperview()
        self.safariVC!.dismiss(animated: true, completion: nil)
        
        var request = URLRequest(url: URL(string: "https://\(StoreStruct.returnedText)/oauth/token?grant_type=authorization_code&code=\(StoreStruct.authCode)&redirect_uri=\(StoreStruct.redirect!)&client_id=\(StoreStruct.clientID)&client_secret=\(StoreStruct.clientSecret)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    DispatchQueue.main.async {
                        var customStyle = VolumeBarStyle.likeInstagram
                        customStyle.trackTintColor = Colours.cellQuote
                        customStyle.progressTintColor = Colours.grayDark
                        customStyle.backgroundColor = Colours.white
                        self.volumeBar.style = customStyle
                        //self.volumeBar.start()
                        //self.volumeBar.showInitial()
                    }
                    
                    
                    StoreStruct.accessToken = (json["access_token"] as! String)
                    StoreStruct.client.accessToken = StoreStruct.accessToken
                    
                    UserDefaults.standard.set(StoreStruct.clientID, forKey: "clientID")
                    UserDefaults.standard.set(StoreStruct.clientSecret, forKey: "clientSecret")
                    UserDefaults.standard.set(StoreStruct.authCode, forKey: "authCode")
                    UserDefaults.standard.set(StoreStruct.accessToken, forKey: "accessToken2")
                    UserDefaults.standard.set(StoreStruct.returnedText, forKey: "returnedText")
                    
                    let request = Timelines.home()
                    StoreStruct.client.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.statusesHome = stat
                            StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                        }
                    }
                    
                    
                    
                    print("fetchingall09")
                    
                        if StoreStruct.statusesLocal.isEmpty {
                            let request = Timelines.public(local: true, range: .default)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    StoreStruct.statusesLocal = stat
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                                }
                            }
                        }
                    
                    
                        if StoreStruct.statusesFederated.isEmpty {
                            let request = Timelines.public(local: false, range: .default)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    StoreStruct.statusesFederated = stat
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                                }
                            }
                        }
                    
                    
                    
                    
                    let request2 = Accounts.currentUser()
                    StoreStruct.client.run(request2) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.currentUser = stat
                            
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                            }
                        }
                    }
                    
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    // onboarding
                    //                    if (UserDefaults.standard.object(forKey: "onb") == nil) || (UserDefaults.standard.object(forKey: "onb") as! Int == 0) {
                    //                        DispatchQueue.main.async {
                    //                            self.bulletinManager.prepare()
                    //                            self.bulletinManager.presentBulletin(above: self, animated: true, completion: nil)
                    //                        }
                    //                    }
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
}
