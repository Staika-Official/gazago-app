import 'flavors.dart';
import 'main.dart' as base;

void main() {
  F.appFlavor = Flavor.stage;
  base.main();
}
