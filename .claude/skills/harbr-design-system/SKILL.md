---
name: harbr-design-system
description: Use when redesigning Harbr UI, building shared visual language, or updating Flutter components to match a modern slick media-management app.
---

# Harbr Design System

You are working on Harbr, a Flutter app for Radarr/Sonarr/Readarr-style media server workflows.

## Goals
- Make the app feel premium, dense, fast, and modern.
- Prefer a clean dark-first aesthetic suitable for Unraid / self-hosted / media-stack users.
- Reduce visual clutter while preserving high information density.
- Build reusable primitives first, then compose screens from them.

## Design rules
- Prefer consistent spacing scale and radii across the app.
- Prefer strong hierarchy: page title, section title, metadata, status, actions.
- Use a restrained color system with semantic status colors.
- Make cards and list rows feel tactile but not heavy.
- Avoid random per-screen styling.
- Favor shared widgets/tokens over inline styling.

## Flutter implementation rules
- Reuse and improve shared components before introducing one-off UI.
- Extract colors, spacing, typography, elevation, and state styles into shared theme/component code.
- Keep dark mode and AMOLED behavior consistent.
- Preserve navigation and business logic unless explicitly changing UX flow.

## Output expectations
When invoked:
1. Audit current UI patterns.
2. Propose the design tokens/components to introduce or normalize.
3. Implement shared Flutter components first.
4. Update affected screens to use them.
5. Summarize what became reusable.
