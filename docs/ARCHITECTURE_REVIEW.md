# Architecture Review

**Package**: responsive_builder2 v0.8.8  
**Date**: 2026-02-08

---

## Overview

responsive_builder2 is a Flutter package that provides widgets and utilities
for building responsive UIs. It helps developers adapt layouts to different
screen sizes (watch, phone, tablet, desktop) and orientations (portrait,
landscape) without scattering conditional logic throughout the codebase.

---

## Architecture Diagram

```
                    ┌─────────────────────┐
                    │  ResponsiveApp      │  (Root wrapper, sets global state)
                    │  - preferDesktop    │
                    │  - screen dimensions│
                    └─────────┬───────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
    ┌─────────▼──────┐ ┌─────▼──────┐ ┌──────▼──────────┐
    │ScreenTypeLayout│ │Orientation │ │RefinedLayout    │
    │  .builder()    │ │LayoutBuilder│ │Builder          │
    │  .builder2()   │ │            │ │                 │
    └────────┬───────┘ └────────────┘ └────────┬────────┘
             │                                  │
             └──────────┬───────────────────────┘
                        │
              ┌─────────▼─────────┐
              │ ResponsiveBuilder │  (Core: LayoutBuilder + MediaQuery)
              │ - SizingInformation│
              └─────────┬─────────┘
                        │
          ┌─────────────┼─────────────┐
          │             │             │
   ┌──────▼──────┐ ┌───▼────┐ ┌──────▼───────────────┐
   │getDeviceType│ │getRefined│ │ResponsiveSizingConfig│
   │             │ │Size     │ │  (Singleton)         │
   └──────┬──────┘ └───┬────┘ └──────────────────────┘
          │            │
   ┌──────▼──────┐     │
   │deviceWidth()│◄────┘  (Conditional import: native/web)
   └─────────────┘

  Separate module:
  ┌─────────────────────┐    ┌──────────────────────┐
  │ScrollTransformView  │───▶│ScrollTransformItem   │
  │ (ScrollController   │    │ (Consumer<Controller>)│
  │  via Provider)      │    └──────────────────────┘
  └─────────────────────┘
```

---

## Component Analysis

### Layer 1: App Configuration

#### `ResponsiveApp` (responsive_wrapper.dart)
- **Role**: Root widget that captures screen dimensions and sets global
  preferences
- **Pattern**: Uses `LayoutBuilder` + `OrientationBuilder` to capture
  constraints
- **State Management**: Static mutable variables in `ResponsiveAppUtil`

**Concerns**:
- Global static state (`ResponsiveAppUtil.width/height/preferDesktop`) means
  only one `ResponsiveApp` can exist meaningfully
- `late` variables have no safe default
- Width/height swap in landscape is semantically incorrect
- No lifecycle management (no disposal, no cleanup)

**Recommendation**: Replace with `InheritedWidget` to scope configuration to
a subtree. This allows multiple `ResponsiveApp` instances (e.g., in different
routes) and eliminates global state.

#### `ResponsiveSizingConfig` (responsive_sizing_config.dart)
- **Role**: Singleton holding global breakpoint configuration
- **Pattern**: Classic singleton with nullable instance

**Concerns**:
- Cannot be fully reset (refined breakpoints persist)
- No way to create separate configs for different app sections
- Singleton makes testing harder (requires manual reset in setUp/tearDown)

**Recommendation**: Either make resettable or convert to an InheritedWidget
so breakpoint configs can be scoped per subtree.

---

### Layer 2: Builder Widgets

#### `ResponsiveBuilder` (widget_builders.dart)
- **Role**: Core widget that provides `SizingInformation` to a builder function
- **Pattern**: `LayoutBuilder` for local constraints + `MediaQuery.sizeOf()`
  for screen size
- **Quality**: Good separation of concerns

**Note**: Uses `LayoutBuilder` which triggers rebuilds on constraint changes.
This is correct behavior for responsive layouts but may cause unnecessary
rebuilds if only the screen-level size matters.

#### `ScreenTypeLayout` (widget_builders.dart)
- **Role**: Switch widget that shows different layouts per device type
- **Pattern**: Three constructors (deprecated, builder, builder2) with
  internal dispatch
- **Quality**: Most complex widget with null-safety issues

