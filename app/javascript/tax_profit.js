function price (){
  const itemPrice = document.getElementById("item-price");
  itemPrice.addEventListener("keyup", () => {
    const count = itemPrice.value;
    const tax = parseInt(count * 0.1);
    const addTaxPrice = document.getElementById("add-tax-price");
    addTaxPrice.innerHTML = `${tax}`;
    const profit = document.getElementById("profit");
    profit.innerHTML = `${count - tax}`;    
  });
}

window.addEventListener('load', price);