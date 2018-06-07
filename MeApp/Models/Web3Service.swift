//
//  Web3Service.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/7/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import Geth
import web3swift
import Alamofire

public class Service{
    
   static func createNewAccount(username:String, password:String) {
        let configuartion = EthAccountConfiguration(namespace: username, password: password)
        let (keystoreA, accountA): (GethKeyStore?,GethAccount?) = EthAccountCoordinator.default.launch(configuartion)
        let configB = EthAccountConfiguration(namespace: "walletB", password: "12345")
        let (keystoreB, accountB): (GethKeyStore?,GethAccount?) = EthAccountCoordinator.default.launch(configB)
        if let walletAAccountAddress: GethAddress = accountA?.getAddress() {
            let amount = GethBigInt.bigInt(valueInEther:50)!
            let transferFunction = EthFunction(name: "transfer", inputParameters: [walletAAccountAddress, amount])
            let encodedTransferFunction = web3swift.encode(transferFunction)
            print("\(encodedTransferFunction.toHexString())")
            let nonce: Int64 = 4 // Update this to valid nonce
            let gasPrice = GethNewBigInt(20000000000)!
            let gasLimit = GethNewBigInt(4300000)!
            let contractAddress = accountA?.getAddress().getHex()
            var addressError: NSError? = nil
            let gethContractAddress: GethAddress! = GethNewAddressFromHex(contractAddress, &addressError)
            let signedTx = web3swift.sign(address: gethContractAddress, encodedFunctionData: encodedTransferFunction, nonce: nonce, gasLimit: gasLimit, gasPrice: gasPrice)
            let signedTxData = try! signedTx?.encodeRLP()
            print("\(signedTxData!.toHexString())\n\(signedTxData!.bytes)")
            let base64SignedTx = signedTxData?.base64EncodedString()
            let parameters: Parameters = [
                "signedTx" : base64SignedTx,
                ]
            print(base64SignedTx)
        }
       
    }
    
    func signTransaction(){
      
    }
}
