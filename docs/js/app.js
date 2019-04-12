var app = angular.module('app', []);

app.controller('MainCtrl', ['$scope', '$http', '$filter',
    function ($scope, $http, $filter) {
        $scope.location = window.location.pathname;

        var req = {
            method: 'GET',
            url: 'https://api.github.com/repos/protirus/Symantec-DLP-SQL/contents/scripts',
            // https://raw.githubusercontent.com/:owner/:repo/master/:path
            // https://raw.githubusercontent.com/Protirus/Tagger/master/README.md
            headers: {
                'Accept': 'application/vnd.github.mercy-preview+json'
            }
        };

        loadFiles = () => {
            $http(req)
                .then(function(response) {
                    angular.forEach(response.data, function(item) {
                        var fileName = item.name.split('.').slice(0, -1).join('.');
                        var ext = item.name.substr(item.name.lastIndexOf('.')+1);
                        if (ext != 'md') {
                            item.fileName = fileName;
                            $scope.files.push(item);
                        }
                    });
                }
            );
        };

        $scope.loadFile = (file) => {
            console.log(file);
            var fileName = file.name.split('.').slice(0, -1).join('.');
            var ext = file.name.substr(file.name.lastIndexOf('.')+1);
            console.log('fileName',fileName);
            console.log('ext',ext);

            var code = document.getElementById("code");
            code.className = "brush: " + ext;
            
            var url = "https://raw.githubusercontent.com/Protirus/Symantec-DLP-SQL/master/scripts/" + file.name;

            var req = {
                method: 'GET',
                url: url,
                headers: {
                    'Accept': 'application/vnd.github.mercy-preview+json'
                }
            };

            $http(req)
                .then(function(response) {
                    $('#code').text(response.data);
                    SyntaxHighlighter.highlight();
                    //$scope.$apply();
                }
            );
        };

        $scope.init = () => {
            $scope.files = [];
            loadFiles();
        };
        //$scope.init();
    }
]
);

// http://jsfiddle.net/davidchase03/u54Kh/
app.directive('markdown', function () {
    var converter = new Showdown.converter();
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            var htmlText = converter.makeHtml(element.text());
            element.html(htmlText);

            // function renderMarkdown() {
            //     var htmlText = converter.makeHtml(scope.$eval(attrs.markdown) || '');
            //     element.html(htmlText);
            // }
            // scope.$watch(attrs.markdown, renderMarkdown);
            // renderMarkdown();
            // scope.$watch('val', function(newValue, oldValue) {
            //     if (newValue)
            //         console.log("I see a data change!");
            // }, true);
        }
    };
});

app.filter('trusted', ['$sce', function ($sce) {
    return function(url) {
        return $sce.trustAsResourceUrl(url);
    };
}]);