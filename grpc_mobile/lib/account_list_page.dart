import 'package:flutter/material.dart';
import 'package:grpc_mobile/account.dart';
import 'package:grpc_mobile/add_account_modal.dart';
import 'account_service.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountListPageState createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  List<Account> accounts = [];
  final AccountService accountService = AccountService();

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    try {
      final fetchedAccounts = await accountService.getAllAccounts();
      setState(() {
        accounts = fetchedAccounts;
      });
    } catch (e) {
      print('Error fetching accounts: $e');
    }
  }

  void _showAddAccountModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AddAccountModal(
          onAccountAdded: (newAccount) {
            setState(() {
              accounts.add(newAccount);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts Manager'),
        centerTitle: true,
      ),
      body: accounts.isEmpty
          ? const Center(
              child: Text(
                'No accounts found. Add a new account!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        account.type[0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text('ID: ${account.id}'),
                    subtitle: Text(
                      'Type: ${account.type}\nBalance: \$${account.solde.toStringAsFixed(2)}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAccountModal,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
