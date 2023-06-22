//
//  MainView.swift
//  HW-07-OTUS
//
//  Created by Александр Никитин on 10.06.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainVM : MainViewModel = MainViewModel()
    
    var body: some View {
        VStack {
            List(mainVM.news, id: \.self) { news in
                Group {
                    if let urlToImg = news.urlToImage,
                       let data = mainVM.imagesForNews[urlToImg],
                       let uiImage = UIImage(data: data)
                       {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                    } else {
                        Image(systemName: "cross")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                    }
                    Text(news.title ?? "")
                }
                .onAppear{
                    Task {
                        if let url = news.urlToImage {
                            await mainVM.downloadImage(urlString: url)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task{
                await mainVM.updateNews()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
