//
//  LoginViewController.swift
//  M-POS
//
//  Created by Tolu on 6/11/18.
//  Copyright © 2018 Flutterwave. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginEmailTxt: UITextField!
    @IBOutlet weak var loginPasswordTxt: UITextField!
    var alert = UIAlertController()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //var Token: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "MPOS-Login.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        if (loginPasswordTxt.hasText == false || loginEmailTxt.hasText == false){
            self.alert = UIAlertController(title: "Failed Login", message: "Email or Password Empty" , preferredStyle: .alert)
            self.alert.addAction(UIAlertAction(title: "okay", style: .default, handler: {action in
                self.alert.dismiss(animated: true, completion: nil)
            }))
            self.present(self.alert, animated: true, completion: nil)
        }
            
            // CALL THE LOGIN API
        else {
            activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            let headers = [
                "Content-Type": "application/json",
                "v3-xapp-id": "1",
                "Cache-Control": "no-cache",
                //"Postman-Token": "cd6ccbba-e8c2-4a3a-85bd-fac0f22a9622"
                
            ]
            let parameters = [
                "identifier": "\(loginEmailTxt.text!)",
                "password": "\(loginPasswordTxt.text!)"
                ] as [String : Any]
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.ravepay.co/login")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            do
            {
                let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = postData as Data
            }
            catch
            {
                return
            }
            
            
            
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                    OperationQueue.main.addOperation {
                        self.alert = UIAlertController(title: "Failed Login", message: "Invalid Email or Password" , preferredStyle: .alert)
                        self.alert.addAction(UIAlertAction(title: "okay", style: .default, handler: {action in
                            self.alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(self.alert, animated: true, completion: nil)
                    }
                }
                else {
                    if let data = data {
                        let json = try?  JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        //print(json ?? "Couldn't read json")
                        if let dictionary = json as? [String:Any] {
                            if let nestedDictionary = dictionary["data"] as? [String:AnyObject]{
                                if let token = nestedDictionary["flw-auth-token"] as? String{
                                    DispatchQueue.main.async {
                                        print(token)
                                        self.showHome(token: token)
                                        
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                }
            })
            
            dataTask.resume()
            
        }
    }
    
    func showHome(token:String?){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "showHome") as! UITabBarController
        let homeController =  controller.viewControllers![0] as! ViewController
        homeController.passedAuth = token
        self.present(controller, animated: true)
    }
    
    
    
}
