//
//  MeterView.swift
//  RecorderPOC2
//
//  Created by Julien Sanchez on 09/03/2020.
//  Copyright © 2020 Julien Sanchez. All rights reserved.
//

import SwiftUI

let numberOfSamples: Int = 100

struct BarView: View {
   // 1
    var value: CGFloat

    var body: some View {
        ZStack {
           // 2
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                // 3
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 1) / CGFloat(numberOfSamples), height: value)
        }
    }
}


struct MeterView: View {
    // 1
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    
    // 2
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    private func lastSamples() -> [Float] {
//        return mic.soundSamples.count > numberOfSamples ? Array<Float>(mic.soundSamples[100...]) : mic.soundSamples;
        return mic.soundSamples;
    }
    
    var body: some View {
        VStack {
             // 3
            HStack(spacing: 1) {
                 // 4
                ForEach(lastSamples(), id: \.self) { level in
                    BarView(value: self.normalizeSoundLevel(level: level))
                }
            }
        }
    }
}

struct MeterView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
