//
//  StringConverter.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 05/01/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation

class StringConverter {
    static let instance = StringConverter()

    func convertFromASCIICodeToCharacterString(_ asciiCode: String) -> String {
        let numberCount = asciiCode.count
        let firstStringCodeStartIndex = asciiCode.startIndex
        let firstStringCodeEndIndex = numberCount == 5
            ? asciiCode.index(firstStringCodeStartIndex, offsetBy: 1)
            : asciiCode.index(firstStringCodeStartIndex, offsetBy: 2)
        let secondStringCodeStartIndex = asciiCode.index(after: firstStringCodeEndIndex)
        let secondStringCodeEndIndex = asciiCode.endIndex

        let firstStringCode = asciiCode[firstStringCodeStartIndex...firstStringCodeEndIndex]
        let secondStringCode = asciiCode[secondStringCodeStartIndex..<secondStringCodeEndIndex]

        guard let firstCode = Int(firstStringCode), let secondCode = Int(secondStringCode) else { fatalError("Could not convert") }

        let firstCharacter = String(UnicodeScalar(UInt8(firstCode)))
        let secondCharacter = String(UnicodeScalar(UInt8(secondCode)))

        print("\(firstCharacter)\(secondCharacter)")
        return "\(firstCharacter)\(secondCharacter)"
    }
}
