import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genix_auctions/bloc/user_session_bloc.dart';
import 'package:genix_auctions/bloc/user_session_state.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/avatar.dart';
import 'package:genix_auctions/core/widgets/gradient_button.dart';
import 'package:genix_auctions/core/widgets/logo.dart';
import 'package:genix_auctions/core/widgets/nav_button.dart';
import 'package:genix_auctions/core/widgets/nav_items.dart';
import 'package:genix_auctions/core/widgets/product_list_page.dart';
import 'package:genix_auctions/core/widgets/vishnu.dart';
import 'package:genix_auctions/create_product_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  final bool isWhite;
  const NavBar({super.key, this.isWhite = false});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isLogged = false;

  getLog() async {
    final preff = await SharedPreferences.getInstance();
    setState(() {
      isLogged = preff.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    getLog();
  }

  void _showCreateProductDialog(BuildContext context, String ownerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateProductDialog(
          ownerId: ownerId,
          onSave: (product) {
            // Handle the saved product
            print('Product saved: $product');
            context.pop();
            // You can call your API or update state here
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      width: double.infinity,
      color: widget.isWhite ? AppPallete.white : AppPallete.navBar,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            const Logo(),
            const Spacer(flex: 8),
            Wrap(
              spacing: 16,
              children: [
                TextButton(
                    onPressed: () async {
                      final pref = await SharedPreferences.getInstance();
                      String email = pref.getString('user_id')!;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListPage(ownerId: email),
                        ),
                      );
                    },
                    child: Text('update')),
                TextButton(
                    onPressed: () async {
                      final pref = await SharedPreferences.getInstance();
                      String email = pref.getString('user_id')!;
                      _showCreateProductDialog(context, email);
                    },
                    child: Text('create')),
                NavigationButton(
                  text: 'Auctions',
                  subItems: ['Add Auction item', 'summa'],
                ),
                const NavItems(
                  text: 'Auctions',
                  icon: Icons.keyboard_arrow_down_rounded,
                  options: ['Add Item for Auction'],
                ),
                const NavItems(
                    text: 'Bidding',
                    icon: Icons.keyboard_arrow_down_rounded,
                    options: []),
                const NavItems(
                    text: 'About us',
                    icon: Icons.keyboard_arrow_down_rounded,
                    options: []),
                const NavItems(
                    text: 'English',
                    leadingIcon: Icons.translate_rounded,
                    icon: Icons.arrow_drop_down_sharp,
                    options: []),
                isLogged
                    ? const Avatar(imageUrl: '')
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => context.go("/login"),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          GradientButton(
                            text: 'Get Started',
                            ontap: () {},
                          ),
                        ],
                      )
                // BlocBuilder<UserSessionBloc, UserSessionState>(
                //   builder: (context, state) {
                //     if (isLogged!) {
                //       return const Avatar(imageUrl: '');
                //     } else {
                // return Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: InkWell(
                //         onTap: () => context.go("/login"),
                //         child: const Text(
                //           'Login',
                //           style: TextStyle(
                //             color: Colors.blue,
                //           ),
                //         ),
                //       ),
                //     ),
                //     GradientButton(
                //       text: 'Get Started',
                //       ontap: () {},
                //     ),
                //   ],
                // );
                //     }
                //   },
                // )
              ],
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  // void _showCreateProductDialog(BuildContext context, String ownerId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CreateProductDialog(
  //         ownerId: ownerId,
  //         onSave: (product) {
  //           // Handle the saved product
  //           print('Product saved: $product');
  //           // You can call your API or update state here
  //         },
  //       );
  //     },
  //   );
  // }
}
