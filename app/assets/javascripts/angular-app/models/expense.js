angular.module('app').factory('Expense', function($resource){

	var Expense = $resource( Routes.expenses_path() + '/:id.json', { id: '@id' }, {
		update: {
			method: 'PUT'
		}
	});

	return Expense;

});