import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPage extends StatefulWidget {
  const RazorPayPage({Key? key}) : super(key: key);
  @override
  _RazorPayPageState createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  late Razorpay _razorPay;
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount)async{
    amount = amount * 100;
    var options = {
      'key' : 'rzp_test_V2EBMlFkPLhZ1i',
      'amount' : amount,
      'name' : 'ezPay',
      'prefill' : {'contact' : '123456789', 'email': 'test@gmail.com'},
      'external' : {
        'wallets' : ['paytm']
      }
    };
    try{
      _razorPay.open(options);
    }catch(e){
      debugPrint('Error : e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(
        msg: "Payment Successful"
            +response.paymentId!,
        toastLength: Toast.LENGTH_SHORT,
    );
  }

  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(
      msg: "Payment Fail"
          +response.message!,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(
      msg: "External Wallet"
          +response.walletName!,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  void dispose(){
    super.dispose();
    _razorPay.clear();
  }
  @override
  void initState(){
    super.initState();
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),
            ClipRRect(
              borderRadius: BorderRadius.circular(200.0),
              child: Image.asset('assets/Image/ezPaylogo.png',
                height: 100,
                width: 300,
              ),
            ),
            SizedBox(height: 10,),
            Text("Welcome to EzPay",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),textAlign: TextAlign.center,
            ),
            SizedBox(height: 30,),
            Padding(padding: EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter Amount to be Paid',
                  labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15)
                ),
                controller: amtController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Please Enter Amount to be paid';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              if(amtController.text.toString().isNotEmpty){
                setState(() {
                  int amount = int.parse(amtController.text.toString());
                  openCheckout(amount);
                });
              }
            }, child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Make Payment'),
            ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          ]
        ),
      ),
    );
  }
}