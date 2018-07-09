//
//  PopUpViewController.swift
//  M-POS
//
//  Created by Tolu on 7/3/18.
//  Copyright © 2018 Flutterwave. All rights reserved.
//

import UIKit
import MessageUI

class PopUpViewController: UIViewController, MFMessageComposeViewControllerDelegate {
 
    @IBOutlet weak var popUpView: UIView!
    var phoneNumber : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.popUpView.layer.cornerRadius = 15
        self.popUpView.layer.masksToBounds = true
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUpBtn(_ sender: Any) {
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.15, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func sendSMSBtn(_ sender: Any) {
        
        let msgVC = MFMessageComposeViewController()
        msgVC.body = "Dial *401*00101297*1000#"
        msgVC.recipients = [phoneNumber!]
        msgVC.messageComposeDelegate = self
        
        self.present(msgVC, animated: true, completion: nil)
        
    }
    
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    

}
