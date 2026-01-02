class TopParticipant {
  final UserInfo user;
  final num totalEarned;
  final num totalPoints;
  final num totalRedeemed;

  TopParticipant({
    required this.user,
    required this.totalEarned,
    required this.totalPoints,
    required this.totalRedeemed,
  });

  factory TopParticipant.fromJson(Map<String, dynamic> json) {
    return TopParticipant(
      user: UserInfo.fromJson(json['userId'] ?? {}),
      totalEarned: json['totalEarned'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      totalRedeemed: json['totalRedeemed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': user.toJson(),
      'totalEarned': totalEarned,
      'totalPoints': totalPoints,
      'totalRedeemed': totalRedeemed,
    };
  }
}

class UserInfo {
  final String bussinessName;
  final String rawBusinessType;
  final String bussinessAdress;

  UserInfo({
    required this.bussinessName,
    required this.rawBusinessType,
    required this.bussinessAdress,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      bussinessName: json['bussinessName'] ?? '',
      rawBusinessType: json['rawBusinessType'] ?? '',
      bussinessAdress: json['bussinessAdress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bussinessName': bussinessName,
      'rawBusinessType': rawBusinessType,
      'bussinessAdress': bussinessAdress,
    };
  }
}
