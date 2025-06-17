//
//  JournalCard.swift
//  LeaFit
//
//  Created by FWZ on 17/06/25.
//

import SwiftUI

struct JournalCard: View {
    let image: String
    let disease: String
    let date: Date
    let isFirst: Bool
    let isLast: Bool
    
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy h:mm a"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                ZStack {
                    VStack { //garis vertikal antar card
                        Rectangle()
                            .fill(Color(hex: "428D6D").opacity(0.5))
                            .frame(width: 2)
                            .opacity(isFirst ? 0 : 1)
                        Spacer()
                        Rectangle()
                            .fill(Color(hex: "428D6D").opacity(0.5))
                            .frame(width: 2)
                            .opacity(isLast ? 0 : 1)
                    }
                    
                    Image(systemName: "circlebadge")
                        .foregroundColor(LeaFitColors.primary)
                }
                                
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipped()
                    .cornerRadius(16)
                    .padding(.horizontal)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    // Disease title and (x others)
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(disease.components(separatedBy: " (").first ?? disease)
                                .font(.headline)
                                .foregroundColor(LeaFitColors.primary)
                                .lineLimit(1)
                            
                            if disease.contains("("),
                               let othersPart = disease.split(separator: "(").dropFirst().first {
                                Text("and (\(othersPart)")
                                    .font(.subheadline)
                                    .foregroundColor(LeaFitColors.primary)
                                    .lineLimit(1)
                                
                            }
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .padding(.trailing, 10)
                }
                .frame(height: 90)
                
                Color.red
                    .frame(width: 10, height: 120)
                    .cornerRadius(5, corners: [.topRight, .bottomRight])
            }
            .padding(.leading, 17)
            .frame(height: 120) // biar ga layout shifting
            .background(LeaFitColors.light)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .padding(.horizontal)
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Preview
#Preview {
    VStack(spacing: 16) {
        JournalCard(
            image: "aloe_sample",
            disease: "Anthracnose",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 17, hour: 9, minute: 43))!,
            isFirst: true,
            isLast: false
        )
        
        JournalCard(
            image: "aloe_sample",
            disease: "Anthracnose (2 others)",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 16, hour: 14, minute: 20))!,
            isFirst: false,
            isLast: false
        )
        
        JournalCard(
            image: "aloe_sample",
            disease: "Very Long Disease Name That Might Cause Layout Issues (3 others)",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 15, hour: 8, minute: 15))!,
            isFirst: false,
            isLast: true
        )
    }
    .background(LeaFitColors.background)
}
