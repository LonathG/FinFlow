//
//  CategoryEnvelopeCard.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct CategoryEnvelopeCard: View {
    public var category: BudgetCategory
    public var onSelect: () -> Void = {}
    
    public init(category: BudgetCategory, onSelect: @escaping () -> Void = {}) {
        self.category = category
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 14) {
                // Top Row: Category Icon & Remaining Badge
                HStack {
                    ZStack {
                        Circle()
                            .fill(category.category.backgroundTint)
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: category.category.icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(category.category.color)
                    }
                    
                    Spacer()
                    
                    Text("$\(String(format: "%.0f", category.remaining)) left")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(category.remaining > 20 ? FinFlowTheme.sproutGreenDark : FinFlowTheme.coral)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(category.remaining > 20 ? FinFlowTheme.sproutGreenLight : FinFlowTheme.coralLight)
                        )
                }
                
                // Titles
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(FinFlowTheme.textPrimary)
                    
                    Text(category.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(FinFlowTheme.textSecondary)
                }
                
                Spacer(minLength: 4)
                
                // Spent vs Allocated Figures
                HStack(alignment: .firstTextBaseline) {
                    Text("$\(String(format: "%.2f", category.spent))")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(FinFlowTheme.textPrimary)
                    
                    Text("of $\(String(format: "%.0f", category.allocated))")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(FinFlowTheme.textSecondary)
                    
                    Spacer()
                    
                    Text("\(Int(round(category.spentPercentage * 100)))%")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(FinFlowTheme.textSecondary)
                }
                
                // Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(FinFlowTheme.surfaceContainerHigh)
                            .frame(height: 7)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        category.category.color,
                                        category.category.color.opacity(0.85)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(8, geo.size.width * CGFloat(category.spentPercentage)), height: 7)
                    }
                }
                .frame(height: 7)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white.opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                    )
            )
            .shadow(color: FinFlowTheme.cardShadow, radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .hoverEffect(.lift)
    }
}
