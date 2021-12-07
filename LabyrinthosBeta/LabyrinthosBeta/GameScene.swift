//
//  GameScene.swift
//  LabyrinthosBeta_0.0.2
//
//  Created by Sumanth Patil on 11/19/21.
//

import SpriteKit
import GameplayKit
import SwiftUI


struct MazeBlock {
    let xcoord: CGFloat?
    let ycoord: CGFloat?
    
    init(x: CGFloat, y: CGFloat) {
        xcoord = x
        ycoord = y
    }
    let block = SKSpriteNode(imageNamed: "wall")
}

enum CollisionType: UInt32 {
    case character = 1
    case wall = 2
    case coin = 4
    case monster = 8
    case finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var coinTextureAtlas = SKTextureAtlas()
    private var coinTextureArray = [SKTexture]()
    private var charTextureAtlas = SKTextureAtlas()
    private var charTextureArray = [SKTexture]()
    private var monsterTextureAtlas = SKTextureAtlas()
    private var monsterTextureArray = [SKTexture]()
    private var character: SKSpriteNode = SKSpriteNode()
    private var selectedButton: SKSpriteNode?
    private var rightbutton: SKSpriteNode = SKSpriteNode()
    private var leftbutton: SKSpriteNode = SKSpriteNode()
    private var upbutton: SKSpriteNode = SKSpriteNode()
    private var downbutton: SKSpriteNode = SKSpriteNode()
    private var restartbutton: SKSpriteNode = SKSpriteNode()
    private var numCoins: Int = 0
    private var levelNum: Int = 1
    private var joystick = AnalogJoystick(diameters: (substrate: 150, stick: 100))
    
