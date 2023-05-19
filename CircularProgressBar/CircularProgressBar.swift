//
//  CircularProgressBar.swift
//  ElenergyLogisticsTH.iOS
//
//  Created by EDY on 2023/5/19.
//

import UIKit

class CircularProgressBar: UIView {
    // 圆弧两端的线帽类型
    enum LineCap {
        case round
        case butt
    }

    // 设置圆弧两端的线帽类型
    var lineCap: LineCap = .round

    // 圆环底色
    var trackColor: UIColor = UIColor.lightGray

    // 起始角度，默认为-90度（12点方向）
    var startAngle: Double = -90.0

    // 进度条是否顺时针旋转，默认为true
    var clockwise: Bool = true

    // 进度条的进度
    var progress: Double = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    // 进度条的渐变色数组
    var gradientColors: [CGColor]?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 根据视图大小和内边距生成圆环半径
        let diameter = min(rect.width - 2 * lineWidth, rect.height - 2 * lineWidth)
        let radius = diameter / 2.0

        // 确定圆心坐标
        let center = CGPoint(x: rect.midX, y: rect.midY)

        // 计算起始角度和结束角度
        let endAngle = startAngle + progress * 360.0 * (clockwise ? 1.0 : -1.0)
        let startRadian = CGFloat(degreesToRadians(degrees: startAngle))
        let endRadian = CGFloat(degreesToRadians(degrees: endAngle))

        // 绘制底层圆环
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startRadian, endAngle: startRadian + CGFloat(2 * Double.pi), clockwise: true)
        trackPath.lineWidth = lineWidth
        trackPath.lineCapStyle = (lineCap == .butt ? CGLineCap.butt : CGLineCap.round)
        trackColor.setStroke()
        trackPath.stroke()

        // 如果有渐变色，绘制进度条圆环
        if let colors = gradientColors {
            // 创建渐变色
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = rect

            var cgColors = [CGColor]()
            for color in colors {
                cgColors.append(color)
            }
            gradientLayer.colors = cgColors

            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineCap = (lineCap == .butt ? CAShapeLayerLineCap.butt : CAShapeLayerLineCap.round)
            shapeLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startRadian, endAngle: endRadian, clockwise: clockwise).cgPath
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = UIColor.black.cgColor
            gradientLayer.mask = shapeLayer

            layer.addSublayer(gradientLayer)
        }
    }

    // 将角度转为弧度
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }

    // 圆环的厚度，默认为20
    public var lineWidth: CGFloat = 20.0 {
        didSet {
            setNeedsDisplay()
        }
    }
}
