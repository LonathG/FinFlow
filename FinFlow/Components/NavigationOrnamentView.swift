//
//  NavigationOrnamentView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct NavigationOrnamentView: View {
    @Binding public var selectedTab: AppTab
    public var onQuickAdd: () -> Void = {}
    
    public init(selectedTab: Binding<AppTab>, onQuickAdd: @escaping () -> Void = {}) {
        self._selectedTab = selectedTab
        self.onQuickAdd = onQuickAdd
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            ForEach(AppTab.allCases) { tab in
                let isSelected = selectedTab == tab
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedTab = tab
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 17, weight: isSelected ? .bold : .medium))
                            .foregroundColor(isSelected ? Color.white : FinFlowTheme.textSecondary)
                        
                        if isSelected {
                            Text(tab.rawValue)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.white)
                                .transition(.opacity.combined(with: .move(edge: .leading)))
                        }
                    }
                    .padding(.horizontal, isSelected ? 16 : 14)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(isSelected ? FinFlowTheme.brand : Color.clear)
                            .shadow(color: isSelected ? FinFlowTheme.glowBrand : Color.clear, radius: 10, x: 0, y: 4)
                    )
                }
                .buttonStyle(.plain)
                .hoverEffect(.highlight)
            }
            
            Divider()
                .frame(height: 24)
                .padding(.horizontal, 4)
            
            // Quick Add Expense (+) Button
            Button(action: onQuickAdd) {
                ZStack {
                    Circle()
                        .fill(FinFlowTheme.sproutGreen)
                        .frame(width: 40, height: 40)
                        .shadow(color: FinFlowTheme.glowSprout, radius: 8, x: 0, y: 2)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            .hoverEffect(.lift)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: FinFlowTheme.floatingShadow, radius: 24, x: 0, y: 12)
        )
    }
}
