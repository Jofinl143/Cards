import SwiftUI

struct EmptyCardView: View {
    @ObservedObject var viewModel = LiveCardsViewModel()
    
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Jane")
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .padding()
            }
            
            Text(text)
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            Image(systemName: "esim")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .padding()

            HStack {
                Text("Visa")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                Spacer()
                Text("Expiry")
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
            }
            .padding()
        }
        .foregroundColor(.white)
        .padding()
        .background(
            LinearGradient(colors: [Color(red: 255/255, green: 100/255, blue: 38/255, opacity: 1), Color.black], startPoint: .top, endPoint: .bottom)
        )
        .overlay(RoundedRectangle(cornerRadius: 6)
            .stroke(Color.black.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(6)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.top, 8)
        .onTapGesture {
            viewModel.refreshView()
        }

    }
}

#Preview {
    EmptyCardView(text: "Please save a card to view")
}
