import XCTest
@testable import Cosmos

class CosmosLayersTests: XCTestCase {
  // MARK: - Position star layers
  
  func testPositionStarLayers() {
    let layerOne = CALayer()
    layerOne.bounds = CGRect(origin: CGPoint(), size: CGSize(width: 20, height: 2))
      
    let layerTwo = CALayer()
    layerTwo.bounds = CGRect(origin: CGPoint(), size: CGSize(width: 20, height: 2))
    
    let layerThree = CALayer()
    layerThree.bounds = CGRect(origin: CGPoint(), size: CGSize(width: 20, height: 2))
    
    let layers = [layerOne, layerTwo, layerThree]
      
    CosmosLayers.positionStarLayers(layers, starMargin: 5)
    
    XCTAssertEqual(0, layerOne.position.x)
    XCTAssertEqual(25, layerTwo.position.x)
    XCTAssertEqual(50, layerThree.position.x)
  }
  
  // MARK: - Create partially filled star
  
  func testCreatePartiallyFilledStar_verifyTextAndStyles() {
    var settings = CosmosSettings()
    settings.starSize = 19
    settings.colorEmpty = UIColor.purpleColor()
    settings.borderColorEmpty = UIColor.blueColor()
    settings.borderWidthEmpty = 1.31
    settings.colorFilled = UIColor.redColor()

    let result = CosmosLayers.createPartialStar(0.8, settings: settings)
    
    XCTAssertEqual(2, result.sublayers!.count)
    
    // Check layer
    // ------------------
    
    XCTAssertEqual(19, result.bounds.size.width)
    XCTAssertEqual(19, result.bounds.size.height)
    
    // Check empty container layer
    // ------------------
    
    let emptyContainerLayer = result.sublayers![0] as CALayer
    XCTAssertEqual(19, emptyContainerLayer.bounds.size.width)
    XCTAssertEqual(19, emptyContainerLayer.bounds.size.height)

    // Check empty shape layer
    // ------------------
    
    let emptyShapeLayer = emptyContainerLayer.sublayers![0] as! CAShapeLayer
    XCTAssertEqual(UIColor.purpleColor(), UIColor(CGColor: emptyShapeLayer.fillColor!))
    XCTAssertEqual(UIColor.blueColor(), UIColor(CGColor: emptyShapeLayer.strokeColor!))
    XCTAssertEqual(1.31, emptyShapeLayer.lineWidth)
    
    // Check filled container layer
    // ------------------
    
    let filledContainerLayer = result.sublayers![1] as CALayer
    XCTAssertEqual(19 * 0.8, filledContainerLayer.bounds.size.width)
    XCTAssertEqual(19, filledContainerLayer.bounds.size.height)
    
    // Check filled shape layer color
    // ------------------
    
    let filledShapeLayer = filledContainerLayer.sublayers![0] as! CAShapeLayer
    XCTAssertEqual(UIColor.redColor(), UIColor(CGColor: filledShapeLayer.fillColor!))
    XCTAssertEqual(UIColor.redColor(), UIColor(CGColor: filledShapeLayer.strokeColor!))
    XCTAssertEqual(1.31, filledShapeLayer.lineWidth)
  }
  
  // MARK: - Create composite star layer
  
  func testCreateCompositeStarLayer_fullStar() {
    var settings = CosmosSettings()
    settings.starSize = 12
    settings.colorFilled = UIColor.yellowColor()
    
    let result = CosmosLayers.createCompositeStarLayer(1, settings: settings) as CALayer
  
    XCTAssertEqual(1, result.sublayers!.count)

    // Check filled container layer
    // ------------------
    
    XCTAssertEqual(12, result.bounds.size.width)
    XCTAssertEqual(12, result.bounds.size.height)
    
    // Check filled shape layer color
    // ------------------
    
    let filledShapeLayer = result.sublayers![0] as! CAShapeLayer
    XCTAssertEqual(UIColor.yellowColor(), UIColor(CGColor: filledShapeLayer.fillColor!))
    XCTAssertEqual(UIColor.yellowColor(), UIColor(CGColor: filledShapeLayer.strokeColor!))
  }

