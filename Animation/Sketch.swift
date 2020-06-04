import Foundation
import CanvasGraphics

class Sketch : NSObject {
    
    // NOTE: Every sketch must contain an object of type Canvas named 'canvas'
    //       Therefore, the line immediately below must always be present.
    let canvas: Canvas
    
    // L-system definitions
    let coniferousTree: LindenmayerSystem
    let theSun: LindenmayerSystem
    let shrub: LindenmayerSystem
    
    
    // This function runs once
    override init() {
        
        // Create canvas object – specify size
        canvas = Canvas(width: 500, height: 500)
        
        // Draw slowly
        //canvas.framesPerSecond = 1
        
        // Define a stochastic system that resembles a coniferous tree
        coniferousTree = LindenmayerSystem(axiom: "SF",
                                           angle: 20,
                                           rules: ["F": [
                                                        RuleSet(odds: 1, successorText: "3F[++1F[X]][+2F][-4F][--5F[X]]6F"),
                                                        RuleSet(odds: 1, successorText: "3F[+1F][+2F][-4F]5F"),
                                                        RuleSet(odds: 1, successorText: "3F[+1F][-2F][--6F]4F"),
                                                        ],
                                                   "X": [
                                                        RuleSet(odds: 1, successorText: "X")
                                                        ]
                                                  ],
                                           colors: ["1": Color(hue: 120, saturation: 100, brightness: 61, alpha: 100),
                                                    "2": Color(hue: 134, saturation: 97, brightness: 46, alpha: 100),
                                                    "3": Color(hue: 145, saturation: 87, brightness: 8, alpha: 100),
                                                    "4": Color(hue: 135, saturation: 84, brightness: 41, alpha: 100),
                                                    "5": Color(hue: 116, saturation: 26, brightness: 100, alpha: 100),
                                                    "6": Color(hue: 161, saturation: 71, brightness: 53, alpha: 100)
                                                   ],
                                           generations: 5)
        
        theSun = LindenmayerSystem(axiom: "S1[-F]++[F]++[F][--F]++[F]++[F][--F]++[F]++[F]",
                                                    angle: 30,
                                                    rules: ["F": [
                                                                 RuleSet(odds: 1, successorText: "[F+F-FF+F-F]")
                                                                 ]
                                                           ],
                                                    colors: [
                                                             "1": Color(hue: 56 , saturation: 100, brightness: 100, alpha: 100)
                                                            ],
                                                    generations: 3)
        
        shrub = LindenmayerSystem(axiom: "SX",
                    angle: 20,
                    rules: ["X": [
                                 RuleSet(odds: 1, successorText: "1[[2-X][2-X+FX+FX][2+X]1-FX[2-XF]1F[2-X][2-X]]"),
                                 RuleSet(odds: 1, successorText: "1[[2+X][2+X-FX-FX][2-X]1+FX[2+XF]1F[2+X][2+X]]"),
                                 RuleSet(odds: 1, successorText: "1[[2-X][2-X+FXX+FX][2-FXFX]1-FX[2-XF][2-X]]")
                                 ],
                            
                            "F":[
                                RuleSet(odds: 1, successorText: "FFF")
                                ]
                           ],
                    colors: [
                             "1": Color(hue: 131 , saturation: 100, brightness: 25, alpha: 100),
                             "2": Color(hue: 46, saturation: 100, brightness: 96, alpha: 100),
                             "3": Color(hue: 37, saturation: 52, brightness: 151, alpha: 100)
                             
                            ],
                    generations: 4)
        
        
        // Create a gradient sky background, blue to white as vertical location increases
        for y in 300...500 {
            
            // Set the line saturation to progressively get closer to white
            let currentSaturation = 100.0 - Float(y - 300) / 2
            // DEBUG: Uncomment line below to see how this value changes
            print("currentSaturation is: \(currentSaturation)")
            canvas.lineColor = Color(hue: 200, saturation: currentSaturation, brightness: 90.0, alpha: 100.0)
            
            // Draw a horizontal line at this vertical location
            canvas.drawLine(from: Point(x: 0, y: y), to: Point(x: canvas.width, y: y))
            
        }
        
        // Create a gradient ground background, brown to darker brown as vertical location increases
        // NOTE: Can use the HSV/HSB sliders (third from top) at this site for help picking colours:
        //       http://colorizer.org
        
        //draw sun
        var sun = VisualizedLindenmayerSystem(system: theSun, length: 94, initialDirection: 45, reduction: 3, pointToStartRenderingFrom: Point(x: 90, y: 430), drawnOn: canvas)
        sun.renderFullSystem()
        
        
        
        for y in 0...300 {
            
            // Set the line brightness to progressively get closer to black
            let currentBrightness = 50.0 - Float(y) / 30.0 * 3.0
            // DEBUG: Uncomment line below to see how this value changes
            print("currentBrightness is \(currentBrightness)")
            canvas.lineColor = Color(hue: 25.0, saturation: 68.0, brightness: currentBrightness, alpha: 100.0)
            
            // Draw a horizontal line at this vertical location
            canvas.drawLine(from: Point(x: 0, y: y), to: Point(x: canvas.width, y: y))
            
        }
        
        //Grass
        var groundVertices: [Point] = []
        canvas.fillColor = Color(hue: 120, saturation: 60, brightness: 40, alpha: 100)
        groundVertices.append(Point(x:0, y:300))
        groundVertices.append(Point(x:200, y:300))
        groundVertices.append(Point(x:500, y:300))
        groundVertices.append(Point(x:250, y:240))
        groundVertices.append(Point(x:0, y:100))
        

        
        
        canvas.drawCustomShape(with: groundVertices)
        
//        for y in 0...300 {
//            let currentBrightness = 50.0 - Float(y) / 30.0 * 3.0
//            canvas.lineColor = Color(hue: 120, saturation: 60, brightness: currentBrightness, alpha: 100)
//            canvas.drawLine(from: Point(x: canvas.width/2, y: y), to: Point(x: canvas.width, y: y))
//        }
        
        // Create 9 trees, drawn from their tops along a quadratic path
        
        // Define the vertex of the parabolic path (top right of canvas)
        let vertex = Point(x: 450, y: 350)
        
        // Define some other point on the parabolic path (in this case, closer to bottom left)
        let anotherPointOnParabola = Point(x: 100, y: 225)
        
        // Work out the "a" value for the parabola (vertical stretch)
        let a = 6/13 * (anotherPointOnParabola.y - vertex.y) / pow(anotherPointOnParabola.x - vertex.x, 2)
        
        // Iterate to create 4 trees
        for i in 1...9 {

            // Use a quadratic relationship to define the vertical starting point for the top of each tree
            // (trees grow down from starting point)
            let x = CGFloat(i - 1) * 50.0 + 20            // This defines "spread" of the trees along the quadratic path
            let y = a * pow(x - vertex.x, 2) + vertex.y    // Determine vertical position using y = a(x-h)^2 + k
            
            
            // DEBUG: To help see where starting points are
            print("Starting point for tree is... x: \(x), y: \(y)")
            
            // Define the length of the tree's initial stroke
            let length = 27.0 - Double(y) / 16.0            // Piggyback on quadratic change in y values to set length
            print("Length of line for system is: \(length)")
            
            // Generate the tree
            var aTree = VisualizedLindenmayerSystem(system: coniferousTree,
                                                    length: length,
                                                    initialDirection: 270,
                                                    reduction: 1.25,
                                                    pointToStartRenderingFrom: Point(x: x, y: y),
                                                    drawnOn: canvas)
            
            // Render this tree
            aTree.renderFullSystem()
            
        }
        
        // Iterate to create trees
        
//        for i in 1...3 {
//
//            // Use a quadratic relationship to define the vertical starting point for the top of each tree
//            // (trees grow down from starting point)
//            let x = 300 + i * 50                                  // This defines "spread" of the trees along the quadratic path
//            let y = 150 + i * 50    // Determine vertical position using y = a(x-h)^2 + k
//
//
//            // DEBUG: To help see where starting points are
//            print("Starting point for tree is... x: \(x), y: \(y)")
//
//            // Define the length of the tree's initial stroke
//            let length = 27.0 - Double(y) / 16.0            // Piggyback on quadratic change in y values to set length
//            print("Length of line for system is: \(length)")
//
//            // Generate the tree
//            var aTree = VisualizedLindenmayerSystem(system: coniferousTree,
//                                                    length: length,
//                                                    initialDirection: 270,
//                                                    reduction: 1.25,
//                                                    pointToStartRenderingFrom: Point(x: x, y: y),
//                                                    drawnOn: canvas)
//
//            // Render this tree
//            aTree.renderFullSystem()
//
//
//        }
        
        for i in 0...15 {
            var theShrub = VisualizedLindenmayerSystem(system: shrub, length: 5, initialDirection: 90, reduction: 1.6, pointToStartRenderingFrom: Point(x: i * canvas.width/16, y: 5 ), drawnOn: canvas)
            theShrub.renderFullSystem()
            if i > 1 {
                var secondShrub = VisualizedLindenmayerSystem(system: shrub, length: 4, initialDirection: 90, reduction: 1.6, pointToStartRenderingFrom: Point(x: i * canvas.width/16, y: 35 ), drawnOn: canvas)
                secondShrub.renderFullSystem()
            }
            if i > 2 {
                var thirdShrub = VisualizedLindenmayerSystem(system: shrub, length: 3, initialDirection: 90, reduction: 1.6, pointToStartRenderingFrom: Point(x: i * canvas.width/16, y: 55 + i), drawnOn: canvas)
                thirdShrub.renderFullSystem()
            }
            if i > 3 {
                var number = Double.random(in: 2...4)
                var fourthShrub = VisualizedLindenmayerSystem(system: shrub, length: number, initialDirection: 90, reduction: 1.6, pointToStartRenderingFrom: Point(x: i * canvas.width/16, y: 75 + i), drawnOn: canvas)
                fourthShrub.renderFullSystem()
            }
        }
        
 
       
        
        
        
    }
    
    // This function runs repeatedly, forever, to create the animated effect
    func draw() {
        
        // Nothing to animate, so nothing in this function
        
    }
    
}
