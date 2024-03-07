import 'dart:ui';

import 'camera.dart';
import 'object.dart';

typedef ObjectCreatedCallback = void Function(Object object);

class Scene {
  Scene({VoidCallback? onUpdate, ObjectCreatedCallback? onObjectCreated}) {
    _onUpdate = onUpdate;
    _onObjectCreated = onObjectCreated;
  }

  Camera camera = Camera();
  VoidCallback? _onUpdate;
  ObjectCreatedCallback? _onObjectCreated;
}
