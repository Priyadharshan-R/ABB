import 'package:equatable/equatable.dart';

abstract class UserSessionEvent extends Equatable {
  const UserSessionEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends UserSessionEvent {}

class LoggedIn extends UserSessionEvent {}

class LoggedOut extends UserSessionEvent {}
