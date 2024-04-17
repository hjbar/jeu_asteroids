open Tsdl
open Tsdl_mixer

type audio_kind =
  | Laser
  | Explosion
  | Bonus
  | Defeat

let audio_table = Hashtbl.create 8

let init l =
  match Sdl.init Sdl.Init.audio with
  | Error (`Msg e) ->
    Sdl.log "Init error: %s" e;
    exit 1
  | Ok () -> begin
    match Mixer.open_audio 44100 Mixer.default_format 2 1024 with
    | Error (`Msg e) ->
      Sdl.log "Open_audio error: %s" e;
      exit 1
    | Ok () ->
      ignore @@ Mixer.allocate_channels 3;
      let load (k, s) =
        let audio =
          match Mixer.load_wav s with
          | Error (`Msg e) ->
            Sdl.log "Load_audio error: %s" e;
            exit 1
          | Ok v -> v
        in
        Hashtbl.replace audio_table k audio
      in
      List.iter load l;
    end

let play k =
  let chunk = Hashtbl.find audio_table k in
  match Mixer.play_channel (-1) chunk 0 with
  | Error (`Msg e) -> Sdl.log "Play_channel error: %s" e; exit 1
  | Ok v -> ()
