import 'package:flutter/material.dart';
import 'package:genix_auctions/core/widgets/footer.dart';
import 'package:genix_auctions/model/auction_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:genix_auctions/core/constants/sapces.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/theme/themes.dart';
import 'package:genix_auctions/core/widgets/custom_dropdown_button.dart';
import 'package:genix_auctions/core/widgets/gradient_button.dart';
import 'package:genix_auctions/core/widgets/logo.dart';
import 'package:genix_auctions/core/widgets/nav_bar.dart';
import 'package:genix_auctions/core/widgets/auction_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _products = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'http://localhost:5000/api/products?page=$_currentPage&limit=$_limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _products.addAll(data['products']);
        _currentPage++;
        _hasMore = _currentPage <= data['totalPages'];
      });
    } else {
      throw Exception('Failed to load products');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(
                height: 82,
              ),
              Container(
                height: 700,
                width: double.infinity,
                color: AppPallete.white,
                child: Stack(
                  children: [
                    Positioned(
                      right: 110,
                      top: 70,
                      child: Image.asset(
                        'assets/background.png',
                        height: 620,
                      ),
                    ),
                    Positioned(
                      left: 200,
                      top: 60,
                      child: SizedBox(
                        width: 500,
                        height: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Gateway \nto Extraordinary Finds',
                              style: TextStyle(
                                fontSize: 62,
                                fontWeight: FontWeight.w100,
                                height: 0,
                              ),
                            ),
                            const Text(
                              'Unlock deals, bid smart, and seize the moment with our online bidding bonanza!',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            Spaces.vspace40,
                            GradientButton(
                              text: 'Watch Video',
                              ontap: () {},
                              radius: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 200,
                      bottom: 20,
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Explore ',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: 'Auctions',
                              style: TextStyle(
                                color: AppPallete.blueText,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 110.0),
                child: Container(
                  width: double.infinity,
                  color: AppPallete.white,
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: _products.map((product) {
                          return AuctionPanel(
                            product: AuctionModel(
                                id: product['_id'],
                                title: product['title'],
                                description: 'description',
                                minimumBidPrice: product['minimumBidPrice'],
                                endDate: "135",
                                currentBidPrice: 1321,
                                imageUrl: product['imageUrl'],
                                reviews: null ?? ['']),
                            time: 681651,
                          );
                          // ListTile(
                          //   title: Text(product['title'] ?? " ..."),
                          //   subtitle: Text(product['description'] ?? "...."),
                          //   leading: Image.network(product['image'] ?? "....."),
                          // );
                        }).toList(),
                      ),
                      if (_hasMore)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: GradientButton(
                            text: 'Load more...',
                            ontap: _fetchProducts,
                          ),
                        ),
                      if (!_hasMore)
                        const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Text(
                            'No more products',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Footer(),
            ],
          ),
          const NavBar(),
        ],
      ),
    );
  }
}

// class AuctionPanel extends StatelessWidget {
//   final List products;

//   const AuctionPanel({Key? key, required this.products}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: products.map((product) {
//         return ListTile(
//           title: Text(product['title'] ?? " ..."),
//           subtitle: Text(product['description'] ?? "...."),
//           leading: Image.network(product['image'] ?? "....."),
//         );
//       }).toList(),
//     );
//   }
// }
