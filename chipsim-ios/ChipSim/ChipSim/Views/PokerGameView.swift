//
//  PokerGameView.swift
//  ChipSim
//
//  Created by Cameron Entezarian on 12/22/25.
//

import SwiftUI
import UIKit

struct PokerGameView: View {
    @ObservedObject var game: PokerGame
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 2) {
                // Status Bar
                HStack(spacing: 4) {
                    Text("Hand #\(game.round)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                    Text("•")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                    Text(game.street.rawValue.capitalized)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                    if game.phase == .betting, game.activePlayerIndex < game.players.count {
                        Text("•")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                        Text("\(game.players[game.activePlayerIndex].name)'s Turn")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    if game.canUndo {
                        Button("UNDO") {
                            game.undo()
                        }
                        .buttonStyle(.bordered)
                        .font(.system(size: 9))
                        .controlSize(.mini)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                    }
                    
                    Button("End") {
                        game.resetGame()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .font(.system(size: 9))
                    .controlSize(.mini)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                }
                .padding(4)
                .background(AppColors.cardBackground)
                .cornerRadius(4)
                    
                    // Result Banner
                    if let result = game.lastResult {
                        Text(result.message)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(AppColors.gold)
                            .padding(4)
                            .frame(maxWidth: .infinity)
                            .background(AppColors.cardBackground)
                            .cornerRadius(4)
                    }
                    
                    // Burn Card Prompt
                    if game.burnCardPending {
                        VStack(spacing: 2) {
                            Text("BURN & DEAL")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(AppColors.gold)
                            
                            Button("Done") {
                                game.acknowledgeBurnCard()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.yellow)
                            .controlSize(.mini)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                        }
                        .padding(4)
                        .background(AppColors.cardBackground)
                        .cornerRadius(4)
                    }
                    
                    // Top Section: Board and Pot
                    HStack(spacing: 4) {
                        // Community Board
                        VStack(spacing: 2) {
                            Text("BOARD")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 4) {
                                ForEach(0..<5) { index in
                                    CardSlotView(
                                        isDealt: getCardSlotDealt(index: index)
                                    )
                                }
                            }
                        }
                        .padding(4)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.cardBackground)
                        .cornerRadius(4)
                        
                        // Pot Display
                        VStack(spacing: 2) {
                            Text("POT")
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                            Text("$\(game.pot + game.players.reduce(0) { $0 + $1.bet })")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(AppColors.gold)
                        }
                        .padding(4)
                        .frame(width: geometry.size.width * 0.18)
                        .background(AppColors.cardBackground)
                        .cornerRadius(4)
                    }
                    
                    // Active Player Card
                    if game.phase == .betting && game.activePlayerIndex < game.players.count {
                        let activePlayer = game.players[game.activePlayerIndex]
                        PlayerCardView(
                            player: activePlayer,
                            isActive: true,
                            isDealer: game.activePlayerIndex == game.dealerIndex,
                            isSB: game.activePlayerIndex == getSBIndex(),
                            isBB: game.activePlayerIndex == getBBIndex()
                        )
                        .frame(height: geometry.size.height * 0.12)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 4) {
                                ForEach(Array(game.players.enumerated()), id: \.element.id) { index, player in
                                    PlayerCardView(
                                        player: player,
                                        isActive: index == game.activePlayerIndex && game.phase == .betting,
                                        isDealer: index == game.dealerIndex,
                                        isSB: index == getSBIndex(),
                                        isBB: index == getBBIndex()
                                    )
                                }
                            }
                        }
                        .frame(height: geometry.size.height * 0.15)
                    }
                    
                    Spacer(minLength: 0)
                    
                    // Controls
                    if game.phase == .result {
                        Button("Deal Next Hand") {
                            game.newRound()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppColors.gold)
                        .font(.system(size: 12, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                    } else if game.phase == .showdown {
                        ScrollView {
                            VStack(spacing: 4) {
                                Text("SHOWDOWN")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(AppColors.gold)
                                
                                ForEach(Array(game.getActivePlayers().enumerated()), id: \.element.id) { index, player in
                                    if let playerIndex = game.players.firstIndex(where: { $0.id == player.id }) {
                                        Button("\(player.name) Wins") {
                                            game.declareWinner(playerIndex)
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(AppColors.gold)
                                        .controlSize(.small)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 30)
                                    }
                                }
                                
                                Button("Split Pot") {
                                    game.declareWinner(nil)
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                                .frame(maxWidth: .infinity)
                                .frame(height: 30)
                            }
                        }
                        .frame(height: geometry.size.height * 0.2)
                    } else if !game.burnCardPending && game.phase == .betting {
                        BettingControlsView(game: game, geometry: geometry)
                            .frame(height: geometry.size.height * 0.4)
                    }
                }
                .padding(2)
                .frame(width: geometry.size.width, height: geometry.size.height)
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
            .onAppear {
                AppDelegate.orientationLock = .landscape
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
            .onDisappear {
                AppDelegate.orientationLock = .all
            }
    }
    
    private func getCardSlotDealt(index: Int) -> Bool {
        let streetCards: [PokerStreet: Int] = [.preflop: 0, .flop: 3, .turn: 4, .river: 5]
        let revealedCount = game.burnCardPending ? streetCards[getStreetBefore(game.street)] ?? 0 : streetCards[game.street] ?? 0
        return index < revealedCount
    }
    
    private func getStreetBefore(_ street: PokerStreet) -> PokerStreet {
        let order: [PokerStreet] = [.preflop, .flop, .turn, .river]
        if let idx = order.firstIndex(of: street), idx > 0 {
            return order[idx - 1]
        }
        return .preflop
    }
    
    private func getSBIndex() -> Int {
        guard game.players.count >= 2 else { return 0 }
        if game.players.count == 2 {
            return game.dealerIndex
        }
        return (game.dealerIndex + 1) % game.players.count
    }
    
    private func getBBIndex() -> Int {
        guard game.players.count >= 2 else { return 1 }
        if game.players.count == 2 {
            return (game.dealerIndex + 1) % game.players.count
        }
        return (game.dealerIndex + 2) % game.players.count
    }
}

struct CardSlotView: View {
    let isDealt: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(isDealt ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                .frame(width: 32, height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(AppColors.gold.opacity(0.3), lineWidth: 1)
                )
            
            if isDealt {
                Text("CARD")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Text("?")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
        }
    }
}

struct PlayerCardView: View {
    let player: PokerPlayer
    let isActive: Bool
    let isDealer: Bool
    let isSB: Bool
    let isBB: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(player.name)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(AppColors.gold)
                
                Spacer()
                
                if isDealer {
                    Text("D")
                        .font(.system(size: 8))
                        .padding(2)
                        .background(Color.blue)
                        .cornerRadius(2)
                } else if isSB {
                    Text("SB")
                        .font(.system(size: 8))
                        .padding(2)
                        .background(Color.gray)
                        .cornerRadius(2)
                } else if isBB {
                    Text("BB")
                        .font(.system(size: 8))
                        .padding(2)
                        .background(Color.orange)
                        .cornerRadius(2)
                }
            }
            
            Text("$\(player.bankroll)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            
            if player.folded {
                Text("FOLD")
                    .font(.system(size: 8))
                    .foregroundColor(.red)
            } else if player.isAllIn {
                Text("ALL-IN $\(player.bet)")
                    .font(.system(size: 8))
                    .foregroundColor(.orange)
            } else if player.bet > 0 {
                Text("$\(player.bet)")
                    .font(.system(size: 8))
                    .foregroundColor(.green)
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isActive ? AppColors.gold.opacity(0.3) : AppColors.cardBackground)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(isActive ? AppColors.gold : AppColors.gold.opacity(0.2), lineWidth: isActive ? 2 : 1)
        )
    }
}

