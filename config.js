/*ejercicio 1*/ 
function tocar(){
    if (document.getElementById("circulo").style.backgroundColor == "red") {
    document.getElementById("circulo").style = "background-color:blue";
    console.log("ahora es azul");
    }
    else{
    document.getElementById("circulo").style = "background-color:red";
    console.log("ahora es rojo");
    }
}

/*ejercicio 2*/ 
function hexa() {
    let valor = document.getElementById("dato_entrante").value;

    if (valor[0] != "#") {
        valor = "#" + valor;
    }
    if (valor.length == 7) {
        document.getElementById("circulo").style.backgroundColor = valor;
    }
    else{
        alert("no es un codigo valido");
    }
}


