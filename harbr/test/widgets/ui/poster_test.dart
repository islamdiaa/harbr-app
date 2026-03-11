import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/poster.dart';
import 'package:harbr/widgets/ui/tokens.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('PosterSize', () {
    test('has 5 presets', () {
      expect(PosterSize.values.length, 5);
    });

    test('values are sm, md, lg, xl, hero', () {
      expect(PosterSize.values, [
        PosterSize.sm,
        PosterSize.md,
        PosterSize.lg,
        PosterSize.xl,
        PosterSize.hero,
      ]);
    });
  });

  group('HarbrPoster', () {
    group('size calculations', () {
      testWidgets('sm size is 40px tall', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(size: PosterSize.sm),
        ));

        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(sizedBox.height, 40.0);
      });

      testWidgets('md size is 56px tall (default)', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(),
        ));

        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(sizedBox.height, 56.0);
      });

      testWidgets('lg size is 72px tall', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(size: PosterSize.lg),
        ));

        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(sizedBox.height, 72.0);
      });

      testWidgets('xl size is 96px tall', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(size: PosterSize.xl),
        ));

        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(sizedBox.height, 96.0);
      });

      testWidgets('hero size is 192px tall', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(size: PosterSize.hero),
        ));

        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(sizedBox.height, 192.0);
      });
    });

    group('aspect ratio', () {
      testWidgets('default is 2:3 (width = height / 1.5)', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(size: PosterSize.lg),
        ));

        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(sizedBox.width, 72.0 / 1.5);
      });

      testWidgets('square mode sets width = height', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(size: PosterSize.lg, isSquare: true),
        ));

        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(sizedBox.width, 72.0);
        expect(sizedBox.height, 72.0);
      });
    });

    group('placeholder', () {
      testWidgets('shows placeholder when url is null', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(
            url: null,
            placeholderIcon: Icons.movie_rounded,
          ),
        ));

        expect(find.byIcon(Icons.movie_rounded), findsOneWidget);
      });

      testWidgets('shows placeholder when url is empty', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(
            url: '',
            placeholderIcon: Icons.movie_rounded,
          ),
        ));

        expect(find.byIcon(Icons.movie_rounded), findsOneWidget);
      });

      testWidgets('no icon shown when placeholderIcon is null', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(url: null),
        ));

        // Container should be present but no icon inside it
        expect(find.byType(Icon), findsNothing);
      });
    });

    group('border radius', () {
      testWidgets('defaults to borderRadiusSm', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(),
        ));

        final clipRRect = tester.widget<ClipRRect>(
          find.byType(ClipRRect).first,
        );
        expect(clipRRect.borderRadius, HarbrTokens.borderRadiusSm);
      });

      testWidgets('uses custom borderRadius when provided', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(
            borderRadius: HarbrTokens.borderRadius12,
          ),
        ));

        final clipRRect = tester.widget<ClipRRect>(
          find.byType(ClipRRect).first,
        );
        expect(clipRRect.borderRadius, HarbrTokens.borderRadius12);
      });
    });

    group('overlay widgets', () {
      testWidgets('renders overlay widgets on top', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(
            url: null,
            overlayWidgets: [
              Positioned(
                bottom: 4,
                right: 4,
                child: Text('4K'),
              ),
            ],
          ),
        ));

        expect(find.text('4K'), findsOneWidget);
      });

      testWidgets('no overlay when overlayWidgets is null', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrPoster(url: null),
        ));

        expect(find.text('4K'), findsNothing);
      });
    });
  });
}
