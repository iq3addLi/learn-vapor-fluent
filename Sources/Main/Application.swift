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
        let controller = BookController()
        
        router.get("test", use: controller.testConnect )
        router.get("book", use: controller.getBook )
        router.post("book", use: controller.postBook )
        router.put("book", use: controller.putBook )
        router.delete("book", use: controller.deleteBook )
        
//        router.get("error") { request -> Response /* It is necessary to tell the compiler the return type */ in
//            let response = Response(http: HTTPResponse(status: .badRequest), using: request)
//            let myContent = Book(title: "Three kingdom", author: "Mitsuteru yokoyama")
//            try response.content.encode(myContent, as: MediaType.json)
//            return response
//        }
//
//        router.get("/notfound") { request -> Response in
//            let response = request.response(ServerError( reason: "Not found is not found."), as: .json)
//            let myContent = Book(title: "Three kingdom", author: "Mitsuteru yokoyama")
//            try response.content.encode(myContent, as: .json)
//            response.http.status = .notFound
//
//            return response
//        }
//
//        router.on(.GET, at: "always", use: controller.alwaysError )
        
        // Set router
        services.register(router, as: Router.self)
        
        // Set server config
        let serverConfiure = NIOServerConfig.default(hostname: "127.0.0.1", port: 8080)
        services.register(serverConfiure)
        
        // Apply change service
        self.services = services
    }
    
    public func launch() throws{
        let config = Config.default()
        let env = try Environment.detect()
        
        // Create vapor application
        let application = try Vapor.Application(config: config, environment: env, services: self.services)
        
        // Application launch
        try application.run()
    }
}
