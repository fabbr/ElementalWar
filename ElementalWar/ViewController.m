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

//set up the power ups
BOOL pu1SmallPackageInt;
BOOL pu2NegateElementsInt;
BOOL pu4ReconInt;
BOOL warInProgress;
#define on true
#define off false

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

#pragma mark - gameLogic


- (void) fillPlayersHand{
    for (int i = 0; i < playerHand.count ; i++) {
       // [self checkForGameOver];     //**Enable this for the GO Alert to show up automatic. Without it it will only showup after NEXT Button is pressed
        if ([playerHand objectAtIndex:i] == emptyArray && playerStack.count > 0) {
            [playerHand replaceObjectAtIndex:i withObject:[playerStack lastObject]];
            [playerStack removeLastObject];
        }
    }
}

-(void)checkForGameOver{
    //player side
    if (playerStack.count == 0 && playerDiscardPile > 0) {  //This will refill the Player Stack with the DiscardPile - No GameOver yet
        playerStack = [NSMutableArray arrayWithArray:playerDiscardPile];
        [playerDiscardPile removeAllObjects];
    }
    
//    Conditions for the Player to Lose the Game - Note that the PlayerHand Array is never empty so we have to compare all the 3 objects to the "emptyArray" NSNumber set previously
        if ([playerStack count] == 0 &&
            [playerDiscardPile count] == 0 &&
            [playerHand objectAtIndex:0] == emptyArray &&
            [playerHand objectAtIndex:1] == emptyArray &&
            [playerHand objectAtIndex:2] == emptyArray){
            NSLog(@"💥💥💥💥💥 GAME OVER, YOU LOST  💥💥💥💥💥");
            //Start of UIAlert View
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"💥💥💥💥💥\n   GAME OVER, YOU LOST  \n💥💥💥💥💥"
                                          message:@"Reason: Ran out of Cards"
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Click Here to go back to Initial Screen"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     NSString * storyboardName = @"Main";
                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                     UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"VC_1"];
                                     [self presentViewController:vc animated:YES completion:nil];
                                 }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    
    //ai Side
    if (aiStack.count == 0 && aiDiscardPile >0) { //Fill up the AI StackPile with DiscardPile - No GameOver
        aiStack = [NSMutableArray arrayWithArray:aiDiscardPile];
        [aiDiscardPile removeAllObjects];
        NSLog(@"end of ai Stack  =-=-=-=-=-");
    }
    if (aiStack.count == 0 && aiDiscardPile.count == 0){
        NSLog(@"🏅🏅🏅🏅 GAME OVER, YOU WIN  🏅🏅🏅🏅");
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"🏅🏅🏅🏅\n   GAME OVER, YOU WIN  \n🏅🏅🏅🏅"
                                      message:@"Reason: AI ran out of Cards"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Click Here to go back to Initial Screen"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 NSString * storyboardName = @"Main";
                                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                 UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"VC_1"];
                                 [self presentViewController:vc animated:YES completion:nil];
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return;
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
   
    //update Ai Card Labels
    [self.aiCardLabel1 setText:@"Card 1"];
    [self.aiCardLabel2 setText:@"Card 2"];
    [self.aiCardLabel3 setText:@"Card 3"];
    
    //update the inPlay Labels
    if (inPlay.count) {
        Card *card4 = [inPlay objectAtIndex:AICARD];
        Card *card5 = [inPlay objectAtIndex:PLAYERCARD];
        [self.aiCardTestLabel setText:[NSString stringWithFormat:@"%d of %@", card4.value, [self updateElementalString:card4]]];
        [self.playerCardTestLabel setText:[NSString stringWithFormat:@"%d of %@", card5.value, [self updateElementalString:card5]]];
    }
}

- (IBAction)cardSelection:(id)sender {  //Selector of the card
    [self checkForWar:sender];          //Send the card Button ID to the CheckForWar Class
    [self fillPlayersHand];
    [self updateGUI];
}

