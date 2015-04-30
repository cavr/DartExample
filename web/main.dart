// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:back_office/nav_menu.dart';
import 'package:route_hierarchical/client.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

ButtonElement inButton;
ButtonElement userButton;
ButtonElement prototypeMission;
ButtonElement prototypeMail;
ButtonElement loadUsers;
ButtonElement deleteUsers;
ButtonElement clonePrototype;
ButtonElement inviteUsers;
ButtonElement welcomeAll;
ButtonElement company;

var token = "";
var authUrl = "http://localhost:8080/auth";
var usersUrl = "http://localhost:8080/admin/user";
var missionUrl = "http://localhost:8080/prototype/mission/";
var mailUrl = "http://localhost:8080/prototype/mail/";
var deleteUsersUrl = "http://localhost:8080/prototype/delete-user/";
var loadUsersUrl = "http://localhost:8080/prototype/users/";
var clonePrototypeUrl = "http://localhost:8080/admin/clone-prototype/";
var inviteUsersUrl = "http://localhost:8080/admin/invite-all";
var welcomeAllUrl = "http://localhost:8080/admin/welcome-all";
var companyUrl = "http://localhost:8080/prototype/company/";
String client;
String password;


void main() {
  initNavMenu();
  
  inButton = querySelector('#inButton');
  inButton.onClick.listen(login);

  userButton = querySelector('#userButton');
  userButton.onClick.listen(getUsers);
  
  prototypeMission = querySelector('#prototypeMission');
  prototypeMission.onClick.listen(loadMission);
    
  prototypeMail = querySelector('#prototypeMail');
  prototypeMail.onClick.listen(loadMailTemplate);
    
  loadUsers = querySelector('#loadUsers');
  loadUsers.onClick.listen(uploadUsers);
    
  deleteUsers = querySelector('#deleteUsers');
  deleteUsers.onClick.listen(deleteUsersFromCsv);
    
  clonePrototype = querySelector("#clonePrototype");
  clonePrototype.onClick.listen(clonePrototypeIntoProgram);
    
  inviteUsers = querySelector("#inviteUsers");
  inviteUsers.onClick.listen(inviteUsersBack);
    
  welcomeAll = querySelector("#welcomeAll");
  welcomeAll.onClick.listen(wellComeAllBack);
  
  company = querySelector("#companyUpdate");
  company.onClick.listen(updateCompanyValues);
             
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
  querySelector("#prototypeMail").style.display='';
  querySelector("#prototypeMission").style.display='';
  querySelector("#programLoad").style.display='';
  querySelector("#loadUsers").style.display = '';
  querySelector("#deleteUsers").style.display = '';
  querySelector("#clonePrototype").style.display = '';
  querySelector("#prototypeId").style.display = '';
  querySelector("#inviteUsers").style.display = '';
  querySelector("#welcomeAll").style.display = '';
  querySelector("#inviteId").style.display = '';
  querySelector("#companyUpdate").style.display = '';
  querySelector("#companyId").style.display = '';
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

   }).catchError((error){
    
    print(error);
    
  });

}

void loadMission(Event e){
  
  var basic = "Basic " + token;
  Map header =  {'Authorization': basic};
  draw("Cargando misiones");
  HttpRequest.request(missionUrl+querySelector("#programLoad").value, requestHeaders : header).then((HttpRequest req) {

     //Map data = JSON.decode(req.response);

     draw(req.response);

   }).catchError((error){
    
    print(error);
    
  });     
  
}

void loadMailTemplate(Event e){  
    var basic = "Basic " + token;
    Map header =  {'Authorization': basic};
    draw("Cargando Correos");
    HttpRequest.request(mailUrl+querySelector("#programLoad").value, requestHeaders : header).then((HttpRequest req) {

       //Map data = JSON.decode(req.response);

       draw(req.response);

     }).catchError((error){
      
      print(error);
      
    });  
    
  }

void uploadUsers(Event e){   
  var basic = "Basic " + token;
     Map header =  {'Authorization': basic};
     draw("Cargando Usuarios");
     HttpRequest.request(loadUsersUrl+querySelector("#programLoad").value, requestHeaders : header).then((HttpRequest req) {

        //Map data = JSON.decode(req.response);

        draw(req.response);

      }).catchError((error){
       
       print(error);
       
     });  
     
}

void deleteUsersFromCsv(Event e){  
  var basic = "Basic " + token;
       Map header =  {'Authorization': basic};
       draw("Borrando Usuarios");
       HttpRequest.request(deleteUsersUrl+querySelector("#programLoad").value, requestHeaders : header).then((HttpRequest req) {

          //Map data = JSON.decode(req.response);

          draw(req.response);

        }).catchError((error){
         
         print(error);
         
       }); 
       
}       
       
void clonePrototypeIntoProgram(Event e){  
  var basic = "Basic " + token;
        Map header =  {'Authorization': basic};
        draw("Clonando Prototipo");
        HttpRequest.request(clonePrototypeUrl+querySelector("#prototypeId").value, requestHeaders : header).then((HttpRequest req) {

           //Map data = JSON.decode(req.response);

           draw(req.response);

         }).catchError((error){
          
          print(error);
          
        });
        
        
}

void inviteUsersBack(Event e){
  
  var basic = "Basic " + token;  
  
  var userList = [querySelector("#inviteId").value];
  Map data = { 'userList': userList};
  var request = new HttpRequest();
  
  request.onReadyStateChange.listen(( Event e){
    draw(request.responseText);
  });
    
  request.open('POST',inviteUsersUrl);
  
  request.setRequestHeader('Authorization', basic);
  request.setRequestHeader( 'Content-Type', 'application/json');
  request.send(JSON.encode(data)); 

}

void wellComeAllBack(Event e){  
  
  var basic = "Basic " + token;
  
  var userList = [querySelector("#inviteId").value];
   Map data = { 'userList': userList};
   var request = new HttpRequest();  
   
   request.onReadyStateChange.listen(( Event e){
     draw(request.responseText);
   });
   
   request.open('POST',welcomeAllUrl);
   
   request.setRequestHeader('Authorization', basic);
   request.setRequestHeader( 'Content-Type', 'application/json');
   request.send(JSON.encode(data));   
}

void updateCompanyValues(Event e){  
  var basic = "Basic " + token;
        Map header =  {'Authorization': basic};
        draw(companyUrl+querySelector("#companyId").value);
        HttpRequest.request(companyUrl+querySelector("#companyId").value, requestHeaders : header).then((HttpRequest req) {

           //Map data = JSON.decode(req.response);

           draw(req.response);

         }).catchError((error){
          
          print(error);
           
});
}
