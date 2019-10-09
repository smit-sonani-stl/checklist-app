import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ChecklistItemsDAO {
  final _items = BehaviorSubject<List<ChecklistItem>>.seeded([]);

  void dispose() {
    _items.close();
  }

  Future<ChecklistItem> getItem(String id) async {
    final index = _getItemIndex(id: id);
    return _items.value[index];
  }

  Stream<List<ChecklistItem>> getAllItems() {
    return _items;
  }

  Stream<List<ChecklistItem>> getUnscheduledItems() {
    return _items.map(
      (list) => list.where((i) => i.targetDate == null).toList(),
    );
  }

  Stream<List<ChecklistItem>> getItemsForDate({@required DateTime date}) {
    return getItemsInDateRange(startDate: date, endDate: date);
  }

  Stream<List<ChecklistItem>> getItemsInDateRange({
    @required DateTime startDate,
    @required DateTime endDate,
  }) {
    return _items.map(
      (list) => list
          .where((i) => i.targetDate != null)
          .where((i) =>
              i.targetDate.millisecondsSinceEpoch >=
              startDate.millisecondsSinceEpoch)
          .where((i) =>
              i.targetDate.millisecondsSinceEpoch <=
              endDate.millisecondsSinceEpoch)
          .toList(),
    );
  }

  Future<ChecklistItem> insert({@required ChecklistItem item}) async {
    final list = _items.value;
    list.add(item);
    _items.add(list);
    return item;
  }

  Future<void> update({@required ChecklistItem item}) async {
    final index = _getItemIndex(id: item.id);
    final items = _items.value;
    items[index] = item;
    return _items.add(items);
  }

  Future<void> delete({@required String id}) async {
    final list = _items.value;
    list.removeWhere((item) => item.id == id);
    return _items.add(list);
  }

  int _getItemIndex({@required id}) {
    final index = _items.value.indexWhere((item) => item.id == id);
    if (index == null) {
      throw ItemNotFoundException(id);
    }
    return index;
  }
}
