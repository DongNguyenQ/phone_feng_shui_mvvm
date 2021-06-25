class MobileNetworkEntity {
  final String id;
  final String name;
  final String logo;
  final List<String> detector;
  MobileNetworkEntity(this.id, this.name, this.logo, this.detector);

  @override
  String toString() {
    return 'MOBILE NETWORK : {id : ${id} - name : ${name} - logo - ${logo} - detector : ${detector}';
  }
}