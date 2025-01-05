document.addEventListener('DOMContentLoaded', async () => {
    try {
        const response = await fetch('/api/plants');
        if (!response.ok) throw new Error('Failed to fetch plants.');

        const plants = await response.json();
        const plantsTable = document.getElementById('plants-table');

        plants.forEach(plant => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${plant.PlantID}</td>
                <td>${plant.ProductID}</td>
                <td>${plant.PlantType}</td>
                <td>${plant.SeedType || 'N/A'}</td>
                <td>${plant.SeedlingType || 'N/A'}</td>
                <td>${plant.PottedType || 'N/A'}</td>
            `;
            plantsTable.appendChild(row);
        });
    } catch (error) {
        console.error(error);
        document.getElementById('error-message').textContent = 'Error loading plant data.';
    }
});
