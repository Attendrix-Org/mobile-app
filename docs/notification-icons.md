# Notification icon generation

## Why this exists

Android notification icons cannot be arbitrary app assets — they must be
compiled `drawable` resources under `android/app/src/main/res/drawable-<density>/`,
sized per-density, monochrome, and referenced by resource name (`ic_notification`)
from the Android manifest / notification builder APIs. Flutter's asset bundle
(`assets/`) is opaque to the Android notification system: `flutter_local_notifications`'
`AndroidInitializationSettings('ic_notification')` resolves that string against
Android's `R.drawable` table, not against Flutter's asset bundle. So the PNG
has to physically exist as a native Android resource before Gradle builds the APK —
there's no way to point the notification API at an SVG in `assets/`.

Rather than hand-export five PNGs every time the icon changes, this pipeline
treats `assets/branding/notification_icon.svg` as the single source of truth
and regenerates all five densities automatically.

## Requirements on the source SVG

- Monochrome, white silhouette, transparent background — Android tints
  notification icons itself (white pixels become an outline; anything else
  is likely to render as a solid grey/white blob on notification shades that
  apply their own tint, per Android's status bar icon guidelines).
- Simple enough to survive downscaling to 24×24 (`mdpi`) legibly.

## Pipeline

1. `assets/branding/notification_icon.svg` changes on `main`.
2. `.github/workflows/notification-icons.yml` fires, runs the composite
   action at `.github/actions/generate-notification-icons`, which:
   - installs Inkscape + ImageMagick + optipng,
   - runs `scripts/generate_notification_icons.sh` to render all five
     densities directly from the SVG (each rendered natively at its target
     size, not downscaled from one raster),
   - runs `scripts/optimize_notification_icons.sh` to losslessly compress
     and strip metadata from generated PNGs,
   - runs `scripts/validate_notification_icons.sh` to check each PNG exists,
     is not corrupt/empty, has the exact expected dimensions, and has a
     genuinely transparent (not just alpha-channel-present) background.
3. If validation passes and the PNGs actually changed, the workflow commits
   them back to `main`.
4. The Release APK workflow (`.github/workflows/attendrix-release.yml`) also runs
   the same composite action as its first build step, so every release build
   regenerates the icons from the current SVG directly in its own working
   tree — this makes the release build correct even if it happens to run
   before the commit from step 3 lands (avoids a race between the two
   workflows). One side effect: the icon workflow's own commit to `main`
   will also re-trigger the release workflow; its `check-version` job will
   see the release tag for the current `pubspec.yaml` version already
   exists and skip the build, so this is a no-op re-run, not a duplicate
   release.

## Updating the icon

Edit only `assets/branding/notification_icon.svg` and push to `main` (or
merge a PR that touches it). Do not hand-edit or hand-export any file under
`android/app/src/main/res/drawable-*/ic_notification.png` — they're
regenerated and will be overwritten.

## Running it manually

Actions tab → **Generate Notification Icons** → **Run workflow** → select
`main`. Useful if you want to force-regenerate without changing the SVG
(e.g. after bumping Inkscape/ImageMagick versions, or to re-run validation).

## Regenerating locally

Requires Inkscape ≥1.0, ImageMagick, and optipng on PATH.

```bash
bash scripts/generate_notification_icons.sh
bash scripts/optimize_notification_icons.sh
bash scripts/validate_notification_icons.sh
```

Run all from the repo root. This writes into
`android/app/src/main/res/drawable-*/ic_notification.png` in your working
tree — review with `git diff` before committing.
