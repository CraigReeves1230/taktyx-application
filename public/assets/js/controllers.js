/**
 * Holds all Angular controllers for frontend
 */

/**
 * Controller to handle search on home page
 * @author Christopher Reeves
 */

// TODO: Add time out protection to all AJAX events

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

            window.taktyx.util.showAJAXLoader();

            // Send information to server
            $http.post('/user/register', post_data)
                .then(function (msg) {

                    window.taktyx.util.killAJAXLoader();

                    // Check for validation errors
                    if(msg.data.has_errors)
                        $scope.errors = msg.data.data;
                    else
                        window.location = '/';

                }, function (errorMsg) {
                    window.taktyx.util.killAJAXLoader();
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

        window.taktyx.util.showAJAXLoader();
        
        // Send information to server
        $http.post('', post_data)
            .then(function (msg) {

                window.taktyx.util.killAJAXLoader();

                if(msg.data.has_errors)
                {
                    $scope.errors = msg.data.data;
                }
                else
                {
                    // Send user to home page
                    window.location = msg.data.redirect_path;
                }
            }, function (errorMsg) {
                // TODO: Handle JSON error from AJAX
            });
    }
});

/**
 * Controller to handle creating and editing services
 * @author Christopher Reeves
 */
window.taktyx.app.controller('createEditServiceCtrl', function ($scope, $http, $element) {

    // Create list of categories
    $scope.errors = {};
    $scope.categories = gon.categories;
    var csrf_token = $("meta[name='csrf-token']").attr('content');

    // Defaults
    $scope.service = {
        category: $scope.categories[0],
        is_published: true,
        are_ratings_allowed: true,
        is_sharing_allowed: true,
        can_receive_takts: true
    };

    // If this service is being edited, populate service object
    $($element).on('editing-service', function(e, service) {

        $scope.loading = true;

        $http.get('/service/json/' + service.id)
            .then(function (msg) {
                $scope.loading = false;
                if(!msg.data.has_errors) {
                    $scope.service = msg.data.service;

                    // Set category
                    $.each($scope.categories, function (index, category) {
                        if (service.category_id == category.id) {
                            $scope.service.category = category;
                        }
                    });

                    // Set address values
                    $scope.service.address_line_1 = msg.data.address.line_1;
                    $scope.service.address_line_2 = msg.data.address.line_2;
                    $scope.service.address_city = msg.data.address.city;
                    $scope.service.zip_code = msg.data.address.zip_code;
                }
                else
                {
                    alert(msg.data.data);
                }
            }, function (msg) {
                // Todo: Handle JSON error
            });
    });

    /**
     * Update service
     * @param e
     */
    $scope.doUpdate = function (e) {
        e.preventDefault();
        $http.put('/service/' + $scope.service.id,  {service: $scope.service, authenticity_token: csrf_token})
            .then(function (msg) {
                if(msg.data.has_errors)
                {
                    if(msg.data.data.general_error)
                        alert(msg.data.data.general_error);
                    else {
                        // Handle validation errors
                        $scope.errors = msg.data.data;
                    }
                }
                else
                {
                    // Remove popup
                    $($element).modal('hide');
                    $(document).trigger('update-services');
                }
            }, function (errMsg) {
                // Todo: Handle JSON error
            });
    };

    // Handle submitting data to server
    $scope.doSubmit = function (e) {
        e.preventDefault();

        window.taktyx.util.showAJAXLoader();

        $http.post('/service', {service: $scope.service, authenticity_token: csrf_token})
            .then(function (msg) {

                window.taktyx.util.killAJAXLoader();

                $scope.errors = {};

                // Handle errors
                if(msg.data.has_errors)
                {
                    // Check for a user not logged in error
                    if(msg.data.data.unauth)
                    {
                        window.location = '/login';
                    }
                    else if(msg.data.data.general_error)
                    {
                        // TODO: Make this error handling prettier than an alert box
                        alert(msg.data.data.general_error)
                    }
                    else
                    {
                        // Display validation errors
                        $scope.errors = msg.data.data;
                    }
                }
                else
                {
                    // The service was created successfully
                    $(".services-tab").tab('show');

                    // Launch event to update services
                    $(document).trigger('update-services-list');
                }

            }, function (errorMsg) {
                window.taktyx.util.killAJAXLoader();
                // TODO: Handle JSON Error messages
            });
    };
});

