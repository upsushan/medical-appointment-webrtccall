import 'package:flutter/material.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final Widget suffixIcon;
  final bool isPassword;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.suffixIcon,
    required this.obscureText,
    required this.isPassword,
    required this.controller,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: AppTextStyles().labelStyle,
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: AppTextStyles().hintStyle,
                  obscureText: widget.isPassword && _obscureText,
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    suffixIcon: widget.isPassword
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24,
                              color: AppColors.secondaryColor,
                            ),
                          )
                        : widget.suffixIcon,

                    // suffixIcon: SvgPicture.asset(suffixIcon),
                    hintStyle: AppTextStyles().hintStyle,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    suffixIconConstraints: BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?> onChanged;

  const DropDown({
    Key? key,
    required this.label,
    required this.hintText,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: AppTextStyles().labelStyle,
          ),
          SizedBox(
            height: 2,
          ),
          DropdownButtonFormField<String>(
            value: widget.selectedOption,
            onChanged: widget.onChanged,
            items: widget.options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: AppTextStyles().hintStyle,
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles().hintStyle,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
