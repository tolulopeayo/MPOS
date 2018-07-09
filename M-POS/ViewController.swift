//
//  ViewController.swift
//  M-POS
//
//  Created by Tolu on 6/8/18.
//  Copyright © 2018 Flutterwave. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate{
    @IBOutlet weak var SelectCurrencyBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var paymentDescTxt: UITextField!
    @IBOutlet weak var currencyTxt: UITextField!
    
    
    let currencies = ["NGN", "KES", "GHS", "ZAR", "USD", "GBP", "EUR"]
    var alert = UIAlertController()
    var passedAuth: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "MPOS-Login.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    // HANDLES THE REQUEST PAYMENT BUTTON
    @IBAction func requestPaymentBtn(_ sender: Any) {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        
        
        
        if currencyTxt.hasText {
            let priceString = currencyFormatter.string(from: Double(currencyTxt.text!)! as NSNumber)!
            print(priceString) // Displays $9,999.99 in the US locale
            
            self.alert = UIAlertController(title: "Confirm Payment", message: "Request payment of \(currencyTxt.text!) \(SelectCurrencyBtn.currentTitle!) from \(phoneNumber.text!) ?" , preferredStyle: .alert)
            self.alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in

                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpId") as! PopUpViewController
                popOverVC.phoneNumber = self.phoneNumber.text!
                self.addChildViewController(popOverVC)
                popOverVC.view.frame = self.view.frame
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParentViewController: self)
            }))
            self.alert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
                self.alert.dismiss(animated: true, completion: nil)
            }))
            self.present(self.alert, animated: true, completion: nil)
        }
        else {
            self.alert = UIAlertController(title: "Invalid Amount!", message: " You cannot request for a payment of 0 \(SelectCurrencyBtn.currentTitle!)" , preferredStyle: .alert)
            self.alert.addAction(UIAlertAction(title: "No vex", style: .default, handler: {action in
                self.alert.dismiss(animated: true, completion: nil)
            }))
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    // HHANDLES THE PICKERVIEW CURRENCY BUTTON
    @IBAction func currencyBtn(_ sender: Any) {
        if pickerView.isHidden {
            UIView.animate(withDuration: 0.5){
            self.pickerView.isHidden = false
            }
        }
        else{
            UIView.animate(withDuration: 0.5){
            self.pickerView.isHidden = true
            }
        }
    
    }
    
    // PICKERVIEW DATASOURCE PROTOCOL FUNCTIONS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
   
    // PICKERVIEW DELEGATE PROTOCOL FUNCTIONS
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SelectCurrencyBtn.setTitle(currencies[row], for: .normal)
        pickerView.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 46, height: 30))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 46, height: 30))
        label.text = currencies[row]
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(label)
        return view
    }
    
    
    //TEXTFIELD DELEGATE PROTOCOL FUNCTIONS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currencyTxt.resignFirstResponder()
        phoneNumber.resignFirstResponder()
    }
    
   /* func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterset = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterset)
    }
 */
 
    
    
    
    // HANDLES THE STEPPER BUTTON
    @IBAction func stepperBtn(_ sender: UIStepper) {
        if currencyTxt.hasText {
            currencyTxt.text = String(sender.stepValue + Double(currencyTxt.text!)!)
        }
        else{
            currencyTxt.text = String(sender.stepValue + 0.00)
        }
        
    }
    
 
    
 // Hadnle sending to email
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([emailTxt.text!])
        mailComposerVC.setSubject("Payment Request")
        mailComposerVC.setMessageBody(paymentDescTxt.text!, isHTML: false)
        return mailComposerVC
        
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "could not send mail", message: "your device could not send mail", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func createPaymentLink() {
        let headers = [
            "v3-xapp-id": "1",
            "Content-Type": "application/json",
            "flw-auth-token": "\(passedAuth!)",
        ]
        let parameters = [
            "slug": "\(paymentDescTxt.text!)",
            "name": "\(paymentDescTxt.text!)",
            "meta": "{\"amount\":\(currencyTxt.text!),\"currency\":\"\(SelectCurrencyBtn.titleLabel!.text!)\"}",
            "type": "Single"
            ] as [String : Any]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.ravepay.co/v2/paymentpages/create")! as URL,
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
                
            } else {
                if let data = data {
                    //let httpResponse = response as? HTTPURLResponse
                    //print(httpResponse)
                    let json = try?  JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json ?? "Couldn't read json")
                    //print (self.passedAuth)
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    

}
