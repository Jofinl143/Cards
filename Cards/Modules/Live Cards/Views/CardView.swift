import SwiftUI

struct CardView: View {
    @ObservedObject var liveCardViewModel = LiveCardsViewModel()
    
    let isFromSavedCardView: Bool
    let card: Card
    
    var plusOrMinusImage: String {
        if card.isCardSaved == 1 {
            return "minus.circle"
        } else {
            return "plus.circle"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Text("Nicolas Martin")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .accessibilityIdentifier("nameText")
                
                Spacer()
                if !isFromSavedCardView {
                    Image(systemName: plusOrMinusImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .accessibilityIdentifier("addOrRemoveImage")
                        .onTapGesture {
                            if card.isCardSaved == 1 {
                                liveCardViewModel.deleteCard(card: card)
                            } else {
                                liveCardViewModel.saveCard(card: card)
                            }
                        }
                }
            }
            .padding()
            
            Text(card.credit_card_number)
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .accessibilityIdentifier("cardNumberText")
                .padding()
            
            Image(systemName: "esim")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .padding()
            
            HStack {
                Text(card.credit_card_type)
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .accessibilityIdentifier("cardTypeText")
                Spacer()
                Text(card.credit_card_expiry_date)
                    .accessibilityIdentifier("expiryText")
                    .font(.system(size: 14, weight: .medium))
            }
            .padding()
        }
        .foregroundColor(.white)
        .background(
            LinearGradient(colors: [Color(red: 176/255, green: 143/255, blue: 38/255, opacity: 1), Color.black], startPoint: .top, endPoint: .bottom)
        )
        .overlay(RoundedRectangle(cornerRadius: 6)
            .stroke(Color.black.opacity(0.5), lineWidth: 1)
        )
        .alert(liveCardViewModel.showCardSavedAlertMessage, isPresented: $liveCardViewModel.showCardSavedAlert) {
            Button("OK", role: .cancel) { }
        }
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    CardView(isFromSavedCardView: false, card: Card(id: 1, uid: "123", credit_card_number: "123457894", credit_card_expiry_date: "11 Sept", credit_card_type: "Visa"))
}
