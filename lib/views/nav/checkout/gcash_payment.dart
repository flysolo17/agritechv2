import 'dart:io';
import 'dart:typed_data';

import 'package:agritechv2/blocs/transactions/transactions_bloc.dart';

import 'package:agritechv2/models/transaction/PaymentMethod.dart';
import 'package:agritechv2/repository/gcash-repository.dart';

import 'package:agritechv2/repository/transaction_repository.dart';
import 'package:agritechv2/utils/Constants.dart';
import 'package:dio/dio.dart';

import 'package:external_app_launcher/external_app_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/payment/QrCodes.dart';
import '../../../styles/color_styles.dart';
import 'package:flutter/material.dart';

import '../../custom widgets/button.dart';

class GcashPaymentMethod extends StatelessWidget {
  final String transactionID;
  final Payment payment;
  final String customer;

  const GcashPaymentMethod({
    super.key,
    required this.transactionID,
    required this.customer,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QRCodes?>(
      stream: GcashRepository().getDefaultPaymentMethod(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Gcash Payment"),
              backgroundColor: ColorStyle.brandRed,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          final qrCodes = snapshot.data!;

          return GcashPayment(
              transactionID: transactionID,
              customer: customer,
              payment: payment,
              qrCodes: qrCodes);
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Gcash Payment"),
              backgroundColor: ColorStyle.brandRed,
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No default payment method available.'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Button(
                      onTap: () async {
                        context.pop();
                      },
                      buttonWidth: double.infinity,
                      buttonText: "Back",
                      buttonColor: ColorStyle.brandRed,
                      borderColor: ColorStyle.blackColor,
                      textColor: ColorStyle.whiteColor,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class GcashPayment extends StatefulWidget {
  final String transactionID;
  final Payment payment;
  final String customer;
  final QRCodes qrCodes;
  const GcashPayment(
      {super.key,
      required this.transactionID,
      required this.customer,
      required this.payment,
      required this.qrCodes});

  @override
  State<GcashPayment> createState() => _GcashPaymentState();
}

class _GcashPaymentState extends State<GcashPayment> {
  final String _receipt = 'lib/assets/images/receipt.png';
  File? _selectedFile;

  _saveNetworkImage(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "agritech-qr");
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Successfully Downloaded")));
  }

  @override
  Widget build(BuildContext context) {
    final flutterMediaDownloaderPlugin = MediaDownload();
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        context.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gcash Payment"),
          backgroundColor: ColorStyle.brandRed,
        ),
        body: BlocProvider(
          create: (context) => TransactionsBloc(
              transactionRepostory: context.read<TransactionRepostory>()),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "To Procceed with Gcash Payment please download our Agritech Gcash Code below.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      widget.qrCodes.qrCode,
                      height: 200,
                      width: 250,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorStyle.brandRed),
                        onPressed: () async {
                          _saveNetworkImage(widget.qrCodes.qrCode);
                        },
                        child: const Text(
                          'Download QR Code',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Next is OPEN GCASH application and pay for the ammount of:",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      formatPrice(widget.payment.amount).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Using the QR Code you just Downloaded",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "The amount you paid serve as your full payment",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorStyle.brandRed),
                      onPressed: () async {
                        var openAppResult = await LaunchApp.openApp(
                          androidPackageName: 'com.globe.gcash.android',
                          appStoreLink:
                              'https://play.google.com/store/apps/details?id=com.globe.gcash.android&pcampaignid=web_share',
                          openStore: false,
                        );

                        print(
                            'openAppResult => $openAppResult ${openAppResult.runtimeType}');
                      },
                      child: const Text(
                        'Open GCash',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "After that DOWNLOAD or SCREENSHOT the reference number of your payment from gcash and upload it here:",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _selectedFile != null
                        ? Image.file(_selectedFile!)
                        : Image.asset(_receipt),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorStyle.brandRed),
                      onPressed: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            File file = File(image.path);
                            _selectedFile = file;
                          });
                        } else {
                          print('upload page : error picking image');
                        }
                      },
                      child: const Text(
                        'Upload Receipt',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Once Everything looks good you can now pay your order.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  if (_selectedFile != null)
                    ConfirmPayment(
                        file: _selectedFile!,
                        transactionID: widget.transactionID,
                        payment: widget.payment,
                        customerName: widget.customer)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmPayment extends StatefulWidget {
  final File file;
  final String transactionID;
  final Payment payment;
  final String customerName;
  const ConfirmPayment(
      {super.key,
      required this.file,
      required this.transactionID,
      required this.payment,
      required this.customerName});

  @override
  State<ConfirmPayment> createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<TransactionsBloc, TransactionsState>(
        listener: (context, state) {
          if (state is TransactionsSuccessState<String>) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.data)));
            context.pop();
            context.pop();
          }
          if (state is TransactionsFailedState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return state is TransactionsLoadingState
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.brandRed),
                  onPressed: () async {
                    context.read<TransactionsBloc>().add(AddGcashPayment(
                        widget.file,
                        widget.customerName,
                        widget.transactionID,
                        widget.payment));
                  },
                  child: const Text(
                    'Confirm Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                );
        },
      ),
    );
  }
}
