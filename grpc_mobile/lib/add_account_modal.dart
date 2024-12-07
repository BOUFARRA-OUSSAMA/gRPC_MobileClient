import 'package:flutter/material.dart';
import 'package:grpc_mobile/account.dart';
import 'account_service.dart';

class AddAccountModal extends StatefulWidget {
  final Function(Account) onAccountAdded;

  const AddAccountModal({super.key, required this.onAccountAdded});

  @override
  // ignore: library_private_types_in_public_api
  _AddAccountModalState createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  final _formKey = GlobalKey<FormState>();
  double _solde = 0.0;
  String _type = 'COURANT';

  final AccountService accountService = AccountService();

  Future<void> _saveAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final newAccount = await accountService.addAccount(
          solde: _solde,
          type: _type,
        );
        widget.onAccountAdded(newAccount);
        Navigator.pop(context);
      } catch (e) {
        print('Error adding account: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Account'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Balance (Solde)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Enter a valid balance';
                }
                return null;
              },
              onSaved: (value) {
                _solde = double.parse(value!);
              },
            ),
            DropdownButtonFormField<String>(
              value: _type,
              items: ['COURANT', 'EPARGNE']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Account Type'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAccount,
          child: Text('Save'),
        ),
      ],
    );
  }
}
