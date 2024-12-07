import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:grpc_mobile/account.dart';
import 'package:grpc_mobile/generated/compte.pbgrpc.dart';

class AccountService {
  late CompteServiceClient _client;

  AccountService() {
    final channel = ClientChannel(
      '10.0.2.2',
      port: 9090,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    _client = CompteServiceClient(channel);
  }

  Future<List<Account>> getAllAccounts() async {
    try {
      final response = await _client.allComptes(GetAllComptesRequest());
      return response.comptes.map((c) => Account.fromProto(c)).toList();
    } catch (e) {
      print('Error fetching accounts: $e');
      rethrow;
    }
  }

  Future<Account> addAccount({required double solde, required String type}) async {
    try {
      final response = await _client.saveCompte(
        SaveCompteRequest(
          compte: CompteRequest(
            solde: solde,
            type: type == 'COURANT' ? TypeCompte.COURANT : TypeCompte.EPARGNE,
            dateCreation: DateTime.now().toIso8601String(),
          ),
        ),
      );
      return Account.fromProto(response.compte);
    } catch (e) {
      print('Error adding account: $e');
      rethrow;
    }
  }

  Future<Account?> getAccountById(int id) async {
    try {
      final response = await _client.compteById(GetCompteByIdRequest(id: id));
      return Account.fromProto(response.compte);
    } catch (e) {
      print('Error fetching account by ID: $e');
      return null;
    }
  }

  Future<void> deleteAccount(int id) async {
    try {
      await _client.deleteCompte(DeleteCompteRequest(id: id));
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  Future<Account> updateAccount(
      {required int id, required double solde, required String type}) async {
    try {
      final response = await _client.updateCompte(
        UpdateCompteRequest(
          id: id,
          compte: CompteRequest(
            solde: solde,
            type: type == 'COURANT' ? TypeCompte.COURANT : TypeCompte.EPARGNE,
            dateCreation: DateTime.now().toIso8601String(),
          ),
        ),
      );
      return Account.fromProto(response.compte);
    } catch (e) {
      print('Error updating account: $e');
      rethrow;
    }
  }
}
