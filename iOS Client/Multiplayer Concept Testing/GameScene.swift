//
//  GameScene.swift
//  Multiplayer Concept Testing
//
//  Created by Andreas Amundsen on 02/01/2017.
//  Copyright © 2017 amundsencode. All rights reserved.
//

import SpriteKit
import GameplayKit
import SocketIO

class GameScene: SKScene {
    let socket = SocketIOClient(socketURL: URL(string: "http://192.168.0.107:3000")!, config: [.log(false), .forcePolling(true)])
    
    override func didMove(to view: SKView) {
        addHandlers()
        socket.connect()
    }

    func addHandlers() {
        socket.on("connect") {data, ack in
            print("Socket connected")
        }
        
        socket.on("chat message") {data, ack in
            self.socket.emit("response", "I got your response", data[0] as! SocketData)
        
            //let position: Int? = Int(data[0] as! String)
            let position: NSArray = data[0] as! NSArray
            self.spawnEntity(pos: CGPoint(x: position[0] as! Int, y: position[1] as! Int))
        }
    }
    
    func spawnEntity(pos: CGPoint) {
        print("Position", pos)
        
        let entity = SKShapeNode(circleOfRadius: 15)
        entity.fillColor = SKColor.green
        entity.position = pos
        addChild(entity)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            spawnEntity(pos: position)
            
            let positionList = [position.x, position.y]
            
            socket.emit("chat message", positionList)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
