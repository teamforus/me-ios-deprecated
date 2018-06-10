//
//  Web3Provider.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/8/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import Web3
import PromiseKit
import web3swift
import Geth
class Web3Provider{
    static let web3 = Web3(rpcURL: "locatHostbkalaa:8550")
    
    
    func createPrivateKey() -> EthereumPrivateKey{
          return try! EthereumPrivateKey(hexPrivateKey: "0xa26da69ed1df3ba4bb2a231d506b711eace012f1bd2571dfbfff9650b03375af")
    }
    
    func getTransaction(){
        
      
        firstly {
            Web3Provider.web3.eth.getTransactionCount(address: self.createPrivateKey().address, block: .latest)
            }.then { nonce in
                Promise { seal in
                    var tx = try EthereumTransaction(
                        nonce: nonce,
                        gasPrice: EthereumQuantity(quantity: 21.gwei),
                        gasLimit: 21000,
                        to: EthereumAddress(hex: "0xC0866A1a0ed41e1aa75c932cA3c55fad847fd90D", eip55: true),
                        value: EthereumQuantity(quantity: 1.eth),
                        chainId: 1
                    )
                    try tx.sign(with: self.createPrivateKey())
                    seal.resolve(tx, nil)
                }
            }.then { tx in
                Web3Provider.web3.eth.sendRawTransaction(transaction: tx)
            }.done { hash in
                print(hash)
            }.catch { error in
                print(error)
        }
    }
    
   static func getBalance(){
        let configuartion = EthAccountConfiguration(namespace: "username", password: "")
        let (keystore, account) = EthAccountCoordinator.default.launch(configuartion)
        let walletAAccountAddress: GethAddress = (account?.getAddress())!
        let addressContract = try? EthereumAddress(hex: walletAAccountAddress.getHex(), eip55: true)
        Web3Provider.web3.eth.getBalance(address: addressContract!, block: .block(4000000)) { (response) in
            
        }
    }
    
}

extension EthereumTransaction {
    
    func promiseSign(with: EthereumPrivateKey) -> Promise<EthereumTransaction> {
        return Promise { seal in
            var tx = self
            try tx.sign(with: with)
            seal.resolve(tx, nil)
        }
    }
}
