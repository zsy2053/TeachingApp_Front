//
//  PaymentViewController.swift
//  iTA
//
//  Created by xiande Yang on 2018-08-30.
//  Copyright © 2018 Shuyang Zang. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func payTuition(_ sender: Any) {
        print("entered")
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        self.present(addCardViewController, animated: true, completion: nil)
            
    }
}

extension PaymentViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController")
        
        self.present(VC!, animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        StripeClient.shared.completeCharge(with: token, amount: 350) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                
                let alertController = UIAlertController(title: "Congrats", message: "Your payment was successful!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "Authentication")
                    
                    self.present(VC!, animated: true, completion: nil)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            // 2
            case .failure(let error):
                completion(error)
            }
        }
    }
    
}
