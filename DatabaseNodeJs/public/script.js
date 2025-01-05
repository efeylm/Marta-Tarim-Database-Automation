document.getElementById('login-form').addEventListener('submit', async (event) => {
    event.preventDefault();

    const FirstName = document.getElementById('FirstName').value;
    const LastName = document.getElementById('LastName').value;
    const Password = document.getElementById('Password').value;

    try {
        const response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ FirstName, LastName, Password }),
        });

        if (response.ok) {
            // Successful login
            const data = await response.json();
            window.location.href = '/home.html';
        } else {
            // Failed login
            document.getElementById('error-message').classList.remove('hidden');
        }
    } catch (error) {
        console.error('Error during login:', error);
        document.getElementById('error-message').classList.remove('hidden');
    }
});
