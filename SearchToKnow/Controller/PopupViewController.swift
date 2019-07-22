//
//  PopupViewController.swift
//  SearchToKnow
//
//  Created by A on 22/07/19.
//  Copyright © 2019 A. All rights reserved.
//

import UIKit
import Speech
import AVKit
class PopupViewController: UIViewController {

    @IBOutlet weak var searchLbl: UILabel!
    
    @IBOutlet weak var goBtn: UIButton!
    
    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-IN"))
    
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        setupSpeech()
        //searchLbl.text = "Hello"

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goBtnPressed(_ sender: UIButton) {
        
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.goBtn.isEnabled = false
            self.goBtn.setTitle("GO", for: .normal)
        } else {
            self.startRecording()
            self.goBtn.setTitle("STOP", for: .normal)
        }
    }
    
    
  fileprivate func setupSpeech() {
        
        self.goBtn.isEnabled = false
        self.speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.goBtn.isEnabled = isButtonEnabled
            }
        }
    }

   fileprivate func startRecording() {
        
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.searchLbl.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.goBtn.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.searchLbl.text = "Say something, I'm listening!"
    }
    
    
    
    @IBAction func closeBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.speechText, object: self)
        dismiss(animated: false, completion: nil)
    }
    
}


extension Notification.Name {
    static let speechText = Notification.Name("speechText")
}

extension PopupViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.goBtn.isEnabled = true
        } else {
            self.goBtn.isEnabled = false
        }
    }
}
