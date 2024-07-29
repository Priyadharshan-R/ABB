import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/avatar.dart';
import 'package:genix_auctions/core/widgets/gradient_button.dart';
import 'package:genix_auctions/core/widgets/logo.dart';
import 'package:genix_auctions/core/widgets/product_list_page.dart';
import 'package:genix_auctions/create_product_dialog.dart';
import 'package:genix_auctions/service/log.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  final bool isWhite;
  const NavBar({Key? key, this.isWhite = false}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isLogged = false;
  String? email;

  @override
  void initState() {
    super.initState();
    _getLog();
  }

  Future<void> _getLog() async {
    final pref = await SharedPreferences.getInstance();
    LogData().getLogData;
    setState(() {
      isLogged = pref.getBool('isLoggedIn') ?? false;
      email = pref.getString('user_id');
    });
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
                if (isLogged) ...[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductListPage(ownerId: email!),
                        ),
                      );
                    },
                    child: Text('Update'),
                  ),
                  TextButton(
                    onPressed: () {
                      _showCreateProductDialog(context, email!);
                    },
                    child: Text('Create'),
                  ),
                  const Avatar(
                    imageUrl: '',
                  ),
                ] else ...[
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
                    ontap: () {
                      context.go('/signup');
                    },
                  ),
                ],
              ],
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
