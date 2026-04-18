//
//  MirrorApp.swift
//  Mirror
//
//  Created by Rahul Biswakarma on 18/04/26.
//

import SwiftData
import SwiftUI

@main
struct MirrorApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            StartupView()
                .onAppear {
                    DispatchQueue.main.async {
                        if let window = NSApplication.shared.windows.first {
                            window.styleMask.insert(.fullSizeContentView)
                            window.titleVisibility = .hidden
                            window.titlebarAppearsTransparent = true
                            window.isOpaque = false
                            window.backgroundColor = .clear
                            window.hasShadow = false
                            window.isMovableByWindowBackground = true

                            // Hide traffic lights
                            window.standardWindowButton(.closeButton)?
                                .isHidden = true
                            window.standardWindowButton(.miniaturizeButton)?
                                .isHidden = true
                            window.standardWindowButton(.zoomButton)?.isHidden =
                                true
                        }
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 600)

        .modelContainer(sharedModelContainer)
    }
}
