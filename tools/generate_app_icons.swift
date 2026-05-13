import AppKit
import Foundation

struct IconSpec {
    let filename: String
    let pixelSize: Int
}

let outputRoot = URL(fileURLWithPath: "/Users/taichiumeki/projects/clockApp/AnalogCalendarClock/Assets.xcassets/AppIcon.appiconset", isDirectory: true)

let specs: [IconSpec] = [
    .init(filename: "iphone-notification-20@2x.png", pixelSize: 40),
    .init(filename: "iphone-notification-20@3x.png", pixelSize: 60),
    .init(filename: "iphone-settings-29@2x.png", pixelSize: 58),
    .init(filename: "iphone-settings-29@3x.png", pixelSize: 87),
    .init(filename: "iphone-spotlight-40@2x.png", pixelSize: 80),
    .init(filename: "iphone-spotlight-40@3x.png", pixelSize: 120),
    .init(filename: "iphone-app-60@2x.png", pixelSize: 120),
    .init(filename: "iphone-app-60@3x.png", pixelSize: 180),
    .init(filename: "ipad-notification-20.png", pixelSize: 20),
    .init(filename: "ipad-notification-20@2x.png", pixelSize: 40),
    .init(filename: "ipad-settings-29.png", pixelSize: 29),
    .init(filename: "ipad-settings-29@2x.png", pixelSize: 58),
    .init(filename: "ipad-spotlight-40.png", pixelSize: 40),
    .init(filename: "ipad-spotlight-40@2x.png", pixelSize: 80),
    .init(filename: "ipad-app-76.png", pixelSize: 76),
    .init(filename: "ipad-app-76@2x.png", pixelSize: 152),
    .init(filename: "ipad-pro-83.5@2x.png", pixelSize: 167),
    .init(filename: "ios-marketing-1024.png", pixelSize: 1024)
]

func drawIcon(pixelSize: Int) -> NSImage {
    let size = CGFloat(pixelSize)
    let image = NSImage(size: NSSize(width: size, height: size))

    image.lockFocus()
    defer { image.unlockFocus() }

    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    NSColor.white.setFill()
    rect.fill()

    let faceRect = rect.insetBy(dx: size * 0.15, dy: size * 0.15)
    let facePath = NSBezierPath(ovalIn: faceRect)
    NSColor(calibratedWhite: 0.998, alpha: 1.0).setFill()
    facePath.fill()
    facePath.lineWidth = max(1.0, size * 0.004)
    NSColor(calibratedWhite: 0.90, alpha: 1.0).setStroke()
    facePath.stroke()

    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = faceRect.width / 2.0

    func drawHand(angleDegrees: CGFloat, lengthRatio: CGFloat, lineWidthRatio: CGFloat, color: NSColor) {
        let radians = (angleDegrees - 90.0) * (.pi / 180.0)
        let endpoint = CGPoint(
            x: center.x + cos(radians) * radius * lengthRatio,
            y: center.y + sin(radians) * radius * lengthRatio
        )
        let path = NSBezierPath()
        path.move(to: center)
        path.line(to: endpoint)
        path.lineWidth = max(1.0, size * lineWidthRatio)
        path.lineCapStyle = .round
        color.setStroke()
        path.stroke()
    }

    drawHand(angleDegrees: 226, lengthRatio: 0.58, lineWidthRatio: 0.042, color: NSColor(calibratedWhite: 0.12, alpha: 1.0))
    drawHand(angleDegrees: 122, lengthRatio: 0.82, lineWidthRatio: 0.031, color: NSColor(calibratedWhite: 0.12, alpha: 1.0))
    drawHand(angleDegrees: 6, lengthRatio: 0.88, lineWidthRatio: 0.012, color: NSColor(calibratedRed: 1.0, green: 0.18, blue: 0.16, alpha: 1.0))

    let hubSize = size * 0.05
    NSColor(calibratedWhite: 0.14, alpha: 1.0).setFill()
    NSBezierPath(ovalIn: NSRect(x: center.x - hubSize / 2.0, y: center.y - hubSize / 2.0, width: hubSize, height: hubSize)).fill()

    return image
}

func writePNG(image: NSImage, to url: URL) throws {
    guard
        let tiffData = image.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiffData),
        let pngData = bitmap.representation(using: .png, properties: [:])
    else {
        throw NSError(domain: "AppIconGeneration", code: 1)
    }

    try pngData.write(to: url)
}

try FileManager.default.createDirectory(at: outputRoot, withIntermediateDirectories: true)

for spec in specs {
    let image = drawIcon(pixelSize: spec.pixelSize)
    try writePNG(image: image, to: outputRoot.appendingPathComponent(spec.filename))
}