**Concerns**:
- Three constructors make the API surface large
- Deprecated constructor still maintained
- Internal `_handleWidgetBuilder`/`_handleWidgetBuilder2` split adds complexity
- Null return paths create crash potential
- `_usingBuilder2()` check is fragile — depends on any builder2 callback being
  non-null

**Recommendation**: Consider deprecating the original constructor entirely and
merging builder/builder2 into a single API with an optional
`SizingInformation` parameter.

#### `OrientationLayoutBuilder` (widget_builders.dart)
- **Role**: Switch widget for portrait/landscape layouts
- **Pattern**: `MediaQuery.orientationOf()` to detect orientation
- **Quality**: Clean and simple

**Note**: Uses `Builder` widget unnecessarily — could use `MediaQuery`
directly in the build method.

#### `RefinedLayoutBuilder` (widget_builders.dart)
- **Role**: Switch widget for refined size categories
- **Pattern**: Uses `ResponsiveBuilder` internally
- **Quality**: Good, follows same pattern as ScreenTypeLayout

---

### Layer 3: Core Logic

#### `getDeviceType` (helpers.dart)
- **Role**: Determines device type from screen size
- **Pattern**: Breakpoint comparison with fallback chain
- **Quality**: Well-structured with clear thresholds

**Concerns**:
- `??=` assignment issue (line 31)
- Uses `width.deviceWidth()` correctly (via conditional import)

#### `getRefinedSize` (helpers.dart)
- **Role**: Determines refined size category
- **Pattern**: Device-type-aware breakpoint comparison
- **Quality**: Functional but verbose

**Concerns**:
- Inlines width calculation instead of using `width.deviceWidth()`
- Duplicated logic between custom and default breakpoint paths (~100 lines of
  near-identical code)
- Watch type always returns `RefinedSize.normal` with custom breakpoints but
  `RefinedSize.small` with defaults — inconsistent behavior

**Recommendation**: Extract breakpoint resolution into a helper to eliminate
duplication:

```dart
RefinedSize _resolveRefinedSize(double width, double small, double normal, double large, double extraLarge) {
  if (width >= extraLarge) return RefinedSize.extraLarge;
  if (width >= large) return RefinedSize.large;
  if (width >= normal) return RefinedSize.normal;
  return RefinedSize.small;
}
```

#### `getValueForScreenType` / `getValueForRefinedSize` (helpers.dart)
- **Role**: Convenience functions returning values based on current device/size
- **Pattern**: MediaQuery + breakpoint lookup + fallback
- **Quality**: Good API, minor issues

**Concerns**:
- `getValueForScreenType` uses `mobile` as parameter name but the concept is
  "phone" everywhere else
- Redundant null check on required `mobile` parameter
- `preferDesktop` check at the end adds global state dependency

---

### Layer 4: Platform Abstraction

#### `device_width.dart` (+ missing `device_width_web.dart`)
- **Role**: Platform-specific width calculation
- **Pattern**: Conditional import (`dart.library.js_interop`)
- **Quality**: Incomplete — web implementation file is missing

**Critical**: The web file doesn't exist, breaking web compilation. This is
the most critical architectural issue.

---

### Separate Module: Scroll Transforms

#### `ScrollTransformView` + `ScrollTransformItem`
- **Role**: Scroll-based visual effects (parallax, scaling)
- **Pattern**: `ScrollController` shared via `Provider`
- **Quality**: Functional but minimal

**Concerns**:
- Adds `provider` as a package dependency for this single feature
- Missing `dispose()` for ScrollController
- `ScrollTransformItem` extends `StatelessWidget` but accesses
  `ScrollController` — should verify controller has clients before accessing
  `.offset`
- Tightly coupled: `ScrollTransformItem` only works inside
  `ScrollTransformView` (or a `ChangeNotifierProvider<ScrollController>`)
  but this constraint isn't enforced

**Recommendation**: Replace `Provider` with `InheritedNotifier<ScrollController>`
to eliminate the `provider` dependency while maintaining the same functionality.

---

## Design Patterns Assessment

### Patterns Used

