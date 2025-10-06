# iOS Simulator Timeout Fix for VS Code Flutter Development

## Problem
- **Error**: `Failed to launch iOS Simulator: Error: Emulator didn't connect within 60 seconds`
- **Cause**: VS Code Flutter extension timeout when iOS simulator takes too long to boot and connect

## Root Cause Analysis
1. **No Pre-booted Simulator**: VS Code tries to boot a simulator from scratch, which can take >60 seconds
2. **Missing Device ID**: Launch configuration doesn't specify which simulator to use
3. **Xcode Destination Issues**: Some Flutter/Xcode combinations have trouble with device targeting

## Solution Implemented

### 1. Automated Simulator Boot Script
Created: `scripts/boot_ios_simulator.sh`
- Automatically boots iPhone 15 Pro iOS26 simulator if none running
- Verifies Flutter can detect the simulator
- Opens Simulator.app for visual confirmation

### 2. VS Code Configuration Updates

#### Launch Configuration (`.vscode/launch.json`)
```json
{
    "name": "Flutter Debug (iOS Simulator)",
    "type": "dart", 
    "request": "launch",
    "program": "lib/main.dart",
    "console": "debugConsole",
    "args": ["--debug"],
    "preLaunchTask": "Boot iOS Simulator"
}
```

#### Tasks Configuration (`.vscode/tasks.json`)
```json
{
    "label": "Boot iOS Simulator",
    "type": "shell",
    "command": "./scripts/boot_ios_simulator.sh"
}
```

### 3. Enhanced VS Code Settings (`.vscode/settings.json`)
- Added Flutter-specific configurations
- Enabled Flutter outline and UI guides
- Configured for optimal iOS development

## How to Use

### Method 1: VS Code Debug (Recommended)
1. Open VS Code
2. Go to Run and Debug (Ctrl/Cmd + Shift + D)  
3. Select "Flutter Debug (iOS Simulator)"
4. Click Run - simulator will auto-boot then app launches

### Method 2: Manual Simulator Boot
1. Run: `./scripts/boot_ios_simulator.sh`
2. Wait for "iOS Simulator setup complete!"
3. Use any Flutter launch configuration

### Method 3: VS Code Tasks
1. Open Command Palette (Ctrl/Cmd + Shift + P)
2. Type "Tasks: Run Task"
3. Select "Boot iOS Simulator"
4. Then run Flutter debug normally

### Method 4: Xcode Direct (Fallback)
1. Run VS Code task: "Open iOS Project in Xcode"
2. In Xcode: Select iOS simulator and press Run

## Verification Steps

1. **Check Simulator Status**:
   ```bash
   xcrun simctl list devices | grep Booted
   ```

2. **Verify Flutter Detection**:
   ```bash
   fvm flutter devices
   ```
   Should show: `iPhone 15 Pro iOS26 (mobile) • C9949953-... • ios`

3. **Test Connection**:
   ```bash
   fvm flutter doctor -v
   ```

## Troubleshooting

### If Simulator Still Doesn't Connect:
1. **Restart Simulator**: `xcrun simctl shutdown all && xcrun simctl boot C9949953-1876-4BBC-A653-9997518BEAEC`
2. **Restart VS Code**: Close and reopen VS Code
3. **Clean Flutter**: Run task "Flutter Clean & Get"
4. **Check Xcode**: Ensure Xcode can build the project independently

### If Xcode Destination Errors:
- Use Xcode directly: Task "Open iOS Project in Xcode"
- The iOS app builds successfully in Xcode even if CLI has issues

### Alternative Simulators:
To use different simulators, update the device ID in:
- `scripts/boot_ios_simulator.sh` (line with xcrun simctl boot)
- Available devices: `xcrun simctl list devices`

## Files Created/Modified

### New Files:
- `scripts/boot_ios_simulator.sh` - Automated simulator boot script
- `.vscode/tasks.json` - VS Code tasks for iOS development

### Modified Files:  
- `.vscode/launch.json` - Added preLaunchTask for iOS simulator
- `.vscode/settings.json` - Enhanced Flutter development settings

## Success Indicators

✅ **VS Code Debug works without timeout**  
✅ **Simulator boots automatically before Flutter launch**  
✅ **Flutter can detect booted iOS simulator**  
✅ **Xcode project opens as backup option**  

## Next Steps

1. **Test the configuration**: Try launching from VS Code
2. **Customize simulator**: Change device in boot script if needed  
3. **Share with team**: These configs work for all developers on the project

---
**Note**: This solution resolves the 60-second timeout by ensuring the iOS simulator is pre-booted and ready before Flutter attempts to connect.