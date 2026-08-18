# DailyRun design notes

Moved out of `SampleResponse.swift` when the sample JSON became
`DailyRun/Resources/Content/04-26.json`.

The fontface for all text in this project is AvenirNext.
For example, AvenirNext-Medium, AvenirNext-DemiBold, etc.
I may refer to fonts simply as the style, for example Regular 10, Bold 24, or MediumItalic 32.
These would correspond to AvenirNext-Regular (size 10), AvenirNext-Bold (size 24), AvenirNext-MediumItalic (size 32).

There are six icons imported in XCode as assets already. They are all SVG files. They should all be displayed in 20x20 pixels.
They are pace_icon, head_to_head_icon, pace_comparison_icon, trivia_icon, learn_more_icon, and video_icon.

## Header

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

## Pace

The icon is pace_icon.
The title style is Medium 12.

The bar graph has pace per mile on the y-axis and mile number on the x-axis. This should support whatever unit is passed into PaceComponent. The y-axis label should be "PACE PER <unit>". The x-axis should only label "<unit> 1" and "<unit> 26.2".
The y-axis scale varies depending on the split data. I'm not sure the best way to generalize this, i.e. generate a reasonable y-range given a list of splits. Any thoughts?
The bar chart is interactive; whenever the user is touching a bar, it should display a label, such as "Mile 1: 4:42", as well as slightly saturate the color of the bar.

The background color is a linear gradient, from top to bottom, it's #070A97 to #03045E.
The bars in the bar chart are #4586FF. The text is white.
The horizontal lines in the bar chart are #2D2FB4.

## Head to head

The background color is #37035E. The title is Bold 14. The description is Medium 12.
The lighter shade of purple used for every other row is #450079. The row text style is Medium 10.
Possibly I want some interactivity here later; don't add anything for now.

## Pace comparison

The background color is #035E3C. Title is Bold 14, description is Medium 12.
Similar to the previous bar chart, each bar is interactive. When the user is touching a bar, it displays a label with the title, for example "100m WR: 9.58 (Bolt 2009)", as well as slightly saturates the bar color.
The bar color is #00E573. The color used for the x-axis and y-axis is #047E51.

## Trivia

Title is Bold 14. Each trivia fact is Medium 12. Background color is #5E2003.

## Video

Title is Bold 14. The background color is #5E0303. The YouTube re-direct thumbnail is the only content of this component.

## Learn more

Title is Bold 14. Each link is Medium 10. Background color is #9D6A43.
