document.addEventListener('DOMContentLoaded', async () => {
    try {
        const response = await fetch('/api/inventory');
        if (!response.ok) throw new Error('Failed to fetch inventory.');

        const inventory = await response.json();
        const inventoryTable = document.getElementById('inventory-table');

        inventory.forEach(item => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${item.ProductID}</td>
                <td>${item.ProductName || 'N/A'}</td>
                <td>${item.Quantity}</td>
                <td>${item.StockStatus}</td>
                <td>${item.ProductType}</td>
            `;
            inventoryTable.appendChild(row);
        });
    } catch (error) {
        console.error(error);
        document.getElementById('error-message').textContent = 'Error loading inventory data.';
    }
});
