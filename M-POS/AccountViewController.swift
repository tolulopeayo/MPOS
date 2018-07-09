//
//  AccountViewController.swift
//  M-POS
//
//  Created by Tolu on 6/26/18.
//  Copyright © 2018 Flutterwave. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func logoutBtn(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "showHome") as! UITabBarController
        let homeController =  controller.viewControllers![0] as! ViewController
        homeController.passedAuth = ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
