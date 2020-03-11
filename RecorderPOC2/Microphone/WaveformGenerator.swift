//
//  WaveformGenerator.swift
//  RecorderPOC2
//
//  Created by Julien Sanchez on 10/03/2020.
//  Copyright © 2020 Julien Sanchez. All rights reserved.
//

import Foundation
import SoundWaveForm

class WavefromGenerator: ObservableObject {
    
    init() {
        
    }
    
    func generate() {
        // Configure the drawings
        let configuration = WaveformConfiguration(
            size: waveFormView.bounds.size,
            backgroundColor: WaveColor.lightGray,
            color: WaveColor.red,
            style: .striped,
            position: .middle,
            scale: 1)

        // Extract the downsampled samples
        // Proceed to extraction
        SamplesExtractor.samples(audioTrack: track,
                timeRange: nil,
                desiredNumberOfSamples: 500,
                onSuccess:{ samples, sampleMax, id in
                    // Let's display the waveform in a view
                    self.waveFormView.image = WaveFormDrawer.image(from: samples, with: configuration)
                },
                onFailure: { error, id in
                    ... // Handle the error e.g: print("\(id ?? "") \(error)")
                }
        )
    }
}
