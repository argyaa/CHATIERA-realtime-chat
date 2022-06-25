import 'package:bloc/bloc.dart';

class EmojiCubit extends Cubit<bool> {
  EmojiCubit() : super(false);

  void setShowEmoji(bool val) {
    emit(val);
  }
}
