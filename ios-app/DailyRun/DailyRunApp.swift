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
            // TODO: replace with the real API call. Roughly:
            //   1. a loading view while the request is in flight
            //   2. DailyRunView(response:) on success
            //   3. an error view with a retry on failure
            // Until then this is the hardcoded stub in SampleResponse.swift.
            DailyRunView(response: .sample)
        }
    }
}
