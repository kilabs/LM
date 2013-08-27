//
//  videoCell.h
//  melon
//
//  Created by Arie on 4/9/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface videoCell : UITableViewCell
{

}
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *excerpt;
@property(nonatomic,strong)UILabel *albumName;
@property(nonatomic,strong)UILabel *length;
@property(nonatomic,strong)UILabel *genre;
@property(nonatomic,strong)UIImageView *thumbnail;
@property(nonatomic,strong)UIButton *play;
@property(nonatomic,strong)UIButton *facebook;
@property(nonatomic,strong)UIButton *twitter;
@end
