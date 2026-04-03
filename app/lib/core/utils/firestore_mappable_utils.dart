import 'package:cloud_firestore/cloud_firestore.dart';

/// Converte estrutura vinda do Firestore para algo que o [dart_mappable] decodifica
/// (ex.: [Timestamp] → [DateTime]) e define o campo `id` com o id do documento.
Map<String, dynamic> firestoreDataToMappableMap(
  Map<String, dynamic> data,
  String documentId,
) {
  final decoded = _decodeFirestoreValue(data) as Map<String, dynamic>;
  decoded['id'] = documentId;
  return decoded;
}

dynamic _decodeFirestoreValue(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is Map) {
    return value.map(
      (k, v) => MapEntry(k.toString(), _decodeFirestoreValue(v)),
    );
  }
  if (value is List) {
    return value.map(_decodeFirestoreValue).toList();
  }
  return value;
}

/// Mapa para o primeiro `add`: sem `id` (o Firestore gera o documento).
Map<String, dynamic> entityMapForFirestoreCreate(Map<String, dynamic> encoded) {
  final m = Map<String, dynamic>.from(encoded);
  m.remove('id');
  return m;
}
