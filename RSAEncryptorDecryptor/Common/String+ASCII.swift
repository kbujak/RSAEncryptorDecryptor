//
//  String+ASCII.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 30/12/2019.
//  Copyright © 2019 Booyac IT. All rights reserved.
//

import Foundation

extension String {
    var toASCII: [String] {
        return self.compactMap { $0.asciiValue }.map { String(format: "%03d", $0) }
    }
}
