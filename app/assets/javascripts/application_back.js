//= require jquery
//= require jquery_ujs
//= require back/plugins/bootstrap/bootstrap.min.js
//= require back/plugins/bootstrap-tagsinput/bootstrap-tagsinput.min
//= require back/app
//= require back/plugins/jQueryUI/jquery-ui.min.js
//= require back/plugins/datatables/jquery.dataTables.min.js
//= require back/plugins/datatables/dataTables.bootstrap.min.js

$(document).ready(function() {

    $("#Subir").on('click', function () {
        $("body,html").animate({ // aplicamos la función animate a los tags body y html
            scrollTop: 0 //al colocar el valor 0 a scrollTop me volverá a la parte inicial de la página
        }, 1000); //el valor 700 indica que lo ara en 700 mili segundos
        return false; //rompe el bucle
    });

    $("#Bajar").on('click', function () {
        $('html, body').animate({
            scrollTop: $("#punto").offset().top
        }, 1000);
    });



  $("#tabla").DataTable({
      'paging'      : true,
      'searching'   : false,
      'ordering'    : true,
      'info'        : true,
      'autoWidth'   : false,

      "bStateSave": true,
      "bSort": false,
      "processing": true,
      "language":
          {
              "emptyTable": "No existen productos con ese nombre",
              "zeroRecords": "No existen registros que cumplan el criterio de búsqueda",
              "processing": "Buscando registros...",
              "search": "Buscar:",
              "lengthMenu": "Mostrar _MENU_ registros",
              "info": "Registros del _START_ al _END_ de un total de _TOTAL_",
              "paginate": {
                  "first": "Primero",
                  "last": "Último",
                  "next": "Siguiente",
                  "previous": "Anterior"
              }
          }
  });
  // Get sidebar state from localStorage and add the proper class to body
  $('body').addClass(localStorage.getItem('sidebar-state'));

    var activePage = stripTrailingSlash(window.location.pathname);
  $('.sidebar-menu li a').each(function(){
    var currentPage = stripTrailingSlash($(this).attr('href'));
    if (activePage == currentPage) {
      $(this).closest('.treeview').addClass('active');
      $(this).parent().addClass('active');
    }
  });
  function stripTrailingSlash(str) {
    if(str.substr(-1) == '/') { return str.substr(0, str.length - 1); }
    return str;
  }

  // Save sidebar state in localStorage browser
  $('.sidebar-toggle').on('click', function(){
    if($('body').attr('class').indexOf('sidebar-collapse') != -1) {
      localStorage.setItem('sidebar-state', '');
    } else {
      localStorage.setItem('sidebar-state', 'sidebar-collapse');
    }
  });

});
