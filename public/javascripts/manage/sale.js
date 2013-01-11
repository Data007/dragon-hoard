function ManageSalesController ( $scope, $http, $routeParams, $location, $window ) {
  $scope.forceSession ();

  $scope.currentOrder = {};
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
        $scope.currentOrder = data.order;
        console.log ( data );
        console.log ( $scope.currentOrder );
        $location.path('/sales/' + $scope.currentOrder.pretty_id);
      })
      .error ( function ( data, status, handlers, config ) {
        $scope.flash.error = data.message;
      });
    }
  };

  $scope.createLineItem = function () {
    console.log ( $scope.currentOrder );
    $http.post ( '/manage/sales/' + $scope.id + '/line_items', {
      token: $scope.session.token,
      line_item: {
        is_quick_item: true,
        description: $scope.lineItem.description,
        price: $scope.lineItem.price,
        quantity: $scope.lineItem.quantity
      }
    })
    .success ( function ( data, status, handlers, config ) {
      console.log ( data );
      $scope.currentOrder = data.order;
    })
    .error ( function ( data, status, handlers, config ) {
      $scope.flash.error = data.message;
    });
  };

  console.log ( $location.path () );
  if ( !$scope.id ) $scope.createSale ();
}
