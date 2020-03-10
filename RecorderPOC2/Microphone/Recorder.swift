//
//  Recorder.swift
//  RecorderPOC2
//
//  Created by Julien Sanchez on 10/03/2020.
//  Copyright © 2020 Julien Sanchez. All rights reserved.
//

import Foundation
import AVFoundation

class Recorder: ObservableObject {
    private var audioRecorder: AVAudioRecorder
    private var audioPlayer: AVAudioPlayer?
    private var recorderSettings: [String:Any]
    private var url: URL
    
    @Published public var isRecording: Bool
    @Published public var hasRecording: Bool
    
    init() {
        self.isRecording = false;
        self.hasRecording = false;
        
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    fatalError("You must allow audio recording for this demo to work")
                }
            }
        }
        
        self.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("current_recording.m4a")
        do {
            try "".write(to: url, atomically: true, encoding: .utf8)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        print(self.url.description);
        
//        self.recorderSettings = [
//            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
//            AVSampleRateKey: 44100.0,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
//        ]
        
        self.recorderSettings = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC_LD),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
        
        self.audioPlayer = nil
    }
    
    public func startRecording() {
        self.audioRecorder.record();
    }
    
    public func stopRecording() {
        self.audioRecorder.stop();
        hasRecording = true;
    }
    
    public func playRecording() {
        do {
            print(url.description)
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch let error {}
    }
}
