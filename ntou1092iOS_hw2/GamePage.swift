//
//  GamePage.swift
//  ntou1092iOS_hw2
//
//  Created by Shaun Ku on 2021/3/16.
//

import SwiftUI

struct GamePage: View
{
    @Environment(\.presentationMode) var presentationMode
    @Binding var coin:Int
    @State private var trumpSuit:String = "♣️"
    @State private var currentTrick:Int = 0
    @State private var callPlayer:Int = -1
    @State private var selectedSuit:String = "♠️"
    @State private var selectedTrick:Int = 1
    @State private var passCount:Int = 0
    @State private var playerCalls:[String] = ["","","",""]
    @State private var playerPlayCards = Array(repeating: Card(suit: "back", rank: ""), count: 4)
    @State private var playerPlayCardsShow:[Bool] = [false,false,false,false]
    @State private var playerTurn:Int = -1
    @State private var callable:Bool = false
    @State private var showCallAlert = false
    @State private var showPlayAlert = false
    @State private var tricks2win:Int = 6
    @State private var myTricks:Int = 0
    @State private var oppTricks:Int = 0
    @State private var infoAppear:Bool = false
    @State private var playDisable:Bool = true
    @State private var tableSuit:String = ""
    @State private var tableCardPlayed:Int = 0
    @State private var cards = [Card]()
    @State private var player0Cards = [Card]()
    @State private var player1Cards = [Card]()
    @State private var player2Cards = [Card]()
    @State private var player3Cards = [Card]()
    @State private var gameEnded:Bool = false
    @State private var showResultPage:Bool = false
    @State private var restartAvailable:Bool = false
    let cardPlayedTime: Double = 2.2
    func initialGame()
    {
        trumpSuit="♣️"
        currentTrick = 0
        callPlayer = Int.random(in: 0...3)
        //callPlayer = 1
        print("Player Start Calling: \(callPlayer)")
        selectedSuit = "♠️"
        selectedTrick = 1
        passCount = 0
        for i in (0..<playerCalls.count)
        {playerCalls[i] = ""}
        playerPlayCards.removeAll()
        for _ in (0..<4)
        {
            let tmpCard = Card(suit: "back", rank: "")
            playerPlayCards.append(tmpCard)
        }
        for i in (0..<playerPlayCardsShow.count)
        {playerPlayCardsShow[i] = false}
        playerTurn = -1
        if(callPlayer==0){callable=true}
        else{callable=false}
        showCallAlert = false
        showPlayAlert = false
        tricks2win = 6
        myTricks = 0
        oppTricks = 0
        infoAppear = false
        //infoAppear = true
        playDisable = true
        tableSuit = ""
        tableCardPlayed = 0
        gameEnded = false
        showResultPage = false
        restartAvailable = false
        //restartAvailable = true
        
        cards.removeAll()
        player0Cards.removeAll()
        player1Cards.removeAll()
        player2Cards.removeAll()
        player3Cards.removeAll()
        for suit in suits
        {
            for rank in ranks
            {cards.append(Card(suit: suit, rank: rank))}
        }
        cards.shuffle()
        //printCards(name:"Cards Deks", cards2print:cards)
        for i in 0..<cards.count
        {
            if(i%4==0){player0Cards.append(cards[i])}
            else if(i%4==1){player1Cards.append(cards[i])}
            else if(i%4==2){player2Cards.append(cards[i])}
            else if(i%4==3){player3Cards.append(cards[i])}
        }
        sortCards(original: $player0Cards)
        sortCards(original: $player1Cards)
        sortCards(original: $player2Cards)
        sortCards(original: $player3Cards)
        //printCards(name:"Player0 Cards", cards2print:player0Cards)
        //printCards(name:"Player1 Cards", cards2print:player1Cards)
        //printCards(name:"Player2 Cards", cards2print:player2Cards)
        //printCards(name:"Player3 Cards", cards2print:player3Cards)
        //remake!!!!!!!!!!!
        computerCallCards(currentPlayer: callPlayer)
    }
    func printCards(name:String, cards2print:[Card])
    {
        print("\(name):")
        for i in 0..<cards2print.count
        {
            print("\(cards2print[i].rank)_of_\(cards2print[i].suit)")
        }
    }
    func sortCards(original: Binding<[Card]>)
    {
        var sortedData = [Card]()
        var currentCard:Card
        for suit in suits
        {
            for rank in ranks
            {
                currentCard = Card(suit:suit, rank:rank)
                for i in 0..<original.wrappedValue.count
                {
                    if((currentCard.suit==original[i].suit.wrappedValue)&&(currentCard.rank==original[i].rank.wrappedValue))
                    {sortedData.append(currentCard)}
                }
            }
        }
        original.wrappedValue = sortedData
        sortedData.removeAll()
    }
    func checkSelected(trumpSuit:String, currentTrick:Int, selectedSuit:String, selectedTrick:Int) -> Bool
    {
        var selectedAvailable = true
        if(selectedTrick<currentTrick){selectedAvailable = false}
        else if(selectedTrick==currentTrick)
        {
            if(trumpSuit=="♠️"){selectedAvailable = false}
            if((trumpSuit=="♥️")&&(selectedSuit != "♠️")){selectedAvailable = false}
            if((trumpSuit=="♦️")&&((selectedSuit=="♦️")||(selectedSuit=="♣️"))){selectedAvailable = false}
            if((trumpSuit=="♣️")&&(selectedSuit=="♣️")){selectedAvailable = false}
        }
        return selectedAvailable
    }
    func passCall(currentPlayer:Int)
    {
        switch currentPlayer
        {
            case 0:
                print("Player 0 Pass!")
                playerCalls[0] = "Pass"
                break
            case 1:
                print("Player 1 Pass!")
                playerCalls[1]  = "Pass"
                break
            case 2:
                print("Player 2 Pass!")
                playerCalls[2]  = "Pass"
                break
            case 3:
                print("Player 3 Pass!")
                playerCalls[3]  = "Pass"
                break
            default:
                break
        }
        passCount  += 1
        //print("Pass Count:\(passCount)")
        if(passCount==3)
        {
            if(callPlayer%2==0){tricks2win = 6+currentTrick}
            else{tricks2win = 13-6-currentTrick}
            for i in (0..<playerCalls.count)
            {playerCalls[i]=""}
            playerTurn = callPlayer
            //playerTurn = 0
            callable = false
            infoAppear = true
            playDisable = false
            playCard(currentPlayer: playerTurn)
        }
        else
        {
            if(currentPlayer==3)
            {
                playerCalls[0] = ""
                callable = true
            }
            else if(currentPlayer==0)
            {callable = false}
        }
    }
    func computerCallCards(currentPlayer:Int)
    {
        let maxTrick2Call_Team:Int = 4
        let maxTrick2Call_Opp:Int = 5
        let maxRandomCall_Team:Int = 3
        let maxRandomCall_Opp:Int = 4
        let player1prob:Int = 30
        let player2prob:Int = 20
        let player3prob:Int = 10
        let callDecision = Int.random(in: 0...100)
        var callAvailable = false
        var randomTrick:Int = 1
        var randomSuitIndex:Int = 3
        switch currentPlayer
        {
            case 1:
                if(playDisable)
                {
                    playerCalls[1] = ""
                    if((currentTrick>maxTrick2Call_Opp)||((currentTrick==maxTrick2Call_Opp)&&(trumpSuit=="♠️")))
                    {passCall(currentPlayer: 1)}
                    else
                    {
                        if(callDecision<player1prob||currentTrick==0)
                        {
                            while(!callAvailable)
                            {
                                if(currentTrick==0){randomTrick = 1}
                                else{randomTrick = Int.random(in: 1...maxRandomCall_Opp)}
                                randomSuitIndex = Int.random(in: 0..<4)
                                callAvailable = checkSelected(trumpSuit:trumpSuit, currentTrick:currentTrick, selectedSuit:suitEmojis[randomSuitIndex], selectedTrick:randomTrick)
                            }
                            //print("callAvailable:\(callAvailable)")
                            playerCalls[1] = "\(randomTrick)\(suitEmojis[randomSuitIndex])"
                            print("Palyer1 Call: \(playerCalls[1])")
                            trumpSuit = suitEmojis[randomSuitIndex]
                            currentTrick = randomTrick
                            callPlayer = 1
                            passCount = 0
                        }
                        else
                        {passCall(currentPlayer: 1)}
                    }
                    computerCallCards(currentPlayer: 2)
                }
                break
            case 2:
                if(playDisable)
                {
                    playerCalls[2] = ""
                    if((currentTrick>maxTrick2Call_Team)||((currentTrick==maxTrick2Call_Team)&&(trumpSuit=="♠️")))
                    {passCall(currentPlayer: 2)}
                    else
                    {
                        if(callDecision<player2prob||currentTrick==0)
                        {
                            while(!callAvailable)
                            {
                                if(currentTrick==0){randomTrick = 1}
                                else{randomTrick = Int.random(in: 1...maxRandomCall_Team)}
                                randomSuitIndex = Int.random(in: 0..<4)
                                callAvailable = checkSelected(trumpSuit:trumpSuit, currentTrick:currentTrick, selectedSuit:suitEmojis[randomSuitIndex], selectedTrick:randomTrick)
                            }
                            //print("callAvailable:\(callAvailable)")
                            playerCalls[2] = "\(randomTrick)\(suitEmojis[randomSuitIndex])"
                            print("Palyer2 Call: \(playerCalls[2])")
                            trumpSuit = suitEmojis[randomSuitIndex]
                            currentTrick = randomTrick
                            callPlayer = 2
                            passCount = 0
                        }
                        else
                        {passCall(currentPlayer: 2)}
                    }
                    computerCallCards(currentPlayer: 3)
                }
                break
            case 3:
                if(playDisable)
                {
                    playerCalls[3] = ""
                    if((currentTrick>maxTrick2Call_Opp)||((currentTrick==maxTrick2Call_Opp)&&(trumpSuit=="♠️")))
                    {passCall(currentPlayer: 3)}
                    else
                    {
                        if(callDecision<player3prob||currentTrick==0)
                        {
                            while(!callAvailable)
                            {
                                if(currentTrick==0){randomTrick = 1}
                                else{randomTrick = Int.random(in: 1...maxRandomCall_Opp)}
                                randomSuitIndex = Int.random(in: 0..<4)
                                callAvailable = checkSelected(trumpSuit:trumpSuit, currentTrick:currentTrick, selectedSuit:suitEmojis[randomSuitIndex], selectedTrick:randomTrick)
                            }
                            //print("callAvailable:\(callAvailable)")
                            playerCalls[3] = "\(randomTrick)\(suitEmojis[randomSuitIndex])"
                            print("Palyer3 Call: \(playerCalls[3])")
                            trumpSuit = suitEmojis[randomSuitIndex]
                            currentTrick = randomTrick
                            callPlayer = 3
                            passCount = 0
                            callable = true
                        }
                        else
                        {passCall(currentPlayer: 3)}
                    }
                }
                break
            case 0:
                break
            default:
                print("Unknow Current Player!")
                break
        }
    }
    func checkPlayCard(playerDeck:[Card],tableSuit:String, playingCardSuit:String) -> Bool
    {
        var available = true
        if(!(tableSuit==""))
        {
            if(!(playingCardSuit==tableSuit))
            {
                for i in (0..<playerDeck.count)
                {
                    if(playerDeck[i].suit==tableSuit)
                    {available = false}
                }
            }
        }
        return available
    }
    func setPlayCard(currentPlayer:Int,card2Play:Card,index:Int)
    {
        if(currentPlayer<=3)&&(currentPlayer>=0)
        {
            playerPlayCards[currentPlayer].suit = card2Play.suit
            playerPlayCards[currentPlayer].rank = card2Play.rank
            playerPlayCardsShow[currentPlayer] = true
            tableCardPlayed += 1
            switch currentPlayer
            {
                case 3:
                    player3Cards.remove(at: index)
                    break
                case 2:
                    player2Cards.remove(at: index)
                    break
                case 1:
                    player1Cards.remove(at: index)
                    break
                case 0:
                    player0Cards.remove(at: index)
                    break
                default:
                    print("Unknow Current Player!")
                    break
            }
        }
    }
    func playCard(currentPlayer:Int)
    {
        var playCardFind:Bool = false
        var firstCardIndex:Int
        switch currentPlayer
        {
            case 3:
                if(!(tableSuit==""))
                {
                    playCardFind = false
                    for i in (0..<player3Cards.count)
                    {
                        if(player3Cards[i].suit==tableSuit)
                        {
                            setPlayCard(currentPlayer: 3, card2Play: player3Cards[i], index: i)
                            playCardFind = true
                            break
                        }
                    }
                    if(!playCardFind)
                    {
                        for i in (0..<player3Cards.count)
                        {
                            if(player3Cards[i].suit==trumpSuit)
                            {
                                setPlayCard(currentPlayer: 3, card2Play: player3Cards[i], index: i)
                                playCardFind = true
                                break
                            }
                        }
                    }
                }
                if((!playCardFind)||tableSuit=="")
                {
                    firstCardIndex = Int.random(in: 0..<player3Cards.count)
                    if(tableSuit==""){tableSuit = player3Cards[firstCardIndex].suit}
                    setPlayCard(currentPlayer: 3, card2Play: player3Cards[firstCardIndex], index: firstCardIndex)
                    
                }
                print("Player3 Play: \(playerPlayCards[3].rank) of \(playerPlayCards[3].suit)")
                if(tableCardPlayed==4){setResult()}
                else
                {
                    playerTurn = 2
                    playCard(currentPlayer: 2)
                }
                break
            case 2:
                if(!(tableSuit==""))
                {
                    playCardFind = false
                    for i in (0..<player2Cards.count)
                    {
                        if(player2Cards[i].suit==tableSuit)
                        {
                            setPlayCard(currentPlayer: 2, card2Play: player2Cards[i], index: i)
                            playCardFind = true
                            break
                        }
                    }
                    if(!playCardFind)
                    {
                        for i in (0..<player2Cards.count)
                        {
                            if(player2Cards[i].suit==trumpSuit)
                            {
                                setPlayCard(currentPlayer: 2, card2Play: player2Cards[i], index: i)
                                playCardFind = true
                                break
                            }
                        }
                    }
                }
                if((!playCardFind)||tableSuit=="")
                {
                    firstCardIndex = Int.random(in: 0..<player2Cards.count)
                    if(tableSuit==""){tableSuit = player2Cards[firstCardIndex].suit}
                    setPlayCard(currentPlayer: 2, card2Play: player2Cards[firstCardIndex], index: firstCardIndex)
                }
                print("Player2 Play: \(playerPlayCards[2].rank) of \(playerPlayCards[2].suit)")
                if(tableCardPlayed==4){setResult()}
                else
                {
                    playerTurn = 1
                    playCard(currentPlayer: 1)
                }
                break
            case 1:
                if(!(tableSuit==""))
                {
                    playCardFind = false
                    for i in (0..<player1Cards.count)
                    {
                        if(player1Cards[i].suit==tableSuit)
                        {
                            setPlayCard(currentPlayer: 1, card2Play: player1Cards[i], index: i)
                            playCardFind = true
                            break
                        }
                    }
                    if(!playCardFind)
                    {
                        for i in (0..<player1Cards.count)
                        {
                            if(player1Cards[i].suit==trumpSuit)
                            {
                                setPlayCard(currentPlayer: 1, card2Play: player1Cards[i], index: i)
                                playCardFind = true
                                break
                            }
                        }
                    }
                }
                if((!playCardFind)||tableSuit=="")
                {
                    firstCardIndex = Int.random(in: 0..<player1Cards.count)
                    if(tableSuit==""){tableSuit = player1Cards[firstCardIndex].suit}
                    setPlayCard(currentPlayer: 1, card2Play: player1Cards[firstCardIndex], index: firstCardIndex)
                }
                print("Player1 Play: \(playerPlayCards[1].rank) of \(playerPlayCards[1].suit)")
                if(tableCardPlayed==4){setResult()}
                else{playerTurn = 0}
                break
            case 0:
                break
            default:
                print("Unknow Current Player!")
                break
        }
    }
    func setResult()
    {
        playerTurn = -1
        let roundWinner = findWinner()
        print("Round Winner: \(roundWinner)")
        if(roundWinner%2==0){myTricks+=1}
        else{oppTricks+=1}
        DispatchQueue.main.asyncAfter(deadline: .now()+cardPlayedTime)
        {
            playerTurn = roundWinner
            if(myTricks+oppTricks==13)
            {
                clearTable()
                infoAppear = false
                gameEnded = true
                DispatchQueue.main.asyncAfter(deadline: .now()+2)
                {
                    showResultPage = true
                    restartAvailable = true
                }
            }
            else
            {
                clearTable()
                playCard(currentPlayer: roundWinner)
            }
        }
    }
    func findWinner() -> Int
    {
        var winner:Int = -1
        let trump:String = suits[suitEmojis.firstIndex(of: trumpSuit) ?? 0]
        var cardsRank:[Int] = [-1,-1,-1,-1]
        var currentMaxRank:Int = -1
        for i in (0..<ranks.count)
        {
            for j in (0..<playerPlayCards.count)
            {
                if(playerPlayCards[j].rank==ranks[i])
                {cardsRank[j] = i}
            }
        }
        for i in (0..<playerPlayCards.count)
        {
            if(playerPlayCards[i].suit==tableSuit)
            {
                if(cardsRank[i]>currentMaxRank)
                {
                    winner = i
                    currentMaxRank = cardsRank[i]
                }
            }
        }
        currentMaxRank = -1
        for i in (0..<playerPlayCards.count)
        {
            if(playerPlayCards[i].suit==trump)
            {
                if(cardsRank[i]>currentMaxRank)
                {
                    winner = i
                    currentMaxRank = cardsRank[i]
                }
            }
        }
        return winner
    }
    func clearTable()
    {
        playerPlayCards.removeAll()
        for _ in (0..<4)
        {
            let tmpCard = Card(suit: "back", rank: "")
            playerPlayCards.append(tmpCard)
        }
        for i in (0..<playerPlayCardsShow.count)
        {playerPlayCardsShow[i] = false}
        tableSuit=""
        tableCardPlayed=0
        
    }
    var body: some View
    {
        GeometryReader
        {
            geometry in
            ZStack
            {
                Image("hw2_background")
                .resizable()
                .opacity(0.3)
                .frame(width: geometry.size.width)
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
                InfoView(isShow: $infoAppear, trumpSuit: $trumpSuit, tricks2win: $tricks2win, myTricks: $myTricks, oppTricks: $oppTricks, tableSuit: $tableSuit, playerTurn: $playerTurn)
                player1CardView(player1Cards: $player1Cards, playerCalls: $playerCalls)
                player2CardView(player2Cards: $player2Cards, playerCalls: $playerCalls)
                player3CardView(player3Cards: $player3Cards, playerCalls: $playerCalls)
                VStack
                {
                    Spacer()
                    if(playDisable)
                    {
                        VStack
                        {
                            Text("\(playerCalls[0])")
                            HStack
                            {
                                Picker(selection: $selectedTrick, label: Text(""), content:
                                {
                                    ForEach(1..<8, id: \.self)
                                    {
                                        number in
                                        Text("\(number)")
                                            .font(Font.custom("ArialMT", size: 20))
                                        .fontWeight(.bold)
                                    }
                                })
                                .frame(width: 40, height: 40, alignment: .center)
                                .clipped()
                                .disabled(!callable)
                                Picker(selection: $selectedSuit, label: Text(""), content:
                                {
                                    ForEach(suitEmojis, id: \.self)
                                    {
                                        (suitEmoji) in
                                        Text(suitEmoji)
                                        .font(Font.custom("ArialMT", size: 20))
                                    }
                                })
                                .frame(width: 40, height: 40, alignment: .center)
                                .clipped()
                                .disabled(!callable)
                                Button(action:{
                                    if(checkSelected(trumpSuit:trumpSuit, currentTrick:currentTrick, selectedSuit:selectedSuit, selectedTrick:selectedTrick))
                                    {
                                        playerCalls[0] = "\(selectedTrick)\(selectedSuit)"
                                        print("Palyer0 Call: \(playerCalls[0])")
                                        trumpSuit = selectedSuit
                                        currentTrick = selectedTrick
                                        callPlayer = 0
                                        passCount = 0
                                        callable = false
                                        computerCallCards(currentPlayer: 1)
                                    }
                                    else
                                    {
                                        print("unavailable")
                                        showCallAlert = true
                                    }
                                }, label:
                                {
                                    Text("confirm")
                                    .font(Font.custom("GillSans-Bold", size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .frame(width:60, height: 30)
                                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing:5))
                                    .opacity(callable ? 1 : 0.3)
                                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color(red: 255/255, green: 255/255, blue: 153/255)))
                                })
                                .alert(isPresented: $showCallAlert)
                                { () -> Alert in
                                    Alert(title: Text("Call isn't available!"), message: Text("Please Check Your Call Carefully!!"), dismissButton: .default(Text("Okay")))
                                }
                                .disabled(!callable)
                                Button(action:{
                                    passCall(currentPlayer: 0)
                                    if(playDisable)
                                    {
                                        computerCallCards(currentPlayer: 1)
                                    }
                                }, label:
                                {
                                    Text("pass")
                                    .font(Font.custom("GillSans-Bold", size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .frame(width:50, height: 30)
                                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing:5))
                                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color(red: 204/255, green: 255/255, blue: 204/255)))
                                    .opacity((!callable)||(currentTrick==0) ? 0.3 : 1)
                                })
                                .disabled((!callable)||(currentTrick==0))
                            }
                        }
                    }
                    HStack(alignment: .center, spacing: -35, content:
                    {
                        Group
                        {
                            ForEach(0..<player0Cards.count, id: \.self)
                            {
                                index in
                                Button(action:
                                {
                                    if(checkPlayCard(playerDeck: player0Cards,tableSuit: tableSuit, playingCardSuit:player0Cards[index].suit))
                                    {
                                        if(tableSuit=="")
                                        {tableSuit=player0Cards[index].suit}
                                        setPlayCard(currentPlayer: 0, card2Play: player0Cards[index], index: index)
                                        print("Player0 Play: \(playerPlayCards[0].rank) of \(playerPlayCards[0].suit)")
                                        if(tableCardPlayed==4){setResult()}
                                        else
                                        {
                                            playerTurn = 3
                                            playCard(currentPlayer: 3)
                                        }
                                    }
                                    else{showPlayAlert = true}
                                }, label:
                                {
                                    Image("\(player0Cards[index].rank)_of_\(player0Cards[index].suit)")
                                    .resizable()
                                    .background(Color.white)
                                    .frame(width: 60, height:80)
                                    .scaledToFit()
                                    .border(Color.black, width: 1)
                                })
                                .alert(isPresented: $showPlayAlert)
                                { () -> Alert in
                                    Alert(title: Text("This card isn't available!"), message: Text("Please Check Carefully!!"), dismissButton: .default(Text("Okay")))
                                }
                                .disabled(!(playerTurn==0))
                                
                            }
                        }
                        
                    })
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                }
                HStack
                {
                    //player3PlayCard
                    Image(playerPlayCards[3].suit=="back" ? "back" : "\(playerPlayCards[3].rank)_of_\(playerPlayCards[3].suit)")
                    .resizable()
                    .background(Color.white)
                    .frame(width: 50, height:80)
                    .scaledToFit()
                    .border(Color.black, width: 1)
                    .opacity(playerPlayCardsShow[3] ? 1 : 0)
                    .rotationEffect(.degrees(90))
                    Spacer()
                    .frame(width: 100, height: 100)
                    //player1PlayCard
                    Image(playerPlayCards[1].suit=="back" ? "back" : "\(playerPlayCards[1].rank)_of_\(playerPlayCards[1].suit)")
                    .resizable()
                    .background(Color.white)
                    .frame(width: 60, height:80)
                    .scaledToFit()
                    .border(Color.black, width: 1)
                    .opacity(playerPlayCardsShow[1] ? 1 : 0)
                    .rotationEffect(.degrees(90))
                }
                VStack
                {
                    //player2PlayCard
                    Image(playerPlayCards[2].suit=="back" ? "back" : "\(playerPlayCards[2].rank)_of_\(playerPlayCards[2].suit)")
                    .resizable()
                    .background(Color.white)
                    .frame(width: 60, height:80)
                    .scaledToFit()
                    .border(Color.black, width: 1)
                    .opacity(playerPlayCardsShow[2] ? 1 : 0)
                    Spacer()
                    .frame(width: 100, height: 100)
                    //player0PlayCard
                    Image(playerPlayCards[0].suit=="back" ? "back" : "\(playerPlayCards[0].rank)_of_\(playerPlayCards[0].suit)")
                    .resizable()
                    .background(Color.white)
                    .frame(width: 60, height:80)
                    .scaledToFit()
                    .border(Color.black, width: 1)
                    .opacity(playerPlayCardsShow[0] ? 1 : 0)
                }
                VStack
                {
                    Spacer()
                    HStack
                    {
                        Button(action:{initialGame()}
                        , label:
                        {
                            Text("Restart")
                            .font(Font.custom("San Francisco", size: 15))
                            .fontWeight(.bold)
                                .foregroundColor(Color.red)
                            .frame(width:60, height: 45)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing:10))
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.red, style: StrokeStyle(lineWidth: 2)))
                            .opacity(restartAvailable ? 1 : 0.3)
                        })
                        .disabled(!restartAvailable)
                        /*Button(action:{presentationMode.wrappedValue.dismiss()}
                        , label:
                        {
                            Text("Home")
                            .font(Font.custom("GillSans-Bold", size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 123/255, green: 104/255, blue: 238/255))
                            .frame(width:60, height: 45)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing:10))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 123/255, green: 104/255, blue: 238/255), style: StrokeStyle(lineWidth: 2)))
                            .opacity(restartAvailable ? 1 : 0.3)
                        })
                        .disabled(!restartAvailable)*/
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                Text("Game\nEnded")
                .font(Font.custom("GillSans-Bold", size: 60))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 123/255, green: 104/255, blue: 238/255))
                .opacity(gameEnded ? 1 : 0)
                .fullScreenCover(isPresented: $showResultPage, content: {
                    ResultPage(showResultPage: $showResultPage, tricks2win: $tricks2win, myTricks: $myTricks, oppTricks: $oppTricks, coin: $coin)
                })
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .onAppear
        {
            initialGame()
        }
    }
}

