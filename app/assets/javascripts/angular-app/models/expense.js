angular.module('app').factory('Expense', function($resource){

	var Expense = $resource('http://localhost:9000/expenses/:id.json', { id: '@id' }, {
		update: {
			method: 'PUT'
		}
	});

	return Expense;

});