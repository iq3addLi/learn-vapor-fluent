//
//  DatabaseAssistant.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/24.
//

import Foundation
import FluentMySQL
import Dispatch

class DatabaseAssistant{
    
    lazy var database: MySQLDatabase = {
        let databaseConfig = MySQLDatabaseConfig(hostname: "127.0.0.1", username: "user", password: "password", database: "mysql_test")
        
        return MySQLDatabase(config: databaseConfig)
    }()
    
    lazy var worker: Worker = {
        return MultiThreadedEventLoopGroup(numberOfThreads: 2)
    }()
    
    init(){
        prepareDatabaseTable()
    }
    
    deinit {
        do{
            try worker.syncShutdownGracefully()
        }catch(let error){
            print("Worker shutdown is failed. reason=\(error)")
        }
    }
    
    // create practice
    private func prepareDatabaseTable(){
        
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async { [weak self] in
            defer{
                semaphore.signal()
            }
            guard let `self` = self else{
                return
            }
            
            do{
                let conn = try self.database.newConnection(on: self.worker).wait()
                print("Create connection is success.conn=\(conn)")
                
                // Create table of Books
                try conn.create(table: Book.self)
                    .ifNotExists()
                    .column(for: \Book.id, type: .bigint, .primaryKey)
                    .column(for: \Book.title, type: .text, .notNull)
                    .column(for: \Book.author, type: .text, .notNull)
                    .column(for: \Book.publisherId, type: .bigint)
                    .run()
                    .wait()
                
                // Create table of Publishers
                try conn.create(table: Publisher.self)
                    .ifNotExists()
                    .column(for: \Publisher.id, type: .bigint, .primaryKey)
                    .column(for: \Publisher.name, type: .text, .notNull)
                    .run()
                    .wait()
                
            }catch(let error){
                print("Failed. reason=\(error)")
            }
        }
        semaphore.wait()
    }

    
    // select practice
    func searchBook( title: String?, author: String?, offset: Int?, limit: Int? ) -> [Book]{
        let semaphore = DispatchSemaphore(value: 0)
        var books: [Book] = []
        DispatchQueue.global().async { [weak self] in
            defer{
                semaphore.signal()
            }
            guard let `self` = self else{
                return
            }
            
            do{
                // Create Connection
                let conn = try self.database.newConnection(on: self.worker).wait()
                // Build query
                var query = Book.query(on: conn)
                if let title = title{
                    query = query.filter( \Book.title == title )
                }
                if let author = author{
                    query = query.filter( \Book.author == author)
                }
                switch (offset, limit) {
                case let (.some(o), .some(l)): query = query.range(o..<(o + l))
                case let (.some(o), .none):    query = query.range(o...)
                case let (.none, .some(l)):    query = query.range(...l)
                case (.none, .none): break
                }
                    
                // Execute query
                books = try query.all().wait()
            }catch(let error){
                print("Failed. reason=\(error)")
            }
        }
        semaphore.wait()
        return books
    }
    
    // insert practice
    func insertBook( book: Book ) -> Book?{
        let semaphore = DispatchSemaphore(value: 0)
        var savedBook: Book? = nil
        DispatchQueue.global().async { [weak self] in
            defer{
                semaphore.signal()
            }
            guard let `self` = self else{
                return
            }
            
            do{
                // Create Connection
                let conn = try self.database.newConnection(on: self.worker).wait()
                // Build & Execute query
                savedBook = try Book(identifier: nil, title: book.title, author: book.author ).save(on: conn).wait()
            }catch(let error){
                print("Failed. reason=\(error)")
            }
        }
        semaphore.wait()
        return savedBook
    }
    
    // update practice
    func updateBook( targetId: Int, book: Book ) -> Book?{
        let semaphore = DispatchSemaphore(value: 0)
        var updatedBook: Book? = nil
        DispatchQueue.global().async { [weak self] in
            defer{
                semaphore.signal()
            }
            guard let `self` = self else{
                return
            }
            do{
                // Create Connection
                let connection = try self.database.newConnection(on: self.worker).wait()
                
                // Search book
                let bookOrNil = try Book.query(on: connection)
                    .filter( \.identifier == targetId )
                    .first()
                    .wait()
                guard let bookRow = bookOrNil else { return }
                
                // Update book
                bookRow.title = book.title
                bookRow.author = book.author
                updatedBook = try bookRow.update(on: connection ).wait()

            }catch(let error){
                print("Failed. reason=\(error)")
            }
        }
        semaphore.wait()
        return updatedBook
    }
    
