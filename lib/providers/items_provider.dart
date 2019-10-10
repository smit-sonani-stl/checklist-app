import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/utils/list_mode_utils.dart';
import 'package:meta/meta.dart';

class ItemsProvider {
  final ChecklistItemsRepository repository;
  final modeUtils = ListModeUtils();

  ItemsProvider({
    @required this.repository,
  });

  Stream<List<ChecklistItem>> watchItems(ListMode mode) {
    Stream<List<ChecklistItem>> stream;
    switch (mode) {
      case ListMode.today:
      case ListMode.thisWeek:
      case ListMode.thisMonth:
        final dates = modeUtils.getDatesForMode(mode);
        stream = repository.getItemsInDateRange(
          startDate: dates['start_date'],
          endDate: dates['end_date'],
        );
        break;
      case ListMode.all:
        stream = repository.getAllItems();
        break;
    }
    return stream;
  }
}
