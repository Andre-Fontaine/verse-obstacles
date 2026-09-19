# ObstacleTest

A Unreal Editor for Fortnite (UEFN) project for building and testing animated obstacles using Verse. This repository tracks the project's `Content` directory, including the Verse source and the `ObstacleTest` level.

## Overview

The project provides a small, reusable framework for animating Creative props (movement, rotation, and scale) with easing, driven entirely by Verse and Fortnite's Creative Animation system. It's built around a `prop_animator` device that manages one or more props configured to translate toward target props or world-space positions.

## Verse Scripts

- **`movement_behaviors.verse`** — Shared animation utilities. Defines the `move_to_ease_type` enum (`Linear`, `Ease`, `EaseIn`, `EaseOut`, `EaseInOut`) and a set of `MoveToEase()` extension methods on `creative_prop` for animating position, rotation, and/or scale with cubic-bezier easing.
- **`movable_prop.verse`** — Abstract base class (`movable_prop`) that manages the lifecycle of a moving prop: start/end delays, looping movement, optional reset to the starting transform, and optional stop-after-first-move behavior. Subclasses implement `Move()` to define how the prop actually moves.
- **`translating_prop.verse`** — Concrete `movable_prop` subclass (`translating_prop`) that moves a `RootProp` toward either a list of target `creative_prop`s (`MoveTargets`) or a fixed world-space position (`MovePosition`).
- **`prop_animator.verse`** — A `creative_device` that, on game start, calls `Setup()` on each configured `translating_prop` to kick off its movement.

## Getting Started

1. Open `ObstacleTest.uefnproject` in Unreal Editor for Fortnite.
2. Open the `ObstacleTest` level (`ObstacleTest.umap`).
3. Place a `prop_animator` device in the level and populate its `TranslatingProps` array with `translating_prop` actors.
4. Configure each `translating_prop`'s `RootProp`, `MoveTargets` (or `MovePosition`), `MoveDuration`, `MoveEaseType`, and delay/reset options in the editor.
5. Launch a session to test the movement.

## Requirements

- Unreal Editor for Fortnite (UEFN)
- Verse language support
