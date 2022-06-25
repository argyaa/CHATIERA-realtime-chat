part of 'people_cubit.dart';

@immutable
abstract class PeopleState {}

class PeopleInitial extends PeopleState {}

class PeopleLoading extends PeopleState {}

class PeopleSuccess extends PeopleState {
  final List<UserModel> user;
  PeopleSuccess(this.user);
}

class PeopleFailed extends PeopleState {
  final String error;
  PeopleFailed(this.error);
}
