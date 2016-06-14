/**
 * Holds all Angular controllers for frontend
 */

/**
 * Controller to handle search on home page
 * @author Christopher Reeves
 */
window.taktyx.app.controller('homeSearchCtrl', function ($scope) {

    // Defaults
    $scope.keyword = "";
    $scope.source_location = "present";
    $scope.address = {address: "", zip_code: ""};

    // Perform search
    $scope.doSearch = function (e)
    {
        e.preventDefault();
        $scope.errors = false;

        // Validate that there is a value in the search keyword field
        if($scope.keyword === "")
        {
            $scope.errors = $scope.errors || {};
            $scope.errors['keyword'] = "Please provide a search phrase.";
        }
        else if($scope.keyword.length < 5)
        {
            $scope.errors = $scope.errors || {};
            $scope.errors['keyword'] = "Please provide a longer search phrase.";
        }

        // Send to search results
        var url = '/search?keyword=' + encodeURIComponent($scope.keyword) +
        '&loc=' + encodeURIComponent($scope.source_location);

        // Add address information if origin location is address
        if($scope.source_location == 'address')
        {
            // If the the source location is address, validate there is at least a zip code
            if(typeof $scope.address.zip_code === "undefined" || $scope.address.zip_code === "")
            {
                $scope.errors = $scope.errors || {};
                $scope.errors['zipcode'] = "Please provide the zip code of the origin location to search from.";
            }
            else
            {
                // Add address to url
                url += '&address=' + encodeURIComponent($scope.address.address);
                url += '&zipcode=' + encodeURIComponent($scope.address.zip_code);
            }
        }

        // Send user to url
        if($scope.errors === false)
            window.location = url;
    };

});


/**
 * Controller to handle search on search results page
 * @author Christopher Reeves
 */
window.taktyx.app.controller('searchResultSearchCtrl', function ($scope) {

    // Defaults
    $scope.keyword = window.taktyx.util.getUrlParameter('keyword');
    $scope.source_location = window.taktyx.util.getUrlParameter('loc');

    if($scope.source_location == "present")
    {
        $scope.address = {address: "", zip_code: ""};
    }
    else
    {
        $scope.address = {
            address: decodeURIComponent(window.taktyx.util.getUrlParameter('address')),
            zip_code: decodeURIComponent(window.taktyx.util.getUrlParameter('zipcode'))
        };
    }
});


/**
 * Controller to handle user registration form
 * @author Christopher Reeves
 */
window.taktyx.app.controller('userRegisterCtrl', function ($scope, $element, $http) {

    // Defaults
    $scope.user = {};
    $scope.newsletter_sub = true;
    $scope.tos = false;
    var csrf_token = $element.data('csrf');

    // Handle submit
    $scope.doSubmit = function (e)
    {
        e.preventDefault();
        $scope.errors = false;

        // Check if terms of service is checked
        if($scope.tos == false)
        {
            $scope.errors = $scope.errors || {};
            $scope.errors.tos = true;
        }
        else
        {
            var post_data = {
                authenticity_token: csrf_token,
                newsletter_sub: $scope.newsletter_sub,
                user: $scope.user
            };

            // Send information to server
            $http.post('/user/register', post_data)
                .then(function (msg) {

                    // Check for validation errors
                    if(msg.data.has_errors)
                        $scope.errors = msg.data.data;
                    else
                        window.location = '/';

                }, function (errorMsg) {
                    // TODO: Handle JSON error from AJAX
                });
        }
    }
});

/**
 * Controller to handle user authentication and logging in
 * @author Christopher Reeves
 */
window.taktyx.app.controller('authLoginCtrl', function ($scope, $http, $element) {

    $scope.auth = {};
    var csrf_token = $element.data('csrf');

    /**
     * Handle logging in
     * @param e
     */
    $scope.doSubmit = function (e)
    {
        e.preventDefault();
        $scope.errors = false;
        var post_data = {
            authenticity_token: csrf_token,
            auth: $scope.auth
        };
        
        // Send information to server
        $http.post('/login', post_data)
            .then(function (msg) {
                if(msg.data.has_errors)
                {
                    $scope.errors = msg.data.data;
                }
                else
                {
                    // Send user to home page
                    window.location = '/';
                }
            }, function (errorMsg) {
                // TODO: Handle JSON error from AJAX
            });
    }
});

