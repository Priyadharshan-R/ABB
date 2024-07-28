import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserSessionState extends Equatable {
  const UserSessionState();

  @override
  List<Object> get props => [];
}

class UserSessionInitial extends UserSessionState {}

class UserSessionAuthenticated extends UserSessionState {}

class UserSessionUnAuthenticated extends UserSessionState {}
