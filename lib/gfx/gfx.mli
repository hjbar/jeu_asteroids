(** All errors are reported with this exception. The payload is an informative
    message. *)
exception GfxError of string

(** type of windows.
    - JavaScript : represents the initial canvas element
    - SDL : represent a top-level window *)
type window

(** type of surfaces. These are rectangles of pixels onto which one can draw,
    blit, etc… *)
type surface

(** type of rendering context. *)
type context

(** type of colors *)
type color

(** font objects *)
type font

(** remote resource *)
type 'a resource

(** tests if the resource is available. *)
val resource_ready : 'a resource -> bool

(** returns the content of the resource. raises Failure with an appropriate
    message if the resource is not ready. *)
val get_resource : 'a resource -> 'a

(** [backend] if the name of the backend. It can be ["sdl"] or ["js"]. *)
val backend : string

val create : string -> window

(** [create s] returns a window and a rendering surface from the string [s]. The
    string has the form ["name:WxH:flags"]. For the JavaScript backend, [name]
    is element id of the canvas representing the window. In the SDL backend,
    [name] is the window title. *)

(** returns the dimensions in screen pixels of the window *)
val get_window_size : window -> int * int

(** sets the dimensions in pixels of the window *)
val set_window_size : window -> int -> int -> unit

(** [get_context w] : returns the context of window [w] *)
val get_context : window -> context

(** [set_context_logical_size ctx w h] sets the logical size of the context. The
    initial values are the same dimentions as the window. The logical size
    reflects the range of pixels that are shown in the context. For instance, If
    the logical size is 100x100 but the window size is 400x400, each logical
    pixel will be automatically zoomed and displayed as a 4x4 pixel in the
    window. *)
val set_context_logical_size : context -> int -> int -> unit

(** [get_context_logical_size ctx w h] returns the logical size of the context. *)
val get_context_logical_size : context -> int * int

(** [set_transform ctx angle hflip vflip] stores a transformation in the
    context. The transformation is a rotation of [angle] (in radians), on
    horizontal reflection (if [hflip] is [true]) and a vertical reflection (if
    [vflip]) is [true]). *)
val set_transform : context -> float -> bool -> bool -> unit

(** [get_transform ctx] returns the transformation currently associated with the
    context. *)
val get_transform : context -> float * bool * bool

val reset_transform : context -> unit
(* [reset_transform ctx] is an alias for [set_transform ctx 0.0 false false]. *)

(** [get_surface w] : returns the underlying surface of window [w] *)
val get_surface : window -> surface

(** [create_surface ctx w h] : creates a surface for the given rendering
    context. *)
val create_surface : context -> int -> int -> surface

(** returns the dimensions of a surface *)
val surface_size : surface -> int * int

(** [blit dst src x y] copies surface [src] on surface [dst] at point [(x,y)] *)
val blit : context -> surface -> surface -> int -> int -> unit

(** [blit_scale ctx dst src dx dy dw dh] copies surface [src] on surface [dst]
    at point [(dx,dy)] scaling it to [dw] width and [dh] height *)
val blit_scale :
  context -> surface -> surface -> int -> int -> int -> int -> unit

(** [blit_full ctx dst src sx sy sw sh dx dy dw dh] copies the surface extracted
    from [src] at point [(sx, sy)] with dimensions [(sw, sh)] on surface [dst]
    at point [(dx,dy)] scaling it to [dw] width and [dh] height *)
val blit_full :
     context
  -> surface
  -> surface
  -> int
  -> int
  -> int
  -> int
  -> int
  -> int
  -> int
  -> int
  -> unit

(** [color r g b a] returns a color built from components red green blue and
    alpha. all values must be integers between 0 and 255 inclusive. *)
val color : int -> int -> int -> int -> color

val set_color : context -> color -> unit

(** [fill_rect ctx dst x y w h c] draws and fills a rectangle on surface surface
    [dst] at coordinates [(x, y)] and with dimensions [w * h]. The rectangle is
    filled with color c *)
val fill_rect : context -> surface -> int -> int -> int -> int -> unit

(** [load_image ctx path] loads an image whose content is given by an
    implementation dependent string (filename, url, … ). Common image types are
    supported (PNG, JPEG, …). The returned resource may not be extracted used
    until [resource_ready] returns [true]. *)
val load_image : context -> string -> surface resource

(** [load_font fn extra size] loads font [fn] at size [size] given in points.
    The [extra] parameters allows to pass implementation dependent options.
    - JavaScript : [fn] is a font name. If it does not exist, it is silently
      replaced by a close matching font or default font by the browser.
    - SDL : [fn] must be a path to the [.ttf] file containing the font. *)
val load_font : string -> string -> int -> font

(** [render_text ctx txt f c] returns a surface containing the text [txt]
    rendered using font [f] with color [c]. *)
val render_text : context -> string -> font -> surface

(** [mesure_text  txt f] returns the size (width height) of the surface that
    [render_text] would return, without creating it. *)
val measure_text : string -> font -> int * int

type event =
  | NoEvent  (** no event *)
  | KeyUp of string  (** Key with a given name was released *)
  | KeyDown of string  (** Key with a given name was pressed *)
  | MouseMove of int * int
    (* button pressed bitmask and x/y coordinates, relative to the window. *)
  | MouseButton of int * bool * int * int
(* button button number, pressed/released, x/y relative to the window. *)

(** The type of input events. The string describing keyboard events is
    implementation defined. *)

(** [poll_event ()] returns the next event in the event queue *)
val poll_event : unit -> event

(** [main_loop f] calls a [f] repeteadly but no faster than 60 times/seconds.
    The callback [f] is given a float representing the elapsed time in
    milliseconds since the begining of the program. It should return true to
    continue being called or false to stop the [main_loop] *)
val main_loop : (float -> bool) -> unit

(** [commit ctx] : renders the rendering context on to its underlying window.
    This should be the last graphical operation of the current frame. *)
val commit : context -> unit

(** [load_file path] creates a resource that, when ready, resolves to the
    content of the file denoted by path.
    - SDL : path is the path of a file.
    - JS : path is a URL to be loaded with *)
val load_file : string -> string resource

(** [open_formatter src] opens a formatter for debugging purposes.
    - SDL : [src] is the file path.
    - JavaScript : [src] must be the ID of an element whose innerHTML is
      appended to. It is recommended to style the element with the CSS property
      white-space:pre to preserve white spaces. *)
val open_formatter : string -> Format.formatter

(** [set_debug_formatter fmt] sets the current formatter. The default value is
    Format.stderr.
    - SDL : writing to Format.stderr writes to the standard error as usual.
    - JavaScript : writing to Format.stderr writes to the JavaScript console. in
      error mode (console.error). *)
val set_debug_formatter : Format.formatter -> unit

(** [debug f a b c d...] prints to the currently configured debug formatter. The
    first argument [f] is a format string (see {!Format.printf}). *)
val debug : ('a, Format.formatter, unit) format -> 'a
