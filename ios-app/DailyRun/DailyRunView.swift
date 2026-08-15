//
//  DailyRunView.swift
//  DailyRun
//

import SwiftUI

/// The app's single screen. Header, then the components in backend order.
/// Sections are full-bleed and flush — each paints its own background.
struct DailyRunView: View {
    let response: DailyRunResponse

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Header(response: response)

                ForEach(Array(response.components.enumerated()), id: \.offset) { _, component in
                    switch component {
                    case .pace(let model):
                        Pace(model: model)
                    case .headToHead(let model):
                        HeadToHead(model: model)
                    case .paceComparison(let model):
                        PaceComparison(model: model)
                    case .trivia(let model):
                        Trivia(model: model)
                    case .video(let model):
                        Video(model: model)
                    case .learnMore(let model):
                        LearnMore(model: model)
                    case .unsupported:
                        EmptyView()
                    }
                }
            }
        }
        .background(.black)
        .ignoresSafeArea(edges: .top)
        .scrollIndicators(.hidden)
        .statusBarHidden(false)
    }
}

#Preview {
    DailyRunView(response: .sample)
}
