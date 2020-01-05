//
//  AppUtility.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 30/12/2019.
//  Copyright © 2019 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class AppUtility {
    static let instance = AppUtility()
    
    func showError(with message: String) {
        guard let VC = UIApplication.shared.windows.first?.rootViewController else { return }
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        VC.present(alert, animated: true, completion: nil)
    }
}
