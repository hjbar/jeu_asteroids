open Tsdl
open Tsdl_mixer

type audio_kind =
| Laser
| Explosion
| Bonus

let audio_table = Hashtbl.create 8

let init l =
  
  match Sdl.init Sdl.Init.audio with
  | Error (`Msg e) -> Sdl.log "Init error: %s" e; exit 1
  | Ok () ->
    match Mixer.open_audio 44100 Mixer.default_format 2 1024 with
    | Error (`Msg e) -> Sdl.log "Open_audio error: %s" e; exit 1
    | Ok () ->
      let load (k, s) =
        let audio = match Mixer.load_wav s with
        | Error (`Msg e) -> Sdl.log "Load_audio error: %s" e; exit 1
        | Ok v -> v
        in Hashtbl.replace audio_table k audio
      in
      List.iter load l;
      false
  
let play k =
      let chunk = Hashtbl.find audio_table k in
      Mixer.play_channel Mixer.channel_post chunk (-1) |> ignore;
      Mixer.close_audio ()
