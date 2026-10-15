//
//  FinFlowStore.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI
import Combine

public enum TimeframeFilter: String, CaseIterable {
    case thisWeek = "This Week"
    case lastWeek = "Last Week"
}

public enum AppTab: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case scanner = "OCR Scanner"
    case analytics = "Analytics"
    case split = "Split Bill"
    case garden3D = "3D Garden"
    case settings = "Profile"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .dashboard: return "leaf.fill"
        case .scanner: return "viewfinder"
        case .analytics: return "chart.xyaxis.line"
        case .split: return "person.2.fill"
        case .garden3D: return "cube.transparent.fill"
        case .settings: return "person.crop.circle"
        }
    }
}

@Observable
public final class FinFlowStore {
    // MARK: - Navigation & Flow
    public var selectedTab: AppTab = .dashboard
    public var isAuthenticated: Bool = true
    public var hasCompletedOnboarding: Bool = true
    public var showSplashIntro: Bool = false
    
    // User Profile
    public var userName: String = "Alex Morgan"
    public var userEmail: String = "alex.morgan@sprout.io"
    public var hasUnreadNotifications: Bool = true
    
    // MARK: - Weekly Budget State
    public var weeklyTarget: Double = 1000.00
    public var dayOfCycle: Int = 4
    public var totalDaysInCycle: Int = 7
    public var selectedTimeframe: TimeframeFilter = .thisWeek
    
    // MARK: - Sprout Vitality & Growth
    public var plantVitality: Double = 0.78
    public var waterCount: Int = 3
    public var isWatering: Bool = false
    
    // MARK: - Budget Envelopes
    public var categories: [BudgetCategory] = [
        BudgetCategory(name: "Groceries", subtitle: "Essential & Pantry", category: .groceries, allocated: 200.00, spent: 120.00),
        BudgetCategory(name: "Dining", subtitle: "Cafés & Outings", category: .dining, allocated: 80.00, spent: 45.00),
        BudgetCategory(name: "Transport", subtitle: "Subway & Rides", category: .transport, allocated: 50.00, spent: 32.00),
        BudgetCategory(name: "Shopping", subtitle: "Gear & Clothing", category: .shopping, allocated: 100.00, spent: 23.00)
    ]
    
    // MARK: - Transactions Ledger
    public var transactions: [Transaction] = []
    
    // MARK: - Historical Chart Series (Mon..Sun)
    public var thisWeekDailySpending: [Double] = [32.0, 24.0, 48.0, 42.8, 28.0, 18.0, 27.2]
    public var lastWeekDailySpending: [Double] = [45.0, 52.0, 38.0, 60.5, 35.0, 50.0, 30.0]
    
    // MARK: - Modal Triggers
    public var showAddExpenseModal: Bool = false
    public var showSplitBillModal: Bool = false
    public var editingTransaction: Transaction? = nil
    
    public init() {
        seedInitialData()
    }
    
    // MARK: - Computed Properties
    public var totalSpent: Double {
        if selectedTimeframe == .thisWeek {
            return transactions.reduce(0) { $0 + $1.amount }
        } else {
            return 310.50
        }
    }
    
    public var remainingAllowance: Double {
        max(0, weeklyTarget - totalSpent)
    }
    
    public var capacityIntactPercentage: Int {
        guard weeklyTarget > 0 else { return 0 }
        let pct = (remainingAllowance / weeklyTarget) * 100.0
        return Int(round(pct))
    }
    
    public var paceDifference: Double {
        return 45.0
    }
    
    public var plantGrowthStage: String {
        let capacity = capacityIntactPercentage
        if capacity >= 70 {
            return "Thriving Sprout"
        } else if capacity >= 40 {
            return "Growing Sapling"
        } else {
            return "Needs Nourishment"
        }
    }
    
