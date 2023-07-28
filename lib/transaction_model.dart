class Transactions {
  int? pageSize;
  int? page;
  String? cursor;
  List<Result>? result;

  Transactions({this.pageSize, this.page, this.cursor, this.result});

  Transactions.fromJson(Map<String, dynamic> json) {
    pageSize = json['page_size'];
    page = json['page'];
    cursor = json['cursor'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }
}

class Result {
  String? hash;
  String? nonce;
  String? transactionIndex;
  String? fromAddress;
  Null? fromAddressLabel;
  String? toAddress;
  String? toAddressLabel;
  String? value;
  String? gas;
  String? gasPrice;
  String? input;
  String? receiptCumulativeGasUsed;
  String? receiptGasUsed;
  Null? receiptContractAddress;
  Null? receiptRoot;
  String? receiptStatus;
  String? blockTimestamp;
  String? blockNumber;
  String? blockHash;
  List<int>? transferIndex;
  List<Logs>? logs;
  DecodedEvent? decodedCall;

  Result(
      {this.hash,
      this.nonce,
      this.transactionIndex,
      this.fromAddress,
      this.fromAddressLabel,
      this.toAddress,
      this.toAddressLabel,
      this.value,
      this.gas,
      this.gasPrice,
      this.input,
      this.receiptCumulativeGasUsed,
      this.receiptGasUsed,
      this.receiptContractAddress,
      this.receiptRoot,
      this.receiptStatus,
      this.blockTimestamp,
      this.blockNumber,
      this.blockHash,
      this.transferIndex,
      this.logs,
      this.decodedCall});

  Result.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    nonce = json['nonce'];
    transactionIndex = json['transaction_index'];
    fromAddress = json['from_address'];
    fromAddressLabel = json['from_address_label'];
    toAddress = json['to_address'];
    toAddressLabel = json['to_address_label'];
    value = json['value'];
    gas = json['gas'];
    gasPrice = json['gas_price'];
    input = json['input'];
    receiptCumulativeGasUsed = json['receipt_cumulative_gas_used'];
    receiptGasUsed = json['receipt_gas_used'];
    receiptContractAddress = json['receipt_contract_address'];
    receiptRoot = json['receipt_root'];
    receiptStatus = json['receipt_status'];
    blockTimestamp = json['block_timestamp'];
    blockNumber = json['block_number'];
    blockHash = json['block_hash'];
    transferIndex = json['transfer_index'].cast<int>();
    if (json['logs'] != null) {
      logs = <Logs>[];
      json['logs'].forEach((v) {
        logs!.add(new Logs.fromJson(v));
      });
    }
    decodedCall = json['decoded_call'] != null
        ? new DecodedEvent.fromJson(json['decoded_call'])
        : null;
  }
}

class Logs {
  String? logIndex;
  String? transactionHash;
  String? transactionIndex;
  String? address;
  String? data;
  String? topic0;
  String? topic1;
  String? topic2;
  Null? topic3;
  String? blockTimestamp;
  String? blockNumber;
  String? blockHash;
  List<int>? transferIndex;
  String? transactionValue;
  DecodedEvent? decodedEvent;

  Logs(
      {this.logIndex,
      this.transactionHash,
      this.transactionIndex,
      this.address,
      this.data,
      this.topic0,
      this.topic1,
      this.topic2,
      this.topic3,
      this.blockTimestamp,
      this.blockNumber,
      this.blockHash,
      this.transferIndex,
      this.transactionValue,
      this.decodedEvent});

  Logs.fromJson(Map<String, dynamic> json) {
    logIndex = json['log_index'];
    transactionHash = json['transaction_hash'];
    transactionIndex = json['transaction_index'];
    address = json['address'];
    data = json['data'];
    topic0 = json['topic0'];
    topic1 = json['topic1'];
    topic2 = json['topic2'];
    topic3 = json['topic3'];
    blockTimestamp = json['block_timestamp'];
    blockNumber = json['block_number'];
    blockHash = json['block_hash'];
    transferIndex = json['transfer_index'].cast<int>();
    transactionValue = json['transaction_value'];
    decodedEvent = json['decoded_event'] != null
        ? new DecodedEvent.fromJson(json['decoded_event'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['log_index'] = this.logIndex;
    data['transaction_hash'] = this.transactionHash;
    data['transaction_index'] = this.transactionIndex;
    data['address'] = this.address;
    data['data'] = this.data;
    data['topic0'] = this.topic0;
    data['topic1'] = this.topic1;
    data['topic2'] = this.topic2;
    data['topic3'] = this.topic3;
    data['block_timestamp'] = this.blockTimestamp;
    data['block_number'] = this.blockNumber;
    data['block_hash'] = this.blockHash;
    data['transfer_index'] = this.transferIndex;
    data['transaction_value'] = this.transactionValue;
    if (this.decodedEvent != null) {
      data['decoded_event'] = this.decodedEvent!.toJson();
    }
    return data;
  }
}

class DecodedEvent {
  String? signature;
  String? label;
  String? type;
  List<Params>? params;

  DecodedEvent({this.signature, this.label, this.type, this.params});

  DecodedEvent.fromJson(Map<String, dynamic> json) {
    signature = json['signature'];
    label = json['label'];
    type = json['type'];
    if (json['params'] != null) {
      params = <Params>[];
      json['params'].forEach((v) {
        params!.add(new Params.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['signature'] = this.signature;
    data['label'] = this.label;
    data['type'] = this.type;
    if (this.params != null) {
      data['params'] = this.params!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Params {
  String? name;
  String? value;
  String? type;

  Params({this.name, this.value, this.type});

  Params.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}
