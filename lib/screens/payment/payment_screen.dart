import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/models/payment_methods.dart';
import 'package:mosques_donation_app/screens/paid/paid_screen.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/custom_card_button.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final Cart cart;

  const PaymentScreen({Key key, this.cart}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String response = '';
  String _loading = "Loading...";
  bool _isRetrieving = true;
  MyFatoorahPaymentMethods paymentMethods;

  @override
  void initState() {
    super.initState();

    MFSDK.init(
      'https://apitest.myfatoorah.com',
      'bearer rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',
    );

    setUpAppBarProperties();
    initiatePayment();
  }

  setUpAppBarProperties() {
    MFSDK.setUpAppBar(
        title: "MyFatoorah Payment",
        titleColor: Colors.white, // Color(0xFFFFFFFF)
        backgroundColor: Colors.black, // Color(0xFF000000)
        isShowAppBar: true);
  }

  void initiatePayment() {
    var request = new MFInitiatePaymentRequest(
      widget.cart.total,
      MFCurrencyISO.KUWAIT_KWD,
    );

    MFSDK.initiatePayment(
        request,
        MFAPILanguage.EN,
        (MFResult<MFInitiatePaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toJson());
                    response = result.response.toJson().toString();
                    paymentMethods = MyFatoorahPaymentMethods.fromJson(
                        result.response.toJson());
                    // paymentMethods = pa_responsersed
                    //     .map<PaymentMethods>(
                    //         (json) => PaymentMethods.fromJson(json))
                    //     .toList();
                    print(paymentMethods);
                    _isRetrieving = false;
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    response = result.error.message;
                    print(result.error.message);
                  })
                }
            });

    setState(() {
      response = _loading;
    });
  }

  void sendPayment(String donorName, double amount) {
    var request = MFSendPaymentRequest(
        invoiceValue: 0.100,
        customerName: "Customer name",
        notificationOption: MFNotificationOption.LINK);

    MFSDK.sendPayment(
        MFAPILanguage.EN,
        request,
        (MFResult<MFSendPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toJson());
                    response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    response = result.error.message;
                  })
                }
            });

    setState(() {
      response = _loading;
    });
  }

  void executeRegularPayment({int paymentMethodId, double amount}) {
    // The value "1" is the paymentMethodId of KNET payment method.
    // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods

    var request = new MFExecutePaymentRequest(
      paymentMethodId.toString(),
      amount.toString(),
    );

    MFSDK.executePayment(
        context,
        request,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(invoiceId);
                    // print(result.response.toJson());
                    // response = result.response.toJson().toString();
                    // getPaymentStatus(invoiceId);
                    Map<String, dynamic> response = result.response.toJson();
                    // print(response);
                    print('InvoiceStatus: ${response["InvoiceStatus"]}');
                    if (response["InvoiceStatus"] == "Paid") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaidScreen(),
                        ),
                      );
                    }
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error.toJson());
                    response = result.error.message;
                  })
                }
            });

    setState(() {
      response = _loading;
    });
  }

  void executeDirectPaymentWithRecurring() {
    // The value "2" is the paymentMethodId of Visa/Master payment method.
    // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
    String paymentMethod = "2";

    var request = new MFExecutePaymentRequest(paymentMethod, "100");

    var mfCardInfo = new MFCardInfo(
        cardNumber: "2223000000000007",
        expiryMonth: "05",
        expiryYear: "21",
        securityCode: "100",
        cardHolderName: "Set Name",
        bypass3DS: true,
        saveToken: true);

    int intervalDays = 5;

    MFSDK.executeDirectPaymentWithRecurring(
        context,
        request,
        mfCardInfo,
        intervalDays,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFDirectPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(invoiceId);
                    // print(result.response.toJson());
                    Map<String, dynamic> response = result.response.toJson();
                    // print(response);
                    print('InvoiceStatus: ${response["InvoiceStatus"]}');
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error.toJson());
                    response = result.error.message;
                  })
                }
            });

    setState(() {
      response = _loading;
    });
  }

  /*
    Payment Enquiry
   */
  void getPaymentStatus(String invoiceId) {
    var request = MFPaymentStatusRequest(invoiceId: invoiceId);

    MFSDK.getPaymentStatus(
        MFAPILanguage.EN,
        request,
        (MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toJson());
                    response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    response = result.error.message;
                  })
                }
            });

    setState(() {
      response = _loading;
    });
  }

  /*
    Cancel Token
   */
  void cancelToken() {
    MFSDK.cancelToken(
        "Put your token here",
        MFAPILanguage.EN,
        (MFResult<bool> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toString());
                    response = result.response.toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    response = result.error.message;
                  })
                }
            });

    setState(() {
      response = _loading;
    });
  }

  /*
    Cancel Recurring Payment
   */
  void cancelRecurringPayment() {
    MFSDK.cancelRecurringPayment(
        "Put RecurringId here",
        MFAPILanguage.EN,
        (MFResult<bool> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toString());
                    response = result.response.toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    response = result.error.message;
                  })
                }
            });

    setState(() {
      response = _loading;
    });
  }

  void executeDirectPayment() {
    // The value "2" is the paymentMethodId of Visa/Master payment method.
    // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
    String paymentMethod = "2";

    var request = new MFExecutePaymentRequest(paymentMethod, "100");

//    var mfCardInfo = new MFCardInfo(cardToken: "Put your token here");

    var mfCardInfo = new MFCardInfo(
        cardNumber: "2223000000000007",
        expiryMonth: "05",
        expiryYear: "21",
        securityCode: "100",
        cardHolderName: "Set Name",
        bypass3DS: true,
        saveToken: true);

    MFSDK.executeDirectPayment(
        context,
        request,
        mfCardInfo,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFDirectPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(invoiceId);
                    print(result.response.toJson());
                    response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error.toJson());
                    response = result.error.message;
                  })
                }
            });

    setState(() {
      response = _loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(trans(context, 'payment_method'))),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trans(context, 'select_your_payment_method'),
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4.2,
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 3),
              Expanded(
                child: _isRetrieving
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: SizeConfig.blockSizeVertical * 5,
                        ),
                        shrinkWrap: true,
                        itemCount: paymentMethods.paymentMethods.length,
                        itemBuilder: (ctx, i) => CustomCardButton(
                          height: SizeConfig.blockSizeVertical * 10,
                          text:
                              paymentMethods.paymentMethods[i].paymentMethodEn,
                          onPressed: () => executeRegularPayment(
                            paymentMethodId: paymentMethods
                                .paymentMethods[i].paymentMethodId,
                            amount: widget.cart.total,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        )
        // SafeArea(
        //   child: Center(
        //     child: Column(children: [
        //       IntrinsicWidth(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           children: [
        //             Padding(
        //               padding: EdgeInsets.all(5.0),
        //             ),
        //             RaisedButton(
        //               child: Text('Send Payment'),
        //               onPressed: sendPayment,
        //             ),
        //             RaisedButton(
        //               child: Text('Initiate Payment'),
        //               onPressed: initiatePayment,
        //             ),
        //             RaisedButton(
        //               child: Text('Execute Regular Payment'),
        //               onPressed: executeRegularPayment,
        //             ),
        //             RaisedButton(
        //               child: Text('Execute Direct Payment'),
        //               onPressed: executeDirectPayment,
        //             ),
        //             RaisedButton(
        //               child: Text('Execute Direct Payment with Recurring'),
        //               onPressed: executeDirectPaymentWithRecurring,
        //             ),
        //             RaisedButton(
        //               child: Text('Cancel Recurring Payment'),
        //               onPressed: cancelRecurringPayment,
        //             ),
        //             RaisedButton(
        //               child: Text('Cancel Token'),
        //               onPressed: cancelToken,
        //             ),
        //             RaisedButton(
        //               child: Text('Get Payment Status'),
        //               onPressed: getPaymentStatus,
        //             ),
        //             Padding(
        //               padding: EdgeInsets.all(8.0),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Container(
        //         child: Expanded(
        //           flex: 1,
        //           child: SingleChildScrollView(
        //             child: Text(_response),
        //           ),
        //         ),
        //       ),
        //     ]),
        //   ),
        // ),
        );
  }
}
