#import <Carbon/Carbon.h>

static const unsigned char kInstallLocation[] =
    "/Library/Input Methods/ThoanTaigi.app";
static NSString *const kSourceID =
    @"tw.ithoan.inputmethod.ThoanTaigi";
static NSString *const kInputModeID =
    @"tw.ithoan.inputmethod.ThoanTaigi.HanloPoj";

void RegisterInputSource() {
  CFURLRef installedLocationURL = CFURLCreateFromFileSystemRepresentation(
      NULL, kInstallLocation, strlen((const char *)kInstallLocation), NO);
  if (installedLocationURL) {
    TISRegisterInputSource(installedLocationURL);
    CFRelease(installedLocationURL);
    NSLog(@"Registered input source from %s", kInstallLocation);
  }
}

void ActivateInputSource() {
  NSString* sourceID1 = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleIdentifier"];
  NSString* inputModeID1 = [[NSBundle mainBundle].infoDictionary valueForKey:@"TISInputSourceID"];
  NSLog(@"sourceID1: %@", sourceID1);
  NSLog(@"inputModeID1: %@", inputModeID1);
  
  CFArrayRef sourceList = TISCreateInputSourceList(NULL, true);
  for (int i = 0; i < CFArrayGetCount(sourceList); ++i) {
    TISInputSourceRef inputSource = (TISInputSourceRef)(CFArrayGetValueAtIndex(
        sourceList, i));
    NSString *sourceID = (__bridge NSString *)(TISGetInputSourceProperty(
        inputSource, kTISPropertyInputSourceID));
    //NSLog(@"examining input source '%@", sourceID);
    if ([sourceID isEqualToString:kSourceID] ||
        [sourceID isEqualToString:kInputModeID]) {
      TISEnableInputSource(inputSource);
      NSLog(@"Enabled input source: %@", sourceID);
      CFBooleanRef isSelectable = (CFBooleanRef)TISGetInputSourceProperty(
          inputSource, kTISPropertyInputSourceIsSelectCapable);
      if (CFBooleanGetValue(isSelectable)) {
        TISSelectInputSource(inputSource);
        NSLog(@"Selected input source: %@", sourceID);
      }
    }
  }
  CFRelease(sourceList);
}

void DeactivateInputSource() {
  CFArrayRef sourceList = TISCreateInputSourceList(NULL, true);
  for (int i = CFArrayGetCount(sourceList); i > 0; --i) {
    TISInputSourceRef inputSource = (TISInputSourceRef)(CFArrayGetValueAtIndex(
        sourceList, i - 1));
    NSString *sourceID = (__bridge NSString *)(TISGetInputSourceProperty(
        inputSource, kTISPropertyInputSourceID));
    //NSLog(@"Examining input source: %@", sourceID);
    if ([sourceID isEqualToString:kSourceID] ||
        [sourceID isEqualToString:kInputModeID]) {
      TISDisableInputSource(inputSource);
      NSLog(@"Disabled input source: %@", sourceID);
    }
  }
  CFRelease(sourceList);
}

BOOL IsInputSourceActive() {
  int active = 0;
  CFArrayRef sourceList = TISCreateInputSourceList(NULL, true);
  for (int i = 0; i < CFArrayGetCount(sourceList); ++i) {
    TISInputSourceRef inputSource = (TISInputSourceRef)(CFArrayGetValueAtIndex(
        sourceList, i));
    NSString *sourceID = (__bridge NSString *)(TISGetInputSourceProperty(
        inputSource, kTISPropertyInputSourceID));
    //NSLog(@"Examining input source: %@", sourceID);
    if ([sourceID isEqualToString:kSourceID] ||
        [sourceID isEqualToString:kInputModeID]) {
      CFBooleanRef isEnabled = (CFBooleanRef)(TISGetInputSourceProperty(
          inputSource, kTISPropertyInputSourceIsEnabled));
      if (CFBooleanGetValue(isEnabled)) {
        ++active;
      }
    }
  }
  CFRelease(sourceList);
  //NSLog(@"IsInputSourceActive: %d", active);
  return active == 2;  // 1 active input method + 1 active input mode
}
