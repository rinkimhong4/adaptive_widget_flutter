import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final TextEditingController? controller;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onEditingComplete,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.controller,
  }) : assert(
         controller == null || initialValue == null,
         'You cannot use both controller and initialValue',
       );

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  bool _hasFocus = false;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();

    _isInternalController = widget.controller == null;

    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);

    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!mounted) return;
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    if (_isInternalController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: hasError ? theme.colorScheme.error : null,
            ),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError
                  ? theme.colorScheme.error
                  : _hasFocus
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: _hasFocus ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            decoration: InputDecoration(
              hintText: widget.hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
