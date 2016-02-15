//
//  Card.m
//  ElementalWar
//
//  Created by Fabio Alves on 2/8/16.
//  Copyright © 2016 HeritageSevenApps. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize element = _element;
@synthesize value = _value;
@synthesize isTurnedOver = _isTurnedOver;

- (id)initWithSuit:(Element)element value:(int)value
{
    NSAssert(value >= CardAce && value <= CardKing, @"Invalid card value"); //testing all the values To be removed before release 
    
    if ((self = [super init]))
    {
        _element = element;
        _value = value;
    }
    return self;
}

@end
