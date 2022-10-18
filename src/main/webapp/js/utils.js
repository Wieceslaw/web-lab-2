function formatFloat(val) {
    return val.replace(',', '.')
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
    <tr>
        <td>${formatDate(new Date(data['datetime'] * 1000))}</td>
        <td>${data['delay']} mcs</td>
        <td>${data['x']}</td>
        <td>${data['y']}</td>
        <td>${data['r']}</td>
        <td>${data['formattedResult']}</td>
    </tr>
    `
}
