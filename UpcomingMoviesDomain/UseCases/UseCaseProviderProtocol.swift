//
//  UseCaseProviderProtocol.swift
//  UpcomingMoviesDomain
//
//  Created by Alonso on 10/26/19.
//  Copyright © 2019 Alonso. All rights reserved.
//

import Foundation

public protocol UseCaseProviderProtocol {
    
    func genreUseCase() -> GenreUseCaseProtocol
    func movieVisitUseCase() -> MovieVisitUseCaseProtocol
    func movieSearchUseCase() -> MovieSearchUseCaseProtocol
    func userUseCase() -> UserUseCaseProtocol
    
}