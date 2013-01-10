function ManageSalesController ( $scope, $http, $routeParams, $location, $window ) {
  $scope.forceSession ();

  $scope.current_sale = {};
  $scope.id = $routeParams.id;

  $scope.createSale = function () {
    if ( $scope.authorized () ) {
      $http.post ( '/manage/sales', {
        token: $scope.session.token,
        order: {
          created_by: $scope.session.user._id
        }
      })
      .success ( function ( data, status, handlers, config ) {
        $scope.current_sale = data;
        $location.path('/sales/' + data.order.pretty_id);
      })
      .error ( function ( data, status, handlers, config ) {
        $scope.flash.error = data.message;
      });
    }
  };

  console.log ( $location.path () );
  if ( !$scope.id ) $scope.createSale ();
}