| Pattern | Where | Assessment |
|---------|-------|-----------|
| Singleton | `ResponsiveSizingConfig` | Problematic for testing and multi-instance scenarios |
| Global Mutable State | `ResponsiveAppUtil` | Anti-pattern; should use InheritedWidget |
| Builder Pattern | `ResponsiveBuilder`, `ScreenTypeLayout` | Good use; core strength of the package |
| Conditional Import | `device_width.dart` | Good idea but incomplete implementation |
| Provider (DI) | `ScrollTransformView` | Overkill; adds dependency for minimal use |
| Strategy Pattern | `getDeviceType`, `getRefinedSize` | Good; allows swappable breakpoints |

### Missing Patterns

1. **InheritedWidget**: Should replace global state for `preferDesktop`,
   screen dimensions, and breakpoint config
2. **Dispose Pattern**: `ScrollTransformView` creates resources without cleanup
3. **Factory/Builder for Breakpoints**: Could provide named constructors for
   common device breakpoint presets (e.g., `ScreenBreakpoints.material()`,
   `ScreenBreakpoints.apple()`)

---

## API Surface Analysis

### Public API Inventory

| Export | Type | Status |
|--------|------|--------|
| `DeviceScreenType` | enum | Active (with 5 deprecated values) |
| `RefinedSize` | enum | Active |
| `SizingInformation` | class | Active |
| `ScreenBreakpoints` | class | Active |
| `RefinedBreakpoints` | class | Active |
| `ResponsiveSizingConfig` | singleton | Active |
| `ResponsiveBuilder` | widget | Active |
| `ScreenTypeLayout` | widget | Active (3 constructors, 1 deprecated) |
| `OrientationLayoutBuilder` | widget | Active |
| `OrientationLayoutBuilderMode` | enum | Active |
| `RefinedLayoutBuilder` | widget | Active |
| `ResponsiveApp` | widget | Active |
| `ResponsiveAppUtil` | utility class | Active (should be internal) |
| `ResponsiveAppExtensions` | extension | Active |
| `WidgetBuilder` | typedef | Active (shadows Flutter type) |
| `WidgetBuilder2` | typedef | Active |
| `ScreenTypeValueBuilder` | class | Deprecated |
| `getDeviceType` | function | Active |
| `getRefinedSize` | function | Active |
| `getValueForScreenType` | function | Active |
| `getValueForRefinedSize` | function | Active |
| `ScrollTransformView` | widget | Active |
| `ScrollTransformItem` | widget | Active |

**Total**: 22 public exports (3 deprecated)

### API Design Issues

1. **`ResponsiveAppUtil` should be private**: Its static methods are
   implementation details, not user-facing API
2. **`WidgetBuilder` typedef should not be exported**: It shadows Flutter's
   built-in type
3. **Mixed naming**: `mobile` vs `phone` used inconsistently across the API
   (`getValueForScreenType` uses `mobile`, `ScreenTypeLayout.builder2` uses
   `phone`)

---

## Scalability Concerns

1. **Adding new device types**: Adding a new device type (e.g., `foldable`,
   `tv`) requires modifying the enum, all helper functions, all widget
   builders, and all test files. There's no extension mechanism.

2. **Adding new refined sizes**: Same issue — tightly coupled to the enum.

3. **Platform-specific behavior**: The conditional import pattern is correct
   but incomplete. Adding more platform-specific logic (e.g., different
   breakpoints for iOS vs Android) would require significant refactoring.

4. **Multi-window support**: The global state pattern makes it impossible to
   support multi-window applications (Flutter desktop) where different windows
   may have different sizes.

---

## Recommended Architecture Changes

### Short-term (Non-breaking) — Safe for patch/minor release

All items below are **NON-BREAKING** or **BEHAVIORAL** bug fixes with low
consumer risk. No public API signatures change. Suitable for a patch version.

| # | Change | Breaking? |
|---|--------|-----------|
| 1 | Create the missing `device_width_web.dart` | NON-BREAKING |
| 2 | Fix null-safety issues in `ScreenTypeLayout` handlers | NON-BREAKING (crash -> graceful fallback) |
| 3 | Add `dispose()` to `ScrollTransformView` | NON-BREAKING |
| 4 | Add breakpoint validation assertions | BEHAVIORAL (debug only, catches invalid inputs) |
| 5 | Initialize `ResponsiveAppUtil` with safe defaults | BEHAVIORAL (crash -> zero default) |