    override func didMove(to view: SKView) {
        self.removeAllChildren()
        self.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        coinTextureAtlas = SKTextureAtlas(named: "images")
        for i in 1...coinTextureAtlas.textureNames.count {
            coinTextureArray.append(SKTexture(imageNamed: "coin\(i).png"))
        }
        charTextureAtlas = SKTextureAtlas(named: "character")
        for i in 1...charTextureAtlas.textureNames.count {
            charTextureArray.append(SKTexture(imageNamed: "character\(i)2.png"))
        }
        monsterTextureAtlas = SKTextureAtlas(named: "monster")
        for i in 1...monsterTextureAtlas.textureNames.count {
            monsterTextureArray.append(SKTexture(imageNamed: "monster\(i).png"))
        }
        setUpJoystick()
        /*rightbutton = SKSpriteNode(imageNamed: "rightarrow")
        rightbutton.position = CGPoint(x: -200, y: -450)
        addChild(rightbutton)
        leftbutton = SKSpriteNode(imageNamed: "leftarrow")
        leftbutton.position = CGPoint(x: -300, y: -450)
        addChild(leftbutton)
        upbutton = SKSpriteNode(imageNamed: "uparrow")
        upbutton.position = CGPoint(x: -250, y: -400)
        addChild(upbutton)
        downbutton = SKSpriteNode(imageNamed: "downarrow")
        downbutton.position = CGPoint(x: -250, y: -500)
        addChild(downbutton)*/
        
        
        let titlebg = SKLabelNode(fontNamed: "Chalkduster")
        titlebg.text = "Lavýrinthos"
        titlebg.fontSize = 60
        titlebg.fontColor = SKColor.blue
        titlebg.position = CGPoint(x: 100 , y: -440)
        addChild(titlebg)
        
        let title = SKLabelNode(fontNamed: "Chalkduster")
        title.text = "Lavýrinthos"
        title.fontSize = 60
        title.fontColor = SKColor.white
        title.position = CGPoint(x: 100 , y: -430)
        addChild(title)
        
        let level = SKLabelNode(fontNamed: "Chalkduster")
        level.text = "Level \(levelNum)"
        level.fontSize = 50
        level.fontColor = SKColor.white
        level.position = CGPoint(x: 100, y: -520)
        addChild(level)
        numCoins = 0
        
        if (levelNum == 1){
            setLevel1()
        }
        else if (levelNum == 2){
            setLevel2()
        }
        else if (levelNum == 3){
            setLevel3()
        }
        else if (levelNum == 4){
            setLevel4()
        }
        else if (levelNum == 5){
            setLevel5()
        }
        else if (levelNum == 6){
            setLevel6()
        }
        else if (levelNum == 7){
            setLevel7()
        }
        else if (levelNum == 8){
            setLevel8()
        }
        else if (levelNum == 9){
            setLevel9()
        }
        else if (levelNum == 10){
            setLevel10()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first  {
            if rightbutton.contains(touch.location(in: self)){
                selectedButton = rightbutton
            }
            else if leftbutton.contains(touch.location(in: self)){
                selectedButton = leftbutton
            }
            else if downbutton.contains(touch.location(in: self)){
                selectedButton = downbutton
            }
            else if upbutton.contains(touch.location(in: self)){
                selectedButton = upbutton
            }
            else if restartbutton.contains(touch.location(in: self)){
                selectedButton = restartbutton
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if selectedButton == rightbutton{
                if (rightbutton.contains(touch.location(in: self))) {
                    moveRight()
                }
            }
            if selectedButton == leftbutton{
                if (leftbutton.contains(touch.location(in: self))) {
                    moveLeft()
                }
            }
            if selectedButton == upbutton{
                if (upbutton.contains(touch.location(in: self))) {
                    moveUp()
                }
            }
            if selectedButton == downbutton{
                if (downbutton.contains(touch.location(in: self))) {
                    moveDown()
                }
            }
            if selectedButton == restartbutton{
                if (restartbutton.contains(touch.location(in: self))) {
                    resetlevel()
                }
            }
        }
        selectedButton = nil
    }
    
    func resetlevel(){
        self.removeAllChildren()
        levelNum = 1
        self.didMove(to: self.view.unsafelyUnwrapped)
    }
    
    func moveRight(){
        character.run(SKAction.moveBy(x: 40, y: 0, duration: 0.5))
    }
    
    func moveLeft(){
        character.run(SKAction.moveBy(x: -40, y: 0, duration: 0.5))
    }
    
    func moveUp(){
        character.run(SKAction.moveBy(x: 0, y: 40, duration: 0.5))
    }
    
    func moveDown(){
        character.run(SKAction.moveBy(x: 0, y: -40, duration: 0.5))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("here")
        if contact.bodyA.node == character && contact.bodyB.node != nil {
            print("\(contact.bodyA.node?.name) collided with \(contact.bodyB.node?.name)")
            print(contact.bodyB.node!)
            playerCollidedWithNode(node: contact.bodyB.node!)
        }
        else if contact.bodyB.node == character && contact.bodyA.node != nil{
            "\(contact.bodyA.node?.name) collided with \(contact.bodyB.node?.name)"
            playerCollidedWithNode(node: contact.bodyA.node!)
        }
    }
    
    func playerCollidedWithNode(node: SKNode){
        if node.name == "coin" {
            numCoins -= 1
            node.removeFromParent()
        }
        else if node.name == "monster" {
            self.removeAllChildren()
            self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
            let gameOver = SKLabelNode(fontNamed: "Chalkduster")
            gameOver.text = "Monster Caught You! Try Again!"
            gameOver.fontSize = 30
            gameOver.fontColor = SKColor.black
            gameOver.position = CGPoint(x: 0 , y: 0)
            addChild(gameOver)
            let seconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.removeAllChildren()
                self.didMove(to: self.view.unsafelyUnwrapped)
            }
            
        }
        else if node.name == "door" && numCoins == 0{
            self.removeAllChildren()
            self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
            let gameOver = SKLabelNode(fontNamed: "Chalkduster")
            var txt = ""
            if (levelNum == 10){
                levelNum = 11
                txt = "YOU WIN!!!"
            }
            else {
                self.levelNum += 1
                txt = "Level \(levelNum)"
            }
            gameOver.text = txt
            gameOver.fontSize = 100
            gameOver.fontColor = SKColor.black
            gameOver.position = CGPoint(x: 0 , y: 0)
            addChild(gameOver)
            let seconds = 2.0
            if (levelNum == 11){
                restartbutton = SKSpriteNode(imageNamed: "resetbutton")
                restartbutton.position = CGPoint(x: 0, y: -300)
                addChild(restartbutton)
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.removeAllChildren()
                    self.didMove(to: self.view.unsafelyUnwrapped)
                }
            }
        }
    }
    
