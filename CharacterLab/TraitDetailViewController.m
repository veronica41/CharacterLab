//
//  TraitDetailViewController.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/7/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "YTVimeoExtractor.h"
#import "TraitDetailViewController.h"
#import "StudentsCollectionViewCell.h"
#import "CLColor.h"
#import "CLModel.h"

@interface TraitDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *traitDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *buildTraitViewHeight;

@property (nonatomic, strong) YTVimeoExtractor *extrator;
@property (nonatomic, strong) MPMoviePlayerController *playerController;
@property (nonatomic, strong) NSArray *tips;

@end


@implementation TraitDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup navigation bar
    self.navigationController.navigationBar.barTintColor = UIColorFromHEX(CLColorBackgroundBeige);
    self.navigationController.navigationBar.tintColor = UIColorFromHEX(CLColorTextBrown);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navBackLight"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromHEX(CLColorTextBrown), NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:20.0]};
    self.navigationItem.title = self.trait.name;

    [self setupVideoPlayer];

    self.traitImageView.image = [UIImage imageNamed:self.trait.name];
    self.traitDescriptionLabel.text = self.trait.desc;
    self.aboutLabel.text = [NSString stringWithFormat:@"ABOUT %@", self.trait.name.uppercaseString];
    self.buildLabel.text = [NSString stringWithFormat:@"BUILD %@", self.trait.name.uppercaseString];

    if (self.hideImageViewOnLoad) {
        self.traitImageView.alpha = 0;
    }

    [[CLModel sharedInstance] getTipsForTrait:self.trait success:^(NSArray *tipsList) {
        self.tips = tipsList;
    } failure:^(NSError *error) {
        NSLog(@"Failed to fetch tips, %@", error);
    }];
}

- (void)setupVideoPlayer {
    [YTVimeoExtractor fetchVideoURLFromURL:self.trait.videoUrl quality:YTVimeoVideoQualityLow completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
        if (error) {
            // TODO: (veronica) show video cannot be load
        } else {
            self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
            self.playerController.shouldAutoplay = NO;
            [self.playerController prepareToPlay];
            self.playerController.view.frame = self.movieView.bounds;
            [self.movieView addSubview:self.playerController.view];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
