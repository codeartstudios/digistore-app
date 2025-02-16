// -------------------------------------------------------- //

// Logic to check if the user is actually logged in or not
// Checks for token validity, organization validity and
// logged in user validity.
function checkIfLoggedIn() {
    // Check if JWT is valid
    var tokenIsValid = dsController.validateToken();

    // Check if logged in user is structurally valid
    var loggedUserIsValid = dsController.loggedUser &&
            dsController.loggedUser.id && dsController.loggedUser.id!=="" &&
            dsController.loggedUser.name && dsController.loggedUser.name!==""

    // Check if organization structure is valid
    var orgIsValid = dsController.organization &&
            dsController.organization.name && dsController.organization.name!=="" &&
            dsController.organization.id && dsController.organization.id!==""

    // console.log(tokenIsValid, loggedUserIsValid, orgIsValid)
    return tokenIsValid===true && loggedUserIsValid===true && orgIsValid===true
}

function logout() {
    // Clear token
    dsController.token = ''
    dsController.loggedUser = {}
    dsController.organization = {}
    dsController.isLoggedIn = checkIfLoggedIn()
    toast.info(qsTr("Logout Success!"))
}
