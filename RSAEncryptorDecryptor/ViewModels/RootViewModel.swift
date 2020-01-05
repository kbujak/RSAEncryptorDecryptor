//
//  RootViewModel.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 30/12/2019.
//  Copyright © 2019 Booyac IT. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RootViewControllerDelegate: AnyObject {
    func didTapChoosePublicKey()
    func didTapChoosePrivateKey()
}

class RootViewModel {
    weak var delegate: RootViewControllerDelegate?

    private let fileManagerFacade: FileManagerFacade
    private let rsaManager: RSAManager
    private let publicKey = BehaviorRelay<Key?>(value: nil)
    private let privateKey = BehaviorRelay<Key?>(value: nil)
    private let text = BehaviorRelay<String>(value: "Empty")
    private let bag = DisposeBag()

    init(fileManagerFacade: FileManagerFacade = FileManagerFacadeImpl(), rsaManager: RSAManager = RSAManagerImpl()) {
        self.fileManagerFacade = fileManagerFacade
        self.rsaManager = rsaManager
    }

    func transform(input: RootViewModel.Input) -> RootViewModel.Output {
        input.publicKeyTrigger
            .debug()
            .drive(onNext: {[weak self] in self?.delegate?.didTapChoosePublicKey() })
            .disposed(by: bag)

        input.privateKeyTrigger
            .debug()
            .drive(onNext: {[weak self] in self?.delegate?.didTapChoosePrivateKey() })
            .disposed(by: bag)

        input.encryptTrigger
            .filter { [weak self] _ -> Bool in
                let isPublicKeySet = self?.publicKey.value != nil
                if !isPublicKeySet { AppUtility.instance.showError(with: "Public key not chosen") }
                return isPublicKeySet
            }
            .drive(onNext: { [weak self] in self?.encrypt() })
            .disposed(by: bag)

        input.decryptTrigger
            .filter { [weak self] _ -> Bool in
                let isPrivateKeySet = self?.privateKey.value != nil
                if !isPrivateKeySet { AppUtility.instance.showError(with: "Private key not chosen") }
                return isPrivateKeySet
            }
            .drive(onNext: { [weak self] in self?.decrypt() })
            .disposed(by: bag)

        let publicKey = self.publicKey.filter { $0 != nil }.map { $0! }
        let privateKey = self.privateKey.filter { $0 != nil }.map { $0! }

        return Output(
            publicKey: publicKey.asDriver(onErrorRecover: { _ in Driver.never() }),
            privateKey: privateKey.asDriver(onErrorRecover: { _ in Driver.never() }),
            text: text.asDriver()
        )
    }

    func retrievePublicKey(from url: URL) {
        guard let key = retrieveKey(from: url) else { return }
        self.publicKey.accept(key)
    }

    func retrievePrivateKey(from url: URL) {
        guard let key = retrieveKey(from: url) else { return }
        self.privateKey.accept(key)
    }
}

extension RootViewModel {
    struct Input {
        let publicKeyTrigger: Driver<Void>
        let privateKeyTrigger: Driver<Void>
        let encryptTrigger: Driver<Void>
        let decryptTrigger: Driver<Void>
    }

    struct Output {
        let publicKey: Driver<Key>
        let privateKey: Driver<Key>
        let text: Driver<String>
    }
}

private extension RootViewModel {
    func retrieveKey(from url: URL) -> Key? {
        guard
            let keyData = fileManagerFacade.retrieveKeyData(from: url),
            let firstComponent = Decimal(string: keyData.0),
            let secondComponent = Decimal(string: keyData.1)
        else { return nil }

        return Key(firstComponent: firstComponent, secondComponent: secondComponent)
    }

    func encrypt() {
        guard
            let text = fileManagerFacade.retrievePlainStringFromFile(),
            let key = publicKey.value
        else { return }

        let encryptedArray = rsaManager.encrypt(text: text, with: key)
        let encryptedString = encryptedArray.map { NSDecimalNumber(decimal: $0).stringValue }.joined(separator: ", ")
        self.text.accept("Encrypted text: \n\(encryptedString)")
        fileManagerFacade.save(encryptedText: encryptedString)
    }

    func decrypt() {
        guard
            let text = fileManagerFacade.retrieveEncryptedStringFromFile(),
            let key = privateKey.value
        else { return }

        let decryptedArray = rsaManager.decrypt(text: text, with: key)
        let decryptedNumberStringsArray = decryptedArray.map { NSDecimalNumber(decimal: $0).stringValue }
        do {
            let decryptedArrayString = try decryptedNumberStringsArray.map { number -> String in
                try StringConverter.instance.convertFromASCIICodeToCharacterString(number)
            }
            let decryptedString = decryptedArrayString.reduce("", { $0 + $1 })
            self.text.accept("Decrypted text: \n\(decryptedString)")
            fileManagerFacade.save(decryptedText: decryptedString)
        } catch let error {
            AppUtility.instance.showError(with: error.localizedDescription)
            return
        }
    }
}
