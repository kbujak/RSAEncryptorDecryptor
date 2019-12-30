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
    private let publicKey = BehaviorRelay<Key?>(value: nil)
    private let privateKey = BehaviorRelay<Key?>(value: nil)
    private let bag = DisposeBag()

    init(fileManagerFacade: FileManagerFacade = FileManagerFacadeImpl()) {
        self.fileManagerFacade = fileManagerFacade
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

        let publicKey = self.publicKey.filter { $0 != nil }.map { $0! }
        let privateKey = self.privateKey.filter { $0 != nil }.map { $0! }

        return Output(
            publicKey: publicKey.asDriver(onErrorRecover: { _ in Driver.never() }),
            privateKey: privateKey.asDriver(onErrorRecover: { _ in Driver.never() })
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
    }

    struct Output {
        let publicKey: Driver<Key>
        let privateKey: Driver<Key>
    }
}

private extension RootViewModel {
    func retrieveKey(from url: URL) -> Key? {
        guard
            let keyData = fileManagerFacade.retrieveKeyData(from: url),
            let firstComponent = UInt64(keyData.0),
            let secondComponent = UInt64(keyData.1)
        else { return nil }

        return Key(firstComponent: firstComponent, secondComponent: secondComponent)
    }
}
