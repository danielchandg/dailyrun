//
//  Trivia.swift
//  DailyRun
//

import SwiftUI

struct Trivia: View {
    let model: TriviaComponent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(icon: "trivia_icon", text: "TRIVIA")

            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(model.facts.enumerated()), id: \.offset) { _, fact in
                    Text(fact)
                        .font(.avenir("Medium", 14))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.leading, 8)
        }
        .sectionBackground(Palette.trivia)
    }
}

#Preview {
    if case .trivia(let model) = DailyRunResponse.sample.components[3] {
        Trivia(model: model)
    }
}
