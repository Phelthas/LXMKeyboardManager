# LXMKeyboardManager
一个通过监听键盘然后调整textField位置使之不会被键盘挡住的工具类

##Installation
requires iOS5.0 or later

### Using cocoaPods
1, add the LXMKeyboardManager pod to your Podfile    

    pod 'LXMKeyboardManager', '~> 0.0.1'   
    
2, run ` pod install `  

3, import the `LXMKeyboardManager.h` header file, Typically, this should be written as `#import <LXMKeyboardManager.h>`     

### Manually
1, add `LXMKeyboardManager.h` and `LXMKeyboardManager.m` in your project     
2, import the `LXMKeyboardManager.h` header file

## How to Use
1, init a keyboardManager in `viewDidAppear` like this:       

    if (!self.keyboardManager) {
        self.keyboardManager = [[LXMKeyboardManager alloc] initWithScrollView:self.scrollView];
    }

2, call `- (void)scrollToIdealPositionWithTargetView:(UIView *)argView;` in UITextFieldDelegate method like this:     

    #pragma mark - UITextFieldDelegate
    - (void)textFieldDidBeginEditing:(UITextField *)textField {
        [self.keyboardManager scrollToIdealPositionWithTargetView:textField];
    }

## Issues & Contributions
if you have any problem, suggestion or other comment, just tell me and maybe we could work it out together   

## License
LXMKeyboardManager is available under the MIT license. See the LICENSE file for more info.   



