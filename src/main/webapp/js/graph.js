const graphImage = document.querySelector('.graph-image')

const rWholeNeg = document.querySelectorAll('.r-whole-neg')
const rHalfNeg = document.querySelectorAll('.r-half-neg')
const rHalfPos = document.querySelectorAll('.r-half-pos')
const rWholePos = document.querySelectorAll('.r-whole-pos')

const yDashLine = document.querySelector('.graph-y-dash-line')
const xDashLine = document.querySelector('.graph-x-dash-line')

function addPointToGraph(x, y, r) {
    let xCord = (x / r / 3 + 0.5) * 300
    let yCord = -((y / r / 3 - 0.5) * 300)
    let circle = document.createElementNS(graphImage.namespaceURI, "circle");
    circle.setAttributeNS(null, "cx", xCord)
    circle.setAttributeNS(null, "cy", yCord)
    circle.setAttributeNS(null, "r", "2")
    graphImage.appendChild(circle)
}

function changeGraphLabels(r) {
    rWholeNeg.forEach(el => {
        el.textContent = -r ? -r : "-R"
    })
    rHalfNeg.forEach(el => {
        el.textContent = -(r / 2) ? -(r / 2) : "-R/2"
    })
    rHalfPos.forEach(el => {
        el.textContent = +r / 2 ? r / 2 : "R/2"
    })
    rWholePos.forEach(el => {
        el.textContent = +r ? +r: "R"
    })
}

graphImage.addEventListener('click', event => {
    let x = (event.offsetX / 250 * 300).toString()
    let y = event.offsetY / 250 * 300
    let r = getR()
    let xCord = Math.round((x / 300 - 0.5) * r * 3)
    let yCord = ((-y / 300) + 0.5) * 3 * r
    clearRError()
    if (!r) {
        showRError("Radius value is not selected")
        return
    }
    if (xCord >= -4 && xCord <= 4 && yCord <= 5 && yCord >= -5) {
        makeRequest(xCord, Math.round(yCord * 10000) / 10000, r)
        addPointToGraph(xCord, yCord, r)
    }
})

graphImage.addEventListener('mousemove', event => {
    let x = (event.offsetX / 250 * 300).toString()
    let y = event.offsetY / 250 * 300
    let r = getR()
    let yCord = ((-y / 300) + 0.5) * 3 * r
    if (!r || yCord <= 5 && yCord >= -5) {
        yDashLine.setAttribute("y1", y)
        yDashLine.setAttribute("y2", y)
    }
    let xCord = Math.round((x / 300 - 0.5) * r * 3)
    if (r && xCord >= -4 && xCord <= 4) {
        let xGraphCord = (xCord / r / 3 + 0.5) * 300
        xDashLine.setAttribute("x1", xGraphCord)
        xDashLine.setAttribute("x2", xGraphCord)
    } else if (!r) {
        xDashLine.setAttribute("x1", x)
        xDashLine.setAttribute("x2", x)
    }
})

graphImage.addEventListener('mouseleave', event => {
    xDashLine.setAttribute("x1", -10)
    xDashLine.setAttribute("x2", -10)
    yDashLine.setAttribute("y1", -10)
    yDashLine.setAttribute("y2", -10)
})
