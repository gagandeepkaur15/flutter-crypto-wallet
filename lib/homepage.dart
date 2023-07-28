import 'package:flutter/material.dart';
import 'package:flutter_wallet/qr.dart';
import 'package:flutter_wallet/transaction_model.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'wallet_services.dart';
import 'package:realm/realm.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _address = TextEditingController();
  TextEditingController _amount = TextEditingController();

  late LoginRealm loginProvider;
  double _balance = 0.00;

  @override
  void initState() {
    super.initState();
    // Initialize the WalletServices provider and call the 'intialize' method
    final walletProvider = Provider.of<WalletServices>(context, listen: false);
    loginProvider = Provider.of<LoginRealm>(context, listen: false);
    final currentUser = loginProvider.currentUser;
    if (currentUser != null) {
      walletProvider.intialize(currentUser);
    }
    _fetchBalance(walletProvider);
  }

  @override
  void dispose() {
    _address.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _fetchBalance(WalletServices walletProvider) async {
    if (walletProvider.myCredentials != null) {
      double balance =
          await walletProvider.getBalance(walletProvider.myCredentials!);
      setState(() {
        _balance = balance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletServices>(context);
    double balance = context.watch<WalletServices>().balance;
    context.read<WalletServices>().getTransactions();
    Transactions? listTransaction = context.watch<WalletServices>().list;

    return Consumer<WalletServices>(builder: (context, walletProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Wallet'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(
                      text: walletProvider.myCredentials!.address.toString()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(
                      Icons.copy,
                      size: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                walletProvider.myCredentials!.address.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 90,
              ),
              const Text(
                'Amount',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                '$_balance',
                // balance == 0.00 ? "0.00" : balance.toString().substring(0, 5),
                style: const TextStyle(fontSize: 30),
              ),
              OutlinedButton(
                  onPressed: () async {
                    await loginProvider.getCurrentUser();
                    User? currentUser = loginProvider.currentUser;
                    if (currentUser != null) {
                      walletProvider.createWallet(currentUser).then((value) =>
                          print(
                              ":::::::::::::::::::::::::::::::::::::::::::::::Wallet created"));
                    }
                  },
                  child: const Text("Create Wallet")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        sendBottomSheet(context);
                      },
                      child: const Text('Send')),
                  ElevatedButton(
                      onPressed: () {
                        receiveBottomSheet(context);
                      },
                      child: const Text('Receive')),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> sendBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 800,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 190,
                  child: TextField(
                    controller: _address,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter address',
                      // isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 190,
                  child: TextField(
                    controller: _amount,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter amount',
                      // isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      final walletProvider =
                          Provider.of<WalletServices>(context, listen: false);
                      String toAddress = _address.text;
                      String amount = _amount.text;

                      walletProvider.sendTransection(
                          toAddress, amount, walletProvider.myCredentials!);

                      walletProvider
                          .sendTransection(
                              toAddress, amount, walletProvider.myCredentials!)
                          .then((value) {
                        print(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Transaction Successful')));
                        Navigator.pop(context);
                        setState(() {
                          _amount.clear();
                          _address.clear();
                        });
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error sending transaction: $error"),
                        ));
                        Navigator.pop(context);
                        setState(() {
                          _amount.clear();
                          _address.clear();
                        });
                      });
                    },
                    child: const Text("Send"))
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> receiveBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return const QRGenerate();
    },
  );
}
