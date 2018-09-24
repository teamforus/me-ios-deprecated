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
    
   static func getNewAccountWithAddress(username:String, password:String) ->(GethKeyStore?, GethAccount?) {
        let configuartion = EthAccountConfiguration(namespace: username, password: password)
    
       return EthAccountCoordinator.default.launch(configuartion)
    }
    
   static func prepareTransaction() -> GethTransaction? {
         let configuartion = EthAccountConfiguration(namespace: "username", password: "assword")
    let (_, account) = EthAccountCoordinator.default.launch(configuartion)
        if let walletAAccountAddress: GethAddress = account?.getAddress() {
            let amount = GethBigInt.bigInt(valueInEther:50)!
            let transferFunction = EthFunction(name: "transfer", inputParameters: [walletAAccountAddress, amount])
            let encodedTransferFunction = web3swift.encode(transferFunction)
            print("\(encodedTransferFunction.toHexString())")
            let nonce: Int64 = 4 // Update this to valid nonce
            let gasPrice = GethNewBigInt(20000000000)!
            let gasLimit = GethNewBigInt(3000000)!
            let contractAddress = account?.getAddress().getHex()
            var addressError: NSError? = nil
            let gethContractAddress = GethNewAddressFromHex(contractAddress, &addressError)
            return web3swift.sign(address: gethContractAddress!, encodedFunctionData: encodedTransferFunction, nonce: nonce, gasLimit: gasLimit, gasPrice: gasPrice)
        }
        return nil
    }
    
 
    
    static func signTranasaction() ->String {
      let signedTx = Service.prepareTransaction()
        let signedTxData = try! signedTx?.encodeRLP()
        print("\(signedTxData!.toHexString())\n\(signedTxData!.bytes)")
        return (signedTxData?.base64EncodedString())!
       
    }
    
    static func sendContract( completion: @escaping (String?, Error?) -> Void) {
        let base64SignedTx = Service.signTranasaction()
        let parameters: Parameters = [
            "signedTx" : base64SignedTx as Any,
            ]
        Alamofire.request("http://requestbin.fullcontact.com/1jttdvr1", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in
            if let data = response.result.value {
                let transactionHash = String(describing: data)
                completion(transactionHash, nil)
            } else {
                completion(nil, nil)
            }
        }
    }

}

extension String{
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
}
