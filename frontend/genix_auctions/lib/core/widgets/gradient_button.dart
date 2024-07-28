import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final double radius;
  final void Function()? ontap;
  const GradientButton({
    super.key,
    required this.text,
    this.radius = 3,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppPallete.buttonGradient1,
                AppPallete.buttonGradient2,
                AppPallete.buttonGradient3,
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