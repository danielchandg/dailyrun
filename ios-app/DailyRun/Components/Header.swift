//
//  Header.swift
//  DailyRun
//

import SwiftUI

/// Roughly square hero photo with the title block overlaid on the bottom.
struct Header: View {
    let response: DailyRunResponse

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geo in
                if let url = response.photo?.resolvedURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.black
                    }
                    .frame(width: geo.size.width, height: geo.size.width)
                    .clipped()
                } else {
                    Color.black
                }
            }
            .aspectRatio(1, contentMode: .fit)

            // Stands in for the mockup's transparent rectangle with a border
            // shadow — darkens the top and bottom so text stays legible.
            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.7), location: 0.0),
                    .init(color: .clear, location: 0.25),
                    .init(color: .clear, location: 0.55),
                    .init(color: .black.opacity(0.9), location: 1.0),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .aspectRatio(1, contentMode: .fit)

            VStack(alignment: .leading, spacing: 2) {
                Text("On this day in history...")
                    .font(.avenir("DemiBoldItalic", 12))

                Text(response.title)
                    .font(.avenir("DemiBold", 32))
                    .lineSpacing(2)

                HStack(alignment: .firstTextBaseline) {
                    Text(response.date)
                        .font(.avenir("DemiBold", 12))

                    Spacer()

                    if let photo = response.photo {
                        HStack(alignment: .firstTextBaseline, spacing: 3) {
                            Text(photo.credit)
                                .font(.avenir("DemiBold", 9))
                                // The credit is a license condition, not
                                // decoration: let it wrap and shrink rather
                                // than truncate away.
                                .multilineTextAlignment(.trailing)
                                .minimumScaleFactor(0.8)

                            if let licenseURL = photo.resolvedLicenseURL {
                                Link(destination: licenseURL) {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 10))
                                        // Widens the hit area without changing
                                        // the glyph — a 10pt icon is a small
                                        // target on its own.
                                        .padding(4)
                                        .contentShape(Rectangle())
                                }
                                .accessibilityLabel("Photo license")
                            }
                        }
                        // Shutterstock's TOS requires the credit be "clearly
                        // and easily readable by the unaided eye", so this
                        // doesn't recede as far as it looks like it should.
                        // Don't drop it back toward 0.6.
                        .foregroundStyle(.white.opacity(0.85))
                    }
                }
                .padding(.top, 6)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    Header(response: .sample)
}
