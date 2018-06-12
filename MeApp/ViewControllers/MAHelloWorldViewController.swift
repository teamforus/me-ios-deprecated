//
//  MAHelloWorldViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/12/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Alamofire
import JSONCodable

class MAHelloWorldViewController: UIViewController {

    @IBOutlet weak var nameUITextField: UITextField!
    @IBOutlet weak var messageUITextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        let newMessageJSON = try! NewMessage(name: nameUITextField.text!, message: messageUITextField.text!).toJSON()
        
        Alamofire.request("https://forus.io/api/v1/messages", method: .post, parameters: (newMessageJSON as! Parameters), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
        }
    }
    
    func getMessages(){
        Alamofire.request("https://forus.io/api/v1/messages").responseJSON { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                let messages = try! ResponseMessage(object: json as! JSONObject)
                print(messages)
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
    }
    


}
