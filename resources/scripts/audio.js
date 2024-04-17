var laser_audio = new Audio();
var explosion_audio = new Audio();
var bonus_audio = new Audio();
var defeat_audio = new Audio();
var damage_audio = new Audio();
var bomb_audio = new Audio();

function init(laser_src, explosion_src, bonus_src, defeat_src, damage_src, bomb_src) {
    var laser_btn = document.getElementById("laser_button");
    laser_btn.addEventListener("click", _ => {
        if (!laser_audio.paused) { laser_audio.pause(); laser_audio.currentTime = 0 }
        laser_audio.play()
    }, { once: false });

    var explosion_btn = document.getElementById("explosion_button");
    explosion_btn.addEventListener("click", _ => {
        if (!explosion_audio.paused) { explosion_audio.pause(); explosion_audio.currentTime = 0 }
        explosion_audio.play()
    }, { once: false });

    var bonus_btn = document.getElementById("bonus_button");
    bonus_btn.addEventListener("click", _ => {
        if (!bonus_audio.paused) { bonus_audio.pause(); bonus_audio.currentTime = 0 }
        bonus_audio.play()
    }, { once: false });

    var defeat_btn = document.getElementById("defeat_button");
    defeat_btn.addEventListener("click", _ => {
        if (!defeat_audio.paused) { defeat_audio.pause(); defeat_audio.currentTime = 0 }
        defeat_audio.play()
    }, { once: false });

    var damage_btn = document.getElementById("damage_button");
    damage_btn.addEventListener("click", _ => {
        if (!damage_audio.paused) { damage_audio.pause(); damage_audio.currentTime = 0 }
        damage_audio.play()
    }, { once: false });

    var bomb_btn = document.getElementById("bomb_button");
    bomb_btn.addEventListener("click", _ => {
        if (!bomb_audio.paused) { bomb_audio.pause(); bomb_audio.currentTime = 0 }
        bomb_audio.play()
    }, { once: false });

    laser_audio.src = laser_src;
    explosion_audio.src = explosion_src;
    bonus_audio.src = bonus_src;
    defeat_audio.src = defeat_src;
    damage_audio.src = damage_src;
    bomb_audio.src = bomb_src;
}

function play(id) {
    var s;
    switch (id) {
        case 0: s = "laser_button"; break;
        case 1: s = "explosion_button"; break;
        case 2: s = "bonus_button"; break;
        case 3: s = "defeat_button"; break;
        case 4: s = "damage_button"; break;
        case 5: s = "bomb_button"; break;
    }
    var btn = document.getElementById(s);
    btn.click();
}
