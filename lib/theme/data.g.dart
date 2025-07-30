
//
// theme/data.g.dart
//

// Do not edit directly
// Generated on Tue, 15 Jul 2025 07:45:54 GMT



part of 'theme.g.dart';

class AppThemeData  {
   const AppThemeData({
      required this.color,
      required this.textStyle,
      required this.double,
    });

    factory AppThemeData.regular() => _regular;

    static final AppThemeData _regular = AppThemeData(
      color: AppColorData.regular(),
      textStyle: AppTextStyleData.regular(),
      double: AppDoubleData.regular(),
    );

    final AppColorData color;
    final AppTextStyleData textStyle;
    final AppDoubleData double;
    

    
}






class AppColorData  {
   const AppColorData({
      required this.colorBaseBalck,
      required this.colorBaseWhite,
      required this.colorBgBlack,
      required this.colorBgBrand,
      required this.colorBgInteractivePrimary,
      required this.colorBgInteractivePrimaryDisabled,
      required this.colorBgInteractivePrimaryPressed,
      required this.colorBgInteractiveSecondary,
      required this.colorBgInteractiveSecondaryDisabled,
      required this.colorBgInteractiveSecondaryPressed,
      required this.colorBgPrimary,
      required this.colorBgSecondary,
      required this.colorBgSuccess,
      required this.colorBgTertiary,
      required this.colorBgTransparcy50,
      required this.colorBgTransparcy60,
      required this.colorBgTransparcy80,
      required this.colorBgWarning,
      required this.colorBgWarningBold,
      required this.colorBgWarningSubtle,
      required this.colorBgWhite,
      required this.colorBluegray100,
      required this.colorBluegray200,
      required this.colorBluegray300,
      required this.colorBluegray400,
      required this.colorBluegray50,
      required this.colorBluegray500,
      required this.colorBluegray600,
      required this.colorBluegray700,
      required this.colorBluegray800,
      required this.colorBluegray900,
      required this.colorBorderBlack,
      required this.colorBorderInteractivePrimary,
      required this.colorBorderInteractivePrimaryDisabled,
      required this.colorBorderInteractivePrimaryPressed,
      required this.colorBorderInteractiveSecondary,
      required this.colorBorderInteractiveSecondaryDisabled,
      required this.colorBorderInteractiveSecondaryPressed,
      required this.colorBorderInverse,
      required this.colorBorderPrimary,
      required this.colorBorderSecondary,
      required this.colorBorderSuccess,
      required this.colorBorderTertiary,
      required this.colorBorderWarning,
      required this.colorBorderWhite,
      required this.colorBrandgray100,
      required this.colorBrandgray200,
      required this.colorBrandgray300,
      required this.colorBrandgray400,
      required this.colorBrandgray50,
      required this.colorBrandgray500,
      required this.colorBrandgray600,
      required this.colorBrandgray700,
      required this.colorBrandgray800,
      required this.colorBrandgray900,
      required this.colorCyan100,
      required this.colorCyan200,
      required this.colorCyan300,
      required this.colorCyan400,
      required this.colorCyan50,
      required this.colorCyan500,
      required this.colorCyan600,
      required this.colorCyan700,
      required this.colorCyan800,
      required this.colorCyan900,
      required this.colorGray100,
      required this.colorGray200,
      required this.colorGray300,
      required this.colorGray400,
      required this.colorGray50,
      required this.colorGray500,
      required this.colorGray600,
      required this.colorGray700,
      required this.colorGray800,
      required this.colorGray900,
      required this.colorGreen100,
      required this.colorGreen200,
      required this.colorGreen300,
      required this.colorGreen400,
      required this.colorGreen50,
      required this.colorGreen500,
      required this.colorGreen600,
      required this.colorGreen700,
      required this.colorGreen800,
      required this.colorGreen900,
      required this.colorIconImportant,
      required this.colorIconInteractivePrimary,
      required this.colorIconInteractivePrimaryDisabled,
      required this.colorIconInteractivePrimaryPressed,
      required this.colorIconInteractiveSecondary,
      required this.colorIconInteractiveSecondaryDisabled,
      required this.colorIconInteractiveSecondaryPressed,
      required this.colorIconInverse,
      required this.colorIconPrimary,
      required this.colorIconQuaternary,
      required this.colorIconSecondary,
      required this.colorIconSuccess,
      required this.colorIconTertiary,
      required this.colorIconWarning,
      required this.colorOrange100,
      required this.colorOrange200,
      required this.colorOrange300,
      required this.colorOrange400,
      required this.colorOrange50,
      required this.colorOrange500,
      required this.colorOrange600,
      required this.colorOrange700,
      required this.colorOrange800,
      required this.colorOrange900,
      required this.colorPink100,
      required this.colorPink200,
      required this.colorPink300,
      required this.colorPink400,
      required this.colorPink50,
      required this.colorPink500,
      required this.colorPink600,
      required this.colorPink700,
      required this.colorPink800,
      required this.colorPink900,
      required this.colorPointBluegray,
      required this.colorPointBrandgray,
      required this.colorPointCyan,
      required this.colorPointGreen,
      required this.colorPointOrange,
      required this.colorPointPink,
      required this.colorPointPurple,
      required this.colorPointYellow,
      required this.colorPointYellowgreen,
      required this.colorPurple100,
      required this.colorPurple200,
      required this.colorPurple300,
      required this.colorPurple400,
      required this.colorPurple50,
      required this.colorPurple500,
      required this.colorPurple600,
      required this.colorPurple700,
      required this.colorPurple800,
      required this.colorPurple900,
      required this.colorRed100,
      required this.colorRed200,
      required this.colorRed300,
      required this.colorRed400,
      required this.colorRed50,
      required this.colorRed500,
      required this.colorRed600,
      required this.colorRed700,
      required this.colorRed800,
      required this.colorRed900,
      required this.colorTextBrand,
      required this.colorTextInfo,
      required this.colorTextInteractivePrimary,
      required this.colorTextInteractivePrimaryDisabled,
      required this.colorTextInteractivePrimaryPressed,
      required this.colorTextInteractiveSecondary,
      required this.colorTextInteractiveSecondaryDisabled,
      required this.colorTextInteractiveSecondaryPressed,
      required this.colorTextInverse,
      required this.colorTextPrimary,
      required this.colorTextSecondary,
      required this.colorTextSuccess,
      required this.colorTextTertiary,
      required this.colorTextWarning,
      required this.colorTextWarningBold,
      required this.colorYellow100,
      required this.colorYellow200,
      required this.colorYellow300,
      required this.colorYellow400,
      required this.colorYellow50,
      required this.colorYellow500,
      required this.colorYellow600,
      required this.colorYellow700,
      required this.colorYellow800,
      required this.colorYellow900,
      required this.colorYellowgreen100,
      required this.colorYellowgreen200,
      required this.colorYellowgreen300,
      required this.colorYellowgreen400,
      required this.colorYellowgreen50,
      required this.colorYellowgreen500,
      required this.colorYellowgreen600,
      required this.colorYellowgreen700,
      required this.colorYellowgreen800,
      required this.colorYellowgreen900,
      required this.staikaPayBk,
      required this.staikaPayGray10,
      required this.staikaPayGray20,
      required this.staikaPayGray30,
      required this.staikaPayGray40,
      required this.staikaPayGray50,
      required this.staikaPayGray60,
      required this.staikaPayGray70,
      required this.staikaPayPrimary,
      required this.staikaPaySecondary,
      required this.staikaPayWh,
      required this.transparencyBlack10,
      required this.transparencyBlack50,
      required this.transparencyBlack60,
      required this.transparencyBlack80,
      required this.transparencyCyan10,
    });



    factory AppColorData.regular() => const AppColorData(
      colorBaseBalck: Color(0xFF000000),
      colorBaseWhite: Color(0xFFFFFFFF),
      colorBgBlack: Color(0xFF000000),
      colorBgBrand: Color(0xFF0EE6F3),
      colorBgInteractivePrimary: Color(0xFF0EE6F3),
      colorBgInteractivePrimaryDisabled: Color(0xFF8A8A8A),
      colorBgInteractivePrimaryPressed: Color(0xFF0AA3AD),
      colorBgInteractiveSecondary: Color(0xFF363841),
      colorBgInteractiveSecondaryDisabled: Color(0xFF2E3038),
      colorBgInteractiveSecondaryPressed: Color(0xFF2E3038),
      colorBgPrimary: Color(0xFF1D1D26),
      colorBgSecondary: Color(0xFF2E3038),
      colorBgSuccess: Color(0xFF0EE6F3),
      colorBgTertiary: Color(0xFF363841),
      colorBgTransparcy50: Color(0x80000000),
      colorBgTransparcy60: Color(0x99000000),
      colorBgTransparcy80: Color(0xCC000000),
      colorBgWarning: Color(0xFFFF2222),
      colorBgWarningBold: Color(0xFFC61A1A),
      colorBgWarningSubtle: Color(0xFFFF7676),
      colorBgWhite: Color(0xFFFFFFFF),
      colorBluegray100: Color(0xFFF0F5FC),
      colorBluegray200: Color(0xFFE8F0FA),
      colorBluegray300: Color(0xFFDEE9F8),
      colorBluegray400: Color(0xFFD7E5F6),
      colorBluegray50: Color(0xFFFAFCFE),
      colorBluegray500: Color(0xFFCDDEF4),
      colorBluegray600: Color(0xFFBBCADE),
      colorBluegray700: Color(0xFF929EAD),
      colorBluegray800: Color(0xFF717A86),
      colorBluegray900: Color(0xFF565D66),
      colorBorderBlack: Color(0xFF000000),
      colorBorderInteractivePrimary: Color(0xFF0EE6F3),
      colorBorderInteractivePrimaryDisabled: Color(0xFF8A8A8A),
      colorBorderInteractivePrimaryPressed: Color(0xFF0AA3AD),
      colorBorderInteractiveSecondary: Color(0xFFC9C5C6),
      colorBorderInteractiveSecondaryDisabled: Color(0xFF2E3038),
      colorBorderInteractiveSecondaryPressed: Color(0xFF2E3038),
      colorBorderInverse: Color(0xFF1D1D26),
      colorBorderPrimary: Color(0xFF2A2B33),
      colorBorderSecondary: Color(0xFF363841),
      colorBorderSuccess: Color(0xFF0EE6F3),
      colorBorderTertiary: Color(0xFF4A4D57),
      colorBorderWarning: Color(0xFFFF2222),
      colorBorderWhite: Color(0xFFFFFFFF),
      colorBrandgray100: Color(0xFFECECEC),
      colorBrandgray200: Color(0xFF8A8A8A),
      colorBrandgray300: Color(0xFF606167),
      colorBrandgray400: Color(0xFF57585F),
      colorBrandgray50: Color(0xFFF5F5F5),
      colorBrandgray500: Color(0xFF4A4D57),
      colorBrandgray600: Color(0xFF363841),
      colorBrandgray700: Color(0xFF2E3038),
      colorBrandgray800: Color(0xFF2A2B33),
      colorBrandgray900: Color(0xFF1D1D26),
      colorCyan100: Color(0xFFB4F7FB),
      colorCyan200: Color(0xFF90F4F9),
      colorCyan300: Color(0xFF5EEEF7),
      colorCyan400: Color(0xFF3EEBF5),
      colorCyan50: Color(0xFFE7FDFE),
      colorCyan500: Color(0xFF0EE6F3),
      colorCyan600: Color(0xFF0DD1DD),
      colorCyan700: Color(0xFF0AA3AD),
      colorCyan800: Color(0xFF087F86),
      colorCyan900: Color(0xFF066166),
      colorGray100: Color(0xFFE6E1E2),
      colorGray200: Color(0xFFC9C5C6),
      colorGray300: Color(0xFFAEAAAB),
      colorGray400: Color(0xFF797677),
      colorGray50: Color(0xFFF2F2F2),
      colorGray500: Color(0xFF605E5F),
      colorGray600: Color(0xFF545253),
      colorGray700: Color(0xFF3C3B3C),
      colorGray800: Color(0xFF313031),
      colorGray900: Color(0xFF282828),
      colorGreen100: Color(0xFFB4FBDE),
      colorGreen200: Color(0xFF90F9CD),
      colorGreen300: Color(0xFF5EF7B7),
      colorGreen400: Color(0xFF3EF5A9),
      colorGreen50: Color(0xFFE7FEF4),
      colorGreen500: Color(0xFF0EF393),
      colorGreen600: Color(0xFF0CC97A),
      colorGreen700: Color(0xFF0A9D5F),
      colorGreen800: Color(0xFF086F43),
      colorGreen900: Color(0xFF044429),
      colorIconImportant: Color(0xFFFF2222),
      colorIconInteractivePrimary: Color(0xFFC9C5C6),
      colorIconInteractivePrimaryDisabled: Color(0xFF605E5F),
      colorIconInteractivePrimaryPressed: Color(0xFF0EE6F3),
      colorIconInteractiveSecondary: Color(0xFF8A8A8A),
      colorIconInteractiveSecondaryDisabled: Color(0xFF545253),
      colorIconInteractiveSecondaryPressed: Color(0xFF8A8A8A),
      colorIconInverse: Color(0xFF000000),
      colorIconPrimary: Color(0xFFFFFFFF),
      colorIconQuaternary: Color(0xFF605E5F),
      colorIconSecondary: Color(0xFFC9C5C6),
      colorIconSuccess: Color(0xFF0EE6F3),
      colorIconTertiary: Color(0xFF8A8A8A),
      colorIconWarning: Color(0xFFFF2222),
      colorOrange100: Color(0xFFFFCEB0),
      colorOrange200: Color(0xFFFFB68A),
      colorOrange300: Color(0xFFFF9554),
      colorOrange400: Color(0xFFFF8133),
      colorOrange50: Color(0xFFFFEFE6),
      colorOrange500: Color(0xFFFF6100),
      colorOrange600: Color(0xFFE85800),
      colorOrange700: Color(0xFFB54500),
      colorOrange800: Color(0xFF8C3500),
      colorOrange900: Color(0xFF6B2900),
      colorPink100: Color(0xFFFFD4E9),
      colorPink200: Color(0xFFFFBFDE),
      colorPink300: Color(0xFFFFA2CF),
      colorPink400: Color(0xFFFF90C5),
      colorPink50: Color(0xFFFFF1F8),
      colorPink500: Color(0xFFFF74B7),
      colorPink600: Color(0xFFE86AA7),
      colorPink700: Color(0xFFB55282),
      colorPink800: Color(0xFF8C4065),
      colorPink900: Color(0xFF6B314D),
      colorPointBluegray: Color(0xFFCDDEF4),
      colorPointBrandgray: Color(0xFF8A8A8A),
      colorPointCyan: Color(0xFF0EE6F3),
      colorPointGreen: Color(0xFF0EF393),
      colorPointOrange: Color(0xFFFF6100),
      colorPointPink: Color(0xFFFF74B7),
      colorPointPurple: Color(0xFFB85DFF),
      colorPointYellow: Color(0xFFFCFF5C),
      colorPointYellowgreen: Color(0xFFCDFF41),
      colorPurple100: Color(0xFFE9CDFF),
      colorPurple200: Color(0xFFDEB4FF),
      colorPurple300: Color(0xFFCF92FF),
      colorPurple400: Color(0xFFC67DFF),
      colorPurple50: Color(0xFFF8EFFF),
      colorPurple500: Color(0xFFB85DFF),
      colorPurple600: Color(0xFFA755E8),
      colorPurple700: Color(0xFF8342B5),
      colorPurple800: Color(0xFF65338C),
      colorPurple900: Color(0xFF4D276B),
      colorRed100: Color(0xFFFFE5E5),
      colorRed200: Color(0xFFFFC7C7),
      colorRed300: Color(0xFFFFA3A3),
      colorRed400: Color(0xFFFF7676),
      colorRed50: Color(0xFFFFF2F2),
      colorRed500: Color(0xFFFF2222),
      colorRed600: Color(0xFFE41E1E),
      colorRed700: Color(0xFFC61A1A),
      colorRed800: Color(0xFFA11616),
      colorRed900: Color(0xFF720F0F),
      colorTextBrand: Color(0xFF0EE6F3),
      colorTextInfo: Color(0xFF797677),
      colorTextInteractivePrimary: Color(0xFFFFFFFF),
      colorTextInteractivePrimaryDisabled: Color(0xFF8A8A8A),
      colorTextInteractivePrimaryPressed: Color(0xFF0AA3AD),
      colorTextInteractiveSecondary: Color(0xFFFFFFFF),
      colorTextInteractiveSecondaryDisabled: Color(0xFF605E5F),
      colorTextInteractiveSecondaryPressed: Color(0xFFE6E1E2),
      colorTextInverse: Color(0xFF000000),
      colorTextPrimary: Color(0xFFFFFFFF),
      colorTextSecondary: Color(0xFFC9C5C6),
      colorTextSuccess: Color(0xFF0EE6F3),
      colorTextTertiary: Color(0xFF8A8A8A),
      colorTextWarning: Color(0xFFFF2222),
      colorTextWarningBold: Color(0xFFC61A1A),
      colorYellow100: Color(0xFFFEFFCC),
      colorYellow200: Color(0xFFFEFFB4),
      colorYellow300: Color(0xFFFDFF92),
      colorYellow400: Color(0xFFFDFF7D),
      colorYellow50: Color(0xFFFFFFEF),
      colorYellow500: Color(0xFFFCFF5C),
      colorYellow600: Color(0xFFE5E854),
      colorYellow700: Color(0xFFB3B541),
      colorYellow800: Color(0xFF8B8C33),
      colorYellow900: Color(0xFF6A6B27),
      colorYellowgreen100: Color(0xFFF0FFC4),
      colorYellowgreen200: Color(0xFFE8FFA8),
      colorYellowgreen300: Color(0xFFDEFF80),
      colorYellowgreen400: Color(0xFFD7FF67),
      colorYellowgreen50: Color(0xFFFAFFEC),
      colorYellowgreen500: Color(0xFFCDFF41),
      colorYellowgreen600: Color(0xFFBBE83B),
      colorYellowgreen700: Color(0xFF92B52E),
      colorYellowgreen800: Color(0xFF718C24),
      colorYellowgreen900: Color(0xFF566B1B),
      staikaPayBk: Color(0xFF000000),
      staikaPayGray10: Color(0xFFF1F2F2),
      staikaPayGray20: Color(0xFFDCDCDC),
      staikaPayGray30: Color(0xFFD0D0D0),
      staikaPayGray40: Color(0xFFB9B9B9),
      staikaPayGray50: Color(0xFFA5A5A5),
      staikaPayGray60: Color(0xFF959595),
      staikaPayGray70: Color(0xFF1D1D26),
      staikaPayPrimary: Color(0xFFFF6100),
      staikaPaySecondary: Color(0xFFFFD4E9),
      staikaPayWh: Color(0xFFFFFFFF),
      transparencyBlack10: Color(0x1A000000),
      transparencyBlack50: Color(0x80000000),
      transparencyBlack60: Color(0x99000000),
      transparencyBlack80: Color(0xCC000000),
      transparencyCyan10: Color(0x1A0EE6F3),
    );


