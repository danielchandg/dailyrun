//
//  DailyRunResponse.swift
//  DailyRun
//

import Foundation

struct DailyRunResponse: Decodable, Sendable {
    let title: String
    let date: String
    let athlete: String
    let event: String
    let components: [DailyRunComponent]
}

enum DailyRunComponent: Decodable, Sendable {
    case pace(PaceComponent)
    case compareSplits(CompareSplitsComponent)
    case worldRecordComparison(WorldRecordComparisonComponent)
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
            case "compare_splits":
                self = .compareSplits(try CompareSplitsComponent(from: decoder))
            case "world_record_comparison":
                self = .worldRecordComparison(try WorldRecordComparisonComponent(from: decoder))
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

struct CompareSplitsComponent: Decodable, Sendable {
    let title: String
    let description: String
    /// Full table; `rows[0]` is the header row.
    let rows: [[String]]
}

struct WorldRecordComparisonComponent: Decodable, Sendable {
    let title: String
    let description: String
    let unit: String?
    let bars: [Bar]

    struct Bar: Decodable, Sendable {
        let label: String
        let value: Double
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
