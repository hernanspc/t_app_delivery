import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool? autofocus; // Nuevo parámetro
  final FocusNode? focusNode; // Nuevo parámetro
  final Function()? onTap; // Nuevo parámetro onTap

  CustomTextFormField({
    Key? key,
    this.controller,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.prefixIcon, // Nuevo parámetro
    this.suffixIcon, // Nuevo parámetro
    this.autofocus, // Nuevo parámetro
    this.focusNode, // Nuevo parámetro
    this.onTap, // Agregar onTap al constructor
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool passwordMode = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));

    const borderRadius = Radius.circular(15);

    return Container(
      // padding: const EdgeInsets.only(bottom: 0, top: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 246, 246),
        borderRadius: const BorderRadius.only(
          topLeft: borderRadius,
          bottomLeft: borderRadius,
          bottomRight: borderRadius,
          topRight: borderRadius,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        onTap: widget.onTap, // Pasar onTap al TextFormField
        autofocus: widget.autofocus ?? false, // Configurar autofocus
        focusNode: widget.focusNode, // Configurar focusNode
        controller: widget.controller,
        onChanged: widget.onChanged,
        validator: widget.validator,
        obscureText: widget.obscureText && !passwordMode,
        keyboardType: widget.keyboardType,
        style: const TextStyle(fontSize: 17, color: Colors.black54),
        decoration: InputDecoration(
          prefixIcon:
              widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          // suffixIcon:
          //     widget.suffixIcon != null ? Icon(widget.suffixIcon) : null,
          floatingLabelStyle: const TextStyle(
            color: Color.fromRGBO(189, 189, 189, 1),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          labelStyle: const TextStyle(color: Color.fromRGBO(189, 189, 189, 1)),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          isDense: true,
          label: widget.label != null ? Text(widget.label!) : null,
          hintText: widget.hint,
          errorText: widget.errorMessage,
          focusColor: colors.primary,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  iconSize: 25,
                  onPressed: () {
                    setState(() {
                      passwordMode = !passwordMode;
                    });
                  },
                  icon: passwordMode
                      ? const Icon(
                          EvaIcons.eyeOutline,
                        )
                      : const Icon(
                          EvaIcons.eyeOff2,
                        ),
                )
              : widget.suffixIcon != null
                  ? Icon(widget.suffixIcon)
                  : null,
        ),
      ),
    );
  }
}
