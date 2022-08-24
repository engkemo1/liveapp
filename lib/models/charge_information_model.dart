class ChargeInformationModel {
  String? status;
  Data? data;
  String? msg;


  ChargeInformationModel({this.status, this.data, this.msg, });

  ChargeInformationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;

    return data;
  }
}

class Data {
  dynamic currentShiftSalaryTotal;
  dynamic currentShiftSalaryRemaining;
  dynamic currentShiftTotalTransferred;
  List<Transactions>? transactions;

  Data(
      {this.currentShiftSalaryTotal,
        this.currentShiftSalaryRemaining,
        this.currentShiftTotalTransferred,
        this.transactions});

  Data.fromJson(Map<String, dynamic> json) {
    currentShiftSalaryTotal = json['current_shift_salary_total'];
    currentShiftSalaryRemaining = json['current_shift_salary_remaining'];
    currentShiftTotalTransferred = json['current_shift_total_transferred'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_shift_salary_total'] = this.currentShiftSalaryTotal;
    data['current_shift_salary_remaining'] = this.currentShiftSalaryRemaining;
    data['current_shift_total_transferred'] = this.currentShiftTotalTransferred;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Transactions {
  String? to_id;
  String? to_name;
  String? time;
  dynamic coins;
  dynamic usd;

  Transactions({this.coins,this.time,this.to_id,this.to_name,this.usd});

  Transactions.fromJson(Map<String, dynamic> json) {
    to_id = json['to_id'];
    to_name=json['to_name'];
    time=json['time'];
    coins=json['coins'];
    usd=json['usd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usd'] = this.usd;
    data['coins'] = this.coins;
    data['time'] = this.time;
    data['to_id'] = this.to_id;
    data['to_name'] = this.to_name;

    return data;
  }
}