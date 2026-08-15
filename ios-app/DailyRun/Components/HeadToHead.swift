//
//  HeadToHead.swift
//  DailyRun
//

import SwiftUI

/// Comparison table. `rows[0]` is the header row; body rows alternate shading.
struct HeadToHead: View {
    let model: HeadToHeadComponent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(icon: "head_to_head_icon", text: model.title)

            Text(model.description)
                .font(.avenir("Medium", 14))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 0) {
                ForEach(Array(model.rows.enumerated()), id: \.offset) { index, row in
                    HStack(spacing: 0) {
                        ForEach(Array(row.enumerated()), id: \.offset) { column, cell in
                            Text(cell)
                                .font(.avenir("Medium", 12))
                                .foregroundStyle(.white)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: column == 0 ? .leading : .center
                                )
                        }
                    }
                    .padding(.vertical, 7)
                    .padding(.horizontal, 12)
                    .background(index.isMultiple(of: 2) ? Color.clear : Palette.headToHeadRow)
                }
            }
            .padding(.top, 4)
        }
        .sectionBackground(Palette.headToHead)
    }
}

#Preview {
    ScrollView {
        if case .headToHead(let model) = DailyRunResponse.sample.components[1] {
            HeadToHead(model: model)
        }
    }
}
