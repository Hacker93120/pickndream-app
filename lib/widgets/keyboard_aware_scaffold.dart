import 'package:flutter/material.dart';

class KeyboardAwareScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;

  const KeyboardAwareScaffold({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                           MediaQuery.of(context).padding.top - 
                           (appBar?.preferredSize.height ?? 0),
              ),
              child: IntrinsicHeight(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
