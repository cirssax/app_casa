//= require jquery
//= require jquery_ujs
//= require back/plugins/bootstrap/bootstrap.min.js
//= require back/plugins/bootstrap-tagsinput/bootstrap-tagsinput.min
//= require back/app
//= require back/plugins/raphael/raphael-min.js
//= require back/plugins/morris/morris.js
//= require back/plugins/jQueryUI/jquery-ui.min.js
//= require back/plugins/datatables/jquery.dataTables.min.js
//= require back/plugins/datatables/dataTables.bootstrap.min.js
//= require back/plugins/fastclick/fastclick.js

$(document).ready(function() {

    $("#BtnProducto").on('click', function () {



    });

    $(window).scroll(function(){
        if ($(this).scrollTop() > 0){
            $('.ir-arriba').slideDown(300);
        } else {
            $('.ir-arriba').slideUp(300);
        };
    });

    $('.ir-arriba').click(function(){
        $('body, html').animate({
            scrollTop: '0px'
        },1000 );
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
