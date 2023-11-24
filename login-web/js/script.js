
const containerL = document.querySelector(".containerL"),
      containerR = document.querySelector(".containerR");

function submitLogin() {
    var username = document.getElementById('username').value;
    var password = document.getElementById('password').value;
    var checkbox = document.getElementById('checkbox').checked;
    
    if (username != "" && password != "") {
        mta.triggerEvent("playerLogin", username, password,checkbox);
    }
};

function register() {
    containerR.classList.add("center");
    containerR.classList.remove("left");

    containerL.classList.add("right");
    containerL.classList.remove("center");
};

function back() {
    containerR.classList.add("left");
    containerR.classList.remove("center");

    containerL.classList.add("center");
    containerL.classList.remove("right");
};

function submitRegister() {
    var pattern = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/; 

    var emailR = document.getElementById('emailR').value;
    var usernameR = document.getElementById('usernameR').value;
    var passwordR = document.getElementById('passwordR').value;
    var repasswordR = document.getElementById('repasswordR').value;
    
    if (emailR != "" || usernameR != "" || passwordR != "" || repasswordR != "") {
        if(String(emailR).search (pattern) != -1){
            mta.triggerEvent("playerRegister", emailR, usernameR, passwordR, repasswordR);
        }
    }
};

function submitGuest(e) {
    mta.triggerEvent("login:close");
};

function backLogin(){
    document.getElementById('emailR').value = "";
    document.getElementById('usernameR').value = "";
    document.getElementById('passwordR').value = "";
    document.getElementById('repasswordR').value = "";
    back();
}