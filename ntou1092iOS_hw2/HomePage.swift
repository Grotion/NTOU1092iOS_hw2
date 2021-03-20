//
//  HomePage.swift
//  ntou1092iOS_hw2
//
//  Created by Shaun Ku on 2021/3/16.
//

import SwiftUI

struct HomePage: View
{
    @State private var coin:Int = 800
    init()
    {
        //coin = 100
        coin = 800
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
                        Spacer()
                        Text("© 2021 Grotion")
                    }
                    VStack
                    {
                        Text("Contract Bridge")
                        .font(Font.custom("BradleyHandITCTT-Bold", size: 45))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 72/255, green: 61/255, blue: 139/255))
                        .multilineTextAlignment(.center)
                        .frame(width:geometry.size.width * 4 / 5)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing:0))
                        NavigationLink(destination: GamePage(coin: $coin))
                        {
                            Text("Play")
                            .font(Font.custom("GillSans-Bold", size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 100/255, green: 149/255, blue: 230/255))
                            .multilineTextAlignment(.center)
                            .frame(width:geometry.size.width * 1 / 3, height: 45)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 100/255, green: 149/255, blue: 230/255), style: StrokeStyle(lineWidth: 2)))
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing:0))
                        Link(destination: URL(string: "https://zh.wikipedia.org/wiki/合約橋牌".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!, label:
                        {
                            Text("Rule")
                            .font(Font.custom("GillSans-Bold", size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 233/255, green: 150/255, blue: 122/255))
                            .multilineTextAlignment(.center)
                            .frame(width:geometry.size.width * 1 / 3, height: 45)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 233/255, green: 150/255, blue: 122/255), style: StrokeStyle(lineWidth: 2)))
                        })
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HomePage_Previews: PreviewProvider
{
    static var previews: some View
    {
        HomePage()
    }
}
