// mac Panel效果代码块相关
var exec = require('child_process').exec;

hexo.on('new', function(data){
    exec("open -a /Applications/Typora.app"+data.path);
});