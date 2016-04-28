//
//  Card.h
//  ElementalWar
//
//  Created by Fabio Alves on 2/8/16.
//  Copyright © 2016 HeritageSevenApps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    elementFire,
    elementEarth,
    elementWater,
    elementWind
}
Element;

#define CardAce   1
#define CardJack  11
#define CardQueen 12
#define CardKing  4 //**** change back to 13 before final version ****

@interface Card : NSObject

@property (nonatomic, assign, readonly) Element element;
@property (nonatomic, assign, readonly) int value;
@property (nonatomic, assign) BOOL isTurnedOver;

- (id)initWithSuit:(Element)suit value:(int)value;


@end
