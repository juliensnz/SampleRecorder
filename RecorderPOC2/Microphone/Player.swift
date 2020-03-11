//
//  Recorder.swift
//  RecorderPOC2
//
//  Created by Julien Sanchez on 10/03/2020.
//  Copyright © 2020 Julien Sanchez. All rights reserved.
//

import Foundation
import AVFoundation

class Player: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private var url: URL
    private var timer: Timer?
    
    @Published public var hasRecording: Bool
    
    init() {
        self.hasRecording = false;
                
        self.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("current_recording.wav")
        
        print(self.url.description);
        
        self.audioPlayer = nil
        self.timer = nil
    }
    
    public func playRecording() {
        do {
            print(url.description)
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch _ {
            
        }
    }
    
    public func playRecordingFromTo(from: CGFloat, to: CGFloat) {
        timer?.invalidate();
        
        do {
            print(url.description)
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            if (nil == self.audioPlayer) {
                return
            }
            
            
            let startTime = self.audioPlayer!.duration * TimeInterval(from);
            let endTime = self.audioPlayer!.duration * (TimeInterval(to) - TimeInterval(from) + TimeInterval(0.042661883));
            print("from: "+from.description);
            print("to: "+to.description)
            print("start: "+startTime.description);
            print("end: "+(startTime + endTime).description)
            
            audioPlayer!.prepareToPlay()
            audioPlayer!.currentTime = startTime
            print("current time start: "+audioPlayer!.currentTime.description)
            audioPlayer!.play()
            
            self.timer = Timer.scheduledTimer(withTimeInterval: endTime, repeats: false) {timer in
                print("current time end: "+self.audioPlayer!.currentTime.description)
                self.audioPlayer!.stop()
            }
        } catch _ {
            
        }
    }
    
    deinit {
        self.timer?.invalidate()
    }
}
