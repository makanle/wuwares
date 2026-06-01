function gentoken(n){
    var chars = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789';
    var token = '';
    for(i = 0 ; i < n ; i++){
        token += chars[Math.floor(Math.random() * chars.length)];
    }
    return token;  
}

module.exports = {gentoken}