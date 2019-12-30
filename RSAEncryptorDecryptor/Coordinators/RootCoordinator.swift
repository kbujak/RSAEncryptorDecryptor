//
//  RootCoordinator.swift
//  RSAEncryptorDecryptor
//
//  Created by Krystian Bujak on 30/12/2019.
//  Copyright © 2019 Booyac IT. All rights reserved.
//

import UIKit

enum SelectedKeyType {
    case `public`, `private`
}

class RootCoordinator: NSObject {
    private var controller: RootViewController?
    private var viewModel: RootViewModel?
    private var selectedKey: SelectedKeyType? = nil

    func start(in window: UIWindow) {
        let VM = RootViewModel()
        viewModel = VM
        VM.delegate = self
        let rootController = RootViewController(viewModel: VM)
        self.controller = rootController

        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
}

extension RootCoordinator: RootViewControllerDelegate {
    func didTapChoosePrivateKey() {
        presentDocumentPicker()
        selectedKey = .private
    }

    func didTapChoosePublicKey() {
        presentDocumentPicker()
        selectedKey = .public
    }

    func presentDocumentPicker() {
        let VC = UIDocumentPickerViewController(documentTypes: ["public.composite-content"], in: .import)
        VC.delegate = self
        controller?.present(VC, animated: true, completion: nil)
    }
}

extension RootCoordinator: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, let selectedKeyType = selectedKey else { return }
        selectedKeyType == .public ? viewModel?.retrievePublicKey(from: url) : viewModel?.retrievePrivateKey(from: url)
        selectedKey = nil
    }
}
