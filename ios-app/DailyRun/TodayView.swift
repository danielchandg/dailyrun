//
//  TodayView.swift
//  DailyRun
//
//  Created by Daniel Chang on 8/13/26.
//

import SwiftUI

struct TodayView: View {
    var body: some View {
        VStack {
            Image(systemName: "figure.run")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    TodayView()
}
