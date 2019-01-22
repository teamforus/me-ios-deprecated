//
//  AudioRecorder.swift
//  VoiceConverter
//
//  Created by Vivek Jayakumar on 28/6/17.

import UIKit
import Speech


protocol SpeechRecorderDelegate {
    func updateSpeechText(_ text: String)
}


class SpeechRecorder: NSObject, SFSpeechRecognizerDelegate {

    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var delegate: SpeechRecorderDelegate?

    func setupSpeechRecorder()   {

        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            switch authStatus {
            case .authorized:
              break

            case .denied:
                break

            case .restricted:
                break

            case .notDetermined:
                break
            }

        }

    }

    func startRecording()  {

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

         let inputNode = audioEngine.inputNode 

        guard let recognitionRequest = recognitionRequest else {
            return
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in

            var isFinal = false

            if result != nil {

                if let speechText = result?.bestTranscription.formattedString {
                self?.delegate?.updateSpeechText(speechText)
                }
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {
                self?.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
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
        }
    }

    func stopRecording() {

        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        audioEngine.inputNode.removeTap(onBus: 0)
    }

}


