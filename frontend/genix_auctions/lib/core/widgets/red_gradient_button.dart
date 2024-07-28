import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';

class RedGradientButton extends StatelessWidget {
  final String text;
  final void Function()? ontap;
  const RedGradientButton({
    super.key,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: ontap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  AppPallete.redButtonGradient1,
                  AppPallete.redButtonGradient2,
                  AppPallete.redButtonGradient3,
                ],
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: AppPallete.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Center(
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(radius),
//         child: Stack(
//           children: <Widget>[
//             Positioned.fill(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(colors: [
//                     AppPallete.buttonGradient1,
//                     AppPallete.buttonGradient2,
//                     AppPallete.buttonGradient3,
//                   ],),
//                 ),
//                 child: Text(text),
//               ),
//             ),
            
//           ],
//         ),
//       ),
//     );