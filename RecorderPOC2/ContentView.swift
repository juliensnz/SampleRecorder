//
//  ContentView.swift
//  RecorderPOC2
//
//  Created by Julien Sanchez on 09/03/2020.
//  Copyright © 2020 Julien Sanchez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        VStack {
            MeterView()
            ActionView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
