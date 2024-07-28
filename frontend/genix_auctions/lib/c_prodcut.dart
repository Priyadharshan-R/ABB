import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:genix_auctions/bid_dialog.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/auction_panel.dart';
import 'package:genix_auctions/core/widgets/nav_bar.dart';
import 'package:genix_auctions/core/widgets/review_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:genix_auctions/model/auction_model.dart';
import 'package:google_fonts/google_fonts.dart';

class CProduct extends StatefulWidget {
  final String id;

  const CProduct({
    super.key,
    required this.id,
  });

  @override
  State<CProduct> createState() => _CProductState();
}

class _CProductState extends State<CProduct> {
  late Future<Map<String, dynamic>> productData;

  @override
  void initState() {
    super.initState();
    productData = _fetchProduct();
  }

  Future<Map<String, dynamic>> _fetchProduct() async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/api/products/${widget.id}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>> _fetchBidsData(String id) async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/bids/${id}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      body: ListView(
        children: [
          const NavBar(),
          FutureBuilder<Map<String, dynamic>>(
            future: productData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                var productData = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60, vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                context.go('/home');
                              },
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.blue),
                              label: const Text('Back to catalog',
                                  style: TextStyle(color: Colors.blue)),
                            ),
                            AuctionPanel(
                              product: AuctionModel(
                                id: productData['_id'],
                                title: productData['title'],
                                description: productData['description'],
                                minimumBidPrice: 123,
                                endDate: "3553",
                                currentBidPrice: 132,
                                imageUrl: productData['imageUrl'],
                                reviews: [''],
                              ),
                              time: 46,
                              hasShadow: false,
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(width: 0),
                      const Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Immerse yourself in pristine sound quality with the Sony Black Headphones. Crafted for audiophiles and casual listeners alike, these headphones deliver an exceptional audio experience with deep, resonant bass and crystal-clear highs. The sleek black design complements any style, whether you\'re on the go or relaxing at home.\n\nEquipped with advanced noise-canceling technology, these headphones block out distractions so you can enjoy your music, podcasts, or calls without interference. Comfort is key with plush ear cushions that provide long-lasting comfort for extended listening sessions.\n\nDesigned for convenience, these headphones feature easy-to-use controls for adjusting volume, skipping tracks, and taking calls on the go. Foldable and compact, they\'re perfect for travel and storage, ensuring you can take your music with you wherever you go.\n\nWhether you\'re commuting, working out, or simply unwinding, the Sony Black Headphones offer premium sound quality and comfort that elevate your listening experience to new heights.',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Reviews',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ReviewWidget(
                              name: 'Kristin Watson',
                              date: 'March 14, 2021',
                              review:
                                  'These headphones are a game-changer for my daily commute. The noise-canceling feature works like a charm.',
                              rating: 5,
                            ),
                            ReviewWidget(
                              name: 'Jenny Wilson',
                              date: 'January 28, 2021',
                              review:
                                  'Im blown away by the sound clarity these headphones offer.',
                              rating: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 32),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            SizedBox(),
                            Container(
                              height: 400,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: productData['bids'].length,
                                  itemBuilder: (context, index) {
                                    print(productData);
                                    return Text(
                                        "${productData['bids'][index]['username'].toString()}    ${productData['bids'][index]['price'].toString()}");
                                  }),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => BidDialog(
                                    productName: productData['title'],
                                    minimumBid: double.parse(
                                        productData['minimumBidPrice']
                                            .toString()),
                                    currentBid: double.parse(
                                        productData['currentBidPrice']
                                            .toString()),
                                    endTime:
                                        productData['bidEndingTime'].toString(),
                                    productId: productData['_id'].toString(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                // primary: Colors.blue,
                              ),
                              child: Text('Bid now'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: Text('No data available'));
              }
            },
          ),
        ],
      ),
    );
  }
}
