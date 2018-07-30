//
//  ViewController.swift
//  iTA
//
//  Created by Shuyang Zang on 2018-07-03.
//  Copyright © 2018 Shuyang Zang. All rights reserved.
//

import UIKit
import LocalAuthentication
import Alamofire

class ViewController: UIViewController {
    
    var userName = ""
    var password = ""
    @IBOutlet weak var TeacherLogin: UIButton!
    @IBOutlet weak var StudentLogin: UIButton!
    
    @IBOutlet weak var passworderror: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userName = ""
        password = ""
        passworderror.text = ""
        TeacherLogin.addTarget(self, action: #selector(getter: ViewController.TeacherLogin), for: UIControlEvents.touchUpInside)
        StudentLogin.addTarget(self, action: #selector(getter: ViewController.StudentLogin), for: UIControlEvents.touchUpInside)
    }
    
    @IBAction func EnterUserName(_ sender: UITextField) {
        userName = sender.text!
    }
    
    @IBAction func EnterPassword(_ sender: UITextField) {
        password = sender.text!
    }
    
    @IBAction func TeacherLogin(_ sender: Any) {
        print("asfasf")
        authenticationWithFaceID(userName: userName, password: password, status: "teacher")
    }
    
    
    @IBAction func StudentLogin(_ sender: Any) {
        print(":sad")
        authenticationWithFaceID(userName: userName, password: password, status: "student")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    func authenticationWithFaceID( userName: String, password: String, status: String) {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    //TODO: User authenticated successfully, take appropriate action
                    let baseURL:URL = URL(string: "http://localhost:3001/")!
                    
                    Alamofire.request(baseURL.appendingPathComponent("users"), method: .get, parameters: ["username": userName, "password": password, "status": status], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
                        response in
                        switch response.result {
                        case .success:
                            print("success login")
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "Authentication")
                            self.present(VC!, animated: true, completion: nil)
                        case .failure(let new_error):
                            self.passworderror.text = new_error as? String
                        }
                    })
                    
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}
