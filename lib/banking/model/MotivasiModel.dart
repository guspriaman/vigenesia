class MotivasiModel {
  String? id;
  String? isiMotivasi;
  String? iduser;
  String? tanggalInput;
  String? tanggalUpdate;

  MotivasiModel(
      {this.id,
      this.isiMotivasi,
      this.iduser,
      this.tanggalInput,
      this.tanggalUpdate});

  MotivasiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isiMotivasi = json['isi_motivasi'];
    iduser = json['iduser'];
    tanggalInput = json['tanggal_input'];
    tanggalUpdate = json['tanggal_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isi_motivasi'] = this.isiMotivasi;
    data['iduser'] = this.iduser;
    data['tanggal_input'] = this.tanggalInput;
    data['tanggal_update'] = this.tanggalUpdate;
    return data;
  }
}
