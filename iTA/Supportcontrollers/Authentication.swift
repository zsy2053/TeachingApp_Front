//
//  Authentication.swift
//  iTA
//
//  Created by Shuyang Zang on 2018-07-24.
//  Copyright © 2018 Shuyang Zang. All rights reserved.
//

import UIKit
import VimeoNetworking

class Authentication: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSlideMenuButton()
        let appConfiguration = AppConfiguration(
            clientIdentifier: "6acfef25fb4b5bf0996de716a6a6578913cfee68",
            clientSecret: "zf66Fic9htXi5nhoWfGAeQcwSkkAAJ5lofnJEEAK8zP+Sio7LiyLNiSkL3ML9Zw0hKxaDHebcdiIX2hBzph7cLej85fG82NIBrxki60XTkZrY4qLHAcA0TuT7Ts2tyrb",
            scopes: [.Public, .Private],
            keychainService: "com.vimeo.keychain_service"
        )
        let vimeoClient = VimeoClient(appConfiguration: appConfiguration)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
