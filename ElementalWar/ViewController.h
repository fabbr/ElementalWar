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

@property (weak, nonatomic) IBOutlet UIButton *playerCard1;
@property (weak, nonatomic) IBOutlet UIButton *playerCard2;
@property (weak, nonatomic) IBOutlet UIButton *playerCard3;

//testing Labels
@property (weak, nonatomic) IBOutlet UILabel *aiCardTestLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerCardTestLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerDiscardPileLabel;
@property (weak, nonatomic) IBOutlet UILabel *aiDiscardPileLabel;

@property (weak, nonatomic) IBOutlet UILabel *inPlayCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *aiCardWarLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerCardWarLabel;


//Power-Up Buttons
- (IBAction)powerUpButton1:(id)sender;

@end

