//
//  SparklineChartView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct SparklineChartView: View {
    public var isThisWeek: Bool
    @State private var hoveredIndex: Int? = 3 // Thursday default
    
    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    public init(isThisWeek: Bool) {
        self.isThisWeek = isThisWeek
    }
    
    public var body: some View {
        VStack(spacing: 14) {
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                
                ZStack {
                    // Area Gradient Fill
                    ChartAreaShape(isThisWeek: isThisWeek)
                        .fill(
                            LinearGradient(
                                colors: [
                                    FinFlowTheme.brand.opacity(0.32),
                                    FinFlowTheme.brand.opacity(0.08),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Chart Stroke Line
                    ChartCurveShape(isThisWeek: isThisWeek)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    FinFlowTheme.brand,
                                    FinFlowTheme.brandDark,
                                    FinFlowTheme.sproutGreen
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                        )
                        .shadow(color: FinFlowTheme.glowBrand, radius: 8, x: 0, y: 4)
                    
                    // Milestone Target Dots
                    if isThisWeek {
                        DotMarker(point: CGPoint(x: (15.0 / 340.0) * w, y: (105.0 / 140.0) * h), title: "$32", isHighlight: false)
                        DotMarker(point: CGPoint(x: (115.0 / 340.0) * w, y: (85.0 / 140.0) * h), title: "$48", isHighlight: false)
                        DotMarker(point: CGPoint(x: (170.0 / 340.0) * w, y: (45.0 / 140.0) * h), title: "$42.8", isHighlight: true)
                        DotMarker(point: CGPoint(x: (280.0 / 340.0) * w, y: (30.0 / 140.0) * h), title: "$18", isHighlight: false)
                        DotMarker(point: CGPoint(x: (325.0 / 340.0) * w, y: (22.0 / 140.0) * h), title: "$27.2", isHighlight: true)
                    } else {
                        DotMarker(point: CGPoint(x: (15.0 / 340.0) * w, y: (65.0 / 140.0) * h), title: "$45", isHighlight: false)
                        DotMarker(point: CGPoint(x: (125.0 / 340.0) * w, y: (70.0 / 140.0) * h), title: "$52", isHighlight: false)
                        DotMarker(point: CGPoint(x: (235.0 / 340.0) * w, y: (90.0 / 140.0) * h), title: "$60.5", isHighlight: true)
                        DotMarker(point: CGPoint(x: (325.0 / 340.0) * w, y: (55.0 / 140.0) * h), title: "$30", isHighlight: true)
                    }
                }
            }
            .frame(height: 140)
            
            // Day Labels along the bottom
            HStack {
                ForEach(0..<days.count, id: \.self) { idx in
                    let isCurrentDay = (isThisWeek && idx == 3) // Thu
                    let isSpecial = (isThisWeek && (idx == 3 || idx == 6))
                    
                    VStack(spacing: 4) {
                        Text(days[idx])
                            .font(.system(size: 13, weight: isSpecial ? .bold : .medium))
                            .foregroundColor(isCurrentDay ? FinFlowTheme.brand : FinFlowTheme.textSecondary)
                        
                        if isCurrentDay {
                            Circle()
                                .fill(FinFlowTheme.brand)
                                .frame(width: 4, height: 4)
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 4, height: 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Curve Shape
struct ChartCurveShape: Shape {
    var isThisWeek: Bool
    
    var animatableData: Double {
        get { isThisWeek ? 1.0 : 0.0 }
        set { }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let sx = rect.width / 340.0
        let sy = rect.height / 140.0
        
        if isThisWeek {
            path.move(to: CGPoint(x: 15 * sx, y: 105 * sy))
            path.addCurve(
                to: CGPoint(x: 115 * sx, y: 85 * sy),
                control1: CGPoint(x: 50 * sx, y: 110 * sy),
                control2: CGPoint(x: 75 * sx, y: 70 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 220 * sx, y: 38 * sy),
                control1: CGPoint(x: 150 * sx, y: 98 * sy),
                control2: CGPoint(x: 180 * sx, y: 30 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 325 * sx, y: 22 * sy),
                control1: CGPoint(x: 255 * sx, y: 46 * sy),
                control2: CGPoint(x: 280 * sx, y: 75 * sy)
            )
        } else {
            path.move(to: CGPoint(x: 15 * sx, y: 65 * sy))
            path.addCurve(
                to: CGPoint(x: 125 * sx, y: 70 * sy),
                control1: CGPoint(x: 55 * sx, y: 40 * sy),
                control2: CGPoint(x: 85 * sx, y: 95 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 235 * sx, y: 90 * sy),
                control1: CGPoint(x: 160 * sx, y: 50 * sy),
                control2: CGPoint(x: 195 * sx, y: 110 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 325 * sx, y: 55 * sy),
                control1: CGPoint(x: 270 * sx, y: 70 * sy),
                control2: CGPoint(x: 295 * sx, y: 45 * sy)
            )
        }
        return path
    }
}

// MARK: - Area Shape
struct ChartAreaShape: Shape {
    var isThisWeek: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let sx = rect.width / 340.0
        let sy = rect.height / 140.0
        
        if isThisWeek {
            path.move(to: CGPoint(x: 15 * sx, y: 105 * sy))
            path.addCurve(
                to: CGPoint(x: 115 * sx, y: 85 * sy),
                control1: CGPoint(x: 50 * sx, y: 110 * sy),
                control2: CGPoint(x: 75 * sx, y: 70 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 220 * sx, y: 38 * sy),
                control1: CGPoint(x: 150 * sx, y: 98 * sy),
                control2: CGPoint(x: 180 * sx, y: 30 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 325 * sx, y: 22 * sy),
                control1: CGPoint(x: 255 * sx, y: 46 * sy),
                control2: CGPoint(x: 280 * sx, y: 75 * sy)
            )
            path.addLine(to: CGPoint(x: 325 * sx, y: rect.height))
            path.addLine(to: CGPoint(x: 15 * sx, y: rect.height))
            path.closeSubpath()
        } else {
            path.move(to: CGPoint(x: 15 * sx, y: 65 * sy))
            path.addCurve(
                to: CGPoint(x: 125 * sx, y: 70 * sy),
                control1: CGPoint(x: 55 * sx, y: 40 * sy),
                control2: CGPoint(x: 85 * sx, y: 95 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 235 * sx, y: 90 * sy),
                control1: CGPoint(x: 160 * sx, y: 50 * sy),
                control2: CGPoint(x: 195 * sx, y: 110 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 325 * sx, y: 55 * sy),
                control1: CGPoint(x: 270 * sx, y: 70 * sy),
                control2: CGPoint(x: 295 * sx, y: 45 * sy)
            )
            path.addLine(to: CGPoint(x: 325 * sx, y: rect.height))
            path.addLine(to: CGPoint(x: 15 * sx, y: rect.height))
            path.closeSubpath()
        }
        return path
    }
}

// MARK: - Dot Marker
struct DotMarker: View {
    let point: CGPoint
    let title: String
    let isHighlight: Bool
    
    var body: some View {
        ZStack {
            if isHighlight {
                Circle()
                    .fill(FinFlowTheme.brand.opacity(0.4))
                    .frame(width: 22, height: 22)
                    .blur(radius: 5)
            }
            
            Circle()
                .fill(isHighlight ? FinFlowTheme.brand : Color.white)
                .frame(width: 12, height: 12)
                .overlay(
                    Circle()
                        .stroke(FinFlowTheme.brand, lineWidth: 2.5)
                )
            
            if isHighlight {
                Circle()
                    .fill(Color.white)
                    .frame(width: 4, height: 4)
            }
        }
        .position(point)
    }
}
