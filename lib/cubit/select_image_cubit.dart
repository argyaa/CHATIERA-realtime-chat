import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'select_image_state.dart';

class SelectImageCubit extends Cubit<SelectImageState> {
  SelectImageCubit() : super(SelectImageInitial());

  final ImagePicker _imagePicker = ImagePicker();
  // ignore: prefer_typing_uninitialized_variables

  void selectImage() async {
    try {
      final dataImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (dataImage != null) {
        print(dataImage.name);
        print(dataImage.path);
        emit(SelectImageSuccess(dataImage));
      }
    } catch (e) {
      print("error di SelectImageCubit");
      print("error di selectImage");
      print(e);
      emit(SelectImageFailed(e.toString()));
    }
  }

  void clearImage() {
    emit(SelectImageInitial());
  }
}
