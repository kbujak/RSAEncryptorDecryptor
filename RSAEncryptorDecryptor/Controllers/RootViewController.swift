//
//  RootViewController.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 30/12/2019.
//  Copyright © 2019 Booyac IT. All rights reserved.
//

import UIKit
import PureLayout
import RxSwift

class RootViewController: UIViewController {
    private let publicKeyButton = UIButton()
    private let privacyKeyButton = UIButton()
    private let publicKeyLabel = UILabel()
    private let privateKeyLabel = UILabel()

    private let viewModel: RootViewModel
    private let bag = DisposeBag()

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [publicKeyButton, privacyKeyButton, publicKeyLabel, privateKeyLabel].forEach { view.addSubview($0) }

        setupLayouts()
        setupStyles()
        bindViewToViewModel()
    }
}

private extension RootViewController {
    func setupLayouts() {

        publicKeyLabel.autoPinEdge(.top, to: .top, of: view, withOffset: 100)
        publicKeyLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 10)

        privateKeyLabel.autoPinEdge(.top, to: .top, of: publicKeyLabel, withOffset: 50)
        privateKeyLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 10)

        publicKeyButton.autoAlignAxis(.vertical, toSameAxisOf: view)
        publicKeyButton.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -130)
        publicKeyButton.autoSetDimension(.height, toSize: 50)
        publicKeyButton.autoSetDimension(.width, toSize: 200)

        privacyKeyButton.autoAlignAxis(.vertical, toSameAxisOf: view)
        privacyKeyButton.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -50)
        privacyKeyButton.autoSetDimension(.height, toSize: 50)
        privacyKeyButton.autoSetDimension(.width, toSize: 200)
    }

    func setupStyles() {
        view.backgroundColor = .white

        publicKeyLabel.text = "KPub: not generated"
        privateKeyLabel.text = "KPriv: not generated"

        publicKeyLabel.font = UIFont.boldSystemFont(ofSize: 12)
        privateKeyLabel.font = UIFont.boldSystemFont(ofSize: 12)

        publicKeyButton.setTitle("Choose public key", for: .normal)
        publicKeyButton.setTitleColor(.white, for: .normal)
        publicKeyButton.backgroundColor = .lightGray

        privacyKeyButton.setTitle("Choose private key", for: .normal)
        privacyKeyButton.setTitleColor(.white, for: .normal)
        privacyKeyButton.backgroundColor = .lightGray
    }
    
    func bindViewToViewModel() {
        let input = RootViewModel.Input(
            publicKeyTrigger: publicKeyButton.rx.tap.asDriver(),
            privateKeyTrigger: privacyKeyButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)

        [
            output.publicKey
                .map { "KPub: {\($0.firstComponent), \($0.secondComponent)}" }
                .drive(publicKeyLabel.rx.text),

            output.privateKey
                .map { "KPriv: {\($0.firstComponent), \($0.secondComponent)}" }
                .drive(privateKeyLabel.rx.text),

        ].forEach { $0.disposed(by: bag) }
    }
}

