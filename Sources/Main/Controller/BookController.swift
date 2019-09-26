//
//  BookController.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import Vapor

class BookController{
    
    lazy var database = {
        return DatabaseAssistant()
    }()
    
    func getBook(_ request: Request) throws -> [Book] {
        let offset = request.query[ Int.self, at: "offset" ]
        let limit = request.query[ Int.self, at: "limit" ]
        let author = request.query[ String.self, at: "author" ]
        let title = request.query[ String.self, at: "title" ]
        
        return self.database.searchBook(title: title, author: author, offset: offset, limit: limit )
    }
    
    func postBook(_ request: Request) throws -> Future<Response> {

        return try request.content.decode(json: Book.self, using: JSONDecoder()).map { (book) in
            
            if let insertedBook = self.database.insertBook(book: book) {
                return request.response( insertedBook , as: .json)
            }else{
                let response = request.response( ServerError( reason: "Request body is unexpected.") , as: .json)
                response.http.status = .badRequest
                return response
            }
        }
    }
    
    func putBook(_ request: Request) throws -> Future<Response> {
        // Found id in query?
        guard let id = request.query[ Int.self, at: "id" ] else{
            return request.response( ServerError( reason: "The id is necessary in query.") , as: .json)
                .encode(status: .badRequest, for: request)
        }
        
        // Requestbody is parsable?
        return try request.content.decode(json: Book.self, using: JSONDecoder()).map { (book) in
            
            if let updatedBook = self.database.updateBook(targetId: id, book: book) {
                return request.response( updatedBook , as: .json)
            }else{
                let response = request.response( ServerError( reason: "Update is failed.") , as: .json)
                response.http.status = .badRequest
                return response
            }
        }
    }
    
    func deleteBook(_ request: Request) throws -> Future<Response> {
        // Found id in query?
        guard let id = request.query[ Int.self, at: "id" ] else{
            return request.response( ServerError( reason: "The id is necessary in query.") , as: .json)
                .encode(status: .badRequest, for: request)
        }
        
        // Delete row
        self.database.deleteBook(targetId: id)
        
        return request.response( GeneralInfomation( "Delete order is accepted.") , as: .json)
            .encode(status: .ok, for: request)
    }
    
}