    // delete practice
    func deleteBook( targetId: Int ) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async { [weak self] in
            defer{
                semaphore.signal()
            }
            guard let `self` = self else{
                return
            }
            do{
                // Create Connection
                let connection = try self.database.newConnection(on: self.worker).wait()
                
                // Search book
                let bookOrNil = try Book.query(on: connection)
                    .filter( \.identifier == targetId )
                    .first()
                    .wait()
                guard let bookRow = bookOrNil else { return }
                
                // Delete book
                try bookRow.delete(on: connection ).wait()
                
            }catch(let error){
                print("Failed. reason=\(error)")
            }
        }
        semaphore.wait()
    }
    
}


extension DatabaseAssistant{
    func getPublishers() -> [Publisher]?{
        let semaphore = DispatchSemaphore(value: 0)
        var publisher: [Publisher]? = nil
        DispatchQueue.global().async { [weak self] in
            defer{
                semaphore.signal()
            }
            guard let `self` = self else{
                return
            }
            
            do{
                // Create Connection
                let conn = try self.database.newConnection(on: self.worker).wait()
                // Build and execute query
                publisher = try Publisher.query(on: conn).all().wait()
            }catch(let error){
                print("Failed. reason=\(error)")
            }
        }
        semaphore.wait()
        return publisher
    }
    
    func getPublisherWithBooks(publisherId: Int) -> PublisherWithBooks?{
        let semaphore = DispatchSemaphore(value: 0)
        var publisherWithBooks: PublisherWithBooks? = nil
        DispatchQueue.global().async { [weak self] in
            defer{
                semaphore.signal()
            }
            guard let `self` = self else{
                return
            }
            do{
                // Create Connection
                let connection = try self.database.newConnection(on: self.worker).wait()
                
                // Search book
                let publisherOrNil = try Publisher.query(on: connection)
                    .filter( \.identifier == publisherId )
                    .first()
                    .wait()
                guard let publisher = publisherOrNil else { return }
                
                // Get books at Publisher
                let books = try publisher.books.query(on: connection).all().wait()
                publisherWithBooks = PublisherWithBooks(identifier: publisher.id!, name: publisher.name, books: books)
            }catch(let error){
                print("Failed. reason=\(error)")
            }
        }
        semaphore.wait()
        return publisherWithBooks
    }
    
    func insertPublisher(name: String) -> Publisher?{
        let semaphore = DispatchSemaphore(value: 0)
        var publisher: Publisher? = nil
        DispatchQueue.global().async { [weak self] in
            defer{
                semaphore.signal()
            }
            guard let `self` = self else{
                return
            }
            
            do{
                // Create Connection
                let conn = try self.database.newConnection(on: self.worker).wait()
                // Build & Execute query
                publisher = try Publisher(name: name).save(on: conn).wait()
            }catch(let error){
                print("Failed. reason=\(error)")
            }
        }
        semaphore.wait()
        return publisher
    }
    
    func setBook(for publisherId: Int, bookId: Int) -> Book?{
        let semaphore = DispatchSemaphore(value: 0)
        var book: Book? = nil
        DispatchQueue.global().async { [weak self] in
            defer{
                semaphore.signal()
            }
            guard let `self` = self else{
                return
            }
            do{
                // Create Connection
                let connection = try self.database.newConnection(on: self.worker).wait()
                
                // Search book
                let bookOrNil = try Book.query(on: connection)
                    .filter( \.identifier == bookId )
                    .first()
                    .wait()
                guard let bookRow = bookOrNil else { return }
                
                // Update book
                bookRow.publisherId = publisherId
                book = try bookRow.update(on: connection ).wait()
                
            }catch(let error){
                print("Failed. reason=\(error)")
            }
        }
        semaphore.wait()
        return book
    }
}
