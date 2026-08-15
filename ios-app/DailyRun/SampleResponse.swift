//
//  SampleResponse.swift
//  DailyRun
//
//  Stand-in for the API while the backend doesn't exist yet.
//  Fill in the JSON below — it's decoded through the real decoder, so if it
//  parses here it'll parse in production.
//
//  Delete this file once the real network call lands.
//

import Foundation

extension DailyRunResponse {
    static let sample: DailyRunResponse = {
        do {
            return try JSONDecoder.dailyRun.decode(
                DailyRunResponse.self,
                from: Data(sampleJSON.utf8)
            )
        } catch {
            fatalError("sampleJSON failed to decode: \(error)")
        }
    }()
}

// Every component type appears once below. Delete the ones you don't want,
// duplicate the ones you do — order here is the order they render on screen.
// Raw string (#"""), so backslash escapes inside the JSON stay literal —
// a plain """ literal would collapse \" into " and break the JSON.
private let sampleJSON = #"""
{
  "title": "World's First Official Sub 2-Hour Marathon",
  "date": "April 26, 2026",
  "event": "2026 London Marathon",
  "photo": "https://static.time.com/v3/assets/bltea6093859af6183b/blt710e33b12972c4a2/6a209e929bc7a33d755cc63b/T100SPORTS-2026-Web-Sebastian-Sawe.jpg?branch=production&width=3840&auto=webp&crop=1:1%2Coffset-x0.00%2Coffset-y100.00",
  "photo_source": "TIME",
  "components": [
    {
      "type": "pace",
      "description": "A 1:59:30 marathon is an average pace of 4:33 per mile.",
      "unit": "mile",
      "y_axis_label": "PACE PER MILE",
      "x_axis_left_label": "Mile 1",
      "x_axis_right_label": "Mile 26.2",
      "axis": {
        "label": "average pace",
        "value": 273
      },
      "distance": 26.2,
      "split_distance": 1.0,
      "splits": [282, 281, 264, 271, 279, 284, 275, 279, 276, 284, 266, 278, 274, 274, 278, 282, 273, 282, 272, 263, 269, 271, 264, 263, 267, 260, 51]
    },
    {
      "type": "head_to_head",
      "title": "WORLD RECORD",
      "description": "Sebastian Sawe beat Kelvin Kiptum's previous world record of 2:00:35 from the 2023 Chicago Marathon.",
      "rows": [
        ["Marathon Split", "Sawe's Time", "Kiptum's Time"],
        ["5 km", "14:14", "14:26"],
        ["10 km", "28:35", "28:42"],
        ["15 km", "43:10", "43:09"],
        ["20 km", "57:21", "57:09"],
        ["25 km", "1:11:41", "1:12:04"],
        ["30 km", "1:26:03", "1:26:31"],
        ["35 km", "1:39:57", "1:40:22"],
        ["40 km", "1:53:39", "1:54:23"],
        ["42.2 km", "1:59:30", "2:00:35"]
      ]
    },
    {
      "type": "pace_comparison",
      "title": "How fast is 1:59:30?",
      "description": "Sawe's average speed compared to world-record pace for various distances",
      "unit": "miles per hour",
      "unit_abbreviation": "mi/h",
      "axis": {
        "label": "Sawe's speed",
        "value": 13.1
      },
      "bars": [
        { "label": "100m", "value": 23.4, "title": "100m WR: 23.4 mi/h (Bolt 2009)" },
        { "label": "400m", "value": 20.8, "title": "400m WR: 20.8 mi/h (Van Niekerk 2016)" },
        { "label": "800m", "value": 17.7, "title": "800m WR: 17.7 mi/h (Rudisha 2012)" },
        { "label": "Mile", "value": 16.2, "title": "Mile WR: 16.2 mi/h (Kerr 2026)" },
        { "label": "5000m", "value": 14.8, "title": "5000m WR: 14.8 mi/h (Cheptegei 2020)" },
        { "label": "Half Marathon", "value": 13.7, "title": "Half Marathon WR: 13.7 mi/h (Kiplimo 2026)" },
        { "label": "Marathon", "value": 13.1, "title": "Marathon WR: 13.1 mi/h (Sawe 2026)" }
      ]
    },
    {
      "type": "trivia",
      "facts": [
        "Yomif Kejelcha, making his marathon debut (!), finished in second place behind Sawe in 1:59:41.",
        "In third place, Jacob Kiplimo finished in 2:00:28, also under the previous world record.",
        "When asked what he ate before the race, Sawe replied, \"Two slices of bread with honey and tea.\""
      ]
    },
    {
      "type": "video",
      "title": "Watch it on YouTube",
      "url": "https://youtu.be/1voTDQQQf5g?si=GiJfiOKZdbOj349A"
    },
    {
      "type": "learn_more",
      "links": [
        { "title": "olympics.com - Sebastian Sawe 2026 London Marathon breakdown", "url": "https://www.olympics.com/en/news/sabastian-sawe-2026-london-marathon-breakdown-stats-splits-world-record" },
        { "title": "Citius Mag - Sub-2! Sebastian Sawe Runs 1:59:30 Marathon World Record in London", "url": "https://citiusmag.com/articles/sabastian-sawe-marathon-world-record-recap-london-2026" },
        { "title": "LetsRun - Did Sawe really run a 4:12 mile at the end of his 1:59 marathon?", "url": "https://www.letsrun.com/news/2026/05/did-sabastian-sawe-really-run-a-412-mile-at-the-end-of-his-159-marathon-no-he-did-not/" }
      ]
    }
  ]
}
"""#


/*
DESIGN NOTES

The fontface for all text in this project is AvenirNext.
For example, AvenirNext-Medium, AvenirNext-DemiBold, etc.
I may refer to fonts simply as the style, for example Regular 10, Bold 24, or MediumItalic 32.
These would correspond to AvenirNext-Regular (size 10), AvenirNext-Bold (size 24), AvenirNext-MediumItalic (size 32).

There are six icons imported in XCode as assets already. They are all SVG files. They should all be displayed in 20x20 pixels.
They are pace_icon, head_to_head_icon, pace_comparison_icon, trivia_icon, learn_more_icon, and video_icon.

HEADER

The image should be around 1:1 aspect ratio for iPhone (don't worry about iPad for now).
That is, if the view port is 402 pixels wide (i.e. iPhone 17 Pro), then the photo is roughly ~400 pixels tall.

There should be a shadow covering both the top and bottom halves of the image.
In the mockup, I have a fully transparent rectangle on top of the photo with border shadow 70% opacity, Y=70 offset, and the shadow is 70 pixels.
If you can apply the border shadow to the image directly, please do so.
Otherwise, add transparent rectangle as I did.

The header contains 3 text fields.
First is "On this day in history..." Second is the title. Third is the date.
First style is MediumItalic 10.
Second style is DemiBold 32.
Third style is Medum 8.

PACE

The icon is pace_icon.
The title style is Medium 12.

The bar graph has pace per mile on the y-axis and mile number on the x-axis. This should support whatever unit is passed into PaceComponent. The y-axis label should be "PACE PER <unit>". The x-axis should only label "<unit> 1" and "<unit> 26.2".
The y-axis scale varies depending on the split data. I'm not sure the best way to generalize this, i.e. generate a reasonable y-range given a list of splits. Any thoughts?
The bar chart is interactive; whenever the user is touching a bar, it should display a label, such as "Mile 1: 4:42", as well as slightly saturate the color of the bar.

The background color is a linear gradient, from top to bottom, it's #070A97 to #03045E.
The bars in the bar chart are #4586FF. The text is white.
The horizontal lines in the bar chart are #2D2FB4.

HEAD TO HEAD

The background color is #37035E. The title is Bold 14. The description is Medium 12.
The lighter shade of purple used for every other row is #450079. The row text style is Medium 10.
Possibly I want some interactivity here later; don't add anything for now.

PACE COMPARISON

The background color is #035E3C. Title is Bold 14, description is Medium 12.
Similar to the previous bar chart, each bar is interactive. When the user is touching a bar, it displays a label with the title, for example "100m WR: 9.58 (Bolt 2009)", as well as slightly saturates the bar color.
The bar color is #00E573. The color used for the x-axis and y-axis is #047E51.

TRIVIA

Title is Bold 14. Each trivia fact is Medium 12. Background color is #5E2003.

VIDEO

Title is Bold 14. The background color is #5E0303. The YouTube re-direct thumbnail is the only content of this component.

LEARN MORE

Title is Bold 14. Each link is Medium 10. Background color is #9D6A43.
*/