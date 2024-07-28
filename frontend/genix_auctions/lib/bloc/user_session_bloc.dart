import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genix_auctions/bloc/user_session_event.dart';
import 'package:genix_auctions/bloc/user_session_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionBloc extends Bloc<UserSessionEvent, UserSessionState> {
  UserSessionBloc() : super(UserSessionInitial()) {
    on<AppStarted>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn');
      print(
          "aaaaaaaaaaaaaaaaaaaaaaaaaaa ${isLoggedIn}aaaaaaaaaaaaaaaaaaaaaaaaaa");
      // final user_email = prefs.getString('user_id');

      if (isLoggedIn!) {
        emit(UserSessionAuthenticated());
      } else {
        emit(UserSessionUnAuthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      print(':::::::::::::::::::::');
      print('${prefs.getBool('isLoggedIn')}');
      emit(UserSessionAuthenticated());
    });

    on<LoggedOut>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      emit(UserSessionUnAuthenticated());
    });
  }
}
