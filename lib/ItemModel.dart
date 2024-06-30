class ItemModel{
  String amount;
  String type;
  String note;
  String date;
  String id;

  ItemModel({required this.amount,required this.date,required this.id,required this.note,required this.type});


  static ItemModel fromSnapshot(Map<String, dynamic> snapshot){
    return ItemModel(
      amount: snapshot['amount'],
      date: snapshot['date'],
      id: snapshot['id'],
      note: snapshot['note'],
      type: snapshot['type'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "amount": amount,
      "date": date,
      "id": id,
      "note": note,
      "type": type,
    };
  }
}