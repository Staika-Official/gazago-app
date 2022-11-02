import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class BottomSheetAlert extends StatelessWidget {
  String title;
  String? contentText;
  Widget? contentWidget;
  List<Widget> actions;

  BottomSheetAlert({Key? key, required this.title, this.contentText, this.contentWidget, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: const BoxDecoration(
        color: Color(0xff363841),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: StyledText(
                  title,
                  fontSize: 22,
                  lineHeight: 24,
                  fontWeight: 500,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: contentWidget != null
                      ? contentWidget
                      : StyledText(
                          contentText!,
                          fontSize: 18,
                          lineHeight: 24,
                          fontWeight: 500,
                          color: Color(0xffbfbfbf),
                        )),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: actions,
              )
            ],
          ),
        ),
      ),
    );
  }
}
