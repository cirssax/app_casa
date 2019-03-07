//= require jquery
//= require jquery_ujs
//= require back/plugins/bootstrap/bootstrap.min.js
//= require back/plugins/bootstrap-tagsinput/bootstrap-tagsinput.min
//= require back/app
//= require back/plugins/jQueryUI/jquery-ui.min.js

$(document).ready(function() {

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
