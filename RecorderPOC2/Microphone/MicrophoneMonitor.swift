//
//  MicrophoneMonitor.swift
//  RecorderPOC2
//
//  Created by Julien Sanchez on 09/03/2020.
//  Copyright © 2020 Julien Sanchez. All rights reserved.
//

import Foundation
import AVFoundation

class MicrophoneMonitor: ObservableObject {

    private var audioRecorder: AVAudioRecorder
    private var timer: Timer?
    
    private var currentSample: Int
    private let numberOfSamples: Int
    
    @Published public var soundSamples: [Float]
    
    init(numberOfSamples: Int) {
        self.numberOfSamples = numberOfSamples // In production check this is > 0.
        self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        self.currentSample = 0
        
        // 3
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    fatalError("You must allow audio recording for this demo to work")
                }
            }
        }
        
        // 4
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        // 5
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            
            startMonitoring()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // 6
    private func startMonitoring() {
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        var count = 0;
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            // 7
            self.audioRecorder.updateMeters()
            self.audioRecorder.averagePower(forChannel: 0)
            count += 1;
            if (count == 10) {
                self.soundSamples = [self.audioRecorder.averagePower(forChannel: 0) + self.audioRecorder.peakPower(forChannel: 0)] + self.soundSamples[..<(self.numberOfSamples-1)]
                self.currentSample = self.currentSample + 1
                count = 0;
            }
        })
    }
    
    // 8
    deinit {
        timer?.invalidate()
        audioRecorder.stop()
    }
}
