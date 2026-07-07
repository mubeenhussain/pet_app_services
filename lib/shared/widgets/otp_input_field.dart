import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// Segmented one-time-code input: [length] single-digit boxes with
/// auto-advance and backspace-to-previous behaviour.
///
/// Fully theme-driven — no hardcoded colors.
class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.onCompleted,
    this.autofocus = true,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (i) {
      final node = FocusNode();
      node.addListener(() => setState(() {}));
      return node;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _value => _controllers.map((c) => c.text).join();

  void _notify() {
    final value = _value;
    widget.onChanged(value);
    if (value.length == widget.length) {
      _focusNodes[widget.length - 1].unfocus();
      widget.onCompleted?.call(value);
    }
  }

  void _onChanged(int index, String raw) {
    if (raw.length > 1) {
      _distribute(index, raw);
      return;
    }
    if (raw.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
    _notify();
  }

  void _distribute(int startIndex, String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    for (var i = 0; i < digits.length && startIndex + i < widget.length; i++) {
      _controllers[startIndex + i].text = digits[i];
    }
    final next = (startIndex + digits.length).clamp(0, widget.length - 1);
    _focusNodes[next].requestFocus();
    setState(() {});
    _notify();
  }

  KeyEventResult _onKey(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      setState(() {});
      _notify();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: List.generate(widget.length, _buildBox),
      ),
    );
  }

  Widget _buildBox(int index) {
    final scheme = context.colorScheme;
    final colors = context.colors;
    final isFocused = _focusNodes[index].hasFocus;
    final hasValue = _controllers[index].text.isNotEmpty;

    final borderColor = isFocused ? scheme.primary : colors.border;
    final fillColor = hasValue || isFocused
        ? scheme.surface
        : scheme.primary.withValues(alpha: 0.06);

    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == widget.length - 1 ? 0 : 8,
        ),
        child: Focus(
          onKeyEvent: (_, event) => _onKey(index, event),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            autofocus: widget.autofocus && index == 0,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: fillColor,
              hintText: '–',
              hintStyle: TextStyle(
                color: colors.textMuted,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: scheme.primary, width: 2),
              ),
            ),
            onChanged: (raw) => _onChanged(index, raw),
          ),
        ),
      ),
    );
  }
}
