let characters = []; 
let selectedSlot = 0;
let selectedGender = "male";

function showOverlay(id) {
    document.querySelectorAll('#char-select-overlay, #char-create-overlay').forEach(el => {
        el.classList.remove('active', 'fade-in', 'fade-out');
        el.style.display = 'none';
        el.style.opacity = 0;
    });
    const el = document.getElementById(id);
    el.style.display = 'flex';
    el.classList.add('active', 'fade-in');
    setTimeout(() => {
        el.classList.remove('fade-in');
        el.style.opacity = 1;
    }, 400);
}

function hideOverlay(id) {
    const el = document.getElementById(id);
    el.classList.add('fade-out');
    el.classList.remove('fade-in', 'active');
    setTimeout(() => {
        el.classList.remove('fade-out');
        el.style.display = 'none';
        el.style.opacity = 0;
    }, 400);
}

function renderSlots() {
    const slots = document.getElementById('char-slots');
    slots.innerHTML = '';
    for (let i = 0; i < 5; i++) {
        const char = characters[i];
        let slot = document.createElement('div');
        slot.className = 'char-slot' + (i === selectedSlot ? ' selected' : '');
        slot.onclick = () => selectSlot(i);

        if (char) {
            slot.innerHTML = `
                <div class="avatar">${char.avatar || '👤'}</div>
                <div class="info">
                    <strong>${char.name}</strong><br>
                    <span class="stats">${char.job || 'Unemployed'} | $${char.money || 0} | XP: ${char.xp || 0}</span>
                </div>
            `;
        } else {
            slot.innerHTML = `
                <div class="avatar">+</div>
                <div class="info">
                    <strong>Create New Character</strong>
                </div>
            `;
        }
        slots.appendChild(slot);
    }
    updateActions();
    updatePreview();
}

function selectSlot(i) {
    selectedSlot = i;
    renderSlots();
    // Send message to Lua to update camera/model
    fetch(`https://${GetParentResourceName()}/selectSlot`, {
        method: 'POST',
        body: JSON.stringify({ slot: i })
    });
}

function updateActions() {
    const hasChar = !!characters[selectedSlot];
    document.getElementById('play-btn').disabled = false;
    document.getElementById('delete-btn').disabled = !hasChar;
}

function updatePreview() {
    const char = characters[selectedSlot];
    const info = document.getElementById('char-preview-info');
    if (char) {
        info.innerHTML = `
            <strong>${char.name}</strong><br>
            Job: ${char.job || 'Unemployed'}<br>
            Crew: ${char.crew || 'None'}<br>
            Cash: $${char.money || 0}<br>
            XP: ${char.xp || 0}<br>
            Races Won: ${char.races_won || 0}
        `;
    } else {
        info.innerHTML = `<em>Select a slot to view details.</em>`;
    }
}

function setGender(gender) {
    selectedGender = gender;
    document.querySelectorAll('.gender-btn').forEach(btn => {
        btn.classList.toggle('selected', btn.dataset.gender === gender);
    });
    // Notify Lua to update the ped model
    fetch(`https://${GetParentResourceName()}/setGender`, {
        method: 'POST',
        body: JSON.stringify({ gender })
    });
}

function updateCreateButton() {
    const firstname = document.getElementById('char-firstname').value.trim();
    const lastname = document.getElementById('char-lastname').value.trim();
    document.getElementById('create-char-btn').disabled = !(firstname && lastname && selectedGender);
}

// Listen for NUI messages from Lua
window.addEventListener('message', function(event) {
    if (event.data && event.data.action === "showCharacters") {
        characters = event.data.characters || [];
        selectedSlot = 0;
        renderSlots();
        showOverlay('char-select-overlay');
    }
    if (event.data && event.data.action === "hideMenu") {
        hideOverlay('char-select-overlay');
    }
});

// Button actions
document.addEventListener('DOMContentLoaded', () => {

    document.getElementById('play-btn').onclick = () => {
        const char = characters[selectedSlot];
        if (char) {
            fetch(`https://${GetParentResourceName()}/playCharacter`, {
                method: 'POST',
                body: JSON.stringify({ slot: selectedSlot })
            });
        } else {
            hideOverlay('char-select-overlay');
            setTimeout(() => showOverlay('char-create-overlay'), 200);
            fetch(`https://${GetParentResourceName()}/startCharCreate`, {
                method: 'POST',
                body: JSON.stringify({ slot: selectedSlot })
            });
        }
    };

    document.getElementById('delete-btn').onclick = () => {
        if (confirm("Are you sure you want to delete this character?")) {
            fetch(`https://${GetParentResourceName()}/deleteCharacter`, {
                method: 'POST',
                body: JSON.stringify({ slot: selectedSlot })
            });
        }
    };

    document.getElementById('cancel-create-btn').onclick = () => {
        hideOverlay('char-create-overlay');
        setTimeout(() => {
            showOverlay('char-select-overlay');
        }, 400);
        fetch(`https://${GetParentResourceName()}/cancelCharCreate`, {
            method: 'POST'
        });
    };

    document.getElementById('char-create-form').onsubmit = (e) => {
        e.preventDefault();
        const firstname = document.getElementById('char-firstname').value.trim();
        const lastname = document.getElementById('char-lastname').value.trim();
        if (!firstname || !lastname) return;
        fetch(`https://${GetParentResourceName()}/submitCharCreate`, {
            method: 'POST',
            body: JSON.stringify({
                firstname,
                lastname,
                gender: selectedGender
            })
        });
        hideOverlay('char-create-overlay');
    };

    document.getElementById('char-firstname').addEventListener('input', updateCreateButton);
    document.getElementById('char-lastname').addEventListener('input', updateCreateButton);
    document.querySelectorAll('.gender-btn').forEach(btn => {
        btn.onclick = () => setGender(btn.dataset.gender);
    });
    updateCreateButton();
});