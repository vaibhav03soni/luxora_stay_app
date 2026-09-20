import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore? get _db {
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  // Generic method to get a collection
  CollectionReference<Map<String, dynamic>>? collection(String path) {
    return _db?.collection(path);
  }

  // Generic method to get a document
  DocumentReference<Map<String, dynamic>>? document(String path) {
    return _db?.doc(path);
  }

  // Real-time stream of a collection
  Stream<List<T>> streamCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) {
    final db = _db;
    if (db == null) return Stream.value([]);

    Query<Map<String, dynamic>> query = db.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => builder(doc.data(), doc.id)).toList();
    });
  }

  // Fetch a single document
  Future<T?> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) builder,
  }) async {
    final db = _db;
    if (db == null) return null;

    final doc = await db.doc(path).get();
    if (doc.exists && doc.data() != null) {
      return builder(doc.data()!, doc.id);
    }
    return null;
  }

  // Set (Create/Update) data
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    final db = _db;
    if (db == null) return;
    await db.doc(path).set(data, SetOptions(merge: merge));
  }

  // Add data to collection
  Future<DocumentReference?> addData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final db = _db;
    if (db == null) return null;
    return await db.collection(path).add(data);
  }

  // Delete document
  Future<void> deleteDocument({required String path}) async {
    final db = _db;
    if (db == null) return;
    await db.doc(path).delete();
  }
}
