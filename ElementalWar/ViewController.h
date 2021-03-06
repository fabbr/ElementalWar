//
//  ViewController.h
//  ElementalWar
//
//  Created by Fabio Alves on 2/8/16.
//  Copyright © 2016 HeritageSevenApps. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController

- (IBAction)startNewGame:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *aiDeckCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerDeckCountLabel;


//Player card selection
- (IBAction)cardSelection:(id)sender;
- (IBAction)nextRoundButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextRoundButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *playerCard1;
@property (weak, nonatomic) IBOutlet UIButton *playerCard2;
@property (weak, nonatomic) IBOutlet UIButton *playerCard3;

//testing Labels
@property (weak, nonatomic) IBOutlet UILabel *aiCardTestLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerCardTestLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerDiscardPileLabel;
@property (weak, nonatomic) IBOutlet UILabel *aiDiscardPileLabel;
@property (weak, nonatomic) IBOutlet UILabel *warLabel;

@property (weak, nonatomic) IBOutlet UILabel *inPlayCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *aiCardWarLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerCardWarLabel;


//Power-Up Buttons
- (IBAction)powerUp1SmallPackageButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *powerUp1SmallPackageButtonOutlet;
- (IBAction)powerUp2NegateElementsButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *powerUp2NegateElementsOutlet;
- (IBAction)powerUp3WarMachineButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *powerUp3WarMachineOutlet;
- (IBAction)powerUp4ReconButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *powerUp4ReconOutlet;

//Ai Cards Labels
@property (weak, nonatomic) IBOutlet UILabel *aiCardLabel1;
@property (weak, nonatomic) IBOutlet UILabel *aiCardLabel2;
@property (weak, nonatomic) IBOutlet UILabel *aiCardLabel3;




@end

