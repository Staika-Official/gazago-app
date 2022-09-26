class LinearProgressMixin {
  double calculateProgress(progress) {
    return progress.round() / 100;
  }
}
