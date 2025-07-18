
//
// theme/gallery.g.dart
//

// Do not edit directly
// Generated on Tue, 15 Jul 2025 07:45:54 GMT



import 'package:flutter/widgets.dart';

import 'theme.g.dart';
import 'widgets.g.dart';

class AppThemeGallery extends StatelessWidget {
    const AppThemeGallery({
        Key? key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return ListView(
            children: [
                const _ColorSection(),const _TextStyleSection(),const _DoubleSection(),
                const SizedBox(height: 20),
            ],
        );
    }   
}

class _ColorSection extends StatelessWidget {
    const _ColorSection({
        Key? key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final theme = AppTheme.of(context);
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                _Header('Color'),
                 _Token(
                    name: 'colorBaseBalck',
                    child: _Color(theme.color.colorBaseBalck),
                ),
                 _Token(
                    name: 'colorBaseWhite',
                    child: _Color(theme.color.colorBaseWhite),
                ),
                 _Token(
                    name: 'colorBgBlack',
                    child: _Color(theme.color.colorBgBlack),
                ),
                 _Token(
                    name: 'colorBgBrand',
                    child: _Color(theme.color.colorBgBrand),
                ),
                 _Token(
                    name: 'colorBgInteractivePrimary',
                    child: _Color(theme.color.colorBgInteractivePrimary),
                ),
                 _Token(
                    name: 'colorBgInteractivePrimaryDisabled',
                    child: _Color(theme.color.colorBgInteractivePrimaryDisabled),
                ),
                 _Token(
                    name: 'colorBgInteractivePrimaryPressed',
                    child: _Color(theme.color.colorBgInteractivePrimaryPressed),
                ),
                 _Token(
                    name: 'colorBgInteractiveSecondary',
                    child: _Color(theme.color.colorBgInteractiveSecondary),
                ),
                 _Token(
                    name: 'colorBgInteractiveSecondaryDisabled',
                    child: _Color(theme.color.colorBgInteractiveSecondaryDisabled),
                ),
                 _Token(
                    name: 'colorBgInteractiveSecondaryPressed',
                    child: _Color(theme.color.colorBgInteractiveSecondaryPressed),
                ),
                 _Token(
                    name: 'colorBgPrimary',
                    child: _Color(theme.color.colorBgPrimary),
                ),
                 _Token(
                    name: 'colorBgSecondary',
                    child: _Color(theme.color.colorBgSecondary),
                ),
                 _Token(
                    name: 'colorBgSuccess',
                    child: _Color(theme.color.colorBgSuccess),
                ),
                 _Token(
                    name: 'colorBgTertiary',
                    child: _Color(theme.color.colorBgTertiary),
                ),
                 _Token(
                    name: 'colorBgTransparcy50',
                    child: _Color(theme.color.colorBgTransparcy50),
                ),
                 _Token(
                    name: 'colorBgTransparcy60',
                    child: _Color(theme.color.colorBgTransparcy60),
                ),
                 _Token(
                    name: 'colorBgTransparcy80',
                    child: _Color(theme.color.colorBgTransparcy80),
                ),
                 _Token(
                    name: 'colorBgWarning',
                    child: _Color(theme.color.colorBgWarning),
                ),
                 _Token(
                    name: 'colorBgWarningBold',
                    child: _Color(theme.color.colorBgWarningBold),
                ),
                 _Token(
                    name: 'colorBgWarningSubtle',
                    child: _Color(theme.color.colorBgWarningSubtle),
                ),
                 _Token(
                    name: 'colorBgWhite',
                    child: _Color(theme.color.colorBgWhite),
                ),
                 _Token(
                    name: 'colorBluegray100',
                    child: _Color(theme.color.colorBluegray100),
                ),
                 _Token(
                    name: 'colorBluegray200',
                    child: _Color(theme.color.colorBluegray200),
                ),
                 _Token(
                    name: 'colorBluegray300',
                    child: _Color(theme.color.colorBluegray300),
                ),
                 _Token(
                    name: 'colorBluegray400',
                    child: _Color(theme.color.colorBluegray400),
                ),
                 _Token(
                    name: 'colorBluegray50',
                    child: _Color(theme.color.colorBluegray50),
                ),
                 _Token(
                    name: 'colorBluegray500',
                    child: _Color(theme.color.colorBluegray500),
                ),
                 _Token(
                    name: 'colorBluegray600',
                    child: _Color(theme.color.colorBluegray600),
                ),
                 _Token(
                    name: 'colorBluegray700',
                    child: _Color(theme.color.colorBluegray700),
                ),
                 _Token(
                    name: 'colorBluegray800',
                    child: _Color(theme.color.colorBluegray800),
                ),
                 _Token(
                    name: 'colorBluegray900',
                    child: _Color(theme.color.colorBluegray900),
                ),
                 _Token(
                    name: 'colorBorderBlack',
                    child: _Color(theme.color.colorBorderBlack),
                ),
                 _Token(
                    name: 'colorBorderInteractivePrimary',
                    child: _Color(theme.color.colorBorderInteractivePrimary),
                ),
                 _Token(
                    name: 'colorBorderInteractivePrimaryDisabled',
                    child: _Color(theme.color.colorBorderInteractivePrimaryDisabled),
                ),
                 _Token(
                    name: 'colorBorderInteractivePrimaryPressed',
                    child: _Color(theme.color.colorBorderInteractivePrimaryPressed),
                ),
                 _Token(
                    name: 'colorBorderInteractiveSecondary',
                    child: _Color(theme.color.colorBorderInteractiveSecondary),
                ),
                 _Token(
                    name: 'colorBorderInteractiveSecondaryDisabled',
                    child: _Color(theme.color.colorBorderInteractiveSecondaryDisabled),
                ),
                 _Token(
                    name: 'colorBorderInteractiveSecondaryPressed',
                    child: _Color(theme.color.colorBorderInteractiveSecondaryPressed),
                ),
                 _Token(
                    name: 'colorBorderInverse',
                    child: _Color(theme.color.colorBorderInverse),
                ),
                 _Token(
                    name: 'colorBorderPrimary',
                    child: _Color(theme.color.colorBorderPrimary),
                ),
                 _Token(
                    name: 'colorBorderSecondary',
                    child: _Color(theme.color.colorBorderSecondary),
                ),
                 _Token(
                    name: 'colorBorderSuccess',
                    child: _Color(theme.color.colorBorderSuccess),
                ),
                 _Token(
                    name: 'colorBorderTertiary',
                    child: _Color(theme.color.colorBorderTertiary),
                ),
                 _Token(
                    name: 'colorBorderWarning',
                    child: _Color(theme.color.colorBorderWarning),
                ),
                 _Token(
                    name: 'colorBorderWhite',
                    child: _Color(theme.color.colorBorderWhite),
                ),
                 _Token(
                    name: 'colorBrandgray100',
                    child: _Color(theme.color.colorBrandgray100),
                ),
                 _Token(
                    name: 'colorBrandgray200',
                    child: _Color(theme.color.colorBrandgray200),
                ),
                 _Token(
                    name: 'colorBrandgray300',
                    child: _Color(theme.color.colorBrandgray300),
                ),
                 _Token(
                    name: 'colorBrandgray400',
                    child: _Color(theme.color.colorBrandgray400),
                ),
                 _Token(
                    name: 'colorBrandgray50',
                    child: _Color(theme.color.colorBrandgray50),
                ),
                 _Token(
                    name: 'colorBrandgray500',
                    child: _Color(theme.color.colorBrandgray500),
                ),
                 _Token(
                    name: 'colorBrandgray600',
                    child: _Color(theme.color.colorBrandgray600),
                ),
                 _Token(
                    name: 'colorBrandgray700',
                    child: _Color(theme.color.colorBrandgray700),
                ),
                 _Token(
                    name: 'colorBrandgray800',
                    child: _Color(theme.color.colorBrandgray800),
                ),
                 _Token(
                    name: 'colorBrandgray900',
                    child: _Color(theme.color.colorBrandgray900),
                ),
                 _Token(
                    name: 'colorCyan100',
                    child: _Color(theme.color.colorCyan100),
                ),
                 _Token(
                    name: 'colorCyan200',
                    child: _Color(theme.color.colorCyan200),
                ),
                 _Token(
                    name: 'colorCyan300',
                    child: _Color(theme.color.colorCyan300),
                ),
                 _Token(
                    name: 'colorCyan400',
                    child: _Color(theme.color.colorCyan400),
                ),
                 _Token(
                    name: 'colorCyan50',
                    child: _Color(theme.color.colorCyan50),
                ),
                 _Token(
                    name: 'colorCyan500',
                    child: _Color(theme.color.colorCyan500),
                ),
                 _Token(
                    name: 'colorCyan600',
                    child: _Color(theme.color.colorCyan600),
                ),
                 _Token(
                    name: 'colorCyan700',
                    child: _Color(theme.color.colorCyan700),
                ),
                 _Token(
                    name: 'colorCyan800',
                    child: _Color(theme.color.colorCyan800),
                ),
                 _Token(
                    name: 'colorCyan900',
                    child: _Color(theme.color.colorCyan900),
                ),
                 _Token(
                    name: 'colorGray100',
                    child: _Color(theme.color.colorGray100),
                ),
                 _Token(
                    name: 'colorGray200',
                    child: _Color(theme.color.colorGray200),
                ),
                 _Token(
                    name: 'colorGray300',
                    child: _Color(theme.color.colorGray300),
                ),
                 _Token(
                    name: 'colorGray400',
                    child: _Color(theme.color.colorGray400),
                ),
                 _Token(
                    name: 'colorGray50',
                    child: _Color(theme.color.colorGray50),
                ),
                 _Token(
                    name: 'colorGray500',
                    child: _Color(theme.color.colorGray500),
                ),
                 _Token(
                    name: 'colorGray600',
                    child: _Color(theme.color.colorGray600),
                ),
                 _Token(
                    name: 'colorGray700',
                    child: _Color(theme.color.colorGray700),
                ),
                 _Token(
                    name: 'colorGray800',
                    child: _Color(theme.color.colorGray800),
                ),
                 _Token(
                    name: 'colorGray900',
                    child: _Color(theme.color.colorGray900),
                ),
                 _Token(
                    name: 'colorGreen100',
                    child: _Color(theme.color.colorGreen100),
                ),
                 _Token(
                    name: 'colorGreen200',
                    child: _Color(theme.color.colorGreen200),
                ),
                 _Token(
                    name: 'colorGreen300',
                    child: _Color(theme.color.colorGreen300),
                ),
                 _Token(
                    name: 'colorGreen400',
                    child: _Color(theme.color.colorGreen400),
                ),
                 _Token(
                    name: 'colorGreen50',
                    child: _Color(theme.color.colorGreen50),
                ),
                 _Token(
                    name: 'colorGreen500',
                    child: _Color(theme.color.colorGreen500),
                ),
                 _Token(
                    name: 'colorGreen600',
                    child: _Color(theme.color.colorGreen600),
                ),
                 _Token(
                    name: 'colorGreen700',
                    child: _Color(theme.color.colorGreen700),
                ),
                 _Token(
                    name: 'colorGreen800',
                    child: _Color(theme.color.colorGreen800),
                ),
                 _Token(
                    name: 'colorGreen900',
                    child: _Color(theme.color.colorGreen900),
                ),
                 _Token(
                    name: 'colorIconImportant',
                    child: _Color(theme.color.colorIconImportant),
                ),
                 _Token(
                    name: 'colorIconInteractivePrimary',
                    child: _Color(theme.color.colorIconInteractivePrimary),
                ),
                 _Token(
                    name: 'colorIconInteractivePrimaryDisabled',
                    child: _Color(theme.color.colorIconInteractivePrimaryDisabled),
                ),
                 _Token(
                    name: 'colorIconInteractivePrimaryPressed',
                    child: _Color(theme.color.colorIconInteractivePrimaryPressed),
                ),
                 _Token(
                    name: 'colorIconInteractiveSecondary',
                    child: _Color(theme.color.colorIconInteractiveSecondary),
                ),
                 _Token(
                    name: 'colorIconInteractiveSecondaryDisabled',
                    child: _Color(theme.color.colorIconInteractiveSecondaryDisabled),
                ),
                 _Token(
                    name: 'colorIconInteractiveSecondaryPressed',
                    child: _Color(theme.color.colorIconInteractiveSecondaryPressed),
                ),
                 _Token(
                    name: 'colorIconInverse',
                    child: _Color(theme.color.colorIconInverse),
                ),
                 _Token(
                    name: 'colorIconPrimary',
                    child: _Color(theme.color.colorIconPrimary),
                ),
                 _Token(
                    name: 'colorIconQuaternary',
                    child: _Color(theme.color.colorIconQuaternary),
                ),
                 _Token(
                    name: 'colorIconSecondary',
                    child: _Color(theme.color.colorIconSecondary),
                ),
                 _Token(
                    name: 'colorIconSuccess',
                    child: _Color(theme.color.colorIconSuccess),
                ),
                 _Token(
                    name: 'colorIconTertiary',
                    child: _Color(theme.color.colorIconTertiary),
                ),
                 _Token(
                    name: 'colorIconWarning',
                    child: _Color(theme.color.colorIconWarning),
                ),
                 _Token(
                    name: 'colorOrange100',
                    child: _Color(theme.color.colorOrange100),
                ),
                 _Token(
                    name: 'colorOrange200',
                    child: _Color(theme.color.colorOrange200),
                ),
                 _Token(
                    name: 'colorOrange300',
                    child: _Color(theme.color.colorOrange300),
                ),
                 _Token(
                    name: 'colorOrange400',
                    child: _Color(theme.color.colorOrange400),
                ),
                 _Token(
                    name: 'colorOrange50',
                    child: _Color(theme.color.colorOrange50),
                ),
                 _Token(
                    name: 'colorOrange500',
                    child: _Color(theme.color.colorOrange500),
                ),
                 _Token(
                    name: 'colorOrange600',
                    child: _Color(theme.color.colorOrange600),
                ),
                 _Token(
                    name: 'colorOrange700',
                    child: _Color(theme.color.colorOrange700),
                ),
                 _Token(
                    name: 'colorOrange800',
                    child: _Color(theme.color.colorOrange800),
                ),
                 _Token(
                    name: 'colorOrange900',
                    child: _Color(theme.color.colorOrange900),
                ),
                 _Token(
                    name: 'colorPink100',
                    child: _Color(theme.color.colorPink100),
                ),
                 _Token(
                    name: 'colorPink200',
                    child: _Color(theme.color.colorPink200),
                ),
                 _Token(
                    name: 'colorPink300',
                    child: _Color(theme.color.colorPink300),
                ),
                 _Token(
                    name: 'colorPink400',
                    child: _Color(theme.color.colorPink400),
                ),
                 _Token(
                    name: 'colorPink50',
                    child: _Color(theme.color.colorPink50),
                ),
                 _Token(
                    name: 'colorPink500',
                    child: _Color(theme.color.colorPink500),
                ),
                 _Token(
                    name: 'colorPink600',
                    child: _Color(theme.color.colorPink600),
                ),
                 _Token(
                    name: 'colorPink700',
                    child: _Color(theme.color.colorPink700),
                ),
                 _Token(
                    name: 'colorPink800',
                    child: _Color(theme.color.colorPink800),
                ),
                 _Token(
                    name: 'colorPink900',
                    child: _Color(theme.color.colorPink900),
                ),
                 _Token(
                    name: 'colorPointBluegray',
                    child: _Color(theme.color.colorPointBluegray),
                ),
                 _Token(
                    name: 'colorPointBrandgray',
                    child: _Color(theme.color.colorPointBrandgray),
                ),
                 _Token(
                    name: 'colorPointCyan',
                    child: _Color(theme.color.colorPointCyan),
                ),
                 _Token(
                    name: 'colorPointGreen',
                    child: _Color(theme.color.colorPointGreen),
                ),
                 _Token(
                    name: 'colorPointOrange',
                    child: _Color(theme.color.colorPointOrange),
                ),
                 _Token(
                    name: 'colorPointPink',
                    child: _Color(theme.color.colorPointPink),
                ),
                 _Token(
                    name: 'colorPointPurple',
                    child: _Color(theme.color.colorPointPurple),
                ),
                 _Token(
                    name: 'colorPointYellow',
                    child: _Color(theme.color.colorPointYellow),
                ),
                 _Token(
                    name: 'colorPointYellowgreen',
                    child: _Color(theme.color.colorPointYellowgreen),
                ),
                 _Token(
                    name: 'colorPurple100',
                    child: _Color(theme.color.colorPurple100),
                ),
                 _Token(
                    name: 'colorPurple200',
                    child: _Color(theme.color.colorPurple200),
                ),
                 _Token(
                    name: 'colorPurple300',
                    child: _Color(theme.color.colorPurple300),
                ),
                 _Token(
                    name: 'colorPurple400',
                    child: _Color(theme.color.colorPurple400),
                ),
                 _Token(
                    name: 'colorPurple50',
                    child: _Color(theme.color.colorPurple50),
                ),
                 _Token(
                    name: 'colorPurple500',
                    child: _Color(theme.color.colorPurple500),
                ),
                 _Token(
                    name: 'colorPurple600',
                    child: _Color(theme.color.colorPurple600),
                ),
                 _Token(
                    name: 'colorPurple700',
                    child: _Color(theme.color.colorPurple700),
                ),
                 _Token(
                    name: 'colorPurple800',
                    child: _Color(theme.color.colorPurple800),
                ),
                 _Token(
                    name: 'colorPurple900',
                    child: _Color(theme.color.colorPurple900),
                ),
                 _Token(
                    name: 'colorRed100',
                    child: _Color(theme.color.colorRed100),
                ),
                 _Token(
                    name: 'colorRed200',
                    child: _Color(theme.color.colorRed200),
                ),
                 _Token(
                    name: 'colorRed300',
                    child: _Color(theme.color.colorRed300),
                ),
                 _Token(
                    name: 'colorRed400',
                    child: _Color(theme.color.colorRed400),
                ),
                 _Token(
                    name: 'colorRed50',
                    child: _Color(theme.color.colorRed50),
                ),
                 _Token(
                    name: 'colorRed500',
                    child: _Color(theme.color.colorRed500),
                ),
                 _Token(
                    name: 'colorRed600',
                    child: _Color(theme.color.colorRed600),
                ),
                 _Token(
                    name: 'colorRed700',
                    child: _Color(theme.color.colorRed700),
                ),
                 _Token(
                    name: 'colorRed800',
                    child: _Color(theme.color.colorRed800),
                ),
                 _Token(
                    name: 'colorRed900',
                    child: _Color(theme.color.colorRed900),
                ),
                 _Token(
                    name: 'colorTextBrand',
                    child: _Color(theme.color.colorTextBrand),
                ),
                 _Token(
                    name: 'colorTextInfo',
                    child: _Color(theme.color.colorTextInfo),
                ),
                 _Token(
                    name: 'colorTextInteractivePrimary',
                    child: _Color(theme.color.colorTextInteractivePrimary),
                ),
                 _Token(
                    name: 'colorTextInteractivePrimaryDisabled',
                    child: _Color(theme.color.colorTextInteractivePrimaryDisabled),
                ),
                 _Token(
                    name: 'colorTextInteractivePrimaryPressed',
                    child: _Color(theme.color.colorTextInteractivePrimaryPressed),
                ),
                 _Token(
                    name: 'colorTextInteractiveSecondary',
                    child: _Color(theme.color.colorTextInteractiveSecondary),
                ),
                 _Token(
                    name: 'colorTextInteractiveSecondaryDisabled',
                    child: _Color(theme.color.colorTextInteractiveSecondaryDisabled),
                ),
                 _Token(
                    name: 'colorTextInteractiveSecondaryPressed',
                    child: _Color(theme.color.colorTextInteractiveSecondaryPressed),
                ),
                 _Token(
                    name: 'colorTextInverse',
                    child: _Color(theme.color.colorTextInverse),
                ),
                 _Token(
                    name: 'colorTextPrimary',
                    child: _Color(theme.color.colorTextPrimary),
                ),
                 _Token(
                    name: 'colorTextSecondary',
                    child: _Color(theme.color.colorTextSecondary),
                ),
                 _Token(
                    name: 'colorTextSuccess',
                    child: _Color(theme.color.colorTextSuccess),
                ),
                 _Token(
                    name: 'colorTextTertiary',
                    child: _Color(theme.color.colorTextTertiary),
                ),
                 _Token(
                    name: 'colorTextWarning',
                    child: _Color(theme.color.colorTextWarning),
                ),
                 _Token(
                    name: 'colorTextWarningBold',
                    child: _Color(theme.color.colorTextWarningBold),
                ),
                 _Token(
                    name: 'colorYellow100',
                    child: _Color(theme.color.colorYellow100),
                ),
                 _Token(
                    name: 'colorYellow200',
                    child: _Color(theme.color.colorYellow200),
                ),
                 _Token(
                    name: 'colorYellow300',
                    child: _Color(theme.color.colorYellow300),
                ),
                 _Token(
                    name: 'colorYellow400',
                    child: _Color(theme.color.colorYellow400),
                ),
                 _Token(
                    name: 'colorYellow50',
                    child: _Color(theme.color.colorYellow50),
                ),
                 _Token(
                    name: 'colorYellow500',
                    child: _Color(theme.color.colorYellow500),
                ),
                 _Token(
                    name: 'colorYellow600',
                    child: _Color(theme.color.colorYellow600),
                ),
                 _Token(
                    name: 'colorYellow700',
                    child: _Color(theme.color.colorYellow700),
                ),
                 _Token(
                    name: 'colorYellow800',
                    child: _Color(theme.color.colorYellow800),
                ),
                 _Token(
                    name: 'colorYellow900',
                    child: _Color(theme.color.colorYellow900),
                ),
                 _Token(
                    name: 'colorYellowgreen100',
                    child: _Color(theme.color.colorYellowgreen100),
                ),
                 _Token(
                    name: 'colorYellowgreen200',
                    child: _Color(theme.color.colorYellowgreen200),
                ),
                 _Token(
                    name: 'colorYellowgreen300',
                    child: _Color(theme.color.colorYellowgreen300),
                ),
                 _Token(
                    name: 'colorYellowgreen400',
                    child: _Color(theme.color.colorYellowgreen400),
                ),
                 _Token(
                    name: 'colorYellowgreen50',
                    child: _Color(theme.color.colorYellowgreen50),
                ),
                 _Token(
                    name: 'colorYellowgreen500',
                    child: _Color(theme.color.colorYellowgreen500),
                ),
                 _Token(
                    name: 'colorYellowgreen600',
                    child: _Color(theme.color.colorYellowgreen600),
                ),
                 _Token(
                    name: 'colorYellowgreen700',
                    child: _Color(theme.color.colorYellowgreen700),
                ),
                 _Token(
                    name: 'colorYellowgreen800',
                    child: _Color(theme.color.colorYellowgreen800),
                ),
                 _Token(
                    name: 'colorYellowgreen900',
                    child: _Color(theme.color.colorYellowgreen900),
                ),
                 _Token(
                    name: 'staikaPayBk',
                    child: _Color(theme.color.staikaPayBk),
                ),
                 _Token(
                    name: 'staikaPayGray10',
                    child: _Color(theme.color.staikaPayGray10),
                ),
                 _Token(
                    name: 'staikaPayGray20',
                    child: _Color(theme.color.staikaPayGray20),
                ),
                 _Token(
                    name: 'staikaPayGray30',
                    child: _Color(theme.color.staikaPayGray30),
                ),
                 _Token(
                    name: 'staikaPayGray40',
                    child: _Color(theme.color.staikaPayGray40),
                ),
                 _Token(
                    name: 'staikaPayGray50',
                    child: _Color(theme.color.staikaPayGray50),
                ),
                 _Token(
                    name: 'staikaPayGray60',
                    child: _Color(theme.color.staikaPayGray60),
                ),
                 _Token(
                    name: 'staikaPayGray70',
                    child: _Color(theme.color.staikaPayGray70),
                ),
                 _Token(
                    name: 'staikaPayPrimary',
                    child: _Color(theme.color.staikaPayPrimary),
                ),
                 _Token(
                    name: 'staikaPaySecondary',
                    child: _Color(theme.color.staikaPaySecondary),
                ),
                 _Token(
                    name: 'staikaPayWh',
                    child: _Color(theme.color.staikaPayWh),
                ),
                 _Token(
                    name: 'transparencyBlack10',
                    child: _Color(theme.color.transparencyBlack10),
                ),
                 _Token(
                    name: 'transparencyBlack50',
                    child: _Color(theme.color.transparencyBlack50),
                ),
                 _Token(
                    name: 'transparencyBlack60',
                    child: _Color(theme.color.transparencyBlack60),
                ),
                 _Token(
                    name: 'transparencyBlack80',
                    child: _Color(theme.color.transparencyBlack80),
                ),
                 _Token(
                    name: 'transparencyCyan10',
                    child: _Color(theme.color.transparencyCyan10),
                ),
                
            ],
        );
    }
}

