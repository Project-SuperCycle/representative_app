import 'dart:convert';
import 'package:supercycle/core/models/trader_branch_model.dart';
import 'package:supercycle/core/models/trader_contract_model.dart';
import 'package:supercycle/core/models/trader_main_branch_model.dart';

class UserProfileModel {
  // Basic Info
  final String email;
  final String role;

  // Branchs
  final TraderMainBranchModel? mainBranch;
  final List<TraderBranchModel> branchs;
  final TraderContractModel? contract;

  // Profile
  final String? businessName;
  final String? rawBusinessType;
  final String? businessAddress;
  final String? doshManagerName;
  final String? doshManagerPhone;

  // Stats
  final num? totalShipmentsCount;
  final num? fullyDeliveredCount;
  final num? partiallyDeliveredCount;
  final num? totalShipments;
  final num? delivered;
  final num? failed;

  // Shipments Summary
  final num? scheduledCount;
  final num? manualCount;
  final num? deliveredTotal;
  final num? deliveredInContract;
  final num? deliveredOutContract;

  // Representative
  final String? repPhone;
  final String? repEmail;
  final String? repName;

  UserProfileModel({
    required this.email,
    required this.role,
    required this.businessName,
    required this.rawBusinessType,
    required this.businessAddress,
    required this.doshManagerName,
    required this.doshManagerPhone,
    required this.totalShipmentsCount,
    required this.fullyDeliveredCount,
    required this.partiallyDeliveredCount,
    required this.totalShipments,
    required this.delivered,
    required this.failed,
    required this.scheduledCount,
    required this.manualCount,
    required this.deliveredTotal,
    required this.deliveredInContract,
    required this.deliveredOutContract,
    required this.repPhone,
    required this.repEmail,
    required this.repName,
    required this.mainBranch,
    required this.branchs,
    required this.contract,
  });

  // Factory constructor for creating a new instance from a map (JSON)
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      email: json['basicInfo']['email'] ?? '',
      role: json['basicInfo']['role'] ?? '',
      businessName: (json['profile'] != null)
          ? json['profile']['bussinessName']
          : null,
      rawBusinessType: (json['profile'] != null)
          ? json['profile']['rawBusinessType']
          : null,
      businessAddress: (json['profile'] != null)
          ? json['profile']['bussinessAdress']
          : null,
      doshManagerName: (json['profile'] != null)
          ? json['profile']['doshMangerName']
          : null,
      doshManagerPhone: (json['profile'] != null)
          ? json['profile']['doshMangerPhone']
          : null,
      mainBranch: (json['mainBranch'] != null)
          ? TraderMainBranchModel.fromJson(json['mainBranch'])
          : null,
      branchs: json['branches'] != null
          ? List<TraderBranchModel>.from(
              json['branches'].map(
                (brnach) => TraderBranchModel.fromJson(brnach),
              ),
            )
          : [],
      totalShipmentsCount: (json['stats'] != null)
          ? json['stats']['totalShipmentsCount']
          : null,
      fullyDeliveredCount: (json['stats'] != null)
          ? json['stats']['fullyDeliveredCount']
          : null,
      partiallyDeliveredCount: (json['stats'] != null)
          ? json['stats']['partiallyOrFullyDeliveredCount']
          : null,
      totalShipments: (json['stats'] != null)
          ? json['stats']['totalShipments']
          : null,
      delivered: (json['stats'] != null) ? json['stats']['delivered'] : null,
      failed: (json['stats'] != null) ? json['stats']['failed'] : null,
      scheduledCount: (json['shipmentsSummary'] != null)
          ? json['shipmentsSummary']['scheduledCount']
          : null,
      manualCount: (json['shipmentsSummary'] != null)
          ? json['shipmentsSummary']['manualCount']
          : null,
      deliveredTotal: (json['shipmentsSummary'] != null)
          ? json['shipmentsSummary']['delivered']['total']
          : null,
      deliveredInContract: (json['shipmentsSummary'] != null)
          ? json['shipmentsSummary']['delivered']['inContract']
          : null,
      deliveredOutContract: (json['shipmentsSummary'] != null)
          ? json['shipmentsSummary']['delivered']['outContract']
          : null,

