//
//  LearnMore.swift
//  DailyRun
//

import SwiftUI

struct LearnMore: View {
    let model: LearnMoreComponent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(icon: "learn_more_icon", text: "Learn More")

            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(model.links.enumerated()), id: \.offset) { _, link in
                    if let url = link.resolvedURL {
                        Link(destination: url) {
                            Text(link.title)
                                .font(.avenir("Medium", 14))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding(.leading, 8)
        }
        .sectionBackground(Palette.learnMore)
    }
}

#Preview {
    if case .learnMore(let model) = DailyRunResponse.sample.components[5] {
        LearnMore(model: model)
    }
}
