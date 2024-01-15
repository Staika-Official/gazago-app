import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaza_go/platform/helpers/security_helper.dart';
import 'package:solana/base58.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_web3/solana_web3.dart';

void main() {

  test('test encode', () {
    int i = 0;
    while (i < 1000) {
      print('---------------------------------------------------------');
      final wallet = Keypair.generateSync();
      // String? email = HiveStore.loadString(key: HiveKey.email.name);
      String email = 'zicnet004@gmail.com';
      String testWalletPassword = '!!qhd0328';
      // String publicKey = wallet.publicKey.toBase58();
      // 암호화된 시크릿키
      String encryptSecretKey = encrypt(base58.encode(wallet.secretKey), email, testWalletPassword);

      print('encryptSecretKey : $encryptSecretKey');
      // 지갑 생성 완료
      String testEmail = 'zicnet004@gmail.com';
      // 82mt6rd86r@privaterelay.appleid.com wfNI5FyPy45L4e++c8KHxMV+fLAVB+2Id1a+MsGgZz0K3DGED1m6+5OzL1ffyo1DHWBWpsUdxQqAhdIIwHRYZyzXfl8+rWbzqxNUyai1BzVw1trWz/7RaRSWyruHdQ9i
      // zicnet004@gmail.com LTYYb5Fl7tzSW+8td1FUDdd2VVhD6ZuSY8N1YEWQcRL/e/Kq+zL2Fs9uZ4LEAqsF2pa+RyCXB6GJRpoDHnzhoxrwg9IaUS7AQ2MHAz1p4mrUY0dbd67RaRx9kCMyj8KE
      // String accountSecretkey = 'LTYYb5Fl7tzSW+8td1FUDdd2VVhD6ZuSY8N1YEWQcRL/e/Kq+zL2Fs9uZ4LEAqsF2pa+RyCXB6GJRpoDHnzhoxrwg9IaUS7AQ2MHAz1p4mrUY0dbd67RaRx9kCMyj8KE';

      String? decryptPrivateKey = decrypt(encryptSecretKey, testEmail, testWalletPassword);
      print('decryptPrivateKey: $decryptPrivateKey');
      print('---------------------------------------------------------');
      expect(decryptPrivateKey!.length, greaterThanOrEqualTo(40));
      i++;
    }
  });

}
