// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:back_office/nav_menu.dart';
import 'package:route_hierarchical/client.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

ButtonElement inButton;
ButtonElement userButton;

var token = "";
var authUrl = "http://localhost:8080/auth";
var usersUrl = "http://localhost:8080/admin/user";
String client;
String password;


void main() {
  initNavMenu();
  inButton = querySelector('#inButton');
  inButton.onClick.listen(login);

  userButton = querySelector('#userButton');
  userButton.onClick.listen(getUsers);

  // Webapps need routing to listen for changes to the URL.
  var router = new Router();
  router.root
    ..addRoute(name: 'about', path: '/about', enter: showAbout)
    ..addRoute(name: 'home', defaultRoute: true, path: '/', enter: showHome);
  router.listen();
}

void showAbout(RouteEvent e) {
  // Extremely simple and non-scalable way to show different views.
  querySelector('#home').style.display = 'none';
  querySelector('#about').style.display = '';
}

void showHome(RouteEvent e) {
  querySelector('#home').style.display = '';
  querySelector('#about').style.display = 'none';
}

Function login(Event e) {

  client = querySelector("#name").value;
  password = querySelector("#pass").value;
  
 var data = {
   'email': client,
   'password': password
 };

 HttpRequest.postFormData(authUrl, data).then((HttpRequest req) {
   print('Request complete ${req.response}');

   Map data = JSON.decode(req.response);

   print('apiId: ${data["apiId"]}');
   print('apiSecret ${data["apiSecret"]}');


   token = window.btoa("${data["apiId"]}:${data["apiSecret"]}");
   print(token);
   setUserSession();

 });
}

void showButtonsForUser(){
  querySelector('#userButton').style.display = '';
}

void setUserSession(){
    querySelector('#home_login').style.display = 'none';
    querySelector('#home_welcome').style.display = '';
    querySelector('#default_about_info').style.display = 'none';
    showButtonsForUser();
}

void draw(String name) {
  querySelector('#resp').text = name;
}

void showUsers(Map users){
  var user;
  for(user in users) {
    //querySelector('#resp').text = user;
  }
}


void getUsers(Event e) {
  
  var basic = "Basic " + token;
  Map header =  {'Authorization': basic};
  
  HttpRequest.request(usersUrl, requestHeaders : header).then((HttpRequest req) {

     //Map data = JSON.decode(req.response);

     draw(req.response);

   });

}
