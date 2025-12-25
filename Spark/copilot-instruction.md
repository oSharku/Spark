<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="13142" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="12042"/>
    </dependencies>
    <objects>
        <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner"/>
        <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
    </objects>
</document>
# Spark - Project Instructions

## Tech Stack
- Language: Swift 5+
- Framework: SwiftUI
- Architecture: MVVM (Model-View-ViewModel)
- Database: SwiftData (Targeting iOS 17+)

## Code Style Rules
- UI: Use clean, student-friendly designs. Use SF Symbols.
- Logic: Always separate logic into `ViewModels`. Views should only handle UI.
- Gamification: The app rewards users with "Sparks" for completing tasks.

## Specific Folder Context
- `Views/`: Contains all screens. Always create a #Preview.
- `Models/`: Data structures. Use @Model for SwiftData.
- `Theme/`: Contains colors and font styles.

