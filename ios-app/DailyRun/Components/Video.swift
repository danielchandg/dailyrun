//
//  Video.swift
//  DailyRun
//

import SwiftUI

/// Thumbnail that hands off to the YouTube app (or Safari) on tap.
struct Video: View {
    let model: VideoComponent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(icon: "video_icon", text: model.title)

            if let url = URL(string: model.url) {
                Link(destination: url) {
                    thumbnail
                }
            }
        }
        .sectionBackground(Palette.video)
    }

    private var thumbnail: some View {
        Rectangle()
            .fill(Color.white.opacity(0.15))
            .aspectRatio(16 / 9, contentMode: .fit)
            .overlay {
                if let still = thumbnailURL {
                    AsyncImage(url: still) { image in
                        // hqdefault is 4:3 with letterbox bars baked in. Filling
                        // the 16:9 box and clipping crops exactly those away.
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.clear
                    }
                }
            }
            .overlay {
                Image(systemName: "play.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(.white)
                    .shadow(radius: 8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 20)
    }

    /// YouTube publishes stills at a predictable path once you have the video id.
    private var thumbnailURL: URL? {
        guard let id = Self.youTubeID(from: model.url) else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(id)/hqdefault.jpg")
    }

    static func youTubeID(from raw: String) -> String? {
        guard let components = URLComponents(string: raw) else { return nil }

        // youtu.be/<id>
        if components.host?.contains("youtu.be") == true {
            let id = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            return id.isEmpty ? nil : id
        }
        // youtube.com/watch?v=<id>
        if let v = components.queryItems?.first(where: { $0.name == "v" })?.value {
            return v
        }
        // youtube.com/embed/<id> and /shorts/<id>
        let parts = components.path.split(separator: "/")
        if let last = parts.last, parts.count >= 2 {
            return String(last)
        }
        return nil
    }
}

#Preview {
    if case .video(let model) = DailyRunResponse.sample.components[4] {
        Video(model: model)
    }
}
