import 'package:todolist/data/source/source.dart';

class Repository<T> implements DataSource<T> {
  final DataSource<T> localDataSource;

  Repository({required this.localDataSource});

  @override
  Future<T> createOrUpdate(T data) {
    return localDataSource.createOrUpdate(data);
  }

  @override
  Future<void> delete(T data) {
    return localDataSource.delete(data);
  }

  @override
  Future<void> deleteAll() {
    return deleteAll();
  }

  @override
  Future<void> deleteById(id) {
    return deleteById(id);
  }

  @override
  Future<T> findById(id) {
    return findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword=''}) {
    return getAll(searchKeyword: searchKeyword);
  }
}
