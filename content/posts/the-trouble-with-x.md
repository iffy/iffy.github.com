Title: The Trouble With X
Date: 2015-01-14
Tags: dev
Template: article.longform
AngularApp: troubleWithX

<span class="aside">Change X to suit your needs.<br/>Go ahead, click it.</span>There's a problem with <x></x>.  It's obvious.  <x></x> has major flaws and I don't understand how anyone derives any actual value from <x></x>.  Don't they know that there's problems with it and that there are much better things available?

Granted, there's no perfect solution, but <x></x>?  Really?  Didn't the people who made <x></x> realize that there are much better ways to do things?  They are obviously utter morons.  Really, the very best things anyone can use is <y></y>.

---

Do your best&mdash;that's all you can do.  Humans are remarkably good at achieving despite our many shortcomings and weaknesses and the odds being stacked against us.



<script>
angular.module('troubleWithX', [])
.value('xdata', {value: 'X'})
.directive('x', function(xdata) {
    return {
        restrict: 'E',
        replace: true,
        template: '<span class="madlib" editable ng-model="data.value"></span>',
        link: function(scope) {
            scope.data = xdata;
        }
    }
})
.directive('y', function(xdata, $timeout) {
    return {
        restrict: 'E',
        replace: true,
        template: '<span class="madlib blue" editable ng-model="y.value"></span>',
        link: function(scope, element) {
            scope.y = {
                value: 'Y',
            }
            var restore = _.debounce(function() {
                scope.$apply(function() {
                    xdata.value = scope.y.value;
                    scope.y.value = 'Y';
                })
            }, 1000);
            element.bind('input', function() {
                restore();
            })
        }
    }
})
.directive('editable', function() {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function(scope, element, attrs, ngModel) {
            element.attr('contentEditable', 'true');

            // input change
            element.bind('input', function() {
                var text = element.text();
                text.replace(/<br>/g, '');
                scope.$apply(function() {
                    ngModel.$setViewValue(text);
                });
            });
            element.bind('blue', function() {
                scope.$apply(function() {
                    ngModel.$render();    
                });
            });

            // model change
            ngModel.$render = function() {
                element.text(ngModel.$viewValue);
            };
        }
    }
})
</script>
