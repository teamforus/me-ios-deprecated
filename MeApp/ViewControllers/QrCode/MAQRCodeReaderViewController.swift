//
//  MAQRCodeReaderViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import QRCodeReader
import Alamofire

class MAQRCodeReaderViewController: UIViewController {
    lazy var reader: QRCodeReader = QRCodeReader()
    
    
    @IBOutlet weak var previewQR: QRCodeReaderView!{
        didSet {
            previewQR.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: true, reader: reader)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard checkScanPermissions(), !reader.isRunning else { return }
        
        reader.didFindCode = { result in
            print("Completion with result: \(result.value) of type \(result.metadataType)")
            if result.value.range(of:"authToken") != nil {
                 self.reader.startScanning()
                var token = result.value.components(separatedBy: ":")
                let parameter: Parameters = ["auth_token" : token[1]]
                AuthorizeTokenRequest.authorizeToken(parameter: parameter, completion: { (response) in
                    self.reader.startScanning()
                }, failure: { (error) in
                    AlertController.showError()
                    self.reader.startScanning()
                })
            }else if result.value.range(of:"uuid") != nil{
                
                var token = result.value.components(separatedBy: ":")
                RecordsRequest.readValidationTokenRecord(token: token[1], completion: { (response) in
                     self.reader.startScanning()
                    let alert: UIAlertController
                    alert = UIAlertController(title: response.name, message: response.value, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Aprove", style: .default, handler: { (action) in
                        self.reader.startScanning()
                        RecordsRequest.aproveValidationTokenRecord(token: token[1], completion: { (response) in
                             self.reader.startScanning()
                        }, failure: { (error) in
                            AlertController.showError()
                             self.reader.startScanning()
                        })
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.reader.startScanning()
                    }))
                    self.present(alert, animated: true, completion: nil)
                 
                }, failure: { (error) in
                    self.reader.startScanning()
                })
            }else {
                let data = result.value.data(using: .utf8)!
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                    {
                        if jsonArray["value"] as! String == "auth_token"{
                        let parameter: Parameters = ["auth_token" : jsonArray["value"] as! String]
                        AuthorizeTokenRequest.authorizeToken(parameter: parameter, completion: { (response) in
                            self.reader.startScanning()
                        }, failure: { (error) in
                            AlertController.showError()
                            self.reader.startScanning()
                        })
                        }else{
                            RecordsRequest.readValidationTokenRecord(token: jsonArray["value"] as! String, completion: { (response) in
                                self.reader.startScanning()
                                let alert: UIAlertController
                                alert = UIAlertController(title: response.name, message: response.value, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Aprove", style: .default, handler: { (action) in
                                    self.reader.startScanning()
                                    RecordsRequest.aproveValidationTokenRecord(token: jsonArray["value"] as! String, completion: { (response) in
                                        self.reader.startScanning()
                                    }, failure: { (error) in
                                        AlertController.showError()
                                        self.reader.startScanning()
                                    })
                                }))
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                                    self.reader.startScanning()
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }, failure: { (error) in
                                self.reader.startScanning()
                            })
                        }
                    } else {
                        self.reader.startScanning()
                    }
                } catch let error as NSError {
                    print(error)
                    self.reader.startScanning()
                }
            }
        }
        
        
        reader.startScanning()
    }
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:],
                                                      completionHandler: {
                                                        (success) in
                                                        print(" \(success)")
                            })
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
