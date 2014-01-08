
function getParam(codice)
{
    var valore = "codice=" + escape(codice);
    return valore;
}
function getArticolo(codice) {
    $.ajaxSetup({
                async: false
                });
    $.ajax({
           type: "GET",
           crossDomain: true,
           url: getDomain()+"NocBible.asmx/Articolo",
           contentType: "application/json; charset=utf-8",
           data:getParam(codice),
           dataType: "jsonp",
           async: false,
           success: function (response) {
           var cars = response;
           $('#modello').html(cars.Modello);
           // $('#thumbnail').append('<img src="../' + cars.Thumbnail + '" /> ');
           $('#AnnoRiferimento').before(cars.AnnoRiferimento);
           $('#NumeroMatricola').before(cars.NumeroMatricola);
           $('#Finitura').before(cars.Finitura);
           $('#Obiettivo').before(cars.Obiettivo);
           $('#Innesto').before(cars.Innesto);
           $('#Otturatore').before(cars.Otturatore);
           $('#LevaCarica').before(cars.LevaCarica);
           $('#Mirino').before(cars.Mirino);
           $('#Autoscatto').before(cars.Autoscatto);
           $('#Occhielli').before(cars.Occhielli);
           $('#NoteSito').before(cars.NoteSito);
           $('#Tempi').before(cars.Tempi);
           var email = 'NocBible consiglia \u000D \u000A' + cars.Modello + '\u000D \u000A';
           email = email + ' http://test.newoldcamera.it/jMobile/corpo.html?Codice=' + codice;
           $("#mailto").attr('href', 'mailto:?subject=NocBible consiglia&body='+email);
           },
           failure: function (msg) {
           console.log("Scheda load failure");
           alert(msg);
           }
           });
}

function getObbiettivo(codice) {
    $.ajaxSetup({
                async: false
                });
    $.ajax({
           type: "GET",
           crossDomain: true,
           url: getDomain() + "NocBible.asmx/Articolo",
           contentType: "application/json; charset=utf-8",
           data: getParam(codice),
           dataType: "jsonp",
           async: false,
           success: function (response) {
           var cars = response;
           $('#modello').html(cars.Modello);
           $('#AnnoRiferimento').before(cars.AnnoRiferimento);
           $('#LunghezzaFocale').before(cars.LunghezzaFocale);
           $('#AperturaDiaframma').before(cars.AperturaDiaframma);
           $('#NumeroLenti').before(cars.NumeroLenti);
           $('#AngoloCampo').before(cars.AngoloCampo);
           $('#DistanzaMinima').before(cars.DistanzaMinima);
           $('#Montatura').before(cars.Montatura);
           $('#Filtri').before(cars.Filtri);
           $('#Paraluce').before(cars.Paraluce);
           $('#Codice6bit').before(cars.Codice6bit);
           $('#NoteSito').before(cars.NoteSito);
           $('#NumeroMatricola').before(cars.NumeroMatricola);
           var email = 'NocBible consiglia \u000D \u000A' + cars.Modello + '\u000D \u000A';
           email = email + ' http://test.newoldcamera.it/jMobile/obiettivo.html?Codice=' + codice;
           $("#mailto").attr('href', 'mailto:?subject=NocBible consiglia&body='+email);
           },
           failure: function (msg) {
           console.log("Scheda load failure");
           alert(msg);
           }
           });
}

function creaGalleria(codice) {
    $.ajaxSetup({
                async: false
                });
    $.ajax({
           type: "GET",
           crossDomain: true,
           url: getDomain() + "/NocBible.asmx/GalleriaImmagini",
           contentType: "application/json; charset=utf-8",
           data: getParam(codice),
           dataType: "jsonp",
           async:false,
           success: function (response) {
           var cars = response;
           var row = "";
           var id = 0;
           $("#Gallery").empty();
           $.each(cars, function (index, car) {
                  row = row + '<li><a rel="external" href="' + getDomain() + car.FileNameRel + '"><img src="' + getDomain() + car.FileNameRel + '" /></a> </li>';
                  });
           $('#modello').html(cars[0].Modello);
           $('#Gallery').html(row);
           var options = {};
           $("#Gallery a").photoSwipe(options);
           },
           failure: function (msg) {
           console.log("Immagini load failure");
           alert(msg);
           }
           });
}

