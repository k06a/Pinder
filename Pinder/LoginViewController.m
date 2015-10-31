//
//  LoginViewController.m
//  Pinder
//
//  Created by Антон Буков on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "PinderServer.h"
#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

@implementation LoginViewController

- (void)awakeFromNib
{
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[PinderServer sharedServer] loginInView:self.webView completion:^(NSString *user_id, NSString *server_token)
    {
        if (user_id && server_token)
        {
            [PinderServer sharedServer].user_id = user_id;
            [PinderServer sharedServer].server_token = server_token;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
