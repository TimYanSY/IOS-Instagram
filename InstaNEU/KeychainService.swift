//
//  KeychainService.swift
//  InstaNEU
//
//  Created by Ashish on 4/16/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation
import KeychainSwift

class KeychainService{
    private var _keychain  = KeychainSwift()
    var KeyChain: KeychainSwift{
        get {
            return _keychain
        }
        set{
            _keychain = newValue
        }
    }
}