class _TextStyleSection extends StatelessWidget {
    const _TextStyleSection({
        Key? key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final theme = AppTheme.of(context);
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                _Header('TextStyle'),
                 _Token(
                    name: 'enBodyMediumLg',
                    child: _TextStyle(theme.textStyle.enBodyMediumLg),
                ),
                 _Token(
                    name: 'enBodyMediumMd',
                    child: _TextStyle(theme.textStyle.enBodyMediumMd),
                ),
                 _Token(
                    name: 'enBodyMediumSm',
                    child: _TextStyle(theme.textStyle.enBodyMediumSm),
                ),
                 _Token(
                    name: 'enBodyMediumXl',
                    child: _TextStyle(theme.textStyle.enBodyMediumXl),
                ),
                 _Token(
                    name: 'enBodySemiboldLg',
                    child: _TextStyle(theme.textStyle.enBodySemiboldLg),
                ),
                 _Token(
                    name: 'enBodySemiboldMd',
                    child: _TextStyle(theme.textStyle.enBodySemiboldMd),
                ),
                 _Token(
                    name: 'enBodySemiboldSm',
                    child: _TextStyle(theme.textStyle.enBodySemiboldSm),
                ),
                 _Token(
                    name: 'enBodySemiboldXl',
                    child: _TextStyle(theme.textStyle.enBodySemiboldXl),
                ),
                 _Token(
                    name: 'enCaptionBoldMd',
                    child: _TextStyle(theme.textStyle.enCaptionBoldMd),
                ),
                 _Token(
                    name: 'enCaptionMediumMd',
                    child: _TextStyle(theme.textStyle.enCaptionMediumMd),
                ),
                 _Token(
                    name: 'enCaptionSemiboldMd',
                    child: _TextStyle(theme.textStyle.enCaptionSemiboldMd),
                ),
                 _Token(
                    name: 'enHeadingBlackLg',
                    child: _TextStyle(theme.textStyle.enHeadingBlackLg),
                ),
                 _Token(
                    name: 'enHeadingBlackMd',
                    child: _TextStyle(theme.textStyle.enHeadingBlackMd),
                ),
                 _Token(
                    name: 'enHeadingBlackSm',
                    child: _TextStyle(theme.textStyle.enHeadingBlackSm),
                ),
                 _Token(
                    name: 'enHeadingBlackXl',
                    child: _TextStyle(theme.textStyle.enHeadingBlackXl),
                ),
                 _Token(
                    name: 'enHeadingBoldLg',
                    child: _TextStyle(theme.textStyle.enHeadingBoldLg),
                ),
                 _Token(
                    name: 'enHeadingBoldMd',
                    child: _TextStyle(theme.textStyle.enHeadingBoldMd),
                ),
                 _Token(
                    name: 'enHeadingBoldSm',
                    child: _TextStyle(theme.textStyle.enHeadingBoldSm),
                ),
                 _Token(
                    name: 'enHeadingBoldXl',
                    child: _TextStyle(theme.textStyle.enHeadingBoldXl),
                ),
                 _Token(
                    name: 'enHeadingMediumLg',
                    child: _TextStyle(theme.textStyle.enHeadingMediumLg),
                ),
                 _Token(
                    name: 'enHeadingMediumMd',
                    child: _TextStyle(theme.textStyle.enHeadingMediumMd),
                ),
                 _Token(
                    name: 'enHeadingMediumSm',
                    child: _TextStyle(theme.textStyle.enHeadingMediumSm),
                ),
                 _Token(
                    name: 'enHeadingMediumXl',
                    child: _TextStyle(theme.textStyle.enHeadingMediumXl),
                ),
                 _Token(
                    name: 'enUnderlineMediumSm',
                    child: _TextStyle(theme.textStyle.enUnderlineMediumSm),
                ),
                 _Token(
                    name: 'koBodyMediumLg',
                    child: _TextStyle(theme.textStyle.koBodyMediumLg),
                ),
                 _Token(
                    name: 'koBodyMediumMd',
                    child: _TextStyle(theme.textStyle.koBodyMediumMd),
                ),
                 _Token(
                    name: 'koBodyMediumSm',
                    child: _TextStyle(theme.textStyle.koBodyMediumSm),
                ),
                 _Token(
                    name: 'koBodyMediumXl',
                    child: _TextStyle(theme.textStyle.koBodyMediumXl),
                ),
                 _Token(
                    name: 'koBodySemiboldLg',
                    child: _TextStyle(theme.textStyle.koBodySemiboldLg),
                ),
                 _Token(
                    name: 'koBodySemiboldMd',
                    child: _TextStyle(theme.textStyle.koBodySemiboldMd),
                ),
                 _Token(
                    name: 'koBodySemiboldSm',
                    child: _TextStyle(theme.textStyle.koBodySemiboldSm),
                ),
                 _Token(
                    name: 'koBodySemiboldXl',
                    child: _TextStyle(theme.textStyle.koBodySemiboldXl),
                ),
                 _Token(
                    name: 'koCaptionMediumMd',
                    child: _TextStyle(theme.textStyle.koCaptionMediumMd),
                ),
                 _Token(
                    name: 'koCaptionSemiboldMd',
                    child: _TextStyle(theme.textStyle.koCaptionSemiboldMd),
                ),
                 _Token(
                    name: 'koHeadingBold2xl',
                    child: _TextStyle(theme.textStyle.koHeadingBold2xl),
                ),
                 _Token(
                    name: 'koHeadingBoldLg',
                    child: _TextStyle(theme.textStyle.koHeadingBoldLg),
                ),
                 _Token(
                    name: 'koHeadingBoldMd',
                    child: _TextStyle(theme.textStyle.koHeadingBoldMd),
                ),
                 _Token(
                    name: 'koHeadingBoldSm',
                    child: _TextStyle(theme.textStyle.koHeadingBoldSm),
                ),
                 _Token(
                    name: 'koHeadingBoldXl',
                    child: _TextStyle(theme.textStyle.koHeadingBoldXl),
                ),
                 _Token(
                    name: 'koHeadingMedium2xl',
                    child: _TextStyle(theme.textStyle.koHeadingMedium2xl),
                ),
                 _Token(
                    name: 'koHeadingMediumLg',
                    child: _TextStyle(theme.textStyle.koHeadingMediumLg),
                ),
                 _Token(
                    name: 'koHeadingMediumMd',
                    child: _TextStyle(theme.textStyle.koHeadingMediumMd),
                ),
                 _Token(
                    name: 'koHeadingMediumSm',
                    child: _TextStyle(theme.textStyle.koHeadingMediumSm),
                ),
                 _Token(
                    name: 'koHeadingMediumXl',
                    child: _TextStyle(theme.textStyle.koHeadingMediumXl),
                ),
                 _Token(
                    name: 'koHeadingSemibold2xl',
                    child: _TextStyle(theme.textStyle.koHeadingSemibold2xl),
                ),
                 _Token(
                    name: 'koHeadingSemiboldLg',
                    child: _TextStyle(theme.textStyle.koHeadingSemiboldLg),
                ),
                 _Token(
                    name: 'koHeadingSemiboldMd',
                    child: _TextStyle(theme.textStyle.koHeadingSemiboldMd),
                ),
                 _Token(
                    name: 'koHeadingSemiboldSm',
                    child: _TextStyle(theme.textStyle.koHeadingSemiboldSm),
                ),
                 _Token(
                    name: 'koHeadingSemiboldXl',
                    child: _TextStyle(theme.textStyle.koHeadingSemiboldXl),
                ),
                 _Token(
                    name: 'koUnderlineMediumMd',
                    child: _TextStyle(theme.textStyle.koUnderlineMediumMd),
                ),
                 _Token(
                    name: 'koUnderlineMediumSm',
                    child: _TextStyle(theme.textStyle.koUnderlineMediumSm),
                ),
                 _Token(
                    name: 'numBodyMediumMd',
                    child: _TextStyle(theme.textStyle.numBodyMediumMd),
                ),
                 _Token(
                    name: 'numBodyMediumSm',
                    child: _TextStyle(theme.textStyle.numBodyMediumSm),
                ),
                 _Token(
                    name: 'numBodyMediumXl',
                    child: _TextStyle(theme.textStyle.numBodyMediumXl),
                ),
                 _Token(
                    name: 'numBodySemiboldMd',
                    child: _TextStyle(theme.textStyle.numBodySemiboldMd),
                ),
                 _Token(
                    name: 'numBodySemiboldSm',
                    child: _TextStyle(theme.textStyle.numBodySemiboldSm),
                ),
                 _Token(
                    name: 'numBodySemiboldXl',
                    child: _TextStyle(theme.textStyle.numBodySemiboldXl),
                ),
                 _Token(
                    name: 'numCaptionMediumMd',
                    child: _TextStyle(theme.textStyle.numCaptionMediumMd),
                ),
                 _Token(
                    name: 'numCaptionSemiboldMd',
                    child: _TextStyle(theme.textStyle.numCaptionSemiboldMd),
                ),
                 _Token(
                    name: 'numHeadingBold2xl',
                    child: _TextStyle(theme.textStyle.numHeadingBold2xl),
                ),
                 _Token(
                    name: 'numHeadingBoldLg',
                    child: _TextStyle(theme.textStyle.numHeadingBoldLg),
                ),
                 _Token(
                    name: 'numHeadingBoldMd',
                    child: _TextStyle(theme.textStyle.numHeadingBoldMd),
                ),
                 _Token(
                    name: 'numHeadingBoldXl',
                    child: _TextStyle(theme.textStyle.numHeadingBoldXl),
                ),
                 _Token(
                    name: 'numHeadingMedium2xl',
                    child: _TextStyle(theme.textStyle.numHeadingMedium2xl),
                ),
                 _Token(
                    name: 'numHeadingMediumLg',
                    child: _TextStyle(theme.textStyle.numHeadingMediumLg),
                ),
                 _Token(
                    name: 'numHeadingMediumMd',
                    child: _TextStyle(theme.textStyle.numHeadingMediumMd),
                ),
                 _Token(
                    name: 'numHeadingMediumXl',
                    child: _TextStyle(theme.textStyle.numHeadingMediumXl),
                ),
                 _Token(
                    name: 'numHeadingSemibold2xl',
                    child: _TextStyle(theme.textStyle.numHeadingSemibold2xl),
                ),
                 _Token(
                    name: 'numHeadingSemibold3xl',
                    child: _TextStyle(theme.textStyle.numHeadingSemibold3xl),
                ),
                 _Token(
                    name: 'numHeadingSemiboldLg',
                    child: _TextStyle(theme.textStyle.numHeadingSemiboldLg),
                ),
                 _Token(
                    name: 'numHeadingSemiboldMd',
                    child: _TextStyle(theme.textStyle.numHeadingSemiboldMd),
                ),
                 _Token(
                    name: 'numHeadingSemiboldXl',
                    child: _TextStyle(theme.textStyle.numHeadingSemiboldXl),
                ),
                
            ],
        );
    }
}

