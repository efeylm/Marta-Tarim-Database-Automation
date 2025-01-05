document.addEventListener('DOMContentLoaded', async () => {
    try {
        const response = await fetch('/api/tools');
        if (!response.ok) throw new Error('Failed to fetch tools.');

        const tools = await response.json();
        const toolsTable = document.getElementById('tools-table');

        tools.forEach(tool => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${tool.ToolID}</td>
                <td>${tool.ProductID}</td>
                <td>${tool.ToolName}</td>
                <td>${tool.ToolType}</td>
                <td>${tool.Condition}</td>
            `;
            toolsTable.appendChild(row);
        });
    } catch (error) {
        console.error(error);
        document.getElementById('error-message').textContent = 'Error loading tools data.';
    }
});
