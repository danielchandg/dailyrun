//
//  PaceComparison.swift
//  DailyRun
//

import Charts
import SwiftUI

/// Speed of the featured run against reference paces at other distances.
struct PaceComparison: View {
    let model: PaceComparisonComponent
    @State private var selected: String?

    private let barWidth: CGFloat = 28

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(icon: "pace_comparison_icon", text: model.title)

            Text(model.description)
                .font(.avenir("Medium", 14))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)

            chart

            Text(selectionLabel)
                .font(.avenir("DemiBold", 12))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .sectionBackground(Palette.paceComparison)
    }

    private var chart: some View {
        Chart {
            ForEach(model.bars, id: \.label) { bar in
                BarMark(
                    x: .value("Distance", bar.label),
                    y: .value("Speed", bar.value),
                    width: .fixed(barWidth)
                )
                .cornerRadius(3)
                .foregroundStyle(
                    selected == bar.label ? Palette.paceComparisonBarTouched : Palette.paceComparisonBar
                )
            }

            if let axis = model.axis {
                // Label lives on the y-axis now, not on the line.
                RuleMark(y: .value("Reference", axis.value))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        // No y-axis — the reference value is carried by the touch label instead.
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let label = value.as(String.self) {
                        Text(label)
                            .font(.avenir("Medium", 9))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .frame(height: 170)
        .chartOverlay { proxy in
            GeometryReader { geo in
                ZStack {
                    axisLines(proxy, geo)
                        .allowsHitTesting(false)

                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { drag in selected = nearestBar(drag.location, proxy, geo) }
                                .onEnded { _ in selected = nil }
                        )
                }
            }
        }
    }

    /// Just the baseline under the bars — the y-axis is gone.
    private func axisLines(_ proxy: ChartProxy, _ geo: GeometryProxy) -> some View {
        Path { path in
            guard let plot = proxy.plotFrame else { return }
            let frame = geo[plot]
            path.move(to: CGPoint(x: frame.minX, y: frame.maxY))
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
        }
        .stroke(Palette.paceComparisonAxis, lineWidth: 1)
    }

    /// The bar under the touch, by horizontal position.
    private func nearestBar(_ location: CGPoint, _ proxy: ChartProxy, _ geo: GeometryProxy) -> String? {
        guard let plot = proxy.plotFrame else { return nil }
        let x = location.x - geo[plot].origin.x
        return proxy.value(atX: x, as: String.self)
    }

    private var unitLabel: String {
        model.unitAbbreviation ?? model.unit ?? ""
    }

    /// With nothing touched this reads out the reference marker; touching a bar
    /// shows that bar's title verbatim.
    private var selectionLabel: String {
        if let bar = model.bars.first(where: { $0.label == selected }) {
            return bar.title
        }
        if let axis = model.axis {
            let value = axis.value.formatted(.number.precision(.fractionLength(0...1)))
            return "\(axis.label): \(value) \(unitLabel)"
        }
        return " "
    }
}

#Preview {
    ScrollView {
        if case .paceComparison(let model) = DailyRunResponse.sample.components[2] {
            PaceComparison(model: model)
        }
    }
}
