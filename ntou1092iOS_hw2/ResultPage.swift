//
//  ResultPage.swift
//  ntou1092iOS_hw2
//
//  Created by Shaun Ku on 2021/3/16.
//

import SwiftUI

struct ResultPage: View
{
    @Binding var showResultPage:Bool
    @Binding var tricks2win:Int
    @Binding var myTricks:Int
    @Binding var oppTricks:Int
    @Binding var coin:Int
    @State private var showGameOverPage:Bool = false
    let winCoin = 750
    let loseCoin = 500
    func setCoin()
    {
        //if(coin<=0){showGameOverPage}
        if(myTricks>=tricks2win)
        {coin += winCoin}
        else
        {coin -= loseCoin}
        if(coin<=0)
        {
            DispatchQueue.main.asyncAfter(deadline: .now()+2)
            {
                showGameOverPage = true
            }
        }
    }
    var body: some View
    {
        GeometryReader
        {
            geometry in
            NavigationView
            {
                ZStack
                {
                    Image("hw2_background")
                    .resizable()
                    .opacity(0.3)
                    .frame(width: geometry.size.width)
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                    VStack
                    {
                        Text(myTricks>=tricks2win ? "You Win :)" : "You Lose :((")
                        .font(Font.custom("Optima-Bold", size: 45))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 102/255, green: 102/255, blue: 255/255))
                        .frame(width:geometry.size.width * 4 / 5)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0))
                        HStack(alignment: .center)
                        {
                            Image("coin")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            Text(myTricks>=tricks2win ? ": \(coin)(+\(winCoin))" : ": \(coin)(-\(loseCoin))")
                            .font(Font.custom("Cochin-Bold", size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 204/255, green: 102/255, blue: 0/255))
                        }
                        Image(myTricks>=tricks2win ? "win" : "lose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 3 / 4, height: geometry.size.height * 1 / 3)
                        .shadow(radius: 20)
                        Button(action: {showResultPage=false}, label:
                        {
                            Text("Back")
                            .font(Font.custom("GillSans-Bold", size: 45))
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing:50))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, style: StrokeStyle(lineWidth: 2)))
                            .opacity(coin>0 ? 1 : 0)
                            
                        })
                        .disabled(coin<=0)
                        .padding(.top, 10)
                    }
                    NavigationLink(
                        destination: GameOverPage(),
                        isActive: $showGameOverPage,
                        label: {
                            EmptyView()
                        })
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
        .onAppear()
        {
            setCoin()
        }
    }
}

struct ResultPage_Previews: PreviewProvider {
    static var previews: some View {
        ResultPage(showResultPage: .constant(true), tricks2win: .constant(7), myTricks: .constant(8), oppTricks: .constant(1), coin: .constant(5000))
    }
}
