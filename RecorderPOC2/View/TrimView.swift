//
//  TrimView.swift
//  RecorderPOC2
//
//  Created by Julien Sanchez on 10/03/2020.
//  Copyright © 2020 Julien Sanchez. All rights reserved.
//

import SwiftUI
import Foundation

struct TrimView: View {
    @ObservedObject private var player = Player()
    @ObservedObject private var trimer = Trimer(url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("current_recording.wav"))

    let g = DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ action in
        print("DOWN: \(action.location.y)")
    }).onEnded({
        print("UP: \($0)")
    })
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .blue]),
                                                startPoint: .top,
                                                endPoint: .bottom))
                    .frame(width: (UIScreen.main.bounds.width), height: self.trimer.start * geometry.size.height)
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.purple, .purple]),
                                            startPoint: .top,
                                            endPoint: .bottom))
                .frame(width: (UIScreen.main.bounds.width), height: (self.trimer.end - self.trimer.start) * geometry.size.height)
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .blue]),
                                                startPoint: .top,
                                                endPoint: .bottom))
                    .frame(width: (UIScreen.main.bounds.width), height: (1 - self.trimer.end) * geometry.size.height)
                
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ action in
                print("DOWN: \(action.location.y/geometry.size.height)")
                self.trimer.changeTrim(position: action.location.y/geometry.size.height);
            }).onEnded({
                print("UP: \($0)")
                self.player.playRecordingFromTo(from: self.trimer.start, to: self.trimer.end)
            }))
        }
    }
}

struct TrimView_Previews: PreviewProvider {
    static var previews: some View {
        TrimView()
    }
}
