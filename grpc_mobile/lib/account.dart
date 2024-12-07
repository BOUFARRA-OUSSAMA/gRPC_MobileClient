import 'package:grpc_mobile/generated/compte.pb.dart';

class Account {
  final int id;
  final double solde;
  final String type;
  final String dateCreation;

  Account({
    required this.id,
    required this.solde,
    required this.type,
    required this.dateCreation,
  });

  factory Account.fromProto(Compte proto) {
    return Account(
      id: proto.id,
      solde: proto.solde,
      type: proto.type == TypeCompte.COURANT ? 'COURANT' : 'EPARGNE',
      dateCreation: proto.dateCreation,
    );
  }
}
