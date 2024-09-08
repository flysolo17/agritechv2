import 'package:cloud_firestore/cloud_firestore.dart';

class QRCodes {
  final String id;
  final String phone;
  final String name;
  final String qrCode;
  final bool isDefault;
  final DateTime createdAt;

  const QRCodes({
    required this.id,
    required this.phone,
    required this.name,
    required this.qrCode,
    required this.isDefault,
    required this.createdAt,
  });

  static QRCodes fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data()!;
    return QRCodes(
      id: data['id'] as String,
      phone: data['phone'] as String,
      name: data['name'] as String,
      qrCode: data['qrCode'] as String,
      isDefault: data['isDefault'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(QRCodes qrCode) {
    return {
      'id': qrCode.id,
      'phone': qrCode.phone,
      'name': qrCode.name,
      'qrCode': qrCode.qrCode,
      'isDefault': qrCode.isDefault,
      'createdAt': Timestamp.fromDate(qrCode.createdAt),
    };
  }
}
