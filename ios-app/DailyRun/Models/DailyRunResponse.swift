//
//  DailyRunResponse.swift
//  DailyRun
//

import Foundation

struct DailyRunResponse: Decodable, Sendable {
    let title: String
    let date: String
    let event: String
    let photo: String?
    /// Attribution to display with `photo`, e.g. "Photo: Getty Images".
    let photoSource: String?
    let components: [DailyRunComponent]
}

enum DailyRunComponent: Decodable, Sendable {
    case pace(PaceComponent)
    case headToHead(HeadToHeadComponent)
    case paceComparison(PaceComparisonComponent)
    case trivia(TriviaComponent)
    case video(VideoComponent)
    case learnMore(LearnMoreComponent)
    case unsupported(type: String)

    private enum DiscriminatorKey: String, CodingKey {
        case type
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DiscriminatorKey.self)
        let type = try container.decode(String.self, forKey: .type)

        do {
            switch type {
            case "pace":
                self = .pace(try PaceComponent(from: decoder))
            case "head_to_head":
                self = .headToHead(try HeadToHeadComponent(from: decoder))
            case "pace_comparison":
                self = .paceComparison(try PaceComparisonComponent(from: decoder))
            case "trivia":
                self = .trivia(try TriviaComponent(from: decoder))
            case "video":
                self = .video(try VideoComponent(from: decoder))
            case "learn_more":
                self = .learnMore(try LearnMoreComponent(from: decoder))
            default:
                self = .unsupported(type: type)
            }
        } catch {
            self = .unsupported(type: type)
        }
    }
}

struct PaceComponent: Decodable, Sendable {
    let description: String
    /// e.g. "miles"
    let unit: String
    /// Overrides the derived "PACE PER <UNIT>".
    let yAxisLabel: String?
    let xAxisLeftLabel: String?
    let xAxisRightLabel: String?
    /// Total distance in `unit`, e.g. 26.2
    let distance: Double
    /// Distance each split covers, in `unit`, e.g. 1.0
    let splitDistance: Double
    /// Seconds per split, in order.
    let splits: [Double]

    var labeledSplits: [LabeledSplit] {
        splits.enumerated().map { index, seconds in
            LabeledSplit(index: index, label: "\(index + 1)", seconds: seconds)
        }
    }

    struct LabeledSplit: Identifiable, Sendable {
        let index: Int
        let label: String
        let seconds: Double

        var id: Int { index }
    }
}

struct HeadToHeadComponent: Decodable, Sendable {
    let title: String
    let description: String
    /// Full table; `rows[0]` is the header row.
    let rows: [[String]]
}

struct TriviaComponent: Decodable, Sendable {
    let facts: [String]
}

struct VideoComponent: Decodable, Sendable {
    let title: String
    let url: String
}

struct PaceComparisonComponent: Decodable, Sendable {
    let title: String
    let description: String
    let unit: String?
    /// Short form for axis labels, e.g. "mi/h".
    let unitAbbreviation: String?
    /// Dashed reference line for the featured race's pace.
    let axis: AxisMarker?
    let bars: [Bar]

    /// Dashed reference line with a label, drawn at `value` on the y-axis.
    struct AxisMarker: Decodable, Sendable {
        let label: String
        let value: Double
    }

    struct Bar: Decodable, Sendable {
        let label: String
        let value: Double
        /// Shown when the user touches this bar.
        let title: String
    }
}

struct LearnMoreComponent: Decodable, Sendable {
    let links: [Link]

    struct Link: Decodable, Sendable {
        let title: String
        let url: String

        var resolvedURL: URL? { URL(string: url) }
    }
}

extension JSONDecoder {
    static var dailyRun: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
