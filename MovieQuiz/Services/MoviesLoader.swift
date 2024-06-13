//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Alexander Bralnin on 04.06.2024.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}


struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkService: NetworkRouting
    
    init(networkService: NetworkRouting = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    // MARK: - Public Methods
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkService.fetch(url: self.mostPopularMoviesUrl){result in
            switch result{
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
            
        }
    }
}
