part of 'select_image_cubit.dart';

@immutable
abstract class SelectImageState {}

class SelectImageInitial extends SelectImageState {}

class SelectImageLoading extends SelectImageState {}

class SelectImageSuccess extends SelectImageState {
  final XFile data;
  SelectImageSuccess(this.data);
}

class SelectImageFailed extends SelectImageState {
  final String error;
  SelectImageFailed(this.error);
}
