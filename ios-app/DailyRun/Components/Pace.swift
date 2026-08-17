//
//  Pace.swift
//  DailyRun
//

import Charts
import SwiftUI

/// Split-by-split pace, plotted on an inverted axis so faster reads as taller.
struct Pace: View {
    let model: PaceComponent
    @State private var selected: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(icon: "pace_icon", text: model.description, font: .avenir("Medium", 14))

            HStack(alignment: .center, spacing: 6) {
                Text(yAxisLabel)
                    .font(.avenir("Bold", 12))
                    .foregroundStyle(.white)
                    .fixedSize()
                    .rotationEffect(.degrees(-90))
                    .frame(width: 12)
                    // Visual nudge only — offset doesn't affect layout, so the
                    // chart stays exactly where it is.
                    .offset(x: -6)

                VStack(alignment: .leading, spacing: 4) {
                    chart

                    // Touch label sits on the same line as the axis labels, so
                    // nothing shifts when the finger lifts.
                    HStack {
                        Text(leftLabel)
                            // Clears the y-axis tick labels so the "M" lands
                            // just right of the first bar. Offset only, so the
                            // right label and the row layout don't move.
                            .offset(x: 26)
                        Spacer()
                        Text(rightLabel)
                    }
                    .overlay {
                        Text(selectionLabel ?? "")
                            .font(.avenir("DemiBold", 12))
                    }
                    .font(.avenir("Medium", 10))
                    .foregroundStyle(.white)
                }
            }
        }
        .sectionBackground(Palette.paceGradient)
    }

    // MARK: - Chart

    private var chart: some View {
        Chart {
            ForEach(points, id: \.index) { point in
                BarMark(
                    x: .value("Split", point.index),
                    // Negated so the scale runs fast-at-top; labels are un-negated below.
                    yStart: .value("Pace", -range.upper),
                    yEnd: .value("Pace", -point.pace),
                    width: .fixed(point.width)
                )
                // A narrowed bar would otherwise centre in its slot; shift it so
                // it starts where a full-width bar would.
                .offset(x: -(barWidth - point.width) / 2)
                .foregroundStyle(selected == point.index ? Palette.paceBarTouched : Palette.paceBar)
            }
        }
        .chartYScale(domain: -range.upper ... -range.lower)
        .chartXScale(domain: -0.5 ... Double(points.count) - 0.5)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .leading, values: gridValues.map { -$0 }) { value in
                AxisGridLine().foregroundStyle(Palette.paceGrid)
                AxisValueLabel {
                    if let raw = value.as(Double.self) {
                        Text(minuteSecond(-raw))
                            .font(.avenir("Medium", 9))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .frame(height: 130)
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { drag in selected = nearestSplit(drag.location, proxy, geo) }
                            .onEnded { _ in selected = nil }
                    )
            }
        }
    }

    /// The split under the touch, by horizontal position.
    private func nearestSplit(_ location: CGPoint, _ proxy: ChartProxy, _ geo: GeometryProxy) -> Int? {
        guard let plot = proxy.plotFrame else { return nil }
        let x = location.x - geo[plot].origin.x
        guard let raw: Double = proxy.value(atX: x) else { return nil }
        let index = Int(raw.rounded())
        return points.contains { $0.index == index } ? index : nil
    }

    // MARK: - Labels

    private var yAxisLabel: String {
        model.yAxisLabel ?? "PACE PER \(model.unit.uppercased())"
    }

    private var leftLabel: String {
        model.xAxisLeftLabel ?? "\(model.unit.capitalized) 1"
    }

    private var rightLabel: String {
        model.xAxisRightLabel
            ?? "\(model.unit.capitalized) \(model.distance.formatted(.number.precision(.fractionLength(0...2))))"
    }

    private var selectionLabel: String? {
        guard let selected, let point = points.first(where: { $0.index == selected }) else { return nil }
        // A partial split reads its own elapsed time; a full one reads its pace.
        // They're the same number for full splits, but not for the tail.
        return "\(point.label): \(minuteSecond(point.isPartial ? point.seconds : point.pace))"
    }

    /// "Mile 1" … "Mile 26.2" when each split is exactly one unit; otherwise a
    /// range like "10-15 km", since "Km 3" would be misleading for 5km splits.
    private func splitName(start: Double, end: Double) -> String {
        func number(_ value: Double) -> String {
            value.formatted(.number.precision(.fractionLength(0...2)))
        }
        guard model.splitDistance != 1 else {
            return "\(model.unit.capitalized) \(number(end))"
        }
        return "\(number(start))-\(number(end)) \(model.unit)"
    }

    // MARK: - Data

    private struct Point {
        let index: Int
        let label: String
        let seconds: Double
        /// Seconds per full unit, so a partial final split is comparable.
        let pace: Double
        let isPartial: Bool
        /// Narrowed in proportion to the distance covered, with a floor so a
        /// very short tail stays visible.
        let width: CGFloat
    }

    private var points: [Point] {
        model.labeledSplits.compactMap { split in
            let start = Double(split.index) * model.splitDistance
            let covered = min(model.splitDistance, max(0, model.distance - start))
            guard covered > 0 else { return nil }

            let isPartial = covered < model.splitDistance
            return Point(
                index: split.index,
                label: splitName(start: start, end: start + covered),
                seconds: split.seconds,
                pace: split.seconds / covered,
                isPartial: isPartial,
                width: isPartial
                    ? Swift.max(3, barWidth * covered / model.splitDistance)
                    : barWidth
            )
        }
    }

    private var barWidth: CGFloat {
        model.splits.count > 30 ? 5 : (model.splits.count > 15 ? 9 : 17)
    }

    /// Pads the observed pace spread, then snaps outward to a round step so the
    /// gridlines land on sensible values. Works the same for 100m splits as for
    /// 5km ones because everything is normalized to pace-per-unit first.
    private var range: (lower: Double, upper: Double, step: Double) {
        let paces = points.map(\.pace)
        guard let min = paces.min(), let max = paces.max() else { return (0, 1, 1) }

        let pad = Swift.max((max - min) * 0.15, 5)
        let steps: [Double] = [1, 2, 5, 10, 15, 20, 30, 60, 120, 300, 600]
        let step = steps.first { candidate in
            let lower = (min - pad).rounded(.down, toMultipleOf: candidate)
            let upper = (max + pad).rounded(.up, toMultipleOf: candidate)
            return (upper - lower) / candidate <= 6
        } ?? 600

        return (
            (min - pad).rounded(.down, toMultipleOf: step),
            (max + pad).rounded(.up, toMultipleOf: step),
            step
        )
    }

    private var gridValues: [Double] {
        stride(from: range.lower, through: range.upper, by: range.step).map { $0 }
    }
}

private extension Double {
    func rounded(_ rule: FloatingPointRoundingRule, toMultipleOf multiple: Double) -> Double {
        (self / multiple).rounded(rule) * multiple
    }
}

#Preview {
    ScrollView {
        if case .pace(let model) = DailyRunResponse.sample.components[0] {
            Pace(model: model)
        }
    }
}