/**
 * Controller to display services user has
 * @author Christopher Reeves
 */
window.taktyx.app.controller('userServicesListCtrl', function ($scope, $http) {

    $scope.user_services = gon.user_services;
    var authenticity_token = $("meta[name='csrf-token']").attr('content');

    if($scope.user_services.length > 0) {
        $scope.selected_service = $scope.user_services[0];
    }

    // Change the service selected and being viewed
    $scope.doSelectService = function (e, service) {
        $scope._updateServiceTakts(service);
        $scope.selected_service = service;
    };

    // Switch online status of service
    $scope.doToggleOnlineStatus = function (e, service) {
        
        // Send request to server
        $http.put('/service/status/' + service.id, {authenticity_token: authenticity_token})
            .then(function (msg) {
                if (!msg.data.has_errors)
                {
                    service.is_active = !service.is_active
                }
                else
                {
                    alert(msg.data.data);
                }
            }, function (errMsg) {
                // TODO: Handle JSON Error
            });
    };

    /**
     * Delete service
     * @param e
     * @param service
     */
    $scope.doDelete = function (e, service) {
        e.preventDefault();

        if(confirm("Are you sure you want to delete this service?\nAll messages and history will be delete.")) {
            $http.post('/service/delete/' + service.id, {authenticity_token: authenticity_token})
                .then(function (msg) {
                    if (!msg.data.has_errors) {
                        $(document).trigger('update-services');
                    }
                    else {
                        alert(msg.data.data);
                    }
                });
        }
    };

    /**
     * Open the edit service dialog
     * @param e
     * @param service
     */
    $scope.doOpenEditServiceDialog = function (e, service) {
        e.preventDefault();
        $('.edit-service').modal('show').trigger('editing-service', [service]);
    };

    /**
     * Delete takt
     * @param e
     * @param takt
     */
    $scope.doDeleteTakt = function (e, takt) {
        e.preventDefault();
        if(confirm("Delete this takt?")) {
            $http.post('/messages/delete/' + takt.id, {authenticity_token: authenticity_token})
                .then(function (msg) {
                    if(!msg.data.has_errors)
                    {
                        $scope._updateServiceTakts($scope.selected_service);
                    }
                    else
                    {
                        alert(msg.data.data);
                    }
                }, function (errMsg) {
                    // TODO: Handle JSON Error
                });
        }
    };

    /**
     * Update takts on services
     * @param service
     * @private
     */
    $scope._updateServiceTakts = function(service)
    {
        $http.get('/messages/fetch?service=' + service.id)
            .then(function (msg) {
                if(!msg.data.has_error)
                {
                    service.takts = msg.data.takts;
                }
                else
                {
                    alert(msg.data.data);
                }
            }, function (errMsg) {
                // TODO: Handle JSON error
            });
    };
    
    $scope._updateServiceTakts($scope.selected_service);

    /**
     * Update service list
     * @private
     */
    $scope._updateServiceList = function () {
        $http.get('/service/json/all')
            .then(function (msg) {
                $scope.user_services = msg.data.services;
            }, function (errMsg) {
                // TODO: Handle JSON error
            });
    };

    // Handle update of services
    $(document).on('update-services', function () {
        $scope._updateServiceList();
    });

    // Handle update takts event
    $(document).on('update-takts', function (e, service_id) {
       if($scope.selected_service.id == service_id)
       {
           $scope._updateServiceTakts($scope.selected_service);
       }
    });
});

