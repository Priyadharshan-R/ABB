import 'dart:async';
import 'dart:convert';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/auction_panel.dart';
import 'package:genix_auctions/core/widgets/nav_bar.dart';
import 'package:genix_auctions/core/widgets/review_widget.dart';
import 'package:genix_auctions/service/log.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:genix_auctions/model/auction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late Stream<Map<String, dynamic>> productDataStream;
  final TextEditingController bidController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  late final String username;

  @override
  void dispose() {
    bidController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Login',
        onPressed: () {
          context.go('/login');
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    getLog();
    productDataStream =
        Stream.periodic(Duration(seconds: 1)).asyncMap((_) => _fetchProduct());
  }

  Future<void> getLog() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString('username') ?? '';
    });
  }

  Future<Map<String, dynamic>> _fetchProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://localhost:5000/api/products/${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      showSnackBar(context, 'Session Expired. Please log in again.');
      context.go('/login');
      throw Exception('Failed to load product: Session expired');
    } else {
      throw Exception('Failed to load product: ${response.body}');
    }
  }

  Future<void> _submitBid() async {
    final straightBid = int.parse(bidController.text);

    final bidData = {
      'username': username,
      'price': straightBid,
      'productId': widget.id,
    };

    final response = await http.put(
      Uri.parse('http://localhost:5000/api/bids'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bidData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context).pop();
    } else {
      if (response.statusCode == 402) {
        Navigator.of(context).pop();
        showSnackBar(context, 'You cannot place consecutive bids');
      } else {
        print('Failed to submit bid: ${response.body}');
      }
    }
  }

  Future<void> _submitReview() async {
    final reviewText = reviewController.text;

    final reviewData = {
      'username': username,
      'review': reviewText,
      'productId': widget.id,
    };
    print(reviewData);

    final response = await http.put(
      Uri.parse('http://localhost:5000/api/products/reviews'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reviewData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        reviewController.clear(); // Clear the review field after submission
      });
    } else {
      showSnackBar(context, 'Failed to submit review: ${response.body}');
    }
  }

  void showBidDialog(String name, double currentBid, String endTime) {
    final end = DateTime.parse(endTime);
    final timeDef = end.difference(DateTime.now());

    showDialog(
      barrierColor: const Color.fromARGB(0, 255, 255, 255),
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.4),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 480, vertical: 190),
            child: BlurryContainer(
              color: AppPallete.white,
              blur: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Submit Bid | ',
                                  style: TextStyle(
                                    fontFamily: 'Outfit-Bold',
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 17,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              'Ends in : ${timeDef.inDays} days ${(timeDef.inHours % 24)} hours ${(timeDef.inMinutes % 60)} mins',
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                              ),
                            )
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current bid : ',
                          style: TextStyle(
                            fontFamily: 'Outfit-Bold',
                          ),
                        ),
                        Text(
                          '\$ $currentBid',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 50),
                    child: TextFormField(
                      controller: bidController,
                      decoration: const InputDecoration(
                        labelText: 'Straight bid',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: _submitBid,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 45, 55, 255),
                            Color.fromARGB(255, 97, 184, 255),
                          ],
                        ),
                      ),
                      width: 130,
                      height: 50,
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Bid Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Outfit',
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      body: ListView(
        children: [
          const NavBar(),
          StreamBuilder<Map<String, dynamic>>(
            stream: productDataStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                var productData = snapshot.data!;
                List<dynamic> reviews = productData['reviews'] ?? [];
                print(reviews);

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
                              product: AuctionModel.fromJson(productData),
                              time: productData['bidEndingTime'].toString(),
                              hasShadow: false,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Description',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(
                                productData['description'] ??
                                    'No description available',
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 30),
                            const Text('Reviews',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            if (reviews.isEmpty)
                              const SizedBox(child: Text('No Reviews yet'))
                            else
                              ...reviews.map<Widget>((review) {
                                final reviewMap =
                                    review as Map<String, dynamic>;
                                print(reviewMap);
                                return ReviewWidget(
                                  name: reviewMap['name'],
                                  date: reviewMap['date'],
                                  review: reviewMap['review'],
                                  rating: reviewMap['rating'],
                                );
                              }).toList(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              child: TextFormField(
                                controller: reviewController,
                                decoration: const InputDecoration(
                                  labelText: 'Add a review',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _submitReview,
                              child: const Text('Submit Review'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  reverse: false,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      (productData['bids'] as List).length,
                                  itemBuilder: (context, index) {
                                    final bid = productData['bids'][index];
                                    return Text(
                                      "${bid['username']}    \$${bid['price']}",
                                      style: TextStyle(fontSize: 14),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                showBidDialog(
                                    productData['title'],
                                    productData['currentBidPrice'].toDouble(),
                                    productData['bidEndingTime'].toString());
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Bid now'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ],
      ),
    );
  }
}
