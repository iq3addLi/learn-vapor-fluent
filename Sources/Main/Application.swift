//
//  Application.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import Vapor

class Application{
    
    private lazy var services = {
        return Services.default()
    }()
    
    init(){
        var services = self.services
        
        // Register routes to the router
        let router = EngineRouter.default()
        
        // Set Routing
        let bookController = BookController()
        let publisherController = PublisherController()
        
        router.get("book", use: bookController.getBook )
        router.post("book", use: bookController.postBook )
        router.put("book", use: bookController.putBook )
        router.delete("book", use: bookController.deleteBook )
        
        router.get("publishers", use: publisherController.getPublishers )
        router.get("publisher", Int.parameter, use: publisherController.getPublisherWithBooks )
        router.post("publisher", use: publisherController.postPublisher )
        router.post("publisher", Int.parameter, "book", use: publisherController.setPublisherWithBook )
        
        // Set router
        services.register(router, as: Router.self)
        
        // Set server config
        let config = NIOServerConfig.default(hostname: "127.0.0.1", port: 8080)
        services.register(config)
        
        // Apply change service
        self.services = services
    }
    
    public func launch() throws{
        let config = Config.default()
        let env = try Environment.detect()
        
        // Create vapor application
        let vaporApp = try Vapor.Application(config: config, environment: env, services: self.services)
        
        // Application launch
        try vaporApp.run()
    }
}