- (IBAction)nextRoundButton:(id)sender {
   
    [self.nextRoundButtonOutlet setTitle:@"Next" forState:UIControlStateNormal];
    //erase War Indicator Label
    [self.warLabel setText:@""];
    
    //reset table cards
    [inPlay removeAllObjects];
    [self.aiCardTestLabel setText:@""];
    [self.playerCardTestLabel setText:@""];
    [self.aiCardWarLabel setText:@""];
    [self.playerCardWarLabel setText:@""];
    [self updateGUI];
    
    //Check for GG
    [self checkForGameOver];
    [self fillPlayersHand];

    //Update Player Cards
    
    if ([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]]) {  //Check if the Object in the PlayerHand Array is a CARD to update it. 
        [self.playerCard1 setEnabled:true];                             //reactivate the Player card buttons
        Card *card1 = [playerHand objectAtIndex:0];
        [self.playerCard1 setTitle:[NSString stringWithFormat:@"%d of %@", card1.value, [self updateElementalString:card1]] forState:UIControlStateNormal];
    }
    
    if ([[playerHand objectAtIndex:1] isMemberOfClass:[Card class]]) {
        [self.playerCard2 setEnabled:true];
        Card *card2 = [playerHand objectAtIndex:1];
        [self.playerCard2 setTitle:[NSString stringWithFormat:@"%d of %@", card2.value, [self updateElementalString:card2]] forState:UIControlStateNormal];
    }

    if ([[playerHand objectAtIndex:2] isMemberOfClass:[Card class]]) {
        [self.playerCard3 setEnabled:true];
        Card *card3 = [playerHand objectAtIndex:2];
        [self.playerCard3 setTitle:[NSString stringWithFormat:@"%d of %@", card3.value, [self updateElementalString:card3]] forState:UIControlStateNormal];
    }
}

-(NSString *)updateElementalString:(Card*)Card{   //To add some graph to the text-based game logic
    NSString *emoji;
    switch ([Card element]) {
        case 0:
            emoji = @"🔥";
            break;
        case 1:
            emoji = @"🌎";
            break;
        case 2:
            emoji = @"🌊";
            break;
        case 3:
            emoji = @"🌬";
            break;
    }
    return emoji;
}



-(void)checkForWar:(id)pressedButton{

    UIButton *button = (UIButton*)pressedButton;

    //add top card from aiStack to inPlay and remove
    [inPlay insertObject:[aiStack lastObject] atIndex:AICARD];
    [aiStack removeLastObject];
    
    //add selected card from playerHand to inPlay and remove
    [inPlay insertObject:[playerHand objectAtIndex:button.tag] atIndex:PLAYERCARD];
    [playerHand replaceObjectAtIndex:button.tag withObject:emptyArray];
    
    
    [button setTitle:@"EMPTY" forState:UIControlStateNormal];

    //disable all the cards
    [self.playerCard1 setEnabled:false];
    [self.playerCard2 setEnabled:false];
    [self.playerCard3 setEnabled:false];
    
    
    
    //check for War Conditions & add cards to Stacks
    Card *cardAi = [inPlay objectAtIndex:AICARD];
    Card *cardPlayer = [inPlay objectAtIndex:PLAYERCARD];
    
    [self checkWinner:cardAi :cardPlayer];
    
}