class _DoubleSection extends StatelessWidget {
    const _DoubleSection({
        Key? key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final theme = AppTheme.of(context);
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                _Header('Double'),
                 _Token(
                    name: 'enBodyMediumLgFontSize',
                    child: _Double(theme.double.enBodyMediumLgFontSize),
                ),
                 _Token(
                    name: 'enBodyMediumLgLetterSpacing',
                    child: _Double(theme.double.enBodyMediumLgLetterSpacing),
                ),
                 _Token(
                    name: 'enBodyMediumLgLineHeight',
                    child: _Double(theme.double.enBodyMediumLgLineHeight),
                ),
                 _Token(
                    name: 'enBodyMediumLgParagraphIndent',
                    child: _Double(theme.double.enBodyMediumLgParagraphIndent),
                ),
                 _Token(
                    name: 'enBodyMediumLgParagraphSpacing',
                    child: _Double(theme.double.enBodyMediumLgParagraphSpacing),
                ),
                 _Token(
                    name: 'enBodyMediumMdFontSize',
                    child: _Double(theme.double.enBodyMediumMdFontSize),
                ),
                 _Token(
                    name: 'enBodyMediumMdLetterSpacing',
                    child: _Double(theme.double.enBodyMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'enBodyMediumMdLineHeight',
                    child: _Double(theme.double.enBodyMediumMdLineHeight),
                ),
                 _Token(
                    name: 'enBodyMediumMdParagraphIndent',
                    child: _Double(theme.double.enBodyMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'enBodyMediumMdParagraphSpacing',
                    child: _Double(theme.double.enBodyMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'enBodyMediumSmFontSize',
                    child: _Double(theme.double.enBodyMediumSmFontSize),
                ),
                 _Token(
                    name: 'enBodyMediumSmLetterSpacing',
                    child: _Double(theme.double.enBodyMediumSmLetterSpacing),
                ),
                 _Token(
                    name: 'enBodyMediumSmLineHeight',
                    child: _Double(theme.double.enBodyMediumSmLineHeight),
                ),
                 _Token(
                    name: 'enBodyMediumSmParagraphIndent',
                    child: _Double(theme.double.enBodyMediumSmParagraphIndent),
                ),
                 _Token(
                    name: 'enBodyMediumSmParagraphSpacing',
                    child: _Double(theme.double.enBodyMediumSmParagraphSpacing),
                ),
                 _Token(
                    name: 'enBodyMediumXlFontSize',
                    child: _Double(theme.double.enBodyMediumXlFontSize),
                ),
                 _Token(
                    name: 'enBodyMediumXlLetterSpacing',
                    child: _Double(theme.double.enBodyMediumXlLetterSpacing),
                ),
                 _Token(
                    name: 'enBodyMediumXlLineHeight',
                    child: _Double(theme.double.enBodyMediumXlLineHeight),
                ),
                 _Token(
                    name: 'enBodyMediumXlParagraphIndent',
                    child: _Double(theme.double.enBodyMediumXlParagraphIndent),
                ),
                 _Token(
                    name: 'enBodyMediumXlParagraphSpacing',
                    child: _Double(theme.double.enBodyMediumXlParagraphSpacing),
                ),
                 _Token(
                    name: 'enBodySemiboldLgFontSize',
                    child: _Double(theme.double.enBodySemiboldLgFontSize),
                ),
                 _Token(
                    name: 'enBodySemiboldLgLetterSpacing',
                    child: _Double(theme.double.enBodySemiboldLgLetterSpacing),
                ),
                 _Token(
                    name: 'enBodySemiboldLgLineHeight',
                    child: _Double(theme.double.enBodySemiboldLgLineHeight),
                ),
                 _Token(
                    name: 'enBodySemiboldLgParagraphIndent',
                    child: _Double(theme.double.enBodySemiboldLgParagraphIndent),
                ),
                 _Token(
                    name: 'enBodySemiboldLgParagraphSpacing',
                    child: _Double(theme.double.enBodySemiboldLgParagraphSpacing),
                ),
                 _Token(
                    name: 'enBodySemiboldMdFontSize',
                    child: _Double(theme.double.enBodySemiboldMdFontSize),
                ),
                 _Token(
                    name: 'enBodySemiboldMdLetterSpacing',
                    child: _Double(theme.double.enBodySemiboldMdLetterSpacing),
                ),
                 _Token(
                    name: 'enBodySemiboldMdLineHeight',
                    child: _Double(theme.double.enBodySemiboldMdLineHeight),
                ),
                 _Token(
                    name: 'enBodySemiboldMdParagraphIndent',
                    child: _Double(theme.double.enBodySemiboldMdParagraphIndent),
                ),
                 _Token(
                    name: 'enBodySemiboldMdParagraphSpacing',
                    child: _Double(theme.double.enBodySemiboldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'enBodySemiboldSmFontSize',
                    child: _Double(theme.double.enBodySemiboldSmFontSize),
                ),
                 _Token(
                    name: 'enBodySemiboldSmLetterSpacing',
                    child: _Double(theme.double.enBodySemiboldSmLetterSpacing),
                ),
                 _Token(
                    name: 'enBodySemiboldSmLineHeight',
                    child: _Double(theme.double.enBodySemiboldSmLineHeight),
                ),
                 _Token(
                    name: 'enBodySemiboldSmParagraphIndent',
                    child: _Double(theme.double.enBodySemiboldSmParagraphIndent),
                ),
                 _Token(
                    name: 'enBodySemiboldSmParagraphSpacing',
                    child: _Double(theme.double.enBodySemiboldSmParagraphSpacing),
                ),
                 _Token(
                    name: 'enBodySemiboldXlFontSize',
                    child: _Double(theme.double.enBodySemiboldXlFontSize),
                ),
                 _Token(
                    name: 'enBodySemiboldXlLetterSpacing',
                    child: _Double(theme.double.enBodySemiboldXlLetterSpacing),
                ),
                 _Token(
                    name: 'enBodySemiboldXlLineHeight',
                    child: _Double(theme.double.enBodySemiboldXlLineHeight),
                ),
                 _Token(
                    name: 'enBodySemiboldXlParagraphIndent',
                    child: _Double(theme.double.enBodySemiboldXlParagraphIndent),
                ),
                 _Token(
                    name: 'enBodySemiboldXlParagraphSpacing',
                    child: _Double(theme.double.enBodySemiboldXlParagraphSpacing),
                ),
                 _Token(
                    name: 'enCaptionBoldMdFontSize',
                    child: _Double(theme.double.enCaptionBoldMdFontSize),
                ),
                 _Token(
                    name: 'enCaptionBoldMdLetterSpacing',
                    child: _Double(theme.double.enCaptionBoldMdLetterSpacing),
                ),
                 _Token(
                    name: 'enCaptionBoldMdLineHeight',
                    child: _Double(theme.double.enCaptionBoldMdLineHeight),
                ),
                 _Token(
                    name: 'enCaptionBoldMdParagraphIndent',
                    child: _Double(theme.double.enCaptionBoldMdParagraphIndent),
                ),
                 _Token(
                    name: 'enCaptionBoldMdParagraphSpacing',
                    child: _Double(theme.double.enCaptionBoldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'enCaptionMediumMdFontSize',
                    child: _Double(theme.double.enCaptionMediumMdFontSize),
                ),
                 _Token(
                    name: 'enCaptionMediumMdLetterSpacing',
                    child: _Double(theme.double.enCaptionMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'enCaptionMediumMdLineHeight',
                    child: _Double(theme.double.enCaptionMediumMdLineHeight),
                ),
                 _Token(
                    name: 'enCaptionMediumMdParagraphIndent',
                    child: _Double(theme.double.enCaptionMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'enCaptionMediumMdParagraphSpacing',
                    child: _Double(theme.double.enCaptionMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'enCaptionSemiboldMdFontSize',
                    child: _Double(theme.double.enCaptionSemiboldMdFontSize),
                ),
                 _Token(
                    name: 'enCaptionSemiboldMdLetterSpacing',
                    child: _Double(theme.double.enCaptionSemiboldMdLetterSpacing),
                ),
                 _Token(
                    name: 'enCaptionSemiboldMdLineHeight',
                    child: _Double(theme.double.enCaptionSemiboldMdLineHeight),
                ),
                 _Token(
                    name: 'enCaptionSemiboldMdParagraphIndent',
                    child: _Double(theme.double.enCaptionSemiboldMdParagraphIndent),
                ),
                 _Token(
                    name: 'enCaptionSemiboldMdParagraphSpacing',
                    child: _Double(theme.double.enCaptionSemiboldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingBlackLgFontSize',
                    child: _Double(theme.double.enHeadingBlackLgFontSize),
                ),
                 _Token(
                    name: 'enHeadingBlackLgLetterSpacing',
                    child: _Double(theme.double.enHeadingBlackLgLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingBlackLgLineHeight',
                    child: _Double(theme.double.enHeadingBlackLgLineHeight),
                ),
                 _Token(
                    name: 'enHeadingBlackLgParagraphIndent',
                    child: _Double(theme.double.enHeadingBlackLgParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingBlackLgParagraphSpacing',
                    child: _Double(theme.double.enHeadingBlackLgParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingBlackMdFontSize',
                    child: _Double(theme.double.enHeadingBlackMdFontSize),
                ),
                 _Token(
                    name: 'enHeadingBlackMdLetterSpacing',
                    child: _Double(theme.double.enHeadingBlackMdLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingBlackMdLineHeight',
                    child: _Double(theme.double.enHeadingBlackMdLineHeight),
                ),
                 _Token(
                    name: 'enHeadingBlackMdParagraphIndent',
                    child: _Double(theme.double.enHeadingBlackMdParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingBlackMdParagraphSpacing',
                    child: _Double(theme.double.enHeadingBlackMdParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingBlackSmFontSize',
                    child: _Double(theme.double.enHeadingBlackSmFontSize),
                ),
                 _Token(
                    name: 'enHeadingBlackSmLetterSpacing',
                    child: _Double(theme.double.enHeadingBlackSmLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingBlackSmLineHeight',
                    child: _Double(theme.double.enHeadingBlackSmLineHeight),
                ),
                 _Token(
                    name: 'enHeadingBlackSmParagraphIndent',
                    child: _Double(theme.double.enHeadingBlackSmParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingBlackSmParagraphSpacing',
                    child: _Double(theme.double.enHeadingBlackSmParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingBlackXlFontSize',
                    child: _Double(theme.double.enHeadingBlackXlFontSize),
                ),
                 _Token(
                    name: 'enHeadingBlackXlLetterSpacing',
                    child: _Double(theme.double.enHeadingBlackXlLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingBlackXlLineHeight',
                    child: _Double(theme.double.enHeadingBlackXlLineHeight),
                ),
                 _Token(
                    name: 'enHeadingBlackXlParagraphIndent',
                    child: _Double(theme.double.enHeadingBlackXlParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingBlackXlParagraphSpacing',
                    child: _Double(theme.double.enHeadingBlackXlParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingBoldLgFontSize',
                    child: _Double(theme.double.enHeadingBoldLgFontSize),
                ),
                 _Token(
                    name: 'enHeadingBoldLgLetterSpacing',
                    child: _Double(theme.double.enHeadingBoldLgLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingBoldLgLineHeight',
                    child: _Double(theme.double.enHeadingBoldLgLineHeight),
                ),
                 _Token(
                    name: 'enHeadingBoldLgParagraphIndent',
                    child: _Double(theme.double.enHeadingBoldLgParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingBoldLgParagraphSpacing',
                    child: _Double(theme.double.enHeadingBoldLgParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingBoldMdFontSize',
                    child: _Double(theme.double.enHeadingBoldMdFontSize),
                ),
                 _Token(
                    name: 'enHeadingBoldMdLetterSpacing',
                    child: _Double(theme.double.enHeadingBoldMdLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingBoldMdLineHeight',
                    child: _Double(theme.double.enHeadingBoldMdLineHeight),
                ),
                 _Token(
                    name: 'enHeadingBoldMdParagraphIndent',
                    child: _Double(theme.double.enHeadingBoldMdParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingBoldMdParagraphSpacing',
                    child: _Double(theme.double.enHeadingBoldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingBoldSmFontSize',
                    child: _Double(theme.double.enHeadingBoldSmFontSize),
                ),
                 _Token(
                    name: 'enHeadingBoldSmLetterSpacing',
                    child: _Double(theme.double.enHeadingBoldSmLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingBoldSmLineHeight',
                    child: _Double(theme.double.enHeadingBoldSmLineHeight),
                ),
                 _Token(
                    name: 'enHeadingBoldSmParagraphIndent',
                    child: _Double(theme.double.enHeadingBoldSmParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingBoldSmParagraphSpacing',
                    child: _Double(theme.double.enHeadingBoldSmParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingBoldXlFontSize',
                    child: _Double(theme.double.enHeadingBoldXlFontSize),
                ),
                 _Token(
                    name: 'enHeadingBoldXlLetterSpacing',
                    child: _Double(theme.double.enHeadingBoldXlLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingBoldXlLineHeight',
                    child: _Double(theme.double.enHeadingBoldXlLineHeight),
                ),
                 _Token(
                    name: 'enHeadingBoldXlParagraphIndent',
                    child: _Double(theme.double.enHeadingBoldXlParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingBoldXlParagraphSpacing',
                    child: _Double(theme.double.enHeadingBoldXlParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingMediumLgFontSize',
                    child: _Double(theme.double.enHeadingMediumLgFontSize),
                ),
                 _Token(
                    name: 'enHeadingMediumLgLetterSpacing',
                    child: _Double(theme.double.enHeadingMediumLgLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingMediumLgLineHeight',
                    child: _Double(theme.double.enHeadingMediumLgLineHeight),
                ),
                 _Token(
                    name: 'enHeadingMediumLgParagraphIndent',
                    child: _Double(theme.double.enHeadingMediumLgParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingMediumLgParagraphSpacing',
                    child: _Double(theme.double.enHeadingMediumLgParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingMediumMdFontSize',
                    child: _Double(theme.double.enHeadingMediumMdFontSize),
                ),
                 _Token(
                    name: 'enHeadingMediumMdLetterSpacing',
                    child: _Double(theme.double.enHeadingMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingMediumMdLineHeight',
                    child: _Double(theme.double.enHeadingMediumMdLineHeight),
                ),
                 _Token(
                    name: 'enHeadingMediumMdParagraphIndent',
                    child: _Double(theme.double.enHeadingMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingMediumMdParagraphSpacing',
                    child: _Double(theme.double.enHeadingMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingMediumSmFontSize',
                    child: _Double(theme.double.enHeadingMediumSmFontSize),
                ),
                 _Token(
                    name: 'enHeadingMediumSmLetterSpacing',
                    child: _Double(theme.double.enHeadingMediumSmLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingMediumSmLineHeight',
                    child: _Double(theme.double.enHeadingMediumSmLineHeight),
                ),
                 _Token(
                    name: 'enHeadingMediumSmParagraphIndent',
                    child: _Double(theme.double.enHeadingMediumSmParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingMediumSmParagraphSpacing',
                    child: _Double(theme.double.enHeadingMediumSmParagraphSpacing),
                ),
                 _Token(
                    name: 'enHeadingMediumXlFontSize',
                    child: _Double(theme.double.enHeadingMediumXlFontSize),
                ),
                 _Token(
                    name: 'enHeadingMediumXlLetterSpacing',
                    child: _Double(theme.double.enHeadingMediumXlLetterSpacing),
                ),
                 _Token(
                    name: 'enHeadingMediumXlLineHeight',
                    child: _Double(theme.double.enHeadingMediumXlLineHeight),
                ),
                 _Token(
                    name: 'enHeadingMediumXlParagraphIndent',
                    child: _Double(theme.double.enHeadingMediumXlParagraphIndent),
                ),
                 _Token(
                    name: 'enHeadingMediumXlParagraphSpacing',
                    child: _Double(theme.double.enHeadingMediumXlParagraphSpacing),
                ),
                 _Token(
                    name: 'enUnderlineMediumSmFontSize',
                    child: _Double(theme.double.enUnderlineMediumSmFontSize),
                ),
                 _Token(
                    name: 'enUnderlineMediumSmLetterSpacing',
                    child: _Double(theme.double.enUnderlineMediumSmLetterSpacing),
                ),
                 _Token(
                    name: 'enUnderlineMediumSmLineHeight',
                    child: _Double(theme.double.enUnderlineMediumSmLineHeight),
                ),
                 _Token(
                    name: 'enUnderlineMediumSmParagraphIndent',
                    child: _Double(theme.double.enUnderlineMediumSmParagraphIndent),
                ),
                 _Token(
                    name: 'enUnderlineMediumSmParagraphSpacing',
                    child: _Double(theme.double.enUnderlineMediumSmParagraphSpacing),
                ),
                 _Token(
                    name: 'koBodyMediumLgFontSize',
                    child: _Double(theme.double.koBodyMediumLgFontSize),
                ),
                 _Token(
                    name: 'koBodyMediumLgLetterSpacing',
                    child: _Double(theme.double.koBodyMediumLgLetterSpacing),
                ),
                 _Token(
                    name: 'koBodyMediumLgLineHeight',
                    child: _Double(theme.double.koBodyMediumLgLineHeight),
                ),
                 _Token(
                    name: 'koBodyMediumLgParagraphIndent',
                    child: _Double(theme.double.koBodyMediumLgParagraphIndent),
                ),
                 _Token(
                    name: 'koBodyMediumLgParagraphSpacing',
                    child: _Double(theme.double.koBodyMediumLgParagraphSpacing),
                ),
                 _Token(
                    name: 'koBodyMediumMdFontSize',
                    child: _Double(theme.double.koBodyMediumMdFontSize),
                ),
                 _Token(
                    name: 'koBodyMediumMdLetterSpacing',
                    child: _Double(theme.double.koBodyMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'koBodyMediumMdLineHeight',
                    child: _Double(theme.double.koBodyMediumMdLineHeight),
                ),
                 _Token(
                    name: 'koBodyMediumMdParagraphIndent',
                    child: _Double(theme.double.koBodyMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'koBodyMediumMdParagraphSpacing',
                    child: _Double(theme.double.koBodyMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'koBodyMediumSmFontSize',
                    child: _Double(theme.double.koBodyMediumSmFontSize),
                ),
                 _Token(
                    name: 'koBodyMediumSmLetterSpacing',
                    child: _Double(theme.double.koBodyMediumSmLetterSpacing),
                ),
                 _Token(
                    name: 'koBodyMediumSmLineHeight',
                    child: _Double(theme.double.koBodyMediumSmLineHeight),
                ),
                 _Token(
                    name: 'koBodyMediumSmParagraphIndent',
                    child: _Double(theme.double.koBodyMediumSmParagraphIndent),
                ),
                 _Token(
                    name: 'koBodyMediumSmParagraphSpacing',
                    child: _Double(theme.double.koBodyMediumSmParagraphSpacing),
                ),
                 _Token(
                    name: 'koBodyMediumXlFontSize',
                    child: _Double(theme.double.koBodyMediumXlFontSize),
                ),
                 _Token(
                    name: 'koBodyMediumXlLetterSpacing',
                    child: _Double(theme.double.koBodyMediumXlLetterSpacing),
                ),
                 _Token(
                    name: 'koBodyMediumXlLineHeight',
                    child: _Double(theme.double.koBodyMediumXlLineHeight),
                ),
                 _Token(
                    name: 'koBodyMediumXlParagraphIndent',
                    child: _Double(theme.double.koBodyMediumXlParagraphIndent),
                ),
                 _Token(
                    name: 'koBodyMediumXlParagraphSpacing',
                    child: _Double(theme.double.koBodyMediumXlParagraphSpacing),
                ),
                 _Token(
                    name: 'koBodySemiboldLgFontSize',
                    child: _Double(theme.double.koBodySemiboldLgFontSize),
                ),
                 _Token(
                    name: 'koBodySemiboldLgLetterSpacing',
                    child: _Double(theme.double.koBodySemiboldLgLetterSpacing),
                ),
                 _Token(
                    name: 'koBodySemiboldLgLineHeight',
                    child: _Double(theme.double.koBodySemiboldLgLineHeight),
                ),
                 _Token(
                    name: 'koBodySemiboldLgParagraphIndent',
                    child: _Double(theme.double.koBodySemiboldLgParagraphIndent),
                ),
                 _Token(
                    name: 'koBodySemiboldLgParagraphSpacing',
                    child: _Double(theme.double.koBodySemiboldLgParagraphSpacing),
                ),
                 _Token(
                    name: 'koBodySemiboldMdFontSize',
                    child: _Double(theme.double.koBodySemiboldMdFontSize),
                ),
                 _Token(
                    name: 'koBodySemiboldMdLetterSpacing',
                    child: _Double(theme.double.koBodySemiboldMdLetterSpacing),
                ),
                 _Token(
                    name: 'koBodySemiboldMdLineHeight',
                    child: _Double(theme.double.koBodySemiboldMdLineHeight),
                ),
                 _Token(
                    name: 'koBodySemiboldMdParagraphIndent',
                    child: _Double(theme.double.koBodySemiboldMdParagraphIndent),
                ),
                 _Token(
                    name: 'koBodySemiboldMdParagraphSpacing',
                    child: _Double(theme.double.koBodySemiboldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'koBodySemiboldSmFontSize',
                    child: _Double(theme.double.koBodySemiboldSmFontSize),
                ),
                 _Token(
                    name: 'koBodySemiboldSmLetterSpacing',
                    child: _Double(theme.double.koBodySemiboldSmLetterSpacing),
                ),
                 _Token(
                    name: 'koBodySemiboldSmLineHeight',
                    child: _Double(theme.double.koBodySemiboldSmLineHeight),
                ),
                 _Token(
                    name: 'koBodySemiboldSmParagraphIndent',
                    child: _Double(theme.double.koBodySemiboldSmParagraphIndent),
                ),
                 _Token(
                    name: 'koBodySemiboldSmParagraphSpacing',
                    child: _Double(theme.double.koBodySemiboldSmParagraphSpacing),
                ),
                 _Token(
                    name: 'koBodySemiboldXlFontSize',
                    child: _Double(theme.double.koBodySemiboldXlFontSize),
                ),
                 _Token(
                    name: 'koBodySemiboldXlLetterSpacing',
                    child: _Double(theme.double.koBodySemiboldXlLetterSpacing),
                ),
                 _Token(
                    name: 'koBodySemiboldXlLineHeight',
                    child: _Double(theme.double.koBodySemiboldXlLineHeight),
                ),
                 _Token(
                    name: 'koBodySemiboldXlParagraphIndent',
                    child: _Double(theme.double.koBodySemiboldXlParagraphIndent),
                ),
                 _Token(
                    name: 'koBodySemiboldXlParagraphSpacing',
                    child: _Double(theme.double.koBodySemiboldXlParagraphSpacing),
                ),
                 _Token(
                    name: 'koCaptionMediumMdFontSize',
                    child: _Double(theme.double.koCaptionMediumMdFontSize),
                ),
                 _Token(
                    name: 'koCaptionMediumMdLetterSpacing',
                    child: _Double(theme.double.koCaptionMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'koCaptionMediumMdLineHeight',
                    child: _Double(theme.double.koCaptionMediumMdLineHeight),
                ),
                 _Token(
                    name: 'koCaptionMediumMdParagraphIndent',
                    child: _Double(theme.double.koCaptionMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'koCaptionMediumMdParagraphSpacing',
                    child: _Double(theme.double.koCaptionMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'koCaptionSemiboldMdFontSize',
                    child: _Double(theme.double.koCaptionSemiboldMdFontSize),
                ),
                 _Token(
                    name: 'koCaptionSemiboldMdLetterSpacing',
                    child: _Double(theme.double.koCaptionSemiboldMdLetterSpacing),
                ),
                 _Token(
                    name: 'koCaptionSemiboldMdLineHeight',
                    child: _Double(theme.double.koCaptionSemiboldMdLineHeight),
                ),
                 _Token(
                    name: 'koCaptionSemiboldMdParagraphIndent',
                    child: _Double(theme.double.koCaptionSemiboldMdParagraphIndent),
                ),
                 _Token(
                    name: 'koCaptionSemiboldMdParagraphSpacing',
                    child: _Double(theme.double.koCaptionSemiboldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingBold2xlFontSize',
                    child: _Double(theme.double.koHeadingBold2xlFontSize),
                ),
                 _Token(
                    name: 'koHeadingBold2xlLetterSpacing',
                    child: _Double(theme.double.koHeadingBold2xlLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingBold2xlLineHeight',
                    child: _Double(theme.double.koHeadingBold2xlLineHeight),
                ),
                 _Token(
                    name: 'koHeadingBold2xlParagraphIndent',
                    child: _Double(theme.double.koHeadingBold2xlParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingBold2xlParagraphSpacing',
                    child: _Double(theme.double.koHeadingBold2xlParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingBoldLgFontSize',
                    child: _Double(theme.double.koHeadingBoldLgFontSize),
                ),
                 _Token(
                    name: 'koHeadingBoldLgLetterSpacing',
                    child: _Double(theme.double.koHeadingBoldLgLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingBoldLgLineHeight',
                    child: _Double(theme.double.koHeadingBoldLgLineHeight),
                ),
                 _Token(
                    name: 'koHeadingBoldLgParagraphIndent',
                    child: _Double(theme.double.koHeadingBoldLgParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingBoldLgParagraphSpacing',
                    child: _Double(theme.double.koHeadingBoldLgParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingBoldMdFontSize',
                    child: _Double(theme.double.koHeadingBoldMdFontSize),
                ),
                 _Token(
                    name: 'koHeadingBoldMdLetterSpacing',
                    child: _Double(theme.double.koHeadingBoldMdLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingBoldMdLineHeight',
                    child: _Double(theme.double.koHeadingBoldMdLineHeight),
                ),
                 _Token(
                    name: 'koHeadingBoldMdParagraphIndent',
                    child: _Double(theme.double.koHeadingBoldMdParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingBoldMdParagraphSpacing',
                    child: _Double(theme.double.koHeadingBoldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingBoldSmFontSize',
                    child: _Double(theme.double.koHeadingBoldSmFontSize),
                ),
                 _Token(
                    name: 'koHeadingBoldSmLetterSpacing',
                    child: _Double(theme.double.koHeadingBoldSmLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingBoldSmLineHeight',
                    child: _Double(theme.double.koHeadingBoldSmLineHeight),
                ),
                 _Token(
                    name: 'koHeadingBoldSmParagraphIndent',
                    child: _Double(theme.double.koHeadingBoldSmParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingBoldSmParagraphSpacing',
                    child: _Double(theme.double.koHeadingBoldSmParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingBoldXlFontSize',
                    child: _Double(theme.double.koHeadingBoldXlFontSize),
                ),
                 _Token(
                    name: 'koHeadingBoldXlLetterSpacing',
                    child: _Double(theme.double.koHeadingBoldXlLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingBoldXlLineHeight',
                    child: _Double(theme.double.koHeadingBoldXlLineHeight),
                ),
                 _Token(
                    name: 'koHeadingBoldXlParagraphIndent',
                    child: _Double(theme.double.koHeadingBoldXlParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingBoldXlParagraphSpacing',
                    child: _Double(theme.double.koHeadingBoldXlParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingMedium2xlFontSize',
                    child: _Double(theme.double.koHeadingMedium2xlFontSize),
                ),
                 _Token(
                    name: 'koHeadingMedium2xlLetterSpacing',
                    child: _Double(theme.double.koHeadingMedium2xlLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingMedium2xlLineHeight',
                    child: _Double(theme.double.koHeadingMedium2xlLineHeight),
                ),
                 _Token(
                    name: 'koHeadingMedium2xlParagraphIndent',
                    child: _Double(theme.double.koHeadingMedium2xlParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingMedium2xlParagraphSpacing',
                    child: _Double(theme.double.koHeadingMedium2xlParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingMediumLgFontSize',
                    child: _Double(theme.double.koHeadingMediumLgFontSize),
                ),
                 _Token(
                    name: 'koHeadingMediumLgLetterSpacing',
                    child: _Double(theme.double.koHeadingMediumLgLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingMediumLgLineHeight',
                    child: _Double(theme.double.koHeadingMediumLgLineHeight),
                ),
                 _Token(
                    name: 'koHeadingMediumLgParagraphIndent',
                    child: _Double(theme.double.koHeadingMediumLgParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingMediumLgParagraphSpacing',
                    child: _Double(theme.double.koHeadingMediumLgParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingMediumMdFontSize',
                    child: _Double(theme.double.koHeadingMediumMdFontSize),
                ),
                 _Token(
                    name: 'koHeadingMediumMdLetterSpacing',
                    child: _Double(theme.double.koHeadingMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingMediumMdLineHeight',
                    child: _Double(theme.double.koHeadingMediumMdLineHeight),
                ),
                 _Token(
                    name: 'koHeadingMediumMdParagraphIndent',
                    child: _Double(theme.double.koHeadingMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingMediumMdParagraphSpacing',
                    child: _Double(theme.double.koHeadingMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingMediumSmFontSize',
                    child: _Double(theme.double.koHeadingMediumSmFontSize),
                ),
                 _Token(
                    name: 'koHeadingMediumSmLetterSpacing',
                    child: _Double(theme.double.koHeadingMediumSmLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingMediumSmLineHeight',
                    child: _Double(theme.double.koHeadingMediumSmLineHeight),
                ),
                 _Token(
                    name: 'koHeadingMediumSmParagraphIndent',
                    child: _Double(theme.double.koHeadingMediumSmParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingMediumSmParagraphSpacing',
                    child: _Double(theme.double.koHeadingMediumSmParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingMediumXlFontSize',
                    child: _Double(theme.double.koHeadingMediumXlFontSize),
                ),
                 _Token(
                    name: 'koHeadingMediumXlLetterSpacing',
                    child: _Double(theme.double.koHeadingMediumXlLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingMediumXlLineHeight',
                    child: _Double(theme.double.koHeadingMediumXlLineHeight),
                ),
                 _Token(
                    name: 'koHeadingMediumXlParagraphIndent',
                    child: _Double(theme.double.koHeadingMediumXlParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingMediumXlParagraphSpacing',
                    child: _Double(theme.double.koHeadingMediumXlParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemibold2xlFontSize',
                    child: _Double(theme.double.koHeadingSemibold2xlFontSize),
                ),
                 _Token(
                    name: 'koHeadingSemibold2xlLetterSpacing',
                    child: _Double(theme.double.koHeadingSemibold2xlLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemibold2xlLineHeight',
                    child: _Double(theme.double.koHeadingSemibold2xlLineHeight),
                ),
                 _Token(
                    name: 'koHeadingSemibold2xlParagraphIndent',
                    child: _Double(theme.double.koHeadingSemibold2xlParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingSemibold2xlParagraphSpacing',
                    child: _Double(theme.double.koHeadingSemibold2xlParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemiboldLgFontSize',
                    child: _Double(theme.double.koHeadingSemiboldLgFontSize),
                ),
                 _Token(
                    name: 'koHeadingSemiboldLgLetterSpacing',
                    child: _Double(theme.double.koHeadingSemiboldLgLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemiboldLgLineHeight',
                    child: _Double(theme.double.koHeadingSemiboldLgLineHeight),
                ),
                 _Token(
                    name: 'koHeadingSemiboldLgParagraphIndent',
                    child: _Double(theme.double.koHeadingSemiboldLgParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingSemiboldLgParagraphSpacing',
                    child: _Double(theme.double.koHeadingSemiboldLgParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemiboldMdFontSize',
                    child: _Double(theme.double.koHeadingSemiboldMdFontSize),
                ),
                 _Token(
                    name: 'koHeadingSemiboldMdLetterSpacing',
                    child: _Double(theme.double.koHeadingSemiboldMdLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemiboldMdLineHeight',
                    child: _Double(theme.double.koHeadingSemiboldMdLineHeight),
                ),
                 _Token(
                    name: 'koHeadingSemiboldMdParagraphIndent',
                    child: _Double(theme.double.koHeadingSemiboldMdParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingSemiboldMdParagraphSpacing',
                    child: _Double(theme.double.koHeadingSemiboldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemiboldSmFontSize',
                    child: _Double(theme.double.koHeadingSemiboldSmFontSize),
                ),
                 _Token(
                    name: 'koHeadingSemiboldSmLetterSpacing',
                    child: _Double(theme.double.koHeadingSemiboldSmLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemiboldSmLineHeight',
                    child: _Double(theme.double.koHeadingSemiboldSmLineHeight),
                ),
                 _Token(
                    name: 'koHeadingSemiboldSmParagraphIndent',
                    child: _Double(theme.double.koHeadingSemiboldSmParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingSemiboldSmParagraphSpacing',
                    child: _Double(theme.double.koHeadingSemiboldSmParagraphSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemiboldXlFontSize',
                    child: _Double(theme.double.koHeadingSemiboldXlFontSize),
                ),
                 _Token(
                    name: 'koHeadingSemiboldXlLetterSpacing',
                    child: _Double(theme.double.koHeadingSemiboldXlLetterSpacing),
                ),
                 _Token(
                    name: 'koHeadingSemiboldXlLineHeight',
                    child: _Double(theme.double.koHeadingSemiboldXlLineHeight),
                ),
                 _Token(
                    name: 'koHeadingSemiboldXlParagraphIndent',
                    child: _Double(theme.double.koHeadingSemiboldXlParagraphIndent),
                ),
                 _Token(
                    name: 'koHeadingSemiboldXlParagraphSpacing',
                    child: _Double(theme.double.koHeadingSemiboldXlParagraphSpacing),
                ),
                 _Token(
                    name: 'koUnderlineMediumMdFontSize',
                    child: _Double(theme.double.koUnderlineMediumMdFontSize),
                ),
                 _Token(
                    name: 'koUnderlineMediumMdLetterSpacing',
                    child: _Double(theme.double.koUnderlineMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'koUnderlineMediumMdLineHeight',
                    child: _Double(theme.double.koUnderlineMediumMdLineHeight),
                ),
                 _Token(
                    name: 'koUnderlineMediumMdParagraphIndent',
                    child: _Double(theme.double.koUnderlineMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'koUnderlineMediumMdParagraphSpacing',
                    child: _Double(theme.double.koUnderlineMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'koUnderlineMediumSmFontSize',
                    child: _Double(theme.double.koUnderlineMediumSmFontSize),
                ),
                 _Token(
                    name: 'koUnderlineMediumSmLetterSpacing',
                    child: _Double(theme.double.koUnderlineMediumSmLetterSpacing),
                ),
                 _Token(
                    name: 'koUnderlineMediumSmLineHeight',
                    child: _Double(theme.double.koUnderlineMediumSmLineHeight),
                ),
                 _Token(
                    name: 'koUnderlineMediumSmParagraphIndent',
                    child: _Double(theme.double.koUnderlineMediumSmParagraphIndent),
                ),
                 _Token(
                    name: 'koUnderlineMediumSmParagraphSpacing',
                    child: _Double(theme.double.koUnderlineMediumSmParagraphSpacing),
                ),
                 _Token(
                    name: 'numBodyMediumMdFontSize',
                    child: _Double(theme.double.numBodyMediumMdFontSize),
                ),
                 _Token(
                    name: 'numBodyMediumMdLetterSpacing',
                    child: _Double(theme.double.numBodyMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'numBodyMediumMdLineHeight',
                    child: _Double(theme.double.numBodyMediumMdLineHeight),
                ),
                 _Token(
                    name: 'numBodyMediumMdParagraphIndent',
                    child: _Double(theme.double.numBodyMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'numBodyMediumMdParagraphSpacing',
                    child: _Double(theme.double.numBodyMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'numBodyMediumSmFontSize',
                    child: _Double(theme.double.numBodyMediumSmFontSize),
                ),
                 _Token(
                    name: 'numBodyMediumSmLetterSpacing',
                    child: _Double(theme.double.numBodyMediumSmLetterSpacing),
                ),
                 _Token(
                    name: 'numBodyMediumSmLineHeight',
                    child: _Double(theme.double.numBodyMediumSmLineHeight),
                ),
                 _Token(
                    name: 'numBodyMediumSmParagraphIndent',
                    child: _Double(theme.double.numBodyMediumSmParagraphIndent),
                ),
                 _Token(
                    name: 'numBodyMediumSmParagraphSpacing',
                    child: _Double(theme.double.numBodyMediumSmParagraphSpacing),
                ),
                 _Token(
                    name: 'numBodyMediumXlFontSize',
                    child: _Double(theme.double.numBodyMediumXlFontSize),
                ),
                 _Token(
                    name: 'numBodyMediumXlLetterSpacing',
                    child: _Double(theme.double.numBodyMediumXlLetterSpacing),
                ),
                 _Token(
                    name: 'numBodyMediumXlLineHeight',
                    child: _Double(theme.double.numBodyMediumXlLineHeight),
                ),
                 _Token(
                    name: 'numBodyMediumXlParagraphIndent',
                    child: _Double(theme.double.numBodyMediumXlParagraphIndent),
                ),
                 _Token(
                    name: 'numBodyMediumXlParagraphSpacing',
                    child: _Double(theme.double.numBodyMediumXlParagraphSpacing),
                ),
                 _Token(
                    name: 'numBodySemiboldMdFontSize',
                    child: _Double(theme.double.numBodySemiboldMdFontSize),
                ),
                 _Token(
                    name: 'numBodySemiboldMdLetterSpacing',
                    child: _Double(theme.double.numBodySemiboldMdLetterSpacing),
                ),
                 _Token(
                    name: 'numBodySemiboldMdLineHeight',
                    child: _Double(theme.double.numBodySemiboldMdLineHeight),
                ),
                 _Token(
                    name: 'numBodySemiboldMdParagraphIndent',
                    child: _Double(theme.double.numBodySemiboldMdParagraphIndent),
                ),
                 _Token(
                    name: 'numBodySemiboldMdParagraphSpacing',
                    child: _Double(theme.double.numBodySemiboldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'numBodySemiboldSmFontSize',
                    child: _Double(theme.double.numBodySemiboldSmFontSize),
                ),
                 _Token(
                    name: 'numBodySemiboldSmLetterSpacing',
                    child: _Double(theme.double.numBodySemiboldSmLetterSpacing),
                ),
                 _Token(
                    name: 'numBodySemiboldSmLineHeight',
                    child: _Double(theme.double.numBodySemiboldSmLineHeight),
                ),
                 _Token(
                    name: 'numBodySemiboldSmParagraphIndent',
                    child: _Double(theme.double.numBodySemiboldSmParagraphIndent),
                ),
                 _Token(
                    name: 'numBodySemiboldSmParagraphSpacing',
                    child: _Double(theme.double.numBodySemiboldSmParagraphSpacing),
                ),
                 _Token(
                    name: 'numBodySemiboldXlFontSize',
                    child: _Double(theme.double.numBodySemiboldXlFontSize),
                ),
                 _Token(
                    name: 'numBodySemiboldXlLetterSpacing',
                    child: _Double(theme.double.numBodySemiboldXlLetterSpacing),
                ),
                 _Token(
                    name: 'numBodySemiboldXlLineHeight',
                    child: _Double(theme.double.numBodySemiboldXlLineHeight),
                ),
                 _Token(
                    name: 'numBodySemiboldXlParagraphIndent',
                    child: _Double(theme.double.numBodySemiboldXlParagraphIndent),
                ),
                 _Token(
                    name: 'numBodySemiboldXlParagraphSpacing',
                    child: _Double(theme.double.numBodySemiboldXlParagraphSpacing),
                ),
                 _Token(
                    name: 'numCaptionMediumMdFontSize',
                    child: _Double(theme.double.numCaptionMediumMdFontSize),
                ),
                 _Token(
                    name: 'numCaptionMediumMdLetterSpacing',
                    child: _Double(theme.double.numCaptionMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'numCaptionMediumMdLineHeight',
                    child: _Double(theme.double.numCaptionMediumMdLineHeight),
                ),
                 _Token(
                    name: 'numCaptionMediumMdParagraphIndent',
                    child: _Double(theme.double.numCaptionMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'numCaptionMediumMdParagraphSpacing',
                    child: _Double(theme.double.numCaptionMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'numCaptionSemiboldMdFontSize',
                    child: _Double(theme.double.numCaptionSemiboldMdFontSize),
                ),
                 _Token(
                    name: 'numCaptionSemiboldMdLetterSpacing',
                    child: _Double(theme.double.numCaptionSemiboldMdLetterSpacing),
                ),
                 _Token(
                    name: 'numCaptionSemiboldMdLineHeight',
                    child: _Double(theme.double.numCaptionSemiboldMdLineHeight),
                ),
                 _Token(
                    name: 'numCaptionSemiboldMdParagraphIndent',
                    child: _Double(theme.double.numCaptionSemiboldMdParagraphIndent),
                ),
                 _Token(
                    name: 'numCaptionSemiboldMdParagraphSpacing',
                    child: _Double(theme.double.numCaptionSemiboldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingBold2xlFontSize',
                    child: _Double(theme.double.numHeadingBold2xlFontSize),
                ),
                 _Token(
                    name: 'numHeadingBold2xlLetterSpacing',
                    child: _Double(theme.double.numHeadingBold2xlLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingBold2xlLineHeight',
                    child: _Double(theme.double.numHeadingBold2xlLineHeight),
                ),
                 _Token(
                    name: 'numHeadingBold2xlParagraphIndent',
                    child: _Double(theme.double.numHeadingBold2xlParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingBold2xlParagraphSpacing',
                    child: _Double(theme.double.numHeadingBold2xlParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingBoldLgFontSize',
                    child: _Double(theme.double.numHeadingBoldLgFontSize),
                ),
                 _Token(
                    name: 'numHeadingBoldLgLetterSpacing',
                    child: _Double(theme.double.numHeadingBoldLgLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingBoldLgLineHeight',
                    child: _Double(theme.double.numHeadingBoldLgLineHeight),
                ),
                 _Token(
                    name: 'numHeadingBoldLgParagraphIndent',
                    child: _Double(theme.double.numHeadingBoldLgParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingBoldLgParagraphSpacing',
                    child: _Double(theme.double.numHeadingBoldLgParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingBoldMdFontSize',
                    child: _Double(theme.double.numHeadingBoldMdFontSize),
                ),
                 _Token(
                    name: 'numHeadingBoldMdLetterSpacing',
                    child: _Double(theme.double.numHeadingBoldMdLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingBoldMdLineHeight',
                    child: _Double(theme.double.numHeadingBoldMdLineHeight),
                ),
                 _Token(
                    name: 'numHeadingBoldMdParagraphIndent',
                    child: _Double(theme.double.numHeadingBoldMdParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingBoldMdParagraphSpacing',
                    child: _Double(theme.double.numHeadingBoldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingBoldXlFontSize',
                    child: _Double(theme.double.numHeadingBoldXlFontSize),
                ),
                 _Token(
                    name: 'numHeadingBoldXlLetterSpacing',
                    child: _Double(theme.double.numHeadingBoldXlLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingBoldXlLineHeight',
                    child: _Double(theme.double.numHeadingBoldXlLineHeight),
                ),
                 _Token(
                    name: 'numHeadingBoldXlParagraphIndent',
                    child: _Double(theme.double.numHeadingBoldXlParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingBoldXlParagraphSpacing',
                    child: _Double(theme.double.numHeadingBoldXlParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingMedium2xlFontSize',
                    child: _Double(theme.double.numHeadingMedium2xlFontSize),
                ),
                 _Token(
                    name: 'numHeadingMedium2xlLetterSpacing',
                    child: _Double(theme.double.numHeadingMedium2xlLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingMedium2xlLineHeight',
                    child: _Double(theme.double.numHeadingMedium2xlLineHeight),
                ),
                 _Token(
                    name: 'numHeadingMedium2xlParagraphIndent',
                    child: _Double(theme.double.numHeadingMedium2xlParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingMedium2xlParagraphSpacing',
                    child: _Double(theme.double.numHeadingMedium2xlParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingMediumLgFontSize',
                    child: _Double(theme.double.numHeadingMediumLgFontSize),
                ),
                 _Token(
                    name: 'numHeadingMediumLgLetterSpacing',
                    child: _Double(theme.double.numHeadingMediumLgLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingMediumLgLineHeight',
                    child: _Double(theme.double.numHeadingMediumLgLineHeight),
                ),
                 _Token(
                    name: 'numHeadingMediumLgParagraphIndent',
                    child: _Double(theme.double.numHeadingMediumLgParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingMediumLgParagraphSpacing',
                    child: _Double(theme.double.numHeadingMediumLgParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingMediumMdFontSize',
                    child: _Double(theme.double.numHeadingMediumMdFontSize),
                ),
                 _Token(
                    name: 'numHeadingMediumMdLetterSpacing',
                    child: _Double(theme.double.numHeadingMediumMdLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingMediumMdLineHeight',
                    child: _Double(theme.double.numHeadingMediumMdLineHeight),
                ),
                 _Token(
                    name: 'numHeadingMediumMdParagraphIndent',
                    child: _Double(theme.double.numHeadingMediumMdParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingMediumMdParagraphSpacing',
                    child: _Double(theme.double.numHeadingMediumMdParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingMediumXlFontSize',
                    child: _Double(theme.double.numHeadingMediumXlFontSize),
                ),
                 _Token(
                    name: 'numHeadingMediumXlLetterSpacing',
                    child: _Double(theme.double.numHeadingMediumXlLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingMediumXlLineHeight',
                    child: _Double(theme.double.numHeadingMediumXlLineHeight),
                ),
                 _Token(
                    name: 'numHeadingMediumXlParagraphIndent',
                    child: _Double(theme.double.numHeadingMediumXlParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingMediumXlParagraphSpacing',
                    child: _Double(theme.double.numHeadingMediumXlParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemibold2xlFontSize',
                    child: _Double(theme.double.numHeadingSemibold2xlFontSize),
                ),
                 _Token(
                    name: 'numHeadingSemibold2xlLetterSpacing',
                    child: _Double(theme.double.numHeadingSemibold2xlLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemibold2xlLineHeight',
                    child: _Double(theme.double.numHeadingSemibold2xlLineHeight),
                ),
                 _Token(
                    name: 'numHeadingSemibold2xlParagraphIndent',
                    child: _Double(theme.double.numHeadingSemibold2xlParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingSemibold2xlParagraphSpacing',
                    child: _Double(theme.double.numHeadingSemibold2xlParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemibold3xlFontSize',
                    child: _Double(theme.double.numHeadingSemibold3xlFontSize),
                ),
                 _Token(
                    name: 'numHeadingSemibold3xlLetterSpacing',
                    child: _Double(theme.double.numHeadingSemibold3xlLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemibold3xlLineHeight',
                    child: _Double(theme.double.numHeadingSemibold3xlLineHeight),
                ),
                 _Token(
                    name: 'numHeadingSemibold3xlParagraphIndent',
                    child: _Double(theme.double.numHeadingSemibold3xlParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingSemibold3xlParagraphSpacing',
                    child: _Double(theme.double.numHeadingSemibold3xlParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemiboldLgFontSize',
                    child: _Double(theme.double.numHeadingSemiboldLgFontSize),
                ),
                 _Token(
                    name: 'numHeadingSemiboldLgLetterSpacing',
                    child: _Double(theme.double.numHeadingSemiboldLgLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemiboldLgLineHeight',
                    child: _Double(theme.double.numHeadingSemiboldLgLineHeight),
                ),
                 _Token(
                    name: 'numHeadingSemiboldLgParagraphIndent',
                    child: _Double(theme.double.numHeadingSemiboldLgParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingSemiboldLgParagraphSpacing',
                    child: _Double(theme.double.numHeadingSemiboldLgParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemiboldMdFontSize',
                    child: _Double(theme.double.numHeadingSemiboldMdFontSize),
                ),
                 _Token(
                    name: 'numHeadingSemiboldMdLetterSpacing',
                    child: _Double(theme.double.numHeadingSemiboldMdLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemiboldMdLineHeight',
                    child: _Double(theme.double.numHeadingSemiboldMdLineHeight),
                ),
                 _Token(
                    name: 'numHeadingSemiboldMdParagraphIndent',
                    child: _Double(theme.double.numHeadingSemiboldMdParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingSemiboldMdParagraphSpacing',
                    child: _Double(theme.double.numHeadingSemiboldMdParagraphSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemiboldXlFontSize',
                    child: _Double(theme.double.numHeadingSemiboldXlFontSize),
                ),
                 _Token(
                    name: 'numHeadingSemiboldXlLetterSpacing',
                    child: _Double(theme.double.numHeadingSemiboldXlLetterSpacing),
                ),
                 _Token(
                    name: 'numHeadingSemiboldXlLineHeight',
                    child: _Double(theme.double.numHeadingSemiboldXlLineHeight),
                ),
                 _Token(
                    name: 'numHeadingSemiboldXlParagraphIndent',
                    child: _Double(theme.double.numHeadingSemiboldXlParagraphIndent),
                ),
                 _Token(
                    name: 'numHeadingSemiboldXlParagraphSpacing',
                    child: _Double(theme.double.numHeadingSemiboldXlParagraphSpacing),
                ),
                 _Token(
                    name: 'numberCardW104',
                    child: _Double(theme.double.numberCardW104),
                ),
                 _Token(
                    name: 'numberCardW108',
                    child: _Double(theme.double.numberCardW108),
                ),
                 _Token(
                    name: 'numberCardW114',
                    child: _Double(theme.double.numberCardW114),
                ),
                 _Token(
                    name: 'numberCardW174',
                    child: _Double(theme.double.numberCardW174),
                ),
                 _Token(
                    name: 'numberCardW316',
                    child: _Double(theme.double.numberCardW316),
                ),
                 _Token(
                    name: 'numberCardW358',
                    child: _Double(theme.double.numberCardW358),
                ),
                 _Token(
                    name: 'numberCardW390',
                    child: _Double(theme.double.numberCardW390),
                ),
                 _Token(
                    name: 'numberCardW82',
                    child: _Double(theme.double.numberCardW82),
                ),
                 _Token(
                    name: 'numberRadius0',
                    child: _Double(theme.double.numberRadius0),
                ),
                 _Token(
                    name: 'numberRadius12',
                    child: _Double(theme.double.numberRadius12),
                ),
                 _Token(
                    name: 'numberRadius16',
                    child: _Double(theme.double.numberRadius16),
                ),
                 _Token(
                    name: 'numberRadius20',
                    child: _Double(theme.double.numberRadius20),
                ),
                 _Token(
                    name: 'numberRadius4',
                    child: _Double(theme.double.numberRadius4),
                ),
                 _Token(
                    name: 'numberRadius8',
                    child: _Double(theme.double.numberRadius8),
                ),
                 _Token(
                    name: 'numberRadiusCircle',
                    child: _Double(theme.double.numberRadiusCircle),
                ),
                 _Token(
                    name: 'numberSpacing0',
                    child: _Double(theme.double.numberSpacing0),
                ),
                 _Token(
                    name: 'numberSpacing10',
                    child: _Double(theme.double.numberSpacing10),
                ),
                 _Token(
                    name: 'numberSpacing12',
                    child: _Double(theme.double.numberSpacing12),
                ),
                 _Token(
                    name: 'numberSpacing16',
                    child: _Double(theme.double.numberSpacing16),
                ),
                 _Token(
                    name: 'numberSpacing2',
                    child: _Double(theme.double.numberSpacing2),
                ),
                 _Token(
                    name: 'numberSpacing20',
                    child: _Double(theme.double.numberSpacing20),
                ),
                 _Token(
                    name: 'numberSpacing24',
                    child: _Double(theme.double.numberSpacing24),
                ),
                 _Token(
                    name: 'numberSpacing28',
                    child: _Double(theme.double.numberSpacing28),
                ),
                 _Token(
                    name: 'numberSpacing32',
                    child: _Double(theme.double.numberSpacing32),
                ),
                 _Token(
                    name: 'numberSpacing36',
                    child: _Double(theme.double.numberSpacing36),
                ),
                 _Token(
                    name: 'numberSpacing4',
                    child: _Double(theme.double.numberSpacing4),
                ),
                 _Token(
                    name: 'numberSpacing40',
                    child: _Double(theme.double.numberSpacing40),
                ),
                 _Token(
                    name: 'numberSpacing44',
                    child: _Double(theme.double.numberSpacing44),
                ),
                 _Token(
                    name: 'numberSpacing48',
                    child: _Double(theme.double.numberSpacing48),
                ),
                 _Token(
                    name: 'numberSpacing52',
                    child: _Double(theme.double.numberSpacing52),
                ),
                 _Token(
                    name: 'numberSpacing56',
                    child: _Double(theme.double.numberSpacing56),
                ),
                 _Token(
                    name: 'numberSpacing60',
                    child: _Double(theme.double.numberSpacing60),
                ),
                 _Token(
                    name: 'numberSpacing64',
                    child: _Double(theme.double.numberSpacing64),
                ),
                 _Token(
                    name: 'numberSpacing68',
                    child: _Double(theme.double.numberSpacing68),
                ),
                 _Token(
                    name: 'numberSpacing72',
                    child: _Double(theme.double.numberSpacing72),
                ),
                 _Token(
                    name: 'numberSpacing76',
                    child: _Double(theme.double.numberSpacing76),
                ),
                 _Token(
                    name: 'numberSpacing8',
                    child: _Double(theme.double.numberSpacing8),
                ),
                 _Token(
                    name: 'numberSpacing80',
                    child: _Double(theme.double.numberSpacing80),
                ),
                 _Token(
                    name: 'numberStroke1',
                    child: _Double(theme.double.numberStroke1),
                ),
                 _Token(
                    name: 'numberStroke2',
                    child: _Double(theme.double.numberStroke2),
                ),
                 _Token(
                    name: 'numberStroke4',
                    child: _Double(theme.double.numberStroke4),
                ),
                 _Token(
                    name: 'unit0',
                    child: _Double(theme.double.unit0),
                ),
                 _Token(
                    name: 'unit1',
                    child: _Double(theme.double.unit1),
                ),
                 _Token(
                    name: 'unit10',
                    child: _Double(theme.double.unit10),
                ),
                 _Token(
                    name: 'unit100',
                    child: _Double(theme.double.unit100),
                ),
                 _Token(
                    name: 'unit104',
                    child: _Double(theme.double.unit104),
                ),
                 _Token(
                    name: 'unit108',
                    child: _Double(theme.double.unit108),
                ),
                 _Token(
                    name: 'unit112',
                    child: _Double(theme.double.unit112),
                ),
                 _Token(
                    name: 'unit114',
                    child: _Double(theme.double.unit114),
                ),
                 _Token(
                    name: 'unit116',
                    child: _Double(theme.double.unit116),
                ),
                 _Token(
                    name: 'unit12',
                    child: _Double(theme.double.unit12),
                ),
                 _Token(
                    name: 'unit120',
                    child: _Double(theme.double.unit120),
                ),
                 _Token(
                    name: 'unit124',
                    child: _Double(theme.double.unit124),
                ),
                 _Token(
                    name: 'unit128',
                    child: _Double(theme.double.unit128),
                ),
                 _Token(
                    name: 'unit132',
                    child: _Double(theme.double.unit132),
                ),
                 _Token(
                    name: 'unit136',
                    child: _Double(theme.double.unit136),
                ),
                 _Token(
                    name: 'unit140',
                    child: _Double(theme.double.unit140),
                ),
                 _Token(
                    name: 'unit144',
                    child: _Double(theme.double.unit144),
                ),
                 _Token(
                    name: 'unit148',
                    child: _Double(theme.double.unit148),
                ),
                 _Token(
                    name: 'unit152',
                    child: _Double(theme.double.unit152),
                ),
                 _Token(
                    name: 'unit156',
                    child: _Double(theme.double.unit156),
                ),
                 _Token(
                    name: 'unit16',
                    child: _Double(theme.double.unit16),
                ),
                 _Token(
                    name: 'unit160',
                    child: _Double(theme.double.unit160),
                ),
                 _Token(
                    name: 'unit164',
                    child: _Double(theme.double.unit164),
                ),
                 _Token(
                    name: 'unit168',
                    child: _Double(theme.double.unit168),
                ),
                 _Token(
                    name: 'unit172',
                    child: _Double(theme.double.unit172),
                ),
                 _Token(
                    name: 'unit174',
                    child: _Double(theme.double.unit174),
                ),
                 _Token(
                    name: 'unit176',
                    child: _Double(theme.double.unit176),
                ),
                 _Token(
                    name: 'unit2',
                    child: _Double(theme.double.unit2),
                ),
                 _Token(
                    name: 'unit20',
                    child: _Double(theme.double.unit20),
                ),
                 _Token(
                    name: 'unit24',
                    child: _Double(theme.double.unit24),
                ),
                 _Token(
                    name: 'unit28',
                    child: _Double(theme.double.unit28),
                ),
                 _Token(
                    name: 'unit312',
                    child: _Double(theme.double.unit312),
                ),
                 _Token(
                    name: 'unit316',
                    child: _Double(theme.double.unit316),
                ),
                 _Token(
                    name: 'unit32',
                    child: _Double(theme.double.unit32),
                ),
                 _Token(
                    name: 'unit358',
                    child: _Double(theme.double.unit358),
                ),
                 _Token(
                    name: 'unit36',
                    child: _Double(theme.double.unit36),
                ),
                 _Token(
                    name: 'unit390',
                    child: _Double(theme.double.unit390),
                ),
                 _Token(
                    name: 'unit4',
                    child: _Double(theme.double.unit4),
                ),
                 _Token(
                    name: 'unit40',
                    child: _Double(theme.double.unit40),
                ),
                 _Token(
                    name: 'unit44',
                    child: _Double(theme.double.unit44),
                ),
                 _Token(
                    name: 'unit48',
                    child: _Double(theme.double.unit48),
                ),
                 _Token(
                    name: 'unit52',
                    child: _Double(theme.double.unit52),
                ),
                 _Token(
                    name: 'unit56',
                    child: _Double(theme.double.unit56),
                ),
                 _Token(
                    name: 'unit60',
                    child: _Double(theme.double.unit60),
                ),
                 _Token(
                    name: 'unit64',
                    child: _Double(theme.double.unit64),
                ),
                 _Token(
                    name: 'unit68',
                    child: _Double(theme.double.unit68),
                ),
                 _Token(
                    name: 'unit72',
                    child: _Double(theme.double.unit72),
                ),
                 _Token(
                    name: 'unit76',
                    child: _Double(theme.double.unit76),
                ),
                 _Token(
                    name: 'unit8',
                    child: _Double(theme.double.unit8),
                ),
                 _Token(
                    name: 'unit80',
                    child: _Double(theme.double.unit80),
                ),
                 _Token(
                    name: 'unit82',
                    child: _Double(theme.double.unit82),
                ),
                 _Token(
                    name: 'unit88',
                    child: _Double(theme.double.unit88),
                ),
                 _Token(
                    name: 'unit92',
                    child: _Double(theme.double.unit92),
                ),
                 _Token(
                    name: 'unit96',
                    child: _Double(theme.double.unit96),
                ),
                
            ],
        );
    }
}


class _Header extends StatelessWidget {
  const _Header(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 10),
        child: Text(
            text,
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
            ),
        ),
    );
  }
}

class _Token extends StatelessWidget {
    const _Token({
        Key? key,
        required this.name,
        required this.child,
    }) : super(key: key);

    final String name;
    final Widget child;

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
                children: [
                    child,
                    const SizedBox(width: 10),
                    Expanded(   
                        child: Wrap(
                            children: [
                                Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Color(0xFFEEEEEE),
                                    borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                    name,
                                    style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF666666),
                                    ),
                                ),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}

class _Vector extends StatelessWidget {
  const _Vector(this.value,{
    Key? key,
  }) : super(key: key);

  final Vector value;

  @override
  Widget build(BuildContext context) {
    return AppIcon(value);
  }
}

class _TextStyle extends StatelessWidget {
  const _TextStyle(this.value,{
    Key? key,
  }) : super(key: key);

  final TextStyle value;

  @override
  Widget build(BuildContext context) {
    return Text('Hello world!', style: value);
  }
}

class _Double extends StatelessWidget {
  const _Double(this.value,{
    Key? key,
  }) : super(key: key);

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text('$value');
  }
}

class _Size extends StatelessWidget {
  const _Size(this.value,{
    Key? key,
  }) : super(key: key);

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text('$value');
  }
}

class _Breakpoint extends StatelessWidget {
  const _Breakpoint(this.value,{
    Key? key,
  }) : super(key: key);

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text('$value');
  }
}

class _EdgeInsets extends StatelessWidget {
  const _EdgeInsets(this.value,{
    Key? key,
  }) : super(key: key);

  final EdgeInsets value;

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(2),
            ),
            padding: value,
            child:  Container(
            width: 32, 
            height: 32, 
            decoration: BoxDecoration(
                color: const Color(0xFF777777),
                borderRadius: BorderRadius.circular(2),
            ),
        ),
    );
  }
}

class _Color extends StatelessWidget {
  const _Color(this.value,{
    Key? key,
  }) : super(key: key);

  final Color value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: value,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: const Color(0x22000000),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}

class _Gradient extends StatelessWidget {
  const _Gradient(this.value,{
    Key? key,
  }) : super(key: key);

  final Gradient value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        gradient: value,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: const Color(0x22000000),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}
