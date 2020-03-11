//
//  Recorder.swift
//  RecorderPOC2
//
//  Created by Julien Sanchez on 10/03/2020.
//  Copyright © 2020 Julien Sanchez. All rights reserved.
//

import Foundation
import AVFoundation

class Trimer: ObservableObject {
    private var url: URL
    
    @Published public var start: CGFloat
    @Published public var end: CGFloat
    
    init(url: URL) {
        start = 0.2;
        end = 0.7;
        self.url = url
    }
    
    public func changeTrim(position: CGFloat) {
        let distanceToStart = abs(start - position);
        let distanceToEnd = abs(end - position);
        
        if (distanceToStart < distanceToEnd && start <= end && position >= 0 && position <= 0.95) {
            self.start = position;
        }
        
        if (distanceToStart >= distanceToEnd && start <= end && position >= 0.05 && position <= 1) {
            self.end = position;
        }
    }
}
