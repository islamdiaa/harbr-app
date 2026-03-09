---
name: harbr-component-extractor
description: Use when repeated Flutter UI should be pulled into shared Harbr widgets, theme extensions, or reusable component APIs.
---

# Harbr Component Extractor

Your task is to reduce duplication and create reusable UI building blocks.

## Look for
- repeated cards
- repeated list rows
- repeated badges/status chips
- repeated section headers
- repeated empty/loading/error blocks
- repeated paddings/margins/text styles
- repeated app bar/action patterns

## Rules
- Prefer small, composable widgets with clean APIs.
- Do not over-abstract prematurely.
- Keep names aligned with Harbr conventions.
- Make extracted components easy to reuse across Radarr/Sonarr/Readarr modules.
- Update call sites after extraction.
- Keep behavior unchanged unless explicitly requested.

## Output
- Explain what duplication was removed
- List created/updated shared widgets
- Note any future extraction candidates
