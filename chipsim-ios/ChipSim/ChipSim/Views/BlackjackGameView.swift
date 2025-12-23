//
//  BlackjackGameView.swift
//  ChipSim
//
//  Created by Cameron Entezarian on 12/22/25.
//

import SwiftUI

struct BlackjackGameView: View {
    @ObservedObject var game: BlackjackGame
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    // Status Bar
                    HStack(spacing: Spacing.sm) {
                        Text("Round #\(game.roundNumber)")
                            .font(.system(size: FontSize.sm, weight: .medium))
                        Text("•")
                            .font(.system(size: FontSize.sm))
                        Text("Bankroll: $\(game.bankroll)")
                            .font(.system(size: FontSize.sm, weight: .medium))
                        
                        Spacer()
                    }
                    .padding(Spacing.sm)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.gold.opacity(0.2), lineWidth: 1)
                    )
                    
                    // Dealer Side
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("DEALER")
                            .font(.system(size: FontSize.md, weight: .semibold))
                            .foregroundColor(AppColors.gold)
                        
                        // Dealer cards would go here
                        HStack {
                            Text("CARD CARD")
                                .font(.system(size: FontSize.sm, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(Spacing.md)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.darkBackground)
                        .cornerRadius(8)
                    }
                    
                    // Player Side
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("PLAYER")
                            .font(.system(size: FontSize.md, weight: .semibold))
                            .foregroundColor(AppColors.gold)
                        
                        // Player cards would go here
                        HStack {
                            Text("🂡 🂢")
                                .font(.system(size: FontSize.lg))
                        }
                        .padding(Spacing.md)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.darkBackground)
                        .cornerRadius(8)
                    }
                    
                    // Outcome Banner
                    if !game.status.isEmpty {
                        Text(game.status)
                            .font(.system(size: FontSize.md, weight: .semibold))
                            .foregroundColor(AppColors.gold)
                            .padding(Spacing.sm)
                            .frame(maxWidth: .infinity)
                            .background(AppColors.darkBackground)
                            .cornerRadius(8)
                    }
                    
                    // Betting Controls
                    if game.phase == .betting {
                        BettingView(game: game)
                    }
                    
                    // Game Actions
                    if game.phase == .playing {
                        GameActionsView(game: game)
                    }
                    
                    // Statistics
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Statistics")
                            .font(.system(size: FontSize.md, weight: .semibold))
                            .foregroundColor(AppColors.gold)
                        
                        HStack(spacing: Spacing.md) {
                            VStack(spacing: Spacing.xs) {
                                Text("Wins")
                                    .font(.system(size: FontSize.xs))
                                Text("\(game.stats.wins)")
                                    .font(.system(size: FontSize.lg, weight: .bold))
                                    .foregroundColor(.green)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: Spacing.xs) {
                                Text("Losses")
                                    .font(.system(size: FontSize.xs))
                                Text("\(game.stats.losses)")
                                    .font(.system(size: FontSize.lg, weight: .bold))
                                    .foregroundColor(.red)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: Spacing.xs) {
                                Text("BJ")
                                    .font(.system(size: FontSize.xs))
                                Text("\(game.stats.blackjacks)")
                                    .font(.system(size: FontSize.lg, weight: .bold))
                                    .foregroundColor(AppColors.gold)
                            }
                        }
                    }
                    .padding(Spacing.md)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.gold.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(Spacing.md)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.05, green: 0.29, blue: 0.05),
                        Color(red: 0.02, green: 0.19, blue: 0.02)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Blackjack")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Home") {
                        game.resetGame()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BettingView: View {
    @ObservedObject var game: BlackjackGame
    @State private var betAmount: String = ""
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            Text("Place Your Bet")
                .font(.system(size: FontSize.md, weight: .semibold))
                .foregroundColor(.yellow)
            
            HStack(spacing: Spacing.sm) {
                TextField("Bet", text: $betAmount)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .font(.system(size: FontSize.sm))
                
                Button("Bet") {
                    if let amount = Int(betAmount), amount > 0 {
                        game.placeBet(amount: amount)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
                .controlSize(.small)
            }
            
            // Quick bet buttons
            HStack(spacing: Spacing.sm) {
                ForEach([10, 25, 50, 100, 500], id: \.self) { amount in
                    Button("$\(amount)") {
                        game.placeBet(amount: amount)
                    }
                    .buttonStyle(.bordered)
                    .tint(.yellow)
                    .controlSize(.small)
                    .font(.system(size: FontSize.xs))
                }
            }
            
            if game.bet > 0 {
                Button("Confirm Bet") {
                    game.confirmBet()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .controlSize(.small)
            }
        }
        .padding(Spacing.md)
        .background(AppColors.darkBackground)
        .cornerRadius(8)
    }
}

struct GameActionsView: View {
    @ObservedObject var game: BlackjackGame
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            Text("Your Turn")
                .font(.system(size: FontSize.md, weight: .semibold))
                .foregroundColor(.yellow)
            
            HStack(spacing: Spacing.sm) {
                Button("Hit") {
                    game.hit()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .controlSize(.small)
                
                Button("Stand") {
                    game.stand()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .controlSize(.small)
                
                Button("Double") {
                    game.doubleDown()
                }
                .buttonStyle(.bordered)
                .tint(.orange)
                .controlSize(.small)
            }
            
            HStack(spacing: Spacing.sm) {
                Button("Split") {
                    game.split()
                }
                .buttonStyle(.bordered)
                .tint(.purple)
                .controlSize(.small)
                
                Button("Surrender") {
                    game.surrender()
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .controlSize(.small)
            }
        }
        .padding(Spacing.md)
        .background(AppColors.darkBackground)
        .cornerRadius(8)
    }
}

#Preview {
    BlackjackGameView(game: BlackjackGame())
}

