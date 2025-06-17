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
    
    var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy h:mm a"
            return formatter.string(from: date)
        }
    
    var body: some View {
        
        ZStack(alignment: .trailing) {
            HStack {
                Image(systemName: "circlebadge")
                    .foregroundColor(LeaFitColors.primary)

                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(16)
                    .padding(.horizontal)
                Spacer()
                VStack{
                    HStack{
                        Text(disease)
                            .font(.headline)
                            .foregroundColor(LeaFitColors.primary)
                            .padding(.top, 40)
                        Spacer()
                    }
                    
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                        .padding(.top, 10)
                }
                
                Color.red
                    .frame(width: 10, height: 120)
                    .cornerRadius(5, corners: [.topRight, .bottomRight])
            }
            .padding(.leading, 17)
                .background(LeaFitColors.light)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .padding(.horizontal)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
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

#Preview {
    JournalCard(
        image: "aloe_sample",
        disease: "Anthracnose",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 17, hour: 9, minute: 43))!
    )
}
