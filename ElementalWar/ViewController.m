//
//  ViewController.m
//  ElementalWar
//
//  Created by Fabio Alves on 2/8/16.
//  Copyright © 2016 HeritageSevenApps. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "Card.h"

@interface ViewController ()


@end

//set up the stacks
NSMutableArray *aiStack;
NSMutableArray *playerStack;
NSMutableArray *playerHand;
NSMutableArray *inPlay;
NSMutableArray *playerDiscardPile;
NSMutableArray *aiDiscardPile;
NSNumber *emptyArray;


#define AICARD 0
#define PLAYERCARD 1
#define ELEMENTBONUS 2

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    playerStack = [[NSMutableArray alloc]init];
    aiStack = [[NSMutableArray alloc]init];
    playerHand = [[NSMutableArray alloc]init];
    inPlay = [[NSMutableArray alloc]init];
    playerDiscardPile = [[NSMutableArray alloc]init];
    aiDiscardPile = [[NSMutableArray alloc]init];
    
    //filling in the Player's Hand Array to compare values
    emptyArray = [[NSNumber alloc]initWithInt:0];
    [playerHand addObject:emptyArray];
    [playerHand addObject:emptyArray];
    [playerHand addObject:emptyArray];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma gameLogic



- (void) fillPlayersHand{

    for (int i = 0; i < playerHand.count ; i++) {
        if ([playerHand objectAtIndex:i] == emptyArray) {
            [playerHand replaceObjectAtIndex:i withObject:[playerStack lastObject]];
            [playerStack removeLastObject];
        }
    }
}


- (IBAction)startNewGame:(id)sender {
    
    //Set up the Deck and Shuffle
    Deck *deck = [[Deck alloc] init];
    [deck shuffle];
    
    
    //Distribute the cards
    while ([deck cardsRemaining] > 0){
        Card *card = [deck draw];
        [playerStack addObject:card];
        Card *card2 = [deck draw];
        [aiStack addObject:card2];
    }
    
    //Fill Player's Hand
    [self fillPlayersHand];

    [self updateGUI];
    
}

- (void)updateGUI{
    self.playerDeckCountLabel.text = [NSString stringWithFormat:@"%ld", playerStack.count];
    self.aiDeckCountLabel.text = [NSString stringWithFormat:@"%ld", aiStack.count];
    self.playerDiscardPileLabel.text = [NSString stringWithFormat:@"%ld", playerDiscardPile.count];
    self.aiDiscardPileLabel.text = [NSString stringWithFormat:@"%ld", aiDiscardPile.count];
    self.inPlayCounterLabel.text = [NSString stringWithFormat:@"%ld", inPlay.count];
    //Update Player Cards
    
    Card *card1 = [playerHand objectAtIndex:0];
    [self.playerCard1 setTitle:[NSString stringWithFormat:@"%d of %d", card1.value, card1.element] forState:UIControlStateNormal];
    
    Card *card2 = [playerHand objectAtIndex:1];
    [self.playerCard2 setTitle:[NSString stringWithFormat:@"%d of %d", card2.value, card2.element] forState:UIControlStateNormal];
   
    Card *card3 = [playerHand objectAtIndex:2];
    [self.playerCard3 setTitle:[NSString stringWithFormat:@"%d of %d", card3.value, card3.element] forState:UIControlStateNormal];
    
    
    //update the inPlay Labels
    if (inPlay.count) {
        Card *card4 = [inPlay objectAtIndex:AICARD];
        Card *card5 = [inPlay objectAtIndex:PLAYERCARD];
        [self.aiCardTestLabel setText:[NSString stringWithFormat:@"%d of %d", card4.value, card4.element]];
        [self.playerCardTestLabel setText:[NSString stringWithFormat:@"%d of %d", card5.value, card5.element]];
    }

}

- (IBAction)cardSelection:(id)sender {
  //  [self updateGUI];
    
//    switch ([sender tag]) {
//        case 0:
//            {//NSLog(@"Card 1");
//                [self checkForWar:sender];
//            }
//            break;
//        case 1:
//           // NSLog(@"Card 2");
//                [self checkForWar:sender];
//            break;
//        case 2:
//          //  NSLog(@"Card 3");
//            break;
//        default:
//            NSLog(@"Something really wrong happened");
//            break;
//    }
    [self checkForWar:sender];
    [self fillPlayersHand];
    [self updateGUI];
}

