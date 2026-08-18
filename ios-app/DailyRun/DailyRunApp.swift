//
//  DailyRunApp.swift
//  DailyRun
//
//  Created by Daniel Chang on 8/13/26.
//

import SwiftUI
import UIKit

@main
struct DailyRunApp: App {
    init() {
        // Locks the scroll view to its content — no rubber-banding past the top
        // or bottom. Global, but this app has one scroll view.
        UIScrollView.appearance().bounces = false
    }

    var body: some Scene {
        WindowGroup {
            // TODO: switch to ContentLibrary.entry(for: .now) once there's a
            // full month of entries and an empty state for the days without
            // one. Pinned to 04-26 for now so the app has something to show
            // on any launch date.
            DailyRunView(response: .sample)
        }
    }
}
