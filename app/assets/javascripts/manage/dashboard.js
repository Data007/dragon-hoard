function ManageDashboardController ( $scope, $http, $routeParams ) {
  $scope.session = {};

  $scope.authenticate = function ( ) {
    $event.stopPropagation();
    $event.preventDefault();
    console.log ( $scope );
  };
}
