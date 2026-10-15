//
//  ReceiptScanSample.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct ReceiptLineItem: Identifiable, Codable {
    public var id: String = UUID().uuidString
    public var title: String
    public var price: Double
    
    public init(title: String, price: Double) {
        self.title = title
        self.price = price
    }
}

public struct OCRBoundingBox: Identifiable {
    public var id: String = UUID().uuidString
    public var label: String
    public var x: CGFloat // normalized 0..1
    public var y: CGFloat // normalized 0..1
    public var width: CGFloat
    public var height: CGFloat
    public var isKeyMetric: Bool
}

public struct ReceiptScanSample: Identifiable {
    public var id: String
    public var merchant: String
    public var category: ExpenseCategory
    public var totalAmount: Double
    public var subtotal: Double
    public var tax: Double
    public var paymentMethod: String
    public var confidence: Double
    public var timestampString: String
    public var imageName: String
    public var items: [ReceiptLineItem]
    public var boundingBoxes: [OCRBoundingBox]
    
    public static let samples: [ReceiptScanSample] = [
        ReceiptScanSample(
            id: "whole_foods",
            merchant: "Whole Foods Market",
            category: .groceries,
            totalAmount: 42.80,
            subtotal: 39.50,
            tax: 3.30,
            paymentMethod: "Apple Pay (•• 4821)",
            confidence: 0.992,
            timestampString: "Today, 11:24 AM",
            imageName: "SampleReceipt",
            items: [
                ReceiptLineItem(title: "Organic Oat Milk 64oz", price: 4.99),
                ReceiptLineItem(title: "Avocados Bag Organic", price: 5.99),
                ReceiptLineItem(title: "Honeycrisp Apples (2.4 lb)", price: 7.18),
                ReceiptLineItem(title: "Artisan Sourdough Loaf", price: 6.49),
                ReceiptLineItem(title: "Wild Caught Salmon Fillet", price: 14.85)
            ],
            boundingBoxes: [
                OCRBoundingBox(label: "WHOLE FOODS MARKET", x: 0.22, y: 0.15, width: 0.56, height: 0.05, isKeyMetric: false),
                OCRBoundingBox(label: "ORGANIC OAT MILK $4.99", x: 0.18, y: 0.28, width: 0.64, height: 0.035, isKeyMetric: false),
                OCRBoundingBox(label: "AVOCADOS BAG $5.99", x: 0.18, y: 0.33, width: 0.64, height: 0.035, isKeyMetric: false),
                OCRBoundingBox(label: "WILD SALMON $14.85", x: 0.18, y: 0.38, width: 0.64, height: 0.035, isKeyMetric: false),
                OCRBoundingBox(label: "SUBTOTAL $39.50", x: 0.18, y: 0.50, width: 0.64, height: 0.035, isKeyMetric: false),
                OCRBoundingBox(label: "TOTAL $42.80", x: 0.18, y: 0.56, width: 0.64, height: 0.05, isKeyMetric: true)
            ]
        ),
        ReceiptScanSample(
            id: "apple_store",
            merchant: "Apple Fifth Avenue",
            category: .shopping,
            totalAmount: 129.00,
            subtotal: 119.00,
            tax: 10.00,
            paymentMethod: "Apple Card (•• 9012)",
            confidence: 0.998,
            timestampString: "Yesterday, 3:45 PM",
            imageName: "SampleReceipt",
            items: [
                ReceiptLineItem(title: "MagSafe Battery Pack", price: 99.00),
                ReceiptLineItem(title: "USB-C Woven Cable (2m)", price: 20.00)
            ],
            boundingBoxes: [
                OCRBoundingBox(label: "APPLE FIFTH AVENUE", x: 0.25, y: 0.16, width: 0.50, height: 0.05, isKeyMetric: false),
                OCRBoundingBox(label: "MAGSAFE PACK $99.00", x: 0.18, y: 0.30, width: 0.64, height: 0.035, isKeyMetric: false),
                OCRBoundingBox(label: "TOTAL $129.00", x: 0.18, y: 0.54, width: 0.64, height: 0.05, isKeyMetric: true)
            ]
        ),
        ReceiptScanSample(
            id: "blue_bottle",
            merchant: "Blue Bottle Coffee",
            category: .dining,
            totalAmount: 14.50,
            subtotal: 12.20,
            tax: 1.10,
            paymentMethod: "Apple Pay (•• 4821)",
            confidence: 0.985,
            timestampString: "Today, 8:15 AM",
            imageName: "SampleReceipt",
            items: [
                ReceiptLineItem(title: "Hayes Valley Espresso", price: 5.50),
                ReceiptLineItem(title: "Cardamom Morning Bun", price: 6.70)
            ],
            boundingBoxes: [
                OCRBoundingBox(label: "BLUE BOTTLE COFFEE", x: 0.22, y: 0.16, width: 0.56, height: 0.05, isKeyMetric: false),
                OCRBoundingBox(label: "ESPRESSO + BUN", x: 0.18, y: 0.32, width: 0.64, height: 0.035, isKeyMetric: false),
                OCRBoundingBox(label: "TOTAL $14.50", x: 0.18, y: 0.52, width: 0.64, height: 0.05, isKeyMetric: true)
            ]
        )
    ]
}