      repPhone: (json['representative'] != null)
          ? json['representative']['phone']
          : null,
      repEmail: (json['representative'] != null)
          ? json['representative']['email']
          : null,
      repName: (json['representative'] != null)
          ? json['representative']['displayName']
          : null,
      contract: (json['contract'] != null)
          ? TraderContractModel.fromJson(json['contract'])
          : null,
    );
  }

  // Convert instance to Map for storage (JSON-safe)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'businessName': businessName,
      'rawBusinessType': rawBusinessType,
      'businessAddress': businessAddress,
      'doshManagerName': doshManagerName,
      'doshManagerPhone': doshManagerPhone,
      'totalShipmentsCount': totalShipmentsCount,
      'fullyDeliveredCount': fullyDeliveredCount,
      'partiallyDeliveredCount': partiallyDeliveredCount,
      'totalShipments': totalShipments,
      'delivered': delivered,
      'failed': failed,
      'scheduledCount': scheduledCount,
      'manualCount': manualCount,
      'deliveredTotal': deliveredTotal,
      'deliveredInContract': deliveredInContract,
      'deliveredOutContract': deliveredOutContract,
      'repPhone': repPhone,
      'repEmail': repEmail,
      'repName': repName,
      'mainBranch': mainBranch != null ? _branchToJsonSafe(mainBranch!) : null,
      'branches': branchs.map((branch) => branch.toJson()).toList(),
      'contract': contract != null ? _contractToJsonSafe(contract!) : null,
    };
  }

  // Helper method to safely convert branch to JSON-compatible map
  Map<String, dynamic>? _branchToJsonSafe(TraderMainBranchModel branch) {
    try {
      final branchMap = branch.toMap();
      // Convert any DateTime objects to ISO8601 strings
      return _convertDateTimesToStrings(branchMap);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? _contractToJsonSafe(TraderContractModel contract) {
    try {
      final contractMap = contract.toJson();
      // Convert any DateTime objects to ISO8601 strings
      return _convertDateTimesToStrings(contractMap);
    } catch (e) {
      return null;
    }
  }

  // Recursively convert DateTime objects to strings in a map
  Map<String, dynamic> _convertDateTimesToStrings(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      if (value is DateTime) {
        result[key] = value.toIso8601String();
      } else if (value is Map<String, dynamic>) {
        result[key] = _convertDateTimesToStrings(value);
      } else if (value is List) {
        result[key] = value.map((item) {
          if (item is DateTime) {
            return item.toIso8601String();
          } else if (item is Map<String, dynamic>) {
            return _convertDateTimesToStrings(item);
          }
          return item;
        }).toList();
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  // Convert instance to JSON string
  String toJson() => json.encode(toMap());

  // Factory constructor to create instance from Map
  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      businessName: map['businessName'],
      rawBusinessType: map['rawBusinessType'],
      businessAddress: map['businessAddress'],
      doshManagerName: map['doshManagerName'],
      doshManagerPhone: map['doshManagerPhone'],
      totalShipmentsCount: map['totalShipmentsCount'] ?? map['totalScheduled'],
      fullyDeliveredCount: map['fullyDeliveredCount'],
      partiallyDeliveredCount: map['partiallyDeliveredCount'],
      totalShipments: map['totalShipments'],
      delivered: map['delivered'],
      failed: map['failed'],
      scheduledCount: map['scheduledCount'],
      manualCount: map['manualCount'],
      deliveredTotal: map['deliveredTotal'],
      deliveredInContract: map['deliveredInContract'],
      deliveredOutContract: map['deliveredOutContract'],
      repPhone: map['repPhone'],
      repEmail: map['repEmail'],
      repName: map['repName'],
      mainBranch: map['mainBranch'] != null
          ? TraderMainBranchModel.fromJson(map['mainBranch'])
          : null,
      branchs: map['branches'] != null
          ? List<TraderBranchModel>.from(
              map['branches'].map(
                (branch) => TraderBranchModel.fromMap(branch),
              ),
            )
          : [],
      contract: map['contract'] != null
          ? TraderContractModel.fromJson(map['contract'])
          : null,
    );
  }

  // CopyWith method for creating a new instance with updated values
  UserProfileModel copyWith({
    String? email,
    String? role,
    String? businessName,
    String? rawBusinessType,
    String? businessAddress,
    String? doshManagerName,
    String? doshManagerPhone,
    TraderMainBranchModel? mainBranch,
    List<TraderBranchModel>? branchs,
    num? totalShipmentsCount,
    num? fullyDeliveredCount,
    num? partiallyDeliveredCount,
    num? totalShipments,
    num? delivered,
    num? failed,
    num? scheduledCount,
    num? manualCount,
    num? deliveredTotal,
    num? deliveredInContract,
    num? deliveredOutContract,
    String? repPhone,
    String? repEmail,
    String? repName,
    TraderContractModel? contract,
  }) {
    return UserProfileModel(
      email: email ?? this.email,
      role: role ?? this.role,
      businessName: businessName ?? this.businessName,
      rawBusinessType: rawBusinessType ?? this.rawBusinessType,
      businessAddress: businessAddress ?? this.businessAddress,
      doshManagerName: doshManagerName ?? this.doshManagerName,
      doshManagerPhone: doshManagerPhone ?? this.doshManagerPhone,
      mainBranch: mainBranch ?? this.mainBranch,
      branchs: branchs ?? this.branchs,
      totalShipmentsCount: totalShipmentsCount ?? this.totalShipmentsCount,
      fullyDeliveredCount: fullyDeliveredCount ?? this.fullyDeliveredCount,
      partiallyDeliveredCount:
          partiallyDeliveredCount ?? this.partiallyDeliveredCount,
      totalShipments: totalShipments ?? this.totalShipments,
      delivered: delivered ?? this.delivered,
      failed: failed ?? this.failed,
      scheduledCount: scheduledCount ?? this.scheduledCount,
      manualCount: manualCount ?? this.manualCount,
      deliveredTotal: deliveredTotal ?? this.deliveredTotal,
      deliveredInContract: deliveredInContract ?? this.deliveredInContract,
      deliveredOutContract: deliveredOutContract ?? this.deliveredOutContract,
      repPhone: repPhone ?? this.repPhone,
      repEmail: repEmail ?? this.repEmail,
      repName: repName ?? this.repName,
      contract: contract ?? this.contract,
    );
  }

  @override
  String toString() {
    return '''
═══════════════════════════════════════════════════════════
                    USER PROFILE
═══════════════════════════════════════════════════════════

📧 BASIC INFO:
   Email: $email
   Role: $role

🏢 BUSINESS INFO:
   Business Name: ${businessName ?? 'N/A'}
   Business Type: ${rawBusinessType ?? 'N/A'}
   Business Address: ${businessAddress ?? 'N/A'}
   Dosh Manager: ${doshManagerName ?? 'N/A'}
   Manager Phone: ${doshManagerPhone ?? 'N/A'}

📊 STATISTICS:
   Total Shipments: ${totalShipmentsCount ?? 'N/A'}
   Fully Delivered: ${fullyDeliveredCount ?? 'N/A'}
   Partially Delivered: ${partiallyDeliveredCount ?? 'N/A'}
   Total Shipments (Stats): ${totalShipments ?? 'N/A'}
   Delivered: ${delivered ?? 'N/A'}
   Failed: ${failed ?? 'N/A'}

📦 SHIPMENTS SUMMARY:
   Scheduled Count: ${scheduledCount ?? 'N/A'}
   Manual Count: ${manualCount ?? 'N/A'}
   Delivered Total: ${deliveredTotal ?? 'N/A'}
   Delivered In Contract: ${deliveredInContract ?? 'N/A'}
   Delivered Out Contract: ${deliveredOutContract ?? 'N/A'}

👤 REPRESENTATIVE:
   Name: ${repName ?? 'N/A'}
   Phone: ${repPhone ?? 'N/A'}
   Email: ${repEmail ?? 'N/A'}

🏪 MAIN BRANCH:
${mainBranch != null ? mainBranch.toString().split('\n').map((line) => '   $line').join('\n') : '   No main branch available'}

📍 BRANCHES (${branchs.length}):
${branchs.isEmpty ? '   No branches available' : branchs.asMap().entries.map((entry) => '\n   Branch ${entry.key + 1}:\n${entry.value.toString().split('\n').map((line) => '   $line').join('\n')}').join('\n')}

📝 CONTRACT:
${contract != null ? contract.toString().split('\n').map((line) => '   $line').join('\n') : '   No contract available'}

═══════════════════════════════════════════════════════════
''';
  }
}
