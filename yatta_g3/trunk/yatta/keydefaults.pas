unit keydefaults;

interface

uses Classes, Windows;

type
  TKeyEvent = (kJump5frames, kJump10frames, kJump15frames, kJump20frames, kJump25frames, kJump35frames, kJump50frames, kJump75frames, kJump100frames,
    kJumpPlus5frames, kJumpMinus5frames, kJumpPlus10frames, kJumpMinus10frames, kJumpPlus50frames, kJumpMinus50frames, kFreezeframeSection, kFFCToSEnd, kFFSBeginningToC,
    kJumpToNextPP, kJumpToRangeStart, kJumpToNextPN, kNextSection, kNextVMatch, kIgnoreHighVOnPlay, kZoomIn, kZoomOut,
    kNoDecimateS, kOpenTryPatternDialog, kPatternGuidanceOn, kPatternShiftInS,
    kPlay, kPlayFromSStart, kPostprocessSection, kPreviousSection, kPreviousVMatch,
    kReplaceCFrameWithNext, kReplaceCFrameWithPrevious, kResetSection, kSelectLowestVMetricMatches,
    kSwitchCMatchToPN, kTogglePBasedOnFreqOfUse, kTogglePreset, kMarkCustomList,
    kPreview, kNextFrame, kPreviousFrame, kSave,
    kSelectSWithSameP, kGenericDelete, kDeleteCFreezeframe, kFreezeframe, kDeleteCSection, kExtendDistanceTo5, kFindVFR1, kFindVFR2,
    kPostprocess, kReset, kDecimate, kRangeStart, kSectionStart, kGotoFrame, kSwitch, kTryPattern, kUsePattern, kNoDecimate,
    kNextCLEntry, kPreviousCLEntry, kToggleToolbar, kDeleteCurrentCLEntry, kBackPropagatePreset);

procedure SetDefaultKeys();

implementation

uses keymap;