    final Color colorBaseBalck;
    final Color colorBaseWhite;
    final Color colorBgBlack;
    final Color colorBgBrand;
    final Color colorBgInteractivePrimary;
    final Color colorBgInteractivePrimaryDisabled;
    final Color colorBgInteractivePrimaryPressed;
    final Color colorBgInteractiveSecondary;
    final Color colorBgInteractiveSecondaryDisabled;
    final Color colorBgInteractiveSecondaryPressed;
    final Color colorBgPrimary;
    final Color colorBgSecondary;
    final Color colorBgSuccess;
    final Color colorBgTertiary;
    final Color colorBgTransparcy50;
    final Color colorBgTransparcy60;
    final Color colorBgTransparcy80;
    final Color colorBgWarning;
    final Color colorBgWarningBold;
    final Color colorBgWarningSubtle;
    final Color colorBgWhite;
    final Color colorBluegray100;
    final Color colorBluegray200;
    final Color colorBluegray300;
    final Color colorBluegray400;
    final Color colorBluegray50;
    final Color colorBluegray500;
    final Color colorBluegray600;
    final Color colorBluegray700;
    final Color colorBluegray800;
    final Color colorBluegray900;
    final Color colorBorderBlack;
    final Color colorBorderInteractivePrimary;
    final Color colorBorderInteractivePrimaryDisabled;
    final Color colorBorderInteractivePrimaryPressed;
    final Color colorBorderInteractiveSecondary;
    final Color colorBorderInteractiveSecondaryDisabled;
    final Color colorBorderInteractiveSecondaryPressed;
    final Color colorBorderInverse;
    final Color colorBorderPrimary;
    final Color colorBorderSecondary;
    final Color colorBorderSuccess;
    final Color colorBorderTertiary;
    final Color colorBorderWarning;
    final Color colorBorderWhite;
    final Color colorBrandgray100;
    final Color colorBrandgray200;
    final Color colorBrandgray300;
    final Color colorBrandgray400;
    final Color colorBrandgray50;
    final Color colorBrandgray500;
    final Color colorBrandgray600;
    final Color colorBrandgray700;
    final Color colorBrandgray800;
    final Color colorBrandgray900;
    final Color colorCyan100;
    final Color colorCyan200;
    final Color colorCyan300;
    final Color colorCyan400;
    final Color colorCyan50;
    final Color colorCyan500;
    final Color colorCyan600;
    final Color colorCyan700;
    final Color colorCyan800;
    final Color colorCyan900;
    final Color colorGray100;
    final Color colorGray200;
    final Color colorGray300;
    final Color colorGray400;
    final Color colorGray50;
    final Color colorGray500;
    final Color colorGray600;
    final Color colorGray700;
    final Color colorGray800;
    final Color colorGray900;
    final Color colorGreen100;
    final Color colorGreen200;
    final Color colorGreen300;
    final Color colorGreen400;
    final Color colorGreen50;
    final Color colorGreen500;
    final Color colorGreen600;
    final Color colorGreen700;
    final Color colorGreen800;
    final Color colorGreen900;
    final Color colorIconImportant;
    final Color colorIconInteractivePrimary;
    final Color colorIconInteractivePrimaryDisabled;
    final Color colorIconInteractivePrimaryPressed;
    final Color colorIconInteractiveSecondary;
    final Color colorIconInteractiveSecondaryDisabled;
    final Color colorIconInteractiveSecondaryPressed;
    final Color colorIconInverse;
    final Color colorIconPrimary;
    final Color colorIconQuaternary;
    final Color colorIconSecondary;
    final Color colorIconSuccess;
    final Color colorIconTertiary;
    final Color colorIconWarning;
    final Color colorOrange100;
    final Color colorOrange200;
    final Color colorOrange300;
    final Color colorOrange400;
    final Color colorOrange50;
    final Color colorOrange500;
    final Color colorOrange600;
    final Color colorOrange700;
    final Color colorOrange800;
    final Color colorOrange900;
    final Color colorPink100;
    final Color colorPink200;
    final Color colorPink300;
    final Color colorPink400;
    final Color colorPink50;
    final Color colorPink500;
    final Color colorPink600;
    final Color colorPink700;
    final Color colorPink800;
    final Color colorPink900;
    final Color colorPointBluegray;
    final Color colorPointBrandgray;
    final Color colorPointCyan;
    final Color colorPointGreen;
    final Color colorPointOrange;
    final Color colorPointPink;
    final Color colorPointPurple;
    final Color colorPointYellow;
    final Color colorPointYellowgreen;
    final Color colorPurple100;
    final Color colorPurple200;
    final Color colorPurple300;
    final Color colorPurple400;
    final Color colorPurple50;
    final Color colorPurple500;
    final Color colorPurple600;
    final Color colorPurple700;
    final Color colorPurple800;
    final Color colorPurple900;
    final Color colorRed100;
    final Color colorRed200;
    final Color colorRed300;
    final Color colorRed400;
    final Color colorRed50;
    final Color colorRed500;
    final Color colorRed600;
    final Color colorRed700;
    final Color colorRed800;
    final Color colorRed900;
    final Color colorTextBrand;
    final Color colorTextInfo;
    final Color colorTextInteractivePrimary;
    final Color colorTextInteractivePrimaryDisabled;
    final Color colorTextInteractivePrimaryPressed;
    final Color colorTextInteractiveSecondary;
    final Color colorTextInteractiveSecondaryDisabled;
    final Color colorTextInteractiveSecondaryPressed;
    final Color colorTextInverse;
    final Color colorTextPrimary;
    final Color colorTextSecondary;
    final Color colorTextSuccess;
    final Color colorTextTertiary;
    final Color colorTextWarning;
    final Color colorTextWarningBold;
    final Color colorYellow100;
    final Color colorYellow200;
    final Color colorYellow300;
    final Color colorYellow400;
    final Color colorYellow50;
    final Color colorYellow500;
    final Color colorYellow600;
    final Color colorYellow700;
    final Color colorYellow800;
    final Color colorYellow900;
    final Color colorYellowgreen100;
    final Color colorYellowgreen200;
    final Color colorYellowgreen300;
    final Color colorYellowgreen400;
    final Color colorYellowgreen50;
    final Color colorYellowgreen500;
    final Color colorYellowgreen600;
    final Color colorYellowgreen700;
    final Color colorYellowgreen800;
    final Color colorYellowgreen900;
    final Color staikaPayBk;
    final Color staikaPayGray10;
    final Color staikaPayGray20;
    final Color staikaPayGray30;
    final Color staikaPayGray40;
    final Color staikaPayGray50;
    final Color staikaPayGray60;
    final Color staikaPayGray70;
    final Color staikaPayPrimary;
    final Color staikaPaySecondary;
    final Color staikaPayWh;
    final Color transparencyBlack10;
    final Color transparencyBlack50;
    final Color transparencyBlack60;
    final Color transparencyBlack80;
    final Color transparencyCyan10;
    


}








class AppTextStyleData  {
   const AppTextStyleData({
      required this.enBodyMediumLg,
      required this.enBodyMediumMd,
      required this.enBodyMediumSm,
      required this.enBodyMediumXl,
      required this.enBodySemiboldLg,
      required this.enBodySemiboldMd,
      required this.enBodySemiboldSm,
      required this.enBodySemiboldXl,
      required this.enCaptionBoldMd,
      required this.enCaptionMediumMd,
      required this.enCaptionSemiboldMd,
      required this.enHeadingBlackLg,
      required this.enHeadingBlackMd,
      required this.enHeadingBlackSm,
      required this.enHeadingBlackXl,
      required this.enHeadingBoldLg,
      required this.enHeadingBoldMd,
      required this.enHeadingBoldSm,
      required this.enHeadingBoldXl,
      required this.enHeadingMediumLg,
      required this.enHeadingMediumMd,
      required this.enHeadingMediumSm,
      required this.enHeadingMediumXl,
      required this.enUnderlineMediumSm,
      required this.koBodyMediumLg,
      required this.koBodyMediumMd,
      required this.koBodyMediumSm,
      required this.koBodyMediumXl,
      required this.koBodySemiboldLg,
      required this.koBodySemiboldMd,
      required this.koBodySemiboldSm,
      required this.koBodySemiboldXl,
      required this.koCaptionMediumMd,
      required this.koCaptionSemiboldMd,
      required this.koHeadingBold2xl,
      required this.koHeadingBoldLg,
      required this.koHeadingBoldMd,
      required this.koHeadingBoldSm,
      required this.koHeadingBoldXl,
      required this.koHeadingMedium2xl,
      required this.koHeadingMediumLg,
      required this.koHeadingMediumMd,
      required this.koHeadingMediumSm,
      required this.koHeadingMediumXl,
      required this.koHeadingSemibold2xl,
      required this.koHeadingSemiboldLg,
      required this.koHeadingSemiboldMd,
      required this.koHeadingSemiboldSm,
      required this.koHeadingSemiboldXl,
      required this.koUnderlineMediumMd,
      required this.koUnderlineMediumSm,
      required this.numBodyMediumMd,
      required this.numBodyMediumSm,
      required this.numBodyMediumXl,
      required this.numBodySemiboldMd,
      required this.numBodySemiboldSm,
      required this.numBodySemiboldXl,
      required this.numCaptionMediumMd,
      required this.numCaptionSemiboldMd,
      required this.numHeadingBold2xl,
      required this.numHeadingBoldLg,
      required this.numHeadingBoldMd,
      required this.numHeadingBoldXl,
      required this.numHeadingMedium2xl,
      required this.numHeadingMediumLg,
      required this.numHeadingMediumMd,
      required this.numHeadingMediumXl,
      required this.numHeadingSemibold2xl,
      required this.numHeadingSemibold3xl,
      required this.numHeadingSemiboldLg,
      required this.numHeadingSemiboldMd,
      required this.numHeadingSemiboldXl,
    });



