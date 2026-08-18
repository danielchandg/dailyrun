//
//  ContentTests.swift
//  DailyRunTests
//
//  Guards the hand-authored entries in Resources/Content. These files are
//  written by hand, so the failure mode to catch is a typo — and the decoder
//  is deliberately lenient about those, which is exactly why this exists.
//

import XCTest
@testable import DailyRun

@MainActor
final class ContentTests: XCTestCase {

    /// Every entry decodes, and every component inside it decodes.
    ///
    /// The second half is the point. `DailyRunComponent.init(from:)` catches
    /// decode failures and falls back to `.unsupported`, which `DailyRunView`
    /// renders as `EmptyView` — so a malformed "pace" block doesn't throw, it
    /// silently drops that section off the screen. Decoding the file is not
    /// enough to prove the file is good.
    func testEveryEntryDecodesCompletely() throws {
        let keys = ContentLibrary.availableKeys

        // Without this the whole test passes by iterating nothing, which is
        // exactly how a broken `availableKeys` slipped through the first time.
        XCTAssertFalse(keys.isEmpty, "ContentLibrary found no entries at all")

        for key in keys {
            let entry = try XCTUnwrap(
                ContentLibrary.entry(forKey: key),
                "\(key).json is in the bundle but failed to decode"
            )

            for (index, component) in entry.components.enumerated() {
                if case .unsupported(let type) = component {
                    XCTFail(
                        """
                        \(key).json: components[\(index)] with type "\(type)" \
                        did not decode. Either the type is misspelled, or one \
                        of its fields is missing or the wrong shape. This \
                        section would be silently missing from the screen.
                        """
                    )
                }
            }
        }
    }

    /// A file named 03-4.json or 13-01.json is silently invisible to
    /// `entry(for:)`, since the lookup only ever asks for a well-formed key.
    func testEveryContentFileIsReachable() throws {
        let bundled = Set(
            (Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? [])
                .map { $0.deletingPathExtension().lastPathComponent }
        )
        let reachable = Set(ContentLibrary.availableKeys)

        XCTAssertEqual(
            bundled.subtracting(reachable), [],
            "JSON in the bundle that ContentLibrary will never load — expected MM-DD.json"
        )
    }

    /// The entry the previews and the app currently render.
    func testSampleEntryLoads() {
        XCTAssertEqual(DailyRunResponse.sample.date, "April 26, 2026")
        XCTAssertFalse(DailyRunResponse.sample.components.isEmpty)
    }

    /// `key(for:)` has to stay on the Gregorian calendar regardless of device
    /// settings, or a non-Gregorian locale resolves April 26 to some other file.
    func testKeyFormatting() {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = .current
        let april26 = gregorian.date(from: DateComponents(year: 2026, month: 4, day: 26))!

        XCTAssertEqual(ContentLibrary.key(for: april26), "04-26")
    }

    /// 02-29 exists in 1 year out of 4 — worth knowing before authoring one.
    func testLeapDayIsReachableOnlyInLeapYears() {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = .current
        let leapDay = gregorian.date(from: DateComponents(year: 2028, month: 2, day: 29))!

        XCTAssertEqual(ContentLibrary.key(for: leapDay), "02-29")
    }
}
