//
//  Alert.swift
//  ProjectAppIOS
//
//  Created by Роман on 05.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit

class Alert {
    static func displayAlert(message: String) {
        DispatchQueue.main.sync {
            let alert = UIAlertController(title: nil, message: message,preferredStyle: .alert)
            alert.view.backgroundColor = UIColor.black
            alert.view.alpha = 0.4
            alert.view.layer.cornerRadius = 12

            guard let viewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else {
                fatalError("keyWindow has no rootViewController")
                return
            }

            viewController.present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
                alert.dismiss(animated: true)
            }
        }
    }
}