-(void)checkWinner:(Card*)cardAi : (Card*)cardPlayer{
    

    int cardAiTotal = cardAi.value;
    int cardPlayerTotal = cardPlayer.value;
    
    //check if Power Up 2 Negate the Elements is active or not to check the Bonuses
    NSLog(@" ");

    if (!pu2NegateElementsInt) {
        
        //check Elemental Bonuses
        switch ([cardAi element]) {
            case elementFire:{
                if (cardPlayer.element == elementEarth) cardAiTotal += ELEMENTBONUS;
                if (cardPlayer.element == elementWater) cardAiTotal -= ELEMENTBONUS;
            }
                break;
            case elementEarth:{
                if (cardPlayer.element == elementWind) cardAiTotal += ELEMENTBONUS;
                if (cardPlayer.element == elementFire) cardAiTotal -= ELEMENTBONUS;
            }
                break;
            case elementWater:{
                if (cardPlayer.element == elementFire) cardAiTotal += ELEMENTBONUS;
                if (cardPlayer.element == elementWind) cardAiTotal -= ELEMENTBONUS;
            }
                break;
            case elementWind:{
                if (cardPlayer.element == elementWater) cardAiTotal += ELEMENTBONUS;
                if (cardPlayer.element == elementEarth) cardAiTotal -= ELEMENTBONUS;
            }
                break;
                break;    //maybe an extra break? Please check.
            default:
                NSLog(@"Something really wrong happened");
                break;
        }
    } //end of if for the pu2ElementsInt
    else{
        NSLog(@"Negate Elements ON");
        pu2NegateElementsInt = off;
    }
    
    
    

    
    //Small Package PowerUp Inverts the values so the smaller will win
    if (pu1SmallPackageInt) {
        NSLog(@"Small Package value change activated");
        int temp;
        temp = cardPlayerTotal;
        cardPlayerTotal = cardAiTotal;
        cardAiTotal = temp;
        pu1SmallPackageInt = off;
    }
    
//    ******TROUBLESHOOTING MODE******
//    (+) will make AI wins // (-) will make PLAYER wins
//    ******TROUBLESHOOTING MODE******
//    cardAiTotal -= 100;
//    ******TROUBLESHOOTING MODE******
//    Making all AI WIN all the time
//    ******TROUBLESHOOTING MODE******
    
    
 
    
    
    //WAR RESULTS AFTER BONUSES:
    NSLog(@"card AI total: %d", cardAiTotal);
    NSLog(@"card Player total: %d", cardPlayerTotal);

    
    //Who won and what to do with the inPlay Cards:
    if (cardAiTotal > cardPlayerTotal){ //ai Wins
        NSLog(@"-> AI Wins");
        [aiDiscardPile addObjectsFromArray:inPlay];
    }else if (cardAiTotal < cardPlayerTotal){//Player Wins
        NSLog(@"-> PLAYER Wins");
        [playerDiscardPile addObjectsFromArray:inPlay];
    }else{//WAR
        [self war];
    }

    
    
    
    
    
}

-(void) war{
    
    NSLog(@"WE HAVE WAR");
    
    warInProgress = true;
    
    //indicate the war happened
    [self.warLabel setText:@"WAR!!!"];
    
    
    //Start of War Crash Solution
    int totalCards = aiStack.count + aiDiscardPile.count;
    int WarTotal;
    if (totalCards < 4) {
        WarTotal = totalCards;
    }else{
        WarTotal = 4;
    }
    
    //get cards from ai Stack
    for (int i=0; i<WarTotal; i++) {
        //[self checkForGameOver];
        if (aiStack.count > 0) {
            [inPlay addObject:[aiStack lastObject]];
            [aiStack removeLastObject];
        } else {
            [inPlay addObject:[aiDiscardPile lastObject]];
            [aiDiscardPile removeLastObject];
        }
    }
    Card *cardAi = [inPlay lastObject];
    
    
    
    totalCards = playerStack.count + playerDiscardPile.count + playerHand.count;
    if (totalCards < 4) {
        WarTotal = totalCards;
    }else{
        WarTotal = 4;
    }
    
    
    //get cards from Player Stack
    for (int i=0; i<WarTotal; i++) {
    //[self checkForGameOver];
    
        // 1st take cards from the PlayerStack and refill with DiscardPile if necessary
        if (playerStack.count > 0) {
            [inPlay addObject:[playerStack lastObject]];
            [playerStack removeLastObject];
            
            //Fill in the PlayerStack with PlayerDiscardPile
            if (playerStack.count == 0 && playerDiscardPile > 0) {  //This will refill the Player Stack with the DiscardPile - No GameOver yet
                playerStack = [NSMutableArray arrayWithArray:playerDiscardPile];
                [playerDiscardPile removeAllObjects];
            }
        }
        // 2nd take cards from PlayerHand if necessary
        else {
            [inPlay addObject:[playerHand lastObject]];
            [playerHand removeLastObject];
        }
        
        

    

    
    }
    Card *cardPlayer = [inPlay lastObject];
    
    //print labels
     [self.aiCardWarLabel setText:[NSString stringWithFormat:@"%d of %@", cardAi.value, [self updateElementalString:cardAi]]];
     [self.playerCardWarLabel setText:[NSString stringWithFormat:@"%d of %@", cardPlayer.value, [self updateElementalString:cardPlayer]]];

    //check for winner or War
    [self checkWinner:cardAi :cardPlayer];

    warInProgress = false;
}

