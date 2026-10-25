import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:qr_toolkit/features/create_qr/domain/usecases/build_qr_content.dart';
import 'package:qr_toolkit/shared/enums/qr_content_type.dart';
import 'package:qr_toolkit/shared/models/qr_model.dart';

enum CreateQrStep { type, content, style }

class CreateQrState {
  const CreateQrState({
    this.step = CreateQrStep.type,
    this.type = QrContentType.url,
    this.content = '',
    this.model = const QrModel(content: '', type: QrContentType.text),
  });

  final CreateQrStep step;
  final QrContentType type;
  final String content;
  final QrModel model;

  CreateQrState copyWith({
    CreateQrStep? step,
    QrContentType? type,
    String? content,
    QrModel? model,
  }) {
    return CreateQrState(
      step: step ?? this.step,
      type: type ?? this.type,
      content: content ?? this.content,
      model: model ?? this.model,
    );
  }
}

class CreateQrController extends StateNotifier<CreateQrState> {
  CreateQrController() : super(const CreateQrState());

  void selectType(QrContentType type) =>
      state = state.copyWith(step: CreateQrStep.content, type: type);

  void updateContent(String content) {
    state = state.copyWith(
      content: content,
      model: state.model.copyWith(content: content, type: state.type),
    );
  }

  void updateFields(Map<String, String> fields) {
    final content = QrContentBuilder().build(state.type, fields);
    state = state.copyWith(
      content: content,
      model: state.model.copyWith(content: content, type: state.type),
    );
  }

  void setColor(int color) =>
      state = state.copyWith(model: state.model.copyWith(color: color));

  void setBackgroundColor(int color) =>
      state = state.copyWith(model: state.model.copyWith(backgroundColor: color));

  void setGradient(int start, int end) => state = state.copyWith(
        model: state.model.copyWith(gradientStart: start, gradientEnd: end),
      );

  Future<void> pickLogo() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      state = state.copyWith(model: state.model.copyWith(logoPath: picked.path));
    }
  }

  void nextStep() {
    final next = CreateQrStep.values[
        (CreateQrStep.values.indexOf(state.step) + 1) %
            CreateQrStep.values.length];
    state = state.copyWith(step: next);
  }
}

final createQrControllerProvider =
    StateNotifierProvider<CreateQrController, CreateQrState>(
  (ref) => CreateQrController(),
);
