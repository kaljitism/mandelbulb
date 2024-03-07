import 'package:flutter/widgets.dart';
import 'package:mandelbulb/engine/scene.dart';
import 'package:vector_math/vector_math_64.dart';

typedef SceneCreatedCallback = void Function(Scene scene);

class Asset3D extends StatefulWidget {
  final bool interactive;
  final SceneCreatedCallback? onSceneCreated;
  final ObjectCreatedCallback? onObjectCreated;

  const Asset3D({
    super.key,
    this.interactive = true,
    this.onSceneCreated,
    this.onObjectCreated,
  });

  @override
  State<Asset3D> createState() => _Asset3DState();
}

class _Asset3DState extends State<Asset3D> {
  late Scene scene;
  late Offset _lastFocalPoint;
  double? _lastZoom;

  void _handleScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.localFocalPoint;
    _lastZoom = null;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    scene.camera.trackBall(
        toVector2(_lastFocalPoint), toVector2(details.localFocalPoint), 1.5);
    _lastFocalPoint = details.localFocalPoint;
    if (_lastZoom == null) {
      _lastZoom = scene.camera.zoom;
    } else {
      scene.camera.zoom = _lastZoom! * details.scale;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    scene = Scene(
      onUpdate: () => setState(() {}),
      onObjectCreated: widget.onObjectCreated,
    );
    // prevents setState() or markNeedsBuild called during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSceneCreated?.call(scene);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        scene.camera.viewportWidth = constraints.maxWidth;
        scene.camera.viewportHeight = constraints.maxHeight;
        final customPaint = CustomPaint(
          painter: _CubePainter(scene),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
        return widget.interactive
            ? GestureDetector(
                onScaleStart: _handleScaleStart,
                onScaleUpdate: _handleScaleUpdate,
                child: customPaint,
              )
            : customPaint;
      },
    );
  }
}

class _CubePainter extends CustomPainter {
  final Scene _scene;
  const _CubePainter(this._scene);

  @override
  void paint(Canvas canvas, Size size) {
    _scene.render(canvas, size);
  }

  @override
  bool shouldRepaint(_CubePainter oldDelegate) {
    return true;
  }
}

// Convert Offset to Vector2
Vector2 toVector2(Offset value) {
  return Vector2(value.dx, value.dy);
}
