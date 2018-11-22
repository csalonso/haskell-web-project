{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Piloto where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

getPilotoR :: Handler Html
getPilotoR = do 
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/piloto.lucius")
        $(whamletFile "templates/piloto.hamlet")
    