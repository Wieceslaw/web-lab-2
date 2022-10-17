const form = document.querySelector('#graphForm')
const y = document.querySelector('#y')
const r = document.querySelector('#r')
const error = document.querySelector('#error')
const table = document.querySelector('#table-body')


function handleError(errorMessage) {
    error.textContent = errorMessage
    if (errorMessage) {
        error.classList.add("error")
        y.classList.add("bounce")
        setTimeout(function() {
            y.classList.remove("bounce");
        }, 1000);
    }
    else {
        error.classList.remove("error")
    }
}

function formatFloat(val) {
    return val.replace(',', '.')
}

function getY() {
    return formatFloat(y.value)
}

function getX() {
    return $('input[name=x]:checked', '#graphForm').val()
}

function getR() {
    return r.value
}

function formatDate(date) {
    let options = {
        year: 'numeric',
        month: 'numeric',
        day: 'numeric',
        hour: 'numeric',
        minute: 'numeric',
        second: 'numeric'
    };
    return date.toLocaleString('ru', options)
}

function parse_table_element(data) {
    return `
    <tr'>
        <td>${formatDate(new Date(data['datetime'] * 1000))}</td>
        <td>${data['delay']} mcs</td>
        <td>${data['x']}</td>
        <td>${data['y']}</td>
        <td>${data['r']}</td>
        <td>${data['formattedResult']}</td>
    </tr>
    `
}

function add_element_to_table(data) {
    tableItem = parse_table_element(data)
    table.insertAdjacentHTML('afterbegin', tableItem)
}

function sendData(event) {
    // validation
    handleError("")
    if (!getY()) {
        console.log("can not be empty")
        handleError("Y can not be empty")
        return
    }
    if (!+getY()) {
        console.log("y must be number")
        handleError("Y must be a number")
        return
    }
    if (+getY() > 5 || +getY() < -5) {
        console.log("y must be lower than 5 and higher then -5")
        handleError("Y must be lower than 5 and higher then -5")
        return
    }
    // sending
    let formData = {
        'x': getX(),
        'y': getY(),
        'r': getR()
    }
    $.ajax({
        url: '/web-lab-2-1.0-SNAPSHOT/controller',
        data: formData,
        processData: true,
        mimeType: 'multipart/form-data',
        type: 'GET',
        success: function(data){
            add_element_to_table(JSON.parse(data))
        },
        error: function(data) {
            alert(data)
        }
    })
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

form.addEventListener('submit', (event) => {
        event.preventDefault();
        sendData(event);
    }
)

setTimezoneCookie()
