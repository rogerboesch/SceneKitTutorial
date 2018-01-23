//: [Previous](@previous)
//: # [Part 1 - Building a Terrain](https://rogerboesch.github.io/scenekit/tutorial/games/2016/07/15/scenekit-zerotohero-I.html)
//: ### Please open the Assitant editor Live View to see the result

import Foundation
import UIKit
import SceneKit
import PlaygroundSupport
import RBSceneUIKit

let scene = SCNScene()
//: ## The Game
//:The Game itself it’s implemented in a child class of SCNScene (like written before). Because we create later different levels of the Game, I name this new class TutorialLevel1. The beauty of Swift and SceneKit is the shortness of code you need to realise a Game. But let us take a look now, what we do in that GameLevel class. Mainly it’s the place to create all the Game objects and control them. So implement the gameplay and logic of our 3D shooter Game.
//:At first we have just two Game objects: The terrain and a player class, while the focus of tutorial 1 is the terrain class. But we implement a simple player class already to “ride” over the terrain and extend it later. But first to the terrain class.
//: Terrain class - RBTerrain.swift
//: I have created a basic class called RBTerrain which creates a 3D landscape in any size and style. So you can use it in your Game or customise it the away you want. The usage it’s simple:
let terrain   = RBTerrain(width: 40, length: 40, scale: 16)

//:This creates the terrain class and defines it’s size and scale. The scale is used to define how high the hills of the landscape will gone. Play a little bit around with this parameter to see the effect. The next lines are more interesting:
let generator = RBPerlinNoiseGenerator(seed: nil)
terrain.formula = {(x: Int32, y: Int32) in
    return generator.valueFor(x: x, y: y) / 8.0
}
//:So let’s take a look at them. The main essence is to specify a formula which generates the “hills” of the terrain, because the terrain class itself just creates a grid of meshes, which can have any form. This is done by use closures. If you are not familiar with it, read on this first, because it’s in all Swift related programming important. If you have used Objective-C before, they are called blocks. The approach of the terrain closure it’s simple. The terrain class calls this function and expect for every x,y coordinate of the grid (mesh) a height coordinate. So you can give any value here. It’s also a good place to play at first a little bit with the terrain class. But to build a real terrain with hills we use a method called Perlin noise. It’s an algorithm which comes not from me of course and it’s described in Wikipedia in detail. I have just made a Swift version out of existing C code. But you can also forget that class for a moment and just use it or write your own formula. An interesting approach for example could be to build the terrain based on a image you have… In any way, the terrain class can always keep untouched, just create another formula and assign it. Before we go deeper in the terrain class, i want talk about the other Game component, the Player class.
//: Try with color or image
terrain.create(withImage: #imageLiteral(resourceName: "grass"))
//terrain.create(withColor: .green)
terrain.position = SCNVector3Make(0, 0, 0)
scene.rootNode.addChildNode(terrain)


//: ## The Player class
let player = SCNNode()

//:The player class looks at first a little bit complicated. But at the end it’s easy. It’s (like the terrain class) derived from SCNNode, but contains then some child nodes that supports camera, light and the player node itself. I talk soon about camera and lights but for now keep in mind:
//: ### Always use child nodes in a SCNNode for a game object
//: Why? You will see later, but in easy words, to manipulate them individual from each other. For example when you rotate your player, you don’t want necessary rotate also your camera. With this approach you can separate all actions.

//: ### Create player node
let cubeGeometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.0)
let playerNode = SCNNode(geometry: cubeGeometry)

//: In our example we will show the cube
playerNode.isHidden = false
player.addChildNode(playerNode)

let colorMaterial = SCNMaterial()
cubeGeometry.materials = [colorMaterial]

//: ## Look at Node
let lookAtNode = SCNNode()
lookAtNode.position = SCNVector3Make(0.0, 0.0, 1.0)
player.addChildNode(lookAtNode)

//: Camera Node
//: The camera is an important object in 3D programming. Its essential a virtual object which describes what is currently visible from your 3D world. So it’s like in real world. Depending on where and how you position your camera, you see individual parts of the 3D world. But why I added the camera to the player? In most of the other examples in the net, you see that the camera is attached to the scene. But in the Game we made, I want the camera is always follow the player object and that’s an easy way to do so. So when we move the player, the camera follows. We see then in next tutorial, how to manipulate the camera more, but for now we have what we want.
let cameraNode = SCNNode()
cameraNode.camera = SCNCamera()
cameraNode.position = SCNVector3(x: 0.8, y: 1, z: -0.5)
cameraNode.camera!.zNear = 0.1
cameraNode.camera!.zFar = 200
player.addChildNode(cameraNode)

//: ## Link them
let constraint1 = SCNLookAtConstraint(target: lookAtNode)
constraint1.isGimbalLockEnabled = true
cameraNode.constraints = [constraint1]

//: ## Create a spotlight at the player
let spotLight = SCNLight()
spotLight.type = SCNLight.LightType.spot
spotLight.spotInnerAngle = 40.0
spotLight.spotOuterAngle = 80.0
spotLight.castsShadow = true
spotLight.color = UIColor.white
let spotLightNode = SCNNode()
spotLightNode.light = spotLight
spotLightNode.position = SCNVector3(x: 1.0, y: 5.0, z: -2.0)
player.addChildNode(spotLightNode)

//: ## Link it
let constraint2 = SCNLookAtConstraint(target: player)
constraint2.isGimbalLockEnabled = true
spotLightNode.constraints = [constraint2]

//: ## Create additional omni light
//: To understand lights in detail needs some more deeper know-how, but for us, it’s like in real world. We add some light bulbs to our scene, so we can simulate sun, or add spot lights to show more detail and make shadows. Also the light I have attached to the player because I want that the light is always where the player is. We will talk more on lights after in the next chapters of this series.
let lightNode = SCNNode()
lightNode.light = SCNLight()
lightNode.light!.type = SCNLight.LightType.omni
lightNode.light!.color = UIColor.darkGray
lightNode.position = SCNVector3(x: 0, y: 10.00, z: -2)
player.addChildNode(lightNode)

//: ## Change player position
player.position = SCNVector3(20, 3, 0)

//: ## Add the player view
scene.rootNode.addChildNode(player)

//: ## Let's add teh Scene to our preview
let sceneView = SCNView(frame:  CGRect(x: 0, y: 0, width: 480, height: 480))
sceneView.scene  = scene

//: You can control the camera, but you will lose the tracking
sceneView.allowsCameraControl = true

sceneView.showsStatistics = true
sceneView.backgroundColor = .darkGray
sceneView.debugOptions = .showWireframe

//: ## Here we add our scene to the live view
PlaygroundPage.current.liveView = sceneView

//: ## And add motion
let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 8, duration: 60)
player.runAction(moveAction)


SCNTransaction.begin()
SCNTransaction.animationDuration = 20
cameraNode.position.x = -1.5
SCNTransaction.commit()

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20)) {
    SCNTransaction.begin()
    SCNTransaction.animationDuration = 20
    cameraNode.position.x = 1.5
    SCNTransaction.commit()
    
}
//: [Next](@next)

