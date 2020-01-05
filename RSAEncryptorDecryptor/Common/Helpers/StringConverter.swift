//
//  StringConverter.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 05/01/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation

enum StringConverterException: LocalizedError {
    case couldNotConvert

    var errorDescription: String? {
        switch self {
        case .couldNotConvert: return "Could not convert value (probably bad private key was used)"
        }
    }
}

class StringConverter {
    static let instance = StringConverter()

    func convertFromASCIICodeToCharacterString(_ asciiCode: String) throws -> String {
        let numberCount = asciiCode.count
        let firstStringCodeStartIndex = asciiCode.startIndex
        let firstStringCodeEndIndex = numberCount == 5
            ? asciiCode.index(firstStringCodeStartIndex, offsetBy: 1)
            : asciiCode.index(firstStringCodeStartIndex, offsetBy: 2)
        let secondStringCodeStartIndex = asciiCode.index(after: firstStringCodeEndIndex)
        let secondStringCodeEndIndex = asciiCode.endIndex

        let firstStringCode = asciiCode[firstStringCodeStartIndex...firstStringCodeEndIndex]
        let secondStringCode = asciiCode[secondStringCodeStartIndex..<secondStringCodeEndIndex]

        guard
            let firstCode = UInt8(firstStringCode),
            let secondCode = UInt8(secondStringCode)
        else { throw StringConverterException.couldNotConvert }
        
        let firstCharacter = String(UnicodeScalar(UInt8(firstCode)))
        let secondCharacter = String(UnicodeScalar(UInt8(secondCode)))

        print("\(firstCharacter)\(secondCharacter)")
        return "\(firstCharacter)\(secondCharacter)"
    }
}
