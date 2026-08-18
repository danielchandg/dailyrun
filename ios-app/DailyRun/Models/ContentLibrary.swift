//
//  ContentLibrary.swift
//  DailyRun
//
//  Entries live as JSON in Resources/Content, one file per calendar day,
//  named "MM-DD.json" — the filename is the key, so there's no index to
//  keep in sync. They're decoded through the real decoder, so anything
//  that loads here will load unchanged if these move behind a network call.
//

import Foundation

enum ContentLibrary {
    /// "MM-DD" for the day `date` falls on, in the device's time zone.
    ///
    /// Pinned to the Gregorian calendar on purpose: a device set to a
    /// Japanese or Buddhist calendar should still resolve April 26 to "04-26".
    static func key(for date: Date) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        let parts = calendar.dateComponents([.month, .day], from: date)
        return String(format: "%02d-%02d", parts.month ?? 1, parts.day ?? 1)
    }

    /// The entry for `date`, or nil on the days with no content.
    static func entry(for date: Date) -> DailyRunResponse? {
        entry(forKey: key(for: date))
    }

    /// The entry filed under `key` ("04-26"), or nil if there isn't one.
    ///
    /// Malformed JSON traps in debug so authoring mistakes surface while
    /// you're editing, and degrades to nil in release rather than taking the
    /// app down over one bad file.
    static func entry(forKey key: String) -> DailyRunResponse? {
        guard let url = url(forKey: key) else { return nil }
        do {
            return try JSONDecoder.dailyRun.decode(
                DailyRunResponse.self,
                from: Data(contentsOf: url)
            )
        } catch {
            assertionFailure("\(key).json failed to decode: \(error)")
            return nil
        }
    }

    /// Every key with an entry behind it, ascending. Useful for a browse list,
    /// and for a test that decodes all of them in one pass.
    static var availableKeys: [String] {
        // Union, not a `??` fallback: the subdirectory lookup returns an empty
        // array rather than nil when Content/ isn't a real directory in the
        // bundle — which is the normal case — so a fallback chain never
        // reaches the root lookup and silently finds nothing.
        let urls = (bundle.urls(forResourcesWithExtension: "json", subdirectory: contentDirectory) ?? [])
            + (bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? [])
        let keys = urls.map { $0.deletingPathExtension().lastPathComponent }
        return Set(keys.filter(isKey)).sorted()
    }

    // MARK: - Bundle lookup

    private static let contentDirectory = "Content"
    private static var bundle: Bundle { .main }

    /// Xcode's synchronized folders flatten Content/ away — the files land at
    /// the bundle root, so the root lookup is the one that hits today. The
    /// subdirectory attempt covers Content/ later becoming a folder reference.
    private static func url(forKey key: String) -> URL? {
        guard isKey(key) else { return nil }
        return bundle.url(forResource: key, withExtension: "json", subdirectory: contentDirectory)
            ?? bundle.url(forResource: key, withExtension: "json")
    }

    /// Guards the bundle lookup against arbitrary strings, and keeps
    /// `availableKeys` from picking up unrelated JSON in the bundle.
    private nonisolated static func isKey(_ key: String) -> Bool {
        let parts = key.split(separator: "-", omittingEmptySubsequences: false)
        guard parts.count == 2,
              parts.allSatisfy({ $0.count == 2 && $0.allSatisfy(\.isNumber) }),
              let month = Int(parts[0]), let day = Int(parts[1])
        else { return false }
        return (1...12).contains(month) && (1...31).contains(day)
    }
}

extension DailyRunResponse {
    /// The entry previews render against. Component order matters — the
    /// per-component previews index into `components` directly.
    static let sample: DailyRunResponse = {
        guard let entry = ContentLibrary.entry(forKey: "04-26") else {
            fatalError("Resources/Content/04-26.json is missing from the bundle")
        }
        return entry
    }()
}
