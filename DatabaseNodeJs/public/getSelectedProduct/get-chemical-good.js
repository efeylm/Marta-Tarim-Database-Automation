document.addEventListener('DOMContentLoaded', async () => {
    try {
        const response = await fetch('/api/chemical-goods');
        if (!response.ok) throw new Error('Failed to fetch chemical goods.');

        const chemicalGoods = await response.json();
        const chemicalGoodsTable = document.getElementById('chemical-goods-table');

        chemicalGoods.forEach(good => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${good.GoodID}</td>
                <td>${good.ProductID}</td>
                <td>${good.Category}</td>
                <td>${good.ExpirationDate}</td>
                <td>${good.FertilizerName || 'N/A'}</td>
                <td>${good.FungicideName || 'N/A'}</td>
                <td>${good.HerbicideName || 'N/A'}</td>
                <td>${good.InsecticideName || 'N/A'}</td>
            `;
            chemicalGoodsTable.appendChild(row);
        });
    } catch (error) {
        console.error(error);
        document.getElementById('error-message').textContent = 'Error loading chemical goods data.';
    }
});