    func setLevel1() {
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.name = "monster"
        monster.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster.position = CGPoint(x: -60, y: -150)
        let moveRight = SKAction.moveBy(x: 160, y: 0, duration: 2.25)
        let moveLeft = SKAction.moveBy(x: -160, y: 0, duration: 2.25)
        let moveDown = SKAction.moveBy(x: 0, y: -120, duration: 2.25)
        let moveUp = SKAction.moveBy(x: 0, y: 120, duration: 2.25)
        monster.run(SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft, moveDown, moveUp])))
        monster.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster.physicsBody?.isDynamic = false
        monster.physicsBody?.collisionBitMask = 0
        monster.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster)
        setMaze()
    }
    
    func setLevel2() {
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.name = "monster"
        monster.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster.position = CGPoint(x: -100, y: -150)
        let moveRight = SKAction.moveBy(x: 240, y: 0, duration: 2.25)
        let moveLeft = SKAction.moveBy(x: -240, y: 0, duration: 2.25)
        monster.run(SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft])))
        monster.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster.physicsBody?.isDynamic = false
        monster.physicsBody?.collisionBitMask = 0
        monster.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster)
        setMaze()
    }
    
    func setLevel3(){
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster1 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster1.physicsBody = SKPhysicsBody(rectangleOf: monster1.size)
        monster1.name = "monster"
        monster1.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster1.position = CGPoint(x: -140, y: -150)
        let moveRight = SKAction.moveBy(x: 400, y: 0, duration: 4.5)
        let moveLeft = SKAction.moveBy(x: -400, y: 0, duration: 4.5)
        monster1.run(SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft])))
        monster1.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster1.physicsBody?.isDynamic = false
        monster1.physicsBody?.collisionBitMask = 0
        monster1.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster1)
        
        var monster2 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster2.physicsBody = SKPhysicsBody(rectangleOf: monster2.size)
        monster2.name = "monster"
        monster2.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster2.position = CGPoint(x: -60, y: -70)
        let moveLeft2 = SKAction.moveBy(x: -200, y: 0, duration: 2.75)
        let moveDown2 = SKAction.moveBy(x: 0, y: -120, duration: 2.25)
        let moveRight2 = SKAction.moveBy(x: 200, y: 0, duration: 2.75)
        let moveUp2 = SKAction.moveBy(x: 0, y: 120, duration: 2.25)
        monster2.run(SKAction.repeatForever(SKAction.sequence([moveLeft2, moveDown2, moveRight2, moveUp2])))
        monster2.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster2.physicsBody?.isDynamic = false
        monster2.physicsBody?.collisionBitMask = 0
        monster2.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster2)
        
        setMaze()
    }
    
    func setLevel4() {
        
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster1 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster1.physicsBody = SKPhysicsBody(rectangleOf: monster1.size)
        monster1.name = "monster"
        monster1.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster1.position = CGPoint(x: -20, y: 50)
        let moveLeft = SKAction.moveBy(x: -200, y: 0, duration: 2.75)
        let moveDown = SKAction.moveBy(x: 0, y: -40, duration: 1)
        let moveRight = SKAction.moveBy(x: 200, y: 0, duration: 2.75)
        let moveUp = SKAction.moveBy(x: 0, y: 40, duration: 1)
        monster1.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveUp, moveRight, moveDown])))
        monster1.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster1.physicsBody?.isDynamic = false
        monster1.physicsBody?.collisionBitMask = 0
        monster1.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster1)
        
        var monster2 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster2.physicsBody = SKPhysicsBody(rectangleOf: monster2.size)
        monster2.name = "monster"
        monster2.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster2.position = CGPoint(x: -60, y: -70)
        let moveLeft2 = SKAction.moveBy(x: -200, y: 0, duration: 2.75)
        let moveDown2 = SKAction.moveBy(x: 0, y: -120, duration: 2.25)
        let moveRight2 = SKAction.moveBy(x: 200, y: 0, duration: 2.75)
        let moveUp2 = SKAction.moveBy(x: 0, y: 120, duration: 2.25)
        monster2.run(SKAction.repeatForever(SKAction.sequence([moveLeft2, moveDown2, moveRight2, moveUp2])))
        monster2.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster2.physicsBody?.isDynamic = false
        monster2.physicsBody?.collisionBitMask = 0
        monster2.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster2)
        
        var monster3 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster3.physicsBody = SKPhysicsBody(rectangleOf: monster3.size)
        monster3.name = "monster"
        monster3.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster3.position = CGPoint(x: 100, y: 10)
        let moveLeft3 = SKAction.moveBy(x: -160, y: 0, duration: 2.75)
        let moveDown3 = SKAction.moveBy(x: 0, y: -160, duration: 2.75)
        let moveRight3 = SKAction.moveBy(x: 160, y: 0, duration: 2.75)
        let moveUp3 = SKAction.moveBy(x: 0, y: 160, duration: 2.75)
        monster3.run(SKAction.repeatForever(SKAction.sequence([moveDown3, moveRight3, moveUp3, moveLeft3])))
        monster3.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster3.physicsBody?.isDynamic = false
        monster3.physicsBody?.collisionBitMask = 0
        monster3.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster3)
        
        setMaze()
    }
    
    func setLevel5() {
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.name = "monster"
        monster.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster.position = CGPoint(x: -180, y: 170)
        let moveDown = SKAction.moveBy(x: 0, y: -280, duration: 3)
        let moveUp = SKAction.moveBy(x: 0, y: 280, duration: 3)
        monster.run(SKAction.repeatForever(SKAction.sequence([moveDown, moveUp])))
        monster.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster.physicsBody?.isDynamic = false
        monster.physicsBody?.collisionBitMask = 0
        monster.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster)
        
        var monster2 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster2.physicsBody = SKPhysicsBody(rectangleOf: monster2.size)
        monster2.name = "monster"
        monster2.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster2.position = CGPoint(x: -100, y: 290)
        let moveLeft2 = SKAction.moveBy(x: -120, y: 0, duration: 2.75)
        let moveDown2 = SKAction.moveBy(x: 0, y: -120, duration: 2.75)
        let moveRight2 = SKAction.moveBy(x: 120, y: 0, duration: 2.75)
        let moveUp2 = SKAction.moveBy(x: 0, y: 120, duration: 2.75)
        monster2.run(SKAction.repeatForever(SKAction.sequence([moveDown2, moveRight2, moveUp2, moveLeft2])))
        monster2.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster2.physicsBody?.isDynamic = false
        monster2.physicsBody?.collisionBitMask = 0
        monster2.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster2)
        
        var monster3 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster3.physicsBody = SKPhysicsBody(rectangleOf: monster3.size)
        monster3.name = "monster"
        monster3.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster3.position = CGPoint(x: -100, y: -110)
        let moveLeft3 = SKAction.moveBy(x: -120, y: 0, duration: 2)
        let moveDown3 = SKAction.moveBy(x: 0, y: -120, duration: 2)
        let moveRight3 = SKAction.moveBy(x: 120, y: 0, duration: 2)
        let moveUp3 = SKAction.moveBy(x: 0, y: 120, duration: 2)
        monster3.run(SKAction.repeatForever(SKAction.sequence([moveDown3, moveRight3, moveUp3, moveLeft3])))
        monster3.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster3.physicsBody?.isDynamic = false
        monster3.physicsBody?.collisionBitMask = 0
        monster3.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster3)
        
        setMaze()
    }
    
    func setLevel6(){
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.name = "monster"
        monster.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster.position = CGPoint(x: -180, y: 250)
        let moveRight = SKAction.moveBy(x: 440, y: 0, duration: 3)
        let moveLeft = SKAction.moveBy(x: -440, y: 0, duration: 3)
        monster.run(SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft])))
        monster.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster.physicsBody?.isDynamic = false
        monster.physicsBody?.collisionBitMask = 0
        monster.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster)
        
        var monster1 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster1.physicsBody = SKPhysicsBody(rectangleOf: monster1.size)
        monster1.name = "monster"
        monster1.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster1.position = CGPoint(x: -180, y: 170)
        let moveDown = SKAction.moveBy(x: 0, y: -280, duration: 2)
        let moveUp = SKAction.moveBy(x: 0, y: 280, duration: 2)
        monster1.run(SKAction.repeatForever(SKAction.sequence([moveDown, moveUp])))
        monster1.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster1.physicsBody?.isDynamic = false
        monster1.physicsBody?.collisionBitMask = 0
        monster1.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster1)
        
        setMaze()
    }
    
    func setLevel7(){
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.name = "monster"
        monster.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster.position = CGPoint(x: -60, y: 410)
        let moveRight = SKAction.moveBy(x: 280, y: 0, duration: 2)
        let moveLeft = SKAction.moveBy(x: -280, y: 0, duration: 2)
        monster.run(SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft])))
        monster.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster.physicsBody?.isDynamic = false
        monster.physicsBody?.collisionBitMask = 0
        monster.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster)
        
        var monster2 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster2.physicsBody = SKPhysicsBody(rectangleOf: monster2.size)
        monster2.name = "monster"
        monster2.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster2.position = CGPoint(x: -140, y: -230)
        let moveRight2 = SKAction.moveBy(x: 200, y: 0, duration: 1)
        let moveLeft2 = SKAction.moveBy(x: -200, y: 0, duration: 1)
        monster2.run(SKAction.repeatForever(SKAction.sequence([moveRight2, moveLeft2])))
        monster2.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster2.physicsBody?.isDynamic = false
        monster2.physicsBody?.collisionBitMask = 0
        monster2.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster2)
        
        var monster1 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster1.physicsBody = SKPhysicsBody(rectangleOf: monster1.size)
        monster1.name = "monster"
        monster1.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster1.position = CGPoint(x: 60, y: 280)
        let moveDown = SKAction.moveBy(x: 0, y: -230, duration: 1.5)
        let moveUp = SKAction.moveBy(x: 0, y: 230, duration: 1.5)
        monster1.run(SKAction.repeatForever(SKAction.sequence([moveDown, moveUp])))
        monster1.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster1.physicsBody?.isDynamic = false
        monster1.physicsBody?.collisionBitMask = 0
        monster1.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster1)
        
        setMaze()
    }
    
    func setLevel8(){
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster2 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster2.physicsBody = SKPhysicsBody(rectangleOf: monster2.size)
        monster2.name = "monster"
        monster2.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster2.position = CGPoint(x: 20, y: 50)
        let moveLeft2 = SKAction.moveBy(x: -200, y: 0, duration: 1.75)
        let moveDown2 = SKAction.moveBy(x: 0, y: -160, duration: 1.5)
        let moveRight2 = SKAction.moveBy(x: 200, y: 0, duration: 1.75)
        let moveUp2 = SKAction.moveBy(x: 0, y: 160, duration: 1.5)
        monster2.run(SKAction.repeatForever(SKAction.sequence([moveLeft2, moveDown2, moveRight2, moveUp2])))
        monster2.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster2.physicsBody?.isDynamic = false
        monster2.physicsBody?.collisionBitMask = 0
        monster2.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster2)
        
        var monster1 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster1.physicsBody = SKPhysicsBody(rectangleOf: monster1.size)
        monster1.name = "monster"
        monster1.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster1.position = CGPoint(x: 100, y: 210)
        let moveDown = SKAction.moveBy(x: 0, y: -160, duration: 2)
        let moveUp = SKAction.moveBy(x: 0, y: 160, duration: 2)
        monster1.run(SKAction.repeatForever(SKAction.sequence([moveDown, moveUp])))
        monster1.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster1.physicsBody?.isDynamic = false
        monster1.physicsBody?.collisionBitMask = 0
        monster1.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster1)
        
        var monster = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.name = "monster"
        monster.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster.position = CGPoint(x: -90, y: -150)
        let moveRight = SKAction.moveBy(x: 280, y: 0, duration: 2)
        let moveLeft = SKAction.moveBy(x: -280, y: 0, duration: 2)
        monster.run(SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft])))
        monster.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster.physicsBody?.isDynamic = false
        monster.physicsBody?.collisionBitMask = 0
        monster.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster)
        
        setMaze()
    }
    
    func setLevel9(){
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.name = "monster"
        monster.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster.position = CGPoint(x: -130, y: 130)
        let moveRight = SKAction.moveBy(x: 280, y: 0, duration: 1.5)
        let moveLeft = SKAction.moveBy(x: -280, y: 0, duration: 1.5)
        monster.run(SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft])))
        monster.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster.physicsBody?.isDynamic = false
        monster.physicsBody?.collisionBitMask = 0
        monster.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster)
        
        var monster1 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster1.physicsBody = SKPhysicsBody(rectangleOf: monster1.size)
        monster1.name = "monster"
        monster1.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster1.position = CGPoint(x: -180, y: 250)
        let moveRight1 = SKAction.moveBy(x: 360, y: 0, duration: 2.5)
        let moveLeft1 = SKAction.moveBy(x: -360, y: 0, duration: 2.5)
        monster1.run(SKAction.repeatForever(SKAction.sequence([moveRight1, moveLeft1])))
        monster1.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster1.physicsBody?.isDynamic = false
        monster1.physicsBody?.collisionBitMask = 0
        monster1.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster1)
        
        var monster2 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster2.physicsBody = SKPhysicsBody(rectangleOf: monster2.size)
        monster2.name = "monster"
        monster2.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster2.position = CGPoint(x: -140, y: -230)
        let moveRight2 = SKAction.moveBy(x: 280, y: 0, duration: 1)
        let moveLeft2 = SKAction.moveBy(x: -280, y: 0, duration: 1)
        monster2.run(SKAction.repeatForever(SKAction.sequence([moveRight2, moveLeft2])))
        monster2.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster2.physicsBody?.isDynamic = false
        monster2.physicsBody?.collisionBitMask = 0
        monster2.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster2)
        
        setMaze()
    }
    
    func setLevel10(){
        character = SKSpriteNode(imageNamed: charTextureAtlas.textureNames[0] as! String)
        character.name = "character"
        character.run(SKAction.repeatForever(SKAction.animate(with: charTextureArray, timePerFrame: 0.3)))
        character.position = CGPoint(x: -300, y: 413)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width-10, height: character.size.height-10))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.linearDamping = 0.5
        character.physicsBody?.categoryBitMask = CollisionType.character.rawValue
        character.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue | CollisionType.monster.rawValue | CollisionType.finish.rawValue
        character.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        addChild(character)
        
        var monster2 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster2.physicsBody = SKPhysicsBody(rectangleOf: monster2.size)
        monster2.name = "monster"
        monster2.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster2.position = CGPoint(x: -260, y: -270)
        let moveLeft2 = SKAction.moveBy(x: -400, y: 0, duration: 3)
        let moveDown2 = SKAction.moveBy(x: 0, y: -680, duration: 3)
        let moveRight2 = SKAction.moveBy(x: 400, y: 0, duration: 3)
        let moveUp2 = SKAction.moveBy(x: 0, y: 680, duration: 3)
        let moveRight22 = SKAction.moveBy(x: 200, y: 0, duration: 3)
        let moveLeft22 = SKAction.moveBy(x: -200, y: 0, duration: 3)
        monster2.run(SKAction.repeatForever(SKAction.sequence([moveUp2, moveRight2, moveLeft2, moveDown2, moveRight22, moveLeft22])))
        monster2.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster2.physicsBody?.isDynamic = false
        monster2.physicsBody?.collisionBitMask = 0
        monster2.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster2)
        
        var monster1 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster1.physicsBody = SKPhysicsBody(rectangleOf: monster1.size)
        monster1.name = "monster"
        monster1.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster1.position = CGPoint(x: 260, y: 320)
        let moveRight1 = SKAction.moveBy(x: 360, y: 0, duration: 2.5)
        let moveLeft1 = SKAction.moveBy(x: -360, y: 0, duration: 2.5)
        let moveUp1 = SKAction.moveBy(x: 0, y: 590, duration: 5)
        let moveDown1 = SKAction.moveBy(x: 0, y: -590, duration: 5)
        monster1.run(SKAction.repeatForever(SKAction.sequence([moveDown1,moveLeft1, moveRight1, moveUp1])))
        monster1.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster1.physicsBody?.isDynamic = false
        monster1.physicsBody?.collisionBitMask = 0
        monster1.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster1)
        
        var monster3 = SKSpriteNode(imageNamed: monsterTextureAtlas.textureNames[0] as! String)
        monster3.physicsBody = SKPhysicsBody(rectangleOf: monster3.size)
        monster3.name = "monster"
        monster3.run(SKAction.repeatForever(SKAction.animate(with: monsterTextureArray, timePerFrame: 0.3)))
        monster3.position = CGPoint(x: -180, y: 330)
        let moveRight3 = SKAction.moveBy(x: 200, y: 0, duration: 2.5)
        let moveLeft3 = SKAction.moveBy(x: -200, y: 0, duration: 2.5)
        let moveUp3 = SKAction.moveBy(x: 0, y: 200, duration: 2.5)
        let moveDown3 = SKAction.moveBy(x: 0, y: -200, duration: 2.5)
        monster3.run(SKAction.repeatForever(SKAction.sequence([moveDown3,moveUp3, moveRight3, moveLeft3])))
        monster3.physicsBody?.categoryBitMask = CollisionType.monster.rawValue
        monster3.physicsBody?.isDynamic = false
        monster3.physicsBody?.collisionBitMask = 0
        monster3.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
        addChild(monster3)
        
        setMaze()
    }
    
    func setUpJoystick() {
        joystick.substrate.color = UIColor(Color.gray)
        joystick.stick.color = UIColor(Color.blue)
        joystick.position = CGPoint(x: -200, y: -450)
        joystick.trackingHandler = { [unowned self] data in
            self.character.position = CGPoint(x: (self.character.position.x + (data.velocity.x * 0.05)), y: (self.character.position.y + (data.velocity.y * 0.05)))
        }
        addChild(joystick)
    }
    func setMaze() {
        if let levPath = Bundle.main.path(forResource: "level\(levelNum)", ofType: "txt"){
            if let levS = try? NSString(contentsOfFile: levPath, encoding: String.Encoding.ascii.rawValue) {
                let lines = levS.components(separatedBy: "\n") as [String]
                for (row, line) in (lines.reversed().enumerated()) {
                    for (col, tilecode) in line.enumerated() {
                        var pos = CGPoint(x: (40 * col) - 300, y: (40 * row) - 350)
                        
                        if (tilecode == "w") {
                            let node = SKSpriteNode(imageNamed: "wall")
                            node.position = pos
                            node.name = "wall"
                            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                            node.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
                            node.physicsBody?.isDynamic = false
                            
                            addChild(node)
                        }
                        else if (tilecode == " ") {
                            let node = SKSpriteNode(imageNamed: "space")
                            node.position = pos
                        }
                        else if (tilecode == "c"){
                            var coin = SKSpriteNode(imageNamed: coinTextureAtlas.textureNames[0] as! String)
                            coin.name = "coin"
                            coin.position = pos
                            coin.run(SKAction.repeatForever(SKAction.animate(with: coinTextureArray, timePerFrame: 0.1)))
                            coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
                            coin.physicsBody?.isDynamic = false
                            coin.physicsBody?.categoryBitMask = CollisionType.coin.rawValue
                            coin.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
                            coin.physicsBody?.collisionBitMask = 0
                            
                            addChild(coin)
                            numCoins += 1
                        }
                        else if (tilecode == "d") {
                            let node = SKSpriteNode(imageNamed: "door")
                            node.position = pos
                            node.name = "door"
                            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                            node.physicsBody?.categoryBitMask = CollisionType.finish.rawValue
                            node.physicsBody?.contactTestBitMask = CollisionType.character.rawValue
                            node.physicsBody?.isDynamic = false
                            
                            addChild(node)
                        }
                    }
                }
            }
        }
    }
}
