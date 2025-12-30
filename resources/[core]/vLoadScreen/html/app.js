window.addEventListener('message', function(event) {
    if (event.data && event.data.action === "showLoading") {
        const o = document.getElementById('loading-overlay');
        o.style.display = 'flex';
        o.style.opacity = '1';
        document.getElementById('loading-text').innerText = event.data.text || "Loading, please wait...";
    }
    if (event.data && event.data.action === "hideLoading") {
        const o = document.getElementById('loading-overlay');
        o.style.opacity = '0';
        setTimeout(() => { o.style.display = 'none'; }, 350);
    }
});