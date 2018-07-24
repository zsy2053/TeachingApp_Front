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

    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Email: UITextField!
    var user_status = "someString"
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Teacher(_ sender: Any) {
        user_status = "teacher"
    }
    @IBAction func Student(_ sender: Any) {
        user_status = "student"
    }
    
    @IBAction func Register(_ sender: Any) {
        let baseURL:URL = URL(string: "http://localhost:3001/")!
        let userName = UserName.text
        let userEmail = Email.text
        
        if (userEmail == nil || userName == nil) {
            //            Display error message
            return
        }
        
        //        Store data
        UserDefaults.standard.set(userEmail, forKey:"userEmail")
        UserDefaults.standard.set(userEmail, forKey:"userName")
        UserDefaults.standard.synchronize()
        Alamofire.request(baseURL.appendingPathComponent("users"), method: .post, parameters: ["username": userName, "email": userEmail, "status": user_status], encoding: JSONEncoding.default, headers: nil).responseJSON (completionHandler: {
            response in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Registration Success", message: "You have successfully registered an iTA account, thank you", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Start studying", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(response.result.value)
                
            case .failure(let error):
                print(error)
            }
        })
    }
}
