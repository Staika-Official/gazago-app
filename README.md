# app-step

앱 생산성을 높이기 위한 보일러플레이트 프로젝트

## 참고사항
1. 파일명은 스네이트케이스로 생성할 것.
2. 안드로이드 스튜디오에서 "Flutter" => "Format on save" 설정 활성화.
3. 되도록 위젯, 객체등의 , 를 붙여서 포맷팅 동일하게 처리되로록 작성할 것.

#### debug signing key값을 구하는 방법

```shell
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

## model 자동생성 명령어
모델을 정의한 다음 아래 명령어를 실행하여 from/toJson기능을 자동으로 생성하도록 한다.

```shell
flutter pub run build_runner build --delete-conflicting-outputs 
```

## 프로젝트 빌드 옵션
대괄호 중 하나의 옵션을 선택 맨 마지막의 옵션은 입력하지 않으면 --release가 디폴트값이다.

### Android

```bash
flutter build [apk | appbundle] --flavor [dev | prod] [--debug | --release(default) | --profile] -t lib/main_[dev/stage/prod].dart
```

### iOS
--export-method 옵션을 넣지 않으면 --export-method app-store가 기본값이다.

```bash
flutter build ipa --flavor [dev | prod] --export-method [ad-hoc | app-store(default) | development] -t lib/main_[dev/stage/prod].dart [--debug | --release(default) | --profile]
```

### 디자인 토큰 설치 및 빌드

```bash
npm install -g style-dictionary-figma-flutter
style-dictionary-figma-flutter
```


### 스테이지 러닝 명령어
```bash
fvm flutter run -d <device> --flavor stage -t lib/main_stage.dart
```