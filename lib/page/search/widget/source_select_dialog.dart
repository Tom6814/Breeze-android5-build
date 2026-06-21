import 'package:flutter/material.dart';
import 'package:zephyr/plugin/visible_plugin_policy.dart';

Future<Map<String, bool>?> showSourceSelectDialog(
  BuildContext context, {
  required Map<String, bool> initial,
  required List<({String pluginId, String title})> sourceOptions,
}) {
  final filteredOptions = sourceOptions
      .where((source) => isPluginVisibleInFrontend(source.pluginId))
      .toList(growable: false);
  final next = filterVisibleSourceSelections(initial);
  return showDialog<Map<String, bool>>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('选择漫画源'),
            content: SizedBox(
              width: 320,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final source in filteredOptions)
                    FilterChip(
                      showCheckmark: false,
                      label: Text(source.title),
                      selected: next[source.pluginId] ?? true,
                      onSelected: (selected) {
                        setState(() {
                          next[source.pluginId] = selected;
                        });
                      },
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(next),
                child: const Text('应用'),
              ),
            ],
          );
        },
      );
    },
  );
}