procedure SetDefaultKeys();
begin
  UpdateMapping(kZoomIn, VK_ADD, [ssShift], 'Zoom in');
  UpdateMapping(kZoomOut, VK_SUBTRACT, [ssShift], 'Zoom out');
  UpdateMapping(kGenericDelete, VK_DELETE, [], 'Generic Delete');
  UpdateMapping(kSelectSWithSameP, Ord('A'), [], 'Select all sections with the same preset');
  UpdateMapping(kUsePattern, Ord('U'), [], 'Use Pattern');
  UpdateMapping(kIgnoreHighVOnPlay, VK_NUMPAD0, [], 'Ignore high vmetric while playing');
  UpdateMapping(kPostprocess, Ord('P'), [], 'Postprocess');
  UpdateMapping(kReset, Ord('R'), [], 'Reset');
  UpdateMapping(kRangeStart, Ord('E'), [], 'Range start');
  UpdateMapping(kGotoFrame, Ord('G'), [], 'Goto frame');
  UpdateMapping(kSwitch, Ord('S'), [], 'Switch');
  UpdateMapping(kTryPattern, Ord('T'), [], 'Try pattern');
  UpdateMapping(kNoDecimate, Ord('O'), [], 'NoDecimate');
  UpdateMapping(kSectionStart, Ord('I'), [], 'Section start');
  UpdateMapping(kDecimate, Ord('D'), [], 'Decimate');
  UpdateMapping(kDeleteCFreezeframe, Ord('Q'), [], 'Delete Current Freezeframe');
  UpdateMapping(kDeleteCSection, Ord('Q'), [ssCtrl], 'Delete Current Section');
  UpdateMapping(kExtendDistanceTo5, Ord('E'), [ssCtrl], 'Extend Distance to 5');
  UpdateMapping(kFindVFR1, Ord('L'), [], 'Find VFR 1');
  UpdateMapping(kFindVFR2, 0, [], 'Find VFR 2');
  UpdateMapping(kFFCToSEnd, Ord('U'), [ssCtrl], 'Freezeframe Current to Section End Frame');
  UpdateMapping(kFFSBeginningToC, Ord('U'), [ssShift], 'Freezeframe Section Beginning to Current Frame');
  UpdateMapping(kFreezeframe, Ord('F'), [], 'Freezeframe');
  UpdateMapping(kFreezeframeSection, Ord('A'), [ssCtrl], 'Freezeframe Section');
  UpdateMapping(kJumpPlus5frames, 0, [], 'Jump +05 frames');
  UpdateMapping(kJumpMinus5frames, 0, [], 'Jump -05 frames');
  UpdateMapping(kJumpPlus10frames, VK_RIGHT, [ssShift], 'Jump +10 frames');
  UpdateMapping(kJumpMinus10frames, VK_LEFT, [ssShift], 'Jump -10 frames');
  UpdateMapping(kJumpPlus50frames, VK_RIGHT, [ssAlt], 'Jump +50 frames');
  UpdateMapping(kJumpMinus50frames, VK_LEFT, [ssAlt], 'Jump -50 frames');
  UpdateMapping(kJump5frames, VK_NUMPAD1, [], 'Move   5 Frames');
  UpdateMapping(kJump10frames, VK_NUMPAD2, [], 'Move  10 Frames');
  UpdateMapping(kJump15frames, VK_NUMPAD3, [], 'Move  15 Frames');
  UpdateMapping(kJump20frames, VK_NUMPAD4, [], 'Move  20 Frames');
  UpdateMapping(kJump25frames, VK_NUMPAD5, [], 'Move  25 Frames');
  UpdateMapping(kJump35frames, VK_NUMPAD6, [], 'Move  35 Frames');
  UpdateMapping(kJump50frames, VK_NUMPAD7, [], 'Move  50 Frames');
  UpdateMapping(kJump75frames, VK_NUMPAD8, [], 'Move  75 Frames');
  UpdateMapping(kJump100frames, VK_NUMPAD9, [], 'Move 100 Frames');
  UpdateMapping(kJumpToNextPP, Ord('M'), [], 'Jump To Next Postprocessed');
  UpdateMapping(kJumpToRangeStart, Ord('J'), [], 'Jump To Range Start');
  UpdateMapping(kJumpToNextPN, Ord('M'), [ssCtrl], 'Jump To Next p/n Match');
  UpdateMapping(kNextSection, VK_UP, [ssCtrl], 'Next Section');
  UpdateMapping(kNextVMatch, VK_UP, [], 'Next V Match');
  UpdateMapping(kNoDecimateS, Ord('O'), [ssCtrl], 'NoDecimate section');
  UpdateMapping(kOpenTryPatternDialog, Ord('T'), [ssCtrl], 'Open Try Pattern Dialog');
  UpdateMapping(kPatternGuidanceOn, Ord('G'), [ssCtrl, ssAlt], 'Pattern Guidance On Section');
  UpdateMapping(kPatternShiftInS, Ord('S'), [ssCtrl], 'Pattern Shift In Section');
  UpdateMapping(kPlay, Ord('Y'), [], 'Play');
  UpdateMapping(kPlayFromSStart, Ord('Y'), [ssCtrl], 'Play From Section Start');
  UpdateMapping(kPostprocessSection, Ord('P'), [ssCtrl], 'Postprocess Section');
  UpdateMapping(kPreviousSection, VK_DOWN, [ssCtrl], 'Previous Section');
  UpdateMapping(kPreviousVMatch, VK_DOWN, [], 'Previous V Match');
  UpdateMapping(kReplaceCFrameWithNext, Ord('F'), [ssCtrl], 'Replace Current Frame With Next');
  UpdateMapping(kReplaceCFrameWithPrevious, Ord('F'), [ssShift], 'Replace Current Frame With Previous');
  UpdateMapping(kResetSection, Ord('R'), [ssCtrl], 'Reset Section');
  UpdateMapping(kSelectLowestVMetricMatches, Ord('B'), [ssCtrl], 'Select Lowest VMetric Matches');
  UpdateMapping(kSwitchCMatchToPN, Ord('W'), [], 'Switch Current Match To p/n');
  UpdateMapping(kTogglePBasedOnFreqOfUse, Ord('K'), [], 'Toggle Preset based on freq. of use');
  UpdateMapping(kTogglePreset, Ord('H'), [], 'Toggle Preset');
  UpdateMapping(kMarkCustomList, Ord('C'), [], 'Mark Start/End for a Custom List');
  UpdateMapping(kPreview, VK_F5, [], 'Preview');
  UpdateMapping(kNextFrame, VK_RIGHT, [], 'Next Frame');
  UpdateMapping(kPreviousFrame, VK_LEFT, [], 'Previous Frame');
  UpdateMapping(kSave, Ord('S'), [ssCtrl, ssAlt], 'Save');
  UpdateMapping(kNextCLEntry, VK_UP, [ssCtrl, ssAlt], 'Jump to next Custom List entry');
  UpdateMapping(kPreviousCLEntry, VK_DOWN, [ssCtrl, ssAlt], 'Jump to previous Custom List entry');
  UpdateMapping(kToggleToolbar, Ord('T'), [ssAlt], 'Toggle Main Window Toolbar');
  UpdateMapping(kDeleteCurrentCLEntry, Ord('Q'), [ssShift], 'Delete Current Custom List entry');
  UpdateMapping(kBackPropagatePreset, VK_RETURN, [ssShift], 'Back propagate the current preset');
end;

end.
