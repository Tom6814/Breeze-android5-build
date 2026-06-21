const Set<String> _visiblePluginIds = {'jm'};

String normalizePluginId(String raw) => raw.trim().toLowerCase();

bool isPluginVisibleInFrontend(String raw) {
  final normalized = normalizePluginId(raw);
  if (normalized.isEmpty) {
    return false;
  }
  return _visiblePluginIds.contains(normalized);
}

Iterable<T> filterFrontendVisiblePlugins<T>(
  Iterable<T> items,
  String Function(T item) pluginIdOf,
) {
  return items.where((item) => isPluginVisibleInFrontend(pluginIdOf(item)));
}

Map<String, bool> filterVisibleSourceSelections(
  Map<String, bool> selections, {
  bool fallbackToJm = true,
}) {
  final filtered = Map<String, bool>.fromEntries(
    selections.entries.where((entry) => isPluginVisibleInFrontend(entry.key)),
  );
  if (filtered.isEmpty && fallbackToJm) {
    return const {'jm': true};
  }
  return filtered;
}
