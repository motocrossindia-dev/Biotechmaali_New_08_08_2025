#!/bin/bash

# Boot iOS Simulator Script for VS Code Flutter Development

echo "🚀 Starting iOS Simulator setup..."

# Check if a simulator is already booted
BOOTED_SIM=$(xcrun simctl list devices | grep Booted | head -n 1)

if [ -z "$BOOTED_SIM" ]; then
    echo "📱 No simulator currently booted, starting iPhone 15 Pro iOS26..."
    
    # Boot the iPhone 15 Pro iOS26 simulator
    xcrun simctl boot C9949953-1876-4BBC-A653-9997518BEAEC
    
    # Open Simulator app
    open -a Simulator
    
    # Wait a moment for the simulator to fully boot
    echo "⏳ Waiting for simulator to boot completely..."
    sleep 5
    
    echo "✅ iPhone 15 Pro iOS26 simulator is ready!"
else
    echo "✅ Simulator already running: $BOOTED_SIM"
fi

# Verify Flutter can detect the simulator
echo "🔍 Checking Flutter device detection..."
cd "$(dirname "$0")/.."
fvm flutter devices --machine | grep -q ios && echo "✅ Flutter can detect iOS simulator" || echo "❌ Flutter cannot detect iOS simulator"

echo "🎉 iOS Simulator setup complete!"