function getImmaginni(codice) {
    $.ajax({
           type: "GET",
           crossDomain: true,
           url: getDomain() + "/NocBible.asmx/Immagini",
           contentType: "application/json; charset=utf-8",
           data: getParam(codice),
           dataType: "jsonp",
           async:false,
           success: function (response) {
           var cars = response;
           if (cars.length > 0) {
           var pathimg = '<img src="' + getDomain() + cars[0] + '" /> '
           $('#img').before('<img src="' + getDomain() + cars[0] + '" /> ');
           $('#thumbnail').append('<img src="' + getDomain() + cars[0] + '" /> ');
           } else {
           $('#colFoto').html('');
           }
           },
           failure: function (msg) {
           console.log("Immagini load failure");
           alert(msg);
           }
           });
}

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
                                             vars[key] = value;
                                             });
    return vars;
}

function setCodice(codice)
{
    sessionStorage.setItem("Codice", codice);
    var myAudio = document.getElementById("audio");
    myAudio.play();
}

function getDomain()
{
    return "http://test.newoldcamera.it/";
}

function creaTabella(tipo) {
    $.ajaxSetup({
                async: false
                });
    $.ajax({
           type: "GET",
           crossDomain: true,
           url: getDomain()+"NocBible.asmx/ArticoliJ",
           contentType: "application/json; charset=utf-8",
           data: { tipo: 'CO' },
           dataType: "jsonp",
           async:false,
           success: function (response) {
           var cars = response;
           var row = "";
           $("#elenco").empty();
           $('#titolo').html('CORPI');
           
           $.each(cars, function (index, car) {
                  row = row + '<li class="ui-li-desc"><a href="corpo.html"';
                  row = row + ' onclick="setCodice(\'' + car.Codice + '\');" data-rola="page" data-transition="flip"><img width="80px" src="'+getDomain() + car.Thumbnail + '">';
                  row = row + '<h2>' + car.oModello + '<h2>';
                  row = row + '<div id="ricerca" class="ricerca">' + car.Ricerca + '</div>';
                  row = row + '</a></li>';
                  });
           $('#elenco').html(row);
           $("#elenco").listview('refresh');
           $.mobile.loading( "hide" );
           },
           failure: function (msg) {
           console.log("elModelli failure");
           alert(msg);
           }
           });
}
function creaTabellaObiettivi(tipo) {
    $.ajaxSetup({
                async: false
                });
    $.ajax({
           type: "GET",
           crossDomain: true,
           url: getDomain() + "NocBible.asmx/ArticoliJ",
           contentType: "application/json; charset=utf-8",
           data: { tipo: 'OB' },
           dataType: "jsonp",
           async:false,
           success: function (response) {
           var cars = response;
           var row = "";
           $("#elencoob").empty();
           $('#titoloob').html('OBIETTIVI');
           $.each(cars, function (index, car) {
                  row = row + '<li><a href="./obiettivo.html"';
                  row = row + ' onclick="setCodice(\'' + car.Codice + '\');" data-transition="flip"><img width="80px" src="' + getDomain() + car.Thumbnail + '">';
                  row = row + '<h2>' + car.oModello + '<h2>';
                  row = row + '<div id="ricerca" class="ricerca">' + car.Ricerca + '</div>';
                  row = row + '</a></li>';
                  });
           $('#elencoob').html(row);
           $("#elencoob").listview('refresh');
           $.mobile.loading( "hide" );
           },
           failure: function (msg) {
           console.log("elModelli failure");
           alert(msg);
           }
           });
}