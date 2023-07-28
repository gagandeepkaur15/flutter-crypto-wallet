import 'package:flutter/material.dart';
import 'package:flutter_wallet/qr.dart';
import 'package:flutter_wallet/realm_model.dart';
import 'package:flutter_wallet/transaction_list.dart';
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
    // final walletProvider = Provider.of<WalletServices>(context);
    // double balance = context.watch<WalletServices>().balance;
    context.read<WalletServices>().getTransactions();
    MyCredentials? cred = context.watch<WalletServices>().myCredentials;
    Transactions? listTransaction = context.watch<WalletServices>().list;

    return Consumer<WalletServices>(builder: (context, walletProvider, _) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 13, 12, 15),
        appBar: AppBar(
          title: const Text('Wallet'),
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(225, 248, 86, 88),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(
                        text:
                            walletProvider.myCredentials!.address.toString()));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Address',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      Icon(
                        Icons.copy,
                        size: 15,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  walletProvider.myCredentials!.address,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(
                  height: 50,
                ),
                walletProvider.myCredentials!.address == ''
                    ? OutlinedButton(
                        onPressed: () async {
                          await loginProvider.getCurrentUser();
                          User? currentUser = loginProvider.currentUser;
                          if (currentUser != null) {
                            walletProvider.createWallet(currentUser).then(
                                  (value) => print(
                                      ":::::::::::::::::::::::::::::::::::::::::::::::Wallet created"),
                                );
                          }
                        },
                        child: const Text("Create Wallet"))
                    : Column(
                        children: [
                          const Text(
                            'Amount',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '$_balance',
                            // balance == 0.00 ? "0.00" : balance.toString().substring(0, 5),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        sendBottomSheet(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(225, 248, 86, 88),
                      ),
                      child: const Text('Send'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        receiveBottomSheet(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(225, 248, 86, 88),
                      ),
                      child: const Text('Receive'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (listTransaction == null) ...[
                        const Text("Null"),
                      ] else if (listTransaction.result!.isEmpty) ...[
                        const Text('No transections to show')
                      ] else
                        ...listTransaction.result!.map((element) {
                          return TList(data: element, address: cred!.address);
                        }).toList()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> sendBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.black,
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
                    style: const TextStyle(color: Colors.white),
                    controller: _address,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(225, 248, 86, 88),
                          ),
                        ),
                        labelText: 'Enter address',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(151, 255, 255, 255)),
                        // isDense: true,

                        contentPadding: const EdgeInsets.all(8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(
                                  225, 248, 86, 88)), //<-- SEE HERE
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(225, 248, 86, 88),
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 190,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _amount,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color.fromARGB(225, 248, 86, 88),
                        ),
                      ),
                      labelText: 'Enter amount',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(151, 255, 255, 255)),
                      // isDense: true,
                      contentPadding: const EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color.fromARGB(225, 248, 86, 88),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color.fromARGB(225, 248, 86, 88),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Transaction Successful')));
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(225, 248, 86, 88),
                  ),
                  child: const Text("Send"),
                )
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
    backgroundColor: Colors.black,
    builder: (BuildContext context) {
      return const QRGenerate();
    },
  );
}