    // MARK: - Interactive Actions
    public func waterPlant() {
        isWatering = true
        waterCount += 1
        plantVitality = min(1.0, plantVitality + 0.05)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isWatering = false
        }
    }
    
    public func addTransaction(
        merchant: String,
        amount: Double,
        category: ExpenseCategory,
        paymentMethod: String = "Apple Pay (•• 4821)",
        note: String? = nil,
        isScanned: Bool = false
    ) {
        let newTx = Transaction(
            merchant: merchant,
            category: category,
            amount: amount,
            date: Date(),
            paymentMethod: paymentMethod,
            note: note,
            isScannedReceipt: isScanned
        )
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            transactions.insert(newTx, at: 0)
            
            if let index = categories.firstIndex(where: { $0.category == category }) {
                categories[index].spent += amount
            } else {
                categories.append(BudgetCategory(name: category.rawValue, subtitle: "Custom Envelope", category: category, allocated: 100.00, spent: amount))
            }
            
            thisWeekDailySpending[3] += amount
            plantVitality = max(0.1, Double(capacityIntactPercentage) / 100.0)
        }
    }
    
    public func updateTransaction(id: UUID, merchant: String, amount: Double, category: ExpenseCategory, note: String?) {
        if let idx = transactions.firstIndex(where: { $0.id == id }) {
            let oldAmount = transactions[idx].amount
            let oldCategory = transactions[idx].category
            
            transactions[idx].merchant = merchant
            transactions[idx].amount = amount
            transactions[idx].category = category
            transactions[idx].note = note
            
            // Adjust categories
            if oldCategory == category {
                if let catIdx = categories.firstIndex(where: { $0.category == category }) {
                    categories[catIdx].spent += (amount - oldAmount)
                }
            } else {
                if let oldCatIdx = categories.firstIndex(where: { $0.category == oldCategory }) {
                    categories[oldCatIdx].spent = max(0, categories[oldCatIdx].spent - oldAmount)
                }
                if let newCatIdx = categories.firstIndex(where: { $0.category == category }) {
                    categories[newCatIdx].spent += amount
                }
            }
        }
    }
    
    public func deleteTransaction(id: UUID) {
        withAnimation(.easeInOut) {
            if let idx = transactions.firstIndex(where: { $0.id == id }) {
                let tx = transactions[idx]
                if let catIndex = categories.firstIndex(where: { $0.category == tx.category }) {
                    categories[catIndex].spent = max(0, categories[catIndex].spent - tx.amount)
                }
                transactions.remove(at: idx)
            }
        }
    }
    
    // MARK: - Initial Seed Data
    private func seedInitialData() {
        let calendar = Calendar.current
        let now = Date()
        
        let tx1 = Transaction(
            merchant: "Whole Foods Market",
            category: .groceries,
            amount: 42.80,
            date: calendar.date(byAdding: .hour, value: -2, to: now) ?? now,
            paymentMethod: "Apple Pay (•• 4821)",
            note: "Weekly organic veggies & oat milk",
            isScannedReceipt: true
        )
        
        let tx2 = Transaction(
            merchant: "Metro Transit",
            category: .transport,
            amount: 2.75,
            date: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
            paymentMethod: "Apple Pay",
            note: "Downtown commute"
        )
        
        let tx3 = Transaction(
            merchant: "Blue Bottle Coffee",
            category: .dining,
            amount: 5.40,
            date: calendar.date(byAdding: .day, value: -1, to: calendar.date(byAdding: .hour, value: 1, to: now)!) ?? now,
            paymentMethod: "Card ••4829",
            note: "New Orleans cold brew"
        )
        
        let tx4 = Transaction(
            merchant: "Trader Joe's",
            category: .groceries,
            amount: 77.20,
            date: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
            paymentMethod: "Card ••4829",
            note: "Pantry supplies & fruits"
        )
        
        let tx5 = Transaction(
            merchant: "Sweetgreen",
            category: .dining,
            amount: 39.60,
            date: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
            paymentMethod: "Apple Pay (•• 4821)",
            note: "Harvest bowl lunch with team"
        )
        
        let tx6 = Transaction(
            merchant: "Metro Transit",
            category: .transport,
            amount: 29.25,
            date: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
            paymentMethod: "Apple Pay",
            note: "Weekly metro pass refill"
        )
        
        let tx7 = Transaction(
            merchant: "Amazon Basics",
            category: .shopping,
            amount: 23.00,
            date: calendar.date(byAdding: .day, value: -4, to: now) ?? now,
            paymentMethod: "Card ••4829",
            note: "Phone charging cables"
        )
        
        transactions = [tx1, tx2, tx3, tx4, tx5, tx6, tx7]
    }
}
