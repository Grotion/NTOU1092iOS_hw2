//
//  GameOverPage.swift
//  ntou1092iOS_hw2
//
//  Created by Shaun Ku on 2021/3/18.
//

import SwiftUI

struct GameOverPage: View
{
    @Environment(\.presentationMode) var presentationMode
    var body: some View
    {
        GeometryReader
        {
            geometry in
            ZStack(alignment: .center)
            {
                Image("hw2_background")
                .resizable()
                .opacity(0.3)
                .frame(width: geometry.size.width)
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
                VStack
                {
                    Text("You're Broke :((")
                    .font(Font.custom("GillSans-Bold", size: 45))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.red)
                    Image("gameover")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 3 / 4, height: geometry.size.height * 1 / 3)
                    .shadow(radius: 20)
                    NavigationLink(destination: HomePage())
                    {
                        Text("Home")
                        .font(Font.custom("GillSans-Bold", size: 45))
                        .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing:50))
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color(red: 0/255, green: 204/255, blue: 204/255)))
                    }
                    .padding(.top, 10)
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct GameOverPage_Previews: PreviewProvider {
    static var previews: some View {
        GameOverPage()
    }
}
