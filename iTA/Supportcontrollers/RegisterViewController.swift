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
    @IBOutlet weak var PasswordError: UILabel!
    @IBOutlet weak var PasswordConfirmError: UILabel!
    
    var user_status = "someString"
    var user_name = ""
    var user_email = ""
    var user_password = ""
    var user_password_confirm = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_name = ""
        user_email = ""
        user_password = ""
        user_password_confirm = ""
        Label.text = "Please Enter User Name"
        EmailCheck.text = "Please Enter User Email"
        PasswordError.text = "Please Enter Password"
        PasswordConfirmError.text = "Please Enter Password Confirm"
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
            checkPassword()
        }
    }
    
    func checkPassword() {
        if (EmailCheck.text == "" && PasswordError.text == "" && PasswordConfirmError.text == "" && !user_status.isEmpty) {
            Register.isEnabled = true
        } else {
            Register.isEnabled = false
        }
    }
    
    @IBAction func EnterPassword(_ sender: UITextField) {
        user_password = sender.text!
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        
        if (user_password.isEmpty) {
            PasswordError.text = "Password Cannot be blank"
            Register.isEnabled = false
        } else if (!NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: sender.text)) {
            PasswordError.text = "Password has to contain at least 8 characters, have at least one letter and one number"
            Register.isEnabled = false
        } else if (!user_password_confirm.isEmpty) {
            if (user_password != user_password_confirm) {
                PasswordError.text = "Password and password confirm do not match"
                PasswordConfirmError.text = "Password and password confirm do not match"
                Register.isEnabled = false
            } else if (user_password == user_password_confirm && NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: sender.text)) {
                PasswordError.text = ""
                PasswordConfirmError.text = ""
                Register.isEnabled = true
            }
        } else {
            PasswordError.text = ""
            checkPassword()
        }
    }
    
    @IBAction func EnterPasswordConfirm(_ sender: UITextField) {
        user_password_confirm = sender.text!
        if (user_password_confirm.isEmpty) {
            PasswordConfirmError.text = "Password confirm cannot be blank"
            Register.isEnabled = false
        } else if (user_password != sender.text) {
            PasswordError.text = "Password and password confirm do not match"
            PasswordConfirmError.text = "Password and password confirm do not match"
            Register.isEnabled = false
        } else {
            PasswordConfirmError.text = ""
            PasswordError.text = ""
            checkPassword()
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

        Alamofire.request(baseURL.appendingPathComponent("users"), method: .post, parameters: ["username": user_name, "email": user_email, "password": user_password, "passwordconfirm": user_password_confirm, "status": user_status], encoding: JSONEncoding.default, headers: nil).responseJSON (completionHandler: {
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
