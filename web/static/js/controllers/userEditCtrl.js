angular.module('MateIM')
    .controller('UserEditCtrl', function($scope, $rootScope, $location, $routeParams,$alert,User) {
        function getUser(){
            User.get({ id: $routeParams.id, edit: true }, function(user,headers) {
                if ("undefined" != typeof(user["email"])){
                    $scope.user = user;
                }else{
                    $alert({
                        content: '君，不要尝试去改被人的资料哟',
                        animation: 'fadeZoomFadeDown',
                        type: 'material',
                        duration: 3
                    });
                    $location.path("/users/"+$routeParams.id);
                }
            },function (httpResponse){
                if (response.status === 401 || response.status === 403) {
                    return;
                }
                $alert({
                    content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                    animation: 'fadeZoomFadeDown',
                    type: 'material',
                    duration: 3
                });
            });
        };

        $scope.saveUser = function(){
            var user = $scope.user;
            if(undefined != user | null != user ) {
                user.$update({id: user.id},
                    function(user,headers) {
                        $alert({
                            content: '君，资料修改成功了',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                        $rootScope.currentUser = user;
                        getUser();
                    },
                    function (httpResponse){
                        if (response.status === 401 || response.status === 403) {
                            return;
                        }
                        $alert({
                            content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                    }
                );
            }
        };

        getUser();

    });