  func testCreateCompositeStarLayer_emptyStar() {
    var settings = CosmosSettings()
    settings.starSize = 61
    settings.colorEmpty = UIColor.purpleColor()
    settings.borderColorEmpty = UIColor.blueColor()
    settings.borderWidthEmpty = 1.31
    
    let result = CosmosLayers.createCompositeStarLayer(0, settings: settings) as CALayer
    
    XCTAssertEqual(1, result.sublayers!.count)
    
    // Check empty container layer
    // ------------------
    
    XCTAssertEqual(61, result.bounds.size.width)
    XCTAssertEqual(61, result.bounds.size.height)
    
    // Check empty shape layer color
    // ------------------
    
    let emptyShapeLayer = result.sublayers![0] as! CAShapeLayer
    XCTAssertEqual(UIColor.purpleColor(), UIColor(CGColor: emptyShapeLayer.fillColor!))
    XCTAssertEqual(UIColor.blueColor(), UIColor(CGColor: emptyShapeLayer.strokeColor!))
    XCTAssertEqual(1.31, emptyShapeLayer.lineWidth)
  }

  func testCreateCompositeStarLayer_partiallyFilled() {
    var settings = CosmosSettings()
    settings.starSize = 14
    settings.colorEmpty = UIColor.purpleColor()
    settings.borderColorEmpty = UIColor.blueColor()
    settings.borderWidthEmpty = 1.31
    settings.colorFilled = UIColor.yellowColor()

    let result = CosmosLayers.createCompositeStarLayer(0.2, settings: settings)
    
    XCTAssertEqual(2, result.sublayers!.count)
    
    // Check layer
    // ------------------
    
    XCTAssertEqual(14, result.bounds.size.width)
    XCTAssertEqual(14, result.bounds.size.height)
    
    // Check empty container layer
    // ------------------
    
    let emptyContainerLayer = result.sublayers![0] as CALayer
    XCTAssertEqual(14, emptyContainerLayer.bounds.size.width)
    XCTAssertEqual(14, emptyContainerLayer.bounds.size.height)
    
    // Check empty shape layer
    // ------------------
    
    let emptyShapeLayer = emptyContainerLayer.sublayers![0] as! CAShapeLayer
    XCTAssertEqual(UIColor.purpleColor(), UIColor(CGColor: emptyShapeLayer.fillColor!))
    XCTAssertEqual(UIColor.blueColor(), UIColor(CGColor: emptyShapeLayer.strokeColor!))
    XCTAssertEqual(1.31, emptyShapeLayer.lineWidth)
    
    // Check filled container layer
    // ------------------
    
    let filledContainerLayer = result.sublayers![1] as CALayer
    XCTAssertEqual(14 * 0.2, filledContainerLayer.bounds.size.width)
    XCTAssertEqual(14, filledContainerLayer.bounds.size.height)
    
    // Check filled shape layer color
    // ------------------
    
    let filledShapeLayer = filledContainerLayer.sublayers![0] as! CAShapeLayer
    XCTAssertEqual(UIColor.yellowColor(), UIColor(CGColor: filledShapeLayer.fillColor!))
    XCTAssertEqual(UIColor.yellowColor(), UIColor(CGColor: filledShapeLayer.strokeColor!))
    XCTAssertEqual(1.31, filledShapeLayer.lineWidth)

  }

  // MARK: - Create star layers 
  
  func testCreateStarLayers() {
    var settings = CosmosSettings()
    settings.starSize = 17
    settings.starMargin = 5
    settings.totalStars = 100 // Crazy, huh? But still way less than 100,000,000,000 to 400,000,000,000 stars in our Milky Way galaxy. 🌌
    
    let result = CosmosLayers.createStarLayers(3.7, settings: settings)
    
    XCTAssertEqual(100, result.count)
    XCTAssertEqual(17, result.last!.bounds.width)
    
    // 100 * 10 (width of the stars)
    //   + 99 * 5 (margin between stars)
    XCTAssertEqual(Double(99 * 17 + 99 * 5), Double(result.last!.position.x))
  }
}