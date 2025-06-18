//
//  JournalCard.swift
//  LeaFit
//
//  Created by FWZ on 17/06/25.
//

import SwiftUI

struct JournalCard: View {
    let image: UIImage
    let disease: String
    let date: Date
    let isFirst: Bool
    let isLast: Bool
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy h:mm a"
        return formatter.string(from: date)
    }
    
    var diseaseColor: Color {
        let disease = self.disease.lowercased()
        
        switch true {
        case disease.contains("anthracnose"):
            return Color(hex: "F40654")
        case disease.contains("rot"):
            return Color(hex: "7D28F7")
        case disease.contains("rust"):
            return Color(hex: "01FED0")
        case disease.contains("sunburn"):
            return Color(hex: "FF7E00")
        default:
            return Color.green
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                
                Spacer()
                    .frame(width: 30)
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipped()
                    .cornerRadius(16)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 4) {
                    
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
                
                Spacer()
                
                
                diseaseColor
                    .frame(width: 15, height: 120)
                    .cornerRadius(5, corners: [.topRight, .bottomRight])
            }
            .frame(height: 120)
            .background(LeaFitColors.light)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            
            
            HStack {
                ZStack {
                    VStack {
                        
                        Rectangle()
                            .fill(Color(hex: "428D6D").opacity(0.5))
                            .frame(width: 2, height: 62)
                            .opacity(isFirst ? 0 : 1)
                        
                        Spacer() // pakein ini biar si time line nya ga dorong ke antar line, instead ke dalam circle (jdi bisa di-adjust)
                        
                        Rectangle()
                            .fill(Color(hex: "428D6D").opacity(0.5))
                            .frame(width: 2, height: 62)
                            .opacity(isLast ? 0 : 1)
                    }
                    .frame(height: 140)
                    
                    
                    Image(systemName: "circlebadge")
                        .foregroundColor(LeaFitColors.primary)
                        .font(.title2)
                    
                }
                .frame(width: 45)
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

// Keep your existing extensions
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
    VStack(spacing: 0) {
        JournalCard(
            image: UIImage(systemName: "aloe_sample") ?? UIImage(),
            disease: "Anthracnose",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 17, hour: 9, minute: 43))!,
            isFirst: true,
            isLast: false
        )
        
        JournalCard(
            image: UIImage(systemName: "aloe_sample") ?? UIImage(),
            disease: "Rot (2 others)",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 16, hour: 14, minute: 20))!,
            isFirst: false,
            isLast: false
        )
        
        JournalCard(
            image: UIImage(systemName: "aloe_sample") ?? UIImage(),
            disease: "Very Long Disease Name That Might Cause Layout Issues (3 others)",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 15, hour: 8, minute: 15))!,
            isFirst: false,
            isLast: false
        )
        JournalCard(
            image: UIImage(systemName: "aloe_sample") ?? UIImage(),
            disease: "Sunburn Cok",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 15, hour: 8, minute: 15))!,
            isFirst: false,
            isLast: true
        )
    }
    .background(LeaFitColors.background)
}
