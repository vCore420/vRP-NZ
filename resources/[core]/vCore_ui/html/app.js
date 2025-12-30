window.addEventListener('message', function(event) {
    if (event.data && event.data.action === "notify") {
        showNotification(
            event.data.data.message,
            event.data.data.type || "info",
            event.data.data.duration || 3000
        );
    }
});

function showNotification(msg, type, duration) {
    const container = document.getElementById('notification-container');
    let notif = document.createElement('div');
    notif.className = 'card notification ' + type;
    notif.innerText = msg;
    notif.style.position = 'fixed';
    notif.style.top = '2em';
    notif.style.right = '2em';
    notif.style.zIndex = 9999;
    container.appendChild(notif);
    setTimeout(() => notif.remove(), duration || 3000);
}