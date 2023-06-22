//
//  MainViewModel.swift
//  HW-07-OTUS
//
//  Created by Александр Никитин on 10.06.2023.
//

import Foundation



@MainActor
final class MainViewModel: ObservableObject {
    
    @Published var news : [News] = .init()
    @Published var imagesForNews: [String : Data] = .init()
    
    private var filesVM : FilesViewModel = .init()
    
    func updateNews() async {
    
        guard let url = URL(string: baseURL + secretKey) else { return }
        let request = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            self.filesVM.saveToFile(data: data, url: url.lastPathComponent)
            self.news = try! JSONDecoder().decode(NewsArray.self, from: data).articles!
            
        } catch {
            //Загружаем кэш с локального устройства (файлы)
            if let data = self.filesVM.loadFromFile(url: url.lastPathComponent) {
                self.news = try! JSONDecoder().decode(NewsArray.self, from: data).articles!
            }
        }
    }
    
    func downloadImage(urlString: String) async {
        if !self.imagesForNews.keys.contains(where: {$0 == urlString}){
            guard let url = URL(string: urlString) else { return }
            do{
                let (data, _) = try await URLSession.shared.data(from: url)
                self.imagesForNews[urlString] = data
                self.filesVM.saveToFile(data: data, url: url.lastPathComponent)
            } catch {
                print("🤬 Не могу загрузить картинку, проблема в интернет соединении")
                let data = self.filesVM.loadFromFile(url: url.lastPathComponent)
                self.imagesForNews[urlString] = data
            }
        }
    }
    
}


final class FilesViewModel: ObservableObject {
    
    func saveToFile(data: Data, url: String) {
        let manager = FileManager.default
        guard let cachesDir = manager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        var filePath = cachesDir
        let fileName = url
        filePath = filePath.appendingPathComponent(fileName)
        do {
            try data.write(to: filePath)
            print("✅ write file to path \(filePath)")
        } catch {
            print("☠️ SAVING ERROR \(error)")
        }
    }
    
    func loadFromFile(url: String) -> Data? {
        let manager = FileManager.default
        guard let cachesDir = manager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        var filePath = cachesDir
        let fileName = url
        filePath = filePath.appendingPathComponent(fileName)
        do {
            let data = try Data.init(contentsOf: filePath)
            return data
        } catch {
            print("☠️ LOADING ERROR \(error)")
            return nil
        }
    }
}
