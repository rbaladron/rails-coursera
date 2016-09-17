(function(){
  'use strict';
  angular.module('dietCheckerApp', [])
  .controller('firstController', FirstController);

  FirstController.$inject = ['$scope', '$filter'];
  function FirstController($scope, $filter) {

    $scope.dishes="";
    $scope.message="";

    $scope.processDishes = function() {

      var dietString = $scope.dishes;
      var newString = dietString.replace(/\s+/g,' ').trim();

      if (newString ==='') {
        $scope.message = "Please enter data first";
      } else {
        var splitedString = newString.split(',');
        var totalDietCount = 0;
        for (var count =0 ; count < splitedString.length; count++) {
          var newSplittedString = splitedString[count].replace(/\s+/g,' ').trim();
          console.log(newSplittedString);

          if(newSplittedString != '') {
            totalDietCount++;
          }
        }
        if (totalDietCount <=3) {
          $scope.message = "Enjoy!";
        } else {
          $scope.message = "Too much!";
        }
      }
    }

  }
})();
