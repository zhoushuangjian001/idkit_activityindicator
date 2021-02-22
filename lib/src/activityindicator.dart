part of idkit_activityindicator;

class IDKitActivityIndicator extends StatefulWidget {
  const IDKitActivityIndicator({
    Key key,
    this.animating = true,
    this.radius,
    this.color,
    this.count = 8,
  })  : assert(radius != null),
        assert(radius > 0),
        assert(count != null),
        assert(count > 3),
        assert(animating != null),
        super(key: key);

  /// 是否开始动画
  final bool animating;

  /// 轨道的长度
  final double radius;

  /// 轨道的颜色
  final Color color;

  /// 轨道的数量
  final int count;

  @override
  _IDKitActivityIndicatorState createState() => _IDKitActivityIndicatorState();
}

class _IDKitActivityIndicatorState extends State<IDKitActivityIndicator>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  List<int> alphaList;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    if (widget.animating) {
      _animationController.repeat();
    }
    alphaList =
        List.generate(widget.count, (index) => 255 * index ~/ widget.count);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _IDKitActivityIndicatorPainter(
          position: _animationController,
          activeColor: widget.color,
          radius: widget.radius,
          alphaValues: alphaList,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant IDKitActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      alphaList =
          List.generate(widget.count, (index) => 255 * index ~/ widget.count);
    }
    if (widget.animating != oldWidget.animating) {
      if (widget.animating) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}

/// 常量
const _kDefaultRadio = 10;
const _kTPi = pi * 2;

class _IDKitActivityIndicatorPainter extends CustomPainter {
  _IDKitActivityIndicatorPainter({
    @required this.position,
    @required this.alphaValues,
    @required this.radius,
    @required this.activeColor,
  })  : tickShapeRRect = RRect.fromLTRBXY(
            -radius / _kDefaultRadio,
            -radius / 3, // Distance of orbit offset center
            radius / _kDefaultRadio,
            -radius,
            radius / _kDefaultRadio,
            radius / _kDefaultRadio),
        super(repaint: position);

  final Animation<double> position;
  final List<int> alphaValues;
  final double radius;
  final Color activeColor;
  final RRect tickShapeRRect;

  @override
  void paint(Canvas canvas, Size size) {
    // 创建画笔
    final paint = Paint();
    final tickCount = alphaValues.length;
    // 保存当前画布
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    // 当前活跃轨道
    final int activeTick = (tickCount * position.value).floor();
    // 创建轨道
    for (var i = 0; i < tickCount; i++) {
      // 取值倒向，颜色深（alpha 的值，值越大，越不透明）
      final int t = (i - activeTick) % tickCount;
      paint.color = activeColor.withAlpha(alphaValues[t]);
      canvas.drawRRect(tickShapeRRect, paint);
      // 当前画布还未重置
      canvas.rotate(_kTPi / tickCount);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_IDKitActivityIndicatorPainter oldWidget) {
    return oldWidget.position != position ||
        oldWidget.activeColor != activeColor ||
        oldWidget.alphaValues != alphaValues ||
        oldWidget.radius != radius;
  }
}
