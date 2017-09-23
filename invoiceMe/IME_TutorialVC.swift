//
//  IME_TutorialVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 16/9/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_TutorialVC: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let anchoImagen = self.view.frame.width
        let altoImagen = self.view.frame.height
        for c_imagen in 0 ..< 8 {
            let name = String(format: "FOTO_%d", c_imagen)
            let image = UIImage(named: name)
            let imagenes = UIImageView(image: image)
            imagenes.frame = CGRect(x: CGFloat(c_imagen) * anchoImagen,
                                    y: 0,
                                    width: anchoImagen,
                                    height: altoImagen)
            myScrollView.addSubview(imagenes as UIImageView)
            
        }
        myScrollView.delegate = self
        myScrollView.contentSize = CGSize(width: 7 * anchoImagen, height: altoImagen)
        myScrollView.isPagingEnabled = true
        myPageControl.numberOfPages = 7
        myPageControl.currentPage = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        CUSTOM_PREFS.setValue("NO", forKey: CONSTANTES.PREFS.FIRST_TIME)
    }

}//FIN DE LA CLASE

extension IME_TutorialVC : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pagina = myScrollView.contentOffset.x / myScrollView.frame.width
        myPageControl.currentPage = Int(pagina)
    }
    
}
