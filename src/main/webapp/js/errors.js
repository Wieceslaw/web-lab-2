const yError = document.querySelector('#y-error')
const xError = document.querySelector('#x-error')
const rError = document.querySelector('#r-error')

function handleError(element, errorMessage) {
    element.textContent = errorMessage
    if (errorMessage) {
        element.classList.add("error")
    } else {
        element.classList.remove("error")
    }
}

function showYError(errorMessage) {
    handleError(yError, errorMessage)
    y.classList.add("bounce")
    setTimeout(function() {
        y.classList.remove("bounce")
    }, 1000)
}

function showXError(errorMessage) {
    handleError(xError, errorMessage)
}

function showRError(errorMessage) {
    handleError(rError, errorMessage)
}

function clearYError() {
    handleError(yError, "")
}

function clearXError() {
    handleError(xError, "")
}

function clearRError() {
    handleError(rError, "")
}
