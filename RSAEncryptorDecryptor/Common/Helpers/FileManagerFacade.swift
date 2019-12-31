//
//  FileManagerFacade.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 30/12/2019.
//  Copyright © 2019 Booyac IT. All rights reserved.
//

import Foundation

protocol FileManagerFacade {
    func retrieveStringFromFile() -> String?
    func retrieveKeyData(from url: URL) -> (String, String)?
    func save(encryptedText: String)
}

class FileManagerFacadeImpl: FileManagerFacade {

    private let manager = FileManager.default
    private let path = "/Users/Booyac/Desktop/text"

    func retrieveStringFromFile() -> String? {
        do {
            let fileURL = URL(fileURLWithPath: path).appendingPathExtension("txt")
            print(fileURL.absoluteString)
            return try String(contentsOf: fileURL)
        } catch let error {
            print(error.localizedDescription)
            AppUtility.instance.showError(with: "File doesn't exist")
            return nil
        }
    }

    func retrieveKeyData(from url: URL) -> (String, String)? {
        do {
            var keyText = try String(contentsOf: url)
            keyText.removeFirst()
            keyText.removeLast()
            let keyData = keyText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            guard
                keyData.count == 2,
                let firstComponent = keyData.first,
                let lastComponent = keyData.last
            else { return nil }
            return (firstComponent, lastComponent)
        } catch let error {
            print(error.localizedDescription)
            AppUtility.instance.showError(with: "Could not retrieve text from key file")
            return nil
        }
    }

    func save(encryptedText: String) {
        do {
        let fileURL = URL(fileURLWithPath: path).appendingPathExtension("enc")
            try encryptedText.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch let error {
            print(error.localizedDescription)
            AppUtility.instance.showError(with: "Could not create file")
        }
    }
}
