let%html photoswipe () = {|
  <div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">
  <!-- Root element of PhotoSwipe. Must have class pswp. -->

      <!-- Background of PhotoSwipe.
           It's a separate element as animating opacity is faster than rgba(). -->
      <div class="pswp__bg"></div>

      <!-- Slides wrapper with overflow:hidden. -->
      <div class="pswp__scroll-wrap">

          <!-- Container that holds slides.
              PhotoSwipe keeps only 3 of them in the DOM to save memory.
              Don't modify these 3 pswp__item elements, data is added later on. -->
          <div class="pswp__container">
              <div class="pswp__item"></div>
              <div class="pswp__item"></div>
              <div class="pswp__item"></div>
          </div>

          <!-- Default (PhotoSwipeUI_Default) interface on top of sliding area. Can be changed. -->
          <div class="pswp__ui pswp__ui--hidden">

              <div class="pswp__top-bar">

                  <!--  Controls are self-explanatory. Order can be changed. -->

                  <div class="pswp__counter"></div>

                  <button class="pswp__button pswp__button--close" title="Close (Esc)"></button>

                  <button class="pswp__button pswp__button--share" title="Share"></button>

                  <button class="pswp__button pswp__button--fs" title="Toggle fullscreen"></button>

                  <button class="pswp__button pswp__button--zoom" title="Zoom in/out"></button>

                  <!-- Preloader demo https://codepen.io/dimsemenov/pen/yyBWoR -->
                  <!-- element will get class pswp__preloader-\-active when preloader is running -->
                  <div class="pswp__preloader">
                      <div class="pswp__preloader__icn">
                        <div class="pswp__preloader__cut">
                          <div class="pswp__preloader__donut"></div>
                        </div>
                      </div>
                  </div>
              </div>

              <div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
                  <div class="pswp__share-tooltip"></div>
              </div>

              <button class="pswp__button pswp__button--arrow--left" title="Previous (arrow left)">
              </button>

              <button class="pswp__button pswp__button--arrow--right" title="Next (arrow right)">
              </button>

              <div class="pswp__caption">
                  <div class="pswp__caption__center"></div>
              </div>

          </div>

      </div>

  </div>
|}

let photoswipe_headers () =
  Html.[
    css_link ~uri:(Skeleton.Static.css_uri ["photoswipe.css"]) ();
    css_link ~uri:(Skeleton.Static.uri ["default-skin"; "default-skin.css"]) ();
    Skeleton.Static.js_script ["photoswipe.js"] ();
    Skeleton.Static.js_script [""] ();
  ]

let galerie_page () =
  let _ = [%client (
    let%lwt () = Lwt_js_events.domContentLoaded () in
    Photoswipe.init ();
    Lwt.return ()
    : unit Lwt.t
  )] in
  let open Html in
  Template.make_page
    ~title:"Galerie"
    ~other_head:(photoswipe_headers ())
    [
      h1 [txt "Galerie"];
      h2 [txt "Archives"];
      img ~src:(Html.uri_of_string (const "https://placekitten.com/600/400")) ~alt:"" ();
      photoswipe ();
      (* Foundation.responsive_embed @@ imgur (); *)
      (* div_classes ["grid-x"; "align-center"] [
       *   div_classes ["cell"; "large-8"; "medium-10"; "small-12"] [
       *     Foundation.accordion
       *       ~multi_expand:true
       *       ~allow_all_closed:true
       *       ~deep_link:true
       *       [
       *         "Archives", [Foundation.responsive_embed @@ archive_album ()];
       *         "Séjour en Égypte", [Google.YouTube.embed ~width:560 ~height:315 "twRjR6MsqEQ"];
       *       ] ();
       *   ];
       * ]; *)
      (* Flickr.client_code_script ();
       * imgur_script (); *)
    ]