### Medium-term (Minor breaking) — Requires minor version bump

These items change public API signatures or observable behavior. Consumer code
may need minor updates. Should be batched into a single minor release with
migration guide.

| # | Change | Breaking? | Migration |
|---|--------|-----------|-----------|
| 1 | Rename `WidgetBuilder` typedef to `ResponsiveWidgetBuilder` | API-BREAKING | Find-and-replace import |
| 2 | Make `ResponsiveAppUtil` private (prefix with `_`) | API-BREAKING | Consumers using `ResponsiveAppUtil.preferDesktop` directly must switch to `ResponsiveApp(preferDesktop:)` |
| 3 | Split `widget_builders.dart` into per-widget files | NON-BREAKING | No consumer changes if exports remain in barrel file |
| 4 | Split `sizing_information.dart` into data classes and breakpoint classes | NON-BREAKING | No consumer changes if exports remain in barrel file |
| 5 | Replace `provider` dependency with `InheritedNotifier` | NON-BREAKING | Internal refactor; `ScrollTransformView`/`ScrollTransformItem` API unchanged |
| 6 | Fix landscape width/height swap in `setScreenSize` | BEHAVIORAL | Apps using `screenWidth`/`screenHeight` in landscape get correct values; visuals may shift |

### Long-term (Major refactor) — Requires major version bump

These are fundamental architecture changes that alter the package's core
patterns. Consumer code will require non-trivial migration.

| # | Change | Breaking? | Migration effort |
|---|--------|-----------|-----------------|
| 1 | Replace `ResponsiveSizingConfig` singleton with `InheritedWidget` config | API-BREAKING | All `ResponsiveSizingConfig.instance` calls replaced with context lookups |
| 2 | Replace `ResponsiveAppUtil` global state with scoped `InheritedWidget` | API-BREAKING | All static field access replaced with `ResponsiveApp.of(context)` or similar |
| 3 | Unify naming: choose either "mobile" or "phone" across entire API | API-BREAKING | Rename `mobile` parameter to `phone` in `getValueForScreenType`, `ScreenTypeLayout.builder`, etc. |
| 4 | Remove deprecated enum values (`Watch`, `Mobile`, `Tablet`, `Desktop`, `mobile`) | API-BREAKING | Consumer code using deprecated values must switch to lowercase equivalents |
| 5 | Consider a breakpoint registry pattern for extensibility | API-BREAKING | New API for registering custom device types; existing breakpoint classes may change |

---

## Dependency Graph

```
responsive_builder2
├── flutter (SDK)
├── provider ^6.1.5
│   └── (only used by ScrollTransformView/Item)
└── universal_platform ^1.1.0
    └── (used for platform detection in helpers.dart)
```

**Assessment**: The dependency footprint is light. The `provider` dependency
could be eliminated by using Flutter's built-in `InheritedNotifier`, reducing
the package's footprint to a single non-SDK dependency (`universal_platform`).

---

## Summary

The package has a solid foundational design with clear separation between
detection logic (helpers), configuration (config singleton), and presentation
(widget builders). The main architectural weaknesses are:

1. **Global mutable state** instead of widget-tree-scoped state
2. **Incomplete platform abstraction** (missing web file)
3. **Null-safety gaps** in the most critical widget (`ScreenTypeLayout`)
4. **Over-reliance on a singleton** for configuration

### Breaking Change Summary Across All Phases

| Phase | Total items | NON-BREAKING | BEHAVIORAL | API-BREAKING |
|-------|-------------|-------------|------------|--------------|
| Short-term | 5 | 3 | 2 | 0 |
| Medium-term | 6 | 3 | 1 | 2 |
| Long-term | 5 | 0 | 0 | 5 |
| **Total** | **16** | **6** | **3** | **7** |

The short-term fixes (5 items, all non-breaking or behavioral) address all
critical and high-severity bugs while maintaining full backward compatibility.
They can be safely released as a **patch version** (0.8.9).

The medium-term changes (6 items, 2 API-breaking) improve code quality and
should be batched into a **minor version** (0.9.0) with a migration guide.

The long-term refactors (5 items, all API-breaking) are best reserved for a
**major version** (1.0.0) with comprehensive migration documentation.
