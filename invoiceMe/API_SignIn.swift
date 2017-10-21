//
//  API_SignIn.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 24/9/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import Foundation
import Parse
import PKHUD

enum CustomError : Error {
    case campoVacio
    case emailInvalido
    case usuarioExistente
    case ingresoUsuarioError
}

class APISignIn {
    var username : String?
    var password : String?
    
    init(p_username: String, p_password: String) {
        self.username = p_username
        self.password = p_password
    }
    
    func signUser() throws {
        guard camposVacios() else {
            throw CustomError.campoVacio
        }
        
        guard validarDatosUsuarios() else {
            throw CustomError.ingresoUsuarioError
        }
    }
    
    func camposVacios() -> Bool {
        return !(username?.isEmpty)! && !(password?.isEmpty)!
    }
    
    func validarDatosUsuarios() -> Bool {
        do {
            try PFUser.logIn(withUsername: username!, password: password!)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return PFUser.current() != nil
    }
}

extension CustomError : LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .campoVacio:
            return "Ingrese todos los campos"
        case .emailInvalido:
            return "Correo invalido"
        case .usuarioExistente:
            return "El usuario ya existe"
        case .ingresoUsuarioError:
            return "Datos incorrectos"
        }
    }
}


