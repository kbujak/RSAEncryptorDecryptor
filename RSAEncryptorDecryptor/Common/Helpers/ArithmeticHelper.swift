//
//  ArithmeticHelper.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 30/12/2019.
//  Copyright © 2019 Booyac IT. All rights reserved.
//

import Foundation

class ArithmeticHelper {
    
    static let instance = ArithmeticHelper()

    func modExponentiation(base: UInt64, exponent: UInt64, mod: UInt64) -> UInt64 {
        var (a, m, n) = (Double(base), Double(exponent), Double(mod))
        var wynik: Double = 1
        var a2: Double = modulo(a: a, mod: n)

        if modulo(a: m, mod: 2) == 1 { wynik = a2 }

        m = floor(m / 2)

        repeat {
            a2 = (modulo(a: a2 * a2, mod: n))
            if modulo(a: m, mod: 2) == 1 { wynik = modulo(a: (wynik * a2), mod: n) }
            m = floor(m / 2)
        } while m != 0

        return UInt64(wynik)
    }
    
    func modulo(a: Double, mod: Double) -> Double {
        let temp = floor(a / mod)
        let result = a - (temp * mod)
        return result
    }
}
