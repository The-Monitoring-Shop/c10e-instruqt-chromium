
let inputFormIterations = 10;

function loginUser() {
    
    // ////////////////////////////////////////////////////////////////////////
    // Setup our variables
    const userEmail = {{AUTOLOGIN_EMAIL}};
    const userPassword = {{AUTOLOGIN_PASSWORD}};

    // ////////////////////////////////////////////////////////////////////////
    const inputForm = document.querySelector("#root > div > div > form");

    // let inputEmail = document.querySelector("#email");
    const inputEmail = document.getElementById("email");
    
    // let inputPassword = document.querySelector("#password");
    const inputPassword = document.getElementById("password");
    
    // let loginButton = document.querySelector("#root > div > div > form > button");
    const loginButton = document.querySelector('button[type="submit"]')
    // const loginButton = document.querySelector('.MuiButtonBase-root.MuiButton-contained.MuiButton-containedPrimary');
    
    // Create a React-compatible event
    const inputValueSetter = Object.getOwnPropertyDescriptor(
        HTMLInputElement.prototype, 'value'
    ).set;

    // Create an input event
    const inputEvent = new Event('input', { bubbles: true });

    // ////////////////////////////////////////////////////////////////////////
    // Run inputForm check 10 times
    if ( inputFormIterations-- > 0) {
        console.info("[autoLogin]: inputFormIterations: "+inputFormIterations);

        // Get the inputform
        // console.info("[autoLogin]: Getting loginForm inputForm...");
        if ( !inputForm ) {
            // Wait for the elements to be available...
            console.info('[autoLogin]: ...waiting for loginForm inputForm');
            window.setTimeout(loginUser, 500);
            return;        
        } else {
            console.info('[autoLogin]: ...got inputform');
        }
    } else {
        // ...then stop
        return
    }

    // ////////////////////////////////////////////////////////////////////////
    // Get the input fields
    // console.info("[autoLogin]: Getting loginForm elements...");
    if ( !inputEmail || !inputPassword || !loginButton) {
        // Wait for the elements to be available...
        console.info('[autoLogin]: ...waiting for loginForm elements');
        window.setTimeout(loginUser, 500);
        return;     
    } else {
        // Entering userEmail
        console.info("[autoLogin]: ...setting inputEmail value");
        inputEmail.focus();
        // Dispatch a React-compatible event
        inputValueSetter.call(inputEmail, userEmail);
        // Dispatch the input event to notify React
        inputEmail.dispatchEvent(inputEvent);

        // Entering userPassword
        console.info("[autoLogin]: ...setting inputPassword value");
        inputPassword.focus();
        // Dispatch a React-compatible event
        inputValueSetter.call(inputPassword, userPassword);
        // Dispatch the input event to notify React
        inputPassword.dispatchEvent(inputEvent);

        // Clicking loginButton
        console.info("[autoLogin]: ...clicking loginButton");
        loginButton.click();   
    }
}


// window.addEventListener("focus", loginUser);
// window.addEventListener("blur", loginUser);
// window.addEventListener("resize", loginUser);
// window.addEventListener("message", loginUser);
// window.addEventListener("pagehide", loginUser);
// window.addEventListener("pagereveal", loginUser);
// window.addEventListener("pageshow", loginUser);
// window.addEventListener("pageswap", loginUser);
// window.addEventListener("popstate", loginUser);

// document.addEventListener("readystatechange", loginUser);
document.addEventListener("DOMContentLoaded", loginUser);
// document.addEventListener("prerenderingchange", loginUser);
// document.addEventListener("visibilitychange", loginUser);
// document.addEventListener("click", loginUser);
