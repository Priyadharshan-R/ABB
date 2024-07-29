// import 'package:blurrycontainer/blurrycontainer.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class BidDialog extends StatefulWidget {
//   final String productName;
//   final double minimumBid;
//   final double currentBid;
//   final String endTime;
//   final String productId;

//   const BidDialog({
//     super.key,
//     required this.productName,
//     required this.minimumBid,
//     required this.currentBid,
//     required this.endTime,
//     required this.productId,
//   });

//   @override
//   _BidDialogState createState() => _BidDialogState();
// }

// class _BidDialogState extends State<BidDialog> {
//   final BidController = TextEditingController();

//   @override
//   void dispose() {
//     BidController.dispose();
//     super.dispose();
//   }

//   show(name, currentBid, endTime) {
//     final end = DateTime.parse(endTime);
//     final timeDef = end.difference(DateTime.now());
//     showDialog(
//       barrierColor: const Color.fromARGB(0, 255, 255, 255),
//       context: context,
//       builder: (BuildContext context) {
//         return Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 480, vertical: 190),
//             child: BlurryContainer(
//               color: const Color.fromARGB(115, 255, 255, 255),
//               blur: 10,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 50, vertical: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           children: [
//                             Row(
//                               children: [
//                                 const Text(
//                                   'Submit Bid | ',
//                                   style: TextStyle(
//                                     fontFamily: 'Outfit-Bold',
//                                     fontSize: 20,
//                                   ),
//                                 ),
//                                 Text(
//                                   name,
//                                   style: const TextStyle(
//                                     fontFamily: 'Outfit',
//                                     fontSize: 17,
//                                   ),
//                                 )
//                               ],
//                             ),
//                             Text(
//                               'Ends in : ${timeDef.inDays} days ${(timeDef.inHours) % 24} hours ${(timeDef.inMinutes) % 60} mins',
//                               style: const TextStyle(
//                                 fontFamily: 'Outfit',
//                               ),
//                             )
//                           ],
//                         ),
//                         InkWell(
//                           onTap: () => context.pop(),
//                           child: const Icon(Icons.close_rounded),
//                         )
//                       ],
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 50, vertical: 20),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Current bid : ',
//                               style: TextStyle(
//                                 fontFamily: 'Outfit-Bold',
//                               ),
//                             ),
//                             Text(
//                               '\$ $currentBid',
//                               style: const TextStyle(
//                                 fontFamily: 'Outfit',
//                                 fontSize: 20,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 10,
//                       horizontal: 50,
//                     ),
//                     child: TextFormField(
//                       controller: BidController,
//                       decoration: const InputDecoration(
//                         labelText: 'Straight bid',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   Container(
//                     decoration: const BoxDecoration(
//                         gradient: LinearGradient(colors: [
//                       Color.fromARGB(255, 45, 55, 255),
//                       Color.fromARGB(255, 97, 184, 255)
//                     ])),
//                     width: 130,
//                     height: 50,
//                     child: const Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Bid Now',
//                             style: TextStyle(
//                                 color: Colors.white, fontFamily: 'Outfit'),
//                           ),
//                           Icon(
//                             Icons.keyboard_arrow_right_rounded,
//                             color: Colors.white,
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _submitBid() async {
//     final straightBid = int.parse(BidController.text);

//     final bidData = {
//       'username': 'equinox',
//       'price': straightBid,
//       'productId': widget.productId,
//     };

//     print(bidData);

//     final response = await http.put(
//       Uri.parse('http://localhost:5000/api/bids'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(bidData),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       // Handle successful bid submission
//       Navigator.of(context).pop();
//     } else {
//       // Handle error
//       print('Failed to submit bid: ${response.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Row(
//         children: [
//           Text('Submit Bid'),
//           Spacer(),
//           Text(widget.productName),
//           Spacer(),
//           IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildBidField('Straight bid', _straightBidController),
//             SizedBox(height: 10),
//             _buildBidField('Maximum bid', _maxBidController),
//             SizedBox(height: 20),
//             _buildBidInfo(),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         ElevatedButton(
//           onPressed: _submitBid,
//           child: Text('Submit'),
//         ),
//       ],
//     );
//   }

//   Widget _buildBidField(String label, TextEditingController controller) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             controller: controller,
//             decoration: InputDecoration(labelText: label, prefixText: '\$'),
//             keyboardType: TextInputType.number,
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.remove),
//           onPressed: () {
//             setState(() {
//               double currentValue = double.parse(controller.text);
//               controller.text = (currentValue - 1).toString();
//             });
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.add),
//           onPressed: () {
//             setState(() {
//               double currentValue = double.parse(controller.text);
//               controller.text = (currentValue + 1).toString();
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildBidInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Minimum Bid: \$${widget.minimumBid.toStringAsFixed(2)}'),
//         SizedBox(height: 5),
//         Text('Current Bid: \$${widget.currentBid.toStringAsFixed(2)}'),
//         SizedBox(height: 5),
//         Text('Ends in: ${widget.endTime}'),
//       ],
//     );
//   }
// }
