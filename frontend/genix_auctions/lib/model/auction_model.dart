class AuctionModel {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final int minimumBidPrice;
  final int currentBidPrice;
  final String endDate;
  final List<Map<String, dynamic>> reviews;

  AuctionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.minimumBidPrice,
    required this.endDate,
    required this.currentBidPrice,
    required this.imageUrl,
    required this.reviews,
  });

  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    return AuctionModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      minimumBidPrice: json['minimumBidPrice'].toDouble(),
      currentBidPrice: json['currentBidPrice'].toDouble(),
      imageUrl: json['imageUrl'],
      reviews: List<Map<String, dynamic>>.from(json['reviews'] ?? []),
      endDate: json['bidEndingTime'],
    );
  }
}
