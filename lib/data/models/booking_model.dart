class BookingModel {
  final String id;
  final String hotelId;
  final String roomId;
  final String userId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalAmount;
  final String status;
  final String transactionId;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.hotelId,
    required this.roomId,
    required this.userId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalAmount,
    required this.status,
    required this.transactionId,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      hotelId: json['hotelId'],
      roomId: json['roomId'],
      userId: json['userId'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      guests: json['guests'],
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      transactionId: json['transactionId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'roomId': roomId,
      'userId': userId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalAmount': totalAmount,
      'status': status,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
