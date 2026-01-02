import 'package:flutter/material.dart';

class EnvironmentalRedeemModel {
  final num quantity;
  final num totalPointsUsed;
  final String status;
  final DateTime createdAt;

  EnvironmentalRedeemModel({
    required this.quantity,
    required this.totalPointsUsed,
    required this.status,
    required this.createdAt,
  });

  // Factory constructor for creating instance from JSON
  factory EnvironmentalRedeemModel.fromJson(Map<String, dynamic> json) {
    return EnvironmentalRedeemModel(
      quantity: json['quantity'] as num,
      totalPointsUsed: json['totalPointsUsed'] as num,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'totalPointsUsed': totalPointsUsed,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper method to get status in Arabic
  String get statusInArabic {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد المراجعة';
      case 'approved':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      case 'planted':
        return 'تم الزراعة';
      default:
        return status;
    }
  }

  // Helper method to get status color
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFA500); // Orange
      case 'approved':
        return const Color(0xFF10B981); // Green
      case 'rejected':
        return const Color(0xFFEF4444); // Red
      case 'planted':
        return const Color(0xFF3B82F6); // Blue
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Helper method to check if status is pending
  bool get isPending => status.toLowerCase() == 'pending';

  // Helper method to check if status is approved
  bool get isApproved => status.toLowerCase() == 'approved';

  // Helper method to check if status is rejected
  bool get isRejected => status.toLowerCase() == 'rejected';

  // Helper method to check if status is planted
  bool get isPlanted => status.toLowerCase() == 'planted';

  // Helper method to format date
  String get formattedDate {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }

  // Helper method to get relative time (e.g., "منذ يومين")
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
    } else {
      return 'الآن';
    }
  }

  // CopyWith method for creating modified copies
  EnvironmentalRedeemModel copyWith({
    num? quantity,
    num? totalPointsUsed,
    String? status,
    DateTime? createdAt,
  }) {
    return EnvironmentalRedeemModel(
      quantity: quantity ?? this.quantity,
      totalPointsUsed: totalPointsUsed ?? this.totalPointsUsed,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'EnvironmentalRedeemModel(quantity: $quantity, totalPointsUsed: $totalPointsUsed, status: $status, createdAt: $createdAt)';
  }
}
