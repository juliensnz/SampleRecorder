//
//  ContentView.swift
//  RecorderPOC2
//
//  Created by Julien Sanchez on 09/03/2020.
//  Copyright © 2020 Julien Sanchez. All rights reserved.
//

import SwiftUI

struct ActionView: View {
    @ObservedObject private var recorder = Recorder()
    
    var body: some View {
        VStack {
            Button(action: {
                print("start recording")
                self.recorder.startRecording()
            }) {
                Text("Start recording")
            }
            Spacer()
            Button(action: {
                print("stop recording")
                self.recorder.stopRecording()
            }) {
                Text("Stop recording")
            }
            Spacer()
            if (self.recorder.hasRecording) {
                Button(action: {
                    print("play recording")
                    self.recorder.playRecording()
                }) {
                    Text("Play recording")
                }
            }
        }
    }
}

struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
    }
}
