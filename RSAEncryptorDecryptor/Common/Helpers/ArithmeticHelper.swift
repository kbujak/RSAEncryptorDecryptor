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

    func modExponentiation(base: Decimal, exponent: Decimal, mod: Decimal) -> Decimal {
        var (a, mTemp, n) = (base, exponent, mod)
        var wynik = Decimal(1)
        var a2: Decimal = modulo(a: a, mod: n)

        if modulo(a: mTemp, mod: 2) == 1 { wynik = a2 }
        
        mTemp = mTemp / 2
        var m = Decimal()
        NSDecimalRound(&m, &mTemp, 0, .down)

        while m != 0 {
            a2 = (modulo(a: a2 * a2, mod: n))
            if modulo(a: m, mod: 2) == 1 { wynik = modulo(a: (wynik * a2), mod: n) }
            m = m / 2
            var mTemp2 = Decimal()
            NSDecimalRound(&mTemp2, &m, 0, .down)
            m = mTemp2
        }

        return wynik
    }

    func modulo(a: Decimal, mod: Decimal) -> Decimal {
        var temp = a / mod
        var roundendTemp = Decimal()
        NSDecimalRound(&roundendTemp, &temp, 0, .down)
        let result = a - (roundendTemp * mod)
        return result
    }
}
