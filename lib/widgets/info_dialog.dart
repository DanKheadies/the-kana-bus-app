import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Kana Bus',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 15, width: double.infinity),
            Wrap(
              alignment: WrapAlignment.start,
              // crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Text(
                  'Translate ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  'input ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surfaceBright,
                  ),
                ),
                Text(
                  'into ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  'English',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                Text(
                  ', ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  'Kana',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  ', ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  'and ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  'Romaji',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  '.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'You should add additional keyboards to your device, e.g. Japanese - Romaji, Japanese - Handwriting, Japanese - Kana.',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
            const SizedBox(height: 10),
            Text(
              'On iOS, go to Settings > General > Keyboard > Keyboards > Add New Keyboard.',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
            const SizedBox(height: 25),
            Text(
              'For the Kana Translation, lowercase input will result in hiragana and uppercase text will result in katakana.',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ],
        ),
      ),
    );
  }
}
