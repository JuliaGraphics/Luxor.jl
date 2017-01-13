
var pathname = window.location.pathname;
if (pathname.indexOf('latest') !== -1) {
    var body = document.getElementsByTagName('body')[0];
    body.style.backgroundImage = 'url(assets/draft.png)';
    body.style.backgroundRepeat = 'no-repeat';
}
