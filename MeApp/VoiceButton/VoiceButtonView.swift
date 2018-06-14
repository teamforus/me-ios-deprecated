//
//  VoiceButtonView.swift
//  VoiceConverter
//
//  Created by Vivek Jayakumar on 1/6/17.


import UIKit

/// Voice Button Delegate Protocol
protocol VoiceButtonDelegate {
    func updateSpeechText(_ text: String)
    func startedRecording()
    func stoppedRecording()
    func notifyError(_ error: String)
}


@IBDesignable
class VoiceButtonView: UIView {
    
    // MARK:- Public Properties
    
    /// Button Background Color
    public var buttonBGColor: UIColor? {
        willSet(newColor) {
            if let image = voiceButton.backgroundImage(for: .normal), let color = newColor {
                let newImage = image.maskWithColor(color: color)
                voiceButton.setBackgroundImage(newImage, for: .normal)
            }
        }
    }
    
    /// Button Image Color
    public var buttonImageColor: UIColor? {
        willSet(newColor) {
            if let image = voiceButton.image(for: .normal), let color = newColor {
                let newImage = image.maskWithColor(color: color)
                voiceButton.setImage(newImage, for: .normal)
            }
        }
    }
    
    /// Button foreground Image
    public var buttonImage: UIImage {
        set {
            voiceButton.setImage(newValue, for: .normal)
        }
        get {
            return self.buttonImage
        }
    }
    
    // MARK:- Private Properties
    @IBOutlet fileprivate weak var buttonContainer: UIView!
    @IBOutlet fileprivate weak var voiceButton: UIButton!
    @IBOutlet fileprivate weak var voiceRangeView: UIView!
    @IBOutlet fileprivate weak var spinnerView: SpinnerView!
    private var isRecording: Bool = false
    private var speechRecorder: SpeechRecorder?
    var voiceButtonDelegate: VoiceButtonDelegate?
    
    
    // MARK:- Initialise View
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        buttonContainer = loadViewFromNib()
        buttonContainer.frame = bounds
        // Default Values
        self.buttonBGColor = UIColor(red:0.15, green:0.45, blue:0.66, alpha:1.0) 
        self.buttonImageColor = .white
        addSubview(buttonContainer)
        spinnerView.isHidden = true
        speechRecorder = SpeechRecorder()
        speechRecorder?.delegate = self
        speechRecorder?.setupSpeechRecorder()
    }
    
    private func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return view
        } else {
            return UIView()
        }
    }
    
    // MARK:- Voice Button Actions
    @IBAction func buttonPressed() {
        if self.isRecording == false {
            if let image = self.voiceButton.backgroundImage(for: .normal) {
                let newImage = image.maskWithColor(color: UIColor(red:0.95, green:0.15, blue:0.07, alpha:1.0)) //F22613
                self.voiceButton.setBackgroundImage(newImage, for: .normal)
            }
            self.voiceButton.setImage(#imageLiteral(resourceName: "stop_icon"), for: .normal)
            speechRecorder?.startRecording()
             self.voiceButtonDelegate?.startedRecording()
            
        } else {
            if let image = self.voiceButton.backgroundImage(for: .normal), let color = self.buttonBGColor {
                let newImage = image.maskWithColor(color: color)
                self.voiceButton.setBackgroundImage(newImage, for: .normal)
            }
            self.voiceButton.setImage(UIImage(named: "micro"), for: .normal)
            if let image = self.voiceButton.image(for: .normal), let color =  self.buttonImageColor {
                let newImage = image.maskWithColor(color: color)
                self.voiceButton.setImage(newImage, for: .normal)
            }
            speechRecorder?.stopRecording()
            voiceButtonDelegate?.stoppedRecording()
        }
        self.isRecording = !self.isRecording
    }
    
    //MARK: Spinner
    
    func showLoader() {
        voiceButton.alpha = 0.5
        spinnerView.isHidden = false
    }
    
    func hideLoader() {
        voiceButton.alpha = 1
        spinnerView.isHidden = true
    }
}

extension VoiceButtonView : SpeechRecorderDelegate {
    func updateSpeechText(_ text: String) {
        voiceButtonDelegate?.updateSpeechText(text)
    }
 
}
