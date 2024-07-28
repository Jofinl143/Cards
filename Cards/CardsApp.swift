import SwiftUI

@main
struct CardsApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                LiveCardsView()
                    .tabItem {
                        Label("Cards", systemImage: "list.dash")
                    }
                
                SavedCardsView()
                    .tabItem {
                        Label("Saved Cards", systemImage: "creditcard.and.123")
                    }
            }
            
        }
    }
}