struct BettingControlsView: View {
    @ObservedObject var game: PokerGame
    let geometry: GeometryProxy
    
    var body: some View {
        Group {
            if game.activePlayerIndex < game.players.count {
                bettingControlsContent
            } else {
                Text("Invalid game state")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    private var bettingControlsContent: some View {
        VStack(spacing: 2) {
            let player = game.players[game.activePlayerIndex]
            let toCall = max(0, game.currentBet - player.bet)
            
            Text("\(player.name)'s Turn")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
            
            if toCall > 0 {
                Text("$\(toCall) to call")
                    .font(.system(size: 9))
                    .foregroundColor(AppColors.gold)
            } else {
                Text("Check available")
                    .font(.system(size: 9))
                    .foregroundColor(.green)
            }
            
            // Primary Actions
            HStack(spacing: 4) {
                Button("Fold") {
                    game.fold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .font(.system(size: 12, weight: .bold))
                .frame(height: 35)
                .frame(maxWidth: .infinity)
                
                if toCall > 0 {
                    Button("Call $\(min(toCall, player.bankroll))") {
                        game.call()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .font(.system(size: 12, weight: .bold))
                    .frame(height: 35)
                    .frame(maxWidth: .infinity)
                } else {
                    Button("CHECK") {
                        game.check()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .font(.system(size: 12, weight: .bold))
                    .frame(height: 35)
                    .frame(maxWidth: .infinity)
                }
                
                if player.bankroll > 0 {
                    Button("ALL-IN") {
                        game.allIn()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .font(.system(size: 12, weight: .bold))
                    .frame(height: 35)
                    .frame(maxWidth: .infinity)
                }
            }
            
            // Raise Options - 6 chips across the bottom
            if player.bankroll > toCall {
                let raises = game.getValidRaises()
                if !raises.isEmpty {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("RAISE TO")
                            .font(.system(size: 8))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 2) {
                            ForEach(Array(raises.prefix(6).enumerated()), id: \.offset) { index, raise in
                                Button(action: {
                                    game.raise(to: raise.amount)
                                }) {
                                    GeometryReader { chipGeometry in
                                        ZStack {
                                            Circle()
                                                .fill(getChipGradient(raise.chipColor))
                                                .overlay(
                                                    Circle()
                                                        .stroke(getChipBorderColor(raise.chipColor), lineWidth: 1.5)
                                                )
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                                                        .frame(width: chipGeometry.size.width * 0.7, height: chipGeometry.size.height * 0.7)
                                                )
                                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                                            
                                            VStack(spacing: 0) {
                                                Text(raise.label)
                                                    .font(.system(size: 7, weight: .bold))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.6)
                                                Text("$\(raise.amount)")
                                                    .font(.system(size: 8, weight: .bold))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.6)
                                            }
                                            .foregroundColor(getChipTextColor(raise.chipColor))
                                        }
                                    }
                                    .aspectRatio(1, contentMode: .fit)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
        }
        .padding(4)
        .background(AppColors.cardBackground)
        .cornerRadius(4)
    }
    
    private func getChipGradient(_ chipColor: String) -> LinearGradient {
        switch chipColor.lowercased() {
        case "white": return ChipColors.whiteChip
        case "red": return ChipColors.redChip
        case "blue": return ChipColors.blueChip
        case "green": return ChipColors.greenChip
        case "orange": return ChipColors.orangeChip
        case "black": return ChipColors.blackChip
        case "gold": return ChipColors.goldChip
        default: return ChipColors.goldChip
        }
    }
    
    private func getChipBorderColor(_ chipColor: String) -> Color {
        switch chipColor.lowercased() {
        case "white": return ChipColors.whiteChipBorder
        case "red": return ChipColors.redChipBorder
        case "blue": return ChipColors.blueChipBorder
        case "green": return ChipColors.greenChipBorder
        case "orange": return ChipColors.orangeChipBorder
        case "black": return ChipColors.blackChipBorder
        case "gold": return ChipColors.goldChipBorder
        default: return ChipColors.goldChipBorder
        }
    }
    
    private func getChipTextColor(_ chipColor: String) -> Color {
        switch chipColor.lowercased() {
        case "white": return ChipColors.whiteChipText
        case "red": return ChipColors.redChipText
        case "blue": return ChipColors.blueChipText
        case "green": return ChipColors.greenChipText
        case "orange": return ChipColors.orangeChipText
        case "black": return ChipColors.blackChipText
        case "gold": return ChipColors.goldChipText
        default: return ChipColors.goldChipText
        }
    }
}

#Preview {
    PokerGameView(game: PokerGame())
}

