//
//  UIColor+Extensions.m
//  get2me
//
//  Created by Constantinos Mavromoustakos on 10/3/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)
+ (UIColor *) randomColorWithAlphaComponent: (float) alphaComponent {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alphaComponent];
}
@end
