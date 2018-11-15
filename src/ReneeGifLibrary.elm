module ReneeGifLibrary exposing (library)

import LibraryData


library : List LibraryData.Gif
library =
    [ { url = "https://media.giphy.com/media/piKaO6KOsO7ArDuiul/giphy.gif"
      , keywords = [ "cello", "music", "mellow" ]

      -- ip = "Mr. Rogers"
      }
    , { url = "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif"
      , keywords = [ "funny", "klingon", "laughing" ]

      -- ip = "TNG"  -- descended from Star Trek superclass
      }
    ]