struct GamePage_Previews: PreviewProvider
{
    static var previews: some View
    {
        GamePage(coin: .constant(5000))
    }
}

struct InfoView: View
{
    @Binding var isShow:Bool
    @Binding var trumpSuit:String
    @Binding var tricks2win:Int
    @Binding var myTricks:Int
    @Binding var oppTricks:Int
    @Binding var tableSuit:String
    @Binding var playerTurn:Int
    var body: some View
    {
        if(isShow)
        {
            VStack
            {
                VStack(alignment: .leading)
                {
                    HStack
                    {
                        Text("Trump: \(trumpSuit)")
                        .font(Font.custom("PingFangSC-Regular", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 102/255, green: 0/255, blue: 204/255))
                        Text(tableSuit=="" ? "" : "Current suit: \(suitEmojis[suits.firstIndex(of: tableSuit) ?? 0])")
                        .font(Font.custom("PingFangSC-Regular", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 204/255, green: 0/255, blue: 102/255))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    HStack
                    {
                        Text("Tricks To Win: \(tricks2win)")
                        .font(Font.custom("San Francisco", size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 255/255, green: 255/255, blue: 0/255))
                        Text("My Tricks: \(myTricks)")
                        .font(Font.custom("PingFangSC-Regular", size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0/255, green: 102/255, blue: 204/255))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        Text("Opp. Tricks: \(oppTricks)")
                        .font(Font.custom("PingFangSC-Regular", size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    HStack
                    {
                        Text(playerTurn == -1 ? "" :"Player Turn: player\(playerTurn)")
                        .font(Font.custom("PingFangSC-Regular", size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                //.frame(height:100)
                Spacer()
            }
        }
    }
}

struct player1CardView: View
{
    @Binding var player1Cards:[Card]
    @Binding var playerCalls:[String]
    var body: some View
    {
        HStack
        {
            Spacer()
            Text("\(playerCalls[1])")
            VStack(alignment: .center, spacing: -35, content:
            {
                Group
                {
                    ForEach(player1Cards.indices, id: \.self)
                    {
                        (index) in
                        Image("back")
                            .resizable()
                            .frame(width: 80, height:60)
                            .scaledToFit()
                            .border(Color.black, width: 1)
                    }
                }
                
            })
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
        }
    }
}

struct player2CardView: View
{
    @Binding var player2Cards:[Card]
    @Binding var playerCalls:[String]
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center, spacing: -35, content:
            {
                Group
                {
                    ForEach(player2Cards.indices, id: \.self)
                    {
                        (index) in
                        Image("back")
                            .resizable()
                            .frame(width: 60, height:80)
                            .scaledToFit()
                            .border(Color.black, width: 1)
                    }
                }
                
            })
                .padding(EdgeInsets(top: 100, leading: 0, bottom: 0, trailing: 0))
            Text("\(playerCalls[2])")
            Spacer()
        }
    }
}

struct player3CardView: View
{
    @Binding var player3Cards:[Card]
    @Binding var playerCalls:[String]
    var body: some View
    {
        HStack
        {
            VStack(alignment: .center, spacing: -35, content:
            {
                Group
                {
                    ForEach(player3Cards.indices, id: \.self)
                    {
                        (index) in
                        Image("back")
                            .resizable()
                            .frame(width: 80, height:60)
                            .scaledToFit()
                            .border(Color.black, width: 1)
                    }
                }
            })
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            Text("\(playerCalls[3])")
            Spacer()
        }
    }
}
