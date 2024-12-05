
function hideNav() {    
    // ////////////////////////////////////////////////////////////////////////
    //  We have to use path then check the aria-label value
    var navigationBar = document.querySelector("#root > div > div > nav > div > div > div > div > div > div:nth-child(5) > div:nth-child(1) > div");

    // ////////////////////////////////////////////////////////////////////////
    // Get the navigationBar
    if ( !navigationBar ) {
        console.info('[removeNavMenuAdmin]: ...waiting for navigationBar')
        window.setTimeout(hideNav, 500);
        return;       
    } else {
        console.info('[removeNavMenuAdmin]: ...got navigationBar')
        var navigationBarText = navigationBar.ariaLabel;
        console.log("[removeNavMenuAdmin]: Menu item:  "+navigationBarText);    
        
        // If we are in Admin menu, lets jump out of it
        if (navigationBarText === "Exit Admin") {
            console.info('[removeNavMenuAdmin]: ...exiting from Admin mode');
            navigationBar.click();
            //  As we have clicked the menu, we have to get it again
            var navigationBar = document.querySelector("#root > div > div > nav > div > div > div > div > div > div:nth-child(5) > div:nth-child(1) > div");            
            // ...and wait till we get new label value
            console.info('[removeNavMenuAdmin]: ...waiting for new navigationBar');
            window.setTimeout(hideNav, 500);
            return;
        } else {
            //  Lets hide our menu
            console.info('[removeNavMenuAdmin]: ...hiding navigationBar');
            // navigationBar.style.display = 'none';
            navigationBar.remove(); 
            return;
        }
    }
}

// window.addEventListener("focus", hideNav);
// window.addEventListener("blur", hideNav);
// window.addEventListener("resize", hideNav);
// window.addEventListener("message", hideNav);
// window.addEventListener("pagehide", hideNav);
// window.addEventListener("pagereveal", hideNav);
// window.addEventListener("pageshow", hideNav);
// window.addEventListener("pageswap", hideNav);
window.addEventListener("popstate", hideNav);

// document.addEventListener("readystatechange", hideNav);
document.addEventListener("DOMContentLoaded", hideNav);
// document.addEventListener("prerenderingchange", hideNav);
// document.addEventListener("visibilitychange", hideNav);
document.addEventListener("click", hideNav);

