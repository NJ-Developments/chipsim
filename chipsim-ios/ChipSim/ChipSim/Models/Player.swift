//
//  Player.swift
//  ChipSim
//
//  Created by Cameron Entezarian on 12/22/25.
//

import Foundation

// MARK: - Poker Player
struct PokerPlayer: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var bankroll: Int
    var totalBuyIn: Int
    var bet: Int
    var roundContribution: Int
    var acted: Bool
    var stats: PlayerStats
    var folded: Bool
    var isAllIn: Bool
    
    init(name: String, bankroll: Int) {
        self.id = UUID()
        self.name = name
        self.bankroll = bankroll
        self.totalBuyIn = bankroll
        self.bet = 0
        self.roundContribution = 0
        self.acted = false
        self.stats = PlayerStats()
        self.folded = false
        self.isAllIn = false
    }
}

// MARK: - Blackjack Player
struct BlackjackPlayer: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var bankroll: Int
    var bet: Int
    var status: String
    var isDoubleDown: Bool
    var hasSurrendered: Bool
    var isSplit: Bool
    var splitCount: Int
    var splitBet: Int
    var splitBet2: Int
    var splitBet3: Int
    var activeHand: Int
    var hand1Result: String
    var hand2Result: String
    var hand3Result: String
    var hand4Result: String
    var splitOriginalBet: Int
    var split1DD: Bool
    var split2DD: Bool
    var split3DD: Bool
    var split4DD: Bool
    var winAmount: Int
    var handComplete: Bool
    var hasInsurance: Bool
    var insuranceBet: Int
    var stats: PlayerStats
    
    init(name: String, bankroll: Int) {
        self.id = UUID()
        self.name = name
        self.bankroll = bankroll
        self.bet = 0
        self.status = ""
        self.isDoubleDown = false
        self.hasSurrendered = false
        self.isSplit = false
        self.splitCount = 0
        self.splitBet = 0
        self.splitBet2 = 0
        self.splitBet3 = 0
        self.activeHand = 1
        self.hand1Result = ""
        self.hand2Result = ""
        self.hand3Result = ""
        self.hand4Result = ""
        self.splitOriginalBet = 0
        self.split1DD = false
        self.split2DD = false
        self.split3DD = false
        self.split4DD = false
        self.winAmount = 0
        self.handComplete = false
        self.hasInsurance = false
        self.insuranceBet = 0
        self.stats = PlayerStats()
    }
}

// MARK: - Player Statistics
struct PlayerStats: Codable, Equatable {
    var handsWon: Int = 0
    var handsLost: Int = 0
    var handsTied: Int = 0
    var wins: Int = 0
    var losses: Int = 0
    var pushes: Int = 0
    var blackjacks: Int = 0
    var totalWon: Int = 0
    var totalLost: Int = 0
    var biggestWin: Int = 0
    var handsPlayed: Int = 0
}

// MARK: - Series Statistics (for Poker)
struct SeriesStats: Codable {
    var seriesWins: Int = 0
    var seriesLosses: Int = 0
    var handsWon: Int = 0
    var handsLost: Int = 0
}

