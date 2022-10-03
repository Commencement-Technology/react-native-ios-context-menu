//
//  RNIImageRequireMaker.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 10/4/22.
//

import Foundation


internal class RNIImageRequireMaker {
  static private var imageCache: [String: UIImage] = [:];
  
  let uri: String;
  let imageLoadingConfig: RNIImageLoadingConfig;
  
  let rawConfig: NSDictionary;
  
  lazy var image: UIImage? = {
    let shouldCache = self.imageLoadingConfig.shouldCache ?? false;
    
    if shouldCache,
       let cachedImage = Self.imageCache[self.uri] {
      
      // A - Use cached image
      return cachedImage;
    };
    
    // B - No cached image
    let image = RCTConvert.uiImage(self.rawConfig);
    
    if shouldCache {
      Self.imageCache[self.uri] = image;
    };
    
    return image;
  }();
  
  init?(
    dict: NSDictionary,
    imageLoadingConfig loadingConfigDict: NSDictionary?
  ){
    guard let uriString = dict["uri"] as? String
    else { return nil };
    
    self.uri = uriString;
    self.rawConfig = dict;
    
    self.imageLoadingConfig =
      RNIImageLoadingConfig(dict: loadingConfigDict ?? [:]);
    
    self.preloadImageIfNeeded();
  };
  
  private func preloadImageIfNeeded(){
    let shouldLazyLoad = self.imageLoadingConfig.shouldLazyLoad ?? false;
    guard !shouldLazyLoad else { return };
    
    // trigger loading of image
    _ = self.image;
  };
};
