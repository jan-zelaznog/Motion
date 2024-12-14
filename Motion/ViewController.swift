//
//  ViewController.swift
//  Motion
//
//  Created by Ángel González on 14/12/24.
//

import UIKit
import SVGKit
import CoreMotion

class ViewController: UIViewController {

    var objetivo: UIImageView!
    var moviendo: UIImageView!
    var refX : Double = 0
    var refY : Double = 0
    var admMovimiento : CMMotionManager!
    // agregamos la lógica de "gamefication"
    var cronometro:UILabel!
    var segundos = 0
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let W = self.view.bounds.width / 6
        let H = self.view.bounds.height / 6
        
        objetivo = UIImageView(frame: CGRect(x:0, y:0, width:W, height:H))
        objetivo.center = self.view.center
        objetivo.image = SVGKImage(named: "beer-mug-empty").uiImage
        self.view.addSubview(objetivo)
        
        moviendo = UIImageView(image: UIImage(named: "beer"))
        moviendo.frame = CGRect(x:0, y:0, width:W, height:H)
        self.view.addSubview(moviendo)
        
        refX = trunc(objetivo.frame.minX)
        refY = trunc(objetivo.frame.minY)
        iniciarJuego()
        cronometro = UILabel(frame:CGRect(x:view.frame.width - W, y:45, width:W, height:W))
        cronometro.textColor = .red
        self.view.addSubview(cronometro)
    }

    func iniciarJuego() {
        moviendo.frame.origin = CGPoint(x:0, y:0)
        segundos = 0
        timer = Timer.scheduledTimer(withTimeInterval:1.0, repeats:true, block: { Timer in
            self.segundos += 1
            self.cronometro.text = "\(self.segundos)"
        })
        iniciaAcelerometro()
    }
    
    func iniciaAcelerometro() {
        let incremento = 25.0
        admMovimiento = CMMotionManager()
        admMovimiento.accelerometerUpdateInterval = 0.1
        admMovimiento.startAccelerometerUpdates(to: OperationQueue.main) { data, error in
            var rect = self.moviendo.frame
            // obtenemos la nueva posicion x/y de la vista y mutiplicamos por el factor de desplazamiento para que sea mas visible que la subview se mueve
            let movetoX  = rect.origin.x + CGFloat((data?.acceleration.x)! * incremento)
            let movetoY  = rect.origin.y - CGFloat((data?.acceleration.y)! * incremento)
            // calculamos que no se vaya a salir de la pantalla
            let maxX = self.view.frame.width - rect.width
            let maxY = self.view.frame.height - rect.height
            if movetoX > 0 && movetoX < maxX {
                rect.origin.x = movetoX
            }
            if ( movetoY > 0 && movetoY < maxY ) {
                rect.origin.y = movetoY
            }
            // ajutamos la nueva posicion de la vista
            self.moviendo.frame = rect
            // comprobamos si ya quedó en la posiciòn deseada (sobre la vista objetivo)
            if ((trunc(rect.minX) == self.refX ||
                 trunc(rect.minX) == self.refX - 1 ||
                 trunc(rect.minX) == self.refX + 1) &&
                (trunc(rect.minY) == self.refY ||
                 trunc(rect.minY) == self.refY - 1 ||
                 trunc(rect.minY) == self.refY + 1)) {
                self.admMovimiento.stopAccelerometerUpdates()
                self.terminarJuego()
            }
        }
    }
    
    func terminarJuego() {
        timer.invalidate()
        // TODO: - Compartir a otras apps
        
        // TODO: - Preguntar si quiere volver a jugar
        
    }
}

