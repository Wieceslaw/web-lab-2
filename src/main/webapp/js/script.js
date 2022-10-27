const form = document.querySelector('#graphForm')
const y = document.querySelector('#y')
const table = document.querySelector('#table-body')
const xButtons = document.querySelectorAll('.x input')
const rButtons = document.querySelectorAll('.r input')
const clearButton = document.querySelector('.clear-button')

function getY() {
    return formatFloat(y.value)
}

function getX() {
    let result = undefined
    xButtons.forEach(element => {
        if (element.classList.contains('active')) {
            result = element.value
        }
    })
    return result
}

function getR() {
    let result = 0
    rButtons.forEach(element => {
        if (element.classList.contains('active')) {
            result = element.value
        }
    })
    return result
}

function add_element_to_table(data) {
    tableItem = parse_table_element(data)
    table.insertAdjacentHTML('afterbegin', tableItem)
}

function makeRequest(x, y, r) {
    let formData = {
        'x': x,
        'y': y,
        'r': r,
        'command': 'check'
    }
    $.ajax({
        url: '/laba2/controller',
        data: formData,
        processData: true,
        mimeType: 'multipart/form-data',
        type: 'GET',
        success: function(data){
            parsedData = JSON.parse(data)
            addPointToGraph(parsedData['x'], parsedData['y'], parsedData['r'])
            add_element_to_table(parsedData)
        },
        error: function(data) {
            // TODO: check other errors
            if (data.statusText === "timeout") {
                alert("The server is not responding")
            } else {
                alert("Something went wrong...")
            }
        },
        timeout: 3000
    })
}

function sendData(event) {
    // validation
    clearYError()
    clearXError()
    clearRError()
    if (!getX()) {
        console.log("x not selected")
        showXError("X cord value not selected")
        return
    }
    if (!getY()) {
        console.log("can not be empty")
        showYError("Y can not be empty")
        return
    }
    if (isNaN(getY())) {
        console.log("y must be number")
        showYError("Y must be a number")
        return
    }
    if (+getY() > 5 || +getY() < -5) {
        console.log("y must be lower than 5 and higher then -5")
        showYError("Y must be lower than 5 and higher then -5")
        return
    }
    if (!getR()) {
        console.log("r not selected")
        showRError("Radius value not selected")
        return
    }
    // sending
    makeRequest(getX(), getY(), getR())
}

function setTimezoneCookie () {
    const timezone_cookie = "timezoneoffset";
    let offset = new Date().getTimezoneOffset();
    if (!Cookies.get(timezone_cookie)) {
        Cookies.set(timezone_cookie, offset, { expires: 30, path: '/' });
        location.reload();
    }
    else {
        let storedOffset = parseInt(Cookies.get(timezone_cookie));
        if (storedOffset !== offset) {
            Cookies.set(timezone_cookie, offset, { expires: 30, path: '/' });
            location.reload();
        }
    }
}

clearButton.addEventListener('click', event => {
    $.ajax({
        url: '/lab2/controller?command=clear',
        type: 'GET',
        success: function(data){
            location.reload();
        },
        error: function(data) {
            if (data.statusText === "timeout") {
                alert("The server is not responding")
            } else {
                alert("Something went wrong...")
            }
        },
        timeout: 3000
    })
})

form.addEventListener('submit', (event) => {
    event.preventDefault();
    sendData(event);
})

xButtons.forEach(element => {
    element.addEventListener( 'click', event => {
            element.classList.add('active')
            xButtons.forEach(nonActiveElement => {
                if (nonActiveElement !== element) {
                    nonActiveElement.classList.remove('active')
                }
            })
        }
    )
})

rButtons.forEach(element => {
    element.addEventListener( 'click', event => {
            changeGraphLabels(element.value)
            element.classList.add('active')
            rButtons.forEach(nonActiveElement => {
                if (nonActiveElement !== element) {
                    nonActiveElement.classList.remove('active')
                }
            })
        }
    )
})

setTimezoneCookie()
