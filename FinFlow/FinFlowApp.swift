//
//  FinFlowApp.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

@main
struct FinFlowApp: App {

    @State private var appModel = AppModel()
    @State private var store = FinFlowStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .environment(store)
        }
        .defaultSize(width: 1080, height: 720)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .environment(store)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
