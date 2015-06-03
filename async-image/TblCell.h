//
//  TblCell.h
//  imageJson
//
//  Created by Iulian G. Necea on 03/06/15.
//  Copyright (c) 2015 StartQ Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TblCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImg;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UILabel *cellPosition;

@end
