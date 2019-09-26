//
//  PublisherController.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/26.
//

import Vapor

class PublisherController{
    
    lazy var database = {
        return DatabaseAssistant()
    }()
    
    func getPublishers(_ request: Request) throws -> Future<Response> {
        
        guard let publishers = database.getPublishers() else{
            return request.response( ServerError(reason: "Get publisher is failed.") , as: .json)
                .encode(status: .internalServerError, for: request)
        }
        
        return request.response( publishers , as: .json)
            .encode(status: .ok, for: request)
    }
    
    func getPublisherWithBooks(_ request: Request) throws -> Future<Response> {
        // Get perameter
        let publisherId = try request.parameters.next(Int.self)
        
        guard let publisherWithBooks = database.getPublisherWithBooks(publisherId: publisherId) else{
            return request.response( ServerError(reason: "Get publisher with books is failed.") , as: .json)
                .encode(status: .internalServerError, for: request)
        }
        
        return request.response( publisherWithBooks , as: .json)
            .encode(status: .ok, for: request)
    }
    
    func postPublisher(_ request: Request) throws -> Future<Response> {
        
        return try request.content.decode(json: Publisher.self, using: JSONDecoder()).map { publisher in
            
            if let insertedPublisher = self.database.insertPublisher(name: publisher.name) {
                return request.response( insertedPublisher , as: .json)
            }else{
                let response = request.response( ServerError( reason: "Request body is unexpected.") , as: .json)
                response.http.status = .badRequest
                return response
            }
        }
    }
    
    func setPublisherWithBook(_ request: Request) throws -> Future<Response> {
        
        // Get perameter
        let publisherId = try request.parameters.next(Int.self)
        
        guard let bookId = request.query[ Int.self, at: "id" ] else{
            return request.response( ServerError(reason: "Query parameter 'id' is nessesary.") , as: .json)
                .encode(status: .badRequest, for: request)
        }
        guard let pubWithBooks = database.setBook(for: publisherId, bookId: bookId) else{
            return request.response( ServerError(reason: "Set book to publisher is failed.") , as: .json)
                .encode(status: .internalServerError, for: request)
        }
        
        return request.response( pubWithBooks , as: .json)
            .encode(status: .ok, for: request)
    }

}
