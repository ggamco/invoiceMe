//
//  IME_IntroAnimacionVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 2/2/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import Parse

class IME_IntroAnimacionVC: UIViewController {

    //MARK: - Variables LOCALES
    var viewAnimator: UIViewPropertyAnimator!
    var desbloqueoGesto = Timer()
    
    let circleShape = CAShapeLayer()
    
    //MARK: - IBOutlets
    @IBOutlet weak var myLogoIntro: UIImageView!
    
    
    //MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Iniciamos la vista con el Logo reducido a escala 0.0
        self.myLogoIntro.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        //Añadimos el circulo a la vista
        view.layer.addSublayer(circleShape)
        
        //Arrancamos la primera animación con un desfase de 1 segundo
        self.desbloqueoGesto = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.animacionPunto), userInfo: nil, repeats: false)
    
    }
    
    //MARK: - Funciones Propia
    @objc func animacionPunto(){
        
        //añadimos un color al circulo
        circleShape.fillColor = UIColor.white.cgColor
        
        //marcamos el punto central del circulo
        let center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        //creamos el path de inicio
        let startPath = UIBezierPath(arcCenter: center, radius: 0.0, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        //creamos el path final
        let endPath = UIBezierPath(arcCenter: center, radius: 15.0, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        //añadimos el path inicial
        circleShape.path = startPath
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endPath
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeBoth
        //animation.repeatCount = 2.0
        animation.isRemovedOnCompletion = false
        
        circleShape.add(animation, forKey: animation.keyPath)
        
        //Cargamos la animacion del logo con un desfase de 2.5 segundos
        self.desbloqueoGesto = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.muestraAutomatico), userInfo: nil, repeats: false)
        
    }
    
    @objc func muestraAutomatico(){
        //Preparamos la animación del logo, lo haremos aumentar de escala
        let logoAnimation = UIViewPropertyAnimator(duration: 0.20, curve: .easeInOut) {
            self.myLogoIntro.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            //Cargamos la animación que hará desaparecer el circulo a la vez que se ejecuta la transformación del logo
            self.desbloqueoGesto = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.desaparecer), userInfo: nil, repeats: false)
        }
        logoAnimation.startAnimation()
        
    }
    
    @objc func desaparecer(){
        //Hacemos desaparecer el circulo usando su opacidad
        let logoAnimation = UIViewPropertyAnimator(duration: 0.05, curve: .easeOut) {
            self.circleShape.opacity = 0
            //Programamos el arranque de la app para asegurar que el logo se muestra durante 3 segundos
            self.desbloqueoGesto = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.comienzoApp), userInfo: nil, repeats: false)
        }
        logoAnimation.startAnimation()
        
    }
    
    @objc func comienzoApp(){
        // TODO: - Logica de mostrar tutorial, paso por registro o login.
        if CUSTOM_PREFS.string(forKey: CONSTANTES.PREFS.FIRST_TIME) != nil {
            //El usuario ya habia iniciado por primera vez la aplicación y ya ha visualizado el tutorial
            if CUSTOM_PREFS.string(forKey: CONSTANTES.PREFS.REGISTERED) != nil {
                //el usuario esta registrado, preguntamos si esta logueado
                if PFUser.current() != nil {
                    // El usuario esta logueado, lo enviamos a la ventana principal
                    let principalVC = storyboard?.instantiateViewController(withIdentifier: "PrimeraVentanaTBC") as! IME_PrimeraVentanaTBC
                    let navController = UINavigationController(rootViewController: principalVC)
                    navController.modalTransitionStyle = .crossDissolve
                    self.present(navController, animated:true, completion: nil)
                } else {
                    //El usuario no esta logueado, le pedimos login
                    let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginTVC") as! IME_LoginTVC
                    let navController = UINavigationController(rootViewController: loginVC)
                    navController.modalTransitionStyle = .crossDissolve
                    self.present(navController, animated:true, completion: nil)
                }
            } else {
                //El usuario no esta registrado
                let registroVC = storyboard?.instantiateViewController(withIdentifier: "RegistroTVC") as! IME_RegistroTVC
                let navController = UINavigationController(rootViewController: registroVC)
                navController.modalTransitionStyle = .crossDissolve
                self.present(navController, animated:true, completion: nil)
            }
        } else {
            //Es la primera ejecución de la aplicacion, mostramos el tutorial
            let tutorialVC = storyboard?.instantiateViewController(withIdentifier: "TutorialVC") as! IME_TutorialVC
            tutorialVC.modalTransitionStyle = .crossDissolve
            present(tutorialVC, animated: true, completion: nil)
        }
     
    }
}
