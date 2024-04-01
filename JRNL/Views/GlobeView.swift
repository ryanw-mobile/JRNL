//
//  GlobeView.swift
//  JRNL
//
//  Created by Ryan Wong on 01/04/2024.
//  Copyright © 2024 RW MobiMedia. All rights reserved.
//

import RealityKit
import SwiftUI

struct GlobeView: View {
    var body: some View {
        #if os(visionOS)
            VStack {
                Model3D(named: "globe") { model in model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            }
        #endif
    }
}

#Preview {
    GlobeView()
}
