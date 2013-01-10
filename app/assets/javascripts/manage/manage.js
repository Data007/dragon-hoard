angular.module ( 'manage', [] ).
  config ( ['$routeProvider', function ( $routeProvider ) {
    $routeProvider.
      when ( '/home', { templateUrl: '/assets/manage/index.html', controller: 'ManageDashboardController' } ).
      when ( '/authorize', { templateUrl: '/assets/manage/authorize.html', controller: 'ManageSessionController' } ).
      when ( '/sales', { templateUrl: '/assets/manage/sales/index.html', controller: 'ManageSalesController' } ).
      when ( '/sales/new', { templateUrl: '/assets/manage/sales/new.html', controller: 'ManageSalesController' } ).
      otherwise ( { redirectTo: '/home' } );
  }]);
