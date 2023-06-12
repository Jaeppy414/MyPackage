import Foundation
import web3swift
import Web3Core

public struct MyPackage {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    public func createAccountsAsync(mainNet: [String], completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let bitsOfEntropy: Int = 128
            let mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!
            let keystore = try! BIP32Keystore(
                mnemonics: mnemonics,
                password: "",
                mnemonicsPassword: "",
                language: .english)!
            let address = keystore.addresses!.first!.address
            let privateKey = try! keystore.UNSAFE_getPrivateKeyData(password: "", account: keystore.addresses!.first!)
            
            var results: [[String: String]] = []
            for net in mainNet {
                let result = [
                    "mainNet": net,
                    "address": address,
                    "private": "0x\(privateKey.toHexString())",
                    "mnemonic": mnemonics
                ]
                results.append(result)
            }
            let jsonData = try! JSONSerialization.data(withJSONObject: results)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            completion(jsonString)
        }
    }
}
