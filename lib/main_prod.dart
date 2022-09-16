import 'flavors.dart';
import 'main.dart' as _main;

void main() {
  F.appFlavor = Flavor.prod;
  _main.main();
}