#pragma mark - PowerUps

- (IBAction)powerUp1SmallPackageButton:(id)sender {
    
    //Change War Label
    [self.warLabel setText:@"SmallPackage Activated"];
    
    pu1SmallPackageInt = on;
    [self.powerUp1SmallPackageButtonOutlet setEnabled:false];
    
}
- (IBAction)powerUp2NegateElementsButton:(id)sender {
    //Change War Label
    [self.warLabel setText:@"Negate Elements Activated"];
    
    pu2NegateElementsInt = on;
    [self.powerUp2NegateElementsOutlet setEnabled:false];
    
    
}



- (IBAction)powerUp3WarMachineButton:(id)sender {
    
    //WarMachine Button check
    int totalPlayerCards = playerHand.count + playerDiscardPile.count + playerStack.count;
    if (totalPlayerCards < 5 || aiStack.count < 5) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Easy there Tiger!"
                                      message:@"You or the Ai don't have enough cards to trigger a WAR"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //Change War Label
    [self.warLabel setText:@"WarMachine Activated"];
    
    //get 3 cards from both Stacks
    for (int i=0; i<3; i++) {
        [inPlay addObject:[aiStack lastObject]];
        [aiStack removeLastObject];
        [inPlay addObject:[playerStack lastObject]];
        [playerStack removeLastObject];
    }
    [self. powerUp3WarMachineOutlet setEnabled:false];
}



- (IBAction)powerUp4ReconButton:(id)sender {
    
    if (aiStack.count < 3) { //mainly to refill the player stack
        [self checkForGameOver];
    }
    
    NSMutableArray *hand = [[NSMutableArray alloc] init];    //array with number os cards left on the AiStack
    for (NSUInteger y = 0; (int)aiStack.count > y && y < 3; y++) {
        [hand addObject:@(y + 1)];    //add number of cards to the array
    }
    
    int inicitalHandCount = (int)hand.count;

    for (int i = 0; i < inicitalHandCount; i++){
       
        NSInteger index = arc4random() % (NSUInteger)(hand.count);  //random number from hand array
        int object = [(NSNumber *)[hand objectAtIndex:index]intValue]; //assign that number to object
        [hand removeObjectAtIndex:index]; //remove number from hand array
        
        
        
        
        int x = (int)aiStack.count - i -1;  //getting the top cards from the stacks
        Card *card1 = [aiStack objectAtIndex:x];
        switch (object) {  //since object was random it will randomly pick a label to update the AiCard
            case 1:
                [self.aiCardLabel1 setText:[NSString stringWithFormat:@"%d of %@", card1.value, [self updateElementalString:card1]]];
                break;
            case 2:
                [self.aiCardLabel2 setText:[NSString stringWithFormat:@"%d of %@", card1.value, [self updateElementalString:card1]]];
                break;
            case 3:
                [self.aiCardLabel3 setText:[NSString stringWithFormat:@"%d of %@", card1.value, [self updateElementalString:card1]]];
                break;
            default:
                break;
        }
    }
    
    [self.powerUp4ReconOutlet setEnabled:FALSE]; //use only once
}
@end
