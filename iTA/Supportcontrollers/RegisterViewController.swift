//
//  RegisterViewController.swift
//  iTA
//
//  Created by Shuyang Zang on 2018-07-03.
//  Copyright © 2018 Shuyang Zang. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var EmailCheck: UILabel!
    @IBOutlet weak var Register: UIButton!
    var user_status = "someString"
    var user_name = ""
    var user_email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_name = ""
        user_email = ""
        Label.text = "Please Enter User Name"
        EmailCheck.text = "Please Enter User Email"
        Register.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func EnterUserName(_ sender: UITextField) {
        user_name = sender.text!
        if (user_name.isEmpty) {
            Label.text = "Please Enter User Name"
            Register.isEnabled = false
        } else {
            Label.text = ""
            if (EmailCheck.text == "") {
                Register.isEnabled = true
            } else {
                Register.isEnabled = false
            }
        }
    }
 
    @IBAction func EnterEmail(_ sender: UITextField) {
        user_email = sender.text!
        let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
        let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)
        if (user_email.isEmpty) {
            EmailCheck.text = "Please Enter User Email"
            Register.isEnabled = false
        } else if (!__emailPredicate.evaluate(with: sender.text)) {
            EmailCheck.text = "Invalid Email Address"
            Register.isEnabled = false
        } else {
            EmailCheck.text = ""
            if(Label.text == "") {
                Register.isEnabled = true
            } else {
                Register.isEnabled = false
            }
        }
    }
    
    
    @IBAction func Student(_ sender: Any) {
        user_status = "student"
    }
    
    @IBAction func Teacher(_ sender: Any) {
        user_status = "teacher"
    }
    
    
    
    @IBAction func Register(_ sender: Any) {
        let baseURL:URL = URL(string: "http://localhost:3001/")!

        Alamofire.request(baseURL.appendingPathComponent("users"), method: .post, parameters: ["username": user_name, "email": user_email, "status": user_status], encoding: JSONEncoding.default, headers: nil).responseJSON (completionHandler: {
            response in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Registration Success", message: "You have successfully registered an iTA account, thank you", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Start studying", style: .default, handler: {_ in
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "Authentication")
                    
                    self.present(VC!, animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
                
            case .failure(let error):
                print(error)
            }
        })
    }
}
