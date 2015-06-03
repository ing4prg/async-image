//
//  TblViewController.m
//  imageJson
//
//  Created by Iulian G. Necea on 03/06/15.
//  Copyright (c) 2015 StartQ Software. All rights reserved.
//

#import "TblViewController.h"
#import "TblCell.h"
#import "SecondViewController.h"

@interface TblViewController (){
    NSArray *jsonArray;
    NSString *imgURL;
}

@end

@implementation TblViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"https://s3-us-west-2.amazonaws.com/wirestorm/assets/response.json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    NSError *err = nil;
    jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return jsonArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TblCell *cell = (TblCell *)[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (cell == nil) {
        cell = (TblCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    cell.cellName.text = (NSString *)[item objectForKey:@"name"];
    cell.cellPosition.text = (NSString *)[item objectForKey:@"position"];
    
    cell.cellImg.image = [UIImage imageNamed:@"DefImg"];
    NSURL *url = [NSURL URLWithString:(NSString *)[item objectForKey:@"smallpic"]];
    
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            cell.cellImg.image = image;
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    imgURL = (NSString *)[item objectForKey:@"lrgpic"];
    [self performSegueWithIdentifier:@"segImage" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"segImage"]) {
        SecondViewController *controller = (SecondViewController *)segue.destinationViewController;
        controller.imgURL = imgURL;
    }
}

#pragma mark - ImageAsync
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // sleep(1); // just for debug
                               if (!error) {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES, image);
                               } else {
                                   completionBlock(NO, nil);
                               }
                           }];
}

@end
