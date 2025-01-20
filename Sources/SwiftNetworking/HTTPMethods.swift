//
//  HTTPMethods.swift
//  SwiftNetworking
//
//  Created by Saurabh Verma on 14/01/25.
//

import Foundation

public enum HTTPMethods: String {
    /// HTTP method GET is used to request a specified resource, it's only used to retrieve some data. GET is
    /// expected to be a safe operation, means it will not change state of any resource on server.
    case GET
    
    /// HTTP method HEAD is used to get metadata associated with a resource on server. Calling HEAD will
    /// return all headers associated with a resource at given URL, but it will actually not return the resource
    /// itself unlike GET method.
    /// HEAD can be used to
    /// - Check size of resource on server
    /// - If resource is present or not on server
    /// - The last modified time/date of the resource
    /// - Validity of a cached resource
    case HEAD
    
    /// HTTP method POST submits an entity to a specified resource, this may lead to change in state for the
    /// server, because of this POST operation is not considered a safe operation.
    case POST
    
    /// HTTP method PUT completely replaces the resource identified by URL. Resource if present is replaced
    /// completely else if not present then it gets created.
    case PUT
    
    
    case DELETE
    
    /// HTTP method CONNECT is used to create a tunnel with server, which eventually could be used to forward
    /// data in both directions.
    case CONNECT
    
    /// HTTP method OPTIONS gives the methods supported and allowed by server. The server does not have
    /// to support every HTTP method for every resource it manages.
    case OPTIONS
    
    /// HTTP method TRACE often gives a content which is just an echo back from the server of the various
    /// request headers that the client sent.
    case TRACE
    
    /// HTTP method PATCH helps to update a resource by sending a small payload rather than a complete
    /// resource representation to server which could be a costly operation if the resource is huge and PUT
    /// is used.
    case PATCH
}

