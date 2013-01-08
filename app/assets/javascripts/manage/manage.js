angular.module ( 'manage', [] ).
  config ( ['$routeProvider', function ( $routeProvider ) {
    $routeProvider.
      when ( '/manage', { templateUrl: '/manage/index', controller: 'ManageDashboardController' } ).
      otherwise ( { redirectTo: '/manage' } );
  }]);
