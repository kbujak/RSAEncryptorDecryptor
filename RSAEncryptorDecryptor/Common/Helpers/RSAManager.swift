//
//  RSAManager.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 30/12/2019.
//  Copyright © 2019 Booyac IT. All rights reserved.
//

import Foundation

protocol RSAManager {
    func encrypt(text: String, with key: Key) -> [Decimal]
    func decrypt(text: String, with key: Key) -> [Decimal]
}

class RSAManagerImpl: RSAManager {
    func encrypt(text: String, with key: Key) -> [Decimal] {
        var dividedNumberStringArray = text.toASCII
        var mergedNumberStringArray = [String]()

        if dividedNumberStringArray.count % 2 != 0 { dividedNumberStringArray.append("000") }

        for i in 0..<(dividedNumberStringArray.count / 2) {
            let mergedNumberString = "\(dividedNumberStringArray[i * 2])\(dividedNumberStringArray[i * 2 + 1])"
            mergedNumberStringArray.append(mergedNumberString)
        }

        let mergedNumberArray = mergedNumberStringArray.compactMap { Decimal(string: $0) }
        let encryptedArray = mergedNumberArray
            .map { ArithmeticHelper.instance.modExponentiation(base: $0, exponent: key.firstComponent, mod: key.secondComponent) }
        print(mergedNumberArray)
        print(encryptedArray)
        return encryptedArray
    }

    func decrypt(text: String, with key: Key) -> [Decimal] {
        let encryptedNumbers = text.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.compactMap { Decimal(string: $0) }
        let decryptedNumbers = encryptedNumbers
            .map { ArithmeticHelper.instance.modExponentiation(base: $0, exponent: key.firstComponent, mod: key.secondComponent) }
        print(decryptedNumbers)
        return decryptedNumbers
    }
}
