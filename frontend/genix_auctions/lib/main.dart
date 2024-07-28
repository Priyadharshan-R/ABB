import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genix_auctions/bloc/user_session_bloc.dart';
import 'package:genix_auctions/routes/routes_impl.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSessionBloc(),
      child: MaterialApp.router(
        title: 'Genix Auctions',
        // theme: ThemeData.light(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
