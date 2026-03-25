import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawker/ui/core/themes/app_colors.dart';

enum AppTextFieldType {
  filled, // 배경이 채워진 스타일 (기본)
  outlined, // 아웃라인 스타일
  underlined, // 언더라인 스타일
}

enum AppTextFieldState { normal, error, disabled, focused }

class AppTextField extends StatefulWidget {
  // 기본 TextField 속성들
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;

  // 커스텀 속성들
  final AppTextFieldType type;
  final AppTextFieldState state;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  const AppTextField({
    super.key,
    // 기본 속성들
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.validator,
    // 커스텀 속성들
    this.type = AppTextFieldType.filled,
    this.state = AppTextFieldState.normal,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: widget.labelStyle ?? _getLabelStyle()),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled && widget.state != AppTextFieldState.disabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          textCapitalization: widget.textCapitalization,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: widget.textStyle ?? _getTextStyle(),
          decoration: _getInputDecoration(),
        ),
        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText ?? widget.helperText ?? '',
            style: _getHelperTextStyle(),
          ),
        ],
      ],
    );
  }

  InputDecoration _getInputDecoration() {
    final isError =
        widget.state == AppTextFieldState.error || widget.errorText != null;
    final isDisabled =
        widget.state == AppTextFieldState.disabled || !widget.enabled;
    final borderRadius = BorderRadius.circular(widget.borderRadius ?? 12);

    switch (widget.type) {
      case AppTextFieldType.filled:
        return InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ?? _getHintStyle(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          filled: true,
          fillColor: widget.fillColor ?? _getFillColor(isError, isDisabled),
          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.border,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color:
                  widget.focusedBorderColor ?? _getFocusedBorderColor(isError),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: widget.errorBorderColor ?? AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: widget.errorBorderColor ?? AppColors.error,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
        );

      case AppTextFieldType.outlined:
        return InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ?? _getHintStyle(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          filled: false,
          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.textLight.withOpacity(0.3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.textLight.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color:
                  widget.focusedBorderColor ?? _getFocusedBorderColor(isError),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: widget.errorBorderColor ?? AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: widget.errorBorderColor ?? AppColors.error,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: AppColors.textLight.withOpacity(0.1),
              width: 1,
            ),
          ),
        );

      case AppTextFieldType.underlined:
        return InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ?? _getHintStyle(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          filled: false,
          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.textLight.withOpacity(0.3),
              width: 1,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.textLight.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:
                  widget.focusedBorderColor ?? _getFocusedBorderColor(isError),
              width: 2,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.errorBorderColor ?? AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.errorBorderColor ?? AppColors.error,
              width: 2,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.textLight.withOpacity(0.1),
              width: 1,
            ),
          ),
        );
    }
  }

  Color _getFillColor(bool isError, bool isDisabled) {
    if (isDisabled) {
      return AppColors.textLight.withOpacity(0.05);
    }
    if (isError) {
      return AppColors.error.withOpacity(0.05);
    }
    if (_isFocused) {
      return AppColors.primaryWithOpacity10;
    }
    return AppColors.surface;
  }

  Color _getFocusedBorderColor(bool isError) {
    if (isError) {
      return AppColors.error;
    }
    return AppColors.primary;
  }

  TextStyle _getTextStyle() {
    final isDisabled =
        widget.state == AppTextFieldState.disabled || !widget.enabled;
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: isDisabled ? AppColors.textLight : AppColors.textPrimary,
    );
  }

  TextStyle _getHintStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textLight,
    );
  }

  TextStyle _getLabelStyle() {
    final isError =
        widget.state == AppTextFieldState.error || widget.errorText != null;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: isError ? AppColors.error : AppColors.textSecondary,
    );
  }

  TextStyle _getHelperTextStyle() {
    final isError =
        widget.state == AppTextFieldState.error || widget.errorText != null;
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: isError ? AppColors.error : AppColors.textLight,
    );
  }
}
