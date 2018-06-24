//
//  ViewController.swift
//  M-POS
//
//  Created by Tolu on 6/8/18.
//  Copyright © 2018 Flutterwave. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var SelectCurrencyBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var paymentDescTxt: UITextField!
    @IBOutlet weak var currencyTxt: UITextField!
    
    
    let currencies = ["NGN", "KES", "GHS", "ZAR", "USD", "GBP", "EUR"]
    var alert = UIAlertController()
    
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
                self.alert.dismiss(animated: true, completion: nil)
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
    
    //
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
    
   /* @IBOutlet weak var paymentLinkTxt: UITextField!
    @IBAction func testPaymentIinkBtn(_ sender: Any) {
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
        
        do {
            
            guard let postData = try JSONSerialization.data(withJSONObject: parameters, options: []) as?  AnyObject else {return}
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.ravepay.co/login")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as? Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse!.statusCode)
                    if (httpResponse!.statusCode == 200) {
                        OperationQueue.main.addOperation {
                            (self.performSegue(withIdentifier: "showHome", sender: self))
                        }
                    }
                    else{
                        OperationQueue.main.addOperation {
                            self.alert = UIAlertController(title: "Failed Login", message: "Invalid Email or Password" , preferredStyle: .alert)
                            self.alert.addAction(UIAlertAction(title: "okay", style: .default, handler: {action in
                                self.alert.dismiss(animated: true, completion: nil)
                            }))
                            self.present(self.alert, animated: true, completion: nil)
                        }
                        
                    }
                    
                    
                }
            })
            
            dataTask.resume()
        }
        catch {
            print("json error: \(error.localizedDescription)")
        }
        
    }*/
    

}
