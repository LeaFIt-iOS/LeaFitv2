//
//import SwiftUI
//import Foundation
//
//struct SwiftUIView : View {
//
//    @State var showingPopup = false // 1
//
//    var body: some View {
//        ZStack {
//            Color.red.opacity(0.2)
//            Button("Push me") {
//                showingPopup = true // 2
//            }
//        }
//        .popup(isPresented: $showingPopup) { // 3
//            ZStack { // 4
//                Color.blue.frame(width: 200, height: 100)
//                Text("Popup!")
//            }
//        }
//    }
//}
//#Preview {
//    SwiftUIView()
//}
