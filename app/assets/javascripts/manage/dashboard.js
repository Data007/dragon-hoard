function ManageDashboardController ( $scope, $http, $window, $routeParams, $location ) {
  $scope.session = {};
  $scope.flash = {};
  $scope.pin = '';

  $scope.authorized = function () {
    return $scope.session.token ? true : false;
  };

  $scope.forceSession = function () {
    if ( !$scope.authorized () ) {
      $scope.session.redirect_url = '#' + $location.path ();
      $window.location.href = '#/authorize';
    }
  };

  $scope.clearSession = function () {
    $scope.session = {};
  };

  $scope.createSession = function () {
    $http.post ( '/manage/session', {pin: $scope.session.pin} )
      .success ( function ( data, status, handlers, config ) {
        $scope.flash = {};
        var redirect_url = $scope.session.redirect_url;
        $scope.session = data;
        $window.location.href = redirect_url;
      })
      .error ( function ( data, status, handler, config ) {
        $scope.flash.error = data.message
      });
  };
}
