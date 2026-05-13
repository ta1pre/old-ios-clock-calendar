import UIKit

final class AnalogClockView: UIView {
    var palette: ClockPalette = .dark {
        didSet {
            setNeedsDisplay()
        }
    }

    var displayDate = Date() {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
        contentMode = .redraw
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isOpaque = false
        contentMode = .redraw
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let side = min(bounds.width, bounds.height)
        let radius = side * 0.46
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        drawFace(in: context, center: center, radius: radius)
        drawTicks(in: context, center: center, radius: radius)
        drawNumerals(center: center, radius: radius)
        drawHands(in: context, center: center, radius: radius)
        drawCenterPin(in: context, center: center, radius: radius)
    }

    private func drawFace(in context: CGContext, center: CGPoint, radius: CGFloat) {
        context.setStrokeColor(palette.clockRing.cgColor)
        context.setLineWidth(max(2.0, radius * 0.010))
        context.strokeEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2.0,
            height: radius * 2.0
        ))
    }

    private func drawTicks(in context: CGContext, center: CGPoint, radius: CGFloat) {
        for minute in 0..<60 {
            let angle = angleForMinute(minute)
            let isHourTick = minute % 5 == 0
            let outer = point(center: center, radius: radius * 0.94, angle: angle)
            let inner = point(center: center, radius: radius * (isHourTick ? 0.86 : 0.90), angle: angle)
            context.setStrokeColor((isHourTick ? palette.clockMajorTick : palette.clockMinorTick).cgColor)
            context.setLineWidth(max(isHourTick ? 3.2 : 1.2, radius * (isHourTick ? 0.016 : 0.006)))
            context.move(to: outer)
            context.addLine(to: inner)
            context.strokePath()
        }
    }

    private func drawNumerals(center: CGPoint, radius: CGFloat) {
        let fontSize = max(18.0, radius * 0.19)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: .regular),
            .foregroundColor: palette.clockNumeral
        ]

        for hour in 1...12 {
            let angle = angleForHour(hour % 12)
            let point = point(center: center, radius: radius * 0.72, angle: angle)
            let text = "\(hour)"
            let size = text.size(withAttributes: attributes)
            text.draw(
                at: CGPoint(x: point.x - size.width / 2.0, y: point.y - size.height / 2.0),
                withAttributes: attributes
            )
        }
    }

    private func drawHands(in context: CGContext, center: CGPoint, radius: CGFloat) {
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: displayDate) % 12
        let minute = calendar.component(.minute, from: displayDate)
        let second = calendar.component(.second, from: displayDate)

        let minuteAngle = angleForMinute(minute) + CGFloat(second) / 60.0 * (.pi / 30.0)
        let hourAngle = angleForHour(hour) + CGFloat(minute) / 60.0 * (.pi / 6.0)
        let secondAngle = angleForMinute(second)

        drawHand(
            in: context,
            center: center,
            length: radius * 0.63,
            tail: radius * 0.08,
            angle: hourAngle,
            width: max(8.0, radius * 0.040),
            color: palette.hourHand
        )

        drawHand(
            in: context,
            center: center,
            length: radius * 0.82,
            tail: radius * 0.08,
            angle: minuteAngle,
            width: max(6.0, radius * 0.026),
            color: palette.minuteHand
        )

        drawHand(
            in: context,
            center: center,
            length: radius * 0.84,
            tail: radius * 0.10,
            angle: secondAngle,
            width: max(2.0, radius * 0.008),
            color: palette.secondHand
        )
    }

    private func drawCenterPin(in context: CGContext, center: CGPoint, radius: CGFloat) {
        let outerRadius = max(8.0, radius * 0.060)
        let innerRadius = outerRadius * 0.36

        context.setFillColor(palette.centerOuter.cgColor)
        context.fillEllipse(in: CGRect(
            x: center.x - outerRadius,
            y: center.y - outerRadius,
            width: outerRadius * 2.0,
            height: outerRadius * 2.0
        ))

        context.setFillColor(palette.centerInner.cgColor)
        context.fillEllipse(in: CGRect(
            x: center.x - innerRadius,
            y: center.y - innerRadius,
            width: innerRadius * 2.0,
            height: innerRadius * 2.0
        ))
    }

    private func drawHand(
        in context: CGContext,
        center: CGPoint,
        length: CGFloat,
        tail: CGFloat,
        angle: CGFloat,
        width: CGFloat,
        color: UIColor
    ) {
        let end = point(center: center, radius: length, angle: angle)
        let start = point(center: center, radius: tail, angle: angle + .pi)
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(width)
        context.setLineCap(.round)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()
    }

    private func angleForHour(_ hour: Int) -> CGFloat {
        return CGFloat(hour) * (.pi / 6.0) - .pi / 2.0
    }

    private func angleForMinute(_ minute: Int) -> CGFloat {
        return CGFloat(minute) * (.pi / 30.0) - .pi / 2.0
    }

    private func point(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }
}
