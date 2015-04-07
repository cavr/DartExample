// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:back_office/nav_menu.dart';
import 'package:route_hierarchical/client.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

ButtonElement inButton;
ButtonElement userButton;

var request;
var requestDos;
var serverResponse;
var tokenid = "";

void main() {
  initNavMenu();
  inButton = querySelector('#inButton');
  inButton.onClick.listen(getResponse);

  userButton = querySelector('#userButton');
  userButton.onClick.listen(getUsers);

  // Webapps need routing to listen for changes to the URL.
  var router = new Router();
  router.root
    ..addRoute(name: 'about', path: '/about', enter: showAbout)
    ..addRoute(name: 'send', path: '/in', enter: showHello)
    ..addRoute(name: 'home', defaultRoute: true, path: '/', enter: showHome);
  router.listen();
}

void showAbout(RouteEvent e) {
  // Extremely simple and non-scalable way to show different views.
  querySelector('#home').style.display = 'none';
  querySelector('#about').style.display = '';
}

void showHello(RouteEvent e) {
  // Extremely simple and non-scalable way to show different views.
  querySelector('#home').style.display = 'none';
  querySelector('#about').style.display = '';
}

void showHome(RouteEvent e) {
  querySelector('#home').style.display = '';
  querySelector('#about').style.display = 'none';
}

void getResponse(Event e) {
  var url = "http://localhost:8080/auth?email="+querySelector("#name").value+"&password="+querySelector("#pass").value;

  request = new HttpRequest();
  request.onReadyStateChange.listen(onData);
  request.open('POST', url);
  request.send();
  print(request.responseText);
}

void showButtonsForUser(){
  
  querySelector('#userButton').style.display = '';
  
}

void onData(_) {
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    Map parsedMap = JSON.decode(request.responseText);
    // Data saved OK.
    serverResponse = 'Server Sez: ' + request.responseText;
    var bytes = UTF8.encode(parsedMap["apiId"] + ':' + parsedMap["apiSecret"]);
    tokenid = CryptoUtils.bytesToBase64(bytes);
    //var base64= btoa(parsedMap["apiId"] + ':' + parsedMap["apiSecret"]);
    showButtonsForUser();
    print("T " + tokenid);
    querySelector('#home_login').style.display = 'none';
    querySelector('#home_welcome').style.display = '';
  } else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    // Status is 0...most likely the server isn't running.
    serverResponse = 'No server';
  }
}

void userListener(_) {
  if (requestDos.readyState == HttpRequest.DONE && requestDos.status == 200) {
    // Data saved OK.
    serverResponse = 'Server Sez: ' + requestDos.responseText;

    //print(requestDos.responseText);
  } else if (requestDos.readyState == HttpRequest.DONE && requestDos.status == 0) {
    // Status is 0...most likely the server isn't running.
    serverResponse = 'No server';
  }
  //Map parsedUsers = JSON.decode(requestDos.responseText);
  //print("MAP "+parsedUsers[""]);
  //showUsers(parsedUsers);
  
  response(requestDos.responseText);
}

void response(String name) {
  querySelector('#resp').text = name;
}

void showUsers(Map users){
  var user;
  for(user in users) {
    //querySelector('#resp').text = user;
  }
}


void getUsers(Event e) {
  var url = "http://localhost:8080/admin/user";

  var basic = "Basic " + tokenid;
  requestDos = new HttpRequest();
  requestDos.onReadyStateChange.listen(userListener);
  requestDos.open('GET', url);
  requestDos.setRequestHeader('Authorization', basic);
  requestDos.send();  
}
