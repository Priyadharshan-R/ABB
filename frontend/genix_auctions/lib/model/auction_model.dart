class AuctionModel {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final int minimumBidPrice;
  final int currentBidPrice;
  final String endDate;
  final List<String> reviews;

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
}
