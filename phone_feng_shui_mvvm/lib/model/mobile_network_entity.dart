
class MobileNetworkEntity {
  final String id;
  final String name;
  final String logo;
  final List<String> detector;
  MobileNetworkEntity(this.id, this.name, this.logo, this.detector);

  MobileNetworkEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        logo = json['logo'],
        detector = json['detector'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'logo': logo,
    'detector': detector
  };

  @override
  String toString() {
    return 'MOBILE NETWORK : {id : ${id} - name : ${name} - logo - ${logo} - detector : ${detector}';
  }
}