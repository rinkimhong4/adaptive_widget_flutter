import 'package:example/api/config/api_service.dart';
import 'package:example/repositories/base_repository.dart';
import 'package:flutter/foundation.dart';

enum CrudStatus { idle, loading, success, error }

/// Generic CRUD provider built on a [BaseRepository].
/// Handles list state, selection, loading flags, and errors.
class BaseCrudProvider<T> extends ChangeNotifier {
  final BaseRepository<T> repository;

  /// Tells the provider how to read an item's id.
  final dynamic Function(T) idSelector;

  BaseCrudProvider({required this.repository, required this.idSelector});

  List<T> items = [];
  T? selected;
  CrudStatus status = CrudStatus.idle;
  String? errorMessage;

  bool get isLoading => status == CrudStatus.loading;
  bool get hasError => status == CrudStatus.error;
  bool get isEmpty => items.isEmpty;

  void _setStatus(CrudStatus s, {String? error}) {
    status = s;
    errorMessage = error;
    notifyListeners();
  }

  Future<void> fetchAll({Map<String, String>? queryParams}) async {
    _setStatus(CrudStatus.loading);
    try {
      items = await repository.getAll(queryParams: queryParams);
      _setStatus(CrudStatus.success);
    } on ApiException catch (e) {
      _setStatus(CrudStatus.error, error: e.message);
    } catch (e) {
      _setStatus(CrudStatus.error, error: e.toString());
    }
  }

  Future<void> fetchById(dynamic id) async {
    _setStatus(CrudStatus.loading);
    try {
      selected = await repository.getById(id);
      _setStatus(CrudStatus.success);
    } on ApiException catch (e) {
      _setStatus(CrudStatus.error, error: e.message);
    } catch (e) {
      _setStatus(CrudStatus.error, error: e.toString());
    }
  }

  Future<bool> create(T item) async {
    _setStatus(CrudStatus.loading);
    try {
      final created = await repository.create(item);
      items.add(created);
      _setStatus(CrudStatus.success);
      return true;
    } on ApiException catch (e) {
      _setStatus(CrudStatus.error, error: e.message);
      return false;
    } catch (e) {
      _setStatus(CrudStatus.error, error: e.toString());
      return false;
    }
  }

  Future<bool> update(dynamic id, T item) async {
    _setStatus(CrudStatus.loading);
    try {
      final updated = await repository.update(id, item);
      final index = items.indexWhere((e) => idSelector(e) == id);
      if (index != -1) {
        items[index] = updated;
      }
      _setStatus(CrudStatus.success);
      return true;
    } on ApiException catch (e) {
      _setStatus(CrudStatus.error, error: e.message);
      return false;
    } catch (e) {
      _setStatus(CrudStatus.error, error: e.toString());
      return false;
    }
  }

  Future<bool> delete(dynamic id) async {
    _setStatus(CrudStatus.loading);
    try {
      await repository.delete(id);
      items.removeWhere((e) => idSelector(e) == id);
      _setStatus(CrudStatus.success);
      return true;
    } on ApiException catch (e) {
      _setStatus(CrudStatus.error, error: e.message);
      return false;
    } catch (e) {
      _setStatus(CrudStatus.error, error: e.toString());
      return false;
    }
  }

  void clearSelected() {
    selected = null;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    if (status == CrudStatus.error) status = CrudStatus.idle;
    notifyListeners();
  }
}
