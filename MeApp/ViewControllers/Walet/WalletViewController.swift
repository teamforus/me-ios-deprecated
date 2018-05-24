//
//  WalletViewController.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/8/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import SwipeCellKit
import Speech
enum WalletCase {
    case token
    case assets
    case passes
}

class WalletViewController: UIViewController,SFSpeechRecognizerDelegate{
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var microUIButton: UIButton!
    var walletCase : WalletCase! = WalletCase.token
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ro"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont(name: "SFProText-Bold", size: 13.0),
                                         NSAttributedStringKey.foregroundColor: UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "Valuta", image: nil, at: 0)
        segmentedControl.insertSegment(withTitle: "Bezit", image: nil, at: 1)
        segmentedControl.insertSegment(withTitle: "Vouchers", image: nil, at: 2)
        segmentedControl.setTitleTextAttributes(largerRedTextSelectAttributes as Any as? [NSAttributedStringKey : Any], for: .normal)
        segmentedControl.underlineSelected = true
        segmentedControl.selectedSegmentContentColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        searchField.placeholderColor(text: "Zoek valuta", withColor: .white)
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        if (sender.selectedSegmentIndex == 0 ){
            walletCase = WalletCase.token
            searchField.placeholderColor(text: "Zoek valuta", withColor: .white)
        }else if (sender.selectedSegmentIndex == 1){
            walletCase = WalletCase.assets
            searchField.placeholderColor(text: "Zoek vermongen", withColor: .white)
        }else if (sender.selectedSegmentIndex == 2){
            walletCase = WalletCase.passes
            searchField.placeholderColor(text: "Zoek vouchers", withColor: .white)
        }
        self.tableView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: Speach
    
    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microUIButton.isEnabled = false
            microUIButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            microUIButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
         let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.searchField.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microUIButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        searchField.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microUIButton.isEnabled = true
        } else {
            microUIButton.isEnabled = false
        }
    }
    
}

    // MARK: UITableViewDelegate

extension WalletViewController: UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell! = nil
        
        switch walletCase {
        case .token:
            let cellWalletSecond = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! WalletSecondTableViewCell
            
            cell = cellWalletSecond
        default:
            let cellWallet = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WaletTableViewCell
            cellWallet.delegate = self
            
            if indexPath.row == 0 {
                cellWallet.titleWalteCategory.text = "Kindpakket"
            }else if indexPath.row == 1 {
                cellWallet.titleWalteCategory.text = "Bike"
            }else if indexPath.row == 2 {
                cellWallet.titleWalteCategory.text = "Kindpakket"
            }
            
            cell = cellWallet
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: SwipeTableViewCellDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let transctionAction = SwipeAction(style: .default, title: "Transaction") { action, indexPath in
        }
        transctionAction.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        transctionAction.textColor = UIColor.lightGray
        transctionAction.image = UIImage(named: "transactionIcon")
        transctionAction.font =  UIFont(name: "SFUIText-Bold", size: 10.0)
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        }
        deleteAction.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        deleteAction.textColor = UIColor.lightGray
        deleteAction.image = UIImage(named: "removeIcon")
        deleteAction.font =  UIFont(name: "SFUIText-Bold", size: 10.0)
        
        switch walletCase {
        case .token: break
        case .assets:
            if orientation == .right {
                return [deleteAction,transctionAction]
            }
            
        case .passes:
            if orientation == .left {
                return [transctionAction]
            }else {
                return [deleteAction]
            }
            
        default: break
            
        }
        return nil
    }
}
