angular.module('app').factory('Expense', ['$resource' , function($resource){

	var Expense = $resource( Routes.expenses_path() + '/:id.json', { id: '@id' }, {
		update: {
			method: 'PUT'
		}
	});

	return Expense;

}]);