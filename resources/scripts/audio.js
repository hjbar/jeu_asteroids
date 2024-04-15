var laser_audio = new Audio();
var explosion_audio = new Audio();
var bonus_audio = new Audio();
var defeat_audio = new Audio();

function init(laser_src, explosion_src, bonus_src, defeat_src) {
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

    laser_audio.src = laser_src;
    explosion_audio.src = explosion_src;
    bonus_audio.src = bonus_src;
    defeat_audio.src = defeat_src;

    console.log(laser_audio.src);
    console.log(explosion_audio.src);
    console.log(bonus_audio.src);
    console.log(defeat_audio.src);
}

function play(name, id) {
    var s;
    console.log(id);
    switch (id) {
        case 0: s = "laser_button"; break;
        case 1: s = "explosion_button"; break;
        case 2: s = "bonus_button"; break;
        case 3: s = "defeat_button"; break;
    }
    var btn = document.getElementById(s);
    btn.click();
}
