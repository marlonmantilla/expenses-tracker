angular.module('app').controller('ExpensesCtrl', ['Expense', '$scope',
	function(Expense, $scope){
		$scope.expenses = Expense.query();
		$scope.newExpense = new Expense();
		$scope.searchExpense = new Expense();
		$scope.filter = false;

		$scope.save = function(expense){
			if(!_.include($scope.expenses, expense)){
				expense.$save();
				$scope.expenses.push(expense);	
			}else{
				Expense.update(expense);
			}
			$scope.newExpense = new Expense();
		};

		$scope.reset = function(){
			$scope.newExpense = new Expense();
		}

		$scope.edit = function(expense) {
      $scope.newExpense = expense;
      $scope.filter = false;
    };

		$scope.remove = function(expense) {
      Expense.delete(expense);
      _.remove($scope.expenses, expense);
    };

    $scope.showSearch = function(){
    	$scope.filter = !$scope.filter;
    }

    $scope.resetFilter = function(){
    	$scope.searchExpense = new Expense();
    	$scope.expenses = Expense.query();
    }

    $scope.search = function(expense){
    	Expense.query({ amount: expense.amount, description: expense.description, comment: expense.comment, filters: true }).$promise.then(function(response) {
    		$scope.expenses = (response);
    	});
    }

	}
]);