//
//  RSAManager.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 30/12/2019.
//  Copyright © 2019 Booyac IT. All rights reserved.
//

import Foundation

protocol RSAManager {
    func encrypt(text: String, with key: Key) -> [UInt64]
}

class RSAManagerImpl: RSAManager {
    func encrypt(text: String, with key: Key) -> [UInt64] {
        var dividedNumberStringArray = text.toASCII
        var mergedNumberStringArray = [String]()

        if dividedNumberStringArray.count % 2 != 0 { dividedNumberStringArray.append("000") }

        for i in 0..<(dividedNumberStringArray.count / 2) {
            let mergedNumberString = "\(dividedNumberStringArray[i * 2])\(dividedNumberStringArray[i * 2 + 1])"
            mergedNumberStringArray.append(mergedNumberString)
        }

        let mergedNumberArray = mergedNumberStringArray.compactMap { UInt64($0) }
        let encryptedArray = mergedNumberArray
            .map { ArithmeticHelper.instance.modExponentiation(base: $0, exponent: key.firstComponent, mod: key.secondComponent) }
        print(mergedNumberStringArray)
        print(mergedNumberArray)
        print(encryptedArray)
        return encryptedArray
    }
}
