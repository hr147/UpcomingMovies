//
//  GenreUseCaseProtocol.swift
//  UpcomingMoviesDomain
//
//  Created by Alonso on 10/27/19.
//  Copyright © 2019 Alonso. All rights reserved.
//

import Foundation

public protocol GenreUseCaseProtocol {
    
    var didUpdateGenre: (() -> Void)? { get set }
    
    func find(with id: Int) -> Genre?
    func findAll() -> [Genre]
    func saveGenres(_ genres: [Genre])
    
    func fetchAll(completion: Result<Genre, Error>)
    
}