- (IBAction)nextRoundButton:(id)sender {
   
    //reset table cards
    [inPlay removeAllObjects];
    [self.aiCardTestLabel setText:@"xxx"];
    [self.playerCardTestLabel setText:@"xxx"];
    
    [self updateGUI];
    
    
    //reactivate the Player card buttons
    [self.playerCard1 setEnabled:true];
    [self.playerCard2 setEnabled:true];
    [self.playerCard3 setEnabled:true];


    
}

-(void)checkForWar:(id)pressedButton{

    UIButton *button = (UIButton*)pressedButton;

    //add top card from aiStack to inPlay and remove
    [inPlay insertObject:[aiStack lastObject] atIndex:AICARD];
    [aiStack removeLastObject];
    
    //add selected card from playerHand to inPlay and remove
    [inPlay insertObject:[playerHand objectAtIndex:button.tag] atIndex:PLAYERCARD];
    [playerHand replaceObjectAtIndex:button.tag withObject:emptyArray];
    
    
    [button setTitle:@"Flipped" forState:UIControlStateDisabled];
    [button setEnabled:FALSE];
    
    
    //check for War Conditions & add cards to Stacks
    Card *cardAi = [inPlay objectAtIndex:AICARD];
    Card *cardPlayer = [inPlay objectAtIndex:PLAYERCARD];
    
    
    if (cardAi.value > cardPlayer.value) { //ai Wins
        [aiDiscardPile addObjectsFromArray:inPlay];
        NSLog(@"ai Wins");
    }
    else if (cardAi.value < cardPlayer.value){ //Player Wins
        [playerDiscardPile addObjectsFromArray:inPlay];
        NSLog(@"Player wins");
    }
    else{ // WAR
        //start war if cards have the same value
        [self war];
    }
}

-(void) war{
    
    //get 4 cards from ai Stack
    for (int i=0; i<4; i++) {
        [inPlay addObject:[aiStack lastObject]];
        [aiStack removeLastObject];
    }
    Card *cardAi = [inPlay lastObject];
    
    //get 4 cards from Player Stack
    for (int i=0; i<4; i++) {
    [inPlay addObject:[playerStack lastObject]];
    [playerStack removeLastObject];
    }
    Card *cardPlayer = [inPlay lastObject];
    
    //print labels
     [self.aiCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardAi.value, cardAi.element]];
     [self.playerCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardPlayer.value, cardPlayer.element]];
    
    //check element
    
    int cardAiTotal = cardAi.value;
    int cardPlayerTotal = cardPlayer.value;


    //check Bonuses
    
    switch ([cardAi element]) {
        case elementFire:{
            NSLog(@"0. FIRE");

            if (cardPlayer.element == elementEarth) cardAiTotal += ELEMENTBONUS;
            if (cardPlayer.element == elementWater) cardAiTotal -= ELEMENTBONUS;
        }
            break;
        case elementEarth:{
            NSLog(@"1. EARTH");

            if (cardPlayer.element == elementWind) cardAiTotal += ELEMENTBONUS;
            if (cardPlayer.element == elementFire) cardAiTotal -= ELEMENTBONUS;
            }
            break;
        case elementWater:{
            NSLog(@"2. WATER");
            
            if (cardPlayer.element == elementFire) cardAiTotal += ELEMENTBONUS;
            if (cardPlayer.element == elementWind) cardAiTotal -= ELEMENTBONUS;
        }
            break;
        case elementWind:{
            NSLog(@"3. WIND");

            if (cardPlayer.element == elementWater) cardAiTotal += ELEMENTBONUS;
            if (cardPlayer.element == elementEarth) cardAiTotal -= ELEMENTBONUS;
        }
            break;

            break;
        default:
            NSLog(@"Something really wrong happened");
            break;
    }

//WAR RESULTS AFTER BONUSES:
    NSLog(@"WAR card AI: %d", cardAiTotal);
    NSLog(@"WAR card Player: %d", cardPlayerTotal);
    
    
    //Redistribute cards
    if (cardAiTotal > cardPlayerTotal){ //ai Wins
        [aiDiscardPile addObjectsFromArray:inPlay];
    }else{//Player Wins
        [playerDiscardPile addObjectsFromArray:inPlay];
    }
    
}


@end