    factory AppTextStyleData.regular() => const AppTextStyleData(
      enBodyMediumLg: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.w500,letterSpacing: -0.32,height: 1.4,decoration: TextDecoration.none,),
      enBodyMediumMd: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.w500,letterSpacing: -0.28,height: 1.4,decoration: TextDecoration.none,),
      enBodyMediumSm: TextStyle(fontFamily: 'Montserrat',fontSize: 12,fontWeight: FontWeight.w500,letterSpacing: -0.24,height: 1.4,decoration: TextDecoration.none,),
      enBodyMediumXl: TextStyle(fontFamily: 'Montserrat',fontSize: 18,fontWeight: FontWeight.w500,letterSpacing: -0.36,height: 1.4,decoration: TextDecoration.none,),
      enBodySemiboldLg: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.w600,letterSpacing: -0.32,height: 1.4,decoration: TextDecoration.none,),
      enBodySemiboldMd: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.w600,letterSpacing: -0.28,height: 1.4,decoration: TextDecoration.none,),
      enBodySemiboldSm: TextStyle(fontFamily: 'Montserrat',fontSize: 12,fontWeight: FontWeight.w600,letterSpacing: -0.24,height: 1.4,decoration: TextDecoration.none,),
      enBodySemiboldXl: TextStyle(fontFamily: 'Montserrat',fontSize: 18,fontWeight: FontWeight.w600,letterSpacing: -0.36,height: 1.4,decoration: TextDecoration.none,),
      enCaptionBoldMd: TextStyle(fontFamily: 'Montserrat',fontSize: 10,fontWeight: FontWeight.w700,height: 1.4,decoration: TextDecoration.none,),
      enCaptionMediumMd: TextStyle(fontFamily: 'Montserrat',fontSize: 10,fontWeight: FontWeight.w500,letterSpacing: -0.2,height: 1.4,decoration: TextDecoration.none,),
      enCaptionSemiboldMd: TextStyle(fontFamily: 'Montserrat',fontSize: 10,fontWeight: FontWeight.w600,letterSpacing: -0.2,height: 1.4,decoration: TextDecoration.none,),
      enHeadingBlackLg: TextStyle(fontFamily: 'Montserrat',fontSize: 28,fontWeight: FontWeight.w900,letterSpacing: -0.392,height: 1.6,decoration: TextDecoration.none,),
      enHeadingBlackMd: TextStyle(fontFamily: 'Montserrat',fontSize: 24,fontWeight: FontWeight.w900,letterSpacing: -0.336,height: 1.6,decoration: TextDecoration.none,),
      enHeadingBlackSm: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w900,letterSpacing: -0.28,height: 1.6,decoration: TextDecoration.none,),
      enHeadingBlackXl: TextStyle(fontFamily: 'Montserrat',fontSize: 32,fontWeight: FontWeight.w900,letterSpacing: -0.448,height: 1.6,decoration: TextDecoration.none,),
      enHeadingBoldLg: TextStyle(fontFamily: 'Montserrat',fontSize: 28,fontWeight: FontWeight.w700,letterSpacing: -0.392,height: 1.6,decoration: TextDecoration.none,),
      enHeadingBoldMd: TextStyle(fontFamily: 'Montserrat',fontSize: 24,fontWeight: FontWeight.w700,letterSpacing: -0.336,height: 1.6,decoration: TextDecoration.none,),
      enHeadingBoldSm: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w700,letterSpacing: -0.28,height: 1.6,decoration: TextDecoration.none,),
      enHeadingBoldXl: TextStyle(fontFamily: 'Montserrat',fontSize: 32,fontWeight: FontWeight.w700,letterSpacing: -0.448,height: 1.6,decoration: TextDecoration.none,),
      enHeadingMediumLg: TextStyle(fontFamily: 'Montserrat',fontSize: 28,fontWeight: FontWeight.w500,letterSpacing: -0.392,height: 1.6,decoration: TextDecoration.none,),
      enHeadingMediumMd: TextStyle(fontFamily: 'Montserrat',fontSize: 24,fontWeight: FontWeight.w500,letterSpacing: -0.336,height: 1.6,decoration: TextDecoration.none,),
      enHeadingMediumSm: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500,letterSpacing: -0.28,height: 1.6,decoration: TextDecoration.none,),
      enHeadingMediumXl: TextStyle(fontFamily: 'Montserrat',fontSize: 32,fontWeight: FontWeight.w500,letterSpacing: -0.448,height: 1.6,decoration: TextDecoration.none,),
      enUnderlineMediumSm: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.w500,letterSpacing: -0.32,height: 1.4,decoration: TextDecoration.underline,),
      koBodyMediumLg: TextStyle(fontFamily: 'Pretendard',fontSize: 16,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      koBodyMediumMd: TextStyle(fontFamily: 'Pretendard',fontSize: 14,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      koBodyMediumSm: TextStyle(fontFamily: 'Pretendard',fontSize: 12,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      koBodyMediumXl: TextStyle(fontFamily: 'Pretendard',fontSize: 18,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      koBodySemiboldLg: TextStyle(fontFamily: 'Pretendard',fontSize: 16,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      koBodySemiboldMd: TextStyle(fontFamily: 'Pretendard',fontSize: 14,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      koBodySemiboldSm: TextStyle(fontFamily: 'Pretendard',fontSize: 12,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      koBodySemiboldXl: TextStyle(fontFamily: 'Pretendard',fontSize: 18,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      koCaptionMediumMd: TextStyle(fontFamily: 'Pretendard',fontSize: 10,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      koCaptionSemiboldMd: TextStyle(fontFamily: 'Pretendard',fontSize: 10,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      koHeadingBold2xl: TextStyle(fontFamily: 'Pretendard',fontSize: 36,fontWeight: FontWeight.w700,height: 1.6,decoration: TextDecoration.none,),
      koHeadingBoldLg: TextStyle(fontFamily: 'Pretendard',fontSize: 28,fontWeight: FontWeight.w700,height: 1.4,decoration: TextDecoration.none,),
      koHeadingBoldMd: TextStyle(fontFamily: 'Pretendard',fontSize: 24,fontWeight: FontWeight.w700,height: 1.4,decoration: TextDecoration.none,),
      koHeadingBoldSm: TextStyle(fontFamily: 'Pretendard',fontSize: 20,fontWeight: FontWeight.w700,height: 1.4,decoration: TextDecoration.none,),
      koHeadingBoldXl: TextStyle(fontFamily: 'Pretendard',fontSize: 32,fontWeight: FontWeight.w700,height: 1.4,decoration: TextDecoration.none,),
      koHeadingMedium2xl: TextStyle(fontFamily: 'Pretendard',fontSize: 36,fontWeight: FontWeight.w500,height: 1.6,decoration: TextDecoration.none,),
      koHeadingMediumLg: TextStyle(fontFamily: 'Pretendard',fontSize: 28,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      koHeadingMediumMd: TextStyle(fontFamily: 'Pretendard',fontSize: 24,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      koHeadingMediumSm: TextStyle(fontFamily: 'Pretendard',fontSize: 20,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      koHeadingMediumXl: TextStyle(fontFamily: 'Pretendard',fontSize: 32,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      koHeadingSemibold2xl: TextStyle(fontFamily: 'Pretendard',fontSize: 36,fontWeight: FontWeight.w600,height: 1.6,decoration: TextDecoration.none,),
      koHeadingSemiboldLg: TextStyle(fontFamily: 'Pretendard',fontSize: 28,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      koHeadingSemiboldMd: TextStyle(fontFamily: 'Pretendard',fontSize: 24,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      koHeadingSemiboldSm: TextStyle(fontFamily: 'Pretendard',fontSize: 20,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      koHeadingSemiboldXl: TextStyle(fontFamily: 'Pretendard',fontSize: 32,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      koUnderlineMediumMd: TextStyle(fontFamily: 'Pretendard',fontSize: 16,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.underline,),
      koUnderlineMediumSm: TextStyle(fontFamily: 'Pretendard',fontSize: 14,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.underline,),
      numBodyMediumMd: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      numBodyMediumSm: TextStyle(fontFamily: 'Montserrat',fontSize: 12,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      numBodyMediumXl: TextStyle(fontFamily: 'Montserrat',fontSize: 18,fontWeight: FontWeight.w500,height: 1.4,decoration: TextDecoration.none,),
      numBodySemiboldMd: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      numBodySemiboldSm: TextStyle(fontFamily: 'Montserrat',fontSize: 12,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      numBodySemiboldXl: TextStyle(fontFamily: 'Montserrat',fontSize: 18,fontWeight: FontWeight.w600,height: 1.4,decoration: TextDecoration.none,),
      numCaptionMediumMd: TextStyle(fontFamily: 'Montserrat',fontSize: 10,fontWeight: FontWeight.w500,letterSpacing: -0.08,height: 1.4,decoration: TextDecoration.none,),
      numCaptionSemiboldMd: TextStyle(fontFamily: 'Montserrat',fontSize: 10,fontWeight: FontWeight.w600,letterSpacing: -0.08,height: 1.4,decoration: TextDecoration.none,),
      numHeadingBold2xl: TextStyle(fontFamily: 'Montserrat',fontSize: 36,fontWeight: FontWeight.w700,height: 1.6,decoration: TextDecoration.none,),
      numHeadingBoldLg: TextStyle(fontFamily: 'Montserrat',fontSize: 28,fontWeight: FontWeight.w700,height: 1.6,decoration: TextDecoration.none,),
      numHeadingBoldMd: TextStyle(fontFamily: 'Montserrat',fontSize: 24,fontWeight: FontWeight.w700,height: 1.6,decoration: TextDecoration.none,),
      numHeadingBoldXl: TextStyle(fontFamily: 'Montserrat',fontSize: 32,fontWeight: FontWeight.w700,height: 1.6,decoration: TextDecoration.none,),
      numHeadingMedium2xl: TextStyle(fontFamily: 'Montserrat',fontSize: 36,fontWeight: FontWeight.w500,height: 1.6,decoration: TextDecoration.none,),
      numHeadingMediumLg: TextStyle(fontFamily: 'Montserrat',fontSize: 28,fontWeight: FontWeight.w500,height: 1.6,decoration: TextDecoration.none,),
      numHeadingMediumMd: TextStyle(fontFamily: 'Montserrat',fontSize: 24,fontWeight: FontWeight.w500,height: 1.6,decoration: TextDecoration.none,),
      numHeadingMediumXl: TextStyle(fontFamily: 'Montserrat',fontSize: 32,fontWeight: FontWeight.w500,height: 1.6,decoration: TextDecoration.none,),
      numHeadingSemibold2xl: TextStyle(fontFamily: 'Montserrat',fontSize: 36,fontWeight: FontWeight.w600,height: 1.6,decoration: TextDecoration.none,),
      numHeadingSemibold3xl: TextStyle(fontFamily: 'Montserrat',fontSize: 50,fontWeight: FontWeight.w600,height: 1.6,decoration: TextDecoration.none,),
      numHeadingSemiboldLg: TextStyle(fontFamily: 'Montserrat',fontSize: 28,fontWeight: FontWeight.w600,height: 1.6,decoration: TextDecoration.none,),
      numHeadingSemiboldMd: TextStyle(fontFamily: 'Montserrat',fontSize: 24,fontWeight: FontWeight.w600,height: 1.6,decoration: TextDecoration.none,),
      numHeadingSemiboldXl: TextStyle(fontFamily: 'Montserrat',fontSize: 32,fontWeight: FontWeight.w600,height: 1.6,decoration: TextDecoration.none,),
    );


    final TextStyle enBodyMediumLg;
    final TextStyle enBodyMediumMd;
    final TextStyle enBodyMediumSm;
    final TextStyle enBodyMediumXl;
    final TextStyle enBodySemiboldLg;
    final TextStyle enBodySemiboldMd;
    final TextStyle enBodySemiboldSm;
    final TextStyle enBodySemiboldXl;
    final TextStyle enCaptionBoldMd;
    final TextStyle enCaptionMediumMd;
    final TextStyle enCaptionSemiboldMd;
    final TextStyle enHeadingBlackLg;
    final TextStyle enHeadingBlackMd;
    final TextStyle enHeadingBlackSm;
    final TextStyle enHeadingBlackXl;
    final TextStyle enHeadingBoldLg;
    final TextStyle enHeadingBoldMd;
    final TextStyle enHeadingBoldSm;
    final TextStyle enHeadingBoldXl;
    final TextStyle enHeadingMediumLg;
    final TextStyle enHeadingMediumMd;
    final TextStyle enHeadingMediumSm;
    final TextStyle enHeadingMediumXl;
    final TextStyle enUnderlineMediumSm;
    final TextStyle koBodyMediumLg;
    final TextStyle koBodyMediumMd;
    final TextStyle koBodyMediumSm;
    final TextStyle koBodyMediumXl;
    final TextStyle koBodySemiboldLg;
    final TextStyle koBodySemiboldMd;
    final TextStyle koBodySemiboldSm;
    final TextStyle koBodySemiboldXl;
    final TextStyle koCaptionMediumMd;
    final TextStyle koCaptionSemiboldMd;
    final TextStyle koHeadingBold2xl;
    final TextStyle koHeadingBoldLg;
    final TextStyle koHeadingBoldMd;
    final TextStyle koHeadingBoldSm;
    final TextStyle koHeadingBoldXl;
    final TextStyle koHeadingMedium2xl;
    final TextStyle koHeadingMediumLg;
    final TextStyle koHeadingMediumMd;
    final TextStyle koHeadingMediumSm;
    final TextStyle koHeadingMediumXl;
    final TextStyle koHeadingSemibold2xl;
    final TextStyle koHeadingSemiboldLg;
    final TextStyle koHeadingSemiboldMd;
    final TextStyle koHeadingSemiboldSm;
    final TextStyle koHeadingSemiboldXl;
    final TextStyle koUnderlineMediumMd;
    final TextStyle koUnderlineMediumSm;
    final TextStyle numBodyMediumMd;
    final TextStyle numBodyMediumSm;
    final TextStyle numBodyMediumXl;
    final TextStyle numBodySemiboldMd;
    final TextStyle numBodySemiboldSm;
    final TextStyle numBodySemiboldXl;
    final TextStyle numCaptionMediumMd;
    final TextStyle numCaptionSemiboldMd;
    final TextStyle numHeadingBold2xl;
    final TextStyle numHeadingBoldLg;
    final TextStyle numHeadingBoldMd;
    final TextStyle numHeadingBoldXl;
    final TextStyle numHeadingMedium2xl;
    final TextStyle numHeadingMediumLg;
    final TextStyle numHeadingMediumMd;
    final TextStyle numHeadingMediumXl;
    final TextStyle numHeadingSemibold2xl;
    final TextStyle numHeadingSemibold3xl;
    final TextStyle numHeadingSemiboldLg;
    final TextStyle numHeadingSemiboldMd;
    final TextStyle numHeadingSemiboldXl;
    


}








class AppDoubleData  {
   const AppDoubleData({
      required this.enBodyMediumLgFontSize,
      required this.enBodyMediumLgLetterSpacing,
      required this.enBodyMediumLgLineHeight,
      required this.enBodyMediumLgParagraphIndent,
      required this.enBodyMediumLgParagraphSpacing,
      required this.enBodyMediumMdFontSize,
      required this.enBodyMediumMdLetterSpacing,
      required this.enBodyMediumMdLineHeight,
      required this.enBodyMediumMdParagraphIndent,
      required this.enBodyMediumMdParagraphSpacing,
      required this.enBodyMediumSmFontSize,
      required this.enBodyMediumSmLetterSpacing,
      required this.enBodyMediumSmLineHeight,
      required this.enBodyMediumSmParagraphIndent,
      required this.enBodyMediumSmParagraphSpacing,
      required this.enBodyMediumXlFontSize,
      required this.enBodyMediumXlLetterSpacing,
      required this.enBodyMediumXlLineHeight,
      required this.enBodyMediumXlParagraphIndent,
      required this.enBodyMediumXlParagraphSpacing,
      required this.enBodySemiboldLgFontSize,
      required this.enBodySemiboldLgLetterSpacing,
      required this.enBodySemiboldLgLineHeight,
      required this.enBodySemiboldLgParagraphIndent,
      required this.enBodySemiboldLgParagraphSpacing,
      required this.enBodySemiboldMdFontSize,
      required this.enBodySemiboldMdLetterSpacing,
      required this.enBodySemiboldMdLineHeight,
      required this.enBodySemiboldMdParagraphIndent,
      required this.enBodySemiboldMdParagraphSpacing,
      required this.enBodySemiboldSmFontSize,
      required this.enBodySemiboldSmLetterSpacing,
      required this.enBodySemiboldSmLineHeight,
      required this.enBodySemiboldSmParagraphIndent,
      required this.enBodySemiboldSmParagraphSpacing,
      required this.enBodySemiboldXlFontSize,
      required this.enBodySemiboldXlLetterSpacing,
      required this.enBodySemiboldXlLineHeight,
      required this.enBodySemiboldXlParagraphIndent,
      required this.enBodySemiboldXlParagraphSpacing,
      required this.enCaptionBoldMdFontSize,
      required this.enCaptionBoldMdLetterSpacing,
      required this.enCaptionBoldMdLineHeight,
      required this.enCaptionBoldMdParagraphIndent,
      required this.enCaptionBoldMdParagraphSpacing,
      required this.enCaptionMediumMdFontSize,
      required this.enCaptionMediumMdLetterSpacing,
      required this.enCaptionMediumMdLineHeight,
      required this.enCaptionMediumMdParagraphIndent,
      required this.enCaptionMediumMdParagraphSpacing,
      required this.enCaptionSemiboldMdFontSize,
      required this.enCaptionSemiboldMdLetterSpacing,
      required this.enCaptionSemiboldMdLineHeight,
      required this.enCaptionSemiboldMdParagraphIndent,
      required this.enCaptionSemiboldMdParagraphSpacing,
      required this.enHeadingBlackLgFontSize,
      required this.enHeadingBlackLgLetterSpacing,
      required this.enHeadingBlackLgLineHeight,
      required this.enHeadingBlackLgParagraphIndent,
      required this.enHeadingBlackLgParagraphSpacing,
      required this.enHeadingBlackMdFontSize,
      required this.enHeadingBlackMdLetterSpacing,
      required this.enHeadingBlackMdLineHeight,
      required this.enHeadingBlackMdParagraphIndent,
      required this.enHeadingBlackMdParagraphSpacing,
      required this.enHeadingBlackSmFontSize,
      required this.enHeadingBlackSmLetterSpacing,
      required this.enHeadingBlackSmLineHeight,
      required this.enHeadingBlackSmParagraphIndent,
      required this.enHeadingBlackSmParagraphSpacing,
      required this.enHeadingBlackXlFontSize,
      required this.enHeadingBlackXlLetterSpacing,
      required this.enHeadingBlackXlLineHeight,
      required this.enHeadingBlackXlParagraphIndent,
      required this.enHeadingBlackXlParagraphSpacing,
      required this.enHeadingBoldLgFontSize,
      required this.enHeadingBoldLgLetterSpacing,
      required this.enHeadingBoldLgLineHeight,
      required this.enHeadingBoldLgParagraphIndent,
      required this.enHeadingBoldLgParagraphSpacing,
      required this.enHeadingBoldMdFontSize,
      required this.enHeadingBoldMdLetterSpacing,
      required this.enHeadingBoldMdLineHeight,
      required this.enHeadingBoldMdParagraphIndent,
      required this.enHeadingBoldMdParagraphSpacing,
      required this.enHeadingBoldSmFontSize,
      required this.enHeadingBoldSmLetterSpacing,
      required this.enHeadingBoldSmLineHeight,
      required this.enHeadingBoldSmParagraphIndent,
      required this.enHeadingBoldSmParagraphSpacing,
      required this.enHeadingBoldXlFontSize,
      required this.enHeadingBoldXlLetterSpacing,
      required this.enHeadingBoldXlLineHeight,
      required this.enHeadingBoldXlParagraphIndent,
      required this.enHeadingBoldXlParagraphSpacing,
      required this.enHeadingMediumLgFontSize,
      required this.enHeadingMediumLgLetterSpacing,
      required this.enHeadingMediumLgLineHeight,
      required this.enHeadingMediumLgParagraphIndent,
      required this.enHeadingMediumLgParagraphSpacing,
      required this.enHeadingMediumMdFontSize,
      required this.enHeadingMediumMdLetterSpacing,
      required this.enHeadingMediumMdLineHeight,
      required this.enHeadingMediumMdParagraphIndent,
      required this.enHeadingMediumMdParagraphSpacing,
      required this.enHeadingMediumSmFontSize,
      required this.enHeadingMediumSmLetterSpacing,
      required this.enHeadingMediumSmLineHeight,
      required this.enHeadingMediumSmParagraphIndent,
      required this.enHeadingMediumSmParagraphSpacing,
      required this.enHeadingMediumXlFontSize,
      required this.enHeadingMediumXlLetterSpacing,
      required this.enHeadingMediumXlLineHeight,
      required this.enHeadingMediumXlParagraphIndent,
      required this.enHeadingMediumXlParagraphSpacing,
      required this.enUnderlineMediumSmFontSize,
      required this.enUnderlineMediumSmLetterSpacing,
      required this.enUnderlineMediumSmLineHeight,
      required this.enUnderlineMediumSmParagraphIndent,
      required this.enUnderlineMediumSmParagraphSpacing,
      required this.koBodyMediumLgFontSize,
      required this.koBodyMediumLgLetterSpacing,
      required this.koBodyMediumLgLineHeight,
      required this.koBodyMediumLgParagraphIndent,
      required this.koBodyMediumLgParagraphSpacing,
      required this.koBodyMediumMdFontSize,
      required this.koBodyMediumMdLetterSpacing,
      required this.koBodyMediumMdLineHeight,
      required this.koBodyMediumMdParagraphIndent,
      required this.koBodyMediumMdParagraphSpacing,
      required this.koBodyMediumSmFontSize,
      required this.koBodyMediumSmLetterSpacing,
      required this.koBodyMediumSmLineHeight,
      required this.koBodyMediumSmParagraphIndent,
      required this.koBodyMediumSmParagraphSpacing,
      required this.koBodyMediumXlFontSize,
      required this.koBodyMediumXlLetterSpacing,
      required this.koBodyMediumXlLineHeight,
      required this.koBodyMediumXlParagraphIndent,
      required this.koBodyMediumXlParagraphSpacing,
      required this.koBodySemiboldLgFontSize,
      required this.koBodySemiboldLgLetterSpacing,
      required this.koBodySemiboldLgLineHeight,
      required this.koBodySemiboldLgParagraphIndent,
      required this.koBodySemiboldLgParagraphSpacing,
      required this.koBodySemiboldMdFontSize,
      required this.koBodySemiboldMdLetterSpacing,
      required this.koBodySemiboldMdLineHeight,
      required this.koBodySemiboldMdParagraphIndent,
      required this.koBodySemiboldMdParagraphSpacing,
      required this.koBodySemiboldSmFontSize,
      required this.koBodySemiboldSmLetterSpacing,
      required this.koBodySemiboldSmLineHeight,
      required this.koBodySemiboldSmParagraphIndent,
      required this.koBodySemiboldSmParagraphSpacing,
      required this.koBodySemiboldXlFontSize,
      required this.koBodySemiboldXlLetterSpacing,
      required this.koBodySemiboldXlLineHeight,
      required this.koBodySemiboldXlParagraphIndent,
      required this.koBodySemiboldXlParagraphSpacing,
      required this.koCaptionMediumMdFontSize,
      required this.koCaptionMediumMdLetterSpacing,
      required this.koCaptionMediumMdLineHeight,
      required this.koCaptionMediumMdParagraphIndent,
      required this.koCaptionMediumMdParagraphSpacing,
      required this.koCaptionSemiboldMdFontSize,
      required this.koCaptionSemiboldMdLetterSpacing,
      required this.koCaptionSemiboldMdLineHeight,
      required this.koCaptionSemiboldMdParagraphIndent,
      required this.koCaptionSemiboldMdParagraphSpacing,
      required this.koHeadingBold2xlFontSize,
      required this.koHeadingBold2xlLetterSpacing,
      required this.koHeadingBold2xlLineHeight,
      required this.koHeadingBold2xlParagraphIndent,
      required this.koHeadingBold2xlParagraphSpacing,
      required this.koHeadingBoldLgFontSize,
      required this.koHeadingBoldLgLetterSpacing,
      required this.koHeadingBoldLgLineHeight,
      required this.koHeadingBoldLgParagraphIndent,
      required this.koHeadingBoldLgParagraphSpacing,
      required this.koHeadingBoldMdFontSize,
      required this.koHeadingBoldMdLetterSpacing,
      required this.koHeadingBoldMdLineHeight,
      required this.koHeadingBoldMdParagraphIndent,
      required this.koHeadingBoldMdParagraphSpacing,
      required this.koHeadingBoldSmFontSize,
      required this.koHeadingBoldSmLetterSpacing,
      required this.koHeadingBoldSmLineHeight,
      required this.koHeadingBoldSmParagraphIndent,
      required this.koHeadingBoldSmParagraphSpacing,
      required this.koHeadingBoldXlFontSize,
      required this.koHeadingBoldXlLetterSpacing,
      required this.koHeadingBoldXlLineHeight,
      required this.koHeadingBoldXlParagraphIndent,
      required this.koHeadingBoldXlParagraphSpacing,
      required this.koHeadingMedium2xlFontSize,
      required this.koHeadingMedium2xlLetterSpacing,
      required this.koHeadingMedium2xlLineHeight,
      required this.koHeadingMedium2xlParagraphIndent,
      required this.koHeadingMedium2xlParagraphSpacing,
      required this.koHeadingMediumLgFontSize,
      required this.koHeadingMediumLgLetterSpacing,
      required this.koHeadingMediumLgLineHeight,
      required this.koHeadingMediumLgParagraphIndent,
      required this.koHeadingMediumLgParagraphSpacing,
      required this.koHeadingMediumMdFontSize,
      required this.koHeadingMediumMdLetterSpacing,
      required this.koHeadingMediumMdLineHeight,
      required this.koHeadingMediumMdParagraphIndent,
      required this.koHeadingMediumMdParagraphSpacing,
      required this.koHeadingMediumSmFontSize,
      required this.koHeadingMediumSmLetterSpacing,
      required this.koHeadingMediumSmLineHeight,
      required this.koHeadingMediumSmParagraphIndent,
      required this.koHeadingMediumSmParagraphSpacing,
      required this.koHeadingMediumXlFontSize,
      required this.koHeadingMediumXlLetterSpacing,
      required this.koHeadingMediumXlLineHeight,
      required this.koHeadingMediumXlParagraphIndent,
      required this.koHeadingMediumXlParagraphSpacing,
      required this.koHeadingSemibold2xlFontSize,
      required this.koHeadingSemibold2xlLetterSpacing,
      required this.koHeadingSemibold2xlLineHeight,
      required this.koHeadingSemibold2xlParagraphIndent,
      required this.koHeadingSemibold2xlParagraphSpacing,
      required this.koHeadingSemiboldLgFontSize,
      required this.koHeadingSemiboldLgLetterSpacing,
      required this.koHeadingSemiboldLgLineHeight,
      required this.koHeadingSemiboldLgParagraphIndent,
      required this.koHeadingSemiboldLgParagraphSpacing,
      required this.koHeadingSemiboldMdFontSize,
      required this.koHeadingSemiboldMdLetterSpacing,
      required this.koHeadingSemiboldMdLineHeight,
      required this.koHeadingSemiboldMdParagraphIndent,
      required this.koHeadingSemiboldMdParagraphSpacing,
      required this.koHeadingSemiboldSmFontSize,
      required this.koHeadingSemiboldSmLetterSpacing,
      required this.koHeadingSemiboldSmLineHeight,
      required this.koHeadingSemiboldSmParagraphIndent,
      required this.koHeadingSemiboldSmParagraphSpacing,
      required this.koHeadingSemiboldXlFontSize,
      required this.koHeadingSemiboldXlLetterSpacing,
      required this.koHeadingSemiboldXlLineHeight,
      required this.koHeadingSemiboldXlParagraphIndent,
      required this.koHeadingSemiboldXlParagraphSpacing,
      required this.koUnderlineMediumMdFontSize,
      required this.koUnderlineMediumMdLetterSpacing,
      required this.koUnderlineMediumMdLineHeight,
      required this.koUnderlineMediumMdParagraphIndent,
      required this.koUnderlineMediumMdParagraphSpacing,
      required this.koUnderlineMediumSmFontSize,
      required this.koUnderlineMediumSmLetterSpacing,
      required this.koUnderlineMediumSmLineHeight,
      required this.koUnderlineMediumSmParagraphIndent,
      required this.koUnderlineMediumSmParagraphSpacing,
      required this.numBodyMediumMdFontSize,
      required this.numBodyMediumMdLetterSpacing,
      required this.numBodyMediumMdLineHeight,
      required this.numBodyMediumMdParagraphIndent,
      required this.numBodyMediumMdParagraphSpacing,
      required this.numBodyMediumSmFontSize,
      required this.numBodyMediumSmLetterSpacing,
      required this.numBodyMediumSmLineHeight,
      required this.numBodyMediumSmParagraphIndent,
      required this.numBodyMediumSmParagraphSpacing,
      required this.numBodyMediumXlFontSize,
      required this.numBodyMediumXlLetterSpacing,
      required this.numBodyMediumXlLineHeight,
      required this.numBodyMediumXlParagraphIndent,
      required this.numBodyMediumXlParagraphSpacing,
      required this.numBodySemiboldMdFontSize,
      required this.numBodySemiboldMdLetterSpacing,
      required this.numBodySemiboldMdLineHeight,
      required this.numBodySemiboldMdParagraphIndent,
      required this.numBodySemiboldMdParagraphSpacing,
      required this.numBodySemiboldSmFontSize,
      required this.numBodySemiboldSmLetterSpacing,
      required this.numBodySemiboldSmLineHeight,
      required this.numBodySemiboldSmParagraphIndent,
      required this.numBodySemiboldSmParagraphSpacing,
      required this.numBodySemiboldXlFontSize,
      required this.numBodySemiboldXlLetterSpacing,
      required this.numBodySemiboldXlLineHeight,
      required this.numBodySemiboldXlParagraphIndent,
      required this.numBodySemiboldXlParagraphSpacing,
      required this.numCaptionMediumMdFontSize,
      required this.numCaptionMediumMdLetterSpacing,
      required this.numCaptionMediumMdLineHeight,
      required this.numCaptionMediumMdParagraphIndent,
      required this.numCaptionMediumMdParagraphSpacing,
      required this.numCaptionSemiboldMdFontSize,
      required this.numCaptionSemiboldMdLetterSpacing,
      required this.numCaptionSemiboldMdLineHeight,
      required this.numCaptionSemiboldMdParagraphIndent,
      required this.numCaptionSemiboldMdParagraphSpacing,
      required this.numHeadingBold2xlFontSize,
      required this.numHeadingBold2xlLetterSpacing,
      required this.numHeadingBold2xlLineHeight,
      required this.numHeadingBold2xlParagraphIndent,
      required this.numHeadingBold2xlParagraphSpacing,
      required this.numHeadingBoldLgFontSize,
      required this.numHeadingBoldLgLetterSpacing,
      required this.numHeadingBoldLgLineHeight,
      required this.numHeadingBoldLgParagraphIndent,
      required this.numHeadingBoldLgParagraphSpacing,
      required this.numHeadingBoldMdFontSize,
      required this.numHeadingBoldMdLetterSpacing,
      required this.numHeadingBoldMdLineHeight,
      required this.numHeadingBoldMdParagraphIndent,
      required this.numHeadingBoldMdParagraphSpacing,
      required this.numHeadingBoldXlFontSize,
      required this.numHeadingBoldXlLetterSpacing,
      required this.numHeadingBoldXlLineHeight,
      required this.numHeadingBoldXlParagraphIndent,
      required this.numHeadingBoldXlParagraphSpacing,
      required this.numHeadingMedium2xlFontSize,
      required this.numHeadingMedium2xlLetterSpacing,
      required this.numHeadingMedium2xlLineHeight,
      required this.numHeadingMedium2xlParagraphIndent,
      required this.numHeadingMedium2xlParagraphSpacing,
      required this.numHeadingMediumLgFontSize,
      required this.numHeadingMediumLgLetterSpacing,
      required this.numHeadingMediumLgLineHeight,
      required this.numHeadingMediumLgParagraphIndent,
      required this.numHeadingMediumLgParagraphSpacing,
      required this.numHeadingMediumMdFontSize,
      required this.numHeadingMediumMdLetterSpacing,
      required this.numHeadingMediumMdLineHeight,
      required this.numHeadingMediumMdParagraphIndent,
      required this.numHeadingMediumMdParagraphSpacing,
      required this.numHeadingMediumXlFontSize,
      required this.numHeadingMediumXlLetterSpacing,
      required this.numHeadingMediumXlLineHeight,
      required this.numHeadingMediumXlParagraphIndent,
      required this.numHeadingMediumXlParagraphSpacing,
      required this.numHeadingSemibold2xlFontSize,
      required this.numHeadingSemibold2xlLetterSpacing,
      required this.numHeadingSemibold2xlLineHeight,
      required this.numHeadingSemibold2xlParagraphIndent,
      required this.numHeadingSemibold2xlParagraphSpacing,
      required this.numHeadingSemibold3xlFontSize,
      required this.numHeadingSemibold3xlLetterSpacing,
      required this.numHeadingSemibold3xlLineHeight,
      required this.numHeadingSemibold3xlParagraphIndent,
      required this.numHeadingSemibold3xlParagraphSpacing,
      required this.numHeadingSemiboldLgFontSize,
      required this.numHeadingSemiboldLgLetterSpacing,
      required this.numHeadingSemiboldLgLineHeight,
      required this.numHeadingSemiboldLgParagraphIndent,
      required this.numHeadingSemiboldLgParagraphSpacing,
      required this.numHeadingSemiboldMdFontSize,
      required this.numHeadingSemiboldMdLetterSpacing,
      required this.numHeadingSemiboldMdLineHeight,
      required this.numHeadingSemiboldMdParagraphIndent,
      required this.numHeadingSemiboldMdParagraphSpacing,
      required this.numHeadingSemiboldXlFontSize,
      required this.numHeadingSemiboldXlLetterSpacing,
      required this.numHeadingSemiboldXlLineHeight,
      required this.numHeadingSemiboldXlParagraphIndent,
      required this.numHeadingSemiboldXlParagraphSpacing,
      required this.numberCardW104,
      required this.numberCardW108,
      required this.numberCardW114,
      required this.numberCardW174,
      required this.numberCardW316,
      required this.numberCardW358,
      required this.numberCardW390,
      required this.numberCardW82,
      required this.numberRadius0,
      required this.numberRadius12,
      required this.numberRadius16,
      required this.numberRadius20,
      required this.numberRadius4,
      required this.numberRadius8,
      required this.numberRadiusCircle,
      required this.numberSpacing0,
      required this.numberSpacing10,
      required this.numberSpacing12,
      required this.numberSpacing16,
      required this.numberSpacing2,
      required this.numberSpacing20,
      required this.numberSpacing24,
      required this.numberSpacing28,
      required this.numberSpacing32,
      required this.numberSpacing36,
      required this.numberSpacing4,
      required this.numberSpacing40,
      required this.numberSpacing44,
      required this.numberSpacing48,
      required this.numberSpacing52,
      required this.numberSpacing56,
      required this.numberSpacing60,
      required this.numberSpacing64,
      required this.numberSpacing68,
      required this.numberSpacing72,
      required this.numberSpacing76,
      required this.numberSpacing8,
      required this.numberSpacing80,
      required this.numberStroke1,
      required this.numberStroke2,
      required this.numberStroke4,
      required this.unit0,
      required this.unit1,
      required this.unit10,
      required this.unit100,
      required this.unit104,
      required this.unit108,
      required this.unit112,
      required this.unit114,
      required this.unit116,
      required this.unit12,
      required this.unit120,
      required this.unit124,
      required this.unit128,
      required this.unit132,
      required this.unit136,
      required this.unit140,
      required this.unit144,
      required this.unit148,
      required this.unit152,
      required this.unit156,
      required this.unit16,
      required this.unit160,
      required this.unit164,
      required this.unit168,
      required this.unit172,
      required this.unit174,
      required this.unit176,
      required this.unit2,
      required this.unit20,
      required this.unit24,
      required this.unit28,
      required this.unit312,
      required this.unit316,
      required this.unit32,
      required this.unit358,
      required this.unit36,
      required this.unit390,
      required this.unit4,
      required this.unit40,
      required this.unit44,
      required this.unit48,
      required this.unit52,
      required this.unit56,
      required this.unit60,
      required this.unit64,
      required this.unit68,
      required this.unit72,
      required this.unit76,
      required this.unit8,
      required this.unit80,
      required this.unit82,
      required this.unit88,
      required this.unit92,
      required this.unit96,
    });



    factory AppDoubleData.regular() => const AppDoubleData(
      enBodyMediumLgFontSize: 16,
      enBodyMediumLgLetterSpacing: -0.32,
      enBodyMediumLgLineHeight: 22.4,
      enBodyMediumLgParagraphIndent: 0,
      enBodyMediumLgParagraphSpacing: 0,
      enBodyMediumMdFontSize: 14,
      enBodyMediumMdLetterSpacing: -0.28,
      enBodyMediumMdLineHeight: 19.6,
      enBodyMediumMdParagraphIndent: 0,
      enBodyMediumMdParagraphSpacing: 0,
      enBodyMediumSmFontSize: 12,
      enBodyMediumSmLetterSpacing: -0.24,
      enBodyMediumSmLineHeight: 16.8,
      enBodyMediumSmParagraphIndent: 0,
      enBodyMediumSmParagraphSpacing: 0,
      enBodyMediumXlFontSize: 18,
      enBodyMediumXlLetterSpacing: -0.36,
      enBodyMediumXlLineHeight: 25.2,
      enBodyMediumXlParagraphIndent: 0,
      enBodyMediumXlParagraphSpacing: 0,
      enBodySemiboldLgFontSize: 16,
      enBodySemiboldLgLetterSpacing: -0.32,
      enBodySemiboldLgLineHeight: 22.4,
      enBodySemiboldLgParagraphIndent: 0,
      enBodySemiboldLgParagraphSpacing: 0,
      enBodySemiboldMdFontSize: 14,
      enBodySemiboldMdLetterSpacing: -0.28,
      enBodySemiboldMdLineHeight: 19.6,
      enBodySemiboldMdParagraphIndent: 0,
      enBodySemiboldMdParagraphSpacing: 0,
      enBodySemiboldSmFontSize: 12,
      enBodySemiboldSmLetterSpacing: -0.24,
      enBodySemiboldSmLineHeight: 16.8,
      enBodySemiboldSmParagraphIndent: 0,
      enBodySemiboldSmParagraphSpacing: 0,
      enBodySemiboldXlFontSize: 18,
      enBodySemiboldXlLetterSpacing: -0.36,
      enBodySemiboldXlLineHeight: 25.2,
      enBodySemiboldXlParagraphIndent: 0,
      enBodySemiboldXlParagraphSpacing: 0,
      enCaptionBoldMdFontSize: 10,
      enCaptionBoldMdLetterSpacing: 0,
      enCaptionBoldMdLineHeight: 14,
      enCaptionBoldMdParagraphIndent: 0,
      enCaptionBoldMdParagraphSpacing: 0,
      enCaptionMediumMdFontSize: 10,
      enCaptionMediumMdLetterSpacing: -0.2,
      enCaptionMediumMdLineHeight: 14,
      enCaptionMediumMdParagraphIndent: 0,
      enCaptionMediumMdParagraphSpacing: 0,
      enCaptionSemiboldMdFontSize: 10,
      enCaptionSemiboldMdLetterSpacing: -0.2,
      enCaptionSemiboldMdLineHeight: 14,
      enCaptionSemiboldMdParagraphIndent: 0,
      enCaptionSemiboldMdParagraphSpacing: 0,
      enHeadingBlackLgFontSize: 28,
      enHeadingBlackLgLetterSpacing: -0.392,
      enHeadingBlackLgLineHeight: 44.8,
      enHeadingBlackLgParagraphIndent: 0,
      enHeadingBlackLgParagraphSpacing: 0,
      enHeadingBlackMdFontSize: 24,
      enHeadingBlackMdLetterSpacing: -0.336,
      enHeadingBlackMdLineHeight: 38.4,
      enHeadingBlackMdParagraphIndent: 0,
      enHeadingBlackMdParagraphSpacing: 0,
      enHeadingBlackSmFontSize: 20,
      enHeadingBlackSmLetterSpacing: -0.28,
      enHeadingBlackSmLineHeight: 32,
      enHeadingBlackSmParagraphIndent: 0,
      enHeadingBlackSmParagraphSpacing: 0,
      enHeadingBlackXlFontSize: 32,
      enHeadingBlackXlLetterSpacing: -0.448,
      enHeadingBlackXlLineHeight: 51.2,
      enHeadingBlackXlParagraphIndent: 0,
      enHeadingBlackXlParagraphSpacing: 0,
      enHeadingBoldLgFontSize: 28,
      enHeadingBoldLgLetterSpacing: -0.392,
      enHeadingBoldLgLineHeight: 44.8,
      enHeadingBoldLgParagraphIndent: 0,
      enHeadingBoldLgParagraphSpacing: 0,
      enHeadingBoldMdFontSize: 24,
      enHeadingBoldMdLetterSpacing: -0.336,
      enHeadingBoldMdLineHeight: 38.4,
      enHeadingBoldMdParagraphIndent: 0,
      enHeadingBoldMdParagraphSpacing: 0,
      enHeadingBoldSmFontSize: 20,
      enHeadingBoldSmLetterSpacing: -0.28,
      enHeadingBoldSmLineHeight: 32,
      enHeadingBoldSmParagraphIndent: 0,
      enHeadingBoldSmParagraphSpacing: 0,
      enHeadingBoldXlFontSize: 32,
      enHeadingBoldXlLetterSpacing: -0.448,
      enHeadingBoldXlLineHeight: 51.2,
      enHeadingBoldXlParagraphIndent: 0,
      enHeadingBoldXlParagraphSpacing: 0,
      enHeadingMediumLgFontSize: 28,
      enHeadingMediumLgLetterSpacing: -0.392,
      enHeadingMediumLgLineHeight: 44.8,
      enHeadingMediumLgParagraphIndent: 0,
      enHeadingMediumLgParagraphSpacing: 0,
      enHeadingMediumMdFontSize: 24,
      enHeadingMediumMdLetterSpacing: -0.336,
      enHeadingMediumMdLineHeight: 38.4,
      enHeadingMediumMdParagraphIndent: 0,
      enHeadingMediumMdParagraphSpacing: 0,
      enHeadingMediumSmFontSize: 20,
      enHeadingMediumSmLetterSpacing: -0.28,
      enHeadingMediumSmLineHeight: 32,
      enHeadingMediumSmParagraphIndent: 0,
      enHeadingMediumSmParagraphSpacing: 0,
      enHeadingMediumXlFontSize: 32,
      enHeadingMediumXlLetterSpacing: -0.448,
      enHeadingMediumXlLineHeight: 51.2,
      enHeadingMediumXlParagraphIndent: 0,
      enHeadingMediumXlParagraphSpacing: 0,
      enUnderlineMediumSmFontSize: 16,
      enUnderlineMediumSmLetterSpacing: -0.32,
      enUnderlineMediumSmLineHeight: 22.4,
      enUnderlineMediumSmParagraphIndent: 0,
      enUnderlineMediumSmParagraphSpacing: 0,
      koBodyMediumLgFontSize: 16,
      koBodyMediumLgLetterSpacing: 0,
      koBodyMediumLgLineHeight: 22.4,
      koBodyMediumLgParagraphIndent: 0,
      koBodyMediumLgParagraphSpacing: 0,
      koBodyMediumMdFontSize: 14,
      koBodyMediumMdLetterSpacing: 0,
      koBodyMediumMdLineHeight: 19.6,
      koBodyMediumMdParagraphIndent: 0,
      koBodyMediumMdParagraphSpacing: 0,
      koBodyMediumSmFontSize: 12,
      koBodyMediumSmLetterSpacing: 0,
      koBodyMediumSmLineHeight: 16.8,
      koBodyMediumSmParagraphIndent: 0,
      koBodyMediumSmParagraphSpacing: 0,
      koBodyMediumXlFontSize: 18,
      koBodyMediumXlLetterSpacing: 0,
      koBodyMediumXlLineHeight: 25.2,
      koBodyMediumXlParagraphIndent: 0,
      koBodyMediumXlParagraphSpacing: 0,
      koBodySemiboldLgFontSize: 16,
      koBodySemiboldLgLetterSpacing: 0,
      koBodySemiboldLgLineHeight: 22.4,
      koBodySemiboldLgParagraphIndent: 0,
      koBodySemiboldLgParagraphSpacing: 0,
      koBodySemiboldMdFontSize: 14,
      koBodySemiboldMdLetterSpacing: 0,
      koBodySemiboldMdLineHeight: 19.6,
      koBodySemiboldMdParagraphIndent: 0,
      koBodySemiboldMdParagraphSpacing: 0,
      koBodySemiboldSmFontSize: 12,
      koBodySemiboldSmLetterSpacing: 0,
      koBodySemiboldSmLineHeight: 16.8,
      koBodySemiboldSmParagraphIndent: 0,
      koBodySemiboldSmParagraphSpacing: 0,
      koBodySemiboldXlFontSize: 18,
      koBodySemiboldXlLetterSpacing: 0,
      koBodySemiboldXlLineHeight: 25.2,
      koBodySemiboldXlParagraphIndent: 0,
      koBodySemiboldXlParagraphSpacing: 0,
      koCaptionMediumMdFontSize: 10,
      koCaptionMediumMdLetterSpacing: 0,
      koCaptionMediumMdLineHeight: 14,
      koCaptionMediumMdParagraphIndent: 0,
      koCaptionMediumMdParagraphSpacing: 0,
      koCaptionSemiboldMdFontSize: 10,
      koCaptionSemiboldMdLetterSpacing: 0,
      koCaptionSemiboldMdLineHeight: 14,
      koCaptionSemiboldMdParagraphIndent: 0,
      koCaptionSemiboldMdParagraphSpacing: 0,
      koHeadingBold2xlFontSize: 36,
      koHeadingBold2xlLetterSpacing: 0,
      koHeadingBold2xlLineHeight: 57.6,
      koHeadingBold2xlParagraphIndent: 0,
      koHeadingBold2xlParagraphSpacing: 0,
      koHeadingBoldLgFontSize: 28,
      koHeadingBoldLgLetterSpacing: 0,
      koHeadingBoldLgLineHeight: 39.2,
      koHeadingBoldLgParagraphIndent: 0,
      koHeadingBoldLgParagraphSpacing: 0,
      koHeadingBoldMdFontSize: 24,
      koHeadingBoldMdLetterSpacing: 0,
      koHeadingBoldMdLineHeight: 33.6,
      koHeadingBoldMdParagraphIndent: 0,
      koHeadingBoldMdParagraphSpacing: 0,
      koHeadingBoldSmFontSize: 20,
      koHeadingBoldSmLetterSpacing: 0,
      koHeadingBoldSmLineHeight: 28,
      koHeadingBoldSmParagraphIndent: 0,
      koHeadingBoldSmParagraphSpacing: 0,
      koHeadingBoldXlFontSize: 32,
      koHeadingBoldXlLetterSpacing: 0,
      koHeadingBoldXlLineHeight: 44.8,
      koHeadingBoldXlParagraphIndent: 0,
      koHeadingBoldXlParagraphSpacing: 0,
      koHeadingMedium2xlFontSize: 36,
      koHeadingMedium2xlLetterSpacing: 0,
      koHeadingMedium2xlLineHeight: 57.6,
      koHeadingMedium2xlParagraphIndent: 0,
      koHeadingMedium2xlParagraphSpacing: 0,
      koHeadingMediumLgFontSize: 28,
      koHeadingMediumLgLetterSpacing: 0,
      koHeadingMediumLgLineHeight: 39.2,
      koHeadingMediumLgParagraphIndent: 0,
      koHeadingMediumLgParagraphSpacing: 0,
      koHeadingMediumMdFontSize: 24,
      koHeadingMediumMdLetterSpacing: 0,
      koHeadingMediumMdLineHeight: 33.6,
      koHeadingMediumMdParagraphIndent: 0,
      koHeadingMediumMdParagraphSpacing: 0,
      koHeadingMediumSmFontSize: 20,
      koHeadingMediumSmLetterSpacing: 0,
      koHeadingMediumSmLineHeight: 28,
      koHeadingMediumSmParagraphIndent: 0,
      koHeadingMediumSmParagraphSpacing: 0,
      koHeadingMediumXlFontSize: 32,
      koHeadingMediumXlLetterSpacing: 0,
      koHeadingMediumXlLineHeight: 44.8,
      koHeadingMediumXlParagraphIndent: 0,
      koHeadingMediumXlParagraphSpacing: 0,
      koHeadingSemibold2xlFontSize: 36,
      koHeadingSemibold2xlLetterSpacing: 0,
      koHeadingSemibold2xlLineHeight: 57.6,
      koHeadingSemibold2xlParagraphIndent: 0,
      koHeadingSemibold2xlParagraphSpacing: 0,
      koHeadingSemiboldLgFontSize: 28,
      koHeadingSemiboldLgLetterSpacing: 0,
      koHeadingSemiboldLgLineHeight: 39.2,
      koHeadingSemiboldLgParagraphIndent: 0,
      koHeadingSemiboldLgParagraphSpacing: 0,
      koHeadingSemiboldMdFontSize: 24,
      koHeadingSemiboldMdLetterSpacing: 0,
      koHeadingSemiboldMdLineHeight: 33.6,
      koHeadingSemiboldMdParagraphIndent: 0,
      koHeadingSemiboldMdParagraphSpacing: 0,
      koHeadingSemiboldSmFontSize: 20,
      koHeadingSemiboldSmLetterSpacing: 0,
      koHeadingSemiboldSmLineHeight: 28,
      koHeadingSemiboldSmParagraphIndent: 0,
      koHeadingSemiboldSmParagraphSpacing: 0,
      koHeadingSemiboldXlFontSize: 32,
      koHeadingSemiboldXlLetterSpacing: 0,
      koHeadingSemiboldXlLineHeight: 44.8,
      koHeadingSemiboldXlParagraphIndent: 0,
      koHeadingSemiboldXlParagraphSpacing: 0,
      koUnderlineMediumMdFontSize: 16,
      koUnderlineMediumMdLetterSpacing: 0,
      koUnderlineMediumMdLineHeight: 22.4,
      koUnderlineMediumMdParagraphIndent: 0,
      koUnderlineMediumMdParagraphSpacing: 0,
      koUnderlineMediumSmFontSize: 14,
      koUnderlineMediumSmLetterSpacing: 0,
      koUnderlineMediumSmLineHeight: 19.6,
      koUnderlineMediumSmParagraphIndent: 0,
      koUnderlineMediumSmParagraphSpacing: 0,
      numBodyMediumMdFontSize: 14,
      numBodyMediumMdLetterSpacing: 0,
      numBodyMediumMdLineHeight: 19.6,
      numBodyMediumMdParagraphIndent: 0,
      numBodyMediumMdParagraphSpacing: 0,
      numBodyMediumSmFontSize: 12,
      numBodyMediumSmLetterSpacing: 0,
      numBodyMediumSmLineHeight: 16.8,
      numBodyMediumSmParagraphIndent: 0,
      numBodyMediumSmParagraphSpacing: 0,
      numBodyMediumXlFontSize: 18,
      numBodyMediumXlLetterSpacing: 0,
      numBodyMediumXlLineHeight: 25.2,
      numBodyMediumXlParagraphIndent: 0,
      numBodyMediumXlParagraphSpacing: 0,
      numBodySemiboldMdFontSize: 14,
      numBodySemiboldMdLetterSpacing: 0,
      numBodySemiboldMdLineHeight: 19.6,
      numBodySemiboldMdParagraphIndent: 0,
      numBodySemiboldMdParagraphSpacing: 0,
      numBodySemiboldSmFontSize: 12,
      numBodySemiboldSmLetterSpacing: 0,
      numBodySemiboldSmLineHeight: 16.8,
      numBodySemiboldSmParagraphIndent: 0,
      numBodySemiboldSmParagraphSpacing: 0,
      numBodySemiboldXlFontSize: 18,
      numBodySemiboldXlLetterSpacing: 0,
      numBodySemiboldXlLineHeight: 25.2,
      numBodySemiboldXlParagraphIndent: 0,
      numBodySemiboldXlParagraphSpacing: 0,
      numCaptionMediumMdFontSize: 10,
      numCaptionMediumMdLetterSpacing: -0.08,
      numCaptionMediumMdLineHeight: 14,
      numCaptionMediumMdParagraphIndent: 0,
      numCaptionMediumMdParagraphSpacing: 0,
      numCaptionSemiboldMdFontSize: 10,
      numCaptionSemiboldMdLetterSpacing: -0.08,
      numCaptionSemiboldMdLineHeight: 14,
      numCaptionSemiboldMdParagraphIndent: 0,
      numCaptionSemiboldMdParagraphSpacing: 0,
      numHeadingBold2xlFontSize: 36,
      numHeadingBold2xlLetterSpacing: 0,
      numHeadingBold2xlLineHeight: 57.6,
      numHeadingBold2xlParagraphIndent: 0,
      numHeadingBold2xlParagraphSpacing: 0,
      numHeadingBoldLgFontSize: 28,
      numHeadingBoldLgLetterSpacing: 0,
      numHeadingBoldLgLineHeight: 44.8,
      numHeadingBoldLgParagraphIndent: 0,
      numHeadingBoldLgParagraphSpacing: 0,
      numHeadingBoldMdFontSize: 24,
      numHeadingBoldMdLetterSpacing: 0,
      numHeadingBoldMdLineHeight: 38.4,
      numHeadingBoldMdParagraphIndent: 0,
      numHeadingBoldMdParagraphSpacing: 0,
      numHeadingBoldXlFontSize: 32,
      numHeadingBoldXlLetterSpacing: 0,
      numHeadingBoldXlLineHeight: 51.2,
      numHeadingBoldXlParagraphIndent: 0,
      numHeadingBoldXlParagraphSpacing: 0,
      numHeadingMedium2xlFontSize: 36,
      numHeadingMedium2xlLetterSpacing: 0,
      numHeadingMedium2xlLineHeight: 57.6,
      numHeadingMedium2xlParagraphIndent: 0,
      numHeadingMedium2xlParagraphSpacing: 0,
      numHeadingMediumLgFontSize: 28,
      numHeadingMediumLgLetterSpacing: 0,
      numHeadingMediumLgLineHeight: 44.8,
      numHeadingMediumLgParagraphIndent: 0,
      numHeadingMediumLgParagraphSpacing: 0,
      numHeadingMediumMdFontSize: 24,
      numHeadingMediumMdLetterSpacing: 0,
      numHeadingMediumMdLineHeight: 38.4,
      numHeadingMediumMdParagraphIndent: 0,
      numHeadingMediumMdParagraphSpacing: 0,
      numHeadingMediumXlFontSize: 32,
      numHeadingMediumXlLetterSpacing: 0,
      numHeadingMediumXlLineHeight: 51.2,
      numHeadingMediumXlParagraphIndent: 0,
      numHeadingMediumXlParagraphSpacing: 0,
      numHeadingSemibold2xlFontSize: 36,
      numHeadingSemibold2xlLetterSpacing: 0,
      numHeadingSemibold2xlLineHeight: 57.6,
      numHeadingSemibold2xlParagraphIndent: 0,
      numHeadingSemibold2xlParagraphSpacing: 0,
      numHeadingSemibold3xlFontSize: 50,
      numHeadingSemibold3xlLetterSpacing: 0,
      numHeadingSemibold3xlLineHeight: 80,
      numHeadingSemibold3xlParagraphIndent: 0,
      numHeadingSemibold3xlParagraphSpacing: 0,
      numHeadingSemiboldLgFontSize: 28,
      numHeadingSemiboldLgLetterSpacing: 0,
      numHeadingSemiboldLgLineHeight: 44.8,
      numHeadingSemiboldLgParagraphIndent: 0,
      numHeadingSemiboldLgParagraphSpacing: 0,
      numHeadingSemiboldMdFontSize: 24,
      numHeadingSemiboldMdLetterSpacing: 0,
      numHeadingSemiboldMdLineHeight: 38.4,
      numHeadingSemiboldMdParagraphIndent: 0,
      numHeadingSemiboldMdParagraphSpacing: 0,
      numHeadingSemiboldXlFontSize: 32,
      numHeadingSemiboldXlLetterSpacing: 0,
      numHeadingSemiboldXlLineHeight: 51.2,
      numHeadingSemiboldXlParagraphIndent: 0,
      numHeadingSemiboldXlParagraphSpacing: 0,
      numberCardW104: 104,
      numberCardW108: 108,
      numberCardW114: 114,
      numberCardW174: 174,
      numberCardW316: 316,
      numberCardW358: 358,
      numberCardW390: 390,
      numberCardW82: 82,
      numberRadius0: 0,
      numberRadius12: 12,
      numberRadius16: 16,
      numberRadius20: 20,
      numberRadius4: 4,
      numberRadius8: 8,
      numberRadiusCircle: 999,
      numberSpacing0: 0,
      numberSpacing10: 10,
      numberSpacing12: 12,
      numberSpacing16: 16,
      numberSpacing2: 2,
      numberSpacing20: 20,
      numberSpacing24: 24,
      numberSpacing28: 28,
      numberSpacing32: 32,
      numberSpacing36: 36,
      numberSpacing4: 4,
      numberSpacing40: 40,
      numberSpacing44: 44,
      numberSpacing48: 48,
      numberSpacing52: 52,
      numberSpacing56: 56,
      numberSpacing60: 60,
      numberSpacing64: 64,
      numberSpacing68: 68,
      numberSpacing72: 72,
      numberSpacing76: 76,
      numberSpacing8: 8,
      numberSpacing80: 80,
      numberStroke1: 1,
      numberStroke2: 2,
      numberStroke4: 4,
      unit0: 0,
      unit1: 1,
      unit10: 10,
      unit100: 100,
      unit104: 104,
      unit108: 108,
      unit112: 112,
      unit114: 114,
      unit116: 116,
      unit12: 12,
      unit120: 120,
      unit124: 124,
      unit128: 128,
      unit132: 132,
      unit136: 136,
      unit140: 140,
      unit144: 144,
      unit148: 148,
      unit152: 152,
      unit156: 156,
      unit16: 16,
      unit160: 160,
      unit164: 164,
      unit168: 168,
      unit172: 172,
      unit174: 174,
      unit176: 176,
      unit2: 2,
      unit20: 20,
      unit24: 24,
      unit28: 28,
      unit312: 312,
      unit316: 316,
      unit32: 32,
      unit358: 358,
      unit36: 36,
      unit390: 390,
      unit4: 4,
      unit40: 40,
      unit44: 44,
      unit48: 48,
      unit52: 52,
      unit56: 56,
      unit60: 60,
      unit64: 64,
      unit68: 68,
      unit72: 72,
      unit76: 76,
      unit8: 8,
      unit80: 80,
      unit82: 82,
      unit88: 88,
      unit92: 92,
      unit96: 96,
    );


    final double enBodyMediumLgFontSize;
    final double enBodyMediumLgLetterSpacing;
    final double enBodyMediumLgLineHeight;
    final double enBodyMediumLgParagraphIndent;
    final double enBodyMediumLgParagraphSpacing;
    final double enBodyMediumMdFontSize;
    final double enBodyMediumMdLetterSpacing;
    final double enBodyMediumMdLineHeight;
    final double enBodyMediumMdParagraphIndent;
    final double enBodyMediumMdParagraphSpacing;
    final double enBodyMediumSmFontSize;
    final double enBodyMediumSmLetterSpacing;
    final double enBodyMediumSmLineHeight;
    final double enBodyMediumSmParagraphIndent;
    final double enBodyMediumSmParagraphSpacing;
    final double enBodyMediumXlFontSize;
    final double enBodyMediumXlLetterSpacing;
    final double enBodyMediumXlLineHeight;
    final double enBodyMediumXlParagraphIndent;
    final double enBodyMediumXlParagraphSpacing;
    final double enBodySemiboldLgFontSize;
    final double enBodySemiboldLgLetterSpacing;
    final double enBodySemiboldLgLineHeight;
    final double enBodySemiboldLgParagraphIndent;
    final double enBodySemiboldLgParagraphSpacing;
    final double enBodySemiboldMdFontSize;
    final double enBodySemiboldMdLetterSpacing;
    final double enBodySemiboldMdLineHeight;
    final double enBodySemiboldMdParagraphIndent;
    final double enBodySemiboldMdParagraphSpacing;
    final double enBodySemiboldSmFontSize;
    final double enBodySemiboldSmLetterSpacing;
    final double enBodySemiboldSmLineHeight;
    final double enBodySemiboldSmParagraphIndent;
    final double enBodySemiboldSmParagraphSpacing;
    final double enBodySemiboldXlFontSize;
    final double enBodySemiboldXlLetterSpacing;
    final double enBodySemiboldXlLineHeight;
    final double enBodySemiboldXlParagraphIndent;
    final double enBodySemiboldXlParagraphSpacing;
    final double enCaptionBoldMdFontSize;
    final double enCaptionBoldMdLetterSpacing;
    final double enCaptionBoldMdLineHeight;
    final double enCaptionBoldMdParagraphIndent;
    final double enCaptionBoldMdParagraphSpacing;
    final double enCaptionMediumMdFontSize;
    final double enCaptionMediumMdLetterSpacing;
    final double enCaptionMediumMdLineHeight;
    final double enCaptionMediumMdParagraphIndent;
    final double enCaptionMediumMdParagraphSpacing;
    final double enCaptionSemiboldMdFontSize;
    final double enCaptionSemiboldMdLetterSpacing;
    final double enCaptionSemiboldMdLineHeight;
    final double enCaptionSemiboldMdParagraphIndent;
    final double enCaptionSemiboldMdParagraphSpacing;
    final double enHeadingBlackLgFontSize;
    final double enHeadingBlackLgLetterSpacing;
    final double enHeadingBlackLgLineHeight;
    final double enHeadingBlackLgParagraphIndent;
    final double enHeadingBlackLgParagraphSpacing;
    final double enHeadingBlackMdFontSize;
    final double enHeadingBlackMdLetterSpacing;
    final double enHeadingBlackMdLineHeight;
    final double enHeadingBlackMdParagraphIndent;
    final double enHeadingBlackMdParagraphSpacing;
    final double enHeadingBlackSmFontSize;
    final double enHeadingBlackSmLetterSpacing;
    final double enHeadingBlackSmLineHeight;
    final double enHeadingBlackSmParagraphIndent;
    final double enHeadingBlackSmParagraphSpacing;
    final double enHeadingBlackXlFontSize;
    final double enHeadingBlackXlLetterSpacing;
    final double enHeadingBlackXlLineHeight;
    final double enHeadingBlackXlParagraphIndent;
    final double enHeadingBlackXlParagraphSpacing;
    final double enHeadingBoldLgFontSize;
    final double enHeadingBoldLgLetterSpacing;
    final double enHeadingBoldLgLineHeight;
    final double enHeadingBoldLgParagraphIndent;
    final double enHeadingBoldLgParagraphSpacing;
    final double enHeadingBoldMdFontSize;
    final double enHeadingBoldMdLetterSpacing;
    final double enHeadingBoldMdLineHeight;
    final double enHeadingBoldMdParagraphIndent;
    final double enHeadingBoldMdParagraphSpacing;
    final double enHeadingBoldSmFontSize;
    final double enHeadingBoldSmLetterSpacing;
    final double enHeadingBoldSmLineHeight;
    final double enHeadingBoldSmParagraphIndent;
    final double enHeadingBoldSmParagraphSpacing;
    final double enHeadingBoldXlFontSize;
    final double enHeadingBoldXlLetterSpacing;
    final double enHeadingBoldXlLineHeight;
    final double enHeadingBoldXlParagraphIndent;
    final double enHeadingBoldXlParagraphSpacing;
    final double enHeadingMediumLgFontSize;
    final double enHeadingMediumLgLetterSpacing;
    final double enHeadingMediumLgLineHeight;
    final double enHeadingMediumLgParagraphIndent;
    final double enHeadingMediumLgParagraphSpacing;
    final double enHeadingMediumMdFontSize;
    final double enHeadingMediumMdLetterSpacing;
    final double enHeadingMediumMdLineHeight;
    final double enHeadingMediumMdParagraphIndent;
    final double enHeadingMediumMdParagraphSpacing;
    final double enHeadingMediumSmFontSize;
    final double enHeadingMediumSmLetterSpacing;
    final double enHeadingMediumSmLineHeight;
    final double enHeadingMediumSmParagraphIndent;
    final double enHeadingMediumSmParagraphSpacing;
    final double enHeadingMediumXlFontSize;
    final double enHeadingMediumXlLetterSpacing;
    final double enHeadingMediumXlLineHeight;
    final double enHeadingMediumXlParagraphIndent;
    final double enHeadingMediumXlParagraphSpacing;
    final double enUnderlineMediumSmFontSize;
    final double enUnderlineMediumSmLetterSpacing;
    final double enUnderlineMediumSmLineHeight;
    final double enUnderlineMediumSmParagraphIndent;
    final double enUnderlineMediumSmParagraphSpacing;
    final double koBodyMediumLgFontSize;
    final double koBodyMediumLgLetterSpacing;
    final double koBodyMediumLgLineHeight;
    final double koBodyMediumLgParagraphIndent;
    final double koBodyMediumLgParagraphSpacing;
    final double koBodyMediumMdFontSize;
    final double koBodyMediumMdLetterSpacing;
    final double koBodyMediumMdLineHeight;
    final double koBodyMediumMdParagraphIndent;
    final double koBodyMediumMdParagraphSpacing;
    final double koBodyMediumSmFontSize;
    final double koBodyMediumSmLetterSpacing;
    final double koBodyMediumSmLineHeight;
    final double koBodyMediumSmParagraphIndent;
    final double koBodyMediumSmParagraphSpacing;
    final double koBodyMediumXlFontSize;
    final double koBodyMediumXlLetterSpacing;
    final double koBodyMediumXlLineHeight;
    final double koBodyMediumXlParagraphIndent;
    final double koBodyMediumXlParagraphSpacing;
    final double koBodySemiboldLgFontSize;
    final double koBodySemiboldLgLetterSpacing;
    final double koBodySemiboldLgLineHeight;
    final double koBodySemiboldLgParagraphIndent;
    final double koBodySemiboldLgParagraphSpacing;
    final double koBodySemiboldMdFontSize;
    final double koBodySemiboldMdLetterSpacing;
    final double koBodySemiboldMdLineHeight;
    final double koBodySemiboldMdParagraphIndent;
    final double koBodySemiboldMdParagraphSpacing;
    final double koBodySemiboldSmFontSize;
    final double koBodySemiboldSmLetterSpacing;
    final double koBodySemiboldSmLineHeight;
    final double koBodySemiboldSmParagraphIndent;
    final double koBodySemiboldSmParagraphSpacing;
    final double koBodySemiboldXlFontSize;
    final double koBodySemiboldXlLetterSpacing;
    final double koBodySemiboldXlLineHeight;
    final double koBodySemiboldXlParagraphIndent;
    final double koBodySemiboldXlParagraphSpacing;
    final double koCaptionMediumMdFontSize;
    final double koCaptionMediumMdLetterSpacing;
    final double koCaptionMediumMdLineHeight;
    final double koCaptionMediumMdParagraphIndent;
    final double koCaptionMediumMdParagraphSpacing;
    final double koCaptionSemiboldMdFontSize;
    final double koCaptionSemiboldMdLetterSpacing;
    final double koCaptionSemiboldMdLineHeight;
    final double koCaptionSemiboldMdParagraphIndent;
    final double koCaptionSemiboldMdParagraphSpacing;
    final double koHeadingBold2xlFontSize;
    final double koHeadingBold2xlLetterSpacing;
    final double koHeadingBold2xlLineHeight;
    final double koHeadingBold2xlParagraphIndent;
    final double koHeadingBold2xlParagraphSpacing;
    final double koHeadingBoldLgFontSize;
    final double koHeadingBoldLgLetterSpacing;
    final double koHeadingBoldLgLineHeight;
    final double koHeadingBoldLgParagraphIndent;
    final double koHeadingBoldLgParagraphSpacing;
    final double koHeadingBoldMdFontSize;
    final double koHeadingBoldMdLetterSpacing;
    final double koHeadingBoldMdLineHeight;
    final double koHeadingBoldMdParagraphIndent;
    final double koHeadingBoldMdParagraphSpacing;
    final double koHeadingBoldSmFontSize;
    final double koHeadingBoldSmLetterSpacing;
    final double koHeadingBoldSmLineHeight;
    final double koHeadingBoldSmParagraphIndent;
    final double koHeadingBoldSmParagraphSpacing;
    final double koHeadingBoldXlFontSize;
    final double koHeadingBoldXlLetterSpacing;
    final double koHeadingBoldXlLineHeight;
    final double koHeadingBoldXlParagraphIndent;
    final double koHeadingBoldXlParagraphSpacing;
    final double koHeadingMedium2xlFontSize;
    final double koHeadingMedium2xlLetterSpacing;
    final double koHeadingMedium2xlLineHeight;
    final double koHeadingMedium2xlParagraphIndent;
    final double koHeadingMedium2xlParagraphSpacing;
    final double koHeadingMediumLgFontSize;
    final double koHeadingMediumLgLetterSpacing;
    final double koHeadingMediumLgLineHeight;
    final double koHeadingMediumLgParagraphIndent;
    final double koHeadingMediumLgParagraphSpacing;
    final double koHeadingMediumMdFontSize;
    final double koHeadingMediumMdLetterSpacing;
    final double koHeadingMediumMdLineHeight;
    final double koHeadingMediumMdParagraphIndent;
    final double koHeadingMediumMdParagraphSpacing;
    final double koHeadingMediumSmFontSize;
    final double koHeadingMediumSmLetterSpacing;
    final double koHeadingMediumSmLineHeight;
    final double koHeadingMediumSmParagraphIndent;
    final double koHeadingMediumSmParagraphSpacing;
    final double koHeadingMediumXlFontSize;
    final double koHeadingMediumXlLetterSpacing;
    final double koHeadingMediumXlLineHeight;
    final double koHeadingMediumXlParagraphIndent;
    final double koHeadingMediumXlParagraphSpacing;
    final double koHeadingSemibold2xlFontSize;
    final double koHeadingSemibold2xlLetterSpacing;
    final double koHeadingSemibold2xlLineHeight;
    final double koHeadingSemibold2xlParagraphIndent;
    final double koHeadingSemibold2xlParagraphSpacing;
    final double koHeadingSemiboldLgFontSize;
    final double koHeadingSemiboldLgLetterSpacing;
    final double koHeadingSemiboldLgLineHeight;
    final double koHeadingSemiboldLgParagraphIndent;
    final double koHeadingSemiboldLgParagraphSpacing;
    final double koHeadingSemiboldMdFontSize;
    final double koHeadingSemiboldMdLetterSpacing;
    final double koHeadingSemiboldMdLineHeight;
    final double koHeadingSemiboldMdParagraphIndent;
    final double koHeadingSemiboldMdParagraphSpacing;
    final double koHeadingSemiboldSmFontSize;
    final double koHeadingSemiboldSmLetterSpacing;
    final double koHeadingSemiboldSmLineHeight;
    final double koHeadingSemiboldSmParagraphIndent;
    final double koHeadingSemiboldSmParagraphSpacing;
    final double koHeadingSemiboldXlFontSize;
    final double koHeadingSemiboldXlLetterSpacing;
    final double koHeadingSemiboldXlLineHeight;
    final double koHeadingSemiboldXlParagraphIndent;
    final double koHeadingSemiboldXlParagraphSpacing;
    final double koUnderlineMediumMdFontSize;
    final double koUnderlineMediumMdLetterSpacing;
    final double koUnderlineMediumMdLineHeight;
    final double koUnderlineMediumMdParagraphIndent;
    final double koUnderlineMediumMdParagraphSpacing;
    final double koUnderlineMediumSmFontSize;
    final double koUnderlineMediumSmLetterSpacing;
    final double koUnderlineMediumSmLineHeight;
    final double koUnderlineMediumSmParagraphIndent;
    final double koUnderlineMediumSmParagraphSpacing;
    final double numBodyMediumMdFontSize;
    final double numBodyMediumMdLetterSpacing;
    final double numBodyMediumMdLineHeight;
    final double numBodyMediumMdParagraphIndent;
    final double numBodyMediumMdParagraphSpacing;
    final double numBodyMediumSmFontSize;
    final double numBodyMediumSmLetterSpacing;
    final double numBodyMediumSmLineHeight;
    final double numBodyMediumSmParagraphIndent;
    final double numBodyMediumSmParagraphSpacing;
    final double numBodyMediumXlFontSize;
    final double numBodyMediumXlLetterSpacing;
    final double numBodyMediumXlLineHeight;
    final double numBodyMediumXlParagraphIndent;
    final double numBodyMediumXlParagraphSpacing;
    final double numBodySemiboldMdFontSize;
    final double numBodySemiboldMdLetterSpacing;
    final double numBodySemiboldMdLineHeight;
    final double numBodySemiboldMdParagraphIndent;
    final double numBodySemiboldMdParagraphSpacing;
    final double numBodySemiboldSmFontSize;
    final double numBodySemiboldSmLetterSpacing;
    final double numBodySemiboldSmLineHeight;
    final double numBodySemiboldSmParagraphIndent;
    final double numBodySemiboldSmParagraphSpacing;
    final double numBodySemiboldXlFontSize;
    final double numBodySemiboldXlLetterSpacing;
    final double numBodySemiboldXlLineHeight;
    final double numBodySemiboldXlParagraphIndent;
    final double numBodySemiboldXlParagraphSpacing;
    final double numCaptionMediumMdFontSize;
    final double numCaptionMediumMdLetterSpacing;
    final double numCaptionMediumMdLineHeight;
    final double numCaptionMediumMdParagraphIndent;
    final double numCaptionMediumMdParagraphSpacing;
    final double numCaptionSemiboldMdFontSize;
    final double numCaptionSemiboldMdLetterSpacing;
    final double numCaptionSemiboldMdLineHeight;
    final double numCaptionSemiboldMdParagraphIndent;
    final double numCaptionSemiboldMdParagraphSpacing;
    final double numHeadingBold2xlFontSize;
    final double numHeadingBold2xlLetterSpacing;
    final double numHeadingBold2xlLineHeight;
    final double numHeadingBold2xlParagraphIndent;
    final double numHeadingBold2xlParagraphSpacing;
    final double numHeadingBoldLgFontSize;
    final double numHeadingBoldLgLetterSpacing;
    final double numHeadingBoldLgLineHeight;
    final double numHeadingBoldLgParagraphIndent;
    final double numHeadingBoldLgParagraphSpacing;
    final double numHeadingBoldMdFontSize;
    final double numHeadingBoldMdLetterSpacing;
    final double numHeadingBoldMdLineHeight;
    final double numHeadingBoldMdParagraphIndent;
    final double numHeadingBoldMdParagraphSpacing;
    final double numHeadingBoldXlFontSize;
    final double numHeadingBoldXlLetterSpacing;
    final double numHeadingBoldXlLineHeight;
    final double numHeadingBoldXlParagraphIndent;
    final double numHeadingBoldXlParagraphSpacing;
    final double numHeadingMedium2xlFontSize;
    final double numHeadingMedium2xlLetterSpacing;
    final double numHeadingMedium2xlLineHeight;
    final double numHeadingMedium2xlParagraphIndent;
    final double numHeadingMedium2xlParagraphSpacing;
    final double numHeadingMediumLgFontSize;
    final double numHeadingMediumLgLetterSpacing;
    final double numHeadingMediumLgLineHeight;
    final double numHeadingMediumLgParagraphIndent;
    final double numHeadingMediumLgParagraphSpacing;
    final double numHeadingMediumMdFontSize;
    final double numHeadingMediumMdLetterSpacing;
    final double numHeadingMediumMdLineHeight;
    final double numHeadingMediumMdParagraphIndent;
    final double numHeadingMediumMdParagraphSpacing;
    final double numHeadingMediumXlFontSize;
    final double numHeadingMediumXlLetterSpacing;
    final double numHeadingMediumXlLineHeight;
    final double numHeadingMediumXlParagraphIndent;
    final double numHeadingMediumXlParagraphSpacing;
    final double numHeadingSemibold2xlFontSize;
    final double numHeadingSemibold2xlLetterSpacing;
    final double numHeadingSemibold2xlLineHeight;
    final double numHeadingSemibold2xlParagraphIndent;
    final double numHeadingSemibold2xlParagraphSpacing;
    final double numHeadingSemibold3xlFontSize;
    final double numHeadingSemibold3xlLetterSpacing;
    final double numHeadingSemibold3xlLineHeight;
    final double numHeadingSemibold3xlParagraphIndent;
    final double numHeadingSemibold3xlParagraphSpacing;
    final double numHeadingSemiboldLgFontSize;
    final double numHeadingSemiboldLgLetterSpacing;
    final double numHeadingSemiboldLgLineHeight;
    final double numHeadingSemiboldLgParagraphIndent;
    final double numHeadingSemiboldLgParagraphSpacing;
    final double numHeadingSemiboldMdFontSize;
    final double numHeadingSemiboldMdLetterSpacing;
    final double numHeadingSemiboldMdLineHeight;
    final double numHeadingSemiboldMdParagraphIndent;
    final double numHeadingSemiboldMdParagraphSpacing;
    final double numHeadingSemiboldXlFontSize;
    final double numHeadingSemiboldXlLetterSpacing;
    final double numHeadingSemiboldXlLineHeight;
    final double numHeadingSemiboldXlParagraphIndent;
    final double numHeadingSemiboldXlParagraphSpacing;
    final double numberCardW104;
    final double numberCardW108;
    final double numberCardW114;
    final double numberCardW174;
    final double numberCardW316;
    final double numberCardW358;
    final double numberCardW390;
    final double numberCardW82;
    final double numberRadius0;
    final double numberRadius12;
    final double numberRadius16;
    final double numberRadius20;
    final double numberRadius4;
    final double numberRadius8;
    final double numberRadiusCircle;
    final double numberSpacing0;
    final double numberSpacing10;
    final double numberSpacing12;
    final double numberSpacing16;
    final double numberSpacing2;
    final double numberSpacing20;
    final double numberSpacing24;
    final double numberSpacing28;
    final double numberSpacing32;
    final double numberSpacing36;
    final double numberSpacing4;
    final double numberSpacing40;
    final double numberSpacing44;
    final double numberSpacing48;
    final double numberSpacing52;
    final double numberSpacing56;
    final double numberSpacing60;
    final double numberSpacing64;
    final double numberSpacing68;
    final double numberSpacing72;
    final double numberSpacing76;
    final double numberSpacing8;
    final double numberSpacing80;
    final double numberStroke1;
    final double numberStroke2;
    final double numberStroke4;
    final double unit0;
    final double unit1;
    final double unit10;
    final double unit100;
    final double unit104;
    final double unit108;
    final double unit112;
    final double unit114;
    final double unit116;
    final double unit12;
    final double unit120;
    final double unit124;
    final double unit128;
    final double unit132;
    final double unit136;
    final double unit140;
    final double unit144;
    final double unit148;
    final double unit152;
    final double unit156;
    final double unit16;
    final double unit160;
    final double unit164;
    final double unit168;
    final double unit172;
    final double unit174;
    final double unit176;
    final double unit2;
    final double unit20;
    final double unit24;
    final double unit28;
    final double unit312;
    final double unit316;
    final double unit32;
    final double unit358;
    final double unit36;
    final double unit390;
    final double unit4;
    final double unit40;
    final double unit44;
    final double unit48;
    final double unit52;
    final double unit56;
    final double unit60;
    final double unit64;
    final double unit68;
    final double unit72;
    final double unit76;
    final double unit8;
    final double unit80;
    final double unit82;
    final double unit88;
    final double unit92;
    final double unit96;
    


}



