class TraderEcoStatsModel {
  final num totalRecycledKg;
  final num treesPlanted;
  final num totalPoints;
  final num totalEarned;
  final num totalRedeemed;
  final int rank;

  TraderEcoStatsModel({
    required this.totalRecycledKg,
    required this.treesPlanted,
    required this.totalPoints,
    required this.totalEarned,
    required this.totalRedeemed,
    required this.rank,
  });

  factory TraderEcoStatsModel.fromJson(Map<String, dynamic> json) {
    return TraderEcoStatsModel(
      totalRecycledKg: json['totalRecycledKg'] ?? 0,
      treesPlanted: json['treesPlanted'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      totalEarned: json['totalEarned'] ?? 0,
      totalRedeemed: json['totalRedeemed'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRecycledKg': totalRecycledKg,
      'treesPlanted': treesPlanted,
      'totalPoints': totalPoints,
      'totalEarned': totalEarned,
      'totalRedeemed': totalRedeemed,
      'rank': rank,
    };
  }

  TraderEcoStatsModel copyWith({
    num? totalRecycledKg,
    num? treesPlanted,
    num? totalPoints,
    num? totalEarned,
    num? totalRedeemed,
    int? rank,
  }) {
    return TraderEcoStatsModel(
      totalRecycledKg: totalRecycledKg ?? this.totalRecycledKg,
      treesPlanted: treesPlanted ?? this.treesPlanted,
      totalPoints: totalPoints ?? this.totalPoints,
      totalEarned: totalEarned ?? this.totalEarned,
      totalRedeemed: totalRedeemed ?? this.totalRedeemed,
      rank: rank ?? this.rank,
    );
  }
}
