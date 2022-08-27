import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'shared_preferences.dart';
//import 'dart:html';
class InAppWebPage extends StatefulWidget {
  const InAppWebPage({Key? key}) : super(key: key);

  @override
  State<InAppWebPage> createState() => _InAppWebPageState();
}

class _InAppWebPageState extends State<InAppWebPage> {
  late InAppWebViewController webView;
  double _progress=0;
  String link='';
  //var urlt = window.location.href;
  arrowBack()async{
    if(await webView.canGoBack())
      {
        await webView.goBack();
        //await webView.goTo(historyItem: historyItem)

      }
  }
  arrowForward()async{
    if(await webView.canGoForward())
    {
      await webView.goForward();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    link = UserSimplePreferences.getLink() ?? 'https://gogoanime.nl/';
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(await webView.canGoBack())
        {
          webView.goBack();
          return false;
        }
        else{
          return true;
        }
      },
      child: Scaffold(
        //resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.amber.withOpacity(0.8),
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => {arrowBack()},
                  color: Colors.black
              ),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_outlined),
                    onPressed: () => {arrowForward()},
                      color: Colors.black
                  ),
                ],
              ),
              const Expanded(
                child:  Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Center(child: Text('Addicted To Anime',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                ),
              )
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    webView.reload();
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                )
            ),
          ],
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(link)), //Change the domain here

              initialOptions: InAppWebViewGroupOptions(  //Keyboard access
                crossPlatform: InAppWebViewOptions(
                mediaPlaybackRequiresUserGesture: false,
                ),
                android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
                ),
                ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
                )
              ),

              onWebViewCreated: (InAppWebViewController controller){
                webView=controller;
              },
              onLoadStart: (controller,url) {
                setState(() async {
                  link=url.toString();
                  await UserSimplePreferences.setLink(link);
                  print("Url is: "+link);
                  // link=url.toString();
                  // print("Url is: "+link);
                });
              },
              onProgressChanged: (InAppWebViewController controller,int progress)
              {
                setState(() {
                  _progress= progress/100;
                });
              },
            ),
            _progress< 1 ? SizedBox(
              height: 3,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey.withOpacity(0.2),
              ),
            ) : const SizedBox()
          ],
        ),
      ),
    );
  }
}
