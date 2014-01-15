//
//  MyController.m
//  SampleKeyframeAnimation
//
//  Created by Peter Chen on 1/9/14.
//  Copyright (c) 2014 Peter Chen. All rights reserved.
//

#import "MyController.h"

@interface MyController ()

@property (nonatomic, strong) UILabel *labelWithUIViewAnimation;
@property (nonatomic, strong) UILabel *labelWithUIViewKeyframeAnimation;
@property (nonatomic, strong) UILabel *labelWithKeyframeCoreAnimation;

@end

@implementation MyController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Keyframe Animation";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"GO!" style:UIBarButtonItemStyleDone target:self action:@selector(_goButtonTapped)];
    
    self.labelWithUIViewAnimation = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 20)];
    self.labelWithUIViewAnimation.text = @"Basic Animation";
    self.labelWithUIViewAnimation.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labelWithUIViewAnimation];
    
    self.labelWithUIViewKeyframeAnimation = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 20)];
    self.labelWithUIViewKeyframeAnimation.text = @"Keyframe Animation";
    self.labelWithUIViewKeyframeAnimation.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labelWithUIViewKeyframeAnimation];
    
    self.labelWithKeyframeCoreAnimation = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 20)];
    self.labelWithKeyframeCoreAnimation.text = @"Keyframe Using Core Animation";
    self.labelWithKeyframeCoreAnimation.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labelWithKeyframeCoreAnimation];
}

- (void)_goButtonTapped {
    [self uiviewAnimate];
}

- (void)uiviewAnimate {
    [UIView animateWithDuration:1 animations:^{
        self.labelWithUIViewAnimation.transform = CGAffineTransformMakeTranslation(0, 50);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            self.labelWithUIViewAnimation.alpha = 0.2;
            
        } completion:^(BOOL finished) {
            [self uiviewKeyframeAnimate];
        }];
    }];
}

- (void)uiviewKeyframeAnimate {
    [UIView animateKeyframesWithDuration:2 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0/4.0 relativeDuration:1/4.0 animations:^{
            self.labelWithUIViewKeyframeAnimation.transform = CGAffineTransformMakeTranslation(0, 25);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/4.0 relativeDuration:1/4.0 animations:^{
            self.labelWithUIViewKeyframeAnimation.transform = CGAffineTransformMakeTranslation(50, 25);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/4.0 relativeDuration:1/4.0 animations:^{
            self.labelWithUIViewKeyframeAnimation.transform = CGAffineTransformMakeTranslation(50, 50);
        }];
        [UIView addKeyframeWithRelativeStartTime:3/4.0 relativeDuration:1/4.0 animations:^{
            self.labelWithUIViewKeyframeAnimation.alpha = 0.2;
        }];
        
    } completion:^(BOOL finished) {
        [self keyframeCoreAnimation];
    }];
}

- (void)keyframeCoreAnimation {
    CGPoint startPosition = self.labelWithKeyframeCoreAnimation.layer.position;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPosition];
    [path addLineToPoint:CGPointMake(startPosition.x, startPosition.y + 25)];
    [path addLineToPoint:CGPointMake(startPosition.x + 50, startPosition.y + 25)];
    [path addLineToPoint:CGPointMake(startPosition.x + 50, startPosition.y + 50)];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.duration = 2*3/4.0;
    animation.delegate = self;
    
    [self.labelWithKeyframeCoreAnimation.layer addAnimation:animation forKey:@"position"];
    self.labelWithKeyframeCoreAnimation.layer.position = CGPointMake(startPosition.x + 50, startPosition.y + 50);
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation.fromValue = @1;
    basicAnimation.toValue = @0.2;
    [self.labelWithKeyframeCoreAnimation.layer addAnimation:basicAnimation forKey:@"opacity"];
    self.labelWithKeyframeCoreAnimation.layer.opacity = [basicAnimation.toValue floatValue];
}

@